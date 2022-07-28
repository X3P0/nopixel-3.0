fx_version 'cerulean'
games { 'gta5' }

--dependency 'yarn'
--dependency 'webpack'

--webpack_config 'webpack.config.js'

files {
    'public/sounds/*',
    'public/common/*',
    'public/sets/civs/*',
    'public/sets/crews/*',
    'public/sets/government/*',
}

client_scripts {
    '@np-lib/client/cl_ui.js',
    './dist/client.js',
    '@np-lib/client/cl_animTask.lua',
    '@np-lib/client/cl_rpc.lua',
    '@np-lib/client/cl_rpc.js',
    '@np-lib/client/cl_ui.lua',
    'cl_*.lua',
}

server_script {
    '@np-lib/server/sv_rpc.lua',
    '@np-lib/server/sv_rpc.js',
    '@np-lib/server/sv_npx.js',
    '@np-lib/server/sv_asyncExports.js',
    './dist/server.js',
    'sv_*.lua',
}
