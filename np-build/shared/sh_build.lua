Build = {}
Build.func = {}

function getModule(module)
    if not Build then print("Warning: '" .. tostring(module) .. "' module doesn't exist") return false end
    return Build[module]
end

Build.Plans = {

	["v_int_49"] = {
		["shell"] = "np_h_49_motelmp_shell",
		['dim'] = {
			['min'] = vector3(-10.6, -10000.34, -2.160843),
			['max'] = vector3(10.6, 10000.22, 1.352829),
		},
		["saveClient"] = true,
		["origin"] = false,
		["generator"] = vector3(175.09986877441,-904.7946166992,-98.9),
		["spawnOffset"] = vector3(-0.49,-1.76,1.01),
		["bedOffset"] = vector4(1.82,-0.66,1.59,88.27),
		["modulo"] = {
			["multi"] = {
				x = 12.0,
				y = 12.0,
				z = -14.0,
			},
			["xLimit"] = 24,
			["yLimit"] = 2,
		},
		["interact"] = {
			[1] = {
				
				["offset"] = vector3(-1.04,3.4,1.20),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"",""},
				["housingSecondary"] = {"to swap char or ~g~/outfits~s~.","apartments:Logout"},
			},
			[2] = {
				
				["offset"] = vector3(-0.96,-3.59,1.20),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","apartments:leave"},
				["housingSecondary"] = {"",""},
			},
			[3] = {
				
				["offset"] = vector3(-1.6,1.2,1.0),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to interact.","apartments:stash"},
				["housingSecondary"] = {"",""},
			}
		},
		["peek"] = {
			["model"] = -1388847408,
			["event"] = "np-housing:alarmEnter",
			["id"] = "np-housing:alarmEnter",
			["icon"] = "hammer",
			["label"] = "Disable",
			["distance"] = {radius = 2.0},
			["pos"] = vector3(-1.84,-2.62,1.10)
		} 
	},

	["np_apartments_room"] = {
		["shell"] = "gabz_pinkcage_ymap_shell",
		['dim'] = {
			['min'] = vector3(-9.326077, -5.972466, -1.777516),
			['max'] = vector3(9.26035, 5.670862, 1.768871),
		},
		["saveClient"] = true,
		["origin"] = false,
		["generator"] = vector3(-334.32,-953.21,-98.9),
		["spawnOffset"] = vector3(-3.88,-2.97,-0.75),
		["bedOffset"] = vector4(-3.46,0.56,-0.32,99.6),
		["modulo"] = {
			["multi"] = {
				x = 12.0,
				y = 12.0,
				z = -14.0,
			},
			["xLimit"] = 24,
			["yLimit"] = 22,
		},
		["interact"] = {
			[1] = {
				
				["offset"] = vector3(-0.18,2.75,-0.78),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"",""},
				["housingSecondary"] = {"to swap char or ~g~/outfits~s~.","apartments:Logout"},
			},
			[2] = {
				
				["offset"] = vector3(-4.03,-3.62,-0.78),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","apartments:leave"},
				["housingSecondary"] = {"",""},
			},
			[3] = {
				
				["offset"] = vector3(0.97,-2.15,-0.75),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to interact.","apartments:stash"},
				["housingSecondary"] = {"",""},
			}
		}
	},

	["np_apartment_tier3"] = {
		["shell"] = "np_apartment_tier3",
		['dim'] = {
			['min'] = vector3(-40.89789, -70.93818, -14.48829),
			['max'] = vector3(90.22247, 72.99227, 43.60839),
		},
		["saveClient"] = true,
		["origin"] = false,
		["generator"] = vector3(-934.32,-53.21,-98.9),
		["spawnOffset"] = vector3(-7.92,-2.63,1.64),
		["bedOffset"] = vector4(2.9,14.95,1.08,183.51),
		["modulo"] = {
			["multi"] = {
				x = 25.0,
				y = 25.0,
				z = -20.0,
			},
			["xLimit"] = 24,
			["yLimit"] = 22,
		},
		["interact"] = {
			[1] = {
				
				["offset"] = vector3(-6.12,14.53,0.4),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"",""},
				["housingSecondary"] = {"to swap char or ~g~/outfits~s~.","apartments:Logout"},
			},
			[2] = {
				
				["offset"] = vector3(-7.74,-0.89,1.6),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","apartments:leave"},
				["housingSecondary"] = {"",""},
			},
			[3] = {
				
				["offset"] = vector3(-3.74,-11.9,1.0),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to interact.","apartments:stash"},
				["housingSecondary"] = {"",""},
			}
		}
	},
	

	["v_int_16_mid"] = {
		["shell"] = "np_h_16_mid_shell",
		['dim'] = {
			['min'] = vector3(-12.098984, -16.01386, -1.625858),
			['max'] = vector3(10.135268, 10.475499, 1.508041),
		},
		["saveClient"] = true,
		["origin"] = false,
		["generator"] = vector3(175.09986877441,-904.7946166992,-98.999984741211),
		["spawnOffset"] = vector3(4.5,-14.0,0.7),
		["backSpawnOffset"] = vector3(-3.8,5.2,0.7),
		["bedOffset"] = vector4(7.18,1.43,1.47,271.37),
		["offsetX"] = {
			["num"] = 175.09986877441,
			["multi"] = 25.0
		},
		["offsetY"] = {
			["num"] = -774.7946166992,
			["multi"] = 0.0
		},
		["offsetZ"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["interact"] = {
			[1] = {
				["offset"] = vector3(8.0,4.0,1.1),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"",""},
				["housingSecondary"] = {"to swap char or ~g~/outfits~s~.","apartments:Logout"},
			},
			[2] = {
				["offset"] = vector3(4.3,-15.95,0.95),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","apartments:leave"},
				["housingSecondary"] = {"",""},
			},
			[3] = {
				["offset"] = vector3(9.8,-1.35,0.15),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to interact.","apartments:stash"},
				["housingSecondary"] = {"",""},
			}
		},
		["peek"] = {
			["model"] = -1388847408,
			["event"] = "np-housing:alarmEnter",
			["id"] = "np-housing:alarmEnter",
			["icon"] = "hammer",
			["label"] = "Disable",
			["distance"] = {radius = 2.0},
			["pos"] = vector3(3.57,-0.38,1.06)
		} 
	},


	


	["v_int_16_high"] = {
		["shell"] = "np_h_16_mesh_shell",
		['dim'] = {
			['min'] = vector3(-27.71931, -10.978034, -0.000218),
			['max'] = vector3(13.652101, 20.87981, 9.698149),
		},
		["saveClient"] = true,
		["origin"] = false,
		["generator"] = vector3(-265.68209838867,-957.06573486328,145.824577331543),
		["spawnOffset"] = vector3(-12.9,-1.5,8.0),
		["bedOffset"] = vector4(4.57,-1.19,1.73,90.47),
		["customLocations"] = {
			[1] = {
				["gen"] = vector3(131.0290527343,-644.0509033203,68.025619506836),
				["offSet"] = vector3(0.0,0.0,68.0534912),
				["numMulStart"] = 0,
				["numMulEnd"] = 7,
				["multi"] = 11.0,
			},

			[2] = {
				["gen"] = vector3(-134.43560791016,-638.13916015625,68.953491210938),
				["offSet"] = vector3(0.0,0.0,61.9534912),
				["numMulStart"] = 6,
				["numMulEnd"] = 14,
				["multi"] = 11.0,
			},

			[3] = {
				["gen"] = vector3(-181.440234375,-584.04815673828,68.95349121093),
				["offSet"] = vector3(0.0,0.0,61.9534912),
				["numMulStart"] = 13,
				["numMulEnd"] = 20,
				["multi"] = 11.0,
			},

			[4] = {
				["gen"] = vector3(-109.9752227783,-570.272351074,61.9534912),
				["offSet"] = vector3(0.0,0.0,61.9534912),
				["numMulStart"] = 19,
				["numMulEnd"] = 26,
				["multi"] = 11.0,
			},

			[5] = {
				["gen"] = vector3(-3.9463002681732,-693.2456665039,103.0334701538),
				["offSet"] = vector3(0.0,0.0,103.0534912),
				["numMulStart"] = 25,
				["numMulEnd"] = 38,
				["multi"] = 11.0,
			},

			[6] = {
				["gen"] = vector3(140.0758819580,-748.12322998, 87.0334701538),
				["offSet"] = vector3(0.0,0.0,87.0534912),
				["numMulStart"] = 37,
				["numMulEnd"] = 49,
				["multi"] = 11.0,
			},

			[7] = {
				["gen"] = vector3(131.0290527343,-644.0509033203, 68.025619506836),
				["offSet"] = vector3(0.0,0.0,68.0534912),
				["numMulStart"] = 48,
				["numMulEnd"] = 60,
				["multi"] = 11.0,
			},
		},
		["interact"] = {
			[1] = {
				
				["offset"] = vector3(6.0,6.0,1.5),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"",""},
				["housingSecondary"] = {"to swap char or ~g~/outfits~s~.","apartments:Logout"}, 
			},
			[2] = {
				
				["offset"] = vector3(-14.45,-2.5,7.3),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave ","apartments:leave"},
				["housingSecondary"] = {"",""},
				--["housingSecondary"] = {"to enter garage.","apartments:garage"},
			},
			[3] = {
				
				["offset"] = vector3(1.5,8.0,1.0),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to interact.","apartments:stash"},
				["housingSecondary"] = {"",""},
			}
		}
	},

	["v_int_72_l"] = {
		["shell"] = "np_h_72_garagel_shell",
		['dim'] = {
			['min'] = vector3(-12.033117, -20.73592, -2.0),
			['max'] = vector3(14.85011, 30.78797, 2.0),
		},
		["saveClient"] = true,
		["origin"] = false,
		["generator"] = vector3(227.391,-1035.0,-98.99),
		["spawnOffset"] = vector3(9.5,-12.7,2.0),
		["offsetX"] = {
			["num"] = 175.09986877441,
			["multi"] = 25.0
		},
		["offsetY"] = {
			["num"] = -774.7946166992,
			["multi"] = 0.0
		},
		["offsetZ"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["interact"] = {
			[1] = {
				["offset"] = vector3(9.5,-12.7,1.0),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to Room","apartments:garageToHouse"},
				["housingSecondary"] = {"to Garage Door.","apartments:garageToWorld"}, 
			},
		}
	},

	["v_int_44"] = {
		["shell"] = "np_h_44_shell",
		['dim'] = {
			['min'] = vector3(-16.4039, -19.13803, -4.107532),
			['max'] = vector3(16.39348, 12.220058, 4.080051),
		},
		["saveClient"] = false,
		["origin"] = false,
		["generator"] = vector3(-811.5,178.69,-40.84),
		["spawnOffset"] = vector3(-5.5793,5.100,0.0),
		["backSpawnOffset"] = vector3(14.17921200,1.90079500,1.1),
		["offsetX"] = {
			["num"] = -811.5,
			["multi"] = 26.0
		},
		["offsetY"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["offsetZ"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["interact"] = {
			[1] = {
				["offset"] = vector3(-6.9,6.32,1.01),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
		["peek"] = {
			["model"] = -1388847408,
			["event"] = "np-housing:alarmEnter",
			["id"] = "np-housing:alarmEnter",
			["icon"] = "hammer",
			["label"] = "Disable",
			["distance"] = {radius = 2.0},
			["pos"] = vector3(1.85,3.93,1.16)
		} 
	},

	["ex_int_office_03b_dlc"] = {
		["shell"] = "np_h_office_03b_shell_2",
		['dim'] = {
			['min'] = vector3(-21.50798, -20.58146, -6.767416),
			['max'] = vector3(21.50797, 20.80905, 4.634768),
		},
		["saveClient"] = false,
		["origin"] = false,
		["generator"] = vector3(162.78,-21.89,-44.35),
		["spawnOffset"] = vector3(-4.5793,2.100,1.0),
		["spawnHeading"] = 180.0,
		["offsetX"] = {
			["num"] = -811.5,
			["multi"] = 26.0
		},
		["offsetY"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["offsetZ"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["interact"] = {
			[1] = {
				["offset"] = vector3(-4.73,3.11,1.02),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	-- Empty Buildings 

	["v_int_38"] = {
		["shell"] = "np_h_38_c_barbers_shell",
		['dim'] = {
			['min'] = vector3(-9.206368, -13.954033, -1.557342),
			['max'] = vector3(9.564014, 9.46025, 1.557342),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(-1.4,-4.47,0.0),
		["interact"] = {
			[1] = {
				["offset"] = vector3(-0.89,-4.52,1.0),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["bkr_biker_dlc_int_ware05"] = {
		["shell"] = "np_h_ware06_walls_upgrade",
		['dim'] = {
			['min'] = vector3(-13.515662, -9.103531, -2.601134),
			['max'] = vector3(13.171064, 9.628727, 2.591596),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(5.81353500,0.28204400,0.0),
		["interact"] = {
			[1] = {
				["offset"] = vector3(8.69,0.0,1.03),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["v_int_16_low"] = {
		["shell"] = "np_h_16_Studio_LoShell",
		['dim'] = {
			['min'] = vector3(-12.690344, -9.932422, -2.724765),
			['max'] = vector3(12.582342, 9.932562, 2.673414),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(5.3,-5.5,1.2),
		["interact"] = {
			[1] = {
				["offset"] = vector3(5.65,-10.03,-0.99),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["v_int_24"] = {
		["shell"] = "np_h_24_Shell",
		['dim'] = {
			['min'] = vector3(-30.19287, -30.18945, -25.40723),
			['max'] = vector3(30.16406, 30.1167, 25.40723),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(6.5793,5.400,6.5),
		["spawnHeading"] = 130.0,
		["interact"] = {
			[1] = {
				["offset"] = vector3(8.05,6.18,6.41),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},
	
	["v_int_24_full"] = {
		["shell"] = "np_h_24_Shell_full",
		['dim'] = {
			['min'] = vector3(-30.19287, -30.18945, -25.40723),
			['max'] = vector3(30.16406, 30.1167, 25.40723),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(7.5793,6.400,7.0),
		["interact"] = {
			[1] = {
				["offset"] = vector3(8.05,6.18,6.41),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
		["peek"] = {
			["model"] = -1388847408,
			["event"] = "np-housing:alarmEnter",
			["id"] = "np-housing:alarmEnter",
			["icon"] = "hammer",
			["label"] = "Disable",
			["distance"] = {radius = 2.0},
			["pos"] = vector3(9.60,1.91,6.80)
		} 
	},

	["v_int_61"] = {
		["shell"] = "np_h_61_shell_walls",
		['dim'] = {
			['min'] = vector3(-11.272211, -9.250825, -1.604133),
			['max'] = vector3(11.269215, 9.223152, 1.445539),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(0.0,-4,1.0),
		["interact"] = {
			[1] = {
				["offset"] = vector3(0.72,-3.84,1.02),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["v_int_49_empty"] = {
		["shell"] = "np_h_49_motelmp_shell_2",
		['dim'] = {
			['min'] = vector3(-16.6, -16.34, -2.160843),
			['max'] = vector3(16.6, 16.22, 1.352829),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(-0.7,-2.85,1.01),
		["interact"] = {
			[1] = {
				["offset"] = vector3(-0.91,-3.53,1.01),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["v_int_16_mid_empty"] = {
		["shell"] = "np_h_16_mid_shell_2",
		['dim'] = {
			['min'] = vector3(-16.100339, -18.73701, -1.495198),
			['max'] = vector3(16.103913, 10.459234, 1.506826),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(4.0,-13.5,0.8),
		["interact"] = {
			[1] = {
				["offset"] = vector3(3.65,-15.76,0.98),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	
	["v_int_44_empty"] = {
		["shell"] = "np_h_44_shell_2",
		['dim'] = {
			['min'] = vector3(-18.4039, -19.13803, -4.107532),
			['max'] = vector3(18.39348, 11.220058, 4.080051),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(-5.5793,6.100,1.0),
		["spawnHeading"] = 270.0,
		["interact"] = {
			[1] = {
				["offset"] = vector3(-6.82,6.06,1.01),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["nopixel_trailer"] = {
		["shell"] = "nopixel_trailer",
		['dim'] = {
			['min'] = vector3(-11.356662, -8.525254, -1.591149),
			['max'] = vector3(11.303047, 8.5, 1.507284),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(-1.39,-1.44,-0.47),
		["interact"] = {
			[1] = {
				["offset"] = vector3(-1.39,-1.97,-0.47),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["ghost_stash_houses_01"] = {
		["shell"] = "ghost_stash_house_01",
		['dim'] = {
			['min'] = vector3(-13.448533, -8.75, -1.758343),
			['max'] = vector3(15.238526, 8.750001, 1.750001),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(7.14,-2.65,0.12),
		["spawnHeading"] = 90.0,
		["interact"] = {
			[1] = {
				["offset"] = vector3(7.14,-2.65,0.12),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["ghost_stash_houses_02"] = {
		["shell"] = "ghost_stash_house_03",
		['dim'] = {
			['min'] = vector3(-42.22152, -9.75, -1.794495),
			['max'] = vector3(20.15835, 21.21826, 4.406738),
		},
		["saveClient"] = false,
		["origin"] = vector3(627.9164,633.8272,-113.2648),
		["spawnOffset"] = vector3(7.14,-2.65,0.12),
		["interact"] = {
			[1] = {
				["offset"] = vector3(7.14,-2.65,0.12),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["np_warehouse_3"] = {
		["shell"] = "np_warehouse_3",
		['dim'] = {
			['min'] = vector3(-40.89789, -71.93818, -14.48829),
			['max'] = vector3(90.22247, 72.99227, 43.60839),
		},
		["saveClient"] = false,
		["origin"] = vector3(-33.16, 29.20, 0.0),
		["spawnOffset"] = vector3(17.64,-1.47,1.01),
		["interact"] = {
			[1] = {
				["offset"] = vector3(17.64,-1.47,1.01),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["empty_house"] = {
		["shell"] = "np_empty_house",
		['dim'] = {
			['min'] = vector3(-40.89789, -71.93818, -14.48829),
			['max'] = vector3(90.22247, 72.99227, 43.60839),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(14.0,0.0,-6.5),
		["interact"] = {
			[1] = {
				["offset"] = vector3(14.0,0.0,-6.5),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
	},

	["v_int_36"] = {
		["shell"] = "np_h_36_shell",
		['dim'] = {
			['min'] = vector3(-40.89789, -71.93818, -14.48829),
			['max'] = vector3(90.22247, 72.99227, 43.60839),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(-0.47,-2.95,0.6),
		["interact"] = {
			[1] = {
				["offset"] = vector3(-0.47,-2.95,1.0),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
		-- ['npc'] = {
		-- 	{
		-- 		['id'] = 'housing_store_seller_',
		-- 		['offset'] = vector4(-2.59,-1.96,0.0,266.79),
		-- 		['pedType'] = 4,
		-- 		['model'] = "a_m_y_vinewood_01",
		-- 		['networked'] = false,
		-- 		['distance'] = 25.0,
		-- 		['settings'] = {
		-- 			{ mode = 'invincible', active = true },
		-- 			{ mode = 'ignore', active = true },
		-- 			{ mode = 'freeze', active = true },
		-- 		},
		-- 		['flags'] = {
		-- 			isNPC = true,
		-- 		},
		-- 		['peek'] = {
		-- 			{
		-- 				['id'] = 'housing:shop:clerk',
		-- 				['label'] = "View inventory",
		-- 				['icon'] = "circle",
		-- 				['event'] = 'np-shops:openHouseShop',
		-- 			}
		-- 		} 
		-- 	}
		-- }
	},

	["v_int_53"] = {
		["shell"] = "np_h_53_shop_shell",
		['dim'] = {
			['min'] = vector3(-40.89789, -71.93818, -14.48829),
			['max'] = vector3(90.22247, 72.99227, 43.60839),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(1.54,-7.64,1.66),
		["interact"] = {
			[1] = {
				["offset"] = vector3(1.54,-7.64,1.66),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
		-- ['npc'] = {
		-- 	{
		-- 		['id'] = 'housing_store_seller_',
		-- 		['offset'] = vector4(1.42,0.25,0.65,179.93),
		-- 		['pedType'] = 4,
		-- 		['model'] = "a_m_y_vinewood_01",
		-- 		['networked'] = false,
		-- 		['distance'] = 25.0,
		-- 		['settings'] = {
		-- 			{ mode = 'invincible', active = true },
		-- 			{ mode = 'ignore', active = true },
		-- 			{ mode = 'freeze', active = true },
		-- 		},
		-- 		['flags'] = {
		-- 			isNPC = true,
		-- 		},
		-- 		['peek'] = {
		-- 			{
		-- 				['id'] = 'housing:shop:clerk',
		-- 				['label'] = "View inventory",
		-- 				['icon'] = "circle",
		-- 				['event'] = 'np-shops:openHouseShop',
		-- 			}
		-- 		} 
		-- 	}
		-- }
	},

	["empty_house_shop"] = {
		["shell"] = "np_empty_house",
		['dim'] = {
			['min'] = vector3(-40.89789, -71.93818, -14.48829),
			['max'] = vector3(90.22247, 72.99227, 43.60839),
		},
		["saveClient"] = false,
		["origin"] = false,
		["spawnOffset"] = vector3(14.0,0.0,-6.5),
		["interact"] = {
			[1] = {
				["offset"] = vector3(14.0,0.0,-6.5),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["generalUse"] = {"",""},
				["housingMain"] = {"to leave.","housing:frontdoor"},
				["housingSecondary"] = {"",""},
			},
		},
		-- ['npc'] = {
		-- 	{
		-- 		['id'] = 'housing_store_seller_',
		-- 		['offset'] = vector4(4.0,0.0,-7.5,270.0),
		-- 		['pedType'] = 4,
		-- 		['model'] = "a_m_y_vinewood_01",
		-- 		['networked'] = false,
		-- 		['distance'] = 25.0,
		-- 		['settings'] = {
		-- 			{ mode = 'invincible', active = true },
		-- 			{ mode = 'ignore', active = true },
		-- 			{ mode = 'freeze', active = true },
		-- 		},
		-- 		['flags'] = {
		-- 			isNPC = true,
		-- 		},
		-- 		['peek'] = {
		-- 			{
		-- 				['id'] = 'housing:shop:clerk',
		-- 				['label'] = "View inventory",
		-- 				['icon'] = "circle",
		-- 				['event'] = 'np-shops:openHouseShop',
		-- 			}
		-- 		} 
		-- 	}
		-- }
	},

	-- Instancing Buildings , not used on buildings that have to be created , must be already built MLO 

	["v_33_cur"] = {
		["instance"] = true,
		["origin"] = vector3(133.2307,-616.1162,205.1947),
		["darken"] = true
	}

}
