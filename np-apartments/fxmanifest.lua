fx_version 'cerulean'
games { 'gta5' }

dependencies {
  "PolyZone"
}

client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  "@PolyZone/client.lua",
  "@PolyZone/BoxZone.lua",
  "@PolyZone/CircleZone.lua",
  "@PolyZone/ComboZone.lua",
  "@PolyZone/EntityZone.lua",
  '@np-errorlog/client/cl_errorlog.lua',
  '@np-lib/client/cl_rpc.lua',
  "@np-locales/client/lib.lua",
  "config.lua",
  'client/cl_*.lua'
}


shared_script 'shared/sh_*.*'

server_scripts {
    '@np-lib/server/sv_rpc.lua',
    '@np-lib/server/sv_sql.lua',
    'server/sv_*.lua',
}

export "getModule"