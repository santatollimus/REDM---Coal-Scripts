-- coal_aim.lua (debug version)
-- Just log when we detect right-click, and auto-draw weapon.

local INPUT_AIM = 0xF84FA74F -- Right mouse / LT

local function hasFirearmDrawn(ped)
    if not IsPedArmed then return false end
    local armed = IsPedArmed(ped, 4) -- 4 = firearms
    return armed == 1 or armed == true
end

local function drawBestWeapon(ped)
    if not GetBestPedWeapon or not SetCurrentPedWeapon then return end

    if GetCurrentPedWeapon then
        local hasWep, curWep = GetCurrentPedWeapon(ped, true)
        if hasWep and curWep ~= `WEAPON_UNARMED` and curWep ~= 0 then
            return
        end
    end

    local best = GetBestPedWeapon(ped, false, false)
    if best ~= 0 and best ~= `WEAPON_UNARMED` then
        SetCurrentPedWeapon(ped, best, true, 0, false, false)
    end
end

CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        if ped == 0 or IsEntityDead(ped) then
            goto continue
        end

        if IsControlJustPressed(0, INPUT_AIM) then
            print("[coal_aim] Right-click detected")

            if not hasFirearmDrawn(ped) then
                drawBestWeapon(ped)
                print("[coal_aim] Drew best firearm")
            else
                print("[coal_aim] Firearm already drawn")
            end
        end

        ::continue::
    end
end)
