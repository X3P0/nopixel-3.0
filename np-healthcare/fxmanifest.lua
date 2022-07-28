fx_version 'cerulean'

games {
  'gta5',
  'rdr3'
}

client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  '@np-locales/client/lib.lua',
  '@np-lib/client/cl_rpc.lua',
  '@np-lib/client/cl_animTask.lua',
  'client/cl_*.lua'
}

shared_scripts {
  '@np-lib/shared/sh_util.lua',
  "shared/sh_*.lua"
}

server_scripts {
  '@np-lib/server/sv_asyncExports.lua',
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_sql.lua',
  'server/sv_*.lua'
}