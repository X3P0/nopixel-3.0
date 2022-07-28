local Zones = {
    {
        id = "bar:grabDrink",
        center = vector3(1231.38, -419.27, 67.79),
        width = 1.8,
        height = 1,
        options = { heading = 345, minZ = 66.79, maxZ = 68.19, data = { name = 'hoa_bar_1' } }
    },
    {
        id = "bar:grabDrink",
        center = vector3(1230.78, -421.21, 67.79),
        width = 1.8,
        height = 1,
        options = { heading = 345, minZ = 66.79, maxZ = 68.19, data = { name = 'hoa_bar_2' } }
    },
    {
        id = "tbar:chargeCustomer",
        center = vector3(1151.41, -411.59, 72.25),
        width = 0.6,
        height = 1.0,
        options = { heading = 344, minZ = 72.05, maxZ = 72.65, data = { name = 'hoa_register' } }
    },
    {
        id = "tbar:getBag",
        center = vector3(1149.8, -407.94, 72.25),
        width = 1.2,
        height = 0.8,
        options = { heading = 324, minZ = 71.35, maxZ = 72.15, data = { name = 'hoa_bag' } }
    },
    {
        id = "tbar:craftToxicMenu",
        center = vector3(1227.1, -420.78, 67.77),
        width = 0.2,
        height = 1.0,
        options = { heading = 345, minZ = 67.77, maxZ = 68.77, data = { name = 'hoa_toxic' } }
    },
}

Citizen.CreateThread(function()
    for _, zone in ipairs(Zones) do
        exports["np-polytarget"]:AddBoxZone(zone.id, zone.center, zone.width, zone.height, zone.options)
    end

    -- Fridge
    exports["np-polytarget"]:AddBoxZone("tavern_drinks", vector3(1150.77, -406.71, 72.25), 0.4, 1.6, {
      heading = 75,
      minZ = 71.25,
      maxZ = 73.25,
      data = {
        id = "tavern_drinks",
      }
    })
    exports['np-interact']:AddPeekEntryByPolyTarget("tavern_drinks", {{
      event = "np-business:client:openTavernDrinks",
      id = "tavernDrinks",
      icon = "circle",
      label = "Open Fridge",
      parameters = { action = "openFridge" },
    }}, { distance = { radius = 3.5 }  })
end)

RegisterUICallback("np-ui:tavern:charge", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')
  local id = tonumber(data.values.state_id)
  local cost = tonumber(data.values.cost)
  local comment = data.values.comment
  data.state_id = id
  data.amount = cost
  data.comment = comment
  data.business = {
    code = "tavern",
  }
  RPC.execute("ChargeExternal", data)
end)

AddEventHandler('np-tavern:peekAction', function(pArgs, pEntity, pContext)
	if not pArgs.action then return end

	local zoneName = ('bar:%s'):format(pArgs.action)

	local data = pContext.zones[zoneName]

	if pArgs.action == 'chargeCustomer' then
    exports['np-ui']:openApplication('textbox', {
        callbackUrl = 'np-ui:tavern:charge',
        key = "tavern_register",
        items = {
          {
            icon = "user",
            label = "State ID",
            name = "state_id",
          },
          {
            icon = "dollar-sign",
            label = "Cost",
            name = "cost",
          },
          {
            icon = "pencil-alt",
            label = "Comment",
            name = "comment",
          },
        },
        show = true,
    })
  elseif pArgs.action == 'getBag' then
    local genId = tostring(math.random(10000, 99999999))
    local invId = "container-" .. genId .. "-brown-bag"
    local metaData = json.encode({
        inventoryId = invId,
        slots = 1,
        weight = 1,
        _hideKeys = {'inventoryId', 'slots', 'weight'},
    })
    TriggerEvent('player:receiveItem', 'foodbag', 1, false, {}, metaData)
  elseif pArgs.action == 'craftToxicMenu' then
    exports['np-ui']:openApplication('textbox', {
      callbackUrl = 'np-ui:tavernCreateItem',
      key = 1,
      items = {
        {
          icon = "biohazard",
          label = "Potency",
          name = "potency",
        },
        {
          icon = "user-clock",
          label = "Interval (seconds)",
          name = "interval",
        },
        {
          icon = "flag-checkered",
          label = "Ticks",
          name = "duration",
        },
        {
          _type = "checkbox",
          label = "Non-lethal",
          name = "nonLethal",
        },
      },
      show = true,
    })
	end
end)

local itemRecipes = {
  ["poisonedcocktail"] = { "moonshine", "drink2" },
  ["poisonedsandwich"] = { "moonshine", "sandwich" },
  ["poisonedwater"] = { "moonshine", "water" },
}

RegisterUICallback("np-ui:tavernCreateItem", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  exports['np-ui']:closeApplication('textbox')
  local potency = tonumber(data.values.potency)
  local interval = tonumber(data.values.interval)
  local duration = tonumber(data.values.duration)
  local nonLethal = data.values.nonLethal
  TriggerServerEvent("np-tavern:poisonItems", potency, interval, duration, nonLethal)
end)

AddEventHandler("np-business:client:openTavernDrinks", function()
  local hasAccess = exports["np-business"]:HasPermission("tavern", "craft_access")

  if not hasAccess then
    return TriggerEvent("DoLongHudText", "Sorry you can't use this.", 2)
  end

  TriggerEvent("server-inventory-open", "42134", "Craft")
end)
