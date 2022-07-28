fx_version "cerulean"

games { "gta5" }

description "Nopixel Boosting Script"

version "1.0.0"

server_scripts {
	"@np-db/server/lib.js",
	"@np-lib/server/sv_rpc.js",
	"@np-lib/server/sv_npx.js",
	"@np-lib/server/sv_asyncExports.js",
	"@np-lib/server/sv_infinity.lua",
	"build/server/*.js",
}

client_scripts {
	"@np-sync/client/lib.lua",
	"@np-lib/client/cl_ui.js",
	"@np-lib/client/cl_rpc.js",
	"build/client/*.js",
}
