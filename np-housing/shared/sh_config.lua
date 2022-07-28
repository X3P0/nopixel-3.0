Housing = {}
Housing.func = {}

Housing.ranges = {
    ["editRange"] = 30,
    ["garageEnterRange"] = 4.5,
    ["doorEnterRange"] = 2.5,
    ["minOrigin"] = -100,
    ["maxOrigin"] = 100,
    ["percentageGivenBackToState"] = 50,
    ["percentageGivenBackToPlayer"] = 50,
    ["incrementForStackingProperty"] = 0.050,
    ["weeklyPaymentPercent"] = 0.025,
    ["realtorPercent"] = 70, -- This is backwards , but the player pays xx percent of the property
    ["realtorCommison"] = 10, -- how much of the realtor percent is given in commision
}

Housing.max = {
    ["office"] = {
        ["propertyAmount"] = 1,
        ["propertykeyAmount"] = 1,
        ["canHaveInventory"] = false,
        ["canHaveBackDoor"] = false,
        ["canHaveGarage"] = false,
        ["canHaveCharSelect"] = false,
        ["canHaveFurniture"] = true,
        ["canHaveCrafting"] = false,
        ["personalKeyAmount"] = 1,
    },
    ["housing"] = {
        ["propertyAmount"] = 2,
        ["propertykeyAmount"] = 4,
        ["canHaveInventory"] = true,
        ["canHaveBackDoor"] = true,
        ["canHaveGarage"] = true,
        ["canHaveCharSelect"] = true,
        ["canHaveFurniture"] = true,
        ["canHaveCrafting"] = true,
        ["personalKeyAmount"] = 4,
    },
    ["warehouse"] = {
        ["propertyAmount"] = 1,
        ["propertykeyAmount"] = 3, -- 3 personal keys , does not inlcude owner
        ["canHaveInventory"] = true,
        ["canHaveBackDoor"] = false,
        ["canHaveGarage"] = false,
        ["canHaveCharSelect"] = false,
        ["canHaveFurniture"] = true,
        ["canHaveCrafting"] = false,
        ["personalKeyAmount"] = 1, -- how many of a given type a single person can have accesses to 
        ["publicCrafting"] = true,
    },

    ["buisness"] = {
        ["propertyAmount"] = 1,
        ["propertykeyAmount"] = 0,
        ["canHaveInventory"] = false,
        ["canHaveBackDoor"] = false,
        ["canHaveGarage"] = false,
        ["canHaveCharSelect"] = false,
        ["canHaveFurniture"] = false,
        ["canHaveCrafting"] = false,
        ["personalKeyAmount"] = 1,
    },

    ["goverment"] = {
        ["propertyAmount"] = 1,
        ["propertykeyAmount"] = 999,
        ["canHaveInventory"] = false,
        ["canHaveBackDoor"] = false,
        ["canHaveGarage"] = false,
        ["canHaveCharSelect"] = false,
        ["canHaveFurniture"] = true,
        ["canHaveCrafting"] = false,
        ["personalKeyAmount"] = 1,
    },

    ["shop"] = {
        ["propertyAmount"] = 9999,
        ["propertykeyAmount"] = 9999,
        ["canHaveInventory"] = false,
        ["canHaveBackDoor"] = false,
        ["canHaveGarage"] = false,
        ["canHaveCharSelect"] = false,
        ["canHaveFurniture"] = true,
        ["canHaveCrafting"] = false,
        ["personalKeyAmount"] = 9999,
    }
}

Housing.interactionlist = {
    [1] = {
        ["name"] = "inventory_offset",
        ["event"] = {
            ["generalUse"] = {"",""},
            ["housingMain"] = {"to interact.","housing:inventory"},
            ["housingSecondary"] = {"",""}, 
        }
    },
    [2] = {
        ["name"] = "charChanger_offset",
        ["event"] = {
            ["generalUse"] = {"",""},
            ["housingMain"] = {"",""},
            ["housingSecondary"] = {"to swap char or ~g~/outfits~s~.","housing:charLogout"},
        }
    },
    [3] = {
        ["name"] = "backdoor_offset_internal",
        ["event"] = {
            ["generalUse"] = {"",""},
            ["housingMain"] = {"to exit","housing:internalBackdoor"},
            ["housingSecondary"] = {"",""},
        }
    },
    [4] = {
        ["name"] = "internal_exit",
        ["event"] = {
            ["generalUse"] = {"",""},
            ["housingMain"] = {"to exit","housing:exitFrontDoor"},
            ["housingSecondary"] = {"",""},
        }
    },
    [5] = {
        ["name"] = "crafting_offset",
        ["event"] = {
            ["generalUse"] = {"",""},
            ["housingMain"] = {"to craft.","housing:crafting"},
            ["housingSecondary"] = {"",""},
        }
    }
}

Housing.TO_TEXT = {
    ['v_int_36'] = 'Shop',
    ['ex_int_office_03b_dlc'] = 'Office',
    ['nopixel_trailer'] = 'Trailer',
    ['v_int_16_low'] = 'Flat',
    ['v_int_16_mid_empty'] = 'House',
    ['v_int_24'] = 'Large House',
    ['v_int_44_empty'] = 'Mansion',
    ['v_int_49_empty'] = 'Motel',
    ['v_int_61'] = 'Bungalow',
    ['ghost_stash_houses_01'] = 'Warehouse',
    ['np_warehouse_3'] = 'Large Warehouse',
    ['buisness_high'] = 'Dummy Housing',
    ['v_int_53'] = 'Shop High',
    ['empty_house_shop'] = 'Empty Shop'
  }
  

Housing.typeInfo = {
    ["v_int_36"] = {
        ["cat"] = "shop", 
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(0.0,0.0,0.0),
            length = 40.0,
            width = 30.0,
            minZ = 10.0,
            maxZ = 10.0,
            heading = 340.0
        } 
    },
    ["ex_int_office_03b_dlc"] = {
        ["cat"] = "office", 
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(0.49,0.48,1.02),
            length = 30.0,
            width = 40.0,
            minZ = 2.0,
            maxZ = 11.0,
            heading = 0.0
        } 
    },
    ["nopixel_trailer"] = {
        ["cat"] = "housing", 
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(0.0,0.0,0.0),
            length = 14.0,
            width = 14.0,
            minZ = 2.0,
            maxZ = 10.0,
            heading = 0.0
        }
    },
    ["v_int_16_low"] = {
        ["cat"] = "housing", 
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(0.85,-2.93,1.01),
            length = 16.0,
            width = 16.0,
            minZ = 2.0,
            maxZ = 10.0,
            heading = 0.0
        }
    },
    ["v_int_16_mid_empty"] = {
        ["cat"] = "housing", 
        ["percentage"] = 0,
        ["robberyCounterpart"] = "v_int_16_mid",
        ["exitOffset"] = vector3(3.76,-15.69,0.98),
        ["alarmOffset"] = vector3(3.57,-0.32,1.06),
        ["zone"] = {
            offset = vector3(2.26,-5.75,0.98),
            length = 24.0,
            width = 16.8,
            minZ = 3.00,
            maxZ = 10.0,
            heading = 0.0
        }
    },
    ["v_int_24"] = {
        ["cat"] = "housing", 
        ["percentage"] = 0,
        ["robberyCounterpart"] = "v_int_24_full",
        ["exitOffset"] = vector3(8.05,6.18,6.41),
        ["alarmOffset"] = vector3(9.64,1.88,6.80),
        ["zone"] = {
            offset = vector3(-2.94,-1.37,5.01),
            length = 23.0,
            width = 40.8,
            minZ = 8.0,
            maxZ = 10.0,
            heading = 0.0
        }
    }, 
    ["v_int_44_empty"] = {
        ["cat"] = "housing", 
        ["percentage"] = 0,
        ["robberyCounterpart"] = "v_int_44",
        ["exitOffset"] = vector3(-6.81,6.2,1.01),
        ["alarmOffset"] = vector3(1.85,3.88,1.16),
        ["zone"] = {
            offset = vector3(3.6,0.05,1.69),
            length = 25.0,
            width = 26.0,
            minZ = 2.0,
            maxZ = 10.0,
            heading = 0.0
        }
    },
    ["v_int_49_empty"] = {
        ["cat"] = "housing", 
        ["percentage"] = 0,
        ["robberyCounterpart"] = "v_int_49",
        ["exitOffset"] = vector3(-0.9,-3.54,1.01),
        ["alarmOffset"] = vector3(-1.89,-2.62,1.10),
        ["zone"] = {
            offset = vector3(0.41,-0.05,1.01),
            length = 10.0,
            width = 10.0,
            minZ = 2.0,
            maxZ = 6.0,
            heading = 0.0
        }
    },
    ["v_int_61"] = {
        ["cat"] = "housing", 
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(0.38,-0.27,1.02),
            length = 12.0,
            width = 22.0,
            minZ = 2.0,
            maxZ = 8.0,
            heading = 0.0
        }
    },
    ["ghost_stash_houses_01"] = {
        ["cat"] = "warehouse", 
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(-1.7,1.38,0.12),
            length = 13.0,
            width = 20.0,
            minZ = 2.0,
            maxZ = 8.0,
            heading = 0.0
        }
    },
    ["np_warehouse_3"] = {
        ["cat"] = "warehouse", 
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(0.0,0.0,0.0),
            length = 53.0,
            width = 50.0,
            minZ = 0.0,
            maxZ = 10.0,
            heading = 0.0
        }
    },
    ["v_int_16_high"] = {
        ["cat"] = "housing",
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(-2.41,3.25,5.82),
            length = 21.0,
            width = 35.0,
            minZ = 10.0,
            maxZ = 10.0,
            heading = 340.0
        }
    },
    ["buisness_high"] = {
        ["cat"] = "buisness",
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(0.0,0.0,0.0),
            length = 40.0,
            width = 30.0,
            minZ = 9.0,
            maxZ = 6.0,
            heading = 0.0
        }
    },

    ["v_int_53"] = {
        ["cat"] = "shop",
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(0.0,0.0,0.0),
            length = 40.0,
            width = 30.0,
            minZ = 9.0,
            maxZ = 6.0,
            heading = 0.0
        }
    },

    ["empty_house_shop"] = {
        ["cat"] = "shop",
        ["percentage"] = 0,
        ["zone"] = {
            offset = vector3(0.0,0.0,0.0),
            length = 60.0,
            width = 60.0,
            minZ = 40.0,
            maxZ = 40.0,
            heading = 0.0
        }
    },
}

--[[
    Pricing is done as follows 

    Base price for selling given for all zones 

    Each type of building is given a % that it will increase price based on ZoningPercentages be it + or -

    Should a certain type of housing in a certain zone want to adjust the precentage then adding that type of housing into a zone list will add that percentage be it + or -
]]
Housing.zoningPrices = {
    ["HARMO"] = { 
        ["baseSellPrice"] = 80000, 
        ["ownedInZonePercent"] = 0.8, 
        ["v_int_49_empty"] = 40, -- Motel 
        ["v_int_16_mid_empty"] = 90, -- House 
        ["nopixel_trailer"] = 0, -- Trailer 
    },

    ["PALETO"] = { 
        ["baseSellPrice"] = 130000, 
        ["ownedInZonePercent"] = 0.8, 
        ["v_int_49_empty"] = -50, -- Motel 
        ["v_int_16_low"] = 40, -- Flat 
        ["v_int_16_mid_empty"] = 0, -- House 
        ["v_int_61"] = 200, -- Bungalow 
        ["ghost_stash_houses_01"] = 40, -- Warehouse 
    },

    ["STRAW"] = { 
        ["baseSellPrice"] = 110000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_49_empty"] = 0, -- Motel 
        ["v_int_16_mid_empty"] = 100, -- House 
        ["shop"] = 120, -- Shop 
    },

    ["ROCKF"] = { 
        ["baseSellPrice"] = 1200000, 
        ["ownedInZonePercent"] = 3, 
        ["ex_int_office_03b_dlc"] = -72, -- Office 
        ["v_int_16_mid_empty"] = -87, -- House 
        ["v_int_24"] = 0, -- Large House 
        ["v_int_16_low"] = -81, -- Flat 
        ["v_int_44_empty"] = 9, -- Mansion 
    },

    ["HAWICK"] = { 
        ["baseSellPrice"] = 320000, 
        ["ownedInZonePercent"] = 5, 
        ["v_int_16_low"] = -32, -- Flat 
        ["ex_int_office_03b_dlc"] = -20, -- Office 
        ["v_int_16_mid_empty"] = -20, -- House 
        ["v_int_61"] = -10, -- Bungalow 
        ["ghost_stash_houses_01"] = 0, -- Warehouse 
    },

    ["PBLUFF"] = { 
        ["baseSellPrice"] = 1200000, 
        ["ownedInZonePercent"] = 2, 
        ["v_int_61"] = -71, -- Bungalow 
        ["v_int_16_low"] = -71, -- Flat 
        ["v_int_44_empty"] = 0, -- Mansion 
    },

    ["EAST_V"] = { 
        ["baseSellPrice"] = 480000, 
        ["ownedInZonePercent"] = 3, 
        ["v_int_61"] = 0, -- Bungalow 
        ["v_int_16_mid_empty"] = -52, -- House 
    },

    ["LEGSQU"] = { 
        ["baseSellPrice"] = 320000, 
        ["ownedInZonePercent"] = 2, 
        ["ex_int_office_03b_dlc"] = 0, -- Office 
    },

    ["DESRT"] = { 
        ["baseSellPrice"] = 80000, 
        ["ownedInZonePercent"] = 3, 
        ["nopixel_trailer"] = 0, -- Trailer 
        ["v_int_49_empty"] = 50, -- Motel 
        ["v_int_16_low"] = 120, -- Flat 
        ["v_int_16_mid_empty"] = 220, -- House 
        ["v_int_61"] = 300, -- Bungalow 
        ["ghost_stash_houses_01"] = 600, -- Warehouse 
    },

    ["DAVIS"] = { 
        ["baseSellPrice"] = 110000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_49_empty"] = 0, -- Motel 
        ["v_int_16_mid_empty"] = 100, -- House 
        ["shop"] = 300, -- Shop 
    },

    ["VCANA"] = { 
        ["baseSellPrice"] = 350000, 
        ["ownedInZonePercent"] = 5, 
        ["v_int_49_empty"] = -170, -- Motel 
        ["v_int_16_low"] = -80, -- Flat 
        ["v_int_61"] = -30, -- Bungalow 
        ["ghost_stash_houses_01"] = 0, -- Warehouse 
    },

    ["SANCHIA"] = { 
        ["baseSellPrice"] = 80000, 
        ["ownedInZonePercent"] = 2, 
        ["v_int_61"] = 20, -- Bungalow 
        ["v_int_16_mid_empty"] = 0, -- House 
    },

    ["VESP"] = { 
        ["baseSellPrice"] = 490000, 
        ["ownedInZonePercent"] = 2, 
        ["v_int_49_empty"] = -70, -- Motel 
        ["ghost_stash_houses_01"] = 0, -- Warehouse 
    },

    ["CHU"] = { 
        ["baseSellPrice"] = 80000, 
        ["ownedInZonePercent"] = 5, 
        ["v_int_16_mid_empty"] = 30, -- House 
        ["v_int_24"] = 130, -- Large House 
        ["v_int_61"] = 160, -- Bungalow 
        ["v_int_16_low"] = 0, -- Flat 
    },

    ["SLAB"] = { 
        ["baseSellPrice"] = 80000, 
        ["ownedInZonePercent"] = 5, 
        ["nopixel_trailer"] = 0, -- Trailer 
    },

    ["SANDY"] = { 
        ["baseSellPrice"] = 80000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_49_empty"] = 40, -- Motel 
        ["nopixel_trailer"] = 0, -- Trailer 
        ["v_int_16_mid_empty"] = 130, -- House 
        ["v_int_61"] = 160, -- Bungalow 
        ["v_int_16_low"] = 70, -- Flat 
    },

    ["CYPRE"] = { 
        ["baseSellPrice"] = 450000, 
        ["ownedInZonePercent"] = 4, 
        ["ghost_stash_houses_01"] = 0, -- Warehouse 
    },

    ["EBURO"] = { 
        ["baseSellPrice"] = 450000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_16_mid_empty"] = -52, -- House 
        ["ghost_stash_houses_01"] = 0, -- Warehouse 
    },

    ["MTGORDO"] = { 
        ["baseSellPrice"] = 2200000, 
        ["ownedInZonePercent"] = 10, 
        ["v_int_44_empty"] = 0, -- Mansion 
    },

    ["ELYSIAN"] = { 
        ["baseSellPrice"] = 100000, 
        ["ownedInZonePercent"] = 6, 
        ["np_warehouse_3"] = 300, -- Large Warehouse 
    },

    ["CHIL"] = { 
        ["baseSellPrice"] = 1200000, 
        ["ownedInZonePercent"] = 3, 
        ["v_int_24"] = -20, -- Large House 
        ["v_int_44_empty"] = 0, -- Mansion 
    },

    ["GREATC"] = { 
        ["baseSellPrice"] = 100000, 
        ["ownedInZonePercent"] = 1, 
        ["v_int_16_mid_empty"] = 0, -- House 
    },

    ["SanAnd"] = { 
        ["baseSellPrice"] = 850000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_44_empty"] = 0, -- Mansion 
    },

    ["TERMINA"] = { 
        ["baseSellPrice"] = 320000, 
        ["ownedInZonePercent"] = 2, 
        ["ex_int_office_03b_dlc"] = 0, -- Office 
    },

    ["RICHM"] = { 
        ["baseSellPrice"] = 1200000, 
        ["ownedInZonePercent"] = 3, 
        ["v_int_24"] = -20, -- Large House 
        ["v_int_44_empty"] = 0, -- Mansion 
    },

    ["MIRR"] = { 
        ["baseSellPrice"] = 480000, 
        ["ownedInZonePercent"] = 2, 
        ["v_int_16_mid_empty"] = 0, -- House 
        ["v_int_61"] = -38, -- Bungalow 
        ["v_int_44_empty"] = 70, -- Mansion 
    },

    ["RGLEN"] = { 
        ["baseSellPrice"] = 1200000, 
        ["ownedInZonePercent"] = 2, 
        ["v_int_44_empty"] = 0, -- Mansion 
    },

    ["GRAPES"] = { 
        ["baseSellPrice"] = 110000, 
        ["ownedInZonePercent"] = 3, 
        ["v_int_49_empty"] = -20, -- Motel 
        ["nopixel_trailer"] = -40, -- Trailer 
        ["v_int_16_mid_empty"] = 100, -- House 
        ["v_int_16_low"] = 0, -- Flat 
        ["ghost_stash_houses_01"] = 250, -- Warehouse 
    },

    ["DELPE"] = { 
        ["baseSellPrice"] = 300000, 
        ["ownedInZonePercent"] = 3, 
        ["v_int_49_empty"] = -70, -- Motel 
        ["ex_int_office_03b_dlc"] = -15, -- Office 
        ["v_int_16_mid_empty"] = -40, -- House 
        ["v_int_61"] = 15, -- Bungalow 
        ["v_int_44_empty"] = 90, -- Mansion 
    },

    ["TEXTI"] = { 
        ["baseSellPrice"] = 450000, 
        ["ownedInZonePercent"] = 3, 
        ["ex_int_office_03b_dlc"] = -28, -- Office 
        ["ghost_stash_houses_01"] = 0, -- Warehouse 
    },

    ["BEACH"] = { 
        ["baseSellPrice"] = 350000, 
        ["ownedInZonePercent"] = 2, 
        ["v_int_61"] = 0, -- Bungalow 
    },

    ["LMESA"] = { 
        ["baseSellPrice"] = 450000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_61"] = -20, -- Bungalow 
        ["ghost_stash_houses_01"] = 0, -- Warehouse 
    },

    ["WINDF"] = { 
        ["baseSellPrice"] = 80000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_16_mid_empty"] = 0, -- House 
    },

    ["BHAMCA"] = { 
        ["baseSellPrice"] = 350000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_61"] = -10, -- Bungalow 
        ["v_int_44_empty"] = 120, -- Mansion 
    },

    ["DTVINE"] = { 
        ["baseSellPrice"] = 1200000, 
        ["ownedInZonePercent"] = 3, 
        ["ex_int_office_03b_dlc"] = -72, -- Office 
        ["v_int_16_mid_empty"] = -87, -- House 
        ["v_int_24"] = 0, -- Large House 
        ["v_int_16_low"] = -81, -- Flat 
        ["ghost_stash_houses_01"] = -30, -- Warehouse 
    },

    ["MURRI"] = { 
        ["baseSellPrice"] = 450000, 
        ["ownedInZonePercent"] = 5, 
        ["ghost_stash_houses_01"] = 0, -- Warehouse 
    },

    ["OCEANA"] = { 
        ["baseSellPrice"] = 80000, 
        ["ownedInZonePercent"] = 2, 
        ["v_int_16_low"] = 0, -- Flat 
    },

    ["CHAMH"] = { 
        ["baseSellPrice"] = 110000, 
        ["ownedInZonePercent"] = 3, 
        ["v_int_49_empty"] = 0, -- Motel 
        ["v_int_16_mid_empty"] = 100, -- House 
        ["shop"] = 230, -- Shop 
    },

    ["ALTA"] = { 
        ["baseSellPrice"] = 320000, 
        ["ownedInZonePercent"] = 5, 
        ["ex_int_office_03b_dlc"] = 0, -- Office 
        ["v_int_16_low"] = -40, -- Flat 
    },

    ["WVINE"] = { 
        ["baseSellPrice"] = 1200000, 
        ["ownedInZonePercent"] = 4, 
        ["ex_int_office_03b_dlc"] = -22, -- Office 
        ["buisness_high"] = 99999999, -- Dummy Housing 
        ["v_int_24"] = -10, -- Large House 
        ["v_int_16_low"] = -81, -- Flat 
        ["v_int_44_empty"] = 0, -- Mansion 
    },

    ["TONGVAH"] = { 
        ["baseSellPrice"] = 900000, 
        ["ownedInZonePercent"] = 0, 
        ["v_int_24"] = 0, -- Large House 
    },

    ["MTCHIL"] = { 
        ["baseSellPrice"] = 300000, 
        ["ownedInZonePercent"] = 5, 
        ["v_int_61"] = 0, -- Bungalow 
    },

    ["KOREAT"] = { 
        ["baseSellPrice"] = 350000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_49_empty"] = -30, -- Motel 
        ["v_int_16_low"] = -10, -- Flat 
        ["v_int_61"] = 30, -- Bungalow 
        ["v_int_44_empty"] = 40, -- Mansion 
    },

    ["golf"] = { 
        ["baseSellPrice"] = 1200000, 
        ["ownedInZonePercent"] = 4, 
        ["v_int_24"] = -10, -- Large House 
        ["ex_int_office_03b_dlc"] = -72, -- Office 
        ["v_int_44_empty"] = 0, -- 3Mansion 
    },

    ["SKID"] = { 
        ["baseSellPrice"] = 320000, 
        ["ownedInZonePercent"] = 5, 
        ["ex_int_office_03b_dlc"] = 0, -- Office 
    },

    ["DELSOL"] = { 
        ["baseSellPrice"] = 490000, 
        ["ownedInZonePercent"] = 3, 
        ["v_int_16_mid_empty"] = -22, -- House 
        ["v_int_61"] = 0, -- Bungalow 
        ["ex_int_office_03b_dlc"] = -10, -- Office 
    },

    ["RANCHO"] = { 
        ["baseSellPrice"] = 110000, 
        ["ownedInZonePercent"] = 6, 
        ["v_int_49_empty"] = 0, -- Motel 
        ["ex_int_office_03b_dlc"] = 60, -- Office 
        ["v_int_16_mid_empty"] = 100, -- House 
        ["v_int_61"] = 140, -- Bungalow 
        ["ghost_stash_houses_01"] = 120, -- Warehouse 
    },

    ["PBOX"] = { 
        ["baseSellPrice"] = 320000, 
        ["ownedInZonePercent"] = 2, 
        ["ex_int_office_03b_dlc"] = 20, -- Office 
    },

    ["DOWNT"] = { 
        ["baseSellPrice"] = 1200000, 
        ["ownedInZonePercent"] = 5, 
        ["ex_int_office_03b_dlc"] = -52, -- Office 
        ["ghost_stash_houses_01"] = -35, -- Warehouse 
    },

    ["BURTON"] = { 
        ["baseSellPrice"] = 320000, 
        ["ownedInZonePercent"] = 5, 
        ["ex_int_office_03b_dlc"] = 0, -- Office 
    },

    ["MORN"] = {
        ["baseSellPrice"] = 1200000,
        ["ownedInZonePercent"] = 2,
        ["v_int_61"] = -71, -- Bungalow
        ["v_int_16_low"] = -71, -- Flat
        ["v_int_44_empty"] = 0, -- Mansion
    },
}




Housing.contract = [[]]


function getContractText(character, price,locationName,LocationType)

local string = string.format([[### Record of Transaction for home Purchase For the County of Los Santos
    
Seller Name: Los Santos State\
Buyer Name: %s
            
            
Address Being Sold : %s \
Description of Property Being Sold : %s \
Value of Property at Time of Sale: $ %s
        
#### Disclosure & Warranty:
        
The Seller certifies that the house is in GOOD REPAIR and that it is structurally sound and meets all code required by State Law.
        
Buyer agrees to the following:
        
* Purchase the home AS IS, and will make no claim against the seller for any defects/issues that arise after purchase. 
        
* Payments on the Property being sold will be due according to the invoice in the form of Property Tax.
        
* State SHALL NOT file for foreclosure until either
    * Two weeks have passed since last payment,
    * Buyer is confirmed to no longer reside within the county, or
    * Granted By a judge for foreclosure
        
* The Property is an asset and therefore falls under the ability for a given loan company and the state to take the property as collateral.
        
Full title and responsibility for all applicable state and local taxes, as well as HOA dues are  the sole responsibility of the Buyer.
    
CID #: %s \
Signature of Buyer: %s
            
Date: %s
    ]],
    character.first_name .. " " .. character.last_name,
    locationName,
    LocationType,
    price,
    character.id,
    character.first_name .. " " .. character.last_name,
    os.date("%Y, %b %d")
)

    return string
end

local ResourceName = GetCurrentResourceName()

AddEventHandler("np-config:configLoaded", function (configId, config)
    if configId ~= "np-housing" then return end

    Housing.max = config.max
end)

AddEventHandler(IsDuplicityVersion() and "onServerResourceStart" or "onClientResourceStart", function (resource)
    if resource ~= ResourceName then return end

    local config = exports["np-config"]:GetModuleConfig("np-housing")

    if not config or not config.max then return end

    Housing.max = config.max
end)