-- anti_lockon.lua (RedM-safe anti lock-on)

-- Thread 1: constantly force Free Aim targeting mode (no assisted modes)
CreateThread(function()
    while true do
        if SetPlayerTargetingMode then
            -- 3 = Free Aim
            SetPlayerTargetingMode(3)
        end

        -- No need to spam every frame
        Wait(2000)
    end
end)

-- Thread 2: disable soft + hard lock-on
CreateThread(function()
    while true do
        local ped    = PlayerPedId and PlayerPedId() or 0
        local player = PlayerId    and PlayerId()    or -1

        if ped ~= 0 then
            -- This config flag disables soft controller lock-on
            -- (same trick used in FiveM anti-aimassist resources)
            if SetPedConfigFlag then
                SetPedConfigFlag(ped, 43, true) -- Disable lock-on
            end
        end

        if player ~= -1 then
            -- Fully disable lock-on
            if SetPlayerLockon then
                SetPlayerLockon(player, false)
            end

            -- And kill any auto-aim range
            if SetPlayerLockonRangeOverride then
                SetPlayerLockonRangeOverride(player, 0.0)
            end
        end

        Wait(500)
    end
end)
