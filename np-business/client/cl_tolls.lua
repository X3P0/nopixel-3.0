Citizen.CreateThread(function()
  -- tolls
  exports["np-polytarget"]:AddBoxZone("toll_control", vector3(183.76, -2959.55, 6.2), 0.6, 0.8, {
    heading = 0,
    minZ = 5.8,
    maxZ = 6.2,
    data = {},
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("toll_control", {{
    event = "np-business:tolls:toggleDocks",
    id = "toll_control_1",
    icon = "circle",
    label = "Toggle 'IN' Gate",
    parameters = { "in" },
  },{
    event = "np-business:tolls:toggleDocks",
    id = "toll_control_2",
    icon = "circle",
    label = "Toggle 'OUT' Gate",
    parameters = { "out" },
  }}, { distance = { radius = 3.5 }})
end)

AddEventHandler("np-business:tolls:toggleDocks", function(pArgs)
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "tollsrus"} })
  if not jobAccess then
    TriggerEvent("DoLongHudText", "You cannot use that", 2)
    return
  end
  local type = pArgs[1]
  local doorId = 0
  if type == "in" then
    doorId = 542
  else
    doorId = 543
  end
  TriggerServerEvent("np-business:doors:toggleLockState", doorId)
end)