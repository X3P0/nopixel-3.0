fx_version "cerulean"

games {"gta5"}

description "Nopixel Vehicle Remote Control"
author "xIAlexanderIx"

server_scripts {
	"server/main.lua"
}

client_script "@np-sync/client/lib.lua"

client_scripts {
	"client/vehicles/*.lua",
	"client/main.lua",
	"client/tools.lua"
}