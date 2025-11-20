-- coal_shottracker.lua
-- Minimal HIT / MISS tracker for RedM
-- Shows status in the top-right of the screen

local INPUT_ATTACK = 0x07CE1E61 -- LMB / RT

-- How long the status text stays on screen (ms)
local STATUS_DURATION = 1500

-- State for HUD text
local currentStatus = nil
local statusExpireTime = 0

-- Text color (default white)
local statusColor = { r = 255, g = 255, b = 255, a = 255 }

----------------------------------------------------
-- UTILS
----------------------------------------------------

local function RotationToDirection(rot)
    local radX = math.rad(rot.x)
    local radY = math.rad(rot.y)
    local radZ = math.rad(rot.z)

    local cosX = math.cos(radX)
    local sinX = math.sin(radX)
    local cosZ = math.cos(radZ)
    local sinZ = math.sin(radZ)

    return {
        x = -sinZ * cosX,
        y =  cosZ * cosX,
        z =  sinX
    }
end

----------------------------------------------------
-- STATUS SETTER (with color)
----------------------------------------------------

local function setStatus(msg, r, g, b, a)
    currentStatus = msg
    statusExpireTime = GetGameTimer() + STATUS_DURATION
    statusColor.r = r or 255
    statusColor.g = g or 255
    statusColor.b = b or 255
    statusColor.a = a or 255
end

----------------------------------------------------
-- DRAW TEXT (RedM-safe)
----------------------------------------------------

local function DrawStatusText()
    if not currentStatus then return end

    local now = GetGameTimer()
    if now > statusExpireTime then
        currentStatus = nil
        return
    end

    local str = CreateVarString(10, "LITERAL_STRING", currentStatus)

    SetTextScale(0.3, 0.3)
    SetTextColor(statusColor.r, statusColor.g, statusColor.b, statusColor.a)
    SetTextCentre(false)   -- left aligned

    -- top-right
    DisplayText(str, 0.495, 0.485)
end

----------------------------------------------------
-- THREAD 1: SHOT DETECTION
----------------------------------------------------

CreateThread(function()
    print("[coal_shottracker] loaded")

    local lastShotTime = 0
    local debounceMs = 150

    while true do
        Wait(0)

        local ped = PlayerPedId()
        if ped == 0 or IsEntityDead(ped) then goto continue end

        if IsPedShooting(ped) then
            local now = GetGameTimer()

            if now - lastShotTime > debounceMs then
                lastShotTime = now

                local camCoord = GetGameplayCamCoord()
                local camRot = GetGameplayCamRot(2)
                local dir = RotationToDirection(camRot)

                local dist = 500.0
                local destX = camCoord.x + dir.x * dist
                local destY = camCoord.y + dir.y * dist
                local destZ = camCoord.z + dir.z * dist

                local ray = StartShapeTestRay(
                    camCoord.x, camCoord.y, camCoord.z,
                    destX, destY, destZ,
                    -1,      -- hit everything
                    ped,     -- ignore shooter
                    0
                )

                local _, hit, _, _, entityHit = GetShapeTestResult(ray)

                if hit == 1 and entityHit ~= 0 and DoesEntityExist(entityHit) then
                    if IsEntityAPed(entityHit) then
                        -- RED
                        setStatus("HIT", 255, 0, 0, 255)
                    else
                        -- ORANGE
                        setStatus("...", 255, 165, 0, 255)
                    end
                else
                    -- WHITE
                    setStatus("MISS", 255, 255, 255, 255)
                end
            end
        end

        ::continue::
    end
end)

----------------------------------------------------
-- THREAD 2: DRAW
----------------------------------------------------

CreateThread(function()
    while true do
        Wait(0)
        DrawStatusText()
    end
end)
