fx_version 'cerulean'
games { 'gta5' }

server_script "@np-lib/server/sv_rpc.lua"
server_script "@np-lib/server/sv_asyncExports.lua"
shared_script "shared/sh_jobmanager.lua"
server_script "server/sv_jobmanager.lua"
client_script "client/cl_jobmanager.lua"
