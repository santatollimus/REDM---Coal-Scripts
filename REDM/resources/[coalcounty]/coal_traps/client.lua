-- client.lua - Coal County bear traps

local trapModel = GetHashKey("p_beartrap01x") -- use your actual trap model here

-- local table of traps for this client
local Traps = {}

local function loadModel(model)
    if not IsModelValid(model) then
        print("[coal_traps] Invalid trap model")
        return false
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
        local timeout = GetGameTimer() + 5000
        while not HasModelLoaded(model) do
            Wait(0)
            if GetGameTimer() > timeout then
                print("[coal_traps] Failed to load trap model in time")
                return false
            end
        end
    end

    return true
end

-- Simple 3D text helper
local function Draw3DText(text, x, y, z)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(x, y, z)
    if not onScreen then return end

    SetTextScale(0.3, 0.3)
    SetTextFontForCurrentCommand(0)
    SetTextCentre(1)
    SetTextColor(255, 255, 255, 215)

    local str = CreateVarString(10, "LITERAL_STRING", text)
    DisplayText(str, sx, sy)
end

-- Called when the server tells us to place a trap (from beartrap usable item)
RegisterNetEvent("coal_traps:placeBearTrap")
AddEventHandler("coal_traps:placeBearTrap", function()
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    if not loadModel(trapModel) then
        return
    end

    -- Slightly below feet so it sits on the ground
    local trap = CreateObject(trapModel, coords.x, coords.y, coords.z - 1.0, true, true, false)
    SetEntityHeading(trap, heading)
    PlaceObjectOnGroundProperly(trap)
    SetEntityAsMissionEntity(trap, true, false)

local netId = NetworkGetNetworkIdFromEntity(trap)
-- SetNetworkIdCanMigrate(netId, true)  -- not needed / not available on RedM

-- Save locally
table.insert(Traps, {
    entity = trap,
    netId  = netId,
    baited = false
})

    -- Register on server
    TriggerServerEvent("coal_traps:trapPlaced", netId)

    print(("[coal_traps] Placed trap entity %s (netId=%s)"):format(trap, netId))
end)

-- Mark a trap as baited when server confirms
RegisterNetEvent("coal_traps:trapBaited")
AddEventHandler("coal_traps:trapBaited", function(netId)
    for _, trap in ipairs(Traps) do
        if trap.netId == netId then
            trap.baited = true
            print("[coal_traps] Trap baited: " .. tostring(netId))
            break
        end
    end
end)

-- Proximity loop: show prompt + keypress to bait trap
CreateThread(function()
    while true do
        Wait(0)

        local ped    = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        for _, trap in ipairs(Traps) do
            if trap.entity and DoesEntityExist(trap.entity) and not trap.baited then
                local tCoords = GetEntityCoords(trap.entity)
                local dist = #(pCoords - tCoords)

                if dist < 1.5 then
-- Draw a small prompt above the trap
Draw3DText("Press [G] to bait trap", tCoords.x, tCoords.y, tCoords.z + 0.5)

-- G key = 0x760A9C6F
if IsControlJustReleased(0, 0x760A9C6F) then
    TriggerServerEvent("coal_traps:baitTrap", trap.netId)
end


                    break -- only handle one trap at a time
                end
            end
        end
    end
end)
