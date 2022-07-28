fx_version 'cerulean'
games { 'gta5' }

--[[ dependencies {
  "np-polyzone",
  "np-lib",
  "np-ui"
} ]]--

client_script "@np-sync/client/lib.lua"
client_script "@np-lib/client/cl_ui.lua"
client_script "@np-lib/client/cl_ui.js"

client_scripts {
  '@np-lib/client/cl_rpc.lua',
  '@np-lib/client/cl_rpc.js',
  'client/cl_*.lua',
  'client/cl_*.js',
  "@PolyZone/client.lua",
  "@PolyZone/ComboZone.lua",
}

shared_script {
  '@np-lib/shared/sh_util.lua',
  'shared/sh_*.*',
}

server_script "@np-lib/server/sv_npx.js"
server_scripts {
  '@np-lib/server/sv_asyncExports.lua',
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_rpc.js',
  '@np-lib/server/sv_sql.lua',
  '@np-lib/server/sv_sql.js',
  'server/sv_*.lua',
  'server/sv_*.js',
}
