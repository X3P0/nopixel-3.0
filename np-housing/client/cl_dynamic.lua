local houseOptions = {
    {['id'] = 'v_int_36', ['name'] = 'Small Shop'},
    {['id'] = 'v_int_53', ['name'] = 'Large Shop'},
    {['id'] = 'empty_house_shop', ['name'] = 'Empty Shop'},
}

function hasPerms()
    local hasPerms = hasRealtorAccess(true)
    if not hasPerms then
      TriggerEvent("DoLongHudText", "You cannot do that.", 2)
      return false
    end
    return true
end

function openTextbox()

    if not hasPerms() then return end

    local isComplete, propertyId, dist, zone = Housing.func.findClosestProperty()

    if dist and dist < 5 then
        TriggerEvent('DoLongHudText', 'To Close to a current property.', 2)
        return
    end

    local items = {
        { icon = 'pencil-alt', label = 'Street Address', name = 'street' },
        { icon = 'pencil-alt', label = 'Price', name = 'price' },
        { _type = 'select', label = 'Building Type', name = 'streetType', options = houseOptions },
    }

    local textBoxOpen = true
    SetTimeout(120000, function()
        if textBoxOpen then
            exports['np-ui']:closeApplication('textbox')
            exports['np-selector']:deselect()
            TriggerEvent('DoLongHudText', 'Timed out!', 2)
        end
    end)
    local response = exports['np-ui']:OpenInputMenu(items)
    exports['np-ui']:closeApplication('textbox')
    exports['np-selector']:deselect()
    textBoxOpen = false

    if not response or response == nil then return end

    local price = tonumber(response.price)
    if price == nil or price <= 10000 then
        TriggerEvent('DoLongHudText', 'Price is to low. (min 10k)', 2)
        return
    end

    for k,v in pairs(Housing.info) do
        if v.Street == response.street then
            TriggerEvent('DoLongHudText', 'Name Already in use.', 2)
            return
        end
    end 

    local playerCoords = GetEntityCoords(PlayerPedId())
    local playerHeading = GetEntityHeading(PlayerPedId())
    local pos = vector4(playerCoords.x,playerCoords.y,playerCoords.z,playerHeading)

    local listData = RPC.execute("housing:addProperty", response.street, price, response.streetType,pos)
    updateList(listData)
end


function openRemoveTextbox()
    if not hasPerms() then return end

    local isComplete, propertyId, dist, zone = Housing.func.findClosestProperty()

    if dist and dist > 50 then
        TriggerEvent('DoLongHudText', 'To far from any property.', 2)
        return
    end

    if propertyId <= 1474 then
        TriggerEvent('DoLongHudText', 'Cannot edit static property.', 2)
        return
    end
    
    local items = {
        { icon = 'pencil-alt', label = 'Street Address (Confirmation)', name = 'street' },
    }

    local textBoxOpen = true
    SetTimeout(120000, function()
        if textBoxOpen then
            exports['np-ui']:closeApplication('textbox')
            exports['np-selector']:deselect()
            TriggerEvent('DoLongHudText', 'Timed out!', 2)
        end
    end)
    local response = exports['np-ui']:OpenInputMenu(items)
    exports['np-ui']:closeApplication('textbox')
    exports['np-selector']:deselect()
    textBoxOpen = false

    if not response or response == nil then return end


    local propertID = 0
    for k,v in pairs(Housing.info) do
        if v.Street == response.street then
            propertID = k
            break
        end
    end

    if propertID ~= 0 then
        local plyCoords = GetEntityCoords(PlayerPedId())
        local checkCoords = vector3(Housing.info[propertID][1].x, Housing.info[propertID][1].y, Housing.info[propertID][1].z)
        if #(checkCoords - plyCoords) > 30.0 then
            TriggerEvent('DoLongHudText', 'To far from property.', 2)
            return
        end

        local listData = RPC.execute("housing:removeProperty", propertID)
        updateList(listData)
    else
        TriggerEvent('DoLongHudText', 'Property Not Found.', 2)
        return
    end

      
end

function openAttatchTextbox()
    if not hasPerms() then return end

    local isComplete, propertyId, dist, zone = Housing.func.findClosestProperty()

    if dist and dist > 50 then
        TriggerEvent('DoLongHudText', 'To far from any property.', 2)
        return
    end

    if propertyId <= 1474 then
        TriggerEvent('DoLongHudText', 'Cannot edit static property.', 2)
        return
    end

    local businessOptions = {
        {['id'] = 'none', ['name'] = 'No Business'},
    }
    local houseOptions = {
        {['id'] = 'none', ['name'] = 'No house'},
        {['id'] = propertyId ,['name'] = Housing.info[propertyId].Street}
    }

    local unk, businesses = RPC.execute("GetBusinesses")
    
    for k, business in pairs(businesses) do
        businessOptions[#businessOptions + 1] = {
            name = business.name,
            id = business.code,
        }
    end

    local items = {
        { _type = 'select', label = 'Property', name = 'propertyObject', options = houseOptions },
        { _type = 'select', label = 'Buisness', name = 'buisness', options = businessOptions },
    }

    local textBoxOpen = true
    SetTimeout(120000, function()
        if textBoxOpen then
            exports['np-ui']:closeApplication('textbox')
            exports['np-selector']:deselect()
            TriggerEvent('DoLongHudText', 'Timed out!', 2)
        end
    end)
    local response = exports['np-ui']:OpenInputMenu(items)
    exports['np-ui']:closeApplication('textbox')
    exports['np-selector']:deselect()
    textBoxOpen = false

    if not response or response == nil then return end

    if propertyId ~= 0 then
        local plyCoords = GetEntityCoords(PlayerPedId())
        local checkCoords = vector3(Housing.info[propertyId][1].x, Housing.info[propertyId][1].y, Housing.info[propertyId][1].z)
        if #(checkCoords - plyCoords) > 30.0 then
            TriggerEvent('DoLongHudText', 'To far from property.', 2)
            return
        end

        RPC.execute("housing:attachBuisness", response.propertyObject,response.buisness)
    else
        TriggerEvent('DoLongHudText', 'Property Not Found.', 2)
        return
    end

      
end


function updateList(listData)
    for k,v in pairs(listData) do
        Housing.info[k] = v

        local zoneName = GetNameOfZone(v[1])

        if Housing.zone[zoneName] == nil then
            Housing.zone[zoneName] = {
                locations = {},
                zoneName = zoneName
            }
        end
        Housing.zone[zoneName].locations[k] = vec3FromVec4(v[1])

    end
end

RegisterNetEvent("housing:updateClientList")
AddEventHandler("housing:updateClientList", function()
    local listData = RPC.execute("housing:getNewestPropertyList")
    updateList(listData)
end)



RegisterCommand("makelocation", function()
    openTextbox()
end)

-- RegisterCommand("lastten", function()
--     for i=(Housing.infoSize-10),Housing.infoSize do
--         print(i,json.encode(Housing.info[i]))
--     end
-- end)
