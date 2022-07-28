fx_version 'cerulean'
games {'gta5'}

client_scripts {
  '@np-errorlog/client/cl_errorlog.lua',
  'cl_playerlist.lua',
}

server_scripts {
  'sv_playerlist.lua',
}

ui_page 'nui/public/index.html'

files {
  'nui/public/index.html',
  'nui/public/fonts/**',
  'nui/public/build/bundle.js',
  'nui/public/build/bundle.css',
}