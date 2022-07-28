AddEventHandler("np-inventory:itemUsed", function(item, info)
  if item ~= "methlabkey" then return end
  if not info then return end
  RPC.execute("np-doors:useDoorKey", NetworkGetNetworkIdFromEntity(PlayerPedId()), info)
end)
AddEventHandler("np-inventory:itemUsed", function(item, info)
  if item ~= "casinogoldcoin" then return end
  if #(GetEntityCoords(PlayerPedId()) - vector3(991.05,24.49,71.47)) > 2 then return end
  RPC.execute("np-doors:triggerCasinoLaundryDoor")
end)
