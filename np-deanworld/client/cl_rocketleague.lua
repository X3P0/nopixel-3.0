local ballName = "v_ilev_exball_blue"
local ballHash = GetHashKey(ballName)
local spawnCarName = "rcbandito"
local spawnCarHash = GetHashKey(spawnCarName)
local mySpawnedVehicle = nil
local mySpawnedVehiclePoint = nil
local ballSpawnCoords = vector3(-1623.91200000, -1084.85600000, 15.25)
local goalOne = nil
local goalTwo = nil
local inSoccerPitch = false
local inGame = false
local inGameIndex = false
local inGameTeam = false
local inGameTeamColor = false
local preGameCoords = nil
local isGameOwner = false
local continueBallLoop = false
local clonedPed = nil
local northGoal = nil
local southGoal = nil
local spawnPoints = {
  ["north"] = {
    vector4(-1617.004, -1085.266, 12.53391, 98.02),
    vector4(-1618.761, -1078.717, 12.53391, 139.62),
    vector4(-1625.579, -1078.064, 12.53483, 176.82),
  },
  ["south"] = {
    vector4(-1622.281, -1091.662, 12.53483, 98.02 - 90.0),
    vector4(-1629.099, -1091.009, 12.53391, 139.62 + 180.0),
    vector4(-1630.857, -1084.46, 12.53391, 176.82 + 90.0),
  },
}
local pedPoints = {
  ["north"] = {
    { coords = vector3(-1613.96,-1086.96,12.4), heading = 45.28 },
    { coords = vector3(-1612.3,-1085.0,12.4), heading = 45.28 },
    { coords = vector3(-1610.65,-1083.04,12.4), heading = 45.28 },
  },
  ["south"] = {
    { coords = vector3(-1623.32,-1098.23,12.4), heading = 45.28 },
    { coords = vector3(-1621.68,-1096.26,12.4), heading = 45.28 },
    { coords = vector3(-1619.99,-1094.33,12.4), heading = 45.28 },
  },
}

local function getModel(name)
  RequestModel(name)
  while not HasModelLoaded(name) do
    Wait(0)
  end
end

local function waitForSpawn(ent)
  local countCheck = 0
  local abandonLoop = false
  while not abandonLoop and not DoesEntityExist(ent) do
    countCheck = countCheck + 1
    if countCheck < 30 then
      Wait(100)
    else
      abandonLoop = true
    end
  end
  return DoesEntityExist(ent)
end

function loadAnimDict(dict)
  while (not HasAnimDictLoaded(dict)) do
      RequestAnimDict(dict)
      Citizen.Wait(0)
  end
end

function spawnBall()
  getModel(ballName)
  local ballObj = CreateObject(ballHash, ballSpawnCoords, 1, 1, 0)
  ActivatePhysics(ballObj)
  SetEntityInvincible(ballObj, true)
  SetDisableFragDamage(ballObj, true)
  Citizen.InvokeNative(0xCD71A4ECAB22709E, ballObj)
  SetModelAsNoLongerNeeded(ballObj)
  TriggerServerEvent("np-deanworld:rocketLeagueBallId", NetworkGetNetworkIdFromEntity(ballObj))
end

function spawnCar(goal, spawnIndex, color)
  getModel(spawnCarName)
  mySpawnedVehiclePoint = spawnPoints[goal][spawnIndex]
  mySpawnedVehicle = CreateVehicle(spawnCarHash, mySpawnedVehiclePoint, 1, 1)
  local isSpawned = waitForSpawn(mySpawnedVehicle)
  if not isSpawned then
    mySpawnedVehicle = nil
    mySpawnedVehiclePoint = nil
    return false
  end
  DoScreenFadeOut(400)
  Wait(400)
  SetVehicleModKit(mySpawnedVehicle, 0)
  SetVehicleMod(mySpawnedVehicle, 3, 316, 0)
  SetVehicleMod(mySpawnedVehicle, 5, 1, 0)
  SetVehicleMod(mySpawnedVehicle, 41, 0, 0)
  SetVehicleColours(mySpawnedVehicle, color == "red" and 28 or 73, 0) -- 28 red 73 blue
  SetEntityInvincible(mySpawnedVehicle, true)
  SetVehicleDirtLevel(mySpawnedVehicle, 0.0)

  local clonedPedSpawnPoint = pedPoints[goal][spawnIndex]
  clonedPed = ClonePed(PlayerPedId(), 1, 1, 1)
  while clonedPed == 0 do
    Wait(0)
  end
  preGameCoords = clonedPedSpawnPoint.coords
  SetEntityCoords(clonedPed, clonedPedSpawnPoint.coords)
  SetEntityHeading(clonedPed, clonedPedSpawnPoint.heading)
  SetEntityInvincible(clonedPed, true)
  FreezeEntityPosition(clonedPed, true)
  SetEntityCollision(clonedPed, false, false)
  TaskSetBlockingOfNonTemporaryEvents(clonedPed, true)
  ClearPedTasksImmediately(clonedPed)
  local animDict = "amb@prop_human_bum_shopping_cart@male@idle_a"
  local animation = "idle_c"
  loadAnimDict(animDict)
  local animLength = GetAnimDuration(animDict, animation)
  TaskPlayAnim(clonedPed, animDict, animation, 1.0, 4.0, animLength, 1, 0, 0, 0, 0)

  Citizen.CreateThread(function()
    while inGame do
      SetEntityCoords(clonedPed, clonedPedSpawnPoint.coords)
      SetEntityHeading(clonedPed, clonedPedSpawnPoint.heading)
      FreezeEntityPosition(clonedPed, true)
      if not IsEntityPlayingAnim(clonedPed, animDict, animation, 3) then
        TaskPlayAnim(clonedPed, animDict, animation, 1.0, 4.0, animLength, 1, 0, 0, 0, 0)
      end
      Citizen.Wait(1000)
    end
  end)

  TaskWarpPedIntoVehicle(PlayerPedId(), mySpawnedVehicle, -1)
  SetModelAsNoLongerNeeded(spawnCarName)
  DoScreenFadeIn(1000)
  return true
end

function joinGame(pGoal, pIndex)
  inGame = false
  inGameTeam = false
  inGameIndex = false
  if not IS_DEAN_WORLD_OPEN then
    TriggerEvent("DoLongHudText", _L("deanworld-closed", "Dean World is closed!"), 2)
    return
  end
  local teamColors = RPC.execute("np-deanworld:rocketLeagueJoinGame", pGoal, pIndex)
  if not teamColors then return end
  inGame = true
  inGameTeam = pGoal
  inGameIndex = pIndex
  inGameTeamColor = teamColors[pGoal]
  local wasSpawned = spawnCar(pGoal, pIndex, inGameTeamColor)
  if not wasSpawned then
    return
  end
  Citizen.CreateThread(function()
    while inGame do
      local veh = GetVehiclePedIsIn(PlayerPedId(), false)
      if not veh or veh == 0 then
        leaveGame()
      end
      Citizen.Wait(250)
    end
  end)
end

function leaveGame()
  if not inGame then return end
  inGame = false
  DoScreenFadeOut(100)
  Wait(400)
  if mySpawnedVehicle then
    Sync.DeleteVehicle(mySpawnedVehicle)
    mySpawnedVehicle = nil
    mySpawnedVehiclePoint = nil
  end
  if clonedPed then
    Sync.DeleteEntity(clonedPed)
    clonedPed = nil
  end
  RPC.execute("np-deanworld:rocketLeagueLeaveGame", inGameTeam, inGameIndex)
  SetEntityCoords(PlayerPedId(), preGameCoords)
  preGameCoords = nil
  continueBallLoop = false
  DoScreenFadeIn(1000)
end

RegisterNetEvent("np-deanworld:rocketLeagueSetBallId")
AddEventHandler("np-deanworld:rocketLeagueSetBallId", function(pNetId)
  if not inGame then return end
  Citizen.CreateThread(function()
    local ballObj = NetworkGetEntityFromNetworkId(pNetId)
    continueBallLoop = true
    while ballObj and ballObj ~= 0 and continueBallLoop do
      local ballCoords = GetEntityCoords(ballObj)
      if northGoal:isPointInside(ballCoords) then
        TriggerServerEvent("np-deanworld:rocketLeagueGoalScored", "north", pNetId)
      elseif southGoal:isPointInside(ballCoords) then
        TriggerServerEvent("np-deanworld:rocketLeagueGoalScored", "south", pNetId)
      end
      Citizen.Wait(250)
    end
  end)
end)

RegisterNetEvent("np-deanworld:rocketLeagueStats")
AddEventHandler("np-deanworld:rocketLeagueStats", function(stats)
  if not inSoccerPitch then return end
  local titleExtra = ""
  local values = {}
  if not stats.gameInProgress then
    titleExtra = " - " .. _L("deanworld-rocket-ready-for-players", "Ready for players!")
    values[#values + 1] = _L("deanworld-blue-team", "Blue Team") .. ": " .. stats.bluePlayers .. " " .. _L("deanworld-players", "players")
    values[#values + 1] = _L("deanworld-red-team", "Red Team") .. ": " .. stats.redPlayers .. " " .. _L("deanworld-players", "players")
  else
    titleExtra = " - " .. _L("deanworld-game-in-progress", "Game in progress!")
    values[#values + 1] = {
      center = true,
      text = _L("deanworld-blue", "Blue") .. " " .. stats.blueScore .. " - " .. stats.redScore .. " " .. _L("deanworld-red", "Red")
    }
    values[#values + 1] = {
      center = true,
      seconds = stats.timeRemaining,
      type = "countdown",
    }
  end
  exports["np-ui"]:sendAppEvent("status-hud", {
    show = true,
    title = _L("deanworld-bumper-ball", "Bumper Ball") .. titleExtra,
    values = values,
  })
end)

RegisterNetEvent("np-deanworld:rocketLeagueFinishGame")
AddEventHandler("np-deanworld:rocketLeagueFinishGame", function(blueScore, redScore)
  leaveGame()
  if not inSoccerPitch then return end
  TriggerEvent("DoLongHudText", _L("deanworld-final-score", "Final score") .. ": " .. _L("deanworld-blue", "Blue") .. " " .. tostring(blueScore) .. " - " .. tostring(redScore) .. " " .. _L("deanworld-red", "Red"), 1, 12000, { i18n = { "Final score", "Blue", "Red" }})
end)

RegisterNetEvent("np-deanworld:rocketLeagueSpawnBall")
AddEventHandler("np-deanworld:rocketLeagueSpawnBall", function(pSource)
  continueBallLoop = false
  if not inGame then return end
  if pSource ~= GetPlayerServerId(PlayerId()) then return end
  spawnBall()
end)

RegisterNetEvent("np-deanworld:rocketLeagueGameStartCountdown")
AddEventHandler("np-deanworld:rocketLeagueGameStartCountdown", function(pSeconds)
  if not inSoccerPitch then return end
  Citizen.CreateThread(function()
    local lc = pSeconds
    while lc > 0 do
      TriggerEvent("DoLongHudText", _L("deanworld-game-starts-in", "Game starts in") .. ": " .. tostring(lc) .. " " .. _L("deanworld-seconds", "seconds") .. "!")
      lc = lc - 1
      Citizen.Wait(1000)
    end
    TriggerEvent("DoLongHudText", _L("deanworld-game-started", "Game started!"))
    if inGame then
      DoScreenFadeOut(500)
      Citizen.Wait(250)
      SetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false), mySpawnedVehiclePoint)
      SetEntityHeading(GetVehiclePedIsIn(PlayerPedId(), false), mySpawnedVehiclePoint[4])
      Citizen.Wait(250)
      DoScreenFadeIn(200)
    end
  end)
end)

AddEventHandler("np-deanworld:rocketLeagueJoinGame", function(a, b, c)
  joinGame(c.zones["rc_soccer_entry_pad"].ref, c.zones["rc_soccer_entry_pad"].goalIndex)
end)

AddEventHandler("np-polyzone:enter", function(name)
  if name ~= "rc_soccer_pitch" then return end
  inSoccerPitch = true
  RPC.execute("np-deanworld:rocketLeagueGetStats")
end)

AddEventHandler("np-polyzone:exit", function(name)
  if name ~= "rc_soccer_pitch" then return end
  inSoccerPitch = false
  exports["np-ui"]:sendAppEvent("status-hud", { show = false })
  leaveGame()
end)

AddEventHandler("np-deanworld:purchaseRLUpgrades", function()
  TriggerEvent("DoLongHudText", _L("deanworld-upgrades-soon", "Jump / Boost / Cosmetic upgrades coming soon!"))
end)

RegisterUICallback("np-ui:rl:changePlayerCount", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  TriggerServerEvent("np-deanworld:rl:changePlayerCount", tonumber(data.key))
end)

AddEventHandler("np-deanworld:rocketLeagueChangePlayers", function()
  local data = {}
  data[#data + 1] = {
    title = "1 vs 1",
    description = "",
    key = "1",
    action = "np-ui:rl:changePlayerCount",
  }
  data[#data + 1] = {
    title = "2 vs 2",
    description = "",
    key = "2",
    action = "np-ui:rl:changePlayerCount",
  }
  data[#data + 1] = {
    title = "3 vs 3",
    description = "",
    key = "3",
    action = "np-ui:rl:changePlayerCount",
  }
  exports["np-ui"]:showContextMenu(data)
end)

-- polyzones
Citizen.CreateThread(function()
  exports["np-polyzone"]:AddBoxZone("rc_soccer_pitch", vector3(-1624.08, -1084.72, 13.24), 21.2, 29.2, {
    heading=230,
    minZ=12.04,
    maxZ=16.64,
    data = {
      id = 1,
      ref = "soccer_pitch_1",
    },
  })
  northGoal = BoxZone:Create(vector3(-1616.29, -1075.88, 13.24), 1.2, 5.4, {
    name="rc_soccer_pitch_goal",
    heading=320,
    minZ=12.04,
    maxZ=15.04,
  })
  southGoal = BoxZone:Create(vector3(-1631.47, -1093.8, 13.24), 1.2, 5.4, {
    name="rc_soccer_pitch_goal",
    heading=320,
    minZ=12.04,
    maxZ=15.04,
  })
  exports["np-polytarget"]:AddBoxZone("rc_soccer_entry_pad", vector3(-1623.89, -1097.76, 13.12), 0.8, 0.6, {
    heading=320,
    minZ=13.12,
    maxZ=13.52,
    data = {
      id = 1,
      goalIndex = 1,
      ref = "south",
    },
  })
  exports["np-polytarget"]:AddBoxZone("rc_soccer_entry_pad", vector3(-1622.13, -1095.9, 13.32), 0.8, 0.6, {
    heading=320,
    minZ=13.12,
    maxZ=13.52,
    data = {
      id = 2,
      goalIndex = 2,
      ref = "south",
    },
  })
  exports["np-polytarget"]:AddBoxZone("rc_soccer_entry_pad", vector3(-1620.64, -1093.81, 13.32), 0.8, 0.6, {
    heading=320,
    minZ=13.12,
    maxZ=13.52,
    data = {
      id = 3,
      goalIndex = 3,
      ref = "south",
    },
  })
  exports["np-polytarget"]:AddBoxZone("rc_soccer_entry_pad", vector3(-1614.46, -1086.65, 13.32), 0.8, 0.6, {
    heading=320,
    minZ=13.12,
    maxZ=13.52,
    data = {
      id = 4,
      goalIndex = 1,
      ref = "north",
    },
  })
  exports["np-polytarget"]:AddBoxZone("rc_soccer_entry_pad", vector3(-1612.78, -1084.66, 13.32), 0.8, 0.6, {
    heading=320,
    minZ=13.12,
    maxZ=13.52,
    data = {
      id = 5,
      goalIndex = 2,
      ref = "north",
    },
  })
  exports["np-polytarget"]:AddBoxZone("rc_soccer_entry_pad", vector3(-1611.15, -1082.62, 13.32), 0.8, 0.6, {
    heading=320,
    minZ=13.12,
    maxZ=13.52,
    data = {
      id = 6,
      goalIndex = 3,
      ref = "north",
    },
  })
  exports['np-interact']:AddPeekEntryByPolyTarget('rc_soccer_entry_pad', {{
    event = "np-deanworld:rocketLeagueJoinGame",
    id = "rljoingame",
    icon = "play",
    label = _L("deanworld-join-game", "Join game!"),
    parameters = {},
  }}, {
    distance = { radius = 2.5 },
  })
  exports['np-interact']:AddPeekEntryByPolyTarget('rc_soccer_entry_pad', {{
    event = "np-deanworld:rocketLeagueChangePlayers",
    id = "rlchangeplayers",
    icon = "circle",
    label = _L("deanworld-change-players", "Change Player Count"),
    parameters = {},
  }}, {
    distance = { radius = 2.5 },
  })

  -- if GetPlayerServerId(PlayerId()) == 1 then
  --   local testFloat = 0.0
  --   while true do
  --     getModel(ballName)
  --     local ballObj = CreateObject(ballHash, vector3(-1599.86,-1106.13,15.68), 1, 1, 0)
  --     ActivatePhysics(ballObj)
  --     SetEntityInvincible(ballObj, true)
  --     SetDisableFragDamage(ballObj, true)
  --     SetModelAsNoLongerNeeded(ballObj)
  --     SetObjectPhysicsParams(
  --       ballObj, -- Object object
  --       100.0, -- float weight
  --       100.0, -- float p2 seems to be weight and gravity related. Higher value makes the obj fall faster. Very sensitive?  
  --       100.0, -- float p3 seems similar to p2  
  --       0.0, -- float p4 makes obj fall slower the higher the value  
  --       0.0, -- float p5 makes obj fall slower the higher the value  
  --       100.0, -- float gravity
  --       0.0, -- float p7
  --       0.0, -- float p8
  --       0.0, -- float p9
  --       0.0, -- float p10
  --       0.0) -- float bouancy
  --     testFloat = testFloat + 1.0
  --     Citizen.Wait(2500)
  --     DeleteEntity(ballObj)
  --   end
  -- end
end)

-- test commands
-- RegisterCommand("ballspawn", function()
--   DeleteObject(ballObj)
--   spawnBall()
-- end, false)

-- RegisterCommand("carspawn", function()
--   spawnCar("south", 1, "red")
-- end, false)

-- RegisterCommand("joingame", function()
--   joinGame("south", 1)
--   Wait(2000)
--   joinGame("south", 2)
--   Wait(2000)
--   joinGame("south", 3)
-- end)

-- RegisterCommand("leavegame", function()
--   leaveGame()
-- end)

-- RegisterCommand("carstuff", function()
--   print('GetVehicleModKit', GetVehicleModKit(GetVehiclePedIsIn(PlayerPedId())))
--   print('GetVehicleModKitType', GetVehicleModKitType(GetVehiclePedIsIn(PlayerPedId())))
--   local i = 0
--   while i < 100 do
--     print('GetVehicleMod: ', i, GetVehicleMod(GetVehiclePedIsIn(PlayerPedId()), i))
--     i = i + 1
--   end
-- end)
