local inServerFarm = false
local activeComputerCode = nil
local isHeistActive = false
local heistSpawnMultiplier = 5.0
local computersHacked = 0
local allPeds = {}
local blackoutEnabled = false
local blackoutProcessed = false
IS_DEAD = false
DEBUG_MODE = false
MAX_PED_SPAWN_AMOUNT = 3

local pedModels = {
  { model = "s_m_m_marine_01", props = { { 0, 2, 0, 0 } } },
  { model = "s_m_m_marine_02", props = { { 0, 2, 0, 0 } } },
  { model = "s_m_y_marine_01", props = { { 0, 2, 0, 0 } } },
  { model = "s_m_y_marine_02", props = { { 0, 2, 0, 0 } } },
  { model = "s_m_y_marine_03", components = { { 2, 3, 0, 0 } } },
  { model = "s_m_y_blackops_01", props = { { 0, 2, 0, 0 } } },
  { model = "s_m_y_blackops_02", props = { { 0, 2, 0, 0 } } },
  { model = "s_m_y_blackops_03", props = { { 0, 2, 0, 0 } } },
}

Citizen.CreateThread(function()
  local pedModelKeyMap = {}
  for _, v in pairs(pedModels) do
    pedModelKeyMap[#pedModelKeyMap + 1] = GetHashKey(v.model)
  end
  exports['np-interact']:AddPeekEntryByModel(pedModelKeyMap, {
    {
      event = 'np-heists-serverroom:lootDeadGuard',
      id = 'np-heists-serverroom:lootDeadGuard',
      icon = 'circle',
      label = 'Grab Gear',
      parameters = {},
    },
  }, {
    distance = { radius = 2.0 },
    isEnabled = function(pEntity)
      if not inServerFarm then return false end
      if not IsPedDeadOrDying(pEntity) then return false end
      return true
    end,
  })

  exports['np-interact']:AddPeekEntryByPolyTarget("server_farm_computer", {
    {
      event = "np-heists-serverroom:hackUpstairsComputer",
      id = "heists_hack_upstairs",
      icon = "laptop",
      label = "Read Computer Data",
      parameters = {},
    }
  }, { distance = { radius = 2.5 }, 
    isEnabled = function() 
      if not inServerFarm then return false end
      return true
    end,
  })

  exports['np-interact']:AddPeekEntryByPolyTarget("server_farm_computer_down", {{
    event = "np-heists-serverroom:hackDownstairsComputer",
    id = "heists_hack_downstairs",
    icon = "laptop",
    label = "Read Computer Data",
    parameters = {},
  }}, { distance = { radius = 2.5 }, isEnabled = function() return IS_BLACKOUT_ENABLED() and inServerFarm end })
end)



function IS_BLACKOUT_ENABLED()
  return blackoutEnabled
end

local deletingPeds = false
local function deletePeds()
  deletingPeds = true
  for _, ped in pairs(allPeds) do
    Sync.DeleteEntity(ped)
  end
  Citizen.CreateThread(function()
    Citizen.Wait(5000)
    deletingPeds = false
  end)
end

local function controlPed(model, pedNetId, aimingPed, pedString)
  Citizen.CreateThread(function()
    local isThrowingGrenade = false
    local adjustingSelf = false
    local prevCoords = nil
    pedNetId = pedNetId
    local ped = NetworkGetEntityFromNetworkId(pedNetId)
    while ped == 0 or ped == -1 do
      ped = NetworkGetEntityFromNetworkId(pedNetId)
      Wait(100)
    end
    while not NetworkHasControlOfEntity(ped) do
      NetworkRequestControlOfEntity(ped)
      Wait(250)
    end
    Citizen.CreateThread(function()
      RPC.execute("np-heists-serverroom:registerPedId", pedNetId)
    end)
    allPeds[#allPeds + 1] = ped
    if deletingPeds then
      Sync.DeleteEntity(ped)
      return
    end
    DecorSetBool(ped, 'ScriptedPed', true)
    SetEntityAsMissionEntity(ped, 1, 1)
    prevCoords = GetEntityCoords(ped)
    -- health armor
    SetEntityMaxHealth(ped, 175)
    SetEntityHealth(ped, 175)
    SetPedArmour(ped, 100)
    SetPedSuffersCriticalHits(ped, false)
    -- weapons
    GiveWeaponToPed(ped, 1192676223, 9999, false, true)
    GiveWeaponToPed(ped, -1813897027, 9999, false, false)
    SetCurrentPedWeapon(ped, 1192676223, true)
    SetPedAmmo(ped, 1192676223, 9999)
    SetAmmoInClip(ped, 1192676223, 9999)
    SetPedAmmo(ped, -1813897027, 9999)
    SetAmmoInClip(ped, -1813897027, 9999)
    -- attack
    SetCanAttackFriendly(ped, false, true)
    -- combat
    SetPedCombatMovement(ped, 3)
    SetPedCombatRange(ped, 0)
    SetPedAccuracy(ped, 100)
    SetPedCanRagdoll(ped, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedCanPeekInCover(ped, true)
    SetPedCanSwitchWeapon(ped, true)
    SetPedCanEvasiveDive(ped, true)
    SetPedConfigFlag(ped, 208, true) -- explosion reactions
    -- SetPedCombatAttributes(ped, 5000, 1)
    -- misc
    SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)
    SetPedRelationshipGroupHash(PlayerPedId(), `PLAYER`)
    SetRelationshipBetweenGroups(5, `HATES_PLAYER`, `PLAYER`)
    SetRelationshipBetweenGroups(5, `PLAYER`, `HATES_PLAYER`)
    SetPedDropsWeaponsWhenDead(ped, false)
    SetPedRandomComponentVariation(ped, true)
    SetPedRandomProps(ped, true)
    if model.components then
      for _, v in pairs(model.components) do
        SetPedComponentVariation(ped, v[1], v[2], v[3], v[4])
      end
    end
    if model.props then
      for _, v in pairs(model.props) do
        SetPedPropIndex(ped, v[1], v[2], v[3], v[4])
      end
    end
    SetPedSeeingRange(ped, 100.0)
    SetPedHearingRange(ped, 100.0)
    SetPedAlertness(ped, 3)

    StopPedSpeaking(ped, true)
    DisablePedPainAudio(ped, true)

    ClearPedTasksImmediately(ped)

    SetEntityLoadCollisionFlag(ped, true)

    if not HasCollisionLoadedAroundEntity(ped) then
      RequestCollisionAtCoord(GetEntityCoords(ped))
    end

    -- TaskGoToCoordAndAimAtHatedEntitiesNearCoord(ped, vector3(2169.57,2916.4,-84.79), vector3(2169.57,2916.4,-84.79),
      -- 2.0, true, 0.01, 0.0, true, 0, 1, `FIRING_PATTERN_FULL_AUTO`)

    -- Citizen.CreateThread(function()
    --   Wait(3000)
    --   while not IsPedDeadOrDying(ped) do
    --     print(#(GetEntityCoords(aimingPed) - GetEntityCoords(ped)))
    --     if (#(GetEntityCoords(ped) - prevCoords) < 2.0) then
    --       prevCoords = GetEntityCoords(ped)
    --       print('ped not moving', ped)
    --       adjustingSelf = true
    --       ClearPedTasksImmediately(ped)
          
    --       Wait(5000)
    --       adjustingSelf = false
    --     else
    --       prevCoords = GetEntityCoords(ped)
    --     end
    --     Wait(5000)
    --   end
    -- end)
    Citizen.CreateThread(function()
      if DEBUG_MODE then
        while not IsPedDeadOrDying(ped) do
          local pedCoords = GetEntityCoords(ped)
          local myCoords = GetEntityCoords(aimingPed)
          DrawLine(pedCoords, myCoords, 0, 255, 0, 255)
          DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, pedString .. " (" .. math.floor(#(GetEntityCoords(ped) - GetEntityCoords(aimingPed))) .. ")")
          Wait(0)
        end
      end
    end)
    Citizen.CreateThread(function()
      while not IsPedDeadOrDying(ped) do
        if not isThrowingGrenade then
          if not IS_DEAD then
            if (#(GetEntityCoords(ped) - GetEntityCoords(aimingPed)) < 60) then
              TaskGoToEntityWhileAimingAtEntity(ped, aimingPed, aimingPed, 2.0, true, 0.0, 0.0, 0, 0, `FIRING_PATTERN_FULL_AUTO`)
            else
              -- TaskPedSlideToCoord(ped, GetEntityCoords(aimingPed), 0.0, 5000)
              local aimingPedCoords = GetEntityCoords(aimingPed)
              local currentCoords = GetEntityCoords(ped)
              local newCoords = getQuarterWayPoint(currentCoords, aimingPedCoords)
              TaskGoToCoordAnyMeans(ped, newCoords, 1.0, 0, 0, 786603, 0xbf800000)
              -- TaskWanderInArea(ped, vector3(2017.81,2941.64,-84.52), 25.0, 10.0, 0.0)
            end
          else
            local destinationCoords = vector3(2168.85,2921.77,-81.07)
            local currentCoords = GetEntityCoords(ped)
            if (#(currentCoords - destinationCoords) < 40) then
              TaskGoToCoordAnyMeans(ped, destinationCoords, 1.0, 0, 0, 786603, 0xbf800000)
            else
              local newCoords = getQuarterWayPoint(currentCoords, destinationCoords)
              TaskGoToCoordAnyMeans(ped, newCoords, 1.0, 0, 0, 786603, 0xbf800000)
            end
          end
        end
        Wait(30000)
      end
    end)
    Citizen.CreateThread(function()
      while not IsPedDeadOrDying(ped) do
        if not isThrowingGrenade then
          if GetSelectedPedWeapon(ped) ~= 1192676223 then
            GiveWeaponToPed(ped, 1192676223, 9999, false, true)
            SetPedAmmo(ped, 1192676223, 9999)
            SetAmmoInClip(ped, 1192676223, 9999)
            SetCurrentPedWeapon(ped, 1192676223, true)
          end
        end
        Wait(1000)
      end
    end)
    Citizen.CreateThread(function()
      Wait(10000)
      while not IsPedDeadOrDying(ped) do
        if (not IS_DEAD) and math.random() < 0.1 and (#(GetEntityCoords(aimingPed) - GetEntityCoords(ped)) < 30) then
          isThrowingGrenade = true
          SetCurrentPedWeapon(ped, -1813897027, true)
          TaskThrowProjectile(ped, GetEntityCoords(aimingPed))
          Wait(3000)
          isThrowingGrenade = false
        end
        Wait(10000)
      end
    end)
  end)
end

local function getSquareMultiplier()
  local sMap = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 1,
    [4] = 1,
    [5] = 1,
    [6] = 2,
    [7] = 2,
    [8] = 2,
    [9] = 3,
    [10] = 0,
  }
  return sMap[computersHacked]
end

local pedDeadChecks = {}
function canSpawnAnotherPed()
  if blackoutEnabled then
    return false
  end
  local pedCount = 0
  for _, ped in pairs(allPeds) do
    if DoesEntityExist(ped) and (not IsPedDeadOrDying(ped)) then
      pedCount = pedCount + 1
    end
    if DoesEntityExist(ped) and IsPedDeadOrDying(ped) then
      if not pedDeadChecks[ped] then
        pedDeadChecks[ped] = 0
      end
      pedDeadChecks[ped] = pedDeadChecks[ped] + 1
      if pedDeadChecks[ped] == 3 then
        Sync.DeleteEntity(ped)
      end
    end
  end
  return pedCount < MAX_PED_SPAWN_AMOUNT
end

function doInServerFarmThread()
  Citizen.CreateThread(function()
    while inServerFarm do
      if isHeistActive and canSpawnAnotherPed() then
        local model = pedModels[math.random(#pedModels)]
        local pedNetId, pedString = RPC.execute("np-heists:npcs:spawn", {
          type = "server_farm",
          npc = {4, model.model},
          spawnCoords = id,
          coordsForDistance = GetEntityCoords(PlayerPedId()),
          distanceFromCoords = 50,
          randomSpawn = true,
        })
        controlPed(model, pedNetId, PlayerPedId(), pedString)
        Wait(10000 * heistSpawnMultiplier)
      end
      Wait(1000)
    end
  end)
end

function teleportToServerFarm(pComputerCode)
  local hasHelmet = exports['np-inventory']:hasEnoughOfItem("varhelmet", 1, false, true)
  if not hasHelmet then
    TriggerEvent("DoLongHudText", "You need a VAR helmet!", 2)
    return
  end
  local cid = exports["isPed"]:isPed("cid")
  local isEntryTimeoutEnabled = RPC.execute("np-heists-serverroom:isEntryTimeoutEnabled")
  if isEntryTimeoutEnabled then
    TriggerEvent("DoLongHudText", "System is recovering, please check in a few minutes...", 2)
    return
  end
  local isHeistActiveCheck = RPC.execute("np-heists-serverroom:getHeistStatus", cid)
  if isHeistActiveCheck then
    TriggerEvent("DoLongHudText", "Cannot enter right now", 2)
    return
  end
  local isTerminalActiveCheck = RPC.execute("np-heists-serverroom:getHeistTerminalStatus", pComputerCode, cid)
  if isTerminalActiveCheck then
    TriggerEvent("DoLongHudText", "Terminal currently in use", 2)
    return
  end
  if not DEBUG_MODE then
    -- TriggerEvent("inventory:DegenItemType", 26, "varhelmet")
  end
  TriggerEvent("weather:blackout", false)
  activeComputerCode = pComputerCode
  inServerFarm = true
  StartTracking()
  allPeds = {}
  TriggerEvent("np-menu:var:inServerFarm", true)
  DoScreenFadeOut(400)
  Wait(600)
  SetEntityCoords(PlayerPedId(), vector3(2154.67,2921.05,-81.07))
  SetEntityHeading(PlayerPedId(), 267.0)
  Wait(600)
  createFarmPolys()
  DoScreenFadeIn(1000)
  SetAiWeaponDamageModifier(1.05)
  Citizen.CreateThread(function()
    Citizen.Wait(2000)
    TriggerEvent("phone:emailReceived", "#EDEN-00A-X1", "VAR", "You have entered a VAR environment. Please note due to headset calibration you may only enter once per 30 minutes. A terminal can only be used by a single user at a time. You may exit at any time using your F1 console. Contraband will be confiscated upon leaving.")
  end)
  doInServerFarmThread()
end

local function doBlackout()
  if not inServerFarm then return end
  if not blackoutEnabled then return end
  if blackoutProcessed then return end
  deletePeds()
  blackoutProcessed = true
  TriggerEvent("phone:emailReceived", "#EDEN-00A-X1", "VAR Emergency Procedure", "Due to unforeseen circumstances, the VAR environment is shutting down. Please vacate the system. In 3 minutes, you will automatically be vacated.")
  for i = 1, 5 do
    Citizen.Wait(200)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
  end
  Wait(1000)
  PlaySoundFrontend(-1, "Business_Shutdown", "DLC_GR_Disruption_Logistics_Sounds", true)
  Wait(1000)
  PlaySoundFrontend(-1, "Business_Shutdown", "DLC_GR_Disruption_Logistics_Sounds", true)
  Wait(1000)
  PlaySoundFrontend(-1, "Business_Shutdown", "DLC_GR_Disruption_Logistics_Sounds", true)
  Wait(2500)
  TriggerEvent("weather:blackout", true, true)
  for i = 1, 5 do
    Citizen.Wait(200)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
  end
end

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
  IS_DEAD = not IS_DEAD
end)

RegisterNetEvent("np-heists-serverroom:activateHeist", function(pIsActive, pHeistSpawnMultiplier, pComputersHacked, pBlackoutEnabled)
  isHeistActive = pIsActive
  heistSpawnMultiplier = pHeistSpawnMultiplier
  computersHacked = pComputersHacked
  blackoutEnabled = pBlackoutEnabled
  doBlackout()
  if inServerFarm and (not isHeistActive) then
    TriggerEvent("DoLongHudText", "System shutdown.", 2)
    Wait(2000)
    TriggerEvent("np-heists-serverroom:vr-room-exit")
  end
end)

RegisterNetEvent("np-heists-serverroom:deletePeds", function()
  deletePeds()
end)

RegisterNetEvent("np-heists-serverroom:heistSpawnMultiplier", function(pHeistSpawnMultiplier, pComputersSolved, pBlackoutEnabled)
  heistSpawnMultiplier = pHeistSpawnMultiplier
  computersHacked = pComputersSolved
  blackoutEnabled = pBlackoutEnabled
  doBlackout()
end)

RegisterNetEvent("np-heists-serverroom:maxPedCountSpawn", function(pMaxPedCount)
  MAX_PED_SPAWN_AMOUNT = pMaxPedCount
end)

AddEventHandler("np-heists-serverroom:vr-room-enter", function(p1, p2, pContext)
  local computerCode = pContext.zones["vr_room_entrance"].id
  teleportToServerFarm(computerCode)
end)

AddEventHandler("np-heists-serverroom:vr-room-exit", function()
  if not inServerFarm then return end
  DoScreenFadeOut(400)
  deletePeds()
  ResetAiWeaponDamageModifier()
  Wait(1000)
  inServerFarm = false
  EndTracking()
  TriggerEvent("np-menu:var:inServerFarm", false)
  RPC.execute("np-heists-serverroom:playerExitVar", activeComputerCode)
  Wait(600)
  TriggerEvent("reviveFunction")
  Wait(1000)
  SetEntityCoords(PlayerPedId(), vector3(-209.25,-296.57,74.49))
  TriggerEvent("weather:blackout", false)
  blackoutProcessed = false
  Wait(600)
  DoScreenFadeIn(1000)
  activeComputerCode = nil
end)

RegisterUICallback("np-ui:heists:serverroomComputerTextbox", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "" } })
  exports["np-ui"]:closeApplication("textbox")
  local computerId = data.key.computerId
  local successfulInput = RPC.execute("np-heists-serverroom:checkComputerInput", computerId, data.values.input)
  if not successfulInput then
    TriggerEvent("DoLongHudText", "Invalid input.")
    return
  end
  RPC.execute("np-heists-serverroom:updateComputerStatus", computerId, 2)
  TriggerEvent("DoLongHudText", "Input accepted.")
end)

RegisterUICallback("np-ui:minigame:movingNumbers", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "" } })
  COMPUTER_HACK_SUCCESS = data.success
end)
AddEventHandler("np-ui:application-closed", function(name)
  if name ~= "minigame-serverroom" then return end
  Citizen.CreateThread(function()
    if COMPUTER_HACK_SUCCESS == nil then
      COMPUTER_HACK_SUCCESS = false
    end
  end)
end)

COMPUTER_HACK_SUCCESS = nil
COMPUTER_HACK_INPUT = nil
AddEventHandler("np-heists-serverroom:hackUpstairsComputer", function(p1, p2, pData)
  local computerId = pData.zones["server_farm_computer"].id
  local computerStatus = RPC.execute("np-heists-serverroom:getComputerStatus", computerId)
  if computerStatus == -1 then
    TriggerEvent("DoLongHudText", "Only one computer can be accessed at a time.", 2)
    return
  end
  local function endComputerInteract()
    ClearPedTasks(PlayerPedId())
  end
  if computerStatus == 0 then
    TriggerEvent("animation:PlayAnimation", "type")
    COMPUTER_HACK_SUCCESS = nil
    exports["np-ui"]:openApplication("minigame-serverroom", {
      numberTimeout = 5000 + ((5 - heistSpawnMultiplier) * 1000), -- math.max(1500, 4000 - ((5 - heistSpawnMultiplier) * 250)),
      squares = 6 + getSquareMultiplier(),
    })
    while COMPUTER_HACK_SUCCESS == nil do
      Wait(1000)
      if DEBUG_MODE then
        COMPUTER_HACK_SUCCESS = true
      end
    end
    Wait(1000)
    exports["np-ui"]:closeApplication("minigame-serverroom")
    if not COMPUTER_HACK_SUCCESS then
      RPC.execute("np-heists-serverroom:registerComputerFailure")
      return endComputerInteract()
    end
    local hubLocation = RPC.execute("np-heists-serverroom:getHubLocation", computerId)
    if DEBUG_MODE then
      COMPUTER_HACK_INPUT = hubLocation.input
      print(hubLocation.location, hubLocation.input)
    end
    Wait(1000)
    exports["np-ui"]:openApplication("yacht-envelope", {
      textOnly = true,
      value = hubLocation.location,
    })
    RPC.execute("np-heists-serverroom:updateComputerStatus", computerId, 1)
    return endComputerInteract()
  end
  if computerStatus == 1 then
    exports["np-ui"]:openApplication("textbox", {
      callbackUrl = "np-ui:heists:serverroomComputerTextbox",
      key = { computerId = computerId },
      items = {
        {
          type = "password",
          icon = "pencil-alt",
          label = DEBUG_MODE and ("Input: " .. (COMPUTER_HACK_INPUT or "")) or "Input",
          name = "input",
        }
      },
      show = true,
    })
    return endComputerInteract()
  end
  TriggerEvent("DoLongHudText", "Computer already processed.", 2)
  return endComputerInteract()
end)

AddEventHandler("np-heists-serverroom:hackDownstairsComputer", function(p1, p2, pData)
  local computerId = pData.zones["server_farm_computer_down"].id
  local squares = RPC.execute("np-heists-serverroom:getComputerSquares", computerId)
  TriggerEvent("animation:PlayAnimation", "type")
  COMPUTER_HACK_SUCCESS = nil
  exports["np-ui"]:openApplication("minigame-serverroom", {
    numberTimeout = 5000,
    squares = squares,
  })
  while COMPUTER_HACK_SUCCESS == nil do
    Wait(1000)
    if DEBUG_MODE then
      COMPUTER_HACK_SUCCESS = true
    end
  end
  Wait(1000)
  exports["np-ui"]:closeApplication("minigame-serverroom")
  if not COMPUTER_HACK_SUCCESS then
    ClearPedTasks(PlayerPedId())
    return
  end
  PlaySoundFrontend(-1, "download_start", "DLC_BTL_Break_In_Sounds", true)
  local finished = exports["np-taskbar"]:taskBar(5000, "Downloading Encryption Data")
  PlaySoundFrontend(-1, "download_complete", "DLC_BTL_Break_In_Sounds", true)
  ClearPedTasks(PlayerPedId())
  RPC.execute("np-heists-serverroom:getEncryptionUsb", computerId)
end)

local lootingDeadGuard = false
AddEventHandler("np-heists-serverroom:lootDeadGuard", function(p1, pEntity, p3)
  if lootingDeadGuard then return end
  lootingDeadGuard = true
  TriggerEvent("farm:weed")
  RPC.execute("np-heists-serveroom:lootDeadGuard")
  Wait(3000)
  Sync.DeleteEntity(pEntity)
  Wait(1000)
  lootingDeadGuard = false
end)

AddEventHandler("np-heists-serverroom:entryBoxInteract", function(p1, p2, p3)
  if not p3 or not p3.zones or not p3.zones["server_farm_hub_box"] then return end
  local data = p3.zones["server_farm_hub_box"]
  local animDict = "anim@amb@business@meth@meth_monitoring_cooking@monitoring@"
  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do
    Wait(0)
  end
  TaskPlayAnim(PlayerPedId(), animDict, "look_around_v5_monitor", 8.0, -8.0, -1, 1, 1.0, false, false, false)
  local finished = exports["np-taskbar"]:taskBar(DEBUG_MODE and 1000 or 20000, "Configuring Server Panel")
  ClearPedTasks(PlayerPedId())
  if finished ~= 100 then
    return
  end
  local computerCode = RPC.execute("np-heists-serverroom:getComputerCodeFromHubBox", data)
  if DEBUG_MODE then
    print(computerCode.location, computerCode.input)
  end
  if not computerCode then
    TriggerEvent("DoLongHudText", "Hub not recognized", 2)
    return
  end
  exports["np-ui"]:openApplication("yacht-envelope", {
    textOnly = true,
    value = computerCode.input,
  })
end)

AddEventHandler("np-heists:serverroom:revivePlayer", function(pEntity)
  TriggerEvent("revive", pEntity)
  TriggerEvent("inventory:removeItem", "varmedkit", 1)
end)

AddEventHandler("np-inventory:itemUsed", function(pItem, pInfo)
  if pItem ~= "heistusbsr" then return end
  local info = json.decode(pInfo)
  local id = info.encryption_id
  local sources = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
  }
  for k, _ in pairs(sources) do
    local items = exports["np-inventory"]:GetItemsByItemMetaKVMulti("heistusbsr", {
      encryption_id = id,
      encryption_source = k,
    })
    if #items > 0 then
      sources[k] = true
    end
  end
  local shouldGiveItem = true
  for _, v in pairs(sources) do
    shouldGiveItem = shouldGiveItem and v or false
  end
  if not shouldGiveItem then
    TriggerEvent("DoLongHudText", "Some parts missing...", 2)
    return
  end
  local meta = {
    encryption_id = id,
    _hideKeys = { "encryption_id" },
  }
  TriggerEvent("player:receiveItem", "heistusbsrmk", 1, false, meta, meta)
end)

AddEventHandler("np-heists-serverroom:entryBoxDecrypt", function(p1, p2, p3)
  if not p3 or not p3.zones or not p3.zones["server_farm_hub_box"] then return end
  local data = p3.zones["server_farm_hub_box"]
  local info = exports["np-inventory"]:GetInfoForFirstItemOfName("heistusbsrmk")
  info = json.decode(info.information)
  local id = info.encryption_id
  local animDict = "anim@amb@business@meth@meth_monitoring_cooking@monitoring@"
  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do
    Wait(0)
  end
  TaskPlayAnim(PlayerPedId(), animDict, "look_around_v5_monitor", 8.0, -8.0, -1, 1, 1.0, false, false, false)
  local finished = exports["np-taskbar"]:taskBar(DEBUG_MODE and 1000 or 2500, "Decrypting Server Panel")
  ClearPedTasks(PlayerPedId())
  if finished ~= 100 then return end
  RPC.execute("np-heists-serverroom:decryptServerBox", id, data.code .. "-" .. data.key)
end)

--
--

Citizen.CreateThread(function()
  if DEBUG_MODE then
    RegisterCommand("sf:goto", function()
      teleportToServerFarm()
    end)
    RegisterCommand("deletePeds", function()
      deletePeds()
    end)
    RegisterCommand("playgame", function(pSrc, pArgs)
      exports["np-ui"]:openApplication("minigame-serverroom", {
        numberTimeout = tonumber(pArgs[1]),
        squares = tonumber(pArgs[2]),
      })
    end, false)
    RegisterCommand("playmaze", function(pSrc, pArgs)
      exports["np-ui"]:openApplication("minigame-maze", {
        show = true,
        gridSize = tonumber(pArgs[1]) or math.random(5, 9),
        withDebug = pArgs[2] == 'true',
      })
    end, false)
    RegisterCommand("doBlackout", function(pSrc, pArgs)
      blackoutEnabled = true
      doBlackout()
    end, false)
  end
end)

local aimingPed = nil
RegisterCommand("farmPed", function()
  if not aimingPed then
    aimingPed = getRandomPed(vector3(2158.66,2921.2,-81.07))
    Wait(1000)
    FreezeEntityPosition(aimingPed, true)
    SetEntityInvincible(aimingPed, true)
  end
  allPeds[#allPeds + 1] = aimingPed
  Citizen.CreateThread(function()
    while true do
      StopFireInRange(GetEntityCoords(aimingPed), 500.0)
      Wait(1000)
    end
  end)
  local model = pedModels[math.random(#pedModels)]
  local pedNetId, pedString = getSpawnedNpc({
    type = "server_farm",
    npc = {4, model.model},
    coordsForDistance = GetEntityCoords(PlayerPedId()),
    distanceFromCoords = 50,
    randomSpawn = true,
  })
  controlPed(model, pedNetId, aimingPed, pedString)
  -- local id = 0
  -- while id < 108 do
  --   id = id + 1
  --   local model = pedModels[math.random(#pedModels)]
  --   local pedNetId, pedString = RPC.execute("np-heists:npcs:spawn", {
  --     type = "server_farm",
  --     npc = {4, model.model},
  --     spawnCoords = id,
  --     -- coordsForDistance = GetEntityCoords(PlayerPedId()),
  --     -- distanceFromCoords = 50,
  --     -- randomSpawn = true,
  --   })
  --   controlPed(model, pedNetId, aimingPed, pedString)
  --   Wait(100)
  -- end
end)
