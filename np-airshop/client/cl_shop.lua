local function showVehicleMenu()
  local vehicles = RPC.execute("airshop:getVehicles")
  local data = {}
  local planes = {}
  local helis = {}
  for _, vehicle in pairs(vehicles) do
    if vehicle.type == "plane" then
      planes[#planes + 1] = {
          title = vehicle.name,
          description = "$" .. vehicle.retail_price .. ".00",
          image = vehicle.image,
          key = vehicle.model,
          children = {
              { title = _L("airshop-confirm-purchase", "Confirm Purchase"), action = "np-ui:airshopPurchase", key = vehicle.model },
          },
      }
    else
      helis[#helis + 1] = {
          title = vehicle.name,
          description = "$" .. vehicle.retail_price .. ".00",
          image = vehicle.image,
          key = vehicle.model,
          children = {
              { title = _L("airshop-confirm-purchase", "Confirm Purchase"), action = "np-ui:airshopPurchase", key = vehicle.model },
          },
      }
    end
  end
  data[1] = {
    title = _L("airshop-title-planes", "Planes"),
    children = planes,
  }
  data[2] = {
    title = _L("airshop-title-helicopters", "Helicopters"),
    children = helis,
  }
  exports["np-ui"]:showContextMenu(data)
end

local function showVehicleRentalMenu()
  local vehicles = RPC.execute("airshop:getVehiclesRental")
  local data = {}
  local planes = {}
  local helis = {}
  for _, vehicle in pairs(vehicles) do
    if vehicle.type == "plane" then
      planes[#planes + 1] = {
          title = vehicle.name,
          description = "$" .. vehicle.retail_price .. ".00",
          image = vehicle.image,
          key = vehicle.model,
          children = {
              { title = _L("airshop-confirm-purchase", "Confirm Purchase"), action = "np-ui:airshopPurchaseRental", key = vehicle.model },
          },
      }
    else
      helis[#helis + 1] = {
          title = vehicle.name,
          description = "$" .. vehicle.retail_price .. ".00",
          image = vehicle.image,
          key = vehicle.model,
          children = {
              { title = _L("airshop-confirm-purchase", "Confirm Purchase"), action = "np-ui:airshopPurchaseRental", key = vehicle.model },
          },
      }
    end
  end
  data[1] = {
    title = _L("airshop-title-planes", "Planes"),
    children = planes,
  }
  data[2] = {
    title = _L("airshop-title-helicopters", "Helicopters"),
    children = helis,
  }
  exports["np-ui"]:showContextMenu(data)
end

RegisterUICallback("np-ui:airshopPurchase", function(data, cb)
  local model = data.key
  data.model = data.key
  data.vehicle_name = GetLabelText(GetDisplayNameFromVehicleModel(data.model))

  local finished = exports["np-taskbar"]:taskBar(15000, _L("airshop-text-purchasing", "Purchasing..."), true)
  if finished ~= 100 then
    cb({ data = {}, meta = { ok = false, message = _L("airshop-text-cancelled", "cancelled") } })
    return
  end

  local success, message = RPC.execute("airshop:purchaseVehicle", data)
  if not success then
      cb({ data = {}, meta = { ok = success, message = message } })
      return
  end

  local veh = NetworkGetEntityFromNetworkId(message)

  DoScreenFadeOut(200)

  Citizen.Wait(200)

  TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)

  SetEntityAsMissionEntity(veh, true, true)
  SetVehicleOnGroundProperly(veh)

  DoScreenFadeIn(2000)

  DoScreenFadeIn(2000)

  cb({ data = {}, meta = { ok = true, message = _L("airshop-text-done", "done") } })
end)

RegisterUICallback("np-ui:airshopPurchaseRental", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = _L("airshop-text-done", "done") } })
  local model = data.key
  data.model = data.key
  data.vehicle_name = GetLabelText(GetDisplayNameFromVehicleModel(data.model))

  local finished = exports["np-taskbar"]:taskBar(15000, _L("airshop-text-purchasing", "Purchasing..."), true)
  if finished ~= 100 then
    cb({ data = {}, meta = { ok = false, message = _L("airshop-text-cancelled", "cancelled") } })
    return
  end

  local success, message = RPC.execute("airshop:purchaseVehicleRental", data)
  if not success then
      TriggerEvent("DoLongHudText", message, 2)
      return
  end

  local cid = exports["isPed"]:isPed("cid")
  local rentalData = RPC.execute("np:vehicles:rentalSpawn", model, { x = -1652.21, y = -3143.04, z = 14.0 }, 325.01)
  local vehId = NetworkGetEntityFromNetworkId(rentalData.netId)

  SetVehicleDirtLevel(vehId, 0.0)
  RemoveDecalsFromVehicle(vehId)

  local metaData = json.encode({
    model = model,
    netId = rentalData.netId,
    state_id = cid,
  })
  TriggerEvent('player:receiveItem', 'rentalpapers', 1, false, {}, metaData)
end)

RegisterNetEvent("np-npcs:ped:vehiclekeeper")
AddEventHandler("np-npcs:ped:vehiclekeeper", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  if GetHashKey("npc_air_shop") == DecorGetInt(pEntity, "NPC_ID") then
    showVehicleMenu()
  end
end)

RegisterNetEvent("np-npcs:ped:vehiclekeeperrent")
AddEventHandler("np-npcs:ped:vehiclekeeperrent", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  if GetHashKey("npc_air_shop") == DecorGetInt(pEntity, "NPC_ID") then
    showVehicleRentalMenu()
  end
end)
