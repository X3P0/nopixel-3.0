fx_version 'cerulean'
game 'gta5'

author 'Gabz'
description 'Fire Dept'
version '6.0.0s'

this_is_a_map 'yes'

dependencies {
    '/server:4960',
    '/gameBuild:2189'
}

escrow_ignore {
    'stream/**/*.ytd',
    'firedept.lua',
}

data_file 'TIMECYCLEMOD_FILE' 'gabz_firedept.xml'

files {
    'gabz_firedept.xml',
}
dependency '/assetpacks'