-- coal_eventlogger client

CreateThread(function()
    if not Config or not Config.Enabled then
        return
    end

    local group = Config.EventGroup or 0
    local seen  = {}  -- hashes we've already logged when OnlyNew = true

    Wait(1000)
    print(("[%s] started | group=%d | mode=%s | onlyNew=%s")
        :format(
            Config.Tag or "coal_eventlogger",
            group,
            tostring(Config.Mode),
            tostring(Config.OnlyNew)
        )
    )

    while true do
        Wait(0)

        local size = GetNumberOfEvents(group)
        if size <= 0 then
            goto continue
        end

        for index = 0, size - 1 do
            local event = GetEventAtIndex(group, index)

            if event ~= 0 then
                -- Only log each unique hash once if OnlyNew is enabled
                if Config.OnlyNew and seen[event] then
                    goto next_event
                end

                local mode = Config.Mode or "all"
                local logThis = false

                if mode == "whitelist" then
                    -- Only hashes explicitly in Whitelist
                    logThis = Config.Whitelist and Config.Whitelist[event] or false
                else
                    -- "all" and "blacklist" behave the same: log unless blacklisted
                    if Config.Blacklist and Config.Blacklist[event] then
                        logThis = false
                    else
                        logThis = true
                    end
                end

                if logThis then
                    seen[event] = true

                    local hexPart = ""
                    local decPart = ""

                    if Config.PrintHex ~= false then
                        hexPart = ("0x%X"):format(event)
                    end

                    if Config.PrintDec then
                        decPart = ("(%d)"):format(event)
                    end

                    local space = (hexPart ~= "" and decPart ~= "") and " " or ""
                    local tag = Config.Tag or "coal_eventlogger"

                    print(("[%s] EVENT[%d] = %s%s%s")
                        :format(tag, index, hexPart, space, decPart))
                end
            end

            ::next_event::
        end

        ::continue::
    end
end)
