CreateThread(function()
	-- Checkin, pillbox
	exports["np-polyzone"]:AddCircleZone("pillbox_checkin", vector3(306.9, -595.03, 43.28), 0.7, {
		useZ=true,
	})

	exports["np-polyzone"]:AddCircleZone("viceroy_checkin", vector3(-817.44, -1236.69, 7.34), 0.7, {
		useZ=true,
	})

	-- Armory, pillbox
	exports["np-polyzone"]:AddCircleZone("hospital_armory", vector3(306.28, -601.58, 43.28), 0.7, {
		useZ=true,
	})

	exports["np-polyzone"]:AddCircleZone("hospital_armory", vector3(-820.22, -1242.72, 7.34), 0.7, {
		useZ=true,
	})

	-- armory el burro
	exports["np-polyzone"]:AddCircleZone("hospital_armory", vector3(1211.51, -1475.16, 34.86), 1.0, {
		useZ=true,
	})

	-- Clothing / Personal Lockers, Staff room, pillbox
	exports["np-polyzone"]:AddBoxZone("hospital_clothing_lockers_staff", vector3(300.28, -598.83, 43.28), 3.2, 4.2, {
		heading=340,
		minZ=42.28,
		maxZ=45.68
	})

	exports["np-polyzone"]:AddBoxZone("hospital_clothing_lockers_staff", vector3(-824.44, -1237.3, 7.34), 5.0, 3.8, {
		heading=320,
		minZ=6.34,
		maxZ=9.34
	})

	-- el burro fd
	exports["np-polyzone"]:AddBoxZone("elburro_clothing_lockers_staff_char_switcher", vector3(1210.94, -1472.72, 34.85), 1.8, 3.4, {
		name="ebsw",
		heading=0,
		minZ=32.65,
		maxZ=36.65
	})

	-- Character Switcher, Staff room, pillbox
	exports["np-polyzone"]:AddBoxZone("hospital_character_switcher_staff", vector3(296.16, -598.31, 43.28), 2.4, 1.2, {
		heading=250,
		minZ=42.28,
		maxZ=45.68
	})

	exports["np-polyzone"]:AddBoxZone("hospital_character_switcher_staff", vector3(-828.56, -1236.19, 7.38), 1.6, 2.4, {
		heading=321,
		minZ=6.38,
		maxZ=9.18
	})
	-- Character Switcher, Backroom pillbox
	exports["np-polyzone"]:AddBoxZone("pillbox_character_switcher_backroom", vector3(340.82, -596.46, 43.28), 2.4, 1.2, {
		heading=160,
		minZ=42.28,
		maxZ=45.68
	})
	-- Character Switcher, Morgue
	exports["np-polyzone"]:AddBoxZone("morgue_character_switcher_backroom", vector3(296.61, -1352.36, 24.53), 1.8, 2.0, {
		heading=50,
		minZ=23.53,
		maxZ=26.53
	})
	-- Character Switcher, Parsons
	exports["np-polyzone"]:AddBoxZone("parsons_character_switcher_backroom", vector3(-1501.62, 857.45, 181.59), 1.8, 2.0, {
		heading=25,
		minZ=180.59,
		maxZ=184.59
	})
	-- Character Switcher, Infirmirary (Prison)
	exports["np-polyzone"]:AddBoxZone("infirm_char_switcher_backroom", vector3(1765.96, 2598.96, 45.73), 2.0, 2.8, {
		heading=0,
		minZ=44.73,
		maxZ=47.33
	})
end)

ICU_ROOMS = {
	{
		name = _L("healthcare-text-room", "Room") .. " 369",
		coords = vector4(361.41,-582.21,43.29,72.57),
	},
	{
		name = _L("healthcare-text-room", "Room") .. " 370",
		coords = vector4(358.8,-586.97,43.29,49.76),
	},
	{
		name = _L("healthcare-text-room", "Room") .. " 374",
		coords = vector4(353.8,-600.94,43.29,59.69),
	},
	{
		name = _L("healthcare-text-room", "Room") .. " 371 " .. _L("healthcare-text-bed", "Bed") .. " 1",
		coords = vector4(365.89,-582.44,43.29,84.27),
	},
	{
		name = _L("healthcare-text-room", "Room") .. " 371 " .. _L("healthcare-text-bed", "Bed") .. " 2",
		coords = vector4(364.62,-586.81,43.29,62.52),
	},
	{
		name = _L("healthcare-text-room", "Room") .. " 371 " .. _L("healthcare-text-bed", "Bed") .. " 3",
		coords = vector4(364.13,-588.24,43.29,51.75),
	}
}
