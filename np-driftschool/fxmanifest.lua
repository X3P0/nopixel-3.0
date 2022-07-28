fx_version 'cerulean'
games {'gta5'}

--[[ dependencies {
    "PolyZone",
    "np-base"
} ]]--


server_script('server.lua')

ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/script.js',
})

client_scripts {
    "@PolyZone/client.lua",
    'client.lua'
}
