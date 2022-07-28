fx_version 'cerulean'
games {'gta5'}

-- dependency "np-base"
-- dependency "raid_clothes"

ui_page "html/index.html"
files({
	"html/*",
	"html/images/*",
	"html/css/*",
	"html/webfonts/*",
	"html/js/*"
})

client_script "@npx/client/lib.js"
server_script "@npx/server/lib.js"
shared_script "@npx/shared/lib.lua"

client_script '@np-lib/client/cl_rpc.lua'
client_script "@np-errorlog/client/cl_errorlog.lua"
client_script "client/*"

shared_script "shared/sh_spawn.lua"
shared_script "@np-lib/shared/sh_cache.lua"
server_scripts {
  '@np-lib/server/sv_sql.lua',
  '@np-lib/server/sv_asyncExports.lua',
  '@np-lib/server/sv_rpc.lua',
}
server_script "server/*"
