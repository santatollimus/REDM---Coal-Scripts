-- custom_crosshair.lua
-- style orange (#FF6600)
local r, g, b = 255, 102, 0

-- tightened crosshair
local armSize   = 0.0022   -- was 0.0018
local thickness = 0.0006   -- was 0.0005
local offset    = 0.0019   -- tiny bump so the arms don’t overlap
local rowGap    = 0.0015   -- vertical distance between rows

local function isAiming()
    return IsAimCamActive() or IsControlPressed(0, 0xF84FA74F)
end

-- Only treat it as "drawn" if the ped actually has a firearm out
local function hasWeaponDrawn()
    if not PlayerPedId then return false end

    local ped = PlayerPedId()
    if ped == 0 then return false end

    -- Preferred: use IsPedArmed (works on RedM)
    if IsPedArmed then
        -- 4 = firearms only (no fists/animals etc.)
        local armed = IsPedArmed(ped, 4)
        if armed == 1 or armed == true then
            return true
        else
            return false
        end
    end

    -- Fallback: current weapon check if available
    if GetCurrentPedWeapon then
        local gotWeapon, weaponHash = GetCurrentPedWeapon(ped, true)
        if not gotWeapon then return false end

        -- treat UNARMED / 0 as "no weapon"
        if weaponHash == `WEAPON_UNARMED` or weaponHash == 0 then
            return false
        end

        return true
    end

    -- If we really can't tell, err on the side of NO crosshair
    return false
end

local function shouldShowCrosshair()
    return isAiming() and hasWeaponDrawn()
end

CreateThread(function()
    while true do
        if shouldShowCrosshair() then
            -- Hide Rockstar's default reticle if this native exists
            if HideHudComponentThisFrame then
                HideHudComponentThisFrame(14)
            end

            local cx, cy = 0.5, 0.5

-- middle row (what you have now, centered vertically)
DrawRect(cx - offset, cy, armSize, thickness, r, g, b, 255) -- middle-left
DrawRect(cx + offset, cy, armSize, thickness, r, g, b, 255) -- middle-right

-- top row (new, same width, a bit above)
DrawRect(cx - offset, cy - rowGap, armSize, thickness, r, g, b, 255) -- top-left
DrawRect(cx + offset, cy - rowGap, armSize, thickness, r, g, b, 255) -- top-right

        end

        Wait(0)
    end
end)
