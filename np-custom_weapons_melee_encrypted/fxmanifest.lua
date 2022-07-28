fx_version 'cerulean'
games { 'rdr3', 'gta5' }

---------------------------------------------------------------------------
-- INCLUDED FILES
---------------------------------------------------------------------------
files {
	'weaponcomponents.meta',
	'pedpersonality.meta',
	'weaponanimations.meta',
	'weaponarchetypes.meta',
	'weapon_shiv.meta',
	'weapon_katanas.meta',
	'weapon_bats.meta'
	}

---------------------------------------------------------------------------
-- DATA FILES
---------------------------------------------------------------------------
	data_file 'WEAPONCOMPONENTSINFO_FILE' 'weaponcomponents.meta'
	data_file 'PED_PERSONALITY_FILE' 'pedpersonality.meta'
	data_file 'WEAPON_ANIMATIONS_FILE' 'weaponanimations.meta'
	data_file 'WEAPON_METADATA_FILE' 'weaponarchetypes.meta'
	data_file 'WEAPONINFO_FILE' 'weapon_shiv.meta'
	data_file 'WEAPONINFO_FILE_PATCH' 'weapon_shiv.meta'
	data_file 'WEAPONINFO_FILE' 'weapon_katanas.meta'
	data_file 'WEAPONINFO_FILE_PATCH' 'weapon_katanas.meta'
	data_file 'WEAPONINFO_FILE' 'weapon_bats.meta'
	data_file 'WEAPONINFO_FILE_PATCH' 'weapon_bats.meta'
dependency '/assetpacks'