local keypadCoords = vector3(-105.3, 6471.61, 31.63)
local keypadHeading = 46.5

local function usePanel(laptopId)
    local canRobPaleto, message = RPC.execute("heists:paletoReady", laptopId)
    if not canRobPaleto then
        TriggerEvent("DoLongHudText", message, 2)
        return
    end

    local canRob = CheckRequiredItems("paleto")
    if not canRob then return end

    local success = Citizen.Await(UseBankPanel(keypadCoords, keypadHeading, "paleto"))

    if not success then
        RPC.execute("np-heists:paletoPanelFail")
        return
    end

    RemoveRequiredItems("paleto")

    TriggerServerEvent("dispatch:svNotify", {
        dispatchCode = "10-90B",
        origin = keypadCoords,
    })

    TriggerEvent("inventory:removeItemByMetaKV", "heistlaptop2", 1, "id", laptopId)

    local trolleyConfig = GetTrolleyConfig("paleto")
    local shouldSpawnGold = RPC.execute("heists:paletoStart")
    SpawnTrolley(trolleyConfig.cashCoords, "cash", trolleyConfig.cashHeading)
    if shouldSpawnGold then
        SpawnTrolley(trolleyConfig.goldCoords, "gold", trolleyConfig.goldHeading)
    end
end

function PaletoCanUsePanel()
    return false -- #(GetEntityCoords(PlayerPedId()) - keypadCoords) < 1.0
end
function PaletoUsePanel(...)
    usePanel(...)
end

AddEventHandler("heists:paletoTrolleyGrab", function(loc, type)
    local canGrab = RPC.execute("np-heists:paletoCanGrabTrolley", loc, type)
    if canGrab then
        Loot(type)
        TriggerEvent("DoLongHudText", "You discarded the counterfeit items", 1)
        RPC.execute("np-heists:payoutTrolleyGrab", loc, type)
    else
        TriggerEvent("DoLongHudText", "You can't do that yet...", 2)
    end
end)
