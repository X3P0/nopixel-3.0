local freezerIds = {
  ["maldinis_freezer"] = true,
}
local inFreezer = false
AddEventHandler("np-polyzone:enter", function(name, pContext, p2, p3)
  if name ~= "business_stash" then return end
  if not freezerIds[pContext.id] then return end
  inFreezer = true
  Citizen.CreateThread(function()
    Wait(20000)
    while inFreezer do
      Wait(2000)
      if not inFreezer then return end
      exports['ragdoll']:SetPlayerHealth(GetEntityHealth(PlayerPedId()) - 1)
    end
  end)
end)
AddEventHandler("np-polyzone:exit", function()
  inFreezer = false
end)
