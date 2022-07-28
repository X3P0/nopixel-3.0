fx_version "cerulean"

game "gta5"

shared_script {
    '@np-lib/shared/sh_util.lua',
}

client_scripts {
    "@np-lib/client/cl_rpc.lua",
    "@np-lib/client/cl_ui.lua",
    "@np-errorlog/client/cl_errorlog.lua",
}

server_scripts {
    "@np-lib/server/sv_asyncExports.lua",
    "@np-lib/server/sv_rpc.lua",
    "@np-lib/server/sv_sql.lua",
}

server_script "server/sv_main.lua"

client_script "client/cl_main.lua"
