fx_version "cerulean"

games { "gta5" }

description "NoPixel Object System"

version "0.1.0"

server_script "@npx/server/lib.js"
server_script "@np-db/server/lib.js"
server_script "@np-lib/server/sv_asyncExports.js"

client_script "@npx/client/lib.js"
client_script "@np-lib/client/cl_ui.js"

shared_script "@np-lib/shared/sh_cacheable.js"

server_scripts {
    "server/*.js",
}

client_scripts {
    "client/*.js",
}
