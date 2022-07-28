local powerPanelHash = -1094431857
local powerPanelCoords = vector3(712.336, 166.227, 79.75325)

-- AddEventHandler("np:target:changed", function(pEntity, pEntityType)
--     if not pEntity then
--         return
--     end
--     local model = GetEntityModel(pEntity)
--     if model == powerPanelHash and #(powerPanelCoords - GetEntityCoords(PlayerPedId())) < 3.0 then
--         TriggerEvent("DoLongHudText", "Be a real shame if this exploded...", 1, 2500)
--     end
-- end)

local entranceDoorCoords = {
    ["front_door"] = {
        coords = vector3(735.1982421875, 132.41223144531, 80.906539916992),
        heading = 0,
    },
}
AddEventHandler("np-inventory:itemUsed", function(item)
    if item ~= "lockpick" then return end
    activeEntranceDoor = nil
    local playerCoords = GetEntityCoords(PlayerPedId())
    for door, conf in pairs(entranceDoorCoords) do
        if #(playerCoords - conf.coords) < 1.0 then
            activeEntranceDoor = door
        end
    end
    if activeEntranceDoor == nil then return end

    
    TriggerServerEvent("dispatch:svNotify", {
        dispatchCode = "10-37",
        origin = entranceDoorCoords[activeEntranceDoor].coords,
    })

    local skillComplete = LoopSkill(5)
    if not skillComplete then
        TriggerEvent("inventory:removeItem", "lockpick", 1)
        return
    end

    RPC.execute("np-heists:cityPowerDoorOpen", activeEntranceDoor)
end)
