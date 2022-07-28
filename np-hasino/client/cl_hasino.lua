ARE_EXEC_OFFICE_COMPUTERS_AVAILABLE = false
EXECUTIVE_KEYCARD_PICKED_UP = false

AddEventHandler("np-hasino:thermiteSuccess", function(pLoc)
  TriggerServerEvent("np-hasino:thermiteSuccessServer", pLoc)
end)

local MAZE_GAME_WON = nil
RegisterUICallback("np-ui:mazeMinigameResult", function(data, cb)
  MAZE_GAME_WON = data.success
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)
AddEventHandler("np-heists:casino:backupGenerator", function(p1, p2, p3)
  local id = p3.zones.hasino_backupgenerator.id
  local canAttempt, message = RPC.execute("np-hasino:canAttemptBackupGenerator", id)
  if not canAttempt then
    TriggerEvent("DoLongHudText", message, 2)
    return
  end
  MAZE_GAME_WON = nil
  exports["np-ui"]:openApplication("minigame-maze", {
    show = true,
    gridSize = 7,
    withDebug = false,
  })
  while MAZE_GAME_WON == nil do
    Wait(1000)
    -- MAZE_GAME_WON = true
  end
  if not MAZE_GAME_WON then return end
  RPC.execute("np-hasino:generatorSuccessful", id)
end)

local COMPUTER_HACK_SUCCESS = nil
RegisterUICallback("np-ui:minigame:movingNumbersHasino", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "" } })
  COMPUTER_HACK_SUCCESS = data.success
end)
AddEventHandler("np-hasino:secInnerDoor", function(p1, p2, p3)
  local id = p3.zones.hasino_sec_comp.id
  if id ~= "inner" then return end
  local canDoInnerComputer = RPC.execute("np-hasino:registerTryForInnerComputer")
  if not canDoInnerComputer then return end
  TriggerEvent("animation:PlayAnimation", "type")
  COMPUTER_HACK_SUCCESS = nil
  exports["np-ui"]:openApplication("minigame-serverroom", {
    numberTimeout = 10000,
    squares = 10,
    gameFinishedEndpoint = "np-ui:minigame:movingNumbersHasino",
  })
  while COMPUTER_HACK_SUCCESS == nil do
    Wait(1000)
    -- if DEBUG_MODE then
      -- COMPUTER_HACK_SUCCESS = true
    -- end
  end
  Wait(1000)
  exports["np-ui"]:closeApplication("minigame-serverroom")
  ClearPedTasks(PlayerPedId())
  if not COMPUTER_HACK_SUCCESS then return end
  local codes = RPC.execute("np-hasino:getInnerDoorCodes")
  exports["np-ui"]:openApplication("yacht-envelope", {
    textOnly = true,
    value = codes,
  })
end)

local codesCoords = {
  { vector3(984.8597, 75.78128, 111.25), 58, 58 },
  { vector3(992.5816, 69.3298, 111.25), 325, 325 },
  { vector3(987.583, 61.43615, 111.25), 325, 325 },
  { vector3(984.7398, 56.74736, 111.25), 325, 325 },
  { vector3(978.3659, 46.68446, 111.25), 325, 325 },
  { vector3(963.298, 22.46363, 111.25), 325, 325 },
  { vector3(953.1877, 6.324841, 111.25), 325, 325 },
  { vector3(941.0243, -0.57475, 111.25), 239, 239 },
}
local codesCoords2 = {
  { vector3(984.9888, 75.98792, 111.25), 58, 58 },
  { vector3(992.803, 69.19148, 111.25), 325, 325 },
  { vector3(987.8269, 61.28372, 111.25), 325, 325 },
  { vector3(984.9124, 56.63951, 111.25), 325, 325 },
  { vector3(978.6001, 46.53809, 111.25), 325, 325 },
  { vector3(963.4739, 22.35373, 111.25), 325, 325 },
  { vector3(953.3847, 6.201729, 111.25), 325, 325 },
  { vector3(940.8923, -0.78589, 111.25), 239, 239 },
}
local codesUsedIdx = {}
local magnetInProgress = false

AddEventHandler("np-inventory:itemUsed", function(pItem)
  if pItem ~= "highpoweredmagnet" then return end
  if magnetInProgress then
    TriggerEvent("DoLongHudText", "Magnet in progress.", 2)
    return
  end
  magnetInProgress = true
  local loc, rotplus, panelIndex = nil, nil
  for pIdx, coords in pairs(codesCoords) do
    if #(coords[1] - GetEntityCoords(PlayerPedId())) < 2.0 then
      loc = { x = coords[1].x, y = coords[1].y, z = coords[1].z, h = coords[2] }
      rotplus = coords[3]
      panelIndex = pIdx
      if codesUsedIdx[panelIndex] then
        local coords2 = codesCoords2[panelIndex]
        loc = { x = coords2[1].x, y = coords2[1].y, z = coords2[1].z, h = coords2[2] }
        rotplus = coords2[3]
      end
    end
  end
  if not loc then
    magnetInProgress = false
    return
  end
  TriggerEvent("inventory:removeItem", "highpoweredmagnet", 1)
  local success = Citizen.Await(MagnetCharge(loc, 0, rotplus, {
    coloredSquares = 8,
    gameTimeoutDuration = 15000,
    gridSize = 5,
  }))
  if not success then
    magnetInProgress = false
    return
  end
  RPC.execute("np-hasino:magnetSuccess", panelIndex, loc)
  codesUsedIdx[panelIndex] = true
  magnetInProgress = false
  Citizen.CreateThread(function()
    Citizen.Wait(10000)
    codesUsedIdx[panelIndex] = false
  end)
end)

RegisterNetEvent("np-hasino:setExecOfficeComputerStatus", function(pStatus)
  ARE_EXEC_OFFICE_COMPUTERS_AVAILABLE = pStatus
end)

AddEventHandler("np-hasino:accessExecOfficeComputer", function(p1, p2, p3)
  local id = p3.zones.hasino_exec_office_pc.id
  local hasUsb = exports['np-inventory']:hasEnoughOfItem('heistusb7', 1, false, true)
  if not hasUsb then
    TriggerEvent("DoLongHudText", 'Firewall Active', 2)
    return
  end
  TriggerEvent("inventory:DegenItemType",21,"heistusb7")
  MAZE_GAME_WON = nil
  exports["np-ui"]:openApplication("minigame-maze", {
    show = true,
    gridSize = 7,
    withDebug = false,
    useChessPieces = true,
  })
  while MAZE_GAME_WON == nil do
    Wait(1000)
    -- MAZE_GAME_WON = true
  end
  if not MAZE_GAME_WON then return end
  RPC.execute("np-hasino:execOfficerComputerSuccess", id)
end)

AddEventHandler("np-hasino:accessCodeMiniVault", function()
  exports["np-ui"]:openApplication("textbox", {
    callbackUrl = "np-ui:hasino:innerVaultAccessCodes",
    key = 1,
    items = {
      {
        icon = "user-secret",
        label = "Password",
        name = "password",
        type = "password",
      },
    },
    show = true,
  })
end)

RegisterUICallback("np-ui:hasino:innerVaultAccessCodes", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  exports["np-ui"]:closeApplication("textbox")
  RPC.execute("np-hasino:inputInnerVaultAccessCodes", data.values.password)
end)

AddEventHandler("np-hasino:pickupExecutiveKeycard", function()
  RPC.execute("np-hasino:pickupExecutiveKeycard")
end)

RegisterNetEvent('np-hasino:executiveKeycardPickedUp', function()
  EXECUTIVE_KEYCARD_PICKED_UP = true
end)

AddEventHandler("np-inventory:itemUsed", function(pItem)
  if pItem ~= "casinoexeckeycard" then return end
  TriggerServerEvent("np-hasino:execCardUsed", GetEntityCoords(PlayerPedId()))
end)

AddEventHandler('np-hasino:pickupUSB', function(pArgs, pEntity, pContext)
  TriggerServerEvent('np-hasino:pickupUSB', pContext.meta.id)
end)
