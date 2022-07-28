fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Gabz'
description 'Ammu-Nation'
version '6.0.0s'

this_is_a_map 'yes'

client_script {
    'gabz_entityset_ammunation.lua',
}

dependencies {
    '/server:4960',
    '/gameBuild:2189'
}

escrow_ignore {
    'stream/**/*.ytd',
    'gabz_entityset_ammunation.lua',
    'ammunation.lua',
}

dependency '/assetpacks'