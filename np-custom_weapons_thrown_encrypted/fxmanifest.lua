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
	'weapon_brick.meta',
	'weapon_shoe.meta',
	'weapon_cash.meta',
	'weapon_book.meta'
	}

---------------------------------------------------------------------------
-- DATA FILES
---------------------------------------------------------------------------
	data_file 'WEAPONCOMPONENTSINFO_FILE' 'weaponcomponents.meta'
	data_file 'PED_PERSONALITY_FILE' 'pedpersonality.meta'
	data_file 'WEAPON_ANIMATIONS_FILE' 'weaponanimations.meta'
	data_file 'WEAPON_METADATA_FILE' 'weaponarchetypes.meta'
	data_file 'WEAPONINFO_FILE' 'weapon_brick.meta'
	data_file 'WEAPONINFO_FILE_PATCH' 'weapon_brick.meta'
	data_file 'WEAPONINFO_FILE' 'weapon_shoe.meta'
	data_file 'WEAPONINFO_FILE_PATCH' 'weapon_shoe.meta'
	data_file 'WEAPONINFO_FILE' 'weapon_cash.meta'
	data_file 'WEAPONINFO_FILE_PATCH' 'weapon_cash.meta'
	data_file 'WEAPONINFO_FILE' 'weapon_book.meta'
	data_file 'WEAPONINFO_FILE_PATCH' 'weapon_book.meta'
dependency '/assetpacks'