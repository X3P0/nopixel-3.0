fx_version 'cerulean'

games { 'gta5' }

shared_script '@np-lib/shared/sh_cacheable.lua'

client_script "@np-sync/client/lib.lua"
client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  '@np-lib/client/cl_rpc.lua',
  'client/cl_*.lua',
  "@PolyZone/client.lua",
}

server_script "@np-lib/server/sv_npx.js"
server_scripts {
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_rpc.js',
  '@np-lib/server/sv_sql.lua',
  '@np-lib/server/sv_sql.js',
  "@np-lib/server/sv_asyncExports.lua",
  'config.lua',
  'server/sv_*.lua',
  'server/sv_*.js',
  'build-server/sv_*.js',
}

