fx_version 'cerulean'
games { 'gta5' }

--[[ dependencies {
  "np-polyzone",
  "np-lib",
  "np-ui"
} ]]--

client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  '@np-lib/client/cl_rpc.lua',
  'client/cl_*.lua',
  "@PolyZone/client.lua",
  "@PolyZone/ComboZone.lua",
}

shared_script {
  '@np-lib/shared/sh_util.lua',
  'shared/sh_*.*',
}

server_scripts {
  '@np-lib/server/sv_asyncExports.lua',
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_sql.lua',
  'server/sv_*.lua',
  'server/sv_*.js',
}
