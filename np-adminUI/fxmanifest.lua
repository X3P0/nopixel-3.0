games {'gta5'}

fx_version 'cerulean'

description "Admin Menu UI"


server_script "@npx/server/lib.js"
server_script "@np-lib/server/sv_asyncExports.js"

client_scripts{
  "@np-lib/client/cl_rpc.lua",
  "client/events.js",
}

server_scripts {
  "server/server.js",
}

ui_page 'nui/dist/index.html'

files {
  'nui/dist/index.html',
  'nui/dist/js/app.js',
  'nui/dist/css/app.css',
  'nui/dist/img/tablet.png'
}