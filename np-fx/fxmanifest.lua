fx_version "cerulean"

games { "gta5" }

description "NoPixel Boilerplate"

version "0.1.0"

server_script '@np-lib/server/sv_infinity.lua'

server_scripts {
    "server/*.js",
    "sv_*.lua",
}

shared_scripts {
    "sh_*.lua"
}

client_scripts {
    "client/*.js",
    "cl_*.lua",
}
