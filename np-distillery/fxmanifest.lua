fx_version 'cerulean'
games { 'gta5' }

--[[ dependencies {
    "PolyZone"
} ]]--

client_scripts {
    'cl_*.lua',
    '@PolyZone/client.lua'
}

shared_script 'sh_*.lua'

server_script 'sv_*.lua'