AddEventHandler('np-inventory:itemUsed', function(pItem)
  if pItem ~= "squidcoinheads" then return end
  TriggerServerEvent("np-squidgames:flipCoin", true)
end)
AddEventHandler('np-inventory:itemUsed', function(pItem)
  if pItem ~= "squidcoinboth" then return end
  TriggerServerEvent("np-squidgames:flipCoin", false)
end)
