
-- RegisterCommand("grabObject", function()
--   local objHash = 887694239
--   local newData = {}
--   for _, v in pairs(COORDS_FOR_SERVER_BOXES) do
--     local coords = vector3(v.coords[1], v.coords[2], v.coords[3])
--     local obj = GetClosestObjectOfType(coords, 1.0, objHash, 0, 0, 0)
--     print(v.code, GetEntityHeading(obj))
--     v.heading = GetEntityHeading(obj)
--     newData[#newData + 1] = v
--   end
--   print(json.encode(newData, { indent = true }))
-- end, false)


-- Citizen.CreateThread(function()
--   local id = 0
--   local row = 0
--   for _, coords in pairs(COORDS_FOR_SERVER_BOXES) do
--     id = id + 1
--     row = math.floor((id - 1) / 7)
--     local start = 39 - (row * 7)
--     local endRun = 42 - (row * 7)
--     local code = (start + (math.floor(((id - 1) / 7)) - 1)) > endRun and "B" or "A"
--     local addr = start + (id - (code == "A" and 1 or 5))
--     TriggerServerEvent("np-scenes:addSceneToClients", {
--       coords = vector3(coords.coords[1], coords.coords[2], coords.coords[3]),
--       text = "<font size='50'>" .. coords.code .. " (" .. coords.id .. ") - (" .. coords.label .. ") - (" .. coords.heading .. ") </font>",
--       distance = 33,
--       color = "white",
--       caret = false,
--       font = 0,
--       solid = false,
--       background = {
--         r = 0,
--         g = 0,
--         b = 0,
--         alpha = 0,
--       }
--     })
--   end
-- end)



