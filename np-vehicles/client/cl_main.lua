local wearingSeatbelt = false
local wearingHarness = false
local currentVehicle = 0
local isInsideVehicle = 0

CreateThread(function()
  while true do
    Citizen.Wait(0)
    if currentVehicle ~= 0 then
      if wearingHarness then
        DisableControlAction(0, 75, true)
        if IsDisabledControlJustPressed(1, 75) then
          TriggerEvent('DoLongHudText', 'You probably should undo your harness...', 101)
        end
      else
        Citizen.Wait(1000)
      end
    else
      Citizen.Wait(5000)
    end
  end
end)

local function isDriver()
  return GetPedInVehicleSeat(currentVehicle, -1) == PlayerPedId()
end

function toggleSeatbelt()
  currentVehicle = GetVehiclePedIsIn(PlayerPedId())
  isInsideVehicle = currentVehicle ~= 0

  if isInsideVehicle then
    local harnessLevel = exports['np-vehicles']:GetVehicleMetadata(currentVehicle, 'harness') or 0
    local hasHarness = harnessLevel > 0
    if wearingSeatbelt and not wearingHarness then -- Wearing seatbelt but no harness, taking off
      TriggerEvent('InteractSound_CL:PlayOnOne', 'seatbeltoff', 0.7)
      wearingSeatbelt = true
      SetFlyThroughWindscreenParams(10.0, 1.0, 1.0, 1.0)
    elseif wearingSeatbelt and wearingHarness and isDriver() then -- Wearing seatbelt/harness, taking off
      toggleHarness(false)
    elseif not wearingSeatbelt and not wearingSeatbelt and isDriver() and hasHarness then -- Not wearing anything and have harness
      toggleHarness(true)
    elseif not wearingSeatbelt and not wearingHarness then
      TriggerEvent('InteractSound_CL:PlayOnOne', 'seatbelt', 0.7) -- Not wearing anything and have no harness
      wearingSeatbelt = true
      SetFlyThroughWindscreenParams(45.0, 1.0, 1.0, 1.0)
    end
    TriggerEvent('harness', wearingHarness, exports['np-vehicles']:GetVehicleMetadata(currentVehicle, 'harness'))
    TriggerEvent('seatbelt', wearingSeatbelt)
  end
end

function toggleHarness(pState)
  local defaultSteering = GetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fSteeringLock')
  local harnessTimer = exports['np-taskbar']:taskBar(5000, (pState and 'Putting on Harness' or 'Taking off Harness'), true)
  if harnessTimer == 100 then
    wearingHarness = pState
    wearingSeatbelt = pState
    TriggerEvent('InteractSound_CL:PlayOnOne', (pState and 'seatbelt' or 'seatbeltoff'), 0.7)
  end
end

AddEventHandler('baseevents:enteredVehicle', function(pCurrentVehicle, currentSeat, vehicleDisplayName)
  currentVehicle = pCurrentVehicle
end)

AddEventHandler('baseevents:leftVehicle', function(pCurrentVehicle, pCurrentSeat, vehicleDisplayName)
  wearingHarness = false
  wearingSeatbelt = false
  currentVehicle = 0
  TriggerEvent('harness', false, 0);
  TriggerEvent('seatbelt', false);
end)
