fx_version "cerulean"

game { "gta5" }

shared_scripts {
    "shared/config.lua"
}

client_scripts {
    "@np-lib/client/cl_ui.lua",
    "@np-locales/client/lib.lua",
    "@np-lib/client/cl_rpc.lua",
    "client/cl_utils.lua",
    "client/cl_main.lua",
    "client/cl_spawn.lua"
}

server_scripts {
    "@np-lib/server/sv_sql.lua",
    "@np-lib/shared/sh_util.lua",
    "@np-lib/server/sv_rpc.lua",
    "@np-lib/server/sv_asyncExports.lua",
    "server/sv_utils.lua",
    "server/sv_main.lua"
}