fx_version 'cerulean'

games { 'gta5' }

client_script "@np-lib/client/cl_rpc.js"
client_script "@np-locales/client/lib.js"
client_script "build/client.js"

server_script "@np-lib/server/sv_rpc.js"
server_script "build/server.js"
