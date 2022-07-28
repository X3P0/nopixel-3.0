fx_version 'cerulean'

games { 'gta5' }

client_script "@np-sync/client/lib.lua"
client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  'client/cl_*.lua',
}

server_script "@np-lib/server/sv_npx.js"
server_scripts {
  '@np-lib/server/sv_sql.js',
  'config.lua',
  'server/sv_*.lua',
  'server/sv_*.js',
  'build-server/sv_*.js',
}

