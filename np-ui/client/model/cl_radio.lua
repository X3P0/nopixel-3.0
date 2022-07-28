RegisterNUICallback("np-ui:hudUpdateRadioSettings", function(data, cb)
    exports["np-base"]:getModule("SettingsData"):setSettingsTableGlobal({ ["tokovoip"] = data.settings }, true)
    cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterNUICallback("np-ui:hudUpdateKeybindSettings", function(data, cb)
    exports["np-base"]:getModule("DataControls"):encodeSetBindTable(data.controls)
    cb({ data = {}, meta = { ok = true, message = 'done' } })
end)