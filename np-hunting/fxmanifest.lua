fx_version "cerulean"

games { "gta5" }

description "NoPixel Hunting Script"

version "0.1.0"

server_script "@np-db/server/lib.js"
server_script "@np-lib/server/sv_sql.js"
server_script "@np-lib/server/sv_rpc.js"
server_script "@np-lib/server/sv_npx.js"
server_script "@np-lib/server/sv_asyncExports.js"

client_script "@np-lib/client/cl_ui.js"
client_script "@np-lib/client/cl_rpc.js"

shared_script "@np-lib/shared/sh_cacheable.js"

server_scripts {
    "build/server/*.js",
}

client_scripts {
    "build/client/*.js",
}