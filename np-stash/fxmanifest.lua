fx_version 'cerulean'
games {'gta5'}

-- dependency "np-base"

client_script "@np-errorlog/client/cl_errorlog.lua"
client_script 'stashhouse_client.lua'


server_scripts {
	'stashhouse_server.lua',
}

export "stash"


ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/Drill.png',
	'html/LockFace.png',
	'html/DestroyPin.png',
	'html/HoldingPin.png',
	'html/HoldingBreak.png',
	'html/sounds/pinbreak.ogg',
	'html/sounds/lockUnlocked.ogg',
	'html/sounds/lockpick.ogg',
	'html/Drill2.png',
	'html/button.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/background2.png'
}
