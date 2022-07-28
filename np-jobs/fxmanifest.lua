fx_version "cerulean"

games { "gta5" }

description "NoPixel Job Framework"

version "0.1.0"

shared_script "@np-lib/shared/sh_cacheable.js"

server_script "@np-lib/server/sv_sql.js"
server_script "@np-lib/server/sv_rpc.js"
server_script "@np-lib/server/sv_npx.js"
server_script "@np-lib/server/sv_asyncExports.js"

client_script "@np-lib/client/cl_ui.js"
client_script "@np-lib/client/cl_rpc.js"
client_script "@np-lib/client/cl_rpc.lua"

client_scripts {
	"client/*.js",
	"client/*.lua",
}

server_scripts {
	"server/*.js",
	"server/*.lua"
}

 client_script "tests/cl_*.js"
 server_script "tests/sv_*.js"