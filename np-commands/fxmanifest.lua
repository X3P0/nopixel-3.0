fx_version 'cerulean'
games { 'gta5' }

client_scripts {
    'cl_*.lua',
}

server_script '@np-lib/server/sv_asyncExports.lua'

server_scripts {
    '@np-lib/server/sv_infinity.lua',
    'sv_*.lua',
}
