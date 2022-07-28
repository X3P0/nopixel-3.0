local guitars = {
    ["green_guitar"] = true,
    ["white_guitar"] = true,
    ["pink_guitar"] = true,
    ["dark_red_guitar"] = true,
    ["yellow_guitar"] = true,
    ["blue_guitar"] = true,
    ["anime_guitar"] = true,
    ["puppers_guitar"] = true,
    ["black_guitar"] = true,
    ["abstract_guitar"] = true,
    ["purple_guitar"] = true,
    ["acoustic_guitar"] = true,
    ["black_acoustic_guitar"] = true,
    ["washed_acoustic_guitar"] = true,
    ["hubcaps_guitar"] = true,
}

CreateThread(function ()
    exports["np-polytarget"]:AddBoxZone("deeznotes_craft", vector3(-1055.46, -1562.94, 4.77), 2.4, 1, {
        heading=305,
        minZ=3.77,
        maxZ=6.37,
    })
    exports["np-interact"]:AddPeekEntryByPolyTarget("deeznotes_craft", {{
        id = 'deeznotes',
        label = 'Craft Guitars',
        icon = 'circle',
        event = "np-business:deeznotes:craft",
        parameters =  { id = "DeezNotesCrafting" },
    }}, {
        distance = { radius = 1.5 },
        isEnabled = function ()
            return IsEmployedAt("deeznotes") and HasPermission("deeznotes", "craft_access")
        end
    })
end)

AddEventHandler("np-business:deeznotes:craft", function ()
    if not IsEmployedAt("deeznotes") then
        return TriggerEvent("DoLongHudText", "Sorry you can't use this.", 2)
    end
    if not HasPermission("deeznotes", "craft_access") then
        return TriggerEvent("DoLongHudText", "Sorry you can't use this.", 2)
    end

    TriggerEvent('server-inventory-open', '42135', 'Craft')
end)

function stringsInserted(originInventory, targetInventory, originSlot, targetSlot, originItemId, targetItemId, originItemInfo, targetItemInfo)
    if originInventory ~= targetInventory then return end
    if originItemId ~= "GuitarStrings" then return end
    if not guitars[targetItemId] then return end

    local itemInfo = exports['np-inventory']:GetItemInfo(targetSlot)
    TriggerServerEvent("inventory:repairItem", itemInfo.id, 100, itemInfo.item_id, exports['isPed']:isPed("cid"))
    TriggerEvent("inventory:removeItemBySlot", originItemId, 1, originSlot)
end

for guitar, enabled in pairs(guitars) do
    if enabled then
        AddEventHandler(guitar .. ":insert", stringsInserted)
    end
end