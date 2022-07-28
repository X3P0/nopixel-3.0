fx_version 'cerulean'
game 'gta5'
version '1.0.0'

client_script "@npx/client/lib.js"
client_script "@np-lib/client/cl_ui.js"
client_script "@np-locales/client/lib.js"
client_script "build/client.js"

server_script "@npx/server/lib.js"
server_script "@np-db/server/lib.js"
server_script "build/server.js"
