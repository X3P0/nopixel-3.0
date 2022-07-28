fx_version 'adamant'

game "gta5"

client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  '@np-lib/client/cl_rpc.lua',
  'client/cl_*.lua',
}

server_script "@np-lib/server/sv_sql.lua"
server_scripts {
  'server/sv_*.lua',
  'server/sv_*.js',
}
