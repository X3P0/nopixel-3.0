RegisterUICallback("np-ui:car-clothing:swapCurrentOutfit", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  exports["np-ui"]:closeApplication("textbox")
  TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)
  local finished = exports["np-taskbar"]:taskBar(30000, "Swapping Outfit")
  ClearPedTasksImmediately(PlayerPedId())
  if finished ~= 100 then return end
  local rd = RPC.execute("np-car-clothing:swapCurrentOutfit", NetworkGetNetworkIdFromEntity(data.key), data.values)
  rd = rd[1]
  exports['np-vehicles']:SetVehicleAppearance(data.key, rd.app)
  exports['np-vehicles']:SetVehicleMods(data.key, rd.mods)
  exports['np-vehicles']:SetVehicleColors(data.key, rd.colors)
end)

AddEventHandler("np-car-clothing:swapCurrentOutfit", function(p1, pEntity)
  exports["np-ui"]:openApplication("textbox", {
    callbackUrl = "np-ui:car-clothing:swapCurrentOutfit",
    key = pEntity,
    items = {
      {
        label = "Slot",
        name = "slot",
        _type = "select",
        options = {
          {
            name = "1",
            id = "1",
          },
          {
            name = "2",
            id = "2",
          },
        },
      },
    },
    show = true,
  })
end)

RegisterUICallback("np-ui:car-clothing:saveCurrentOutfit", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  exports["np-ui"]:closeApplication("textbox")
  RPC.execute("np-car-clothing:saveCurrentOutfit", NetworkGetNetworkIdFromEntity(data.key), data.values)
end)

AddEventHandler("np-car-clothing:saveCurrentOutfit", function(p1, pEntity, p3)
  exports["np-ui"]:openApplication("textbox", {
    callbackUrl = "np-ui:car-clothing:saveCurrentOutfit",
    key = pEntity,
    items = {
      { label = "Name", name = "name" },
      {
        label = "Slot",
        name = "slot",
        _type = "select",
        options = {
          {
            name = "1",
            id = "1",
          },
          {
            name = "2",
            id = "2",
          },
        },
      },
    },
    show = true,
  })
end)

Citizen.CreateThread(function()
  exports["np-polyzone"]:AddBoxZone("custom_car_clothing", vector3(143.13, 319.25, 112.14), 16.2, 9.2, {
    name="usethis",
    heading=295,
    minZ=110.74,
    maxZ=113.94,
  })
  exports["np-polyzone"]:AddBoxZone("bennys", vector3(143.13, 319.25, 112.14), 16.2, 9.2, {
    name="usethis",
    heading=295,
    minZ=110.74,
    maxZ=113.94,
  })
end)
