fx_version 'cerulean'
games { 'gta5' }

--[[ dependencies {
  "np-lib",
  "np-ui"
} ]]--

shared_script "@np-lib/shared/sh_set.lua"

client_script "@np-lib/client/cl_ui.lua"
client_script "@np-errorlog/client/cl_errorlog.lua"

client_scripts {
  '@np-lib/client/cl_rpc.lua',
  'shared/*.lua',
  'client/cl_*.lua'
}

server_scripts {
  '@np-lib/server/sv_sql.lua',
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_asyncExports.lua',
  'shared/*.lua',
  'server/sv_*.lua'
}
