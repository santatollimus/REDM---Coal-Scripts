-- coal_shottracker.lua
-- Tracks shots and prints HIT / MISS in chat

local INPUT_ATTACK = 0x07CE1E61 -- LMB / RT

-- Convert camera rotation to a direction vector
local function RotationToDirection(rot)
    local radX = math.rad(rot.x)
    local radY = math.rad(rot.y)
    local radZ = math.rad(rot.z)

    local cosX = math.cos(radX)
    local sinX = math.sin(radX)
    local cosZ = math.cos(radZ)
    local sinZ = math.sin(radZ)

    -- RDR2 forward vector from camera
    return vector3(-sinZ * cosX, cosZ * cosX, sinX)
end

local function sendChat(msg)
    TriggerEvent("chat:addMessage", {
        color = {255, 255, 255},
        args = {"ShotTracker", msg}
    })
end

CreateThread(function()
    local wasShooting = false

    while true do
        Wait(0)

        local ped = PlayerPedId()
        if ped == 0 or IsEntityDead(ped) then
            wasShooting = false
            goto continue
        end

        local isShooting = IsPedShooting(ped) or IsControlJustPressed(0, INPUT_ATTACK)

        -- Only react on the moment a shot starts
        if isShooting and not wasShooting then
            wasShooting = true

            -- Use camera as origin & direction
            local camCoord = GetGameplayCamCoord()
            local camRot   = GetGameplayCamRot(2)
            local dir      = RotationToDirection(camRot)

            local distance = 500.0
            local dest     = camCoord + dir * distance

            -- Raycast along the bullet path
            local ray = StartShapeTestRay(
                camCoord.x, camCoord.y, camCoord.z,
                dest.x, dest.y, dest.z,
                -1,  -- hit everything
                ped, -- ignore shooter
                0
            )

            local _, hit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)

            if hit == 1 and entityHit ~= 0 and DoesEntityExist(entityHit) then
                if IsEntityAPed(entityHit) then
                    sendChat("HIT: ped/animal")
                else
                    sendChat("HIT: object / world")
                end
            else
                sendChat("MISS")
            end
        elseif not isShooting then
            wasShooting = false
        end

        ::continue::
    end
end)
