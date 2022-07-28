fx_version 'cerulean'
games {'gta5'}

SetResourceInfo('uiPage', 'html/index.html')
ui_page 'html/index.html'



client_script 'blackjackDealer_client.lua'
client_script 'casino_client.lua'
-- client_script 'cardsDealer_client.lua'

server_script 'casino_server.lua'

files
{
    'html/index.html',
    'html/scripts.js',
    'html/styles.css',
}

exports {
    'getChipBalance'
}
