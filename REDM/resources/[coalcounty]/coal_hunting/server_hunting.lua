-- server_hunting.lua - Coal County hunting rewards

local Core          = exports.vorp_core:GetCore()
local vorpInventory = exports.vorp_inventory:vorp_inventoryApi()

-- Look up rewards for a given model hash from HuntingConfig in coal_hunting.lua
local function getRewardsForModel(model)
    if not HuntingConfig or not HuntingConfig.rewards then
        return nil
    end
    return HuntingConfig.rewards[model]
end

local function prettifyItemName(item)
    item = tostring(item or "")
    item = item:gsub("_", " ")
    return item:gsub("^%l", string.upper)
end

-- Try to get the VORP label from the DB; fall back to prettified name
local function getItemLabel(itemName)
    itemName = tostring(itemName or "")

    -- 1) Newer vorp_inventory export: getServerItem
    local ok, data = pcall(function()
        if exports.vorp_inventory and exports.vorp_inventory.getServerItem then
            return exports.vorp_inventory:getServerItem(itemName)
        end
    end)

    if ok and data and data.label then
        return data.label
    end

    -- 2) Older API: vorpInventory.getDBItem, if present
    if vorpInventory and vorpInventory.getDBItem then
        local ok2, data2 = pcall(function()
            -- src isn't used for DB lookup, 0 is fine
            return vorpInventory.getDBItem(0, itemName)
        end)

        if ok2 and data2 and data2.label then
            return data2.label
        end
    end

    -- 3) Fallback: prettified item name
    return prettifyItemName(itemName)
end

-- Give items and build a readable summary string
local function giveMeatToPlayer(source, rewards)
    local parts = {}

    for _, r in ipairs(rewards) do
        if r.item and r.count and r.count > 0 then
            vorpInventory.addItem(source, r.item, r.count)

            local itemName = tostring(r.item)
            local label    = r.display or getItemLabel(itemName)
            table.insert(parts, string.format("%dx %s", r.count, label))
        end
    end

    if #parts > 0 then
        return table.concat(parts, ", ")
    end

    return nil
end


-- Fired from client when a carcass/pelt is picked up
RegisterNetEvent("coal_hunting:PickedUpCarcass")
AddEventHandler("coal_hunting:PickedUpCarcass", function(netId, model)
    local src = source
    model = tonumber(model) or model

    local rewards = getRewardsForModel(model)
    if not rewards then
        local msg = ("[coal_hunting] No rewards configured for model hash: %s")
            :format(tostring(model))
        print(msg)
        TriggerClientEvent("vorp:TipRight", src,
            "No hunting rewards configured for this carcass (model " .. tostring(model) .. ")",
            4000
        )
        TriggerClientEvent("coal_debugger:rewardLog", src, msg)
        return
    end

    -- delete request goes out immediately (client already waits 2s before actually deleting)
    if netId then
        TriggerClientEvent("coal_hunting:ClientDeleteCarcass", -1, netId)
    end

    -- now delay the reward / tip / debugger log by 2 seconds
    CreateThread(function()
        Wait(1000)

        local summary = giveMeatToPlayer(src, rewards)

        local msg
        if summary then
            msg = ("[coal_hunting] Gave to %s from model %s: %s")
                :format(tostring(src), tostring(model), tostring(summary))
            TriggerClientEvent("vorp:TipRight", src, "You collected: " .. summary, 4000)
        else
            msg = ("[coal_hunting] Gave nothing to %s from model %s")
                :format(tostring(src), tostring(model))
            TriggerClientEvent("vorp:TipRight", src,
                "", 4000)
        end

        print(msg)
        TriggerClientEvent("coal_debugger:rewardLog", src, msg)
    end)
end)
