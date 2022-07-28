fx_version 'cerulean'
games {'gta5'}

--resource_type 'gametype' { name = 'Hot Putsuit' }
client_script "@np-errorlog/client/cl_errorlog.lua"
client_script "@np-locales/client/lib.lua"
client_script "@np-lib/client/cl_infinity.lua"
server_script "@np-lib/server/sv_infinity.lua"

server_script "server.lua"
client_script "client.lua"
