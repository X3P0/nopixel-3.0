fx_version "cerulean"

games { "gta5" }

description "NoPixel Heists X"

version "0.1.0"

dependencies { "mka-lasers" }

shared_scripts { "@npx/shared/lib.lua", "@np-lib/shared/sh_util.lua", "lua/shared/sh_*.lua" }

server_scripts {
  "@npx/server/lib.js",
  "@np-lib/server/sv_rpc.lua",
  "@np-lib/server/sv_sql.lua",
  "@np-db/server/lib.js",
  "@np-lib/server/sv_asyncExports.js",
  "@np-lib/server/sv_asyncExports.lua",
  "server/sv_*.js",
  "lua/server/sv_*.lua",
}

client_scripts {
  "@npx/client/lib.js",
  "@np-lib/client/cl_ui.js",
  "@np-locales/client/lib.js",
  "@np-errorlog/client/cl_errorlog.lua",
  "@np-sync/client/lib.lua",
  "@np-lib/client/cl_rpc.lua",
  "@np-lib/client/cl_ui.lua",
  "@np-lib/client/cl_animTask.lua",
  "@mka-lasers/client/client.lua",
  "@mka-grapple/client.lua",
  "client/cl_*.js",
  "lua/client/cl_*.lua",
}
