fx_version "cerulean"
games {"gta5"}

client_script "@np-errorlog/client/cl_errorlog.lua"

client_script {
    "@np-lib/client/cl_rpc.lua",
    "@np-locales/client/lib.lua",
    "client/cl_main.lua"
}


server_scripts {
    "@np-lib/shared/sh_util.lua",
    "@np-lib/server/sv_rpc.lua",
    "@np-lib/server/sv_sql.lua",
    "server/sv_main.lua"
}