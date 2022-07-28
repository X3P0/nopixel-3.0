fx_version 'cerulean'
games { 'rdr3', 'gta5' }

description 'Play sounds'
version '1.1.5'

-- Client Scripts
client_script {
    '@np-errorlog/client/cl_errorlog.lua',
    '@np-lib/client/cl_infinity.lua',
    'client/main.lua'
}

shared_script 'shared/sh_*.*'

-- Server Scripts
server_script {
    '@np-lib/server/sv_infinity.lua',
    'server/main.lua'
}

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files({
    'client/html/index.html',
    'client/html/sounds/*.ogg',
    'client/html/sounds/Spells/*.ogg'
})
