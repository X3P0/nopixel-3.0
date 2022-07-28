local spraying = false
AddEventHandler("np-inventory:itemUsed", function(pItem)
  if pItem ~= "vineyardspray" then return end
  if spraying then return end
  spraying = true
  Citizen.CreateThread(function()
    Citizen.Wait(2000)
    spraying = false
  end)
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  if veh == 0 or GetEntityModel(veh) ~= `duster` then
    TriggerEvent("DoLongHudText", "You can't do that yet.", 2)
    return
  end
  local coords = GetEntityCoords(PlayerPedId())
  if #(vector3(-1841.7,2067.08,138.29) - coords) > 400 then
    TriggerEvent("DoLongHudText", "You must be near the vineyard.", 2)
    return
  end
  TriggerServerEvent("fx:dusterSpray", NetworkGetNetworkIdFromEntity(veh))
  Citizen.CreateThread(function()
    coords = GetEntityCoords(PlayerPedId())
    RPC.execute("np-vineyard:sprayGrapes", coords)
    Citizen.Wait(1000)
    coords = GetEntityCoords(PlayerPedId())
    RPC.execute("np-vineyard:sprayGrapes", coords)
    Citizen.Wait(1000)
    coords = GetEntityCoords(PlayerPedId())
    RPC.execute("np-vineyard:sprayGrapes", coords)
  end)
end)
