fx_version "cerulean"

games { "gta5" }

description "NoPixel Boilerplate"

version "0.1.0"

server_script "@npx/server/lib.js"
server_script "@np-lib/server/sv_asyncExports.js"

client_script "@npx/client/lib.js"
client_script "@np-lib/client/cl_ui.js"
client_script "@np-locales/client/lib.js"

server_scripts {
    "server/sv_*.js",
}

client_scripts {
    "client/cl_*.js",
}

ui_page "nui/index.html"

files {
  "nui/index.html",
  "nui/js/script.js",
  "nui/css/style.css",
  "nui/img/bg.png",
  "nui/headbagon.ogg",
  "nui/headbagoff.ogg",
}