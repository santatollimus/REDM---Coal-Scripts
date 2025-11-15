-- server.lua (e.g. coal_traps/server.lua)

local VORPInv = exports.vorp_inventory:vorp_inventoryApi()

CreateThread(function()
    -- Register "beartrap" as a usable item
    VORPInv.RegisterUsableItem("beartrap", function(data)
        local src = data.source

        -- Optional: consume 1 trap when used
        VORPInv.subItem(src, "beartrap", 1)   -- requires vorp_inventory API 

        -- Tell the client to place the trap
        TriggerClientEvent("coal_traps:placeBearTrap", src)
    end)
end)

-- =========================================
-- Trap tracking + baiting
-- =========================================

local Traps = {}

-- Called from client when a trap object is created
RegisterNetEvent("coal_traps:trapPlaced")
AddEventHandler("coal_traps:trapPlaced", function(netId)
    local src = source
    if not netId then return end

    Traps[netId] = {
        owner  = src,
        baited = false
    }

    print(("[coal_traps] Registered trap %s for player %s"):format(tostring(netId), tostring(src)))
end)

-- Player presses E near a trap to bait it
RegisterNetEvent("coal_traps:baitTrap")
AddEventHandler("coal_traps:baitTrap", function(netId)
    local src = source
    if not netId then return end

    local info = Traps[netId]
    if not info then
        print(("[coal_traps] Player %s tried to bait unknown trap %s"):format(src, tostring(netId)))
        return
    end

    -- Only the owner can bait their trap
    if info.owner ~= src then
        print(("[coal_traps] Player %s tried to bait trap %s they don't own"):format(src, tostring(netId)))
        return
    end

    if info.baited then
        TriggerClientEvent("vorp:TipRight", src, "This trap is already baited.", 3000)
        return
    end

    -- TODO later: check/remove bait item (like meat) if you want
    info.baited = true

    TriggerClientEvent("vorp:TipRight", src, "You bait the trap.", 3000)
    -- Tell the client to mark it as baited (so prompt stops)
    TriggerClientEvent("coal_traps:trapBaited", src, netId)

    print(("[coal_traps] Trap %s baited by player %s"):format(tostring(netId), tostring(src)))
end)
