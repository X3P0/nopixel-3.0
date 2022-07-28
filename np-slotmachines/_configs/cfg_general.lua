--[[
cfg_general.lua
]]

enableDebug = false

cfg_casino_coords = vector3(1032.22,40.71,69.87)
cfg_casino_scope_dist = 100.0

cfg_slot_machines = {
    [`vw_prop_casino_slot_01a`] = {
        label = "Angel Knights",
        machineModel = "vw_prop_casino_slot_01a",
        reelModel = "vw_prop_casino_slot_01a_reels",
        machines = {
            --Front Casino Slot Machines
            ["ak1"] = {
                pos = vector3(985.7021, 46.8523, 70.06008), 
                heading = 148.15661621094,
                numOfBets = 5,
                coinValue = 10
            },
            ["ak2"] = {
                pos = vector3(993.5618, 52.13541, 70.06008), 
                heading = 283.15670776367,
                numOfBets = 5,
                coinValue = 10
            },
            ["ak3"] = {
                pos = vector3(995.6368, 45.66202, 70.06008), 
                heading = 148.15661621094,
                numOfBets = 5,
                coinValue = 10
            },
            ["ak4"] = {
                pos = vector3(1000.35, 40.48258, 70.0601), 
                heading = 223.15672302246,
                numOfBets = 5,
                coinValue = 10
            }
        }
    },
    [`vw_prop_casino_slot_02a`] = {
        label = "Impotent Rage",
        machineModel = "vw_prop_casino_slot_02a",
        reelModel = "vw_prop_casino_slot_02a_reels",
        machines = {
            --Back Casino Slot Machines
            ["ir1"] = {
                pos = vector3(1017.83, 46.60374, 70.34293),
                heading = 239.46688842773,
                numOfBets = 5,
                coinValue = 10
            },
            --Front Casino Slot Machines
            ["ir2"] = {
                pos = vector3(986.0349, 46.00101, 70.06008), 
                heading = 76.156661987305,
                numOfBets = 5,
                coinValue = 10
            },
            ["ir3"] = {
                pos = vector3(993.8307, 51.43645, 70.06008), 
                heading = 298.15661621094,
                numOfBets = 5,
                coinValue = 10
            },
            ["ir4"] = {
                pos = vector3(995.9695, 44.81073, 70.06008), 
                heading = 76.156661987305,
                numOfBets = 5,
                coinValue = 10
            },
            ["ir5"] = {
                pos = vector3(999.8772, 39.91138, 70.0601), 
                heading = 238.15664672852,
                numOfBets = 5,
                coinValue = 10
            }
        }
    },
    [`vw_prop_casino_slot_03a`] = {
        label = "Republican Space Rangers",
        machineModel = "vw_prop_casino_slot_03a",
        reelModel = "vw_prop_casino_slot_03a_reels",
        machines = {
            --Back Casino Slot Machines
            ["rsr1"] = {
                pos = vector3(1018.143, 47.27817, 70.25374),
                heading = 253.07382202148,
                numOfBets = 5,
                coinValue = 10
            },
            --Front Casino Slot Machines
            ["rsr2"] = {
                pos = vector3(985.328, 45.42156, 70.06008), 
                heading = 4.1566424369812,
                numOfBets = 5,
                coinValue = 10
            },
            ["rsr3"] = {
                pos = vector3(994.2695, 50.82844, 70.06008), 
                heading = 313.15664672852,
                numOfBets = 5,
                coinValue = 10
            },
            ["rsr4"] = {
                pos = vector3(995.2626, 44.23128, 70.06008), 
                heading = 4.1566424369812,
                numOfBets = 5,
                coinValue = 10
            },
            ["rsr5"] = {
                pos = vector3(999.5728, 39.23074, 70.0601), 
                heading = 253.15664672852,
                numOfBets = 5,
                coinValue = 10
            }
        }
    },
    [`vw_prop_casino_slot_04a`] = {
        label = "Fame or Shame",
        machineModel = "vw_prop_casino_slot_04a",
        reelModel = "vw_prop_casino_slot_04a_reels",
        machines = {
            --Back Casino Slot Machines
            ["fs1"] = {
                pos = vector3(1018.244, 48.01497, 70.28422),
                heading = 267.40490722656,
                numOfBets = 5,
                coinValue = 10
            },
            --Front Casino Slot Machines
            ["fs2"] = {
                pos = vector3(981.5927, 48.89051, 70.0601), 
                heading = 13.156670570374,
                numOfBets = 5,
                coinValue = 10
            },
            ["fs3"] = {
                pos = vector3(984.5585, 45.91473, 70.06008), 
                heading = 292.15661621094,
                numOfBets = 5,
                coinValue = 10
            },
            ["fs4"] = {
                pos = vector3(990.9783, 48.84046, 70.06008), 
                heading = 148.15661621094,
                numOfBets = 5,
                coinValue = 10
            },
            ["fs5"] = {
                pos = vector3(994.8491, 50.34983, 70.06008), 
                heading = 328.15661621094,
                numOfBets = 5,
                coinValue = 10
            },
            ["fs6"] = {
                pos = vector3(994.4931, 44.72444, 70.06008), 
                heading = 292.15661621094,
                numOfBets = 5,
                coinValue = 10
            },
            ["fs7"] = {
                pos = vector3(999.4487, 38.49699, 70.0601), 
                heading = 268.15670776367,
                numOfBets = 5,
                coinValue = 10
            },
            ["fs8"] = {
                pos = vector3(995.6794, 40.00175, 70.06008), 
                heading = 148.15661621094,
                numOfBets = 5,
                coinValue = 10
            }
        }
    },
    [`vw_prop_casino_slot_05a`] = {
        label = "Deity of the Sun",
        machineModel = "vw_prop_casino_slot_05a",
        reelModel = "vw_prop_casino_slot_05a_reels",
        machines = {
            --Back Casino Slot Machines
            ["dots1"] = {
                pos = vector3(1018.083, 48.75245, 70.33798),
                heading = 283.07467651367,
                numOfBets = 5,
                coinValue = 10
            },
            --Front Casino Slot Machines
            ["dots2"] = {
                pos = vector3(984.7897, 46.79897, 70.06008), 
                heading = 220.15669250488,
                numOfBets = 5,
                coinValue = 10
            },
            ["dots3"] = {
                pos = vector3(982.2932, 49.15398, 70.0601), 
                heading = 28.156669616699,
                numOfBets = 5,
                coinValue = 10
            },
            ["dots4"] = {
                pos = vector3(991.3109, 47.98918, 70.06008), 
                heading = 76.156661987305,
                numOfBets = 5,
                coinValue = 10
            },
            ["dots5"] = {
                pos = vector3(995.5303, 50.04023, 70.06008), 
                heading = 343.15661621094,
                numOfBets = 5,
                coinValue = 10
            },
            ["dots6"] = {
                pos = vector3(994.7244, 45.60869, 70.06008), 
                heading = 220.15669250488,
                numOfBets = 5,
                coinValue = 10
            },
            ["dots7"] = {
                pos = vector3(996.0121, 39.15047, 70.06008), 
                heading = 76.156661987305,
                numOfBets = 5,
                coinValue = 10
            },
            ["dots8"] = {
                pos = vector3(999.526, 37.75539, 70.0601),
                heading = 283.15670776367,
                numOfBets = 5,
                coinValue = 10
            }
        }
    },
    [`vw_prop_casino_slot_06a`] = {
        label = "Twilight Knife",
        machineModel = "vw_prop_casino_slot_06a",
        reelModel = "vw_prop_casino_slot_06a_reels",
        machines = {
            --Back Casino Slot Machines
            ["tf1"] = {
                pos = vector3(1017.878, 49.42477, 70.38261),
                heading = 297.48474121094,
                numOfBets = 5,
                coinValue = 10
            },
            --Front Casino Slot Machines
            ["tf2"] = {
                pos = vector3(982.8981, 49.59357, 70.0601), 
                heading = 43.156620025635,
                numOfBets = 5,
                coinValue = 10
            },
            ["tf3"] = {
                pos = vector3(990.6041, 47.40972, 70.06008), 
                heading = 4.1566424369812,
                numOfBets = 5,
                coinValue = 10
            },
            ["tf4"] = {
                pos = vector3(996.2663, 49.9165, 70.06008), 
                heading = 358.15664672852,
                numOfBets = 5,
                coinValue = 10
            },
            ["tf5"] = {
                pos = vector3(995.3053, 38.57102, 70.06008),
                heading = 4.1566424369812,
                numOfBets = 5,
                coinValue = 10
            }
        }
    },
    [`vw_prop_casino_slot_07a`] = {
        label = "Diamond Miners",
        machineModel = "vw_prop_casino_slot_07a",
        reelModel = "vw_prop_casino_slot_07a_reels",
        machines = {
            --Back Casino Slot Machines
            ["dm1"] = {
                pos = vector3(1017.534, 50.08327, 70.35616),
                heading = 313.31225585938,
                numOfBets = 5,
                coinValue = 10
            },
            --Front Casino Slot Machines
            ["dm2"] = {
                pos = vector3(983.3739, 50.16665, 70.0601), 
                heading = 58.156597137451,
                numOfBets = 5,
                coinValue = 10
            },
            ["dm3"] = {
                pos = vector3(989.8346, 47.90289, 70.06008), 
                heading = 292.15661621094,
                numOfBets = 5,
                coinValue = 10
            },
            ["dm4"] = {
                pos = vector3(997.0084, 49.98836, 70.06009), 
                heading = 13.156546592712,
                numOfBets = 5,
                coinValue = 10
            },
            ["dm5"] = {
                pos = vector3(994.5358, 39.06418, 70.06008), 
                heading = 292.15661621094,
                numOfBets = 5,
                coinValue = 10
            }
        }
    },
    [`vw_prop_casino_slot_08a`] = {
        label = "Evacuator",
        machineModel = "vw_prop_casino_slot_08a",
        reelModel = "vw_prop_casino_slot_08a_reels",
        machines = {
            --Back Casino Slot Machines
            ["e1"] = {
                pos = vector3(1016.907, 50.52707, 70.41514),
                heading = 327.48468017578,
                numOfBets = 5,
                coinValue = 10
            },
            --Front Casino Slot Machines
            ["e2"] = {
                pos = vector3(983.685, 50.84427, 70.0601), 
                heading = 73.156707763672,
                numOfBets = 5,
                coinValue = 10
            },
            ["e3"] = {
                pos = vector3(990.0659, 48.78713, 70.06008), 
                heading = 220.15669250488,
                numOfBets = 5,
                coinValue = 10
            },
            ["e4"] = {
                pos = vector3(994.767, 39.94843, 70.06008), 
                heading = 220.15669250488,
                numOfBets = 5,
                coinValue = 10
            }
        }
    }
}

cfg_slot_symbols = {
    ["blank"] = {11.25, 33.75, 56.25, 78.75, 101.25, 123.75, 146.25, 168.75, 191.25, 213.75, 236.25, 258.75, 281.25, 303.75, 326.25, 348.75},
    ["special1"] = {112.5},
    ["special2"] = {90.0, 247.5, 337.5},
    ["watermelon"] = {67.5, 225.0},
    ["bell"] = {157.5, 292.5},
    ["seven"] = {0.0, 180.0},
    ["cherry"] = {45.0, 135.0, 315.0},
    ["grape"] = {22.5, 202.5, 270.0}
}

cfg_slot_audioref = {
    ["vw_prop_casino_slot_01a"] = "dlc_vw_casino_slot_machine_ak_npc_sounds",
    ["vw_prop_casino_slot_02a"] = "dlc_vw_casino_slot_machine_ir_npc_sounds",
    ["vw_prop_casino_slot_03a"] = "dlc_vw_casino_slot_machine_rsr_npc_sounds",
    ["vw_prop_casino_slot_04a"] = "dlc_vw_casino_slot_machine_fs_npc_sounds",
    ["vw_prop_casino_slot_05a"] = "dlc_vw_casino_slot_machine_ds_npc_sounds",
    ["vw_prop_casino_slot_06a"] = "dlc_vw_casino_slot_machine_kd_npc_sounds",
    ["vw_prop_casino_slot_07a"] = "dlc_vw_casino_slot_machine_td_npc_sounds",
    ["vw_prop_casino_slot_08a"] = "dlc_vw_casino_slot_machine_hz_npc_sounds"
}

--#[Global Functions]#--
function smDebug(debug)
    if enableDebug then
        print(GetCurrentResourceName() .. " | " .. debug)
    end
end