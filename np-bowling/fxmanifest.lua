fx_version 'cerulean'
games { 'gta5' }

client_script "@npx/client/lib.js"
server_script "@npx/server/lib.js"
shared_script "@npx/shared/lib.lua"

client_script "@np-errorlog/client/cl_errorlog.lua"
client_script '@np-locales/client/lib.lua'
client_script "@np-lib/client/cl_ui.lua"

client_scripts {
  'client/cl_*.lua',
}

shared_script {
  'sh_config.lua',
}

server_scripts {
  'server/sv_*.lua',
}
