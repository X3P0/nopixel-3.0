fx_version 'cerulean'
games { 'gta5' }

client_script "@npx/client/lib.js"
server_script "@npx/server/lib.js"
shared_script "@npx/shared/lib.lua"

client_script "@np-sync/client/lib.lua"
client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  'client/cl_*.lua',
  'client/cl_*.js',
}

server_scripts {
  '@np-lib/server/sv_asyncExports.lua',
  'server/sv_*.lua',
  'server/sv_*.js',
}
