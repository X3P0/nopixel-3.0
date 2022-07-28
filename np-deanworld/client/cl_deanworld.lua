IS_DEAN_WORLD_OPEN = false
local inDeanWorld = false
local screenUrl = "https://i.imgur.com/que3k9U.gif"
local stageLasers = {}
local lasersActive = false
local dwDui = nil

local laserStartPoints = {
  vector3(-1708.143, -1118.798, 18.233), vector3(-1712.99, -1114.295, 18.233), vector3(-1715.504, -1126.564, 18.265), vector3(-1711.787, -1122.662, 18.259), vector3(-1720.232, -1122.084, 18.233), vector3(-1716.582, -1118.176, 18.242), vector3(-1717.928, -1124.304, 18.243), vector3(-1710.374, -1116.698, 18.239),vector3(-1713.793, -1124.813, 18.351), vector3(-1709.852, -1120.587, 18.383), vector3(-1718.38, -1120.104, 18.266), vector3(-1714.688, -1116.145, 18.286), vector3(-1715.854, -1119.022, 19.522), vector3(-1712.621, -1122.028, 19.522), vector3(-1716.591, -1118.214, 19.522), vector3(-1711.851, -1122.636, 19.522), vector3(-1713.945, -1120.846, 19.522)
}
local laserGridPoints = {
  vector3(-1713.19, -1115.173, 12.987), vector3(-1709.722, -1119.036, 12.987), vector3(-1714.208, -1120.434, 12.987), vector3(-1715.24, -1124.777, 12.987), vector3(-1719.312, -1121.682, 12.987), vector3(-1716.399, -1118.379, 12.987), vector3(-1712.011, -1122.468, 12.987), vector3(-1717.283, -1123.323, 12.987), vector3(-1713.101, -1119.223, 12.987), vector3(-1715.308, -1121.568, 12.987), vector3(-1711.936, -1120.356, 12.987), vector3(-1714.357, -1118.08, 12.987), vector3(-1716.43, -1120.424, 12.987), vector3(-1717.535, -1121.622, 12.987), vector3(-1715.208, -1123.747, 12.987), vector3(-1716.342, -1122.701, 12.987), vector3(-1714.19, -1122.666, 12.987), vector3(-1713.09, -1121.483, 12.987), vector3(-1710.866, -1119.167, 12.987), vector3(-1712.006, -1118.077, 12.987), vector3(-1713.195, -1117.024, 12.987), vector3(-1711.137, -1117.084, 12.987), vector3(-1714.311, -1115.978, 12.987), vector3(-1718.555, -1120.589, 12.987), vector3(-1714.138, -1124.792, 12.987), vector3(-1710.923, -1121.363, 12.987), vector3(-1709.824, -1119.995, 12.987)
}

Citizen.CreateThread(function()
  exports['np-density']:RegisterDensityReason('deanworld', 10)

  local centerPoint = vector3(-1694.1, -1119.5, 14.7)
  local radiusSize = 180.0

  AddScenarioBlockingArea(centerPoint - radiusSize, centerPoint + radiusSize, false, true, true, true)
  AddPopMultiplierArea(centerPoint - radiusSize, centerPoint + radiusSize, 0.0, 0.0, false)
  SetPedNonCreationArea(centerPoint - radiusSize, centerPoint + radiusSize)
  -- TriggerEvent("server-inventory-open", "42075", "Shop")

  for k, coords in pairs(laserStartPoints) do
      local cLaser = Laser.new(coords, laserGridPoints, {
          travelTimeBetweenTargets = {1.0, 1.0},
          waitTimeAtTargets = {0.0, 0.0},
          randomTargetSelection = true,
          name = "laser_" .. tostring(k),
          color = {0, 255, 100, 200},
          extensionEnabled = false,
      })
      stageLasers[#stageLasers + 1] = cLaser
  end
end)

local function activateLasers(doActivate)
  if not inDeanWorld then return end
  if doActivate and lasersActive then return end
  lasersActive = doActivate
  if not lasersActive then
    for _, v in pairs(stageLasers) do
      v.setActive(false)
    end
    return
  end
  Citizen.CreateThread(function()
    while lasersActive do
      for _, v in pairs(stageLasers) do
        v.setActive(true)
      end
      if math.random() < 0.1 then
        local lc = 0
        local wasActive = true
        while lc < 6 do
          lc = lc + 1
          wasActive = not wasActive
          for _, v in pairs(stageLasers) do
            v.setActive(wasActive)
          end
          Citizen.Wait(125)
        end
        for _, v in pairs(stageLasers) do
          v.setActive(true)
        end
      end
      Citizen.Wait(2500)
    end
    for _, v in pairs(stageLasers) do
      v.setActive(false)
    end
  end)
end

RegisterNetEvent("np-deanworld:isOpen")
AddEventHandler("np-deanworld:isOpen", function(isOpen)
  IS_DEAN_WORLD_OPEN = isOpen
end)

RegisterNetEvent("np-deanworld:activateLasers")
AddEventHandler("np-deanworld:activateLasers", function(doActivate)
  activateLasers(doActivate)
end)

AddEventHandler("np-polyzone:enter", function(zone, data)
  if zone ~= "farmers_market" then return end
  if data.id ~= "deanworld" then return end
  IS_DEAN_WORLD_OPEN = RPC.execute("np-deanworld:isDWOpen")
  exports['np-density']:ChangeDensity('deanworld', 0.0)
  inDeanWorld = true
  dwDui = exports["np-lib"]:getDui(screenUrl, 1024, 1024)
  AddReplaceTexture("dw_stage_txd", "dw_stage_screen_tx", dwDui.dictionary, dwDui.texture)
end)

AddEventHandler("np-polyzone:exit", function(zone, data)
  if zone ~= "farmers_market" then return end
  exports['np-density']:ChangeDensity('deanworld', -1)
  inDeanWorld = false
  if dwDui ~= nil then
    RemoveReplaceTexture("dw_stage_txd", "dw_stage_screen_tx")
    exports["np-lib"]:releaseDui(dwDui.id)--, "dw_stage_txd", "dw_stage_screen_tx")
  end
end)

RegisterNetEvent("np-deanworld:changeScreenImage")
AddEventHandler("np-deanworld:changeScreenImage", function(url)
  if inDeanWorld and dwDui ~= nil then
    exports["np-lib"]:changeDuiUrl(dwDui.id, url)
  end
  screenUrl = url
end)

local pickupCids = {
  -- [1001] = true, -- Dw Test
  [3503] = true, -- Dean
  [1652] = true, -- Locksley
}
AddEventHandler("np-deanworld:findLostStuff", function(zone, data)
  local charId = exports["isPed"]:isPed("cid")
  if not pickupCids[charId] then
    TriggerEvent("DoLongHudText", _L("deanworld-lost-nothing-found", "Nothing found."), 2)
    return
  end
  local hasCash = RPC.execute("np-deanworld:getOwedCash")
  exports["np-ui"]:sendAppEvent("game", { getDeanWorldCsv = true })
  TriggerEvent("DoLongHudText", _L("deanworld-lost-handed-note", "They handed you a note."))
  if hasCash then
    TriggerEvent("player:receiveItem", "SecurityCase", 1)
    TriggerEvent('attach:securityCase')
  end
end)

AddEventHandler("np-deanworld:buyShitFood", function(zone, data)
  TriggerEvent("server-inventory-open", "42075", "Shop")
end)

AddEventHandler("np-deanworld:dropOffCases", function(zone, pEntity, p3)
  local charId = exports["isPed"]:isPed("cid")
  local result = RPC.execute("np-deanworld:dropOffCases", charId)
  if not result then return end
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed, true)
  SetPedCanRagdoll(playerPed, false)
  PlayAmbientSpeech1(pEntity, 'Generic_Hi', 'Speech_Params_Force')
  TaskTurnPedToFaceEntity(playerPed, pEntity, 1000)
  TriggerEvent("attach:securityCase")
  Wait(1000)
  RequestAnimDict("mp_safehouselost@")
  while not HasAnimDictLoaded("mp_safehouselost@") do
    Wait(0)
  end
  TaskPlayAnim(playerPed, 'mp_safehouselost@', 'package_dropoff', 8.0, -8.0, -1, 1, 0, false, false, false)
  Wait(3000)
  SetPedCanRagdoll(playerPed, true)
  ClearPedTasks(playerPed)
  TriggerEvent("attach:securityCase")
end)

AddEventHandler("np-deanworld:buyAdministrationTicket", function(zone, data)
  TriggerEvent("DoLongHudText", _L("deanworld-admin-funny", "They look at you funny."), 2)
end)

AddEventHandler("nikez-rollercoaster:canSpawnCoaster", function()
  if IS_DEAN_WORLD_OPEN then
    TriggerEvent('nikez-rollercoaster:spawnCoaster')
  end
end)

AddEventHandler("nikez-freefalltower:canSpawnRide", function()
  if IS_DEAN_WORLD_OPEN then
    TriggerEvent('nikez-freefalltower:spawnRide')
  end
end)

-- college field stuff
Citizen.CreateThread(function()
  exports["np-polyzone"]:AddBoxZone("collegefieldscreen", vector3(-1744.18, 171.33, 64.37), 25, 25, {
    heading=305,
    minZ=62.77,
    maxZ=66.97,
    data = {
      id = 1,
    },
  })
end)
local inCollegeField = false
local collgeFieldScreenUrl = "https://i.imgur.com/que3k9U.gif"
local collegeFieldDui = nil
AddEventHandler("np-polyzone:enter", function(zone, data)
  if zone ~= "collegefieldscreen" then return end
  inCollegeField = true
  collegeFieldDui = exports["np-lib"]:getDui(collgeFieldScreenUrl, 1024, 1024)
  AddReplaceTexture("dw_stage_txd", "dw_stage_screen_tx", collegeFieldDui.dictionary, collegeFieldDui.texture)
end)

AddEventHandler("np-polyzone:exit", function(zone, data)
  if zone ~= "collegefieldscreen" then return end
  inCollegeField = false
  if collegeFieldDui ~= nil then
    RemoveReplaceTexture("dw_stage_txd", "dw_stage_screen_tx")
    exports["np-lib"]:releaseDui(collegeFieldDui.id)
  end
end)

RegisterNetEvent("np-deanworld:changeCollegeScreenImage")
AddEventHandler("np-deanworld:changeCollegeScreenImage", function(pUrl)
  if inCollegeField and collegeFieldDui ~= nil then
    exports["np-lib"]:swapDuiUrl(collegeFieldDui.id, pUrl)
  end
  collgeFieldScreenUrl = pUrl
end)
