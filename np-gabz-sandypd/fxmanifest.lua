fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Gabz'
description 'Sandy Sheriff'
version '4.0.0'

this_is_a_map 'yes'

dependencies {
    'np-gabz-pdprops',
    '/server:4960',
    '/gameBuild:2189'
}

escrow_ignore {
    'stream/**/*.ytd'
}

client_script {
    "gabz_sdso_entitysets.lua"
}
dependency '/assetpacks'