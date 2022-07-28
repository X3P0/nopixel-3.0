fx_version "cerulean"
games {"gta5"}

ui_page "client/ui/html/index.html"

files {
  "client/ui/html/index.html", 
  "client/ui/html/js/ui.js", 
  "client/ui/html/css/menu.css", 
  "client/ui/html/imgs/logo.png",
}

shared_script "@np-lib/shared/sh_util.lua"

client_script "@npx/client/lib.js"
client_script "@np-sync/client/lib.lua"
client_script "@np-lib/client/cl_ui.lua"
client_script "@np-lib/client/cl_polyhooks.lua"
client_script "@PolyZone/client.lua"


server_script "@npx/server/lib.js"
server_script "@np-lib/server/sv_asyncExports.lua"

shared_script "_configs/cfg_general.lua"
shared_script "@npx/shared/lib.lua"

client_scripts {
  "client/cl_*.lua"
}

server_scripts {
  "server/sv_*.lua"
}

