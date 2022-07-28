local GeneralEntries = MenuEntries["general"]

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "vehicles",
    title = _L("menu-general-vehicle", "Vehicle"),
    icon = "#vehicle-options-vehicle",
    event = "veh:options"
  },
  isEnabled = function(pEntity, pContext)
      return not IsDisabled() and IsPedInAnyVehicle(PlayerPedId(), false)
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "vehicles-keysgive",
    title = _L("menu-general-givekeys", "Give Keys"),
    icon = "#general-keys-give",
    event = "vehicle:giveKey"
},
isEnabled = function(pEntity, pContext)
    return not IsDisabled() and IsPedInAnyVehicle(PlayerPedId(), false) and exports["np-vehicles"]:HasVehicleKey(GetVehiclePedIsIn(PlayerPedId(), false))
end
}


GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "atc-set-flight-data",
      title = _L("menu-vehicles-set-flight-data", "Flight Data"),
      icon = "#vehicle-flight-data",
      event = "np-atc:setFlightData"
  },
  isEnabled = function(pEntity, pContext)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed)

    if vehicle == 0 then return false end

    local vehicleClass = GetVehicleClass(vehicle)

    return not IsDisabled() and (vehicleClass == 15 or vehicleClass == 16) and (GetPedInVehicleSeat(vehicle, -1) == playerPed or GetPedInVehicleSeat(vehicle, 0) == playerPed)
  end
}


-- change to keybind?
-- GeneralEntries[#GeneralEntries+1] = {
--     data = {
--         id = "vehicles-doorKeyFob",
--         title = "Door KeyFob",
--         icon = "#general-door-keyFob",
--         event = "np-doors:doorKeyFob"
--     },
--     isEnabled = function(pEntity, pContext)
--         return not IsDisabled() and IsPedInAnyVehicle(PlayerPedId(), false) and exports["np-inventory"]:hasEnoughOfItem("keyfob", 1, false)
--     end
-- }

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "peds-escort",
    title = _L("menu-general-stopescorting", "Stop escorting"),
    icon = "#general-escort",
    event = "np-police:drag:stopForced"
  },
  isEnabled = function(pEntity, pContext)
      return not IsDisabled() and isEscorting
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "oxygentank",
    title = _L("menu-general-removeoxygentank", "Remove Oxygen Tank"),
    icon = "#oxygen-mask",
    event = "RemoveOxyTank"
  },
  isEnabled = function(pEntity, pContext)
      return not IsDisabled() and hasOxygenTankOn
  end
}


GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "policeDeadA",
    title = _L("menu-general-1013A", "10-13A"),
    icon = "#police-dead",
    event = "police:tenThirteenA",
  },
  isEnabled = function(pEntity, pContext)
      return isDead and (isPolice or isDoc)
  end
}


GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "policeDeadB",
    title = _L("menu-general-1013B", "10-13B"),
    icon = "#police-dead",
    event = "police:tenThirteenB",
  },
  isEnabled = function(pEntity, pContext)
    return isDead and (isPolice or isDoc)
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "emsDeadA",
    title = _L("menu-general-1014A", "10-14A"),
    icon = "#ems-dead",
    event = "police:tenForteenA",
  },
  isEnabled = function(pEntity, pContext)
    return isDead and isMedic
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "emsDeadB",
    title = _L("menu-general-1014B", "10-14B"),
    icon = "#ems-dead",
    event = "police:tenForteenB",
  },
  isEnabled = function(pEntity, pContext)
    return isDead and isMedic
  end
}


GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "unseat",
    title = _L("menu-general-chairgetup", "Get up"),
    icon = "#obj-chair",
    event = "np-emotes:sitOnChair"
  },
  isEnabled = function(pEntity, pContext)
    return not isDead and exports["np-flags"]:HasPedFlag(PlayerPedId(), "isSittingOnChair")
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "property-enter",
    title = _L("menu-general-enterproperty", "Enter Property"),
    icon = "#property-enter",
    event = "housing:interactionTriggered"
  },
  isEnabled = function(pEntity, pContext)
    return not isDead and exports["np-housing"]:isNearProperty()
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "property-lock",
    title = _L("menu-general-togglepropertylock", "Unlock/Lock Property"),
    icon = "#property-lock",
    event = "housing:toggleClosestLock"
  },
  isEnabled = function(pEntity, pContext)
    return not isDead and exports["np-housing"]:isNearProperty(true)
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "vehicle-vehicleList",
      title = _L("menu-general-vehiclelist", "Vehicle List"),
      icon = "#vehicle-vehicleList",
      event = "vehicle:garageVehicleList",
      parameters = { nearby = true, radius = 4.0 }
  },
  isEnabled = function(pEntity, pContext)
    return not IsDisabled() and not IsPedInAnyVehicle(PlayerPedId()) and (pEntity and pContext.flags["isVehicleSpawner"] or not pEntity and exports["np-vehicles"]:IsOnParkingSpot(PlayerPedId(), true, 4.0))
  end
}

local canDropGoods = false

AddEventHandler("np-jobs:dodo:canDropGoods", function(allowed)
  canDropGoods = allowed
end)

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "job-drop-goods",
    title = _L("menu-general-dropgoods", "Deliver Goods"),
    icon = "#property-lock",
    event = "np-jobs:dodo:dropGoods",
  },
  isEnabled = function(pEntity, pContext)
    return canDropGoods
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "dispatch:openDispatch",
      title = _L("menu-general-dispatch", "Dispatch"),
      icon = "#general-check-over-target",
      event = "np-dispatch:openFull"
  },
  isEnabled = function()
      return (isPolice or isMedic) and not isDead
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "judge-raid:lockdown",
      title = _L("menu-general-togglelockdownproperty", "Toggle Lockdown Property"),
      icon = "#judge-raid-lock-down",
      event = "property:menuAction",
      parameters = {action = "lockdown"}
  },
  isEnabled = function(pEntity, pContext)
      return not isDead and isPolice and exports["np-housing"]:isNearProperty(false)
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "emotes:openmenu",
      title = _L("menu-general-emotes", "Emotes"),
      icon = "#general-emotes",
      event = "emotes:OpenMenu"
  },
  isEnabled = function(pEntity, pContext)
      return not isDead
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "drivingInstructor:testToggle",
      title = _L("menu-general-drivingtest", "Driving Test"),
      icon = "#drivinginstructor-drivingtest",
      event = "drivingInstructor:testToggle"
  },
  isEnabled = function(pEntity, pContext)
      return not isDead and isInstructorMode
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "drivingInstructor:submitTest",
      title = _L("menu-general-submittest", "Submit Test"),
      icon = "#drivinginstructor-submittest",
      event = "drivingInstructor:submitTest"
  },
  isEnabled = function(pEntity, pContext)
      return not isDead and isInstructorMode
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "general:checkoverself",
      title = _L("menu-general-examineself", "Examine Self"),
      icon = "#general-check-over-self",
      event = "Evidence:CurrentDamageList"
  },
  isEnabled = function(pEntity, pContext)
      return not isDead
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "bennys:enter",
      title = _L("menu-general-enterbennys", "Enter Bennys"),
      icon = "#general-check-vehicle",
      event = "bennys:enter"
  },
  isEnabled = function(pEntity, pContext)
      return not IsDisabled() and polyChecks.bennys.isInside and IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "toggle-anchor",
    title = _L("menu-general-toggleanchor", "Toggle Anchor"),
    icon = "#vehicle-anchor",
    event = "mka-anchor:toggleAnchor"
  },
  isEnabled = function(pEntity, pContext)
    local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local boatModel = GetEntityModel(currentVehicle)
    return not IsDisabled() and currentVehicle ~= 0 and (IsThisModelABoat(boatModel) or IsThisModelAJetski(boatModel) or IsThisModelAnAmphibiousCar(boatModel) or IsThisModelAnAmphibiousQuadbike(boatModel))
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "mdw",
    title = _L("menu-general-mdw", "MDW"),
    icon = "#mdt",
    event = "np-ui:openMDW"
  },
  isEnabled = function()
    return (
          myJob == "district attorney"
      or  myJob == "doctor"
      or  myJob == "defender"
      or  isPolice or isDoc or isMedic or isDoctor or isJudge or isMayor or isCountyClerk
    ) and not isDead
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "prepare-boat-mount",
      title = _L("menu-general-mounttrailer", "Mount on Trailer"),
      icon = "#vehicle-plate-remove",
      event = "vehicle:mountBoatOnTrailer"
  },
  isEnabled = function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    if veh == 0 then
      return false
    end
    local seat = GetPedInVehicleSeat(veh, -1)
    if seat ~= ped then
      return false
    end
    local model = GetEntityModel(veh)
    if IsDisabled() or not (IsThisModelABoat(model) or IsThisModelAJetski(model) or IsThisModelAnAmphibiousCar(model)) then
      return false
    end
    local left, right = GetModelDimensions(model)
    return #(vector3(0, left.y, 0) - vector3(0, right.y, 0)) < 15
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "prison-task",
    title = _L("menu-general-prison-currenttask", "Current Task"),
    icon = "#prisoner-task",
    event = "np-jail:showCurrentTask"
  },
  isEnabled = function()
    return (
      polyChecks.prison.isInside
      and not isDoc
      and not isPolice
      and not isDead
      and isPrisoner
    )
  end
}

-- GeneralEntries[#GeneralEntries+1] = {
--   data = {
--       id = "prepare-boat-mount1",
--       title = "Mount on Trailer",
--       icon = "#vehicle-plate-remove",
--       event = "vehicle:mountCarOnTrailer"
--   },
--   isEnabled = function(pEntity)

--     return pEntity ~= 0
--   end
-- }

-- AddEventHandler("vehicle:mountCarOnTrailer", function(a, pEntity)
--   if GetVehicleDoorAngleRatio(pEntity, 5) == 0 then
--     SetVehicleDoorOpen(pEntity, 5, 0, 0)
--   else
--     SetVehicleDoorShut(pEntity, 5, 0)
--   end
--   -- SetCarBootOpen(pEntity)
--   SetVehicleOnGroundProperly(pEntity)
--   -- SetEntityCoords(pEntity, GetEntityCoords(pEntity).x, GetEntityCoords(pEntity).y, GetEntityCoords(pEntity).z + 0.05, 0, 0, 0, 1)
-- end)

local currentJob = nil
local policeModels = {
  [`npolvic`] = true,
  [`npolexp`] = true,
  [`npolmm`] = true,
  [`npolvette`] = true,
  [`npolchal`] = true,
  [`npolstang`] = true,
  [`npolchar`] = true,
}
RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    currentJob = job
end)
GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "open-rifle-rack",
      title = _L("menu-general-riflerack", "Locked Storage"),
      icon = "#vehicle-plate-remove",
      event = "vehicle:openRifleRack"
  },
  isEnabled = function(pEntity)
    if currentJob ~= "police" then return false end
    local veh = GetVehiclePedIsIn(PlayerPedId())
    if veh == 0 then return false end
    local model = GetEntityModel(veh)
    if policeModels[model] == nil then return false end
    return true
  end
}
AddEventHandler("vehicle:openRifleRack", function()
  local finished = exports["np-taskbar"]:taskBar(2500, _L("menu-misc-unlocking-text", "Unlocking..."))
  if finished ~= 100 then return end
  local veh = GetVehiclePedIsIn(PlayerPedId())
  if veh == 0 then return end
  local vehId = exports["np-vehicles"]:GetVehicleIdentifier(veh)
  TriggerEvent("server-inventory-open", "1", "rifle-rack-" .. vehId)
end)

local dashCamAttached = {}
AddEventHandler("np-menu:dashCamAttached", function(pVehicleNetId, pEnabled)
  dashCamAttached[pVehicleNetId] = pEnabled
end)
GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "remove-dashcam-from-vehicle",
      title = _L("menu-general-removedashcam", "Remove Dashcam"),
      icon = "#news-job-news-camera",
      event = "np-gopro:removeDashCam",
  },
  isEnabled = function()
    local veh = GetVehiclePedIsIn(PlayerPedId())
    local netId = NetworkGetNetworkIdFromEntity(veh)
    return not IsDisabled() and dashCamAttached[netId]
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "civDead",
    title = _L("menu-general-callforhelp", "Call for Help"),
    icon = "#police-dead",
    event = "ragdoll:sendPing",
  },
  isEnabled = function(pEntity, pContext)
      return (not IN_SERVER_FARM) and isDead and not (isPolice or isDoc)
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "civDead",
    title = _L("menu-general-uselocalems", "Use Local EMS"),
    icon = "#police-dead",
    event = "ragdoll:respawnLocal",
  },
  isEnabled = function(pEntity, pContext)
      return (not IN_SERVER_FARM) and isDead and exports["ragdoll"]:allowRespawn()
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "civEject",
    title = _L("menu-general-ejectvehicle", "Self Eject"),
    icon = "#vehicle-plate-remove",
    event = "ragdoll:ejectVehicle",
  },
  isEnabled = function(pEntity, pContext)
      local ped = PlayerPedId()
      local plyVeh = GetVehiclePedIsIn(ped, false)
      local IsDriver = GetPedInVehicleSeat(plyVeh, -1) == ped
      return (not IN_SERVER_FARM) and isDead and plyVeh and IsDriver
  end
}

AddEventHandler("np-menu:var:inServerFarm", function(pBool)
  IN_SERVER_FARM = pBool
end)
GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "varLeave",
    title = _L("menu-general-leaveVar", "Exit VAR"),
    icon = "#news-job-news-camera",
    event = "np-heists-serverroom:vr-room-exit",
  },
  isEnabled = function(pEntity, pContext)
      return IN_SERVER_FARM
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
      id = "vehicle-garageActions",
      title = _L("menu-general-garageactions", "Garage Actions"),
      icon = "#vehicle-vehicleList",
      event = "np-vehicles:openGarageActions",
      parameters = { nearby = true, radius = 4.0 }
  },
  isEnabled = function(pEntity, pContext)
    return not IsDisabled() and (isPolice or isJudge) and not IsPedInAnyVehicle(PlayerPedId()) and (pEntity and pContext.flags["isVehicleSpawner"] or not pEntity and exports["np-vehicles"]:IsOnParkingSpot(PlayerPedId(), true, 4.0))
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "infDead",
    title = _L("menu-general-infDead", "Respawn Menu"),
    icon = "#infected-icon",
    event = "np-outbreak:openRespawnMenu",
  },
  isEnabled = function(pEntity, pContext)
      return isDead and isInfected
  end
}

GeneralEntries[#GeneralEntries+1] = {
  data = {
    id = "humanDead",
    title = _L("menu-general-humeanDead", "Respawn As Infected"),
    icon = "#infected-icon",
    event = "np-outbreak:openRespawnMenu",
    parameters = { fromHuman = true }
  },
  isEnabled = function(pEntity, pContext)
      return isDead and not isInfected and isOutbreakRunning
  end
}
