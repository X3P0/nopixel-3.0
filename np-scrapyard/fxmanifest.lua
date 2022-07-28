fx_version "cerulean"

games { "gta5" }

description "NoPixel Scrapyard"

version "0.1.0"

server_script "@np-lib/server/sv_sql.js"
server_script "@np-lib/server/sv_npx.js"
server_script "@np-lib/server/sv_asyncExports.js"
server_script "@np-inventory/shared_list.js"

client_script "@np-lib/shared/sh_cacheable.js"
client_script "@np-lib/client/cl_ui.js"
client_script "@np-lib/client/cl_rpc.js"
client_script "@np-locales/client/lib.js"

server_scripts {
    "server/*.js",
}

client_scripts {
    "client/*.js",
}
