-- coal_debugger.lua
-- Simple F8-only debugger:
--   - Logs last killed ped model hash
--   - Logs currently carried entity hash and net ID
--   - /lastkill prints the last kill hash again

local lastLoggedPed = nil
local seenDeadPeds = {}
local lastCarriedEntity = nil
----------------------------------------------------------------------
-- On-screen debug box (optional HUD output)
----------------------------------------------------------------------

local debugLines = {}
local debugTimer = 0
local debugDuration = 8000 -- ms visible

local function ShowDebugText(text)
    debugTimer = GetGameTimer() + debugDuration
    table.insert(debugLines, 1, text)

    -- keep only newest 5–6 lines
    if #debugLines > 6 then
        table.remove(debugLines)
    end
end

CreateThread(function()
    while true do
        Wait(0)

        if debugTimer > GetGameTimer() and #debugLines > 0 then
            -- top-left box
            local baseX, baseY = 0.013, 0.025
            local width = 0.40
            local heightPerLine = 0.022
            local totalHeight = (#debugLines * heightPerLine) + 0.010

            -- background
            DrawRect(
                baseX + width / 2,
                baseY + totalHeight / 2,
                width,
                totalHeight,
                0, 0, 0, 190
            )

            -- text
            for i, line in ipairs(debugLines) do
                SetTextScale(0.30, 0.30)
                SetTextColour(255, 255, 255, 255)
                SetTextCentre(false)
                SetTextFontForCurrentCommand(0)
                SetTextDropshadow(1, 0, 0, 0, 255)
                SetTextOutline()

                SetTextEntry("STRING")
                AddTextComponentString(line)
                DrawText(baseX + 0.006, baseY + (i - 1) * heightPerLine)
            end
        end
    end
end)

----------------------------------------------------------------------
-- Helper to log nicely to F8
----------------------------------------------------------------------

local function logKilledPed(ped)
    local model = GetEntityModel(ped)
    lastLoggedPed = model

    local msg = string.format("[coal_debugger] Last killed model hash: %s", tostring(model))
    print(msg)  -- shows in F8 console
end

local function logCarriedEntity(entity)
    local model = GetEntityModel(entity)

    local netId
    if NetworkGetEntityIsNetworked(entity) then
        netId = NetworkGetNetworkIdFromEntity(entity)
    else
        -- local-only entity, no network object
        netId = 0   -- or "local" if you prefer a label
    end

    local msg = string.format(
        "[coal_debugger] Now carrying entity: netId=%s, model=%s",
        tostring(netId),
        tostring(model)
    )
    print(msg) -- shows in F8 console
end


----------------------------------------------------------------------
-- Thread 1: watch for peds you kill
----------------------------------------------------------------------

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()

        if playerPed ~= 0 then
            local peds = GetGamePool("CPed")

            for _, ped in ipairs(peds) do
                if ped ~= playerPed and DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                    if IsEntityDead(ped) and not seenDeadPeds[ped] then
                        seenDeadPeds[ped] = true

                        local killer = GetPedSourceOfDeath(ped)
                        if killer == playerPed then
                            logKilledPed(ped)
                        end
                    end
                end
            end
        end

        Wait(500) -- twice per second
    end
end)

----------------------------------------------------------------------
-- Thread 2: watch what you're carrying (carcasses etc.)
----------------------------------------------------------------------

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()

        if playerPed ~= 0 then
            -- 0xD806CD2A4F2C2996 = GET_CARRIED_ATTACHED_ENTITY
            local carried = Citizen.InvokeNative(0xD806CD2A4F2C2996, playerPed, 0)

            if carried ~= 0 and DoesEntityExist(carried) and carried ~= lastCarriedEntity then
                lastCarriedEntity = carried
                logCarriedEntity(carried)
            end
        end

        Wait(500)
    end
end)

----------------------------------------------------------------------
-- Commands
----------------------------------------------------------------------

RegisterCommand("lastkill", function()
    if lastLoggedPed then
        local msg = string.format("[coal_debugger] Last killed model hash: %s", tostring(lastLoggedPed))
        print(msg)
    else
        print("[coal_debugger] No kills recorded yet this session.")
    end
end, false)
----------------------------------------------------------------------
----------------------------------------------------------------------
-- Generic log hook used by coal_hunting (and others)
----------------------------------------------------------------------

RegisterNetEvent("coal_debugger:log")
AddEventHandler("coal_debugger:log", function(msg)
    msg = tostring(msg or "")

    -- F8 console
    print(msg)

    -- Optional HUD box (top-left)
    ShowDebugText(msg)
end)
-----------------------------------------------------------------------
-- Debug: show hunting reward summary in F8 via coal_debugger
RegisterNetEvent("coal_debugger:RewardSummary", function(model, summary)
    -- local player’s server ID (for clarity in logs)
    local serverId = GetPlayerServerId(PlayerId())

    print(("[coal_debugger] Gave to %s from model %s: %s"):format(
        tostring(serverId),
        tostring(model),
        tostring(summary or "nil")
    ))
end)
-- =========================================================
-- Reward debug from coal_hunting
-- =========================================================
RegisterNetEvent("coal_debugger:rewardLog")
AddEventHandler("coal_debugger:rewardLog", function(msg)
    msg = tostring(msg or "")
    print("[coal_debugger] " .. msg)
end)

