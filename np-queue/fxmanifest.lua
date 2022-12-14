fx_version "cerulean"

games { "gta5" }

description "NoPixel Boilerplate"

version "0.1.0"

server_script "@npx/server/lib.js"
server_script "@np-lib/server/sv_rpc.js"
server_script "@np-lib/server/sv_asyncExports.js"
server_script "@np-db/server/lib.js"

client_script "@np-lib/client/cl_rpc.lua"

server_scripts {
    "server/*.js",
}

client_scripts {
    "client/*.lua",
}
