local isDialing, isRinging = false, false
local incomingCallId = nil
local activeCallId = nil
local isDead = false

function IsInActiveCall()
  return isDialing or isRinging or activeCallId
end

-- This is what you should call on the receiving end ;)
RegisterNetEvent("phone:call:receive")
AddEventHandler("phone:call:receive", function(pNumber, pCallId)
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "call-receiving",
      number = pNumber,
      callId = pCallId
    }
  })
  isRinging = true
  incomingCallId = pCallId
end)

-- call this event when call begins
RegisterNetEvent("phone:call:in-progress")
AddEventHandler("phone:call:in-progress", function(pNumber, pCallId)
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "call-in-progress",
      number = pNumber,
      callId = pCallId
    }
  })
  isDialing, isRinging = false, false
  activeCallId = pCallId
  playPhoneCallAnim()
end)

-- call this event when call is outgoing
RegisterNetEvent("phone:call:dialing")
AddEventHandler("phone:call:dialing", function(pNumber, pCallId)
  TriggerEvent("attachItemPhone", "phone01")
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "call-dialing",
      number = pNumber,
      callId = pCallId
    }
  })
  isDialing = true
  incomingCallId = pCallId
  playPhoneCallAnim()
end)

-- call this when there is no active calling state (not dialing, receiving, in call - after hang up)
RegisterNetEvent("phone:call:inactive")
AddEventHandler("phone:call:inactive", function(pNumber, pCallId, pMessage)
  TriggerEvent("destroyPropPhone")
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "call-inactive",
      number = pNumber,
      message = pMessage,
    }
  })
  isDialing, isRinging = false, false
  activeCallId = nil
  incomingCallId = nil
end)

-- dial from phone
RegisterUICallback("np-ui:callStart", function(data, cb)
  local caller_number, target_number  = data.character.number, data.number
  RPC.execute("phone:callStart", caller_number, target_number)
  TriggerEvent("attachItemPhone", "phone01")
  cb({ data = {}, meta = { ok = true, message = '' } })
end)

RegisterNetEvent("phone:call911")
AddEventHandler("phone:call911", function(args, pMakeCall, pAnon)
  if isDead then
    TriggerEvent("DoLongHudText", "Can't make a call yet... try /911o", 2)
    return
  end
  local cid = exports["isPed"]:isPed("cid")
  if RPC.execute("police:is911Banned", cid) then
    return TriggerEvent("DoLongHudText", "You are currently blocked from using emergency services.", 2)
  end
  local plyPos = GetEntityCoords(PlayerPedId(), true)
  local phoneNumber = exports["isPed"]:isPed("phone_number")
  local origin = false
  local msg = args[1] == "/911" and "Operator Call" or ""
  if not pAnon then
    origin = {
      x = plyPos.x,
      y = plyPos.y,
      z = plyPos.z
    }
  end
  if not pMakeCall then
    args[1] = ""
    for _, v in pairs(args) do
      msg = msg .. " " .. v
    end
  end
  local availableNumber
  if pMakeCall then
    availableNumber = RPC.execute("np-dispatch:get911Number")
    if not availableNumber then
      TriggerEvent("DoLongHudText", "No operators available, use /911o!", 2)
      return
    end
    RPC.execute("phone:callStart", tostring(phoneNumber), tostring(availableNumber), '911', "911 - " .. tostring(phoneNumber), "911")
    TriggerEvent("attachItemPhone", "phone01")
  end
  TriggerServerEvent('dispatch:svNotify', {
    dispatchCode = "911",
    displayCode = "911",
    skipMapping = true,
    recipientList = { ["police"] = true },
    isImportant = true,
    playSound = true,
    soundName = "HighPrioCrime",
    priority = 1,
    dispatchMessage = "An incoming 911 call!",
    text = (pAnon and "UNKNOWN NUMBER" or phoneNumber) .. (availableNumber and " to " .. availableNumber or "") .. " - " .. msg,
    origin = origin,
  })
end)

-- answer from phone
RegisterUICallback("np-ui:callAccept", function(data, cb)
  local call_id = data.meta.callId
  local success, message = RPC.execute('phone:callAccept', call_id)
  TriggerEvent("attachItemPhone", "phone01")
  cb({ data = {}, meta = { ok = true, message = 'done' }})
end)

-- end from phone
RegisterUICallback("np-ui:callEnd", function(data, cb)
  local call_id = data.meta.callId
  local success, message = RPC.execute('phone:callEnd', call_id)
  cb({ data = {}, meta = { ok = success, message = message }})
end)

RegisterUICallback("np-ui:togglePhoneNotificationSounds", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = 'done' }})
  RPC.execute("np-phone:silenceCallsForServerId")
end)

function endPhoneCall()
  TriggerEvent("destroyPropPhone")
  if not activeCallId or not incomingCallId then return end
  if activeCallId then
    RPC.execute('phone:callEnd', activeCallId)
  elseif incomingCallId then
    RPC.execute('phone:callEnd', incomingCallId)
  end

  local timeout = false

  Citizen.SetTimeout(1500, function() timeout = true end)

  while not timeout and (isRinging or isDialing or activeCallId) do
    Citizen.Wait(100)
  end
end

function answerPhoneCall()
  if not incomingCallId then return end
  if isDead then return end
  local isCuffed = exports["isPed"]:isPed("handcuffed")
  if isCuffed then return end
  RPC.execute('phone:callAccept', incomingCallId)
  TriggerEvent("attachItemPhone", "phone01")
end

function LoadAnimDict(dict)
  if not HasAnimDictLoaded(dict) then
      RequestAnimDict(dict)

      while not HasAnimDictLoaded(dict) do
          Citizen.Wait(0)
      end
  end
end

AddEventHandler("pd:deathcheck", function()
  isDead = not isDead
  if isDead then
    endPhoneCall()
  end
end)

function playPhoneCallAnim()
    local dict, anim = "cellphone@", "cellphone_text_to_call"

    Citizen.CreateThread(function() 
      LoadAnimDict(dict)

      local playerPed = PlayerPedId()

      while (isDialing or activeCallId) and not isDead do
        if not IsEntityPlayingAnim(playerPed, dict, anim, 3) then
          TaskPlayAnim(playerPed, dict, anim, 3.0, -1, -1, 50, 0, false, false, false)
        end

        Citizen.Wait(5000)
      end
      
      -- TODO: add transitions between browse and call mode rather than clearing task
      TriggerEvent("destroyPropPhone")
      -- ClearPedTasks(playerPed)
      StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_to_call", 1.0)
    end)
end

function HasValidPhoneItem()
  local phoneItems = {"mobilephone", "stoleniphone", "stolennokia", "stolenpixel3", "stolens8", "boomerphone", "burnerphone"}

  for _, item in ipairs(phoneItems) do
    if exports["np-inventory"]:hasEnoughOfItem(item, 1, false, true) then
      return true  
    end
  end

  return false
end

RPC.register("phone:HasValidPhoneItem", function()
  return HasValidPhoneItem()
end)

AddEventHandler("np-ui:application-closed", function (name, data)
  if name ~= "burner" then return end
  StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
  if not IsInActiveCall() then
      TriggerEvent("destroyPropPhone")
  end
end)

-- init
Citizen.CreateThread(function()
  exports["np-keybinds"]:registerKeyMapping("","Phone", "Call Answer", "+answerPhoneCall", "-answerPhoneCall")
  RegisterCommand('+answerPhoneCall', answerPhoneCall, false)
  RegisterCommand('-answerPhoneCall', function() end, false)
  exports["np-keybinds"]:registerKeyMapping("","Phone", "Call End", "+endPhoneCall", "-endPhoneCall")
  RegisterCommand('+endPhoneCall', endPhoneCall, false)
  RegisterCommand('-endPhoneCall', function() end, false)
end)
