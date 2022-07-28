SIGNED_IN = false
CURRENT_RESTAURANT = nil
SERVER_CODE = 'wl'

local activePurchases = {}

local debugMode = GetConvar('sv_environment', 'prod') == 'debug'

function isSignedOn()
    return SIGNED_IN or CURRENT_RESTAURANT == 'prison_cooks'
end

function signOff()
    SIGNED_IN = false
    TriggerEvent("DoLongHudText", _L("restaurant-clocked-out", "Clocked out."))
end

AddEventHandler('np-restaurants:signOnPrompt', function(pParameters, pEntity, pContext)
    local biz = pContext.zones['restaurant_sign_on'].biz
    local type = pContext.zones['restaurant_sign_on'].type
    SIGNED_IN, langString, message = RPC.execute("np-restaurants:joinJob", biz, type)
    TriggerEvent("DoLongHudText", _L(langString, message))
end)

AddEventHandler('np-restaurants:signOffPrompt', function(pParameters, pEntity, pContext)
    local biz = pContext.zones['restaurant_sign_on'].biz
    RPC.execute("np-restaurants:leaveJob", biz)
    signOff()
end)

RegisterNetEvent('np-restaurants:forceLeaveJob', function()
    signOff()
end)

AddEventHandler('np-restaurants:viewActiveEmployees', function(pParameters, pEntity, pContext)
    local biz = pContext.zones['restaurant_sign_on'].biz
    local employees = RPC.execute('np-restaurants:getActiveEmployees', biz)

    local mappedEmployees = {}

    for _, employee in pairs(employees) do
        local fancyLocationName = GetBusinessConfig(biz).name
        table.insert(mappedEmployees, {
            title = string.format("%s (%s)", employee.name, employee.cid),
            description = string.format(_L("restaurant-clocked-in-at", "Clocked in at %s"), fancyLocationName),
        })
    end
    if #mappedEmployees == 0 then
        table.insert(mappedEmployees, {
            title = _L("restaurant-no-active-employees", "Nobody is clocked in currently"),
        })
    end

    exports['np-ui']:showContextMenu(mappedEmployees)
end)

AddEventHandler('np-restaurants:makePayment', function(pParameters, pEntity, pContext)
    local id, biz
    local isNotRestaurant = false

    if pParameters and pParameters.isEditorPeek then
        id = exports["np-housing"]:getOwnerOfCurrentProperty()
        biz = exports["np-housing"]:getCurrentPropertyID()
        isNotRestaurant = true
    else
        id = pContext.zones['restaurant_registers'].id
        biz = pContext.zones['restaurant_registers'].biz
    end

    if id == nil or biz == nil then return end

    local activeRegisterId = id
    local activeRegister = activePurchases[activeRegisterId]
    if not activeRegister or activeRegister == nil then
        TriggerEvent("DoLongHudText", _L("restaurant-no-active-purchase", "No purchase active."))
        return
    end
    local priceWithTax = RPC.execute("PriceWithTaxString", activeRegister.cost, "Goods")
    local acceptContext = {
        {
            i18nTitle = true,
            title = _L("restaurant-make-payment", "Register Purchase"),
            description = "$" .. priceWithTax.text .. " | " .. activeRegister.comment,
        },
        {
            i18nTitle = true,
            title = _L("restaurant-accept-purchase", "Purchase with Bank"),
            action = "np-restaurants:finishPurchasePrompt",
            icon = 'credit-card',
            key = {cost = activeRegister.cost, comment = activeRegister.comment, registerId = id, charger = activeRegister.charger, biz = biz, cash = false, isNotRestaurant = isNotRestaurant},
        },
        {
            i18nTitle = true,
            title = _L("restaurant-cash-purchase", "Purchase with Cash"),
            action = "np-restaurants:finishPurchasePrompt",
            icon = 'money-bill',
            key = {cost = activeRegister.cost, comment = activeRegister.comment, registerId = id, charger = activeRegister.charger, biz = biz, cash = true, isNotRestaurant = isNotRestaurant},
        }
    }
    exports['np-ui']:showContextMenu(acceptContext)
end)

RegisterUICallback('np-restaurants:finishPurchasePrompt', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    local success = RPC.execute("np-restaurants:completePurchase", data.key)
    if not success then
        TriggerEvent("DoLongHudText", _L("restaurant-could-not-complete-purchase", "The purchase could not be completed."))
    end
end)

AddEventHandler('np-restaurants:chargeCustomer', function(pParameters, pEntity, pContext)
    local id, biz

    if pParameters.isEditorPeek then
        id = exports["np-housing"]:getOwnerOfCurrentProperty()
        biz = exports["np-housing"]:getCurrentPropertyID()
    else
        id = pContext.zones['restaurant_registers'].id
        biz = pContext.zones['restaurant_registers'].biz
    end

    if id == nil or biz == nil then return end

    local elements = {
     {
            icon = "dollar-sign",
            label = _L("restaurant-cost", "Cost"),
            name = "cost",
        },
        {
            icon = "pencil-alt",
            label = _L("restaurant-comment", "Comment"),
            name = "comment",
        },
    }

    local prompt = exports['np-ui']:OpenInputMenu(elements)

    if not prompt then return end

    local cost = tonumber(prompt.cost)
    local comment = prompt.comment
    --check if cost is actually a number
    if cost == nil or not cost then return end
    if comment == nil then comment = "" end

    if cost < 5 then cost = 5 end --Minimum $10

    --Send event to everyone indicating a purchase is ready at specified register
    RPC.execute("np-restaurants:startPurchase", {cost = cost, comment = comment, registerId = id})
end)

RegisterNetEvent('np-restaurants:activePurchase', function(data)
    activePurchases[data.registerId] = data
end)

RegisterNetEvent('np-restaurants:closePurchase', function(data)
    activePurchases[data.registerId] = nil
end)

AddEventHandler('np-polyzone:enter', function(pZone, pData)
    if pZone == 'restaurant_buff_zone' then
        CURRENT_RESTAURANT = pData.id
        TriggerEvent("np-buffs:inDoubleBuffZone", true, pData.id)
        checkForHeadset()
    end

    if pZone == 'restaurant_bs_drivethru' then
        enterDriveThru()
    end
end)

AddEventHandler('np-polyzone:exit', function(pZone, pData)
    if pZone == 'restaurant_buff_zone' then
        if SIGNED_IN then
            SIGNED_IN = false
            RPC.execute("np-restaurants:leaveJob", CURRENT_RESTAURANT)
            TriggerEvent("DoLongHudText", _L("restaurant-clocked-out-distance", "You went too far away! Clocked out."))
        end
        CURRENT_RESTAURANT = nil
        TriggerEvent("np-buffs:inDoubleBuffZone", false)
        turnOffHeadset()
    end

    if pZone == 'restaurant_bs_drivethru' then
        exitDriveThru()
    end
end)

AddEventHandler("np-restaurants:silentAlarm", function()
    local finished = exports["np-taskbar"]:taskBar(4000, _L("foodchain-pressing-alarm", "Pressing Alarm"))
    if finished ~= 100 then return end
    TriggerServerEvent("np-restaurants:triggerSilentAlarm", GetEntityCoords(PlayerPedId()))
end)
