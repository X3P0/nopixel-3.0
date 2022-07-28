local canFireWork = true
AddEventHandler("np-inventory:itemUsed", function(pItem)
  if pItem ~= "fireworks_starter" then return end
  if not canFireWork then return end
  canFireWork = false
  Citizen.CreateThread(function()
    Citizen.Wait(30000)
    canFireWork = true
  end)
  TriggerServerEvent("fx:fireworks")
end)
