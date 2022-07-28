local LastSpawnAttempt, LastRespawn, SpawnDrawing = nil, nil, false

local function getVehicleClassification(pVehicleModel)
  local vehicleClass = GetVehicleClassFromName(pVehicleModel)
  if vehicleClass == 13 then
    return "bicycle"
  elseif vehicleClass == 14 then
    return "boat"
  else
    return "car"
  end
end

RegisterUICallback("np-ui:getCars", function(data, cb)
  local data = RPC.execute("np:vehicles:getPlayerVehiclesWithCoordinates", data.character.id)
  local playerCoords = GetEntityCoords(PlayerPedId())
  for _, car in pairs(data) do
    if car.location then
      local vehicleCoords = vector3(car.location.x, car.location.y, car.location.z)

      if car.parking_state == 'out' and #(vehicleCoords - playerCoords) < 5.0 then
        car.spawnable = true
        car.sellable = true
      end
    else
      print('ERROR GETTING THE LOCATION OF THE VEHICLE', car.parking_garage, car.plate, car.location)
    end

    car.type = getVehicleClassification(car.model)
  end
  cb({ data = data, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:carActionTrack", function(data, cb)
  local vehicleCoords = data.car.location
  if not vehicleCoords then return end
  SetNewWaypoint(vehicleCoords.x, vehicleCoords.y)

  local plyCoords = GetEntityCoords(PlayerPedId())
  if not SpawnDrawing and #(plyCoords - vector3(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)) < 200.0 then
    SpawnDrawing = true
    SetTimeout(30000, function()
      SpawnDrawing = false
    end)
    Citizen.CreateThread(function()
      while SpawnDrawing do
        DrawMarker(36, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 0, 0, 0, 0, 0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, true, true, 0, false, nil, nil, false)
        Wait(0)
      end
    end)
  end

  TriggerEvent('DoLongHudText',"GPS updated.")
  cb({ data = {}, meta = { ok = true, message = '' } })
end)

RegisterUICallback("np-ui:carActionSpawn", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' }})

  local vehicle_plate = data.car

  local timer = GetGameTimer()

  if LastSpawnAttempt and (timer - LastSpawnAttempt) < 1000 or LastRespawn and (timer - LastRespawn) < 60000 then return end

  LastSpawnAttempt = timer

  local success, message = table.unpack(RPC.execute('np:vehicles:respawnVehicle', vehicle_plate))

  if success then
    SpawnDrawing = false
    LastRespawn = timer
  else
    TriggerEvent('DoLongHudText', message, 2)
  end
end)


function canCarSpawn(pLicensePlate)
  if IsPedInAnyVehicle(PlayerPedId(), false) then
    return false, "You're in a car."
  end

  local fakePlate = nil
  if fakePlates[pLicensePlate] ~= nil then
    fakePlate = fakePlates[pLicensePlate]
  end

  local DoesVehExistInProximity = nil
  if fakePlate ~= nil then
    DoesVehExistInProximity = CheckExistenceOfVehWithPlate(fakePlate)
    fakePlates[pLicensePlate] = nil
  else
    DoesVehExistInProximity = CheckExistenceOfVehWithPlate(pLicensePlate)
  end

  return not DoesVehExistInProximity
end

function CheckExistenceOfVehWithPlate(pLicensePlate)
  local playerCoords = GetEntityCoords(PlayerPedId())
  local vehicleHandle, scannedVehicle = FindFirstVehicle()
  local success
  repeat
      local pos = GetEntityCoords(scannedVehicle)
      local distance = #(playerCoords - pos)
        if distance < 50.0 then
          local targetVehiclePlate = GetVehicleNumberPlateText(scannedVehicle)
          if targetVehiclePlate == pLicensePlate then
            return true
          end
        end
      success, scannedVehicle = FindNextVehicle(vehicleHandle)
  until not success
  EndFindVehicle(vehicleHandle)
  return false
end

RegisterUICallback("np-ui:carActionSell", function(data, cb)
  local vehicleCoords = data.car.location
  if not vehicleCoords then return end
  TriggerEvent('np:vehicles:sellPhone', data.car.vin, data.stateId, data.price + 0.0)
  cb({ data = {}, meta = { ok = true, message = '' } })
end)
