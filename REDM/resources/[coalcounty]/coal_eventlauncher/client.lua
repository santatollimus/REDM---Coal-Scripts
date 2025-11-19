-- coal_eventlauncher client

CreateThread(function()
    if not Config or not Config.Enabled then
        print("[coal_eventlauncher] disabled in config")
        return
    end

    Wait(1000)
    print(("[%s] loaded with %d actions")
        :format(Config.Tag, #Config.Actions))

    while true do
        Wait(0)

        for _, action in ipairs(Config.Actions) do
            local key  = action.key or Config.DefaultKey
            local name = action.name or "Unnamed"

            if IsControlJustPressed(0, key) then
                print(("[%s] key=0x%X -> %s")
                    :format(Config.Tag, key, name))

                if type(action.onPress) == "function" then
                    -- Custom function action
                    local ok, err = pcall(action.onPress)
                    if not ok then
                        print(("[%s] ERROR in action '%s': %s")
                            :format(Config.Tag, name, tostring(err)))
                    end

                elseif action.hash then
                    -- Simple "call this native" action
                    local hash = action.hash
                    print(("[%s] firing 0x%X (%s)")
                        :format(Config.Tag, hash, name))

                    if action.args then
                        Citizen.InvokeNative(hash, table.unpack(action.args))
                    else
                        Citizen.InvokeNative(hash)
                    end

                else
                    print(("[%s] action '%s' has neither onPress nor hash")
                        :format(Config.Tag, name))
                end
            end
        end
    end
end)
