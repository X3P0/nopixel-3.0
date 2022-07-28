fx_version 'cerulean'
games {'gta5'}

-- dependency "np-base"



client_script "@np-errorlog/client/cl_errorlog.lua"

server_script "server/sv_log.lua"
server_script "server/sv_log.js"
server_script '@np-lib/server/sv_sql.js'
server_script '@np-lib/server/sv_asyncExports.lua'

server_export "AddLog"