fx_version "cerulean"

games { "gta5" }

name "np-gballs"
description "Usable golf clubs."
author "Loqrin for NoPixel | nopixel.net"
url "https://www.nopixel.net/"

version "0.1.0"

--server_script "@np-lib/server/sv_sql.js"
--server_script "@np-lib/server/sv_rpc.js"
--server_script "@np-lib/server/sv_npx.js"
--server_script "@np-lib/server/sv_asyncExports.js"

--client_script "@np-lib/client/cl_ui.js"
--client_script "@np-lib/client/cl_rpc.js"

server_scripts {
    "server/*.js",
}

client_scripts {
    "client/weirdShit.lua",
    "client/*.js",
}