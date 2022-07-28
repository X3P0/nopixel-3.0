fx_version "cerulean"

games { "gta5" }

description "Nikez Rollercoaster"

version "0.1.0"

server_script "@np-lib/server/sv_rpc.js"
client_script "@np-lib/client/cl_rpc.js"

server_scripts {
    "server/*.js",
}

client_scripts {
    "client/*.js",
}
