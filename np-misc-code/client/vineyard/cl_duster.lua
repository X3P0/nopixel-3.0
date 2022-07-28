AddEventHandler("np-business:heroWineDuster", function()
  local hasAccess = RPC.execute("np-business:hasPermission", "hero_wine", "craft_access")
  if not hasAccess then
    TriggerEvent("DoLongHudText", "You cannot do that.", 2)
    return
  end
  local finished = exports["np-taskbar"]:taskBar(math.random(5000, 10000), "Grabbing Duster")
  if finished ~= 100 then return end
  RPC.execute("np-business:herowine:chargeCompany", 10000)
  local cid = exports["isPed"]:isPed("cid")
  local rentalData = RPC.execute("np:vehicles:rentalSpawn", "duster", { x = 2132.93, y = 4784.85, z = 40.98 }, 26.4)
  local vehId = NetworkGetEntityFromNetworkId(rentalData.netId)

  SetVehicleDirtLevel(vehId, 0.0)
  RemoveDecalsFromVehicle(vehId)

  local metaData = json.encode({
    model = model,
    netId = rentalData.netId,
    state_id = cid,
  })
  TriggerEvent('player:receiveItem', 'rentalpapers', 1, false, {}, metaData)
  Wait(500)
  TriggerEvent("player:receiveItem", "vineyardspray", 1)
end)

Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("hero_wine_duster", vector3(2121.37, 4784.47, 40.97), 0.8, 0.4, {
		heading=27,
		minZ = 40.57,
		maxZ = 40.97,
		data = {
			id = "grapeseed"
		}
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hero_wine_duster", {{
    event = "np-business:heroWineDuster",
    id = "hero_wine_duster",
    icon = "circle",
    label = "Grab Duster",
    parameters = {}
  }}, { distance = { radius = 1.5 }})
end)
