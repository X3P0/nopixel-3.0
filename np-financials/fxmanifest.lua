fx_version 'cerulean'
games { 'gta5' }

--[[ dependencies {
  "np-lib",
  "np-ui"
} ]]--

server_script "@npx/server/lib.js"
client_script "@npx/client/lib.js"
shared_script "@npx/shared/lib.lua"

client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  '@np-errorlog/client/cl_errorlog.lua',
  '@np-lib/client/cl_rpc.lua',
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/ComboZone.lua',
  'client/cl_*.lua',
}

shared_script {
  '@np-lib/shared/sh_util.lua',
  'shared/sh_*.*',
}

server_scripts {
  'config.lua',
  '@np-lib/server/sv_asyncExports.lua',
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_sql.lua',
  'server/sv_*.lua',
}