local InDropOffLocation = false

RegisterUICallback("np-ui:repoSeizeVehicle", function(data, cb)
    local loan = data.key

    cb({ data = {}, meta = { ok = true, message = "done" } })

    VehicleSeizureMenu(loan.characterId, loan.id)
end)

RegisterUICallback("np-ui:repoSeizeProperty", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)

RegisterUICallback("np-ui:repoFetchAssetLocation", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })

    local info = data.key

    local location = RPC.execute('np-business:repo:fetchAssetLocation', info.type, info.data)

    if not location then
        return TriggerEvent('DoLongHudText', 'Unable to locate vehicle.', 2)
    end

    SetNewWaypoint(location.coords.x, location.coords.y)

    TriggerEvent('DoLongHudText',"GPS updated.")
end)

RegisterUICallback("np-ui:repoRecoverAsset", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })

    local info = data.key

    local location = RPC.execute('np-business:repo:fetchAssetLocation', info.type, info.data)

    if not location then
        return TriggerEvent('DoLongHudText', 'Unable to locate vehicle.', 2)
    end

    if info.type == 'vehicle' then
        local garage = exports['np-vehicles']:GetCurrentGarage()

        if garage ~= location.garage then
            return TriggerEvent('DoLongHudText', 'This is not the correct garage.', 2)
        end

        local isOnSpot, parkingSpot = table.unpack(exports['np-vehicles']:FindParkingSpot(PlayerPedId(), true, 4.5))

        if not isOnSpot then
            return TriggerEvent('DoLongHudText', 'Empty parking spot required.', 2)
        end

        info.data.parking = { garage = garage, spot = parkingSpot.id, type = parkingSpot.type }
    end

    local success = RPC.execute('np-business:repo:recoverAsset', info.type, info.data)

    TriggerEvent('DoLongHudText', not success and 'Asset not found here.' or 'Asset recovered successfully.', not success and 2 or 1)
end)

RegisterUICallback("np-ui:repoSeizeAsset", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })

    local info = data.key

    local vehicle = exports['np-target']:GetCurrentEntity()

    if not vehicle or vehicle == 0 then
        return TriggerEvent('DoLongHudText', 'Vehicle not found.', 2)
    end

    local vin = exports['np-vehicles']:GetVehicleIdentifier(vehicle)

    if not vin or vin ~= info.data.vin then
        return TriggerEvent('DoLongHudText', 'This is not the correct vehicle.', 2)
    end

    local success = RPC.execute('np-business:repo:seizeAsset', info.type, info.data)

    TriggerEvent('DoLongHudText', not success and 'Failed to seize asset.' or 'Asset was seized successfully.', not success and 2 or 1)
end)

RegisterUICallback("np-ui:repoGenerateOrder", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })

    local info = data.key

    Citizen.Wait(500)

    local elements = {
        { name = "reason", label = "Repossession Reason", icon = "scroll" }
    }

    local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return type(values.reason) == 'string' and string.len(values.reason) >= 5
    end)

    if (not prompt or not prompt.reason) then return end

    RPC.execute('np-business:repoGenerateOrder', info.plate, info.vin, prompt.reason, info.loanId)
end)

AddEventHandler('np-inventory:itemUsed', function(itemId, itemInfo)
    if (itemId ~= 'vehicle_repo_order') then return end

    local data = json.decode(itemInfo)
    local repoType = itemId == 'vehicle_repo_order' and 'vehicle' or 'property'

    RepoOrderMenu(repoType, data)
end)

AddEventHandler("np-polyzone:enter", function(name, data)
    if name ~= "np-jobs:impound:dropOff" then return end

    InDropOffLocation = true
end)

AddEventHandler("np-polyzone:exit", function(name, data)
    if name ~= "np-jobs:impound:dropOff" then return end

    InDropOffLocation = false
end)

function RepoOrderMenu(pType, pData)
    local information = ''

    local garage = exports['np-vehicles']:GetCurrentGarage()

    if pType == 'vehicle' then
        information = ('Issuer: %s | Plate: %s'):format(pData.issuer, pData.plate)
    elseif pType == 'property' then
        information = ('Issuer: %s | Property: %s'):format(pData.issuer, pData.propertyName)
    end

    local elements = {
        {
            title = 'Repossession Information',
            description = information,
            children = {}
        },
        {
            title = 'Repossession Reason',
            description = ('Reason: %s'):format(pData.reason)
        },
        {
            title = 'Locate Asset',
            description = '',
            action = "np-ui:repoFetchAssetLocation",
            key = { type = pType, data = pData },
            children = {}
        }
    }

    if pType == 'vehicle' then
        if InDropOffLocation then 
            elements[#elements+1] = {
                title = 'Repossess Asset',
                description = '',
                action = "np-ui:repoSeizeAsset",
                key = { type = pType, data = pData },
            }
        else
            elements[#elements+1] = {
                title = 'Recover Asset',
                description = '',
                action = "np-ui:repoRecoverAsset",
                disabled = garage == nil,
                key = { type = pType, data = pData },
            }
        end
    end
    
    exports['np-ui']:showContextMenu(elements)
end

function VehicleSeizureMenu(pCharacterId, pLoanId)
    local data = RPC.execute("np:vehicles:getPlayerVehiclesByCharacterId", pCharacterId)

    print(json.encode(data))

    local elements = {}

    for _, vehicle in ipairs(data) do
        local hidden = vehicle.vinScratched or vehicle.fakePlate

        local element = {
            title = vehicle.name,
            description = ('Plate: %s | State: %s'):format(vehicle.plate, not hidden and vehicle.parking_state or 'Unknown'),
            disabled = hidden,
            children = {
                {
                    title = 'Locate Vehicle',
                    description = '',
                    action = "np-ui:repoFetchAssetLocation",
                    key = { type = 'vehicle', data = vehicle }
                },
                {
                    title = 'Generate Repossession Order',
                    description = '',
                    action = "np-ui:repoGenerateOrder",
                    key = { plate = vehicle.plate, vin = vehicle.vin, loanId = pLoanId }
                },
            }
        }

        elements[#elements+1] = element
    end

    exports['np-ui']:showContextMenu(elements)
end

