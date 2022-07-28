local Nodes = {}
local Generators = {}
local active = false
local flashState = false

local stateToBlipColor = { 2, 81, 1, 5 }
local stateToString = {
  'Power is nominal', 'Power is at 100%%! Warning: Nearly overloaded!', 'Offline', '%s %d%% power',
}

Citizen.CreateThread(function()
  exports['np-interact']:AddPeekEntryByModel({ -2008643115 }, {
    {
      event = 'np-heists:grid:checkNodeState',
      id = 'np-heists:grid:checkNodeState',
      icon = 'info-circle',
      label = 'check state',
      parameters = {},
    },
  }, {
    distance = { radius = 2.0 },
    isEnabled = function(pEntity)
      local node = GetNodeForEntity(pEntity)
      return active and node and node.state ~= 3 and
                 exports['np-inventory']:hasEnoughOfItem('relayprobe', 1, false, true)
    end,
  })

  exports['np-interact']:AddPeekEntryByModel({ -2008643115 }, {
    {
      event = 'np-heists:grid:useThermiteCharge',
      id = 'np-heists:grid:useThermiteCharge',
      icon = 'fire-alt',
      label = 'use thermite',
      parameters = {},
    },
  }, {
    distance = { radius = 2.0 },
    isEnabled = function(pEntity)
      local node = GetNodeForEntity(pEntity)
      return active and node and node.state ~= 3 and (not node.disabled or flashState) and
                 exports['np-inventory']:hasEnoughOfItem('thermitecharge', 1, false, true)
    end,
  })

  -- exports['np-polytarget']:AddBoxZone('grid_bank_node', vector3(-355.92, -50.55, 54.42), 1.6, 1, {
  --   heading = 340,
  --   minZ = 53.42,
  --   maxZ = 54.82,
  --   data = { id = 'fleeca_harwick' },
  -- })

  -- exports['np-polytarget']:AddBoxZone('grid_bank_node', vector3(1158.43, 2708.93, 37.97), 2.0, 1, {
  --   heading = 0,
  --   minZ = 36.97,
  --   maxZ = 38.77,
  --   data = { id = 'fleeca_harmony' },
  -- })

  -- exports['np-polytarget']:AddBoxZone('grid_bank_node', vector3(-2948.24, 481.2, 15.26), 1.8, 1, {
  --   heading = 355,
  --   minZ = 14.26,
  --   maxZ = 16.86,
  --   data = { id = 'fleeca_greatocean' },
  -- })

  -- exports['np-polytarget']:AddBoxZone('grid_bank_node', vector3(-1217.42, -333.12, 42.12), 1.0, 1.6,
  --                                     {
  --   heading = 295,
  --   minZ = 41.12,
  --   maxZ = 42.92,
  --   data = { id = 'fleeca_lifeinvader' },
  -- })

  -- exports['np-polytarget']:AddBoxZone('grid_bank_node', vector3(319.59, -315.69, 51.21), 1.8, 1, {
  --   heading = 340,
  --   minZ = 50.21,
  --   maxZ = 51.61,
  --   data = { id = 'fleeca_pinkcage' },
  -- })

  -- exports['np-polytarget']:AddBoxZone('grid_bank_node', vector3(138.96, -1055.9, 29.19), 1.8, 1, {
  --   heading = 250,
  --   minZ = 28.19,
  --   maxZ = 29.59,
  --   data = { id = 'fleeca_legion' },
  -- })

  exports['np-interact']:AddPeekEntryByPolyTarget('grid_bank_node', {
    {
      event = 'np-heists:grid:checkBankNodeState',
      id = 'np-heists:grid:checkBankNodeState',
      icon = 'info-circle',
      label = 'check state',
      parameters = {},
    },
  }, {
    distance = { radius = 2.0 },
    isEnabled = function(pEntity, pContext)
      local bank = GetNodeContextId(pContext)
      local node = GetBankNode(bank)
      return active and node and node.state ~= 3 and
                 exports['np-inventory']:hasEnoughOfItem('relayprobe', 1, false, true)
    end,
  })
end)

function startPowerGrid()
  if active then
    return
  end
  Nodes = {}
  Generators = {}

  -- Create blips for the small electrical boxes
  local nodeData = RPC.execute('np-heists:grid:getNodeState')
  for _, node in ipairs(nodeData) do
    local blip = AddBlipForCoord(node.coords)
    SetBlipSprite(blip, 354)
    if node.bank then
      SetBlipScale(blip, 1.25)
      SetBlipAsShortRange(blip, false)
      SetBlipPriority(blip, 10)
    else
      SetBlipAsShortRange(blip, true)
      SetBlipScale(blip, 0.75)
    end
    SetBlipColour(blip, stateToBlipColor[node.state])
    SetBlipHiddenOnLegend(blip, true)
    Nodes[#Nodes + 1] = {
      handle = blip,
      id = node.id,
      coords = node.coords,
      state = node.state,
      power = node.power,
      bank = node.bank,
      transfer = node.transfer,
      disabled = node.disabled,
    }
  end

  -- Create blips for the generators
  local genData = RPC.execute('np-heists:grid:getGenState')
  for _, gen in ipairs(genData) do
    local blip = AddBlipForCoord(gen.coords)
    SetBlipSprite(blip, 42)
    SetBlipScale(blip, 0.4)
    SetBlipColour(blip, 65)
    SetBlipAsShortRange(blip, true)
    SetBlipHiddenOnLegend(blip, true)
    SetBlipAlpha(blip, 64)
    Generators[#Generators + 1] = {
      handle = blip,
      id = gen.id,
      coords = gen.coords,
      state = gen.state,
    }
  end
end

-- debug
-- Citizen.CreateThread(function()
--   startPowerGrid()
-- end)

-- returns electrical node within 2 units of entity
function GetNodeForEntity(pEntity)
  local coords = GetEntityCoords(pEntity)
  for _, node in ipairs(Nodes) do
    local dist = node.bank and 2.0 or 0.5
    if #(node.coords - coords) < dist then
      return node
    end
  end
end

function GetNodeContextId(pContext)
  if (not pContext) or (not pContext.zones) or (not pContext.zones['grid_bank_node']) or
      (not pContext.zones['grid_bank_node'].id) then
    return -1
  end
  return pContext.zones['grid_bank_node'].id
end

function GetBankNode(pBank)
  for _, node in ipairs(Nodes) do
    if node.bank == pBank then
      return node
    end
  end
end

-- returns node with id
function GetNode(pNodeId)
  for idx, node in ipairs(Nodes) do
    if node.id == pNodeId then
      return node
    end
  end
end

-- 50% alert chance
local function sendAlert()
  if math.random() < 0.5 then
    TriggerEvent('civilian:alertPolice', 8.0, 'Suspicious', 0)
  end
end

local function mechanicAnim()
  local animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
  local animation = 'machinic_loop_mechandplayer'
  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do
    Wait(0)
  end

  TaskPlayAnim(PlayerPedId(), animDict, animation, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
end

local function pingCoords(pCoords, pSize, pColor)
  local timer = GetGameTimer()
  local expanding = true
  local blipScale = 0.0

  local blip = AddBlipForCoord(pCoords)
  SetBlipSprite(blip, 10)
  SetBlipColour(blip, pColor)
  SetBlipHiddenOnLegend(blip, true)
  SetBlipHighDetail(blip, true)
  SetBlipScale(blip, blipScale)

  while expanding do
    Wait(0)
    local deltaTime = GetGameTimer() - timer
    timer = GetGameTimer()
    blipScale = blipScale + (deltaTime * 0.0025)
    SetBlipScale(blip, blipScale)
    SetBlipAlpha(blip, math.floor(map_range(blipScale, 0.0, pSize, 255, 0) + 0.5))
    if blipScale > pSize then
      expanding = false
    end
  end
  RemoveBlip(blip)
end

AddEventHandler('np-heists:grid:checkBankNodeState', function(pArgs, pEntity, pContext)
  mechanicAnim()

  local bank = GetNodeContextId(pContext)
  local node = GetBankNode(bank)

  local finished = exports['np-taskbar']:taskBar(1500, 'Getting Info')
  ClearPedTasks(PlayerPedId())
  if finished == 100 then
    local context = {
      {
        title = 'Transformer',
        description = (stateToString[node.state]):format('Consuming', node.power),
      }, { title = 'Test Ping', action = 'np-heists:grid:sendTestPing', key = node },
    }
    exports['np-ui']:showContextMenu(context)
  end
end)

-- Peek handler for Check State
AddEventHandler('np-heists:grid:checkNodeState', function(pArgs, pEntity, pContext)
  mechanicAnim()
  local node = GetNodeForEntity(pEntity)
  if not node then
    TriggerEvent('DoLongHudText', 'Could not find node for entity. Retry.', 2)
    return
  end
  local finished = exports['np-taskbar']:taskBar(1500, 'Getting Info')
  ClearPedTasks(PlayerPedId())
  if finished == 100 then
    local context = {
      { title = 'Relay',
        description = (stateToString[node.state]):format('Redirecting', node.power) },
      { title = 'View Redirection', action = 'np-heists:grid:viewConnected', key = node },
    }
    exports['np-ui']:showContextMenu(context)
  end
end)

RegisterUICallback('np-heists:grid:viewConnected', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
  local node = data.key
  local connected = RPC.execute('np-heists:grid:getConnected', node.id)
  for _, nodeId in ipairs(connected) do
    local cNode = GetNode(nodeId)
    if nodeId == node.transfer then
      -- Clear any old route first
      ClearGpsCustomRoute()

      -- Start a new route
      StartGpsMultiRoute(13, false, true)

      -- Add the points
      AddPointToGpsCustomRoute(node.coords.x, node.coords.y, node.coords.z)
      AddPointToGpsCustomRoute(cNode.coords.x, cNode.coords.y, cNode.coords.z)

      -- Set the route to render
      SetGpsCustomRouteRender(true, 8, 8)

      SetTimeout(1 * 60 * 1000, function()
        ClearGpsCustomRoute()
      end)
    end
  end
end)

RegisterUICallback('np-heists:grid:sendTestPing', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
  local node = data.key

  local success = RPC.execute('np-heists:grid:pingNode', node)
  if not success then
    TriggerEvent('DoLongHudText', 'Recharging...', 2)
    return
  end

  local nodeCoords = vector3(node.coords.x, node.coords.y, node.coords.z)
  local connected = RPC.execute('np-heists:grid:getConnected', node.id)

  local transferNodes = {}
  for _, nodeId in ipairs(connected) do
    local cNode = GetNode(nodeId)
    if cNode.transfer == node.id then
      transferNodes[#transferNodes+1] = cNode
    end
  end

  for i=1,3 do
    PlaySound(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', false, 0, true)
    Wait(1000)
  end

  PlaySound(-1, 'On_Call_Player_Join', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 0, true)
  pingCoords(nodeCoords, 4.0, 33)
  for _,pNode in ipairs(transferNodes) do
    Wait(100)
    PlaySound(-1, 'On_Call_Player_Join', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 0, true)
    Citizen.CreateThread(function()
      pingCoords(pNode.coords, 2.0, 33)
    end)
  end
end)

-- Peek handler for Use Thermite
AddEventHandler('np-heists:grid:useThermiteCharge', function(pArgs, pEntity, pContext)
  local node = GetNodeForEntity(pEntity)
  if not node then
    TriggerEvent('DoLongHudText', 'Could not find electrical node.', 2)
    return
  end
  TriggerEvent('inventory:removeItem', 'thermitecharge', 1)
  local electricalBoxCoords = GetOffsetFromEntityInWorldCoords(pEntity, 0.0, -0.285, 1.0)
  local electricalBoxHeading = GetEntityHeading(pEntity)
  local electricalBoxThermite = {
    x = electricalBoxCoords.x,
    y = electricalBoxCoords.y,
    z = electricalBoxCoords.z,
    h = electricalBoxHeading,
  }

  -- Power box thermite game settings
  local gameSettings = {
    gameFinishedEndpoint = thermiteMinigameUICallbackUrl,
    gameTimeoutDuration = 17000,
    coloredSquares = 12,
    gridSize = 6,
  }

  if node.disabled then
    gameSettings = {
      gameFinishedEndpoint = thermiteMinigameUICallbackUrl,
      gameTimeoutDuration = 15000,
      coloredSquares = 16,
      gridSize = 6,
    }
  end

  local success = Citizen.Await(ThermiteCharge(electricalBoxThermite, nil, 0.0, gameSettings))
  sendAlert()
  if success then
    RPC.execute('np-heists:grid:useThermiteCharge', node)
  end
end)

AddEventHandler('np-inventory:itemUsed', function(pItemId, pInfo)
  if pItemId == 'powercodes' then
    startPowerGrid()
    return
  end

  if pItemId == 'heistlaptop333' then -- disabled
    if not exports['np-inventory']:hasEnoughOfItem('heistusb5', 1, false, true) then
      TriggerEvent('DoLongHudText', 'Missing security USB', 2)
      return
    end
    TriggerEvent('inventory:DegenLastUsedItem', 24)
    -- power code minigame settings
    local gameDuration = 5000
    local gameRoundsTotal = 4
    local numberOfShapes = 4
    local minigameHackExp = 10
    exports['np-ui']:openApplication('minigame-captcha', {
      gameFinishedEndpoint = MinigameUICallbackUrl,
      gameDuration = gameDuration * PanelTimeMultiplier,
      gameRoundsTotal = gameRoundsTotal,
      numberOfShapes = numberOfShapes,
    })

    TriggerEvent('client:newStress', true, 500)

    Citizen.CreateThread(function()
      while MinigameResult == nil do
        Citizen.Wait(1000)
        -- minigameResult = true
      end
      if MinigameResult then
        TriggerEvent('player:receiveItem', 'powercodes', 1, false)
        -- automatically start the game for them as well
        startPowerGrid()
        TriggerServerEvent('np-heists:hack:success', minigameHackExp)
      end
      MinigameResult = nil
    end)
    return
  end
end)

RegisterNetEvent('np-heists:grid:setActive', function(pState)
  active = pState
  if not active then
    for _, node in ipairs(Nodes) do
      RemoveBlip(node.handle)
    end
    for _, gen in ipairs(Generators) do
      RemoveBlip(gen.handle)
    end
  end
  exports['np-island']:hideBlips(active)
end)

RegisterNetEvent('np-heists:grid:updateNodeState', function(pNode)
  for idx, node in ipairs(Nodes) do
    if node.id == pNode.id then
      pNode.handle = node.handle
      Nodes[idx] = pNode
      SetBlipColour(node.handle, stateToBlipColor[pNode.state])
      return
    end
  end
end)

RegisterNetEvent('np-heists:grid:updateGenState', function(pGenId, pState)
  for _, gen in ipairs(Generators) do
    if gen.id == pGenId then
      gen.state = pState
      SetBlipColour(gen.handle, stateToBlipColor[pState])
      return
    end
  end
end)

RegisterNetEvent("sv-heists:cityPowerState", function(state)
  flashState = not state
  for _, node in ipairs(Nodes) do
    if not node.disabled then
      SetBlipFlashes(node.handle, flashState)
    end
    SetBlipColour(node.handle, flashState and (node.bank and 17 or 1) or stateToBlipColor[pNode.state])
  end

  for _, gen in ipairs(Generators) do
    SetBlipSprite(gen.handle, flashState and 41 or 42)
    SetBlipColour(gen.handle, flashState and 1 or 65)
  end
end)
