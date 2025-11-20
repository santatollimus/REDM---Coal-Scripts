fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
games { 'rdr3' }
lua54 'yes'

description 'Coal Hunting – auto convert carcass to meat'
version '1.0.0'

-- Everything is in a single Lua file now
client_scripts {
    'coal_hunting.lua'
}

server_scripts {
    'coal_hunting.lua'
}
