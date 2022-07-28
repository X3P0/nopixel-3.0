local DRONE_UPDATE_TIME = 90.15
local DRONE_MOVE_SPEED = 500.0
local minY, maxY = -89.0, 89.0

CURRENT_DRONE = nil
DRONES = {}

local isPiloting = false

RegisterNetEvent('np-rcvehicles:drone:spawn', function(pDroneSettings)
  if not pDroneSettings then
    return
  end

  if DRONES[pDroneSettings.id] then
    TriggerEvent('DoLongHudText', 'You already have this drone deployed.', 2)
    return
  end

  pDroneSettings.tilt = 0.0
  pDroneSettings.roll = 0.0

  DRONES[pDroneSettings.id] = pDroneSettings
end)

RegisterNetEvent('np-rcvehicles:drone:pilot', function(pDroneId)
  if not DRONES[pDroneId] then
    return
  end

  CURRENT_DRONE = DRONES[pDroneId]

  CURRENT_DRONE.handle = NetworkGetEntityFromNetworkId(CURRENT_DRONE.netId)
  SetEntityHealth(CURRENT_DRONE.handle, 50)

  isPiloting = true

  exports['np-taskbar']:taskbarDisableInventory(true)
  exports['np-actionbar']:disableActionBar(true)
  exports["np-ui"]:sendAppEvent("hud", { display = false })

  loadAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@base")
  TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
  TriggerEvent("attachItemPhone", "tablet01")

  CURRENT_DRONE.cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  SetCamFov(CURRENT_DRONE.cam, 60.0)
  SetFocusEntity(CURRENT_DRONE.handle)
  RenderScriptCams(true, false, 0, 1, 0)
  SetEntityHasGravity(CURRENT_DRONE.handle, false)
  TriggerEvent('np-rc:droneEntered', CURRENT_DRONE)

  -- Scaleform loop
  Citizen.CreateThread(function()
    local sf = RequestScaleformMovie('DRONE_CAM')
    while not HasScaleformMovieLoaded(sf) do
      Wait(0)
    end
    CURRENT_DRONE.pilot_coords = GetEntityCoords(PlayerPedId())

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
      local heading = Round(GetEntityHeading(CURRENT_DRONE.handle) + 180.0) * -1
      BeginScaleformMovieMethod(sf, 'SET_HEADING')
      ScaleformMovieMethodAddParamInt(heading)
      EndScaleformMovieMethod()

      local distToPlayer = #(CURRENT_DRONE.position - CURRENT_DRONE.pilot_coords)
      if (distToPlayer > (CURRENT_DRONE.maxDistance * 0.6)) then
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

      if (distToPlayer > (CURRENT_DRONE.maxDistance * 0.8)) then
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

      if (distToPlayer > CURRENT_DRONE.maxDistance) then
        isPiloting = false
        SetEntityRotation(CURRENT_DRONE.handle, 0.0, 0.0, heading, 2)
      end

      SetScriptGfxDrawOrder(1)
      DrawScaleformMovieFullscreen(sf, 255, 255, 255, 255, 0)
      Wait(0)
    end
    SetScaleformMovieAsNoLongerNeeded(sf)
  end)

  --  Movement loop
  Citizen.CreateThread(function()
    while not NetworkHasControlOfNetworkId(CURRENT_DRONE.netId) and isPiloting do
      NetworkRequestControlOfEntity(CURRENT_DRONE.handle)
      Wait(0)

      if IsDisabledControlJustReleased(0, Keys['ESC']) then
        isPiloting = false
        SetEntityRotation(CURRENT_DRONE.handle, 0.0, 0.0, heading, 2)
      end
    end

    SetNetworkIdCanMigrate(CURRENT_DRONE.netId, false)

    while isPiloting do
      local delta = GetFrameTime() / DRONE_UPDATE_TIME
      CURRENT_DRONE.forward, CURRENT_DRONE.right, CURRENT_DRONE.up, CURRENT_DRONE.position = GetEntityMatrix(CURRENT_DRONE.handle)
      CURRENT_DRONE.rotation = GetEntityRotation(CURRENT_DRONE.handle, 2)

      if GetEntityHealth(CURRENT_DRONE.handle) <= 0 then
        CURRENT_DRONE.crashed = true
        isPiloting = false
        TriggerEvent('DoLongHudText', 'Drone destroyed.', 2)
        break
      end

      local forwardS = 0.0
      local rightS = 0.0
      local upS = 0.0
      local rollMulti = 10.0

      local heading = CURRENT_DRONE.rotation.z

      DisableAllControlActions(0)

      if IsDisabledControlPressed(0, Keys['W']) then
        forwardS = DRONE_MOVE_SPEED
        CURRENT_DRONE.tilt = CURRENT_DRONE.tilt + (delta * DRONE_MOVE_SPEED * rollMulti)
        if CURRENT_DRONE.tilt > 45.0 then
          CURRENT_DRONE.tilt = 45.0
        end
      end

      if IsDisabledControlPressed(0, Keys['S']) then
        forwardS = -DRONE_MOVE_SPEED
        CURRENT_DRONE.tilt = CURRENT_DRONE.tilt - (delta * DRONE_MOVE_SPEED * rollMulti)
        if CURRENT_DRONE.tilt < -45.0 then
          CURRENT_DRONE.tilt = -45.0
        end
      end

      if forwardS == 0.0 then
        if CURRENT_DRONE.tilt < -0.5 then
          CURRENT_DRONE.tilt = CURRENT_DRONE.tilt + (delta * DRONE_MOVE_SPEED * rollMulti)
        elseif CURRENT_DRONE.tilt > 0.5 then
          CURRENT_DRONE.tilt = CURRENT_DRONE.tilt - (delta * DRONE_MOVE_SPEED * rollMulti)
        end
      end

      if IsDisabledControlPressed(0, Keys['D']) then
        rightS = DRONE_MOVE_SPEED
        CURRENT_DRONE.roll = CURRENT_DRONE.roll - (delta * DRONE_MOVE_SPEED * rollMulti)
        if CURRENT_DRONE.roll < -30.0 then
          CURRENT_DRONE.roll = -30.0
        end
      end

      if IsDisabledControlPressed(0, Keys['A']) then
        rightS = -DRONE_MOVE_SPEED
        CURRENT_DRONE.roll = CURRENT_DRONE.roll + (delta * DRONE_MOVE_SPEED * rollMulti)
        if CURRENT_DRONE.roll > 30.0 then
          CURRENT_DRONE.roll = 30.0
        end
      end

      if rightS == 0.0 then
        if CURRENT_DRONE.roll < -0.5 then
          CURRENT_DRONE.roll = CURRENT_DRONE.roll + (delta * DRONE_MOVE_SPEED * rollMulti)
        elseif CURRENT_DRONE.roll > 0.5 then
          CURRENT_DRONE.roll = CURRENT_DRONE.roll - (delta * DRONE_MOVE_SPEED * rollMulti)
        end
      end

      if IsDisabledControlJustPressed(0, Keys['SPACE']) then
        TriggerEvent('np-rc:droneAbility', CURRENT_DRONE)
      end

      if IsDisabledControlPressed(0, Keys['Q']) then
        upS = DRONE_MOVE_SPEED / 4.0
      end

      if IsDisabledControlPressed(0, Keys['E']) then
        upS = -DRONE_MOVE_SPEED / 4.0
      end

      if IsDisabledControlPressed(0, Keys['LEFTSHIFT']) then
        forwardS = forwardS * 4.0
        upS = upS * 10.0
      end

      local rightAxisX = GetDisabledControlNormal(0, 220)
      local rightAxisY = GetDisabledControlNormal(0, 221)

      if (math.abs(rightAxisX) > 0) and (math.abs(rightAxisY) > 0) then
        local rotation = GetCamRot(CURRENT_DRONE.cam, 2)
        rotz = rotation.z + rightAxisX * -6.5

        local yValue = rightAxisY * -2.75

        rotx = rotation.x

        if rotx + yValue > minY and rotx + yValue < maxY then
          rotx = rotation.x + yValue
        end

        SetCamRot(CURRENT_DRONE.cam, rotx, rotation.y, rotz, 2)
        heading = rotz + 180.0
      end

      local speedRight = delta * rightS
      local speedForward = delta * forwardS
      local speedUp = delta * upS

      local direction = RotationToDirection(CURRENT_DRONE.rotation)

      local forceX = (DRONE_MOVE_SPEED + direction.x) * -speedRight
      local forceY = (DRONE_MOVE_SPEED + direction.y) * -speedForward
      local forceZ = (DRONE_MOVE_SPEED + direction.z) * -speedUp

      forceZ = forceZ - (forceY * math.sin(math.rad(CURRENT_DRONE.tilt * 3.14 / 2)))
      forceZ = forceZ + (forceX * math.sin(math.rad(CURRENT_DRONE.roll)))
      -- if any numbskulls copy this code, don't uncomment this line because it's not FPS safe.
      -- forceZ = forceZ + (9.81 * delta * (DRONE_MOVE_SPEED / 2.0) * (50.0 + (math.random(1,100))))

      ApplyForceToEntityCenterOfMass(CURRENT_DRONE.handle, 0, forceX, forceY, forceZ, false, true, true, false)
      SetEntityRotation(CURRENT_DRONE.handle, CURRENT_DRONE.tilt, CURRENT_DRONE.roll, heading, 2)

      local camOffset = GetOffsetFromEntityInWorldCoords(CURRENT_DRONE.handle, 0.0, CURRENT_DRONE.camOffset[1], CURRENT_DRONE.camOffset[2])
      SetCamCoord(CURRENT_DRONE.cam, camOffset)

      if IsDisabledControlJustReleased(0, Keys['ESC']) then
        isPiloting = false
        SetEntityRotation(CURRENT_DRONE.handle, 0.0, 0.0, heading, 2)
      end
      Wait(0)
    end

    RenderScriptCams(false, false, 0, 0, 0)
    ClearFocus()
    DestroyCam(CURRENT_DRONE.cam, false)

    exports['np-taskbar']:taskbarDisableInventory(false)
    exports['np-actionbar']:disableActionBar(false)
    exports["np-ui"]:sendAppEvent("hud", { display = true })

    StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 1.0)
    TriggerEvent("destroyPropPhone")
    SetPlayerControl(PlayerId(), 1, 0)

    SetEntityHasGravity(CURRENT_DRONE.handle, true)
    SetNetworkIdCanMigrate(CURRENT_DRONE.netId, true)

    TriggerEvent('np-rc:droneExited', CURRENT_DRONE)
    RPC.execute('np-rcvehicles:leaveDrone', CURRENT_DRONE.id)
    if CURRENT_DRONE.crashed then
        RPC.execute('np-rcvehicles:crashDrone', CURRENT_DRONE.id)
    end
    CURRENT_DRONE = nil
  end)

  -- Sound/Misc Loop
  Citizen.CreateThread(function()
    local flightLoop = -1
    local player = PlayerPedId()
    while isPiloting do
      if HasSoundFinished(flightLoop) then
        flightLoop = GetSoundId()
        PlaySoundFromEntity(flightLoop, 'Flight_Loop', CURRENT_DRONE.handle, 'DLC_H3_Prep_Drones_Sounds', 1, 0)
        SetVariableOnSound(flightLoop, 'DroneRotationalSpeed', 0.5)
      end

      if IsPedRagdoll(player) or IsPedDeadOrDying(player, true) then
        isPiloting = false
        SetEntityRotation(CURRENT_DRONE.handle, 0.0, 0.0, CURRENT_DRONE.rotation.z, 2)
      end


      if getRemainingBattery(CURRENT_DRONE) <= 0 then
        isPiloting = false
        SetEntityRotation(CURRENT_DRONE.handle, 0.0, 0.0, CURRENT_DRONE.rotation.z, 2)
        TriggerEvent('DoLongHudText', 'Your drone ran out of battery.', 2)
      end

      Wait(0)
    end
    ActivatePhysics(CURRENT_DRONE.handle)
    Wait(5000)
    if not HasSoundFinished(flightLoop) then
      StopSound(flightLoop)
      ReleaseSoundId(flightLoop)
    end
  end)
end)

RegisterNetEvent('np-rcvehicles:drone:destroy', function(pDroneId)
  if CURRENT_DRONE and CURRENT_DRONE.id == pDroneId then
    isPiloting = false
  end
  DRONES[pDroneId] = nil
end)
