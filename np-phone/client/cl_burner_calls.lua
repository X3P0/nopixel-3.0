local isDialing, dialCounter, isRinging, ringingCounter, activeCallId = false, 0, false, 0, nil

-- This is what you should call on the receiving end ;)
RegisterNetEvent("burner:call:receive")
AddEventHandler("burner:call:receive", function(pNumber, pCallId)
  SendUIMessage({
    source = "np-nui",
      app = "burner",
      data = {
        action = "call-receiving",
        number = pNumber,
        callId = pCallId
    }
  })
  isRinging = true
end)

-- call this event when call begins
RegisterNetEvent("burner:call:in-progress")
AddEventHandler("burner:call:in-progress", function(pNumber, pCallId)
  SendUIMessage({
    source = "np-nui",
    app = "burner",
    data = {
      action = "call-in-progress",
      number = pNumber,
      callId = pCallId
    }
  })
  isDialing, isRinging = false, false
  activeCallId = pCallId
  playBurnerCallAnim()
end)

-- call this event when call is outgoing
RegisterNetEvent("burner:call:dialing")
AddEventHandler("burner:call:dialing", function(pNumber, pCallId)
  
  SendUIMessage({
    source = "np-nui",
    app = "burner",
    data = {
      action = "call-dialing",
      number = pNumber,
      callId = pCallId
    }
  })
  isDialing = true
  playBurnerCallAnim()
end)

-- call this when there is no active calling state (not dialing, receiving, in call - after hang up)
RegisterNetEvent("burner:call:inactive")
AddEventHandler("burner:call:inactive", function(pNumber, pCallId, pMessage)
  SendUIMessage({
    source = "np-nui",
    app = "burner",
    data = {
      action = "call-inactive",
      number = pNumber,
      message = pMessage,
    }
  })
  isDialing, isRinging = false, false
  activeCallId = nil
end)

-- dial from phone
RegisterUICallback("np-ui:burnerCallStart", function(data, cb)
  local caller_number, target_number = data.source_number, data.number
  RPC.execute("burner:callStart", caller_number, target_number)
  cb({ data = {}, meta = { ok = true, message = '' } })
end)

function playBurnerCallAnim()
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
    ClearPedTasks(playerPed)
  end)
end