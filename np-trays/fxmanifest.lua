fx_version "cerulean"

games { "gta5" }

description "NoPixel Boilerplate"

version "0.1.0"

client_script "@np-lib/client/cl_ui.js"
client_script "@np-locales/client/lib.js"
client_script "@np-lib/client/cl_rpc.js"

server_scripts {
    "build/server/*.js",
}

client_scripts {
    "build/client/*.js",
}
