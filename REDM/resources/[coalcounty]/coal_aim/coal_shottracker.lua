-- coal_shottracker.lua
-- Minimal HIT / MISS tracker with debounce so 1 shot = 1 message

local INPUT_ATTACK = 0x07CE1E61 -- LMB / RT

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

local function sendChat(msg)
    TriggerEvent("chat:addMessage", {
        color = {255, 255, 255},
        args = {"ShotTracker", msg}
    })
end

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
                        sendChat("HIT: ped/animal")
                        print("[coal_shottracker] HIT ped/animal:", entityHit)
                    else
                        sendChat("HIT: object / world")
                        print("[coal_shottracker] HIT object/world:", entityHit)
                    end
                else
                    sendChat("MISS")
                    print("[coal_shottracker] MISS")
                end
            end
        end

        ::continue::
    end
end)
