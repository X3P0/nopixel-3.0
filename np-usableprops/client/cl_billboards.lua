local billboardItems = {
    ["mobilebillboard1"] = "np_billboard_01",
    ["mobilebillboard2"] = "np_billboard_02",
    ["mobilebillboard3"] = "np_billboard_03",
}

local billboardOffsets = {
    ["mobilebillboard1"] = -0.9,
    ["mobilebillboard2"] = -0.5,
    ["mobilebillboard3"] = -0.5
}

AddEventHandler("np-inventory:itemUsed", function (name)
    if not billboardItems[name] then return end

    placeBillboard(name)
end)

function placeBillboard (name)
    local result = exports['np-objects']:PlaceAndSaveObject(
        billboardItems[name],
        {},
        {
            groundSnap = true,
            zOffset = billboardOffsets[name]
        }
    )
    if not result then
        return false
    end

    TriggerEvent('inventory:removeItem', name, 1)
end