fx_version 'cerulean'

games {'gta5'}

shared_script '@np-lib/shared/sh_cacheable.lua'

server_script "@np-lib/server/sv_infinity.lua"
server_script '@np-lib/server/sv_rpc.lua'

server_scripts {
	'server/sv_*.lua',
	'client/**/svm_*.lua',
}

client_script "@np-errorlog/client/cl_errorlog.lua"
client_script "@np-infinity/client/classes/blip.lua"
client_script "@np-lib/client/cl_infinity.lua"
client_script '@np-lib/client/cl_rpc.lua'
client_script "@np-lib/client/cl_ui.lua"
client_script "@np-locales/client/lib.lua"

client_scripts	{
	'client/**/cl_*.lua',
	'client/**/clm_*.lua',
}

