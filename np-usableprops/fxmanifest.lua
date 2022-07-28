fx_version 'cerulean'
games {'gta5'}

client_script "@npx/client/lib.js"
server_script "@npx/server/lib.js"
shared_script "@npx/shared/lib.lua"

client_script "@np-errorlog/client/cl_errorlog.lua"
client_script "@np-sync/client/lib.lua"

server_script "@np-lib/server/sv_asyncExports.lua"

shared_script "@np-lib/shared/sh_util.lua"

client_scripts {
  '@np-lib/client/cl_rpc.lua',
  'client/cl_*.lua'
}

server_scripts {
  '@np-lib/server/sv_sql.lua',
  '@np-lib/server/sv_rpc.lua',
  'server/sv_*.lua'
}
