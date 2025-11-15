-- How fast horse stamina drains while sprinting
-- 1.0 = vanilla
-- 0.5 = half as fast
-- 0.25 = quarter as fast (almost infinite sprint)
local staminaMultiplier = 0.25

-- PED::_SET_STAMINA_DEPLETION_MULTIPLIER
local SET_STAMINA_DEPLETION_MULTIPLIER = 0xEF5A3D2285D8924B

CreateThread(function()
    while true do
        -- We don't need to spam every frame; twice a second is fine
        Wait(500)

        local ped = PlayerPedId()

        if IsPedOnMount(ped) then
            local horse = GetMount(ped)

            if horse ~= 0 then
                -- Apply our custom drain multiplier to the mount
                Citizen.InvokeNative(SET_STAMINA_DEPLETION_MULTIPLIER, horse, staminaMultiplier)
            end
        end
    end
end)
