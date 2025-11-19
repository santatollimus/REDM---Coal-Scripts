Config = {}

-- Turn launcher on/off
Config.Enabled = true

-- Tag that appears in F8 logs
Config.Tag = "coal_eventlauncher"

-- Default key if an action doesn't specify one (G key in RDR2)
Config.DefaultKey = 0x760A9C6F

-- Actions:
-- Each entry can have:
--   name  = label shown in F8
--   key   = control code (optional, defaults to Config.DefaultKey)
--   hash  = the native / event hash to call
--   args  = optional args passed to Citizen.InvokeNative(hash, table.unpack(args))

Config.Actions = {
    -- EXAMPLE 1: fire a hash on G
    {
        name = "Fire 0xDE1126F3",
        key  = 0x760A9C6F,   -- G
        hash = 0x956C2A0E,
        -- args = { ... },   -- fill in if that native needs args
    },

    -- EXAMPLE 2: fire another hash on H
{
    name = "Fire 0xEED15F18",
    key  = 0x580C4473,   -- B key
    hash = 0x956C2A0E,
},

    -- Add as many as you want:
    -- {
    --     name = "My hash",
    --     key  = 0xXXXXXXXX,
    --     hash = 0xYYYYYYYY,
    --     args = { ... },
    -- },
}
