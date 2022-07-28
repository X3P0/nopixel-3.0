fx_version "cerulean"

games {"gta5"}

description "NoPixel Peek Interactions"


client_script "@npx/client/lib.js"
server_script "@npx/server/lib.js"
shared_script "@npx/shared/lib.lua"

shared_scripts {
	"shared/sh_*.lua",
}

server_scripts {
	"server/sv_*.lua",
}
client_script "@np-locales/client/lib.lua"
client_script "@mka-array/Array.lua"
client_script "@np-lib/client/cl_ui.lua"

client_scripts {
	"client/cl_*.lua",
	'@np-lib/client/cl_rpc.lua',
	"client/entries/cl_*.lua",
}
