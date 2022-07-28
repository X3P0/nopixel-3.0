fx_version 'cerulean'
games { 'rdr3', 'gta5' }

-- --[[ dependencies {
--   "np-lib",
--   "np-ui"
-- } ]]--

client_script "@npx/client/lib.js"
server_script "@npx/server/lib.js"
shared_script "@npx/shared/lib.lua"

client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  '@np-errorlog/client/cl_errorlog.lua',
  '@np-lib/client/cl_rpc.lua',
  'client/cl_*.lua',
}

shared_script {
  '@np-lib/shared/sh_util.lua',
  'shared/sh_*.*'
}

server_scripts {
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_sql.lua',
  '@np-lib/server/sv_asyncExports.lua',
  'config.lua',
  'server/sv_*.lua',
}

lua54 'yes'