fx_version 'adamant' 
games { 'gta5' } 
 
description 'Flamethrower Add-On Weapon (FiveM resource)'
description_cont 'Repackaged from the dlc.rpf and made so it can be streamed to a FiveM server'

original_author 'WildBrick142'
original_mod 'https://www.gta5-mods.com/weapons/flamethrower-add-on-hud-icon'

resource_creator 'Success'
resource_creator_link 'https://forum.cfx.re/t/flamethrower-add-on-hud-icon-adapted-for-fivem-originally-by-wildbrick142/1309791'


 
files {

    --Flamethrower
    'data/weaponflamethrower.meta',
    'data/weaponarchetypes.meta',
    'data/weaponanimations.meta',
    'data/pedpersonality.meta',
    'data/loadouts.meta',
    'data/pickups.meta',
    'data/ptfxassetinfo.meta',
    'data/weapon_names.lua'
}

    --Flamethrower
    data_file 'WEAPONINFO_FILE' 'data/weaponflamethrower.meta'
    data_file 'WEAPON_METADATA_FILE' 'data/weaponarchetypes.meta'
    data_file 'WEAPON_ANIMATIONS_FILE' 'data/weaponanimations.meta'
    data_file 'PED_PERSONALITY_FILE' 'data/pedpersonality.meta'
    data_file 'LOADOUTS_FILE' 'data/loadouts.meta'
    data_file 'DLC_WEAPON_PICKUPS' 'data/pickups.meta'
    data_file 'PTFXASSETINFO_FILE' 'data/ptfxassetinfo.meta'

client_scripts {
    --Weapon Names.lua
    'data/weapon_names.lua'
}
