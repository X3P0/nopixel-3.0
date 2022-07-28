fx_version 'cerulean'
games {'gta5'}

-- dependency "np-base"


client_script "@np-errorlog/client/cl_errorlog.lua"


client_script {
	'util/xml.lua',
	'client/ytyp/*',
	'client/cl_ytyp.lua',
	
}

exports {
	'request',
} 