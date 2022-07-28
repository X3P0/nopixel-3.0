fx_version "cerulean"

games { "gta5" }

description "Voice System"

ui_page "nui/ui.html"

server_scripts {
    '@np-lib/server/sv_asyncExports.lua',
    '@np-lib/server/sv_rpc.lua',
    "config.lua",
    "server/lib.lua",
    "server/np_lib.lua",
    "server/classes/*.lua",
    "server/modules/*.lua",
    "server/server.lua",
    "server/implementation/*.lua"
}

client_scripts {
    '@np-lib/client/cl_rpc.lua',
    "config.lua",
    "client/tools/*.lua",
    "client/classes/*.lua",
    "client/modules/*.lua",
    "client/client.lua",
    "client/implementation/*.lua",
}

files {
    "nui/sounds/*.*",
    "nui/sounds/clicks/*.*",
    "nui/ui.html",
    "nui/css/style.css",
    "nui/js/script.js"
}

if GetConvar("sv_environment", "prod") == "debug" then
    server_script "tests/sv_*.lua"
    client_script "tests/cl_*.lua"
end
