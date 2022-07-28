Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("bucky_entrance", vector3(1012.33, -3311.5, 5.9), 1.2, 0.6, {
    heading=359,
    minZ=6.0,
    maxZ=7.0,
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("bucky_entrance", {{
    id =  'bucky_entrance',
    label =  'Elevator',
    icon =  'circle',
    event = "np-bucky:enterBunker",
    parameters =  {},
  }}, { distance = { radius = 1.5 } })

  exports["np-polytarget"]:AddBoxZone("bucky_exit", vector3(857.2, -3250.62, -98.36), 0.6, 0.6, {
    heading=359,
    minZ=-98.36,
    maxZ=-97.76,
  })
  exports["np-polytarget"]:AddBoxZone("bucky_exit", vector3(239.28, -1003.8, -99.0), 0.4, 0.4, {
    heading=5,
    minZ=-99.0,
    maxZ=-98.6,
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("bucky_exit", {{
    id =  'bucky_exit',
    label =  'Elevator',
    icon =  'circle',
    event = "np-bucky:exitBunker",
    parameters =  {},
  }}, { distance = { radius = 1.5 } })
end)

AddEventHandler("np-bucky:enterBunker", function()
  exports["np-ui"]:openApplication("textbox", {
    callbackUrl = "np-ui:bucky:enterBunker",
    key = "np-ui:bucky:enterBunker",
    items = {
      {
        icon = "user-edit",
        label = "Password",
        name = "pass",
        type = "password",
      }
    },
    show = true,
  })
end)

AddEventHandler("np-bucky:exitBunker", function()
  local finished = exports["np-taskbar"]:taskBar(math.random(1000, 4000), "Waiting for Elevator")
  if finished ~= 100 then return end
  DoScreenFadeOut(400)
  Wait(400)
  SetEntityCoords(PlayerPedId(), vector3(1013.25,-3311.64,5.91))
  SetEntityHeading(PlayerPedId(), 266.73)
  Wait(400)
  DoScreenFadeIn(400)
end)

local coordsHeading = {
  ["1111"] = { vector3(240.84,-1004.76,-98.99), 87.65 },
  ["6565"] = { vector3(857.24,-3249.82,-98.34), 1.28 },
}
RegisterUICallback("np-ui:bucky:enterBunker", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "" } })
  exports["np-ui"]:closeApplication("textbox")
  local coordsH = coordsHeading[data.values.pass]
  if not coordsH then return end
  local finished = exports["np-taskbar"]:taskBar(math.random(1000, 4000), "Waiting for Elevator")
  if finished ~= 100 then return end
  DoScreenFadeOut(400)
  Wait(600)
  SetEntityCoords(PlayerPedId(), coordsH[1])
  SetEntityHeading(PlayerPedId(), coordsH[2])
  -- Wait(400)
  -- if coordsH[3] then
  --   local intId = GetInteriorAtCoords(coordsH[3])
  --   local roomHash = -1711658181
  --   ForceRoomForEntity(PlayerPedId(), intId, roomHash)
  --   Wait(500)
  -- end
  Wait(400)
  DoScreenFadeIn(400)
end)
-- Citizen.CreateThread(function()
--   local coords = GetInteriorAtCoords(197.8153, -1002.293, -99.65749)
--   print(coords)
--   local roomHash = GetRoomKeyFromEntity(PlayerPedId())
--   print(roomHash)
-- end)
