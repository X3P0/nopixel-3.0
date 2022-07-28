fx_version "cerulean"

games { "gta5" }

description "nns_weather by nns - nopixel edition"

version "1.0.0"

server_script "@np-lib/server/sv_npx.js"
server_script "@np-lib/server/sv_rpc.js"
server_script "@np-lib/server/sv_asyncExports.js"

server_scripts {
    "server/*.js",
}

client_scripts {
    "client/*.js",
}
