fx_version 'cerulean'
games { 'gta5' }

dependencies {
  "mka-lasers"
}

client_script "@npx/client/lib.js"
server_script "@npx/server/lib.js"
shared_script '@npx/shared/lib.lua'

client_scripts {
  '@np-locales/client/lib.lua',
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
}

shared_script {
  '@np-lib/shared/sh_util.lua',
  '@np-lib/shared/sh_cacheable.lua',
  'shared/sh_*.*',
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
}
