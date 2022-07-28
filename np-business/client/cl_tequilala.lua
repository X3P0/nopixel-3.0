local listening = false
local function listenForTequilalaDJKeypress(type, data)
    listening = true
    Citizen.CreateThread(function()
        while listening do
            if IsControlJustReleased(0, 38) then
                TriggerEvent("np-music:showBroadcastContextMenu", "tequilala")
            end
            Wait(0)
        end
    end)
end


AddEventHandler("np-polyzone:enter", function(name, data)
    if name == "tequilala" then
        TriggerEvent("np-music:subscribe", "tequilala");
        return
    end
    if name == "tequilala_dj" then
        listenForTequilalaDJKeypress(name, data)
        exports["np-ui"]:showInteraction("[E] DJ")
    end
end)


AddEventHandler("np-polyzone:exit", function(name, data)
    if name == "tequilala" then
        TriggerEvent("np-music:unsubscribe");
        return
    end
    if name == "tequilala_dj" then
        listening = false
        exports["np-ui"]:hideInteraction()
    end
end)

CreateThread(function ()
    exports["np-polyzone"]:AddBoxZone("tequilala", vector3(-559.15, 284.96, 82.18), 15.6, 20.8, {
        heading=355,
        minZ=75.18,
        maxZ=89.58
    })
    exports["np-polyzone"]:AddBoxZone("tequilala_dj", vector3(-561.4, 281.46, 85.68), 2.4, 3.8, {
        heading=355,
        minZ=84.68,
        maxZ=87.08
    })
end)