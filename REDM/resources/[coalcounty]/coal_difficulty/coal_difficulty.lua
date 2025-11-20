-- coal_difficulty.lua

Config = Config or {}

Config.Difficulty = {
    -- How tanky ALL non-player peds should be compared to their normal health.
    -- 1.0 = default, 2.0 = twice as hard to kill, 3.0 = three times, etc.
    healthMultiplier = 2.5
}

CreateThread(function()
    while true do
        local handle, ped = FindFirstPed()
        local success = false

        if handle ~= -1 then
            repeat
                if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                    -- This will catch ALL NPCs: animals + human peds

                    local baseMaxHealth = 250 -- fallback
                    if GetEntityMaxHealth then
                        baseMaxHealth = GetEntityMaxHealth(ped)
                    end

                    local desiredMax = math.floor(baseMaxHealth * Config.Difficulty.healthMultiplier)

                    -- Only buff if we haven't already set it this high
                    if GetEntityMaxHealth(ped) < desiredMax then
                        SetEntityMaxHealth(ped, desiredMax)
                        SetEntityHealth(ped, desiredMax)
                    end
                end

                success, ped = FindNextPed(handle)
            until not success

            EndFindPed(handle)
        end

        -- Don’t spam too hard; this is enough to keep newly spawned peds updated
        Wait(5000)
    end
end)
