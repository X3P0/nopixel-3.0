local carBombActive = false
local carHasBomb = false
local listening = false
local bombTick = 0
local duration = 0

local function getVehicleSpeed(pEntity)
  return GetEntitySpeed(pEntity) * 2.236936
end

local function doTickNoise(pEntity)
	PlaySoundFromEntity(-1, 'Beep_Red', pEntity, 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true, 10)
  bombTick = bombTick + 1
end

local function stopTickNoise(pEntity)
  bombTick = 0
end

local function resetCarBombState()
  listening = false
  carBombActive = false
  carHasBomb = false
  bombTick = 0
  duration = 0
end

local function explodeVehicle(pEntity)
  exports['np-sync']:SyncedExecution('NetworkExplodeVehicle', pEntity, 1, 0, 0)
  TriggerServerEvent('np-miscscripts:carbombs:removeBomb', NetworkGetNetworkIdFromEntity(pEntity))
end

local function listenForBombTick(pEntity, pMinSpeed, pTicksBeforeExplode, pTicksForRemoval)
  if listening then return end

  listening = true
  Citizen.CreateThread(function()
    while listening do
      if not DoesEntityExist(pEntity) then
        resetCarBombState()
        break
      end

      -- Set the bomb active now so we can listen for ticks
      if carHasBomb and not carBombActive and getVehicleSpeed(pEntity) > pMinSpeed then
        carBombActive = true
        TriggerEvent('DoLongHudText', 'Bomb activated - Do not leave the vehicle - SPEED', 1, 10000)
      end

      if duration >= pTicksForRemoval then
        resetCarBombState()
        TriggerEvent('DoLongHudText', 'Bomb deactivated', 1, 10000)
        TriggerServerEvent('np-miscscripts:carbombs:removeBomb', NetworkGetNetworkIdFromEntity(pEntity))
        break
      end

      -- If they are moving less than the speed limit start ticking
      if carBombActive and getVehicleSpeed(pEntity) < pMinSpeed  then
        doTickNoise(pEntity)
      elseif getVehicleSpeed(pEntity) > pMinSpeed and bombTick > 0 then
        stopTickNoise(pEntity)
      end

      if bombTick > pTicksBeforeExplode then
        resetCarBombState()
        explodeVehicle(pEntity)
      end
      
      duration = duration + 1
      Wait(1000)
    end
  end)
end

local function checkForCarBomb(pEntity) 
  if not DoesEntityExist(pEntity) then return end

  TriggerEvent('animation:PlayAnimation', 'search')

  local progress = exports['np-taskbar']:taskBar(25000, 'Searching for car bomb...', true)
  ClearPedTasks(PlayerPedId())

  if progress ~= 100 then return end

  local metaData = exports['np-vehicles']:GetVehicleMetadata(pEntity)
  local carBombMeta = metaData.carBombData or false
  local remoteBomb = NPX.Procedures.execute('np-usableprops:hasPhoneBomb', NetworkGetNetworkIdFromEntity(pEntity))

  if remoteBomb and remoteBomb.planted then
    local number = remoteBomb.bomb.number
    TriggerServerEvent('np-usableprops:defusePhoneBomb', number)
    TriggerEvent('np-police:client:showTextPopup', { show = true, text = 'Cell Phone Found, Number: ' .. number })
    TriggerEvent("player:receiveItem", "phonebombdefused", 1)
    return TriggerEvent('DoLongHudText', 'Looks like there is a phone bomb on this vehicle', 1)
  end

  if carBombMeta and carBombMeta.hasCarBomb then
    TriggerServerEvent('np-miscscripts:carbombs:foundBomb', NetworkGetNetworkIdFromEntity(pEntity), carBombMeta)
    return TriggerEvent('DoLongHudText', 'Looks like there is a car bomb on this vehicle', 1)
  end

  return TriggerEvent('DoLongHudText', 'There seems to be no bomb on this vehicle.', 1)
end

AddEventHandler('baseevents:enteredVehicle', function (pEntity, pSeat, pName, pClass, pModel)
  if pSeat ~= -1 then return end

  local metaData = exports['np-vehicles']:GetVehicleMetadata(pEntity)
  if metaData == nil then return end

  local carBombMeta = metaData.carBombData or false

  if carBombMeta and carBombMeta.hasCarBomb and not carBombActive then
    -- print('[miscscripts] Entered vehicle with car bomb')
    listenForBombTick(pEntity, carBombMeta.minSpeed, carBombMeta.ticksBeforeExplode, carBombMeta.ticksForRemoval)
    carHasBomb = true
  end
end)

AddEventHandler('baseevents:leftVehicle', function (pEntity, pSeat, pName, pClass, pModel)
  local metaData = exports['np-vehicles']:GetVehicleMetadata(pEntity)
  if metaData == nil then return end
  
  local carBombMeta = metaData.carBombData or false

  if carBombMeta and carBombMeta.hasCarBomb and carBombActive then
    resetCarBombState()
    explodeVehicle(pEntity)
  end

  -- At this point they should have blown up if they had a bomb else reset state
  resetCarBombState()
end)

AddEventHandler('np-inventory:itemUsed', function (name, info)
  local items = {
    ['car_bomb'] = true,
    ['bombmirror'] = true,
  }

  if not items[name] then return end

  local vehicle = exports['isPed']:TargetVehicle()
  if vehicle == 0 then return end

  if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(vehicle), false) > 3.0 then return end
  
  if name == 'bombmirror' then
    return checkForCarBomb(vehicle)  
  end

  TriggerEvent('animation:PlayAnimation', 'kneel')

  local elements = {
    { name = 'minSpeed', label = 'Min Speed (MPH)', icon = 'time', _type = 'number' },
    { name = 'ticksBeforeExplode', label = 'Ticks before explosion (Seconds)', icon = 'time', _type = 'number' },
    { name = 'ticksForRemoval', label = 'Removal Length (Seconds)', icon = 'time', _type = 'number' },
    { name = "gridSize", label = "Grid Size (5-12)", icon = "time", _type = "number" },
    { name = "coloredSquares", label = "Colored Sqaures (5-20)", icon = "time", _type = "number" },
    { name = "timeToComplete", label = "Time To Complete (10-30 Seconds)", icon = "time", _type = "number" },
  }

  local prompt = exports['np-ui']:OpenInputMenu(elements)

  if not prompt then 
    ClearPedTasks(PlayerPedId())
    return
  end

  local minSpeed = tonumber(prompt.minSpeed) or 0
  if minSpeed <= 1 then
    return TriggerEvent('DoLongHudText', 'Min speed must be more than 1 MPH', 2)
  end

  local ticksBeforeExplode = tonumber(prompt.ticksBeforeExplode) or 0
  if ticksBeforeExplode < 5 then
    return TriggerEvent('DoLongHudText', 'Min ticks before explosion needs to be more than 5', 2)
  end

  local ticksForRemoval = tonumber(prompt.ticksForRemoval) or 0
  if ticksForRemoval < 5 then
    return TriggerEvent('DoLongHudText', 'Removal duration needs to be more than 5', 2)
  end

  local gridSize = tonumber(prompt.gridSize)
  if gridSize > 12 or gridSize < 5 then
      return TriggerEvent("DoLongHudText", "Grid size must be between 5-12", 2)
  end

  local coloredSquares = tonumber(prompt.coloredSquares)
  if coloredSquares > 20 or coloredSquares < 5 then
      return TriggerEvent("DoLongHudText", "Colored Sqaures must be between 5-20", 2)
  end

  local timeToComplete = tonumber(prompt.timeToComplete) * 1000
  if timeToComplete < 10000 or timeToComplete > 30000 then
      return TriggerEvent("DoLongHudText", "Time to complete must be between 10-30 seconds", 2)
  end

  local progress = exports['np-taskbar']:taskBar(25000, 'Planting car bomb...', true)
  
  ClearPedTasks(PlayerPedId())
  
  if progress ~= 100 then return end

  local netId = NetworkGetNetworkIdFromEntity(vehicle)
  local added = NPX.Procedures.execute('np-miscscripts:carbombs:addCarBomb', netId, minSpeed, ticksBeforeExplode, ticksForRemoval, gridSize, coloredSquares, timeToComplete)
  TriggerEvent('inventory:removeItem', 'car_bomb', 1)
  
  return TriggerEvent('DoLongHudText', 'Successfully added car bomb to vehicle', 1)
end)

AddEventHandler('np-miscscripts:carBombs:removeBomb', function (pData, pEntity)
  local metaData = exports['np-vehicles']:GetVehicleMetadata(pEntity)
  local carBombMeta = metaData.carBombData or false

  if carBombMeta and carBombMeta.hasCarBomb then
    TriggerEvent('animation:PlayAnimation', 'kneel')
  
    exports['np-ui']:openApplication('memorygame', {
      gameFinishedEndpoint = 'np-miscscripts:carBombs:completeHacking',
      gameTimeoutDuration = carBombMeta.timeToComplete or 14000,
      coloredSquares =  carBombMeta.coloredSqaures or 10,
      gridSize = carBombMeta.gridSize or 5,
      parameters = {
        netId = NetworkGetNetworkIdFromEntity(pEntity)
      }
    })
  end

end)

RegisterUICallback('np-miscscripts:carBombs:completeHacking', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })

  local success = data.success
  local netId = data.parameters.netId

  ClearPedTasks(PlayerPedId())

  TriggerServerEvent('np-miscscripts:carbombs:removeBomb', netId)
  
  if success then
    TriggerEvent('DoLongHudText', 'Bomb has been removed from vehicle', 1)
    TriggerEvent("player:receiveItem", "car_bomb_defused", 1)
  else
    explodeVehicle(NetworkGetEntityFromNetworkId(netId)) 
    resetCarBombState()
  end

  Citizen.Wait(2000)
  exports['np-ui']:closeApplication('memorygame')
end)
