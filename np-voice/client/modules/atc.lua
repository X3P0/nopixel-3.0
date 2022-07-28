ATCRadio, ATCRadioVolume, IsATCRadioOn, IsConnected, IsTransmittingToATC = RadioChannel:new(118.0), Config.settings.atcVolume, true, false, false

function ConnectToATCFrequency()
    local subscribers = RPC.execute('np-voice:atc:subscribe')

    for serverId, active in pairs(subscribers) do
        if active then ATCRadio:addSubscriber(serverId) end
    end

    IsConnectedToATC = true

    Debug("[ATC] Connected to Radio")
end

function DisconnectFromATCFrequency()
    IsConnectedToATC = false

    if IsTransmittingToATC then
        StopATCTransmission(true)
    end

    RPC.execute('np-voice:atc:unsubscribe')

    Debug("[ATC] Disconnected from Radio")
end

function AddATCSubscriber(pServerId)
    if ATCRadio:subscriberExists(pServerId) then return end

    ATCRadio:addSubscriber(pServerId)

    if IsTransmittingToATC then
        AddPlayerToTargetList(pServerId, "atc", true)
    end

    Debug("[ATC] Added Subscriber | Player: %s", pServerId)
end

function RemoveATCSubscriber(pServerId)
    if not ATCRadio:subscriberExists(pServerId) then return end

    ATCRadio:removeSubscriber(pServerId)

    if IsTransmittingToATC then
        RemovePlayerFromTargetList(pServerId, "atc", true, true)
    end

    Debug("[ATC] Removed Subscriber | Player: %s", pServerId)
end

function SetATCRadioPowerState(state)
    if Throttled("atc:powerState") then return end
    IsATCRadioOn = state

    local volume = _C(IsATCRadioOn, ATCRadioVolume, -1.0)

    UpdateContextVolume("atc", volume)

    if not IsATCRadioOn and IsTransmittingToATC then
        StopATCTransmission(true)
    end

    Throttled("atc:powerState", 500)

    Debug("[ATC] Power State | Powered On: %s", IsATCRadioOn)
end

function SetATCRadioVolume(volume, pDisableNotification)
    if volume <= 0 then return end

    ATCRadioVolume = _C(volume > 10, 1.0, volume * 0.1)

    if almostEqual(0.0, volume, 0.01) then ATCRadioVolume = 0.0 end

    if IsATCRadioOn then
        UpdateContextVolume("atc", ATCRadioVolume)
    end

    if not pDisableNotification then
        TriggerEvent("DoLongHudText", ("New ATC volume %s"):format(ATCRadioVolume), 1, 12000, { i18n = { "New ATC volume" }})
    end

    Debug("[ATC] Volume Changed | Current: %s", ATCRadioVolume)
end

function IncreaseATCRadioVolume()
    local currentVolume = ATCRadioVolume * 10
    SetATCRadioVolume(currentVolume + 1)
end

function DecreaseATCRadioVolume()
    local currentVolume = ATCRadioVolume * 10
    SetATCRadioVolume(currentVolume - 1)
end

function StartATCRadioTask()
    Citizen.CreateThread(function()
        local lib = "random@arrests"
        local anim = "generic_radio_chatter"
        local playerPed = PlayerPedId()

        LoadAnimDict("random@arrests")

        while IsTransmittingToATC do
            if not IsEntityPlayingAnim(playerPed, lib, anim, 3) then
                TaskPlayAnim(playerPed, lib, anim, 8.0, 0.0, -1, 49, 0, false, false, false)
            end

            SetControlNormal(0, 249, 1.0)

            Citizen.Wait(0)
        end

        StopAnimTask(playerPed, lib, anim, 3.0)
    end)
end

function StartATCTransmission()
    if not IsATCRadioOn or not IsConnectedToATC or Throttled("atc:transmit") or isDead or IsTransmissionDisabled("atc") then return end

    if not IsTransmittingToATC then
        IsTransmittingToATC = true

        AddGroupToTargetList(ATCRadio.subscribers, "atc")

        StartATCRadioTask()

        PlayLocalRadioClick(true)

        Debug("[ATC] Transmission | Sending: %s", IsTransmittingToATC)
    end

    if ATCTimeout then
        ATCTimeout:resolve(false)
    end
end

function StopATCTransmission(forced)
    if not IsTransmittingToATC or ATCTimeout then return end

    ATCTimeout = TimeOut(300):next(function (continue)
        ATCTimeout = nil

        if forced ~= true and not continue then return end

        IsTransmittingToATC = false

        RemoveGroupFromTargetList(ATCRadio.subscribers, "atc", true)

        PlayLocalRadioClick(false)

        Throttled("atc:transmit", 300)

        Debug("[ATC] Transmission | Sending: %s", IsTransmittingToATC)
    end)

    return ATCTimeout
end

function LoadATCModule()
    RegisterModuleContext("atc", 3)

    UpdateContextVolume("atc", Config.settings.atcVolume)

    if Config.enableSubmixes and Config.enableFilters.radio then
        -- RegisterContextSubmix("atc")

        -- local filters = {
        --     { name = "freq_low", value = 100.0 },
        --     { name = "freq_hi", value = 5000.0 },
        --     { name = "rm_mod_freq", value = 300.0 },
        --     { name = "rm_mix", value = 0.1 },
        --     { name = "fudge", value = 4.0 },
        --     { name = "o_freq_lo", value = 300.0 },
        --     { name = "o_freq_hi", value = 5000.0 },
        -- }

        -- SetFilterParameters("atc", filters)
    end

    exports["np-keybinds"]:registerKeyMapping("", "ATC", "Push-To-Talk", "+transmitToATCRadio", "-transmitToATCRadio")
    RegisterCommand('+transmitToATCRadio', StartATCTransmission, false)
    RegisterCommand('-transmitToATCRadio', StopATCTransmission, false)

    exports["np-keybinds"]:registerKeyMapping("", "ATC", "On / Off", "+toggleATCRadioState", "-toggleATCRadioState")
    RegisterCommand('+toggleATCRadioState', function() SetATCRadioPowerState(not IsATCRadioOn) end, false)
    RegisterCommand('-toggleATCRadioState', function() end, false)

    exports["np-keybinds"]:registerKeyMapping("", "ATC", "Volume Up", "+increaseATCRadioVolume", "-increaseATCRadioVolume")
    RegisterCommand('+increaseATCRadioVolume', IncreaseATCRadioVolume, false)
    RegisterCommand('-increaseATCRadioVolume', function() end, false)

    exports["np-keybinds"]:registerKeyMapping("", "ATC", "Volume Down", "+decreaseATCRadioVolume", "-decreaseATCRadioVolume")
    RegisterCommand('+decreaseATCRadioVolume', DecreaseATCRadioVolume, false)
    RegisterCommand('-decreaseATCRadioVolume', function() end, false)

    RegisterNetEvent('np-voice:atc:connect', ConnectToATCFrequency)

    RegisterNetEvent('np-voice:atc:disconnect', DisconnectFromATCFrequency)

    RegisterNetEvent('np-voice:atc:setPowerState', SetATCRadioPowerState)

    RegisterNetEvent('np-voice:atc:addSubscriber', AddATCSubscriber)

    RegisterNetEvent('np-voice:atc:removeSubscriber', RemoveATCSubscriber)

    Debug("[ATC] Module Loaded")
end
