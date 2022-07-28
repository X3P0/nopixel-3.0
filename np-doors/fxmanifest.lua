fx_version 'cerulean'

games {
    'gta5',
    'rdr3'
}

server_script '@npx/server/lib.js'
client_script '@npx/client/lib.js'
shared_script '@npx/shared/lib.lua'

client_scripts {
  '@np-lib/client/cl_rpc.lua',
  '@np-lib/client/cl_rpc.lua',
  '@np-lib/client/cl_ui.lua',
  '@np-lib/client/cl_polyhooks.lua',
  '@np-lib/shared/sh_cacheable.lua',
	'client/cl_*.lua'
}

shared_scripts {
  '@np-lib/shared/sh_util.lua',
	"shared/*.lua"
}

server_scripts {
  '@np-lib/server/sv_rpc.lua',
  '@np-lib/server/sv_sql.lua',
  "@np-lib/server/sv_asyncExports.lua",
	'server/*.lua'
}
