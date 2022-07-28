local gameDirty = false
local gameValues = {}
local hudDirty = false
local hudValues = {}

function makeHudDirty()
    hudDirty = true
end
function setHudValue(k, v)
    if hudValues[k] == nil or hudValues[k] ~= v then
        hudDirty = true
    end
    hudValues[k] = v
end
function setGameValue(k, v)
    if gameValues[k] == nil or gameValues[k] ~= v then
        gameDirty = true
    end
    gameValues[k] = v
end

Citizen.CreateThread(function()
    while true do
        if hudDirty then
            hudDirty = false
            sendAppEvent("hud", hudValues)
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(500)
    while true do
        if gameDirty then
            gameDirty = false
            sendAppEvent("game", gameValues)
        end
        Citizen.Wait(1000)
    end
end)

-- RegisterCommand("np-ui:hud-preset", function(source, args)
--     sendAppEvent("preferences", {
--         changeHud = tonumber(args[1])
--     })
-- end)
-- RegisterCommand("np-ui:preferences", function(source, args)
--     openApplication("preferences")
-- end)
