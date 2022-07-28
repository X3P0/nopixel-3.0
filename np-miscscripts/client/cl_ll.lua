local count, data

CreateThread(function ()
    exports["np-polytarget"]:AddBoxZone("ll_sliders", vector3(1151.47, -409.69, 72.25), 0.6, 1.2, {
        heading=75,
        minZ=71.45,
        maxZ=72.65
    })
    exports["np-interact"]:AddPeekEntryByPolyTarget("ll_sliders", {{
        NPXEvent = "np-miscscripts:ll:sliders",
        id = "ll_sliders",
        icon = "sliders-h",
        label = "Control Panel",
        parameters = { },
    }}, { distance = { radius = 3.5 }  })
end)

NPX.Events.on("np-miscscripts:ll:sliders", function ()
    if not count or not data then
        local sliderSettings = NPX.Procedures.execute("np-miscscripts:ll:getSliders")
        count = sliderSettings.count
        data = sliderSettings.data
    end

    exports['np-ui']:openApplication('range-picker', {
        ["sliders"] = count,
        ["submitUrl"] = "np-miscscripts:ll:submitSliders"
    })
end)

RegisterUICallback("np-miscscripts:ll:submitSliders", function (result, cb)
    cb({ data = {}, meta = { ok = true, message = 'done' } })
    exports['np-ui']:closeApplication('range-picker')
    local diff = 0
    for i = 1, count do
        diff = diff + math.abs(data[i] - tonumber(result.ranges[i]))
    end
    if diff > 50*count then
        exports['ragdoll']:SetPlayerHealth(0)
        TriggerEvent("DoLongHudText", "Well this was fucking shit wasnt it", 2)
    elseif diff > 10*count then
        exports['ragdoll']:SetPlayerHealth(GetEntityHealth(PlayerPedId()) - math.random(5, 20))
        TriggerEvent("DoLongHudText", "Ouch", 2)
    elseif diff == 0 then
        TriggerEvent("DoLongHudText", "Congrats you somehow found the absolute correct numbers. Go do something with your life now", 1)
    else
        TriggerEvent("DoLongHudText", "Close enough, this will work for now", 1)
    end
end)
