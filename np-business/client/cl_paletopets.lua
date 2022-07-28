AddEventHandler("np-business:paletopets:openMenu", function(data)
  exports["np-companions"]:openAccessoryMenu(data.companionType, false)
end)

Citizen.CreateThread(function()

  exports["np-polytarget"]:AddBoxZone(
    "paleto_pets_vendor",
    vector3(-288.16, 6299.1, 31.49), 0.6, 1.4,
    {
      heading=45,
      minZ=30.29,
      maxZ=32.69
    }
  );

  local pets = exports["np-companions"]:getPetsWithAccessories()
  local items = {}
  for k, v in ipairs(pets) do
    items[#items + 1] = {
      event = "np-business:paletopets:openMenu",
      id = "paleto_pets_" .. v.type,
      icon = "book",
      label = "Browse " .. v.name .. " Accessories",
      parameters = {
        companionType = v.type
      }
    }
  end

  exports["np-interact"]:AddPeekEntryByPolyTarget(
    "paleto_pets_vendor",
    items,
    {
      distance = { radius = 2.0 }
    }
  )
end)
