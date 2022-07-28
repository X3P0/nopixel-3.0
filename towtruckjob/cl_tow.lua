local towingProcess = false

local BlacklistedModels = {
  [`stockade`] = true
}

local BlacklistedClasses = {
  [15] = true,
  [16] = true
}

function RequestControl(pEntity)
  local timeout = false

  if not NetworkHasControlOfEntity(pEntity) then
    NetworkRequestControlOfEntity(pEntity)

    Citizen.SetTimeout(1000, function () timeout = true end)

    while not NetworkHasControlOfEntity(pEntity) and not timeout do
      NetworkRequestControlOfEntity(pEntity)
      Citizen.Wait(100)
    end
  end

  return NetworkHasControlOfEntity(pEntity)
end

function FindVehicleAttachedToVehicle(pVehicle)
  local handle, vehicle = FindFirstVehicle()

  local success

  repeat
    if GetEntityAttachedTo(vehicle) == pVehicle then
      return vehicle
    end

        success, vehicle = FindNextVehicle(handle)
  until not success

  EndFindVehicle(handle)
end


function GetAttachOffset(pTarget)
  local model = GetEntityModel(pTarget)
  local minDim, maxDim = GetModelDimensions(model)
  local vehSize = maxDim - minDim
  return vector3(0, -(vehSize.y / 2), 0.4 - minDim.z)
end

function AttachToFlatbed(pFlatbed, pEntity, pTarget)
  local distance = #(GetEntityCoords(pTarget) - GetEntityCoords(pEntity))
  local speed = GetEntitySpeed(pTarget)
  local isTowing = HasVehicleFlag(pEntity, 'isTowingVehicle')

  if not isTowing and distance <= 15 and speed <= 3.0 then
    local offset = GetAttachOffset(pTarget)

    if offset then
      local hasControlOfTow = RequestControl(pEntity)
      local hasControlOfTarget = RequestControl(pTarget)

      if hasControlOfTow and hasControlOfTarget then
        AttachEntityToEntity(pTarget, pEntity, GetEntityBoneIndexByName(pEntity, 'bodyshell'), offset.x, offset.y, offset.z, 0, 0, 0, 1, 1, 0, 0, 0, 1)
        SetCanClimbOnEntity(pTarget, false)
        SetVehicleFlag(pEntity, 'isTowingVehicle', true)
      end
    end
  end
end

function DetachFromFlatbed(pEntity, pTarget)
  local drop = GetOffsetFromEntityInWorldCoords(pTarget, 0.0,-5.5,0.0)

  if IsEntityAttachedToEntity(pTarget, pEntity) then
    Sync.DetachEntity(pTarget, true, true)
    Citizen.Wait(100)
    Sync.SetEntityCoords(pTarget, drop)
    Citizen.Wait(100)
    Sync.SetVehicleOnGroundProperly(pTarget)
    SetVehicleFlag(pEntity, 'isTowingVehicle', false)
  end
end

RegisterNetEvent('jobs:towVehicle')
AddEventHandler('jobs:towVehicle', function (pParams, pEntity, pContext)
  local target = exports['np-target']:GetEntityInFrontOfEntity(pEntity, -8, 0.6)

  if target == nil or target == 0 then 
    return TriggerEvent("DoLongHudText","No vehicle found", 2)
  end

  local targetModel = GetEntityModel(target)
  local targetClass = GetVehicleClass(target)

  if (BlacklistedModels[targetModel] or BlacklistedClasses[targetClass]) then
    return TriggerEvent("DoLongHudText","Cannot tow this vehicle", 2)
  end

  local targetDriver = GetPedInVehicleSeat(target, -1)

  if targetDriver ~= 0 then return TriggerEvent("DoLongHudText","Vehicle must be empty.", 2) end

  local driver = GetPedInVehicleSeat(pEntity, -1)

  if target and pEntity ~= target and GetEntityType(target) == 2 and GetEntityModel(pEntity) == `flatbed` then
    local towCoords, targetCoords = GetEntityCoords(pEntity), GetEntityCoords(target)
    local distance = #(targetCoords - towCoords)

    if distance <= 10 then
        TaskTurnPedToFaceCoord(PlayerPedId(), targetCoords, 1.0)
        Citizen.Wait(1000)
      TriggerEvent("animation:tow")

      local hooking = exports["np-taskbar"]:taskBar(15000,"Hooking up vehicle.")
      if hooking == 100 then
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10.0, 'towtruck2', 0.5)
        local towing = exports["np-taskbar"]:taskBar(5000,"Towing Vehicle")

        local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(driver))
        local tow, vehicle = NetworkGetNetworkIdFromEntity(pEntity), NetworkGetNetworkIdFromEntity(target)

        if driver and driver ~= 0 then
          TriggerServerEvent('tow:attachVehicle', serverId, pContext.model, tow, vehicle)
        else
          AttachToFlatbed(pContext.model, pEntity, target)
        end

        TriggerServerEvent('tow:vehicleAttached', pContext.model, tow, vehicle)
      end
      ClearPedSecondaryTask(PlayerPedId())
      towingProcess = false
      return
    end
  end

  TriggerEvent("DoLongHudText","No vehicle found", 2)
end)

RegisterNetEvent('jobs:untowVehicle')
AddEventHandler('jobs:untowVehicle', function (pParams, pEntity, pContext)
  local target = FindVehicleAttachedToVehicle(pEntity)

  if target and target ~= pEntity and target ~= 0 then
    TaskTurnPedToFaceEntity(PlayerPedId(), pEntity, 1.0)
    Citizen.Wait(1000)
    TriggerEvent("animation:tow")
    local untowing = exports["np-taskbar"]:taskBar(7000,"Untowing Vehicle")

    if untowing == 100 then
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10.0, 'towtruck2', 0.5)
      local unhooking = exports["np-taskbar"]:taskBar(5000,"Unhooking Vehicle")
      DetachFromFlatbed(pEntity, target)
    end
    ClearPedSecondaryTask(PlayerPedId())
    towingProcess = false
    return
  end

  TriggerEvent("DoLongHudText","No vehicle found", 2)
end)

RegisterNetEvent('animation:tow')
AddEventHandler('animation:tow', function()
  towingProcess = true
    local lPed = PlayerPedId()
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
  end

  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10.0, 'towtruck', 0.5)

    while towingProcess do

        if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
            ClearPedSecondaryTask(lPed)
            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)

RegisterNetEvent('tow:attachVehicle')
AddEventHandler('tow:attachVehicle', function(pModel, pTow, pVehicle)
  local tow, vehicle = NetworkGetEntityFromNetworkId(pTow), NetworkGetEntityFromNetworkId(pVehicle)

  if DoesEntityExist(tow) and DoesEntityExist(vehicle) then
    AttachToFlatbed(pModel, tow, vehicle)
  end
end)