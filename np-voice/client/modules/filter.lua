local SubmixList, SubmixCount = {}, 0

function RegisterContextSubmix(pContext)
    local data = {}

    SubmixCount = SubmixCount + 1

    data.slot = 1
    data.submix = CreateAudioSubmix(pContext)

    Transmissions:setContextData(pContext, "submix", pContext)

    SubmixList[pContext] = data

    Debug('[Filter] Registered Submix | %s', pContext)
end

function SetFilterParameters(pContext, pSettings)
    local data = SubmixList[pContext]

    if not data or not pSettings then return end

    data.setting = pSettings

    SetAudioSubmixEffectRadioFx(data.submix, data.slot)
    SetAudioSubmixEffectParamInt(data.submix, data.slot, `default`, 1)

    for _, setting in ipairs(pSettings) do
        SetAudioSubmixEffectParamFloat(data.submix, data.slot, GetHashKey(setting.name), setting.value)
    end

    AddAudioSubmixOutput(data.submix, data.slot)

    Debug('[Filter] Updated Submix parameters | %s', pContext)
end

function SetSubmixBalance(pContext, pBalance)
    local data = SubmixList[pContext]

    if not data or not pBalance then return end

    local leftChannels, rightChannels = CalculateAudioBalance(pBalance)

    SetAudioSubmixOutputVolumes(data.submix, 0, leftChannels, rightChannels, leftChannels, rightChannels, leftChannels, rightChannels)

    Debug('[Filter] Update Submix Balance for %s | Values: Left %f Right %f ', pContext, leftChannels, rightChannels)
end

exports('SetSubmixBalance', SetSubmixBalance)

function SetPlayerFilter(pServerId, pContext)
    if pContext == "default" then
        MumbleSetSubmixForServerId(pServerId, -1)
    else
        local data = SubmixList[pContext]

        if not data then return end
        MumbleSetSubmixForServerId(pServerId, data.submix)
    end

    Debug('[Filter] Changed Player Submix | Server ID: %s | Submix: %s', pServerId, pContext)
end

function SetTransmissionFilters(serverID, context)
    local submix = context.submix and context.submix or 'default'
    SetPlayerFilter(serverID, submix)
end

function CanUseFilter(transmitting, context)
    if transmitting and context == "radio" and not IsRadioOn then
        return false
    end

    return true
end

RegisterNetEvent("np:voice:connection:state")
AddEventHandler("np:voice:connection:state", function (serverID, isConnected)
    if not isConnected and Config.enableSubmixes then
        SetPlayerFilter(serverID, 'default')
        Debug("[Filter] Submix Reset | Player: %s ", serverID)
    end
end)

AddEventHandler('np:voice:state', function (isActive)
    if not isActive and Config.enableSubmixes then
        Transmissions:contextIterator(function (pServerId)
            SetPlayerFilter(pServerId, 'default')
        end)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() or not Config.enableSubmixes then return end

    Transmissions:contextIterator(function (pServerId)
        SetPlayerFilter(pServerId, 'default')
    end)
end)