fx_version "cerulean"

games { "gta5" }

description "Nopixel Laptop Script"

version "1.0.0"

client_script "@np-lib/client/cl_ui.js"
client_script "@np-lib/client/cl_rpc.js"

server_scripts {
    "build/server/*.js",
}

client_scripts {
    "build/client/*.js",
}
