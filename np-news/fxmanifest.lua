fx_version 'cerulean'
games { 'gta5' }

--[[ dependencies {
  "np-lib",
  "np-ui"
} ]]--

client_script "@np-lib/client/cl_ui.lua"
client_script "@np-errorlog/client/cl_errorlog.lua"

shared_scripts {
  '@np-lib/shared/sh_util.lua',
  'shared/sh_*.lua'
}


client_scripts {
  '@np-lib/client/cl_rpc.lua',
  'client/cl_*.lua',
}

server_scripts {
  '@np-lib/server/sv_rpc.lua',
  'server/sv_*.lua',
}