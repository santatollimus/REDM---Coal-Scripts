Config.Weapons = {
    [`WEAPON_REPEATER_CARBINE`] = {
        -- Maxed out accuracy & much tighter grouping
        accuracy = 1.0,   -- was 0.95
        damage   = 55.0,
        recoil   = 0.5,   -- was 1.0  (less kick)
        spread   = 0.3,   -- was 1.0  (much tighter)
        range    = 15,    -- small bump in effective range
    },

    [`WEAPON_REVOLVER_CATTLEMAN`] = {
        accuracy = 1.0,   -- was 0.95
        damage   = 40.0,
        recoil   = 0.7,   -- was 1.2
        spread   = 0.4,   -- was 1.3
        range    = 15,
    }
}

-- OPTIONAL: This mostly affects AI; you can keep, tweak, or remove it.
-- 100 is basically aimbot-level for peds.
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        -- Try 75–85 if you want high but not perfect AI accuracy:
        SetPedAccuracy(ped, 85)
        Wait(0)
    end
end)
