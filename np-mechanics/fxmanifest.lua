fx_version "cerulean"

games { "gta5" }

description "NoPixel Mechanics Script"

version "0.1.0"

server_script "@npx/server/lib.js"
server_script "@np-lib/server/sv_asyncExports.js"

client_script "@npx/client/lib.js"
client_script "@np-locales/client/lib.js"

server_scripts {
    "build/server/*.js",
}

client_scripts {
    "build/client/*.js",
}
