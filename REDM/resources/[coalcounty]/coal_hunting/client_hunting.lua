-- client_hunting.lua
local Core = exports.vorp_core:GetCore()

local lastCarriedEntity = 0

local function isPedCarryingSomething(ped)
    -- IS_PED_CARRYING_SOMETHING
    return Citizen.InvokeNative(0xA911EE21EDF69DAF, ped)
end

local function getCarriedEntity(ped)
    -- GET_CARRIED_ATTACHED_ENTITY
    return Citizen.InvokeNative(0xD806CD2A4F2C2996, ped, 0)
end

CreateThread(function()
    while true do
        Wait(250)

        local ped = PlayerPedId()

        if isPedCarryingSomething(ped) then
            local ent = getCarriedEntity(ped)

 if ent ~= 0 and DoesEntityExist(ent) then
    if ent ~= lastCarriedEntity then
        lastCarriedEntity = ent

        -- Only try to get a net ID if the entity is actually networked
        local isNetworked = Citizen.InvokeNative(0xC7827959479DCC78, ent) -- NETWORK_GET_ENTITY_IS_NETWORKED
        local netId = nil
        if isNetworked then
            netId = NetworkGetNetworkIdFromEntity(ent)
        else
            netId = 0 -- we'll use the fallback delete path for non-networked entities
        end

        local model = GetEntityModel(ent)

        TriggerEvent("coal_debugger:log",
            ("[coal_hunting] Now carrying entity: netId=%s, model=%s")
            :format(tostring(netId), tostring(model))
        )

        TriggerServerEvent("coal_hunting:PickedUpCarcass", netId, model)
    end
end

        else
            -- Not carrying anything
            lastCarriedEntity = 0
        end
    end
end)

RegisterNetEvent("coal_hunting:ClientDeleteCarcass")
AddEventHandler("coal_hunting:ClientDeleteCarcass", function(netId)
    -- capture current values so they don't change while we wait
    local thisNetId = netId
    local thisLast  = lastCarriedEntity

    CreateThread(function()
        -- wait 1 seconds before removing the body
        Wait(1000)

        local ent = nil

        -- Try via network ID first (works for networked props/peds)
        if thisNetId and thisNetId ~= 0 then
            ent = NetworkGetEntityFromNetworkId(thisNetId)
            if ent ~= 0 and DoesEntityExist(ent) then
                TriggerEvent("coal_debugger:log",
                    ("[coal_hunting] Deleting carcass by netId=%s (entity=%s)")
                    :format(tostring(thisNetId), tostring(ent))
                )

                DeleteEntity(ent)
                return
            end
        end

        -- Fallback: use the last carried entity (covers local-only entities like some animals)
        if thisLast ~= 0 and DoesEntityExist(thisLast) then
            TriggerEvent("coal_debugger:log",
                ("[coal_hunting] Deleting carcass using fallback lastCarriedEntity=%s")
                :format(tostring(thisLast))
            )

            DeleteEntity(thisLast)

            -- only clear if it's still the current one
            if thisLast == lastCarriedEntity then
                lastCarriedEntity = 0
            end
        else
            TriggerEvent("coal_debugger:log",
                ("[coal_hunting] Failed to delete carcass (netId=%s) – no valid entity found")
                :format(tostring(thisNetId))
            )
        end
    end)
end)

