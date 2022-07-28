fx_version "cerulean"
games { "gta5" }

client_script "@np-sync/client/lib.lua"
client_script "@np-lib/client/cl_ui.lua"
client_script "@PolyZone/client.lua"
client_script "@np-lib/client/cl_polyhooks.lua"
client_script "@npx/client/lib.js"

server_script "@npx/server/lib.js"
server_script "@np-lib/server/sv_asyncExports.lua"
server_script "@np-lib/server/sv_sql.lua"


client_scripts {
  "client/cl_*.lua"
}

shared_script {
  "@np-lib/shared/sh_util.lua",
  "@npx/shared/lib.lua",
  "shared/sh_*.*",
}

server_scripts {
  "server/sv_*.lua"
}
