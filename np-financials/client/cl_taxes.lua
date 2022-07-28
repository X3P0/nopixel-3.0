RegisterUICallback("np-ui:getTaxOptions", function(data, cb)
    local success, message = RPC.execute("GetTaxLevels", true)
    cb({ data = message, meta = { ok = success, message = 'ok' } })
end)

RegisterUICallback("np-ui:getTaxHistory", function(data, cb)
    local success, message = RPC.execute("GetTaxHistory")
    cb({ data = message, meta = { ok = success, message = 'ok' } })
end)

RegisterUICallback("np-ui:saveTaxOptions", function(data, cb)
    local options = data.options -- { [ id: 1, level: 10 ]}
    local success, message = RPC.execute("SetTaxLevel", options)
    cb({ data = message, meta = { ok = success, message = 'ok' } })
end)

RegisterUICallback("np-ui:getAssetTaxes", function(data, cb)
    local cid = data.character.id
    local success, message = RPC.execute("GetAssetTaxes", cid)
    if success then
        local houses = exports["np-housing"]:retrieveHousingTableMapped()
        for _, tax in pairs(message) do
            if tax.asset_type == "property" then
                local str = ("00%s0"):format(tax.asset_owner_id)
                local propertyId = tax.asset_name:sub(#str - 1)
                tax.asset_name = findProperty(houses, tonumber(propertyId))
            end
        end
    end
    cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:getOutstandingHousePayments", function (data, cb)
    local data = RPC.execute("getOutstandingHousePayments", data.property_owner, data.property_id)
    if data ~= nil then
        cb({ data = json.encode(data), meta = { ok = success, message = "done" } })
        return
    end
    cb({ data = json.encode({}), meta = { ok = success, message = "done" } })
end)

function findProperty(houses, id)
    for _, house in pairs(houses) do
        if house.id == id then
            return house.street
        end
    end
    return "Property"
end


RegisterUICallback("np-ui:payAssetTax", function(data, cb)
    local pCharacterId, pSourceAccountId, pAssetTaxId, pAssetName = data.character.id, data.character.bank_account_id, data.asset.id, data.asset.name
    local success, message = RPC.execute("PayAssetTaxes", pCharacterId, pSourceAccountId, pAssetTaxId, pAssetName)
    cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)
