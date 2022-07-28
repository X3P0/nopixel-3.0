fx_version 'cerulean'
games { 'gta5' }

client_script "@np-lib/client/cl_ui.lua"

shared_script "@np-lib/shared/sh_cacheable.lua"

client_scripts {
  '@np-errorlog/client/cl_errorlog.lua',
  '@np-lib/client/cl_rpc.lua',
  '@np-lib/client/cl_animTask.lua',
  'client/cl_*.lua'
}

shared_scripts {
  '@np-lib/shared/sh_util.lua',
  'shared/sh_*.*'
}

server_scripts {
  'config.lua',
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_sql.lua',
  '@np-lib/server/sv_sql.js',
  'server/classes/*.lua',
  'server/sv_*.lua',
  'server/sv_*.js',
}


client_script "tests/cl_*.lua"
