fx_version "cerulean"

games { "gta5" }

description "NoPixel Bullet Club"

version "0.1.0"

server_script "@npx/server/lib.js"
server_script "@np-lib/server/sv_asyncExports.js"

client_script "@npx/client/lib.js"
client_script "@np-lib/client/cl_ui.js"
client_script "@np-locales/client/lib.js"

server_scripts {
    "build/server/sv_*.js",
}

client_scripts {
    "build/client/cl_*.js",
}
