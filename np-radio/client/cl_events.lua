local isRadioOpen = false

RegisterNetEvent('ChannelSet')
AddEventHandler('ChannelSet', function(chan)
    exports["np-ui"]:sendAppEvent("radio", { value = chan })
end)

RegisterNetEvent('radioGui')
AddEventHandler('radioGui', function()
    local currentJob = exports["isPed"]:isPed("myjob")

    if exports["isPed"]:isPed("incall") then
    TriggerEvent("DoShortHudText","You can not do that while in a call!",2)
        return
    end

    if not hasRadio() then
        TriggerEvent("DoShortHudText","You need a radio.",2)
        toggleRadioAnimation(false)
        return
    end

    if not isRadioOpen then
        exports["np-ui"]:openApplication("radio", {
            emergency = (currentJob == "police" or currentJob == "ems" or currentJob == "doc")
        })
        toggleRadioAnimation(true)
    else
        exports["np-ui"]:closeApplication("radio")
        closeEvent()
    end

    isRadioOpen = not isRadioOpen
end)

RegisterUICallback('np-ui:radioVolumeUp', function(data, cb)
    exports["np-voice"]:IncreaseRadioVolume()
    cb({ data = {}, meta = { ok = true, message = '' } })
end)

RegisterUICallback('np-ui:radioVolumeDown', function(data, cb)
    exports["np-voice"]:DecreaseRadioVolume()
    cb({ data = {}, meta = { ok = true, message = '' } })
end)

RegisterUICallback('np-ui:toggleRadioOn', function(data, cb)
    exports["np-voice"]:SetRadioPowerState(true)
    cb({ data = {}, meta = { ok = true, message = '' } })
end)

RegisterUICallback('np-ui:toggleRadioOff', function(data, cb)
    exports["np-voice"]:SetRadioPowerState(false)
    cb({ data = {}, meta = { ok = true, message = '' } })
end)

RegisterUICallback('np-ui:setRadioChannel', function(data, cb)
    local success = handleConnectionEvent(data.channel)
    cb({ data = success, meta = { ok = true, message = '' } })
end)

AddEventHandler('np-radio:setChannel', function(params)
    handleConnectionEvent(params[1])
    exports["np-ui"]:sendAppEvent("radio", { value = params[1] })
end)

AddEventHandler('np-radio:updateRadioState', function (frequency, powered)
    exports["np-ui"]:sendAppEvent("radio", { value = frequency, state = powered })
end)

AddEventHandler("np-ui:application-closed", function (name, data)
    if name ~= "radio" then return end
    isRadioOpen = false
    closeEvent()
end)

RegisterNetEvent('np-inventory:itemCheck')
AddEventHandler('np-inventory:itemCheck', function (item, state, quantity)
    if item ~= "civradio" and item ~= "radio" then return end
    if state or quantity > 0 then return end
    exports["np-voice"]:SetRadioPowerState(false)
    exports["np-ui"]:sendAppEvent("radio", { value = 0, state = false })
    TriggerEvent("DoLongHudText", "You have been disconnected from the radio.")
end)