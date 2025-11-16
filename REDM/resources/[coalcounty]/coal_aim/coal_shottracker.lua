-- coal_shottracker.lua
-- Minimal HIT / MISS tracker with debounce so 1 shot = 1 message
-- Now shows status in the top-right of the screen instead of chat

local INPUT_ATTACK = 0x07CE1E61 -- LMB / RT

-- How long the status text stays on screen (ms)
local STATUS_DURATION = 1500

-- State for HUD text
local currentStatus = nil
local statusExpireTime = 0

local function RotationToDirection(rot)
    -- rot is a vector3 of degrees
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

-- Instead of sending to chat, update the HUD status
local function setStatus(msg)
    currentStatus = msg
    statusExpireTime = GetGameTimer() + STATUS_DURATION
end

-- Draw text in the top-right corner
local function DrawStatusText()
    if not currentStatus then
        return
    end

    local now = GetGameTimer()
    if now > statusExpireTime then
        currentStatus = nil
        return
    end

    -- Basic text setup
    SetTextFont(4)          -- font index (try 0–4 if you want to experiment)
    SetTextScale(0.5, 0.5)  -- size
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    SetTextDropshadow(1, 0, 0, 0, 255)

    -- No fancy justification/wrap, just left-aligned text near top-right
    SetTextCentre(false)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(currentStatus)

    -- x, y screen coords: 0.0 = left/top, 1.0 = right/bottom
    -- 0.90, 0.05 = near top-right but safely on-screen
    EndTextCommandDisplayText(0.90, 0.05)
end


-- Thread 1: detect shots and set status
CreateThread(function()
    print("[coal_shottracker] loaded")

    local lastShotTime = 0
    local debounceMs   = 150  -- minimum time between shots we count

    while true do
        Wait(0)

        local ped = PlayerPedId()
        if ped == 0 or IsEntityDead(ped) then
            goto continue
        end

        -- Fires when a bullet actually leaves the gun
        if IsPedShooting(ped) then
            local now = GetGameTimer()

            -- Only process if enough time has passed since last shot
            if now - lastShotTime > debounceMs then
                lastShotTime = now
                print("[coal_shottracker] shot detected")

                local camCoord = GetGameplayCamCoord()
                local camRot   = GetGameplayCamRot(2)
                local dir      = RotationToDirection(camRot)

                local distance = 500.0
                local destX = camCoord.x + dir.x * distance
                local destY = camCoord.y + dir.y * distance
                local destZ = camCoord.z + dir.z * distance

                local ray = StartShapeTestRay(
                    camCoord.x, camCoord.y, camCoord.z,
                    destX,      destY,      destZ,
                    -1,         -- hit everything
                    ped,        -- ignore shooter
                    0
                )

                local _, hit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)

                if hit == 1 and entityHit ~= 0 and DoesEntityExist(entityHit) then
                    if IsEntityAPed(entityHit) then
                        setStatus("HIT: ped/animal")
                        print("[coal_shottracker] HIT ped/animal:", entityHit)
                    else
                        setStatus("HIT: object / world")
                        print("[coal_shottracker] HIT object/world:", entityHit)
                    end
                else
                    setStatus("MISS")
                    print("[coal_shottracker] MISS")
                end
            end
        end

        ::continue::
    end
end)

-- Thread 2: draw the HUD text every frame
CreateThread(function()
    while true do
        Wait(0)
        DrawStatusText()
    end
end)
