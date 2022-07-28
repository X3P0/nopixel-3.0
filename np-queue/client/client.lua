local resourceStartHandler
local currentResourceName = GetCurrentResourceName()

resourceStartHandler = AddEventHandler('onClientResourceStart', function(resourceName)
  if resourceName ~= currentResourceName then return end

  TriggerServerEvent('np-queue:playerConnected')
  while NetworkIsSessionStarted() ~= 1 do Wait(0) end
  TriggerServerEvent('np-queue:playerActive')
  RemoveEventHandler(resourceStartHandler)
end)

RegisterNetEvent('np-queue:gavePersistentBufferSlotByCharacterId')
AddEventHandler('np-queue:gavePersistentBufferSlotByCharacterId', function (pSuccess, pCharacterId)
  local code = 1
  local message = 'Successfully gave buffer slot'
  if not pSuccess then
    code = 2
    message = 'Failed to give buffer slot'
  end
  TriggerEvent('DoLongHudText', message, code)
end)
