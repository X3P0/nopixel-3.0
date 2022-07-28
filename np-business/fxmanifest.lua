fx_version "cerulean"
games { "gta5" }

lua54 'yes'

client_script "@npx/client/lib.js"
server_script "@npx/server/lib.js"
shared_script "@npx/shared/lib.lua"

client_script "@np-lib/client/cl_ui.lua"
client_scripts {
    "@np-errorlog/client/cl_errorlog.lua",
    '@np-sync/client/lib.lua',
    "@np-lib/client/cl_rpc.lua",
    "@np-locales/client/lib.lua",
    '@mka-lasers/client/client.lua',
    "client/cl_*.lua",
    "business/**/cl_*.lua",
}

shared_script {
    "@np-lib/shared/sh_util.lua",
    "shared/sh_*.*",
    "business/**/sh_*.lua",
}

server_scripts {
    "config.lua",
    "@np-lib/server/sv_asyncExports.lua",
    "@np-lib/server/sv_rpc.lua",
    "@np-lib/server/sv_sql.lua",
    "server/sv_*.lua",
    "business/**/sv_*.lua",
}

