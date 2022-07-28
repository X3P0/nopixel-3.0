fx_version 'cerulean'
games { 'gta5' }

client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  '@np-errorlog/client/cl_errorlog.lua',
  '@np-lib/client/cl_rpc.lua',
  'client/cl_*.lua',
}

shared_scripts {
  '@np-lib/shared/sh_util.lua',
  'shared/sh_*.*'
}

server_scripts {
  'config.lua',
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_sql.lua',
  'server/sv_*.lua',
}

if GetConvar("sv_environment", "prod") == "debug" then
  client_script "tests/cl_*.lua"
end
