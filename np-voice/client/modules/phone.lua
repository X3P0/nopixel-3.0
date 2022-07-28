PhoneVolume, IsOnPhoneCall, CurrentCall = 1.0, false

function StartPhoneCall(serverId, callId)
    if IsOnPhoneCall then return end

    IsOnPhoneCall = true

    CurrentCall = { callId = callId, targetId = serverId }

    AddPlayerToTargetList(serverId, "phone", true)

    Citizen.CreateThread(function()
        local existingTarget = not Targets:targetHasAnyActiveContext(serverId)
        local existingChannel = not IsPlayerInTargetChannel(serverId)
        while IsOnPhoneCall do
            local currentTarget = not Targets:targetHasAnyActiveContext(serverId)
            local currentChannel = not IsPlayerInTargetChannel(serverId)
            if existingTarget ~= currentTarget or existingChannel ~= currentChannel then
                existingTarget = currentTarget
                existingChannel = currentChannel
                RefreshTargets()
            end

            Citizen.Wait(1000)
        end
    end)

    Debug('[Phone] Call Started | Call ID %s | Player %s', callId, serverId)
end

function StopPhoneCall(serverId, callId)
    if not IsOnPhoneCall or CurrentCall.callId ~= callId then return end

    IsOnPhoneCall = false

    CurrentCall = nil

    RemovePlayerFromTargetList(serverId, "phone", true, true)

    Debug('[Phone] Call Ended | Call ID %s | Player %s', callId, serverId)
end

function IncreasePhoneVolume()
  local currentVolume = PhoneVolume * 10
  SetPhoneVolume(currentVolume + 1)
end

function DecreasePhoneVolume()
  local currentVolume = PhoneVolume * 10
  SetPhoneVolume(currentVolume - 1)
end

function SetPhoneVolume(volume)
  -- We prevent the usage of a volume lower than 1
  if volume <= 0 then return end

  -- If the specified volume is beyond the allowed limit then we set it to the maximum volume instead
  PhoneVolume = _C(volume > 10, 1.0, volume * 0.1)

  if almostEqual(0.0, volume, 0.01) then PhoneVolume = 0.0 end

  -- If the radio is turned on then we update the volume of the current transmissions
  UpdateContextVolume("phone", PhoneVolume)

  Debug("[Phone] Volume Changed | Current: %s", PhoneVolume)
end

function LoadPhoneModule()
    RegisterModuleContext("phone", 1)
    UpdateContextVolume("phone", Config.settings.phoneVolume)

    RegisterNetEvent("np:voice:phone:call:start")
    AddEventHandler("np:voice:phone:call:start", StartPhoneCall)

    RegisterNetEvent("np:voice:phone:call:end")
    AddEventHandler("np:voice:phone:call:end", StopPhoneCall)

    exports("SetPhoneVolume", SetPhoneVolume)
    exports("IncreasePhoneVolume", IncreasePhoneVolume)
    exports("DecreasePhoneVolume", DecreasePhoneVolume)

    if Config.enableSubmixes and Config.enableFilters.phone then
        RegisterContextSubmix("phone")

        local filters = {
            { name = "freq_low", value = 100.0 },
            { name = "freq_hi", value = 10000.0 },
            { name = "rm_mod_freq", value = 0.0 },
            { name = "rm_mix", value = 0.10 },
            { name = "fudge", value = 1.0 },
            { name = "o_freq_lo", value = 100.0 },
            { name = "o_freq_hi", value = 10000.0 },
        }

        SetFilterParameters("phone", filters)
    end

    TriggerEvent("np:voice:phone:ready")

    Debug("[Phone] Module Loaded")
end

RegisterNetEvent('np-voice:setTransmissionDisabled', function ()
    WasEventCanceled()

    if not IsOnPhoneCall then return end

    local serverId = CurrentCall.targetId

    local isPhoneDisabled = IsTransmissionDisabled("phone")

    if isPhoneDisabled then
        RemovePlayerFromTargetList(serverId, "phone", true, true)
    elseif not isPhoneDisabled and not IsPlayerInContextTargetList(serverId, "phone") then
        AddPlayerToTargetList(serverId, "phone", true)
    end
end)