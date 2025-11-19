-- coal_spawn.lua
-- Dev helper: /spawn <hashOrName> [outfitIndex]

-- simple model loader
local DECOR_OUTFIT = "coal_outfitPreset"

-- run once (e.g. at top of file / on resource start)
DecorRegister(DECOR_OUTFIT, 3) -- 3 = int
local function loadModel(model)
    if not IsModelValid(model) then
        print(("[coal_spawn] Invalid model hash: %s"):format(tostring(model)))
        return false
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
        local timeout = GetGameTimer() + 5000

        while not HasModelLoaded(model) do
            Wait(0)
            if GetGameTimer() > timeout then
                print("[coal_spawn] Failed to load model in time")
                return false
            end
        end
    end

    return true
end

-- RedM CreatePed_2 wrapper
local function CreatePed_2(modelHash, x, y, z, heading, isNetwork, thisScriptCheck, p7, p8)
    return Citizen.InvokeNative(
        0xD49F9B0955C367DE, -- CREATE_PED
        modelHash, x, y, z, heading, isNetwork, thisScriptCheck, p7, p8
    )
end

-- give the ped a default/random outfit (fix invisible animal issue)
local function SetPedDefaultOutfit(ped)
    if ped ~= 0 and DoesEntityExist(ped) then
        -- 0x283978A15512B2FE: _SET_RANDOM_OUTFIT_VARIATION / default outfit
        Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
    end
end

-- apply a specific outfit preset index (for legendaries, etc.)
local function SetPedOutfitPreset(ped, presetIndex)
    if ped ~= 0 and DoesEntityExist(ped) and presetIndex ~= nil then
        -- 0x77FF8D35EEC6BBC4: _SET_PED_OUTFIT_PRESET(ped, presetIndex, p2)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, ped, presetIndex, 0)
    end
end

RegisterCommand("spawn", function(source, args)
    if #args < 1 then
        print("[coal_spawn] Usage: /spawn <hash or model name> [count 1-10] [outfitIndex]")
        return
    end

    local input = args[1]

    -- optional count arg (2nd param)
    local count = 1
    if args[2] ~= nil then
        local parsed = tonumber(args[2])
        if parsed then
            count = parsed
        end
    end

    -- clamp count 1–10
    if count < 1 then count = 1 end
    if count > 10 then count = 10 end

    -- optional outfit index (3rd param)
    local outfitIndex = nil
    if args[3] ~= nil then
        local parsedOutfit = tonumber(args[3])
        if not parsedOutfit then
            print("[coal_spawn] outfitIndex must be a number if provided")
            return
        end
        outfitIndex = parsedOutfit
    end

    -- allow either numeric hash or model name
    local model = tonumber(input)
    if not model then
        model = GetHashKey(input)
    end

    if not IsModelValid(model) then
        print(("[coal_spawn] Model is not valid: %s"):format(tostring(input)))
        return
    end

    if not loadModel(model) then
        return
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    local spawnDist = 3.0

    for i = 1, count do
        -- spread them around the player in a circle
        local angleOffset = (360.0 / count) * (i - 1)
        local rad = math.rad(heading + angleOffset)

        local sx = coords.x + math.cos(rad) * spawnDist
        local sy = coords.y + math.sin(rad) * spawnDist
        local sz = coords.z

        local spawned = CreatePed_2(model, sx, sy, sz, heading, true, true, true, true)

 if spawned == 0 or not DoesEntityExist(spawned) then
            print("[coal_spawn] Failed to create ped "..i)
        else
            if outfitIndex ~= nil then
                SetPedOutfitPreset(spawned, outfitIndex)
                DecorSetInt(spawned, DECOR_OUTFIT, outfitIndex)
            else
                SetPedDefaultOutfit(spawned)
            end

            SetEntityAsMissionEntity(spawned, true, false)

            print(("[coal_spawn] Spawned ped %s at %.2f, %.2f, %.2f (model=%s, %d/%d, outfit=%s)")
                :format(tostring(spawned), sx, sy, sz, tostring(model), i, count, tostring(outfitIndex)))
        end
    end
end, false)

