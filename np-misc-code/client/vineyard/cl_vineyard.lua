AddEventHandler("np-vineyard:npcManager", function(p1)
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "hero_wine"} })
  if not jobAccess then
    TriggerEvent("DoLongHudText", "They don't recognize you.", 2)
    return
  end
  if p1.id == "start_harvest" then
    RPC.execute("np-vineyard:startHarvest")
    return
  end
  if p1.id == "rent_atv" then
    local finished = exports["np-taskbar"]:taskBar(math.random(5000, 10000), "Grabbing ATV")
    if finished ~= 100 then return end
    RPC.execute("np-business:herowine:chargeCompany", 5000)
    local cid = exports["isPed"]:isPed("cid")
    local rentalData = RPC.execute("np:vehicles:rentalSpawn", "verus", { x = -1926.68, y = 2065.61, z = 140.62 }, 256.71)
    local vehId = NetworkGetEntityFromNetworkId(rentalData.netId)
    SetVehicleDirtLevel(vehId, 0.0)
    RemoveDecalsFromVehicle(vehId)
    local metaData = json.encode({
      model = model,
      netId = rentalData.netId,
      state_id = cid,
    })
    TriggerEvent('player:receiveItem', 'rentalpapers', 1, false, {}, metaData)
    return
  end
  if p1.id == "buy_equipment" then
    TriggerEvent("server-inventory-open", "42131", "Shop")
    return
  end
end)

AddEventHandler("np-vineyard:pickupBasket", function(p1, p2, p3)
  if p3 and p3.meta and p3.meta.data and p3.meta.data.metadata and p3.meta.data.metadata.type == "vineyard_grape_basket" then
    local data = p3.meta.data.metadata
    local objectId = p3.meta.id
    RPC.execute("np-vineyard:pickupBasket", objectId, data)
  end
end)

Citizen.CreateThread(function()
  exports["np-interact"]:AddPeekEntryByModel({ `prop_fruit_basket` }, {
    {
      id = "peek_prop_fruit_basket",
      event = "np-vineyard:pickupBasket",
      icon = "shopping-basket",
      label = "Pick Up",
    },
  }, {
    distance = { radius = 5.0 },
    isEnabled = function(p1, p2, p3)
      return p2 and p2.meta and p2.meta.data and p2.meta.data.metadata and p2.meta.data.metadata.type == "vineyard_grape_basket"
    end,
  })
end)

-- GRAPELINES (LOL)
-- local colors = {}
-- Citizen.CreateThread(function()
--   while true do
--     for k, coord in pairs(GRAPE_COORDS) do
--       if not colors[k] then
--         colors[k] = { math.random(255), math.random(255), math.random(255) }
--       end
--       DrawLine(coord.x, coord.y, coord.z - 1000.0, coord.x, coord.y, coord.z + 1000.0, colors[k][1], colors[k][2], colors[k][3], 255)
--     end
--     Wait(0)
--   end
-- end)
