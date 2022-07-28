local hiddenBikes = {
  ["bimx"] = true
}

local function showBicycleMenu(hideBikes)
    local bicycles = RPC.execute("bicycles:getBicycles")
    local data = {}
    for _, bike in pairs(bicycles) do
        if hideBikes[bike.model] ~= nil then goto continue end
        data[#data + 1] = {
            title = bike.name,
            description = "$" .. bike.retail_price .. ".00",
            image = bike.hd_image_url,
            key = bike.model,
            children = {
                { title = "Purchase Bicycle", action = "np-ui:bicyclesPurchase", key = bike.model },
            },
        }
        ::continue::
    end
    exports["np-ui"]:showContextMenu(data)
end

RegisterUICallback("np-ui:bicyclesPurchase", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })

    data.model = data.key
    data.vehicle_name = GetLabelText(GetDisplayNameFromVehicleModel(data.model))

    local finished = exports["np-taskbar"]:taskBar(15000, "Purchasing...", true)
    if finished ~= 100 then
      cb({ data = {}, meta = { ok = false, message = 'cancelled' } })
      return
    end

    local success, message = RPC.execute("bicycles:purchaseBicycle", data)
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
end)

RegisterNetEvent("np-npcs:ped:vehiclekeeper")
AddEventHandler("np-npcs:ped:vehiclekeeper", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  if GetHashKey("npc_bike_shop") == DecorGetInt(pEntity, "NPC_ID") then
    local shouldHideBikes = RPC.execute("bicycles:shouldHideBikes")
    showBicycleMenu(shouldHideBikes and hiddenBikes or {})
  end
end)
