fx_version "cerulean"

games { "gta5" }

description "NoPixel Boilerplate"

version "0.1.0"

server_script "@npx/server/lib.js"

client_script "@np-lib/client/cl_ui.js"
client_script "@npx/client/lib.js"
client_script "@np-locales/client/lib.js"

server_scripts {
    "server/*.js",
}

client_scripts {
    "client/*.js",
}
