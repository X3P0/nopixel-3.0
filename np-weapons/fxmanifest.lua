games {"gta5"}

fx_version "cerulean"

description "Weapons"

dependencies  {
  "damage-events"
}

client_scripts {
  "@np-errorlog/client/cl_errorlog.lua",
  "@np-lib/client/cl_rpc.lua",
 -- "client.lua",
  "modes.lua",
  "melee.lua",
  "pickups.lua",
  "cl_*.lua"
}

shared_script {
  "@np-lib/shared/sh_util.lua"
}
server_scripts {
  "@np-lib/server/sv_rpc.lua",
  "@np-lib/server/sv_sql.lua",
  "server.lua"
}

server_export "getWeaponMetaData"
server_export "updateWeaponMetaData"

exports {
  "toName",
  "findModel"
}
