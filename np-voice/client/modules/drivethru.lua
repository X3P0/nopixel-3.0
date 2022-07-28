DTRadio, DTVolume, IsDTRadioOn, IsConnectedToDT, IsTransmittingToDT, DTIsHeadset = RadioChannel:new(120.6), Config.settings.dtVolume, true, false, false, false

function ConnectToDTFrequency(pIsHeadset)
    local subscribers = RPC.execute('np-voice:drivethru:subscribe')

    for serverId, active in pairs(subscribers) do
        if active then DTRadio:addSubscriber(serverId) end
    end

    IsConnectedToDT = true
    DTIsHeadset = pIsHeadset

    exports['np-ui']:sendAppEvent("hud", {
        burgerShotIntercom = IsDTRadioOn
    })

    Debug("[DriveThru] Connected to Radio")
end

function DisconnectFromDTFrequency()
    IsConnectedToDT = false

    if IsTransmittingToDT then
        StopDTTransmission(true)
    end

    RPC.execute('np-voice:drivethru:unsubscribe')
    DTIsHeadset = false

    exports['np-ui']:sendAppEvent("hud", {
        burgerShotIntercom = false
    })

    Debug("[DriveThru] Disconnected from Radio")
end

function AddDTSubscriber(pServerId)
    if DTRadio:subscriberExists(pServerId) then return end

    DTRadio:addSubscriber(pServerId)

    if IsTransmittingToDT then
        AddPlayerToTargetList(pServerId, "drivethru", true)
    end

    Debug("[DriveThru] Added Subscriber | Player: %s", pServerId)
end

function RemoveDTSubscriber(pServerId)
    if not DTRadio:subscriberExists(pServerId) then return end

    DTRadio:removeSubscriber(pServerId)

    if IsTransmittingToDT then
        RemovePlayerFromTargetList(pServerId, "drivethru", true, true)
    end

    Debug("[DriveThru] Removed Subscriber | Player: %s", pServerId)
end

function SetDTRadioPowerState(state)
    if Throttled("drivethru:powerState") then return end
    IsDTRadioOn = state

    local volume = _C(IsDTRadioOn, DTVolume, -1.0)

    UpdateContextVolume("drivethru", volume)

    if not IsDTRadioOn and IsTransmittingToDT then
        StopDTTransmission(true)
    end

    Throttled("drivethru:powerState", 500)

    exports['np-ui']:sendAppEvent("hud", {
        burgerShotIntercom = IsDTRadioOn
    })

    Debug("[DriveThru] Power State | Powered On: %s", IsDTRadioOn)
end

function SetDTRadioVolume(volume, pDisableNotification)
    if volume <= 0 then return end

    DTVolume = _C(volume > 10, 1.0, volume * 0.1)

    if almostEqual(0.0, volume, 0.01) then DTVolume = 0.0 end

    if IsDTRadioOn then
        UpdateContextVolume("drivethru", DTVolume)
    end

    if not pDisableNotification then
        TriggerEvent("DoLongHudText", ("New DriveThru volume %s"):format(DTVolume), 1, 12000, { i18n = { "New DriveThru volume" } })
    end

    Debug("[DriveThru] Volume Changed | Current: %s", DTVolume)
end

function IncreaseDTRadioVolume()
    local currentVolume = DTVolume * 10
    SetDTRadioVolume(currentVolume + 1)
end

function DecreaseDTRadioVolume()
    local currentVolume = DTVolume * 10
    SetDTRadioVolume(currentVolume - 1)
end

function StartDTRadioTask()
    Citizen.CreateThread(function()
        local lib = "random@arrests"
        local anim = "generic_radio_chatter"
        local playerPed = PlayerPedId()

        LoadAnimDict("random@arrests")

        while IsTransmittingToDT do
            if not IsEntityPlayingAnim(playerPed, lib, anim, 3) then
                TaskPlayAnim(playerPed, lib, anim, 8.0, 0.0, -1, 49, 0, false, false, false)
            end

            SetControlNormal(0, 249, 1.0)

            Citizen.Wait(0)
        end

        StopAnimTask(playerPed, lib, anim, 3.0)
    end)
end

function StartDTTransmission()
    if not IsDTRadioOn or not IsConnectedToDT or (DTIsHeadset and Throttled("drivethru:transmit")) or isDead then return end

    if not IsTransmittingToDT then
        IsTransmittingToDT = true

        AddGroupToTargetList(DTRadio.subscribers, "drivethru")

        if DTIsHeadset then
            StartDTRadioTask()
        end

        Debug("[DriveThru] Transmission | Sending: %s", IsTransmittingToDT)
    end

    if DTTimeout then
        DTTimeout:resolve(false)
    end
end

function StopDTTransmission(forced)
    if not IsTransmittingToDT or DTTimeout then return end

    DTTimeout = TimeOut(300):next(function (continue)
        DTTimeout = nil

        if forced ~= true and not continue then return end

        IsTransmittingToDT = false

        RemoveGroupFromTargetList(DTRadio.subscribers, "drivethru", true)

        Throttled("drivethru:transmit", 300)

        Debug("[DriveThru] Transmission | Sending: %s", IsTransmittingToDT)
    end)

    return DTTimeout
end

function LoadDTModule()
    RegisterModuleContext("drivethru", 3)

    UpdateContextVolume("drivethru", Config.settings.dtVolume)

    if Config.enableSubmixes and Config.enableFilters.radio then
        RegisterContextSubmix("drivethru")

        local filters = {
            { name = "freq_low", value = 300.0 },
            { name = "freq_hi", value = 3000.0 },
            { name = "rm_mod_freq", value = 300.0 },
            { name = "rm_mix", value = 0.1 },
            { name = "fudge", value = 4.0 },
            { name = "o_freq_lo", value = 300.0 },
            { name = "o_freq_hi", value = 5000.0 },
        }

        SetFilterParameters("drivethru", filters)
    end

    exports["np-keybinds"]:registerKeyMapping("", "DriveThru Headset", "Push-To-Talk", "+transmitToDriveThru", "-transmitToDriveThru")
    RegisterCommand('+transmitToDriveThru', function()
        if not DTIsHeadset then return end
        StartDTTransmission()
    end, false)
    RegisterCommand('-transmitToDriveThru', function()
        if not DTIsHeadset then return end
        StopDTTransmission()
    end, false)

    exports["np-keybinds"]:registerKeyMapping("", "DriveThru Headset", "On / Off", "+toggleDTRadioState", "-toggleDTRadioState")
    RegisterCommand('+toggleDTRadioState', function()
        if not DTIsHeadset then return end
        SetDTRadioPowerState(not IsDTRadioOn)
    end, false)
    RegisterCommand('-toggleDTRadioState', function() end, false)

    exports["np-keybinds"]:registerKeyMapping("", "DriveThru Headset", "Volume Up", "+increaseDTVolume", "-increaseDTVolume")
    RegisterCommand('+increaseDTVolume', IncreaseDTRadioVolume, false)
    RegisterCommand('-increaseDTVolume', function() end, false)

    exports["np-keybinds"]:registerKeyMapping("", "DriveThru Headset", "Volume Down", "+decreaseDTRadioVolume", "-decreaseDTRadioVolume")
    RegisterCommand('+decreaseDTRadioVolume', DecreaseDTRadioVolume, false)
    RegisterCommand('-decreaseDTRadioVolume', function() end, false)

    RegisterNetEvent('np-voice:drivethru:connect', ConnectToDTFrequency)

    RegisterNetEvent('np-voice:drivethru:disconnect', DisconnectFromDTFrequency)

    RegisterNetEvent('np-voice:drivethru:setPowerState', SetDTRadioPowerState)

    RegisterNetEvent('np-voice:drivethru:addSubscriber', AddDTSubscriber)

    RegisterNetEvent('np-voice:drivethru:removeSubscriber', RemoveDTSubscriber)

    -- scuffed way of overriding vanilla keybind
    AddEventHandler('np:voice:transmissionStarted', function()
        if DTIsHeadset then return end
        StartDTTransmission()
    end)

    AddEventHandler('np:voice:transmissionFinished', function()
        if DTIsHeadset then return end
        StopDTTransmission(true)
    end)

    Debug("[DriveThru] Module Loaded")
end
