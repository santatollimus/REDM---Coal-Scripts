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

                    local netId = NetworkGetNetworkIdFromEntity(ent)
                    local model = GetEntityModel(ent)

                    -- Debug: you can comment this out later
                    TriggerEvent("coal_debugger:log",
                        ("[coal_hunting] Now carrying entity: netId=%s, model=%s")
                        :format(tostring(netId), tostring(model))
                    )

                    -- Tell server to process rewards + deletion
                    TriggerServerEvent("coal_hunting:PickedUpCarcass", netId, model)
                end
            end
        else
            -- Not carrying anything
            lastCarriedEntity = 0
        end
    end
end)

-- Client-side delete if server asks (safety / desync fix)
RegisterNetEvent("coal_hunting:ClientDeleteCarcass", function(netId)
    if not netId then return end

    local ent = NetworkGetEntityFromNetworkId(netId)
    if ent ~= 0 and DoesEntityExist(ent) then
        DeleteEntity(ent)
    end
end)
