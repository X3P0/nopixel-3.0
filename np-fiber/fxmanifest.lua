fx_version "cerulean"

games { "gta5" }

description "NoPixel Fiber"

version "0.1.0"

ui_page 'nui/index.html'

files {
    'nui/**/*',
}

server_script "@npx/server/lib.js"
server_script "@np-lib/server/sv_asyncExports.js"

client_script "@npx/client/lib.js"
client_script "@np-lib/client/cl_ui.js"

server_scripts {
    "server/sv_*.js",
}

client_scripts {
    "client/cl_*.js",
}
