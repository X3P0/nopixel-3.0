--[[
cl_ply.lua
]]

--#[Local Variables]#--
local isInsideCasino = false
local isSMSetup = false
local isSeatedAtSlotMachine = false
local isSlotMachineSpinning = false
local isBetContextShowing = false
local isPlyBusy = false

local currentCoinValue = 0
local currentBet = 1

local currentSlotMachine = nil
local currentSlotMachineModel = nil
local currentReelModel = nil
local currentReels = {}
local currentSlotMachineLabel = ""
local currentSlotMachineDetails = nil
local currentSlotMachinePos = vector3(0, 0, 0)

local currentChair = nil
local currentChairPos = vector3(0, 0, 0)
local currentChairRot = vector3(0, 0, 0)

local currentSlotMachineObjs = {}

local currentAccJackpot = 0

local isSlotMachinesEnabled = false

--#[Local Functions]#--
local function isNear(pos1, pos2, distMustBe)
  local diff = #(pos2 - pos1)
  return (diff < (distMustBe))
end

local function calculateRot(x1, y1, x2, y2)
  local t = -math.deg(math.atan2(x2 - x1, y2 - y1))

  return t < -180 and t + 180 or t
end

local function createObj(model, pos, heading, placeObjectProperly)
  local hash = ""
  local obj = nil

  if tonumber(model) ~= nil then
    hash = tonumber(model)
  else
    hash = GetHashKey(model)
  end

  RequestModel(hash)

  if IsModelValid(hash) then
    obj = CreateObjectNoOffset(hash, pos, false, false, false)
    SetEntityHeading(obj, heading)

    if placeObjectProperly then
      PlaceObjectOnGroundProperly(obj)
    end

    SetEntityAsMissionEntity(obj, true, true)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, true, true)
    SetEntityCanBeDamaged(obj, false)
  end

  return obj
end

local function drawStatusHUD(state, pValues)
  local title = "Slot Machine - " .. currentSlotMachineLabel
  local balance = RPC.execute("np-casino:getCurrentChipCount")
  local values = {}

  table.insert(values, "Balance: $" .. balance)

  for k, v in pairs(pValues) do
    table.insert(values, v)
  end

  table.insert(values, "Jackpot Accumulator: ~$" .. math.floor(currentAccJackpot / 1000) .. "k")

  exports["np-ui"]:sendAppEvent("status-hud", {
    show = state,
    title = title,
    values = values
  })
end

local function cleanUpSlots()
  ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL")
  ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01")
  ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02")
  ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03")

  currentReels = {}
  isSeatedAtSlotMachine = false
  isSlotMachineSpinning = false
  isBetContextShowing = false
  isPlyBusy = false

  currentCoinValue = 0
  currentBet = 1

  currentSlotMachine = nil
  currentSlotMachineModel = nil
  currentReelModel = nil
  currentReels = {}
  currentSlotMachineDetails = nil
  currentSlotMachinePos = vector3(0, 0, 0)

  currentChair = nil
  currentChairPos = vector3(0, 0, 0)
  currentChairRot = vector3(0, 0, 0)
end

local function getUpFromSlotMachine()
  local plyPed = PlayerPedId()

  isSeatedAtSlotMachine = false

  --[[local leavingScene = NetworkCreateSynchronisedScene(currentChairPos, currentChairRot, 2, false, false, 1065353216, 0, 1065353216)
  NetworkAddPedToSynchronisedScene(plyPed, leavingScene, "anim_casino_a@amb@casino@games@slots@male", "exit_left", 2.0, -2.0, 13, 16, 1148846080, 0)
  NetworkStartSynchronisedScene(leavingScene)]]

  FreezeEntityPosition(plyPed, false)

  TaskPlayAnim(GetPlayerPed(-1), "anim_casino_a@amb@casino@games@slots@male", "exit_left", 1.0, 1.0, 2500, 0)

  Citizen.Wait(math.floor(GetAnimDuration("anim_casino_a@amb@casino@games@slots@male", "exit_left") * 800))

  ClearPedTasks(plyPed)

  TriggerServerEvent("np-slotmachines-sv:getUpFromSlotMachine")
  drawStatusHUD(false, {})

  SetEntityCollision(currentSlotMachine, true, true)

  if #currentReels > 0 then
    for k, v in pairs(currentReels) do 
      DeleteEntity(v.reel)
    end
  end

  currentReels = {}

  isSlotMachineSpinning = false
  isBetContextShowing = false
end

local function reelManager()
  while isSMSetup do 
    if isSlotMachineSpinning then
      for k, v in ipairs(currentReels) do 
        if v.isSpinning then
          if v.rot >= 360.0 then
            v.rot = 0.0
          end

          v.rot = v.rot + 11.25

          SetEntityRotation(v.reel, v.rot, 0.0, GetEntityHeading(currentSlotMachine), 2, true)
        end
      end
    end

    Citizen.Wait(0)
  end
end

local function slotMachineManager()
  while isSMSetup do
    if isSeatedAtSlotMachine then
      if not isBetContextShowing then
        if currentSlotMachineDetails ~= nil then
          local data = {}

          isBetContextShowing = true
          
          table.insert(data, {
            action = "np-ui-slotmachines:placeBet",
            i18nTitle = true,
            title = "Place bet",
            description = "$100.00",
            key = {
              coinValue = 100,
              bet = 1,
              maxBet = 0,
            },
          })
          table.insert(data, {
            action = "np-ui-slotmachines:placeBet",
            title = "Place bet",
            i18nTitle = true,
            description = "$250.00",
            key = {
              coinValue = 250,
              bet = 1,
              maxBet = 0,
            },
          })
          table.insert(data, {
            action = "np-ui-slotmachines:placeBet",
            title = "Place bet",
            i18nTitle = true,
            description = "$500.00",
            key = {
              coinValue = 500,
              bet = 1,
              maxBet = 0,
            },
          })
          table.insert(data, {
            action = "np-ui-slotmachines:placeBet",
            title = "Place bet",
            i18nTitle = true,
            description = "$1,000.00",
            key = {
              coinValue = 1000,
              bet = 1,
              maxBet = 1,
            },
          })

          table.insert(data, {
            action = "np-ui-slotmachines:leaveMachine",
            title = "Leave Machine",
            i18nTitle = true,
            key = {},
          })

          exports["np-ui"]:showContextMenu(data) 
        end
      end
    end
    
    Citizen.Wait(0)
  end
end

local function initializeSlotMachines()
  local isInteractionShowing = false
  local canPlayAtSlotMachine = false
  local interactionBackground = ""

  RequestAnimDict("anim_casino_a@amb@casino@games@slots@male")

  while not HasAnimDictLoaded("anim_casino_a@amb@casino@games@slots@male") do 
    RequestAnimDict("anim_casino_a@amb@casino@games@slots@male")
    Citizen.Wait(0)
  end

  RequestAnimDict("anim_casino_b@amb@casino@games@shared@player@")

  while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@shared@player@") do 
    RequestAnimDict("anim_casino_b@amb@casino@games@shared@player@")
    Citizen.Wait(0)
  end

  RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1)
  RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1)
  RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02", false, -1)
  RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03", false, -1)

  TriggerServerEvent("np-slotmachines-sv:getMachineData")

  while isSMSetup do
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)

    for k, v in pairs(currentSlotMachineObjs) do 
      if isNear(plyPos, v.chairPos, 0.75) and not v.ply then
        while true do
          plyPed = PlayerPedId()
          plyPos = GetEntityCoords(plyPed)

          if not isNear(plyPos, v.chairPos, 0.75) then
            if isInteractionShowing then
              isInteractionShowing = false
  
              exports["np-ui"]:hideInteraction(interactionBackground)
            end

            break
          end

          if not isInteractionShowing then
            isInteractionShowing = true

            if exports["np-inventory"]:hasEnoughOfItem("casinomember", 1, false, true) then
              interactionBackground = "success"
              canPlayAtSlotMachine = true
            elseif exports["np-inventory"]:hasEnoughOfItem("casinovip", 1, false, true) then
              interactionBackground = "success"
              canPlayAtSlotMachine = true
            else
              interactionBackground = "error"
              canPlayAtSlotMachine = false
            end

            exports["np-ui"]:showInteraction("[E] Play " .. v.label, interactionBackground)
          end
        
          if IsControlJustReleased(1, 38) and canPlayAtSlotMachine then --Key: E
            TriggerServerEvent("np-slotmachines-sv:sitDownAtSlotMachine", k)

            break
          end

          Citizen.Wait(0)
        end
      end
    end

    Citizen.Wait(0)
  end
end

local function enteredCasino()
  isSMSetup = true

  smDebug("Player entered casino, setting up...")

  for k, v in pairs(cfg_slot_machines) do 
    for m, n in pairs(v.machines) do 
      local slotMachineEnt = GetClosestObjectOfType(n.pos.x, n.pos.y, n.pos.z, 1.0, GetHashKey(v.machineModel))
      local chairPos = GetOffsetFromEntityInWorldCoords(slotMachineEnt, 0, -1.0, 1.25)

      currentSlotMachineObjs[m] = {label = v.label, chairPos = chairPos, ply = false}
    end
  end

  Citizen.CreateThread(initializeSlotMachines)
  Citizen.CreateThread(slotMachineManager)
  Citizen.CreateThread(reelManager)
end

local function exitedCasino()
  isSMSetup = false
  currentSlotMachineObjs = {}

  smDebug("Player left casino, cleaning up...")

  cleanUpSlots()
end

--#[Event Handlers]#--
RegisterNetEvent("np-slotmachines-cl:getMachineData")
AddEventHandler("np-slotmachines-cl:getMachineData", function(data)
  for k, v in pairs(data) do
    if currentSlotMachineObjs[k] ~= nil then
      currentSlotMachineObjs[k].ply = v
    end
  end
end)

RegisterNetEvent("np-slotmachines-cl:updateMachineData")
AddEventHandler("np-slotmachines-cl:updateMachineData", function(machine, ply)
  if currentSlotMachineObjs[machine] ~= nil then
    currentSlotMachineObjs[machine].ply = ply
  end
end)

RegisterNetEvent("np-slotmachines-cl:sitDownAtSlotMachine")
AddEventHandler("np-slotmachines-cl:sitDownAtSlotMachine", function(machine, coinValue)
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)
  local hasMachineBeenFound = false
  local seatPos = vector3(0, 0, 0)

  currentCoinValue = coinValue

  for k, v in pairs(cfg_slot_machines) do 
    for m, n in pairs(v.machines) do 
      if m == machine then
        hasMachineBeenFound = true

        currentSlotMachinePos = vector3(n.pos.x, n.pos.y, n.pos.z)
        currentSlotMachine = GetClosestObjectOfType(n.pos.x, n.pos.y, n.pos.z, 1.0, GetHashKey(v.machineModel))
        currentSlotMachineModel = v.machineModel
        currentReelModel = v.reelModel
        currentSlotMachineLabel = v.label
        currentSlotMachineDetails = n

        break
      end
    end

    if hasMachineBeenFound then
      break
    end
  end

  local chairPos = GetOffsetFromEntityInWorldCoords(currentSlotMachine, 0.0, 0.0, 0.0)
  local chairRot = vector3(0, 0, GetEntityHeading(currentSlotMachine))
  local chairAngle = chairRot.z - calculateRot(chairPos.x, chairPos.y, plyPos.x, plyPos.y) + 90.0
  local seatAnim = "enter_left"

  if chairAngle > 0 then seatAnim = "enter_left" end
  if chairAngle < 0 then seatAnim = "enter_right" end

  local sittingScene = nil
  local chairAnimPos = GetOffsetFromEntityInWorldCoords(currentSlotMachine, -0.471, -1.419, 0.0)
  local chairAnimRot = GetEntityHeading(currentSlotMachine)
  local sittingIdleAnim = "betidle_idle_a"
  local sittingIdleAnimTime = GetGameTimer() + math.floor(GetAnimDuration("anim_casino_a@amb@casino@games@slots@male", sittingIdleAnim) * 990)

  currentChairPos = chairPos
  currentChairRot = chairRot
  currentChair = 1

  TaskGoStraightToCoord(plyPed, chairAnimPos, 1.0, 5000, chairAnimRot, 0.01)

  Citizen.Wait(1500)

  SetEntityCollision(currentSlotMachine, false, true)

  Citizen.Wait(50)

  sittingScene = NetworkCreateSynchronisedScene(chairPos, chairRot, 2, true, true, 1065353216, 0, 1065353216)
  NetworkAddPedToSynchronisedScene(plyPed, sittingScene, "anim_casino_a@amb@casino@games@slots@male", seatAnim, 2.0, -2.0, 13, 16, 1148846080, 0)
  NetworkStartSynchronisedScene(sittingScene)

  sittingScene = NetworkConvertSynchronisedSceneToSynchronizedScene(sittingScene)

  repeat Citizen.Wait(0) until GetSynchronizedScenePhase(sittingScene) >= 0.99 or HasAnimEventFired(plyPed, 2038294702) or HasAnimEventFired(plyPed, -1424880317)

  --[[sittingScene = NetworkCreateSynchronisedScene(chairPos, chairRot, 2, true, true, 1065353216, 0, 1065353216)
  NetworkAddPedToSynchronisedScene(plyPed, sittingScene, "anim_casino_a@amb@casino@games@slots@male", "betidle_idle_a", 2.0, -2.0, 13, 16, 1148846080, 0)
  NetworkStartSynchronisedScene(sittingScene)]]

  FreezeEntityPosition(plyPed, true)

  TaskPlayAnim(plyPed, "anim_casino_a@amb@casino@games@slots@male", "betidle_idle_a", 1.0, 1.0, -1, 0)

  while not IsEntityPlayingAnim(plyPed, "anim_casino_a@amb@casino@games@slots@male", "betidle_idle_a", 3) do 
    Citizen.Wait(0)
  end

  isSeatedAtSlotMachine = true

  drawStatusHUD(true, {})

  while isSeatedAtSlotMachine do 
    if GetGameTimer() >= sittingIdleAnimTime then
      while isPlyBusy do 
        Citizen.Wait(0)
      end

      if isSeatedAtSlotMachine then
        --[[sittingScene = NetworkCreateSynchronisedScene(chairPos, chairRot, 2, true, true, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(plyPed, sittingScene, "anim_casino_a@amb@casino@games@slots@male", sittingIdleAnim, 2.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(sittingScene)]]

        TaskPlayAnim(plyPed, "anim_casino_a@amb@casino@games@slots@male", sittingIdleAnim, 1.0, 1.0, -1, 0)

        sittingIdleAnimTime = GetGameTimer() + math.floor(GetAnimDuration("anim_casino_a@amb@casino@games@slots@male", sittingIdleAnim) * 990)
      end
    end

    if IsControlJustReleased(1, 202) then --Key: Unknown
      getUpFromSlotMachine()
    end

    Citizen.Wait(0)
  end
end)

RegisterNetEvent("np-slotmachines-cl:playSlotMachineSound")
AddEventHandler("np-slotmachines-cl:playSlotMachineSound", function(machinePos, machineModel, sound)
  if isSMSetup then
    local soundRef = ""
    local machineToPlayOutOf = GetClosestObjectOfType(machinePos.x, machinePos.y, machinePos.z, 1.0, GetHashKey(machineModel))

    if cfg_slot_audioref[machineModel] ~= nil then
      soundRef = cfg_slot_audioref[machineModel]

      if machineToPlayOutOf ~= nil then
        local soundID = GetSoundId()

        PlaySoundFromEntity(soundID, sound, machineToPlayOutOf, soundRef, false, 20, 0)

        while not HasSoundFinished(soundID) do 
          Citizen.Wait(0)
        end
      
        ReleaseSoundId(soundID)
      end
    end
  end
end)

RegisterNetEvent("np-slotmachines-cl:stopReels")
AddEventHandler("np-slotmachines-cl:stopReels", function(reel, rot)
  currentReels[reel].isSpinning = false
  currentReels[reel].rot = rot

  SetEntityRotation(currentReels[reel].reel, rot, 0.0, GetEntityHeading(currentSlotMachine))

  if reel == 3 then isSlotMachineSpinning = false isBetContextShowing = false end
end)

RegisterNetEvent("np-slotmachines-cl:spinFinished")
AddEventHandler("np-slotmachines-cl:spinFinished", function(amountWon)
  if amountWon > 0 then
    -- RPC.execute("np-casino:winChips", amountWon)

    TriggerEvent("DoLongHudText", "You've won $" .. amountWon .. "!", 1, 12000, { i18n = { "You've won" }})
  else
    TriggerEvent("DoLongHudText", "You've won nothing.", 2)
  end

  drawStatusHUD(true, {})
end)

RegisterNetEvent("np-slotmachines-cl:toggleSlotMachines")
AddEventHandler("np-slotmachines-cl:toggleSlotMachines", function(state)
  isSlotMachinesEnabled = state

  if state then
    smDebug("Slot machines have been enabled.")

    if not isSMSetup and isInsideCasino then
      enteredCasino()
    end
  else
    smDebug("Slot machines have been disabled.")

    if isSMSetup then
      exitedCasino()
    end
  end
end)

AddEventHandler("np-casino:casinoEnteredEvent", function()
  isInsideCasino = true
  isSlotMachinesEnabled, currentAccJackpot = RPC.execute("np-slotmachines-sv:checkIfSlotMachinesState")

  if not isSlotMachinesEnabled then
    return
  end

  enteredCasino()
end)

AddEventHandler("np-casino:casinoExitedEvent", function()
  isInsideCasino = false
  isSlotMachinesEnabled = RPC.execute("np-slotmachines-sv:checkIfSlotMachinesState")
  if not isSlotMachinesEnabled then
    return
  end

  exitedCasino()
end)

--#[NUI Callbacks]#--
RegisterUICallback("np-ui-slotmachines:placeBet", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })

  if currentSlotMachine and not isSlotMachineSpinning then
    local plyPed = PlayerPedId()

    currentBet = data.key.bet * data.key.coinValue

    if data.key.bet == data.key.maxBet then
      TaskPlayAnim(plyPed, "anim_casino_a@amb@casino@games@slots@male", "betidle_press_betmax_a", 3.0, 11.0, -1, 48, 0, false, false, false)
    else
      TaskPlayAnim(plyPed, "anim_casino_a@amb@casino@games@slots@male", "betidle_press_betone_a", 3.0, 11.0, -1, 48, 0, false, false, false)
    end

    local useChipsResult = RPC.execute("np-casino:useChips", currentBet)

    if not useChipsResult then
      TriggerEvent("DoLongHudText", "You do not have enough in your casino balance to bet.", 2)
      return
    end

    drawStatusHUD(true, { "Bet: $" .. currentBet })

    Citizen.Wait(500)

    if #currentReels > 0 then
      for k, v in ipairs(currentReels) do 
        v.isSpinning = true

        Citizen.Wait(0)
      end
    else
      local slotMachineOffset = GetOffsetFromEntityInWorldCoords(currentSlotMachine, 0.003, 0.050, 1.1)
      local reel1 = createObj(currentReelModel, slotMachineOffset, GetEntityHeading(currentSlotMachine), false)

      SetEntityCollision(reel1, false)

      slotMachineOffset = GetOffsetFromEntityInWorldCoords(reel1, 0.124, 0.0, 0.0)
      local reel2 = createObj(currentReelModel, slotMachineOffset, GetEntityHeading(currentSlotMachine), false)

      SetEntityCollision(reel2, false)

      slotMachineOffset = GetOffsetFromEntityInWorldCoords(reel1, -0.12, 0.0, 0.0)
      local reel3 = createObj(currentReelModel, slotMachineOffset, GetEntityHeading(currentSlotMachine), false)

      SetEntityCollision(reel3, false)

      table.insert(currentReels, {reel = reel3, rot = 90, isSpinning = true})

      Citizen.Wait(0)

      table.insert(currentReels, {reel = reel1, rot = 0, isSpinning = true})

      Citizen.Wait(0)

      table.insert(currentReels, {reel = reel2, rot = 270, isSpinning = true})
    end

    isPlyBusy = true
    
    TaskPlayAnim(PlayerPedId(), "anim_casino_a@amb@casino@games@slots@male", "pull_spin_a", 3.0, 11.0, -1, 48, 0, false, false, false)

    PlayEntityAnim(currentSlotMachine, "pull_spin_a_slotmachine", "anim_casino_a@amb@casino@games@slots@male", 1000.0, false, true, true, 0, 136704)

    Citizen.Wait(3000)

    isPlyBusy = false

    local cid = exports["isPed"]:isPed("cid")
    local info = (exports["np-inventory"]:GetInfoForFirstItemOfName("casinoloyalty") or { information = "{}" })
    TriggerServerEvent(
      "np-slotmachines-sv:spinMachine",
      currentSlotMachinePos,
      currentSlotMachineModel,
      currentBet,
      cid,
      json.decode(info.information).state_id
    )

    isSlotMachineSpinning = true
  end
end)

RegisterUICallback("np-ui-slotmachines:leaveMachine", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  getUpFromSlotMachine()
end)

--#[DEV COMMANDS]#--
--[[RegisterCommand("get_slotmachine_info", function()
  local slotMachineObjs = {
    [`vw_prop_casino_slot_01a`] = "vw_prop_casino_slot_01a",
    [`vw_prop_casino_slot_02a`] = "vw_prop_casino_slot_02a",
    [`vw_prop_casino_slot_03a`] = "vw_prop_casino_slot_03a",
    [`vw_prop_casino_slot_04a`] = "vw_prop_casino_slot_04a",
    [`vw_prop_casino_slot_05a`] = "vw_prop_casino_slot_05a",
    [`vw_prop_casino_slot_06a`] = "vw_prop_casino_slot_06a",
    [`vw_prop_casino_slot_07a`] = "vw_prop_casino_slot_07a",
    [`vw_prop_casino_slot_08a`] = "vw_prop_casino_slot_08a"
  }

  local objPool = GetGamePool("CObject")
  local plyPos = GetEntityCoords(PlayerPedId())
  local foundObj = 0
  local isFound = false

  for k, v in pairs(objPool) do 
    if v ~= 0 then
      if DoesEntityExist(v) then
        if slotMachineObjs[GetEntityModel(v)] ~= nil then
          local objPos = GetEntityCoords(v)

          if isNear(plyPos, objPos, 1.0) then
            foundObj = v
            isFound = true

            break
          end
        end
      end
    end

    if isFound then
      break
    end
  end

  if isFound then
    smDebug("---------------------------------")
    smDebug("Found slot machine: " .. slotMachineObjs[GetEntityModel(foundObj)])
    smDebug("Slot machine name: " .. cfg_slot_machines[GetEntityModel(foundObj)].label)
    smDebug("Coords: " .. GetEntityCoords(foundObj))
    smDebug("Heading: " .. GetEntityHeading(foundObj))
    smDebug("---------------------------------")

    local data = "pos = " .. GetEntityCoords(foundObj) .. ", heading = " .. GetEntityHeading(foundObj) .. ","

    exports.loq_coords:CopyToClipboard(data)
  else
    smDebug("Couldn't locate a slot machine near player.")
  end
end)]]
