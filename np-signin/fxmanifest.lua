fx_version 'cerulean'
games { 'gta5' }

client_script "@np-errorlog/client/cl_errorlog.lua"
client_script "@np-locales/client/lib.lua"
client_script "@np-lib/client/cl_ui.lua"
client_script "@np-lib/client/cl_rpc.lua"
client_script "config.lua"

client_scripts {
  "client/cl_*.lua"
}
server_scripts {
  "server/sv_*.lua"
}
