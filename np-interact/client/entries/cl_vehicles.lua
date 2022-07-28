local Entries = {}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_flip",
            label = _L("interact-flip-vehicle", "Flip Vehicle"),
            icon = "car-crash",
            event = "FlipVehicle",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 3.0 },
        isEnabled = function(pEntity, pContext)
            return not IsVehicleOnAllWheels(pEntity)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "carry_bike",
            label = _L("interact-carry-bike", "Carry Bike"),
            icon = "spinner",
            event = "carryEntity",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 3.0 },
        isEnabled = function(pEntity, pContext)
            return IsThisModelABicycle(pContext.model) and not IsEntityAttachedToAnyPed(pEntity) and not IsEntityAttachedToAnyPed(PlayerPedId())
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_getintrunk",
            label = _L("interact-enter-trunk", "Enter trunk"),
            icon = "user-secret",
            event = "np-police:vehicle:getInTrunk",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4.0 },
        isEnabled = function(pEntity, pContext)
            local lockStatus = GetVehicleDoorLockStatus(pEntity)
            return DoesVehicleHaveDoor(pEntity, 5) and isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model) and (lockStatus == 1 or lockStatus == 0 or lockStatus == 4) and not isEscorting
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_opentrunkinv",
            label = _L("interact-view-trunk", "View trunk"),
            icon = "truck-loading",
            event = "np-inventory:openTrunk",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4.0 },
        isEnabled = function(pEntity, pContext)
            local lockStatus = GetVehicleDoorLockStatus(pEntity)
            return DoesVehicleHaveDoor(pEntity, 5) and isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model) and (lockStatus == 1 or lockStatus == 0 or lockStatus == 4) and not isEscorting
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_putintrunk",
            label = _L("interact-enter-trunk", "Put in trunk"),
            icon = "user-secret",
            event = "np-police:vehicle:forceTrunkCheck",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4.0 },
        isEnabled = function(pEntity, pContext)
            local lockStatus = GetVehicleDoorLockStatus(pEntity)
            return DoesVehicleHaveDoor(pEntity, 5) and isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model) and (lockStatus == 1 or lockStatus == 0 or lockStatus == 4) and isEscorting
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_runplate",
            label = _L("interact-runplate", "Run Plate"),
            icon = "money-check",
            event = "clientcheckLicensePlate",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 7.0 },
        isEnabled = function(pEntity, pContext)
            return isPolice and (isCloseToHood(pEntity, PlayerPedId(), 2.0) or isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)) and not IsPedInAnyVehicle(PlayerPedId(), false)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_inspectvin",
            label = _L("interact-checkvin", "Check VIN"),
            icon = "sim-card",
            event = "vehicle:checkVIN",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 3.0 },
        isEnabled = function(pEntity, pContext)
            return isCloseToHood(pEntity, PlayerPedId(), 2.0) and (isPolice or isMedic) and not IsPedInAnyVehicle(PlayerPedId(), false)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_add_fakeplate",
            label = _L("interact-addfakeplate", "Add Fakeplate"),
            icon = "screwdriver",
            event = "vehicle:addFakePlate",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 3.0 },
        isEnabled = function(pEntity, pContext)
            return (isCloseToHood(pEntity, PlayerPedId(), 2.0) or isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)) and not IsPedInAnyVehicle(PlayerPedId(), false)
            and exports["np-vehicles"]:HasVehicleKey(pEntity) and exports["np-inventory"]:hasEnoughOfItem("fakeplate", 1, false, true)
            and not exports["np-vehicles"]:GetVehicleMetadata(pEntity, 'fakePlate')
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "inventory_open_hidden",
            label = _L("interact-open-compartment", "Open Compartment"),
            icon = "screwdriver",
            event = "inventory:open_hidden",
            parameters = {
            }
        }
    },
    options = {
        distance = { radius = 3.0 },
        isEnabled = function(pEntity, pContext)
            return (not IsPedInAnyVehicle(PlayerPedId(), false) and GetBoneDistance(pEntity, 2, 'wheel_rf') <= 1.7 and pContext.model == GetHashKey("mule") and exports["np-inventory"]:hasEnoughOfItem("homemadekey", 1, false)  )
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "inventory_hidden_scratches",
            label = _L("interact-loose-bolt", "Loose Bolt"),
            icon = "screwdriver",
            event = "inventory:open_hidden_fail",
            parameters = {
            }
        }
    },
    options = {
        distance = { radius = 3.0 },
        isEnabled = function(pEntity, pContext)
            return (not IsPedInAnyVehicle(PlayerPedId(), false) and GetBoneDistance(pEntity, 2, 'wheel_rf') <= 1.7 and pContext.model == GetHashKey("mule") and not exports["np-inventory"]:hasEnoughOfItem("homemadekey", 1, false)  )
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_remove_fakeplate",
            label = _L("interact-remove-fakeplate", "Remove Fakeplate"),
            icon = "ban",
            event = "vehicle:removeFakePlate",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 3.0 },
        isEnabled = function(pEntity, pContext)
            return (isCloseToBoot(pEntity, PlayerPedId(), 1.8, pContext.model) or pContext.model == `esv`) and not IsPedInAnyVehicle(PlayerPedId(), false)
            and exports["np-vehicles"]:HasVehicleKey(pEntity) and exports["np-vehicles"]:GetVehicleMetadata(pEntity, 'fakePlate')
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_examine",
            label = _L("interact-examine-veh", "Examine Vehicle"),
            icon = "wrench",
            event = "np:vehicles:examineVehicle",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 3.0, boneId = "engine" },
        isEnabled = function(pEntity, pContext)
            return isCloseToEngine(pEntity, PlayerPedId(), 3.0, pContext.model) and not bypassedNetVehicles[VehToNet(pEntity)]
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_refuel_station",
            label = _L("interact-refuel-veh", "Refuel Vehicle"),
            icon = "gas-pump",
            event = "vehicle:refuel:showMenu",
            parameters = {}
        }
    },
    options = {
        isEnabled = function(pEntity, pContext)
            return polyChecks.gasStation.isInside and canRefuelHere(pEntity, polyChecks.gasStation.polyData) and not bypassedNetVehicles[VehToNet(pEntity)]
        end
    }
}

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 2 },
  data = {
      {
          id = "vehicle_refuel_station_plane",
          label = _L("interact-refuel-veh", "Refuel Vehicle"),
          icon = "gas-pump",
          event = "vehicle:refuel:showMenu",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.0 },
      isEnabled = function(pEntity, pContext)
          local vehicleClass = GetVehicleClass(pEntity)
          if vehicleClass ~= 16 then return false end
          return polyChecks.gasStation.isInside
      end
  }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_refuel_station_boat",
            label = _L("interact-refuel-veh", "Refuel Vehicle"),
            icon = "gas-pump",
            event = "vehicle:refuel:showMenu",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 5.0 },
        isEnabled = function(pEntity, pContext)
            local vehicleClass = GetVehicleClass(pEntity)
            if vehicleClass ~= 14 then return false end
            return polyChecks.gasStation.isInside
        end
    }
}

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 2 },
  data = {
      {
          id = "vehicle_refuel_station_chopter",
          label = _L("interact-refuel-veh", "Refuel Vehicle"),
          icon = "gas-pump",
          event = "vehicle:refuel:showMenu",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 5.0 },
      isEnabled = function(pEntity, pContext)
          local vehicleClass = GetVehicleClass(pEntity)
          if vehicleClass ~= 15 then return false end
          return polyChecks.gasStation.isInside
      end
  }
}

-- Entries[#Entries + 1] = {
--     type = 'entity',
--     group = { 2 },
--     data = {
--         {
--             id = "vehicle_refuel_jerrycan",
--             label = _L("interact-refuel-veh", "Refuel Vehicle"),
--             icon = "gas-pump",
--             event = "vehicle:refuel:jerryCan",
--             parameters = {}
--         }
--     },
--     options = {
--         distance = { radius = 1.2, boneId = 'wheel_lr' },
--         isEnabled = function(pEntity, pContext)
--             return HasWeaponEquipped(883325847) -- WEAPON_PetrolCan
--         end
--     }
-- }

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_putinvehicle",
            label = _L("interact-vehicle-seatin", "seat in vehicle"),
            icon = "chevron-circle-left",
            event = "np-police:vehicle:seat",
            parameters = {}
        },
        {
            id = "vehicle_unseatnearest",
            label = _L("interact-vehicle-unseat", "unseat from vehicle"),
            icon = "chevron-circle-right",
            event = "np-police:vehicle:unseat",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4.0 },
        isEnabled = function(pEntity, pContext)
            return (not (isCloseToHood(pEntity, PlayerPedId()) or isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model))
              or pContext.model == GetHashKey("emsnspeedo"))
              and not IsPedInAnyVehicle(PlayerPedId(), false)
              and NetworkGetEntityIsNetworked(pEntity)
              and not bypassedNetVehicles[VehToNet(pEntity)]
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_keysgive",
            label = _L("interact-givekey", "give key"),
            icon = "key",
            event = "vehicle:giveKey",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 1.8 },
        isEnabled = function(pEntity, pContext)
            return hasKeys(pEntity) and not bypassedNetVehicles[VehToNet(pEntity)]
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_vinscratch",
            label = _L("interact-scratchvin", "scratch vin"),
            icon = "eye-slash",
            event = "np-boosting:scratchVehicleVin",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4 },
        isEnabled = function(pEntity, pContext)
            return pContext.meta ~= nil and pContext.meta.boostingInfo ~= nil and pContext.meta.boostingInfo.vinScratch
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_methdisturbdrop",
            label = _L("interact-intercept-goods-meth", "Intercept goods"),
            icon = "eye-slash",
            event = "np-meth:dropoff:cancelDropOff",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4 },
        isEnabled = function(pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId(), 1.1, false) and pContext.meta ~= nil and pContext.meta.dropoffInfo and pContext.meta.dropoffInfo.uuid and isPolice
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_methdrop",
            label = _L("interact-dropoff-goods-meth", "Drop off goods"),
            icon = "cubes",
            event = "np-meth:dropoff:doDropoff",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4 },
        isEnabled = function(pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId(), 1.1, false) and pContext.meta ~= nil and pContext.meta.dropoffInfo and pContext.meta.dropoffInfo.uuid
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isWheelchair' },
    data = {
        {
            id = "wheelchair",
            label = _L("interact-toggle-wheelchair", "toggle wheelchair"),
            icon = "wheelchair",
            event = "np:vehicle:wheelchair:control",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 0.9, boneId = 'misc_a' }
    }
}


Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isTowTruck' },
    data = {
        {
            id = "towtruck_tow",
            label = _L("interact-tow-veh", "tow vehicle"),
            icon = "trailer",
            event = "jobs:towVehicle",
            parameters = {}
        }
    },
    options = {
        job = { 'impound', 'pd_impound' },
        distance = { radius = 2.5, boneId = 'wheel_lr' },
        isEnabled = function (pEntity, pContext)
            return not pContext.flags['isTowingVehicle']
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isTowTruck' },
    data = {
        {
            id = "towtruck_untow",
            label = _L("interact-untow-veh", "untow vehicle"),
            icon = "trailer",
            event = "jobs:untowVehicle",
            parameters = {}
        }
    },
    options = {
        job = { 'impound', 'pd_impound' },
        distance = { radius = 2.5, boneId = 'wheel_lr' },
        isEnabled = function (pEntity, pContext)
            return pContext.flags['isTowingVehicle']
        end
    }
}

Entries[#Entries + 1] = {
    type = 'model',
    group = { GetHashKey('trash2') },
    data = {
        {
            id = "sanitation_worker_throw_trash",
            label = _L("interact-throwin-trash", "throw in trash"),
            icon = "trash-restore-alt",
            event = "np-jobs:sanitationWorker:vehicleTrash",
            parameters = {}
        }
    },
    options = {
        job = { 'sanitation_worker' },
        distance = { radius = 3.8, boneId = 'wheel_lr' },
        isEnabled = function (pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId(), 1.1, true)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'model',
    group = { GetHashKey('boxville7'), GetHashKey('pounder') },
    data = {
        {
            id = "dodo_deliveries_take_goods",
            label = _L("interact-grabgoods-deliveryjob", "Grab goods"),
            icon = "box",
            event = "np-jobs:dodo:takeGoods",
            parameters = {}
        }
    },
    options = {
        job = { 'dodo_deliveries' },
        distance = { radius = 5.0, boneId = 'wheel_lr' },
        isEnabled = function (pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId())
        end
    }
}

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 2 },
  data = {
      {
          id = "vehicle_buy_vehicle",
          label = _L("interact-sell-vehicle-ottos", "sell vehicle"),
          icon = "money-check-alt",
          NPXEvent = "np-ottosauto:vehicle:transaction",
          parameters = {
            business = "ottos_auto",
            action = "sell"
          }
      }
  },
  options = {
      distance = { radius = 1.8 },
      isEnabled = function(pEntity, pContext)
          return polyChecks.ottosAuto.isInside and hasJobPermission("ottos_auto") and CanSellOrBuyCar(pEntity, true)
      end
  }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_buy_vehicle_tuner",
            label = _L("interact-sell-vehicle-ottos", "sell vehicle"),
            icon = "money-check-alt",
            NPXEvent = "np-ottosauto:vehicle:transaction",
            parameters = {
              business = "tuner",
              action = "sell"
            }
        }
    },
    options = {
        distance = { radius = 1.8 },
        isEnabled = function(pEntity, pContext)
            return polyChecks.tuner.isInside and hasJobPermission("tuner", "buy_car") and CanSellOrBuyCar(pEntity, true)
        end
    }
  }

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 2 },
  data = {
      {
          id = "vehicle_sell_vehicle",
          label = _L("interact-buy-vehicle-ottos", "buy vehicle"),
          icon = "shopping-cart",
          NPXEvent = "np-ottosauto:vehicle:transaction",
          parameters = {
            business = "ottos_auto",
            action = "buy"
          }
      }
  },
  options = {
      distance = { radius = 1.8 },
      isEnabled = function(pEntity, pContext)
        return polyChecks.ottosAuto.isInside and hasJobPermission("ottos_auto", "buy_car") and CanSellOrBuyCar(pEntity, false)
      end
  }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_sell_vehicle_tuner",
            label = _L("interact-buy-vehicle-ottos", "buy vehicle"),
            icon = "shopping-cart",
            NPXEvent = "np-ottosauto:vehicle:transaction",
            parameters = {
              business = "tuner",
              action = "buy"
            }
        }
    },
    options = {
        distance = { radius = 1.8 },
        isEnabled = function(pEntity, pContext)
          return polyChecks.tuner.isInside and hasJobPermission("tuner", "buy_car") and CanSellOrBuyCar(pEntity, false)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_tamperedwith",
            label = _L("interact-check-veh-tampering", "check for tampering signs"),
            icon = "unlink",
            event = "np-vehicles:checkTampering",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 1.8 },
        job = { 'police' },
        isEnabled = function(pEntity, pContext)
            return isCloseToDriverDoor(pEntity, PlayerPedId(), 1.5)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'model',
    group = { GetHashKey('bcat') },
    data = {
        {
            id = "rhino-open-armory",
            label = _L("interact-open-armory", "open armory"),
            icon = "shopping-cart",
            event = "np-police:client:openRhinoArmoy",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 7.0 },
        isEnabled = function (pEntity, pContext)
            return isPolice and (isCloseToHood(pEntity, PlayerPedId(), 2.0) or isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)) and not IsPedInAnyVehicle(PlayerPedId(), false)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_defusebomb",
            label = _L("interact-defusecarbomb", "Defuse Car Bomb"),
            icon = "cut",
            event = "np-miscscripts:carBombs:removeBomb",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 1.8 },
        isEnabled = function(pEntity, pContext)
            return
            pContext.meta ~= nil and
            pContext.meta.carBombData ~= nil and
            pContext.meta.carBombData.found
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_pickup_rc",
            label = _L("interact-pickup-rc", "pickup"),
            icon = "people-carry",
            event = "np-rcvehicles:pickupCar",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 1.8 },
        isEnabled = function(pEntity, pContext)
            return pContext.model == `rcbandito` and #GetEntityVelocity(pEntity) < 0.2 and bypassedNetVehicles[VehToNet(pEntity)]
        end
    }
}

-- custom car clothing
local inClothingShop = false
AddEventHandler("np-polyzone:enter", function(pName)
  if pName ~= "custom_car_clothing" then return end
  inClothingShop = true
end)
AddEventHandler("np-polyzone:exit", function(pName)
  if pName ~= "custom_car_clothing" then return end
  inClothingShop = false
end)
Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_clothing_save",
            label = "Save Current Outfit",
            icon = "plus",
            event = "np-car-clothing:saveCurrentOutfit",
            parameters = {},
        },
        {
            id = "vehicle_clothing_swap",
            label = "Swap Current Outfit",
            icon = "redo",
            event = "np-car-clothing:swapCurrentOutfit",
            parameters = {},
        },
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function(pEntity, pContext)
            return inClothingShop
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_heroindisturbdrop",
            label = "Intercept goods",
            icon = "eye-slash",
            event = "np-heroin:seeds:cancelSeeds",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4 },
        isEnabled = function(pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId(), 1.1, false) and pContext.meta ~= nil and pContext.meta.seedsInfo and pContext.meta.seedsInfo.uuid and isPolice
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_heroindrop",
            label = "drop off goods",
            icon = "cubes",
            event = "np-heroin:seeds:doDropoff",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4 },
        isEnabled = function(pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId(), 1.1, false) and pContext.meta ~= nil and pContext.meta.seedsInfo and pContext.meta.seedsInfo.uuid
        end
    }
}





-- local stockadeHash = `STOCKADE`
-- Entries[#Entries + 1] = {
--   type = 'entity',
--   group = { 2 },
--   data = {
--       {
--           id = "moneytruckthermite",
--           label = "Use Thermite",
--           icon = "circle",
--           event = "np-heists:bobcatThermiteMoneyTruckDoor",
--           parameters = {}
--       }
--   },
--   options = {
--       distance = { radius = 8.0 },
--       isEnabled = function(pEntity, pContext)
--           return pContext.model == stockadeHash
--             and isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)
--             and not DecorGetBool(pEntity, "BobcatMoneyTruck")
--             and exports["np-inventory"]:hasEnoughOfItem("thermitecharge", 1, false, true)
--       end
--   }
-- }

-- Entries[#Entries + 1] = {
--   type = 'entity',
--   group = { 2 },
--   data = {
--       {
--           id = "moneytruckloot",
--           label = "Take Goods",
--           icon = "circle",
--           event = "np-heists:bobcatMoneyTruckTakeGoods",
--           parameters = {}
--       }
--   },
--   options = {
--       distance = { radius = 8.0 },
--       isEnabled = function(pEntity, pContext)
--           return pContext.model == stockadeHash
--             and isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)
--             and DecorGetBool(pEntity, "BobcatMoneyTruck")
--       end
--   }
-- }

Citizen.CreateThread(function()
    for _, entry in ipairs(Entries) do
        if entry.type == 'flag' then
            AddPeekEntryByFlag(entry.group, entry.data, entry.options)
        elseif entry.type == 'model' then
            AddPeekEntryByModel(entry.group, entry.data, entry.options)
        elseif entry.type == 'entity' then
            AddPeekEntryByEntityType(entry.group, entry.data, entry.options)
        elseif entry.type == 'polytarget' then
            AddPeekEntryByPolyTarget(entry.group, entry.data, entry.options)
        end
    end
end)
