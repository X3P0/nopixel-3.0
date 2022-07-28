DecorRegister('ScriptedPed', 2)

local Densitities = {}

local density = 0.8
local pedDensity = 1.0
local IsSpeeding = false
local IsDriver = false

local disabledRogue = false
local disabledDensity = false

CreateThread(function()
  while true do
    local vehDensity = IsSpeeding and (IsDriver and 0.1 or 0.0) or density

    if disabledDensity then vehDensity = 1.0 end

    SetParkedVehicleDensityMultiplierThisFrame(pedDensity)
    SetVehicleDensityMultiplierThisFrame(vehDensity)
    SetRandomVehicleDensityMultiplierThisFrame(vehDensity)
    SetPedDensityMultiplierThisFrame(pedDensity)
    SetScenarioPedDensityMultiplierThisFrame(pedDensity, pedDensity) -- Walking NPC Density
    Wait(0)
  end
end)

function RegisterDensityReason(pReason, pPriority)
  Densitities[pReason] = { reason = pReason, priority = pPriority, level = -1, active = false }
end

exports('RegisterDensityReason', RegisterDensityReason)

function ChangeDensity(pReason, pLevel)
  if not Densitities[pReason] then return end

  Densitities[pReason]['level'] = pLevel

  local level = Config.populationDensity
  local priority

  for _, reason in pairs(Densitities) do
    if reason.level ~= -1 and (not priority or priority < reason.priority) then
      priority = reason.priority
      level = reason.level
    end
  end


  -- print('density', level)

  density = level + 0.0
end

exports('ChangeDensity', ChangeDensity)

AddEventHandler('pausePopulation', function(pPause)
  density = pPause and 0.0 or Config.populationDensity
  print('pausing polulation', density)
end)

AddEventHandler('np-gopro:activateVRChair', function ()
  density = 0.0
  print('pausing polulation', density)
end)

AddEventHandler("np-ui:application-closed", function(name)
  if name ~= "gopros" then return end

  density = Config.populationDensity
end)

AddEventHandler('np-density:disable', function (pDensity, pRogue)
    disabledDensity = pDensity
    disabledRogue = pRogue
end)

local MarkedPeds = {}
local RequiredChecks = 4

function IsModelValid(ped)
  local eType = GetPedType(ped)
  return eType ~= 0 and eType ~= 1 and eType ~= 3 and eType ~= 28 and not IsPedAPlayer(ped)
end

function IsPedValid(ped)
  local isScripted = DecorExistOn(ped, 'ScriptedPed')

  return not isScripted and IsModelValid(ped) and not IsEntityAMissionEntity(ped) and NetworkGetEntityIsNetworked(ped) and not IsPedDeadOrDying(ped, 1)  and IsPedStill(ped) and IsEntityStatic(ped) and not IsPedInAnyVehicle(ped) and not IsPedUsingAnyScenario(ped)
end

Citizen.CreateThread(function()
    while true do
      local idle = 2000
      local success

      if not disabledRogue then
        local handle, ped = FindFirstPed()

        repeat
            if IsPedValid(ped) and not MarkedPeds[ped] then
              MarkedPeds[ped] = 1
            end

            success, ped = FindNextPed(handle)
        until not success

        EndFindPed(handle)
      end

      Citizen.Wait(idle)
    end
end)

function DeleteRoguePed(pPed)
  local owner = NetworkGetEntityOwner(pPed)

  if owner == -1 or owner == PlayerId() then
    DeleteEntity(pPed)
  else
    local netId = NetworkGetNetworkIdFromEntity(pPed)

    return { netId = netId, owner = GetPlayerServerId(owner)}
  end
end

Citizen.CreateThread(function()
    while true do
      local idle = 3000

      local toDelete = {}
      local playerCoords = GetEntityCoords(PlayerPedId())

      for ped, count in pairs(MarkedPeds) do
        if ped and DoesEntityExist(ped) and IsPedValid(ped) then
          local entitycoords = GetEntityCoords(ped)

          if count >= RequiredChecks and #(entitycoords - playerCoords) <= 100.0 then

            local deleteInfo = DeleteRoguePed(ped)

            if deleteInfo then
              toDelete[#toDelete+1] = deleteInfo
            end
          end

          MarkedPeds[ped] = count + 1
        else
          MarkedPeds[ped] = nil
        end
      end

      if #toDelete > 0 then
        TriggerServerEvent('np:peds:rogue', toDelete)
      end

      Citizen.Wait(idle)
    end
end)

RegisterNetEvent('np:peds:rogue:delete')
AddEventHandler('np:peds:rogue:delete', function(pNetId)
  local entity = NetworkGetEntityFromNetworkId(pNetId)

  if DoesEntityExist(entity) then
    DeleteEntity(entity)
  end
end)

RegisterNetEvent('np:peds:decor:set')
AddEventHandler('np:peds:decor:set', function (pNetId, pType, pProperty, pValue)
  local entity = NetworkGetEntityFromNetworkId(pNetId)

  if DoesEntityExist(entity) then
    if pType == 1 then
      DecorSetFloat(entity, pProperty, pValue)
    elseif pType == 2 then
      DecorSetBool(entity, pProperty, pValue)
    elseif pType == 3 then
      DecorSetInt(entity, pProperty, pValue)
    end
  end
end)

AddEventHandler('baseevents:vehicleSpeeding', function (isSpeeding)
  IsSpeeding = isSpeeding
end)

AddEventHandler('baseevents:enteredVehicle', function (currentVehicle, currentSeat)
  IsSpeeding = false
  IsDriver = currentSeat == -1
end)

AddEventHandler('baseevents:leftVehicle', function ()
  IsSpeeding = false
  IsDriver = false
end)


AddEventHandler('baseevents:vehicleChangedSeat', function (currentVehicle, currentSeat)
  IsDriver = currentSeat == -1
end)
