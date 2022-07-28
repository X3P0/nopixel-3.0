fx_version 'cerulean'
games { 'gta5' }

--[[ dependencies {
  "np-lib",
  "np-ui"
} ]]--

client_script "@np-lib/client/cl_ui.lua"
client_script "@np-errorlog/client/cl_errorlog.lua"

client_scripts {
  'client/cl_*.lua'
}

server_scripts {
  'server/sv_*.lua'
}