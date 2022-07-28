local EVENTS = {
    SWITCHER = 1,
    OUTFITS = 2,
}

local MenuData = {
    {
        title = "Outfits",
        description = "Gotta look fresh",
        action = "np-business:sh_handler",
        key = { event = EVENTS.OUTFITS, switchCharacter = true }
    },
    {
        title = "Character switch",
        description = "Go bowling with your cousin",
        children = {
            { title = "Yes", action = "np-business:sh_handler", key = { event = EVENTS.SWITCHER, switchCharacter = true } },
            { title = "No", action = "np-business:sh_handler", key = { event = EVENTS.SWITCHER, switchCharacter = false } },
        }
    },
}

local listening = false
local function listenForKeypress(pEvent)
    listening = true
    Citizen.CreateThread(function()
        while listening do
            if IsControlJustReleased(0, 38) then
                listening = false
                exports["np-ui"]:hideInteraction()
                exports["np-ui"]:showContextMenu(MenuData)
            end
            Wait(0)
        end
    end)
end

AddEventHandler("np-polyzone:enter", function(zone)
    if zone == "saco_log" or zone == "hades_log" or zone == "saco_beach_log" then
        exports["np-ui"]:showInteraction("[E] Wardrobe")
        listenForKeypress(zone)
    end
end)

AddEventHandler("np-polyzone:exit", function(zone)
    if zone == "saco_log" or zone == "hades_log" or zone == "saco_beach_log" then
        exports["np-ui"]:hideInteraction()
        listening = false
    end
end)



RegisterUICallback("np-business:sh_handler", function(data, cb)
    local eventData = data.key
    if eventData.event == EVENTS.SWITCHER and eventData.switchCharacter then
        TransitionToBlurred(500)
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerEvent("np-base:clearStates")
        exports["np-base"]:getModule("SpawnManager"):Initialize()
        Wait(1000)
    elseif eventData.event == EVENTS.OUTFITS then
        TriggerEvent('np-clothing:outfits')
    end
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)