CARS = {}
CURRENT_CAR = nil

local isPiloting = false

RegisterNetEvent('np-rcvehicles:car:setup', function(pCarSettings)
  local handle = NetworkGetEntityFromNetworkId(pCarSettings.netId)
  SetEntityHealth(handle, 150)
  SetVehicleModKit(handle, 0)
  SetVehicleMod(handle, 3, 316, 0)
--   SetVehicleMod(handle, 8, 0, 0) -- c4 0, no c4 -1
  SetVehicleColours(handle, 72, 0) -- purple
  SetVehicleDirtLevel(handle, 0.0)
  SetVehicleDoorsLocked(handle, 4)
  SetVehicleDoorsLockedForAllPlayers(handle, true)
  SetVehicleDoorsLockedForNonScriptPlayers(handle, true)
end)

RegisterNetEvent('np-rcvehicles:car:spawn', function(pCarSettings)
  if not pCarSettings then
    return
  end

  if CARS[pCarSettings.id] then
    TriggerEvent('DoLongHudText', 'You already have this car deployed.', 2)
    return
  end

  CARS[pCarSettings.id] = pCarSettings
end)

RegisterNetEvent('np-rcvehicles:car:pilot', function(pCarId)
  if not CARS[pCarId] then
    return
  end

  DoScreenFadeOut(400)
  Wait(400)

  CURRENT_CAR = CARS[pCarId]

  CURRENT_CAR.handle = NetworkGetEntityFromNetworkId(CURRENT_CAR.netId)

  if not DoesEntityExist(CURRENT_CAR.handle) then
    DoScreenFadeIn(400)
    RPC.execute('np-rcvehicles:leaveCar', CURRENT_CAR.id)
    return TriggerEvent('DoLongHudText', 'This car is not in range.', 2)
  end

  isPiloting = true

  CURRENT_CAR.cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  SetCamFov(CURRENT_CAR.cam, 60.0)
  RenderScriptCams(true, false, 0, 1, 0)
  TriggerEvent('np-rc:carEntered', CURRENT_CAR)

  CURRENT_CAR.clonePed = ClonePed(PlayerPedId(), 1, 1, 1)
  while not DoesEntityExist(CURRENT_CAR.clonePed) do
    Citizen.Wait(0)
  end

  SetEntityInvincible(CURRENT_CAR.clonePed, true)
  FreezeEntityPosition(CURRENT_CAR.clonePed, true)
  TaskSetBlockingOfNonTemporaryEvents(CURRENT_CAR.clonePed, true)
  SetBlockingOfNonTemporaryEvents(CURRENT_CAR.clonePed, true)
  ClearPedTasksImmediately(CURRENT_CAR.clonePed)
  local animDict = 'amb@code_human_in_bus_passenger_idles@female@tablet@base'
  local animation = 'base'
  loadAnimDict(animDict)
  TaskPlayAnim(CURRENT_CAR.clonePed, 'amb@code_human_in_bus_passenger_idles@female@tablet@base', 'base', 3.0, 3.0, -1, 49, 0, 0, 0, 0)

  exports['np-taskbar']:taskbarDisableInventory(true)
  exports['np-actionbar']:disableActionBar(true)

  TaskWarpPedIntoVehicle(PlayerPedId(), CURRENT_CAR.handle, -1)
  TriggerEvent('np-ui:setVehicleBypassed', CURRENT_CAR.handle, true)
  DoScreenFadeIn(1000)

  -- Anim loop
  Citizen.CreateThread(function()
    while isPiloting do
      exports['np-ui']:sendAppEvent('hud', { display = false })
      if not IsEntityPlayingAnim(CURRENT_CAR.clonePed, animDict, animation, 3) then
        TaskPlayAnim(CURRENT_CAR.clonePed, animDict, animation, 1.0, 4.0, animLength, 1, 0, 0, 0, 0)
      end

      if getRemainingBattery(CURRENT_CAR) <= 0 then
        isPiloting = false
        TriggerEvent('DoLongHudText', 'Your car ran out of battery.', 2)
      end
      Citizen.Wait(1000)
    end
  end)

  -- Main Loop
  Citizen.CreateThread(function()
    while isPiloting do
      CURRENT_CAR.position = GetEntityCoords(CURRENT_CAR.handle)
      if GetEntityHealth(CURRENT_CAR.handle) <= 0 then
        CURRENT_CAR.crashed = true
        isPiloting = false
        TriggerEvent('DoLongHudText', 'Car destroyed.', 2)
        break
      end

      local camOffset = GetOffsetFromEntityInWorldCoords(CURRENT_CAR.handle, 0.0, CURRENT_CAR.camOffset[1], CURRENT_CAR.camOffset[2])
      SetCamCoord(CURRENT_CAR.cam, camOffset)
      SetCamRot(CURRENT_CAR.cam, GetEntityRotation(CURRENT_CAR.handle), 2)

      if IsDisabledControlJustReleased(0, Keys['ESC']) then
        isPiloting = false
      end

      Wait(0)
    end
    DoScreenFadeOut(100)
    Wait(400)
    RenderScriptCams(false, false, 0, 0, 0)
    DestroyCam(CURRENT_CAR.cam, false)
    SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(CURRENT_CAR.clonePed))
    Sync.DeleteEntity(CURRENT_CAR.clonePed)
    DoScreenFadeIn(1000)
    SetPlayerControl(PlayerId(), 1, 0)

    exports['np-taskbar']:taskbarDisableInventory(false)
    exports['np-actionbar']:disableActionBar(false)
    exports['np-ui']:sendAppEvent('hud', { display = true })
    TriggerEvent('np-ui:setVehicleBypassed', CURRENT_CAR.handle)

    SetNetworkIdCanMigrate(CURRENT_CAR.netId, true)

    TriggerEvent('np-rc:carExited', CURRENT_CAR)
    RPC.execute('np-rcvehicles:leaveCar', CURRENT_CAR.id)
    if CURRENT_CAR.crashed then
      RPC.execute('np-rcvehicles:crashCar', CURRENT_CAR.id)
    end
    CURRENT_CAR = nil
  end)

  -- Scaleform loop
  Citizen.CreateThread(function()
    local sf = RequestScaleformMovie('DRONE_CAM')
    while not HasScaleformMovieLoaded(sf) do
      Wait(0)
    end
    CURRENT_CAR.pilot_coords = GetEntityCoords(CURRENT_CAR.clonePed)

    -- BeginScaleformMovieMethod(sf, 'SET_RETICLE_IS_VISIBLE')
    -- ScaleformMovieMethodAddParamBool(true)
    -- EndScaleformMovieMethod()

    local function setMethod(sf, method, toggle)
      BeginScaleformMovieMethod(sf, method)
      ScaleformMovieMethodAddParamBool(toggle)
      EndScaleformMovieMethod()
    end

    setMethod(sf, 'SET_HEADING_METER_IS_VISIBLE', true)
    setMethod(sf, 'SET_ZOOM_METER_IS_VISIBLE', true)

    BeginScaleformMovieMethod(sf, 'SET_ZOOM')
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    local warningShowing = false
    local warningBorder = false

    while isPiloting do
      local heading = Round(GetEntityHeading(CURRENT_CAR.handle)) * -1
      BeginScaleformMovieMethod(sf, 'SET_HEADING')
      ScaleformMovieMethodAddParamInt(heading)
      EndScaleformMovieMethod()

      local distToPlayer = #(CURRENT_CAR.position - CURRENT_CAR.pilot_coords)
      if (distToPlayer > (CURRENT_CAR.maxDistance * 0.6)) then
        if not warningShowing then
          setMethod(sf, 'SET_WARNING_IS_VISIBLE', true)
          BeginScaleformMovieMethod(sf, 'SET_WARNING_FLASH_RATE')
          ScaleformMovieMethodAddParamFloat(0.1)
          EndScaleformMovieMethod()
          warningShowing = true
        end
      elseif warningShowing then
        setMethod(sf, 'SET_WARNING_IS_VISIBLE', false)
        warningShowing = false
      end

      if (distToPlayer > (CURRENT_CAR.maxDistance * 0.8)) then
        if not warningBorder then
          BeginScaleformMovieMethod(sf, 'SET_WARNING_FLASH_RATE')
          ScaleformMovieMethodAddParamFloat(1.0)
          EndScaleformMovieMethod()
          warningBorder = true
        end
      elseif warningBorder then
        BeginScaleformMovieMethod(sf, 'SET_WARNING_FLASH_RATE')
        ScaleformMovieMethodAddParamFloat(0.1)
        EndScaleformMovieMethod()
        warningBorder = false
      end

      if (distToPlayer > CURRENT_CAR.maxDistance) then
        isPiloting = false
      end

      SetScriptGfxDrawOrder(1)
      DrawScaleformMovieFullscreen(sf, 255, 255, 255, 255, 0)
      Wait(0)
    end
    SetScaleformMovieAsNoLongerNeeded(sf)
  end)
end)

RegisterNetEvent('np-rcvehicles:car:destroy', function(pCarId)
  if CURRENT_CAR and CURRENT_CAR.id == pCarId then
    isPiloting = false
  end
  CARS[pCarId] = nil
end)
