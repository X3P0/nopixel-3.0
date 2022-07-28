fx_version 'cerulean'
games { 'gta5' }

server_script "@np-lib/server/sv_rpc.js"
server_script "@np-db/server/lib.js"

server_scripts {
  '@np-lib/server/sv_sql.lua',
  'server/sv_*.js',
}
