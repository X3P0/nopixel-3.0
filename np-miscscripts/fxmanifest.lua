fx_version "cerulean"

game "gta5"

files {
    'dlc_nikez_misc/*.awc',
    'misc.dat54.rel'
}

client_script "@np-sync/client/lib.lua"
client_script "@np-lib/client/cl_ui.lua"
client_script "@npx/client/lib.js"
server_script "@npx/server/lib.js"
shared_script "@npx/shared/lib.lua"
client_script "@np-errorlog/client/cl_errorlog.lua"
server_script "@np-lib/server/sv_asyncExports.lua"


client_script {
    "client/cl_*.lua",
    "client/cl_*.js"
}

server_script {
    "server/sv_*.lua",
    "server/sv_*.js"
}

data_file 'AUDIO_WAVEPACK' 'dlc_nikez_misc'
data_file 'AUDIO_SOUNDDATA' 'misc.dat'
