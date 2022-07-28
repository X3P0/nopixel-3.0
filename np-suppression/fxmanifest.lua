fx_version 'cerulean'
games { 'rdr3', 'gta5' }

-- --[[ dependencies {
--   "np-lib",
--   "np-ui"
-- } ]]--

server_scripts {
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_sql.lua',
  'server/config.lua',
  'server/sv_*.lua',
}

lua54 'yes'