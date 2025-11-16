local Core          = exports.vorp_core:GetCore()
local vorpInventory = exports.vorp_inventory:vorp_inventoryApi()

-- Look up reward table for a given model hash
local function getRewardsForModel(model)
    if not HuntingConfig or not HuntingConfig.rewards then
        return nil
    end
    return HuntingConfig.rewards[model]
end

-- "raw_venison" -> "Raw venison"
local function prettifyItemName(item)
    item = tostring(item or "")
    item = item:gsub("_", " ")
    return item:gsub("^%l", string.upper)
end

-- Give items and build a human-readable summary string
local function giveMeatToPlayer(source, rewards)
    local parts = {}

    for _, r in ipairs(rewards) do
        if r.item and r.count and r.count > 0 then
            vorpInventory.addItem(source, r.item, r.count)

            local label = r.display or prettifyItemName(r.item)
            table.insert(parts, string.format("%dx %s", r.count, label))
        end
    end

    if #parts > 0 then
        return table.concat(parts, ", ")
    end

    return nil
end

-- Fired from client when a carcass is picked up
RegisterNetEvent("coal_hunting:PickedUpCarcass")
AddEventHandler("coal_hunting:PickedUpCarcass", function(netId, model)
    local src = source

    model = tonumber(model) or model
    if not model then
        print("[coal_hunting] PickedUpCarcass: missing model from client")
        return
    end

    -- Look up rewards
    local rewards = getRewardsForModel(model)
    if not rewards then
        print(("[coal_hunting] No rewards configured for model hash: %s"):format(tostring(model)))
        TriggerClientEvent("vorp:TipRight", src,
            "No hunting rewards configured for this carcass (model " .. tostring(model) .. ")", 4000)
        return
    end

    -- Tell all clients to delete the carcass entity by netId
    if netId then
        TriggerClientEvent("coal_hunting:ClientDeleteCarcass", -1, netId)
    end

    -- OLD Give meat & build summary
   -- local summary = giveMeatToPlayer(src, rewards)
   -- local msg = summary and ("You collected: " .. summary)
                     --  or  "You collected nothing from the carcass."
--					  or ""
    -- Give items & build summary text
    local summary = giveMeatToPlayer(src, rewards)

    local msg
    if summary then
        msg = ("[coal_hunting] Gave to %s from model %s: %s")
              :format(tostring(src), tostring(model), tostring(summary))
        TriggerClientEvent("vorp:TipRight", src, "You collected: " .. summary, 4000)
    else
        msg = ("[coal_hunting] Gave nothing to %s from model %s")
              :format(tostring(src), tostring(model))
        TriggerClientEvent("vorp:TipRight", src, "You collected nothing from the carcass.", 4000)
    end

    -- F8 server log
    print(msg)

    -- Send to Coal Debugger on that player’s client
    TriggerClientEvent("coal_debugger:rewardLog", src, msg)
end)

    TriggerClientEvent("vorp:TipRight", src, msg, 4000)
end)
