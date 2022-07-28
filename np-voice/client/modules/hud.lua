local function playRadioClick(transmitting, setting, type, pDistortion)
    if transmitting and Settings[setting] then
        SendNUIMessage({ type = type, state = transmitting, distortion = pDistortion})
    end
    if not transmitting and Settings[setting] then
        SendNUIMessage({ type = type, state = transmitting, distortion = pDistortion })
    end
end

function PlayRemoteRadioClick(transmitting, pDistortion)
    if transmitting then
        playRadioClick(transmitting, "remoteClickOn", "remoteClick", pDistortion)
    else
        playRadioClick(transmitting, "remoteClickOff", "remoteClick", pDistortion)
    end
end

function PlayLocalRadioClick(transmitting)
    if transmitting then
        playRadioClick(transmitting, "localClickOn", "localClick")
    else
        playRadioClick(transmitting, "localClickOff", "localClick")
    end
end

function UpdateRadioPowerState(state)
    exports["np-ui"]:sendAppEvent("radio", { value = CurrentChannel == nil and '' or CurrentChannel.id, state = IsRadioOn and 'on' or 'off' })
end

function UpdateHudSettings()
    SendNUIMessage({ type = 'settings', settings = Settings })
end
