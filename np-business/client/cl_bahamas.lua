Citizen.CreateThread(function()
  -- Disable for public
  local areStashesPublic = exports['np-config']:GetMiscConfig("business.stashes.public")
  if areStashesPublic then
    return
  end
  
  -- Drinks
  exports["np-polytarget"]:AddBoxZone("bahamas_drinks", vector3(-1386.25, -609.31, 30.32), 1.0, 0.95, {
    heading = 33.0,
    minZ = 29.32,
    maxZ = 31.52,
    data = {
      id = "bahamas_drinks"
    },
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("bahamas_drinks", {{
    event = "np-business:client:openBahamasDrinks",
    id = "yellowJackDrinks",
    icon = "cocktail",
    label = _L("restaurant-open", "Open"),
    parameters = { },
  }}, { distance = { radius = 3.5 }  })

end)

AddEventHandler("np-business:client:openBahamasDrinks", function()
  local hasAccess = HasPermission("bahama_mamas", "craft_access")

  if not hasAccess then
    TriggerEvent("DoLongHudText", "Sorry you can't use this.", 2)
    return
  end

  TriggerEvent('server-inventory-open', '42093', 'Shop')
end)
