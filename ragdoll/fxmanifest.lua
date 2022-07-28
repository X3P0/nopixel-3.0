fx_version 'cerulean'
games {'gta5'}

client_script '@np-lib/client/cl_rpc.lua'
client_script 'respawn.lua'
client_script 'cl_health.lua'

server_script '@npx/server/lib.js'
client_script '@npx/client/lib.js'
shared_script '@npx/shared/lib.lua'

server_script 'server.lua'
server_script 'sv_health.lua'