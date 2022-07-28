fx_version 'cerulean'
games { 'gta5' }

dependencies {
  "mka-lasers"
}

client_scripts {
  '@np-errorlog/client/cl_errorlog.lua',
  '@np-sync/client/lib.lua',
  '@np-lib/client/cl_rpc.lua',
  '@np-lib/client/cl_ui.lua',
  '@np-lib/client/cl_animTask.lua',
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/ComboZone.lua',
  '@mka-lasers/client/client.lua',
  '@mka-grapple/client.lua',
  'client/cl_*.lua',
  'client/cl_*.js',
  'client/**/cl_*.lua',
  'client/**/cl_*.js',
}

shared_script {
  '@np-lib/shared/sh_util.lua',
  'shared/sh_*.*',
  'shared/**/sh_*.*',
}

server_scripts {
  'config.lua',
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_sql.lua',
  '@np-lib/server/sv_sql.js',
  '@np-lib/server/sv_asyncExports.js',
  '@np-lib/server/sv_asyncExports.lua',
  'server/sv_*.lua',
  'server/sv_*.js',
  'server/**/sv_*.lua',
  'server/**/sv_*.js',
}
