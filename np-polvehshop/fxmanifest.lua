fx_version 'cerulean'
games { 'gta5' }

--[[ dependencies {
  "np-polyzone",
  "np-lib",
  "np-ui"
} ]]--

shared_script "shared/zones.lua"

client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  '@np-lib/client/cl_rpc.lua',
  'client/cl_*.lua',
}

server_scripts {
  '@np-lib/server/sv_asyncExports.lua',
  '@np-lib/server/sv_rpc.lua',
  'server/sv_*.lua',
}
