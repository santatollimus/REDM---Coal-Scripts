Config = {}

-- Master enable switch
Config.Enabled = true

-- Script event group to watch
-- 0 is the most common group for game/script events
Config.EventGroup = 0

-- Mode:
--   "all"       -> log everything (except Blacklist)
--   "blacklist" -> same as "all" (Blacklist is a deny-list)
--   "whitelist" -> log ONLY hashes in Whitelist
Config.Mode = "all"

-- If true, only print each unique hash once per session
Config.OnlyNew = true

-- Output formatting
Config.PrintHex = true   -- print as 0xDEADBEEF
Config.PrintDec = true   -- print as (3735928559)

-- Tag prefix in F8 so you can grep/filter easily
Config.Tag = "coal_eventlogger"

-- Hashes to NEVER print when Mode is "all" or "blacklist"
-- Fill these with noisy hashes once you discover them.
Config.Blacklist = {
    -- [0xDE1126F3] = true,
    -- [735942751]  = true,
}

-- Hashes to ONLY print when Mode == "whitelist"
Config.Whitelist = {
    -- [0x90F48BEB] = true,
    -- [402722103]  = true,
}
