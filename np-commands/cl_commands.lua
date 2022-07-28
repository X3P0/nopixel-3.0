 


 AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  TriggerServerEvent("np-commands:buildCommands","")
end)