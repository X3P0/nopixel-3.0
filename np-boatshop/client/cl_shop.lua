local function showBoatMenu()
  local boats = RPC.execute("boatshop:getBoats")
  local data = {}
  for _, vehicle in pairs(boats) do
      data[#data + 1] = {
          title = vehicle.name,
          description = "$" .. vehicle.retail_price .. ".00",
          image = vehicle.image,
          key = vehicle.model,
          children = {
              { title = _L("boatshop-confirm-purchase", "Confirm Purchase"), action = "np-ui:boatshopPurchase", key = vehicle.model },
          },
      }
  end
  exports["np-ui"]:showContextMenu(data)
end

RegisterUICallback("np-ui:boatshopPurchase", function(data, cb)
  data.model = data.key
  data.vehicle_name = GetLabelText(GetDisplayNameFromVehicleModel(data.model))

  local finished = exports["np-taskbar"]:taskBar(15000, _L("boatshop-text-purchasing", "Purchasing..."), true)
  if finished ~= 100 then
    cb({ data = {}, meta = { ok = false, message = _L("boatshop-text-cancelled", "cancelled") } })
    return
  end

  local success, message = RPC.execute("boatshop:purchaseBoat", data)
  if not success then
      cb({ data = {}, meta = { ok = success, message = message } })
      TriggerEvent("DoLongHudText", message, 2)
      return
  end

  local veh = NetworkGetEntityFromNetworkId(message)

  DoScreenFadeOut(200)

  Citizen.Wait(200)

  TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)

  SetEntityAsMissionEntity(veh, true, true)
  SetVehicleOnGroundProperly(veh)

  DoScreenFadeIn(2000)

  cb({ data = {}, meta = { ok = true, message = _L("boatshop-text-done", "done") } })
end)

RegisterNetEvent("np-npcs:ped:vehiclekeeper")
AddEventHandler("np-npcs:ped:vehiclekeeper", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  if GetHashKey("npc_boat_shop") == DecorGetInt(pEntity, "NPC_ID") then
    showBoatMenu()
  end
end)
