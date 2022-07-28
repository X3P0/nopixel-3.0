local insidePrison = false

local payphoneModels = {
  `p_phonebox_02_s`,
  `prop_phonebox_03`,
  `prop_phonebox_02`,
  `prop_phonebox_04`,
  `prop_phonebox_01c`,
  `prop_phonebox_01a`,
  `prop_phonebox_01b`,
  `p_phonebox_01b_s`,
}

Citizen.CreateThread(function()
  exports["np-interact"]:AddPeekEntryByModel(payphoneModels, {{
    event = "np-phone:startPayPhoneCall",
    id = "np-phone:startPayPhoneCall",
    icon = "phone-volume",
    label = "Make Call",
    parameters = {},
  },
  {
    event = "np-phone:showTaxiList",
    id = "np-phone:showTaxiList",
    icon = "clipboard-list",
    label = "View Taxis",
    parameters = {},
  }}, {
    distance = { radius = 1.5 },
    isEnabled = function()
      if insidePrison then
        return false
      end
      return true
    end
   })
end)

local entityPayPhoneCoords = nil
AddEventHandler("np-phone:startPayPhoneCall", function(pArgs, pEntity)
  entityPayPhoneCoords = GetEntityCoords(pEntity)
  exports['np-ui']:openApplication('textbox', {
    callbackUrl = 'np-phone:startPayPhoneCallAction',
    key = 1,
    items = {
      {
        icon = "phone-volume",
        label = "Phone Number",
        name = "number",
      },
    },
    show = true,
  })
end)

AddEventHandler("np-phone:showTaxiList", function(pArgs, pEntity)
  local success, drivers = RPC.execute("np-ui:abdultaxi:fetchDrivers")

  local context = {}

  for src, taxi in pairs(drivers) do
    context[#context+1] = {
      icon = "car-side",
      title = taxi.name .. ' ' .. taxi.phoneNumber,
      description = taxi.status,
      key = { phone = taxi.phoneNumber },
      action = "np-phone:startPayPhoneCallAction",
      disabled = taxi.status == 'Busy'
    }
  end

  if #context == 0 then
    context[#context+1] = {
      icon = "clipboard-list",
      title = "No taxis available",
    }
  end

  exports['np-ui']:showContextMenu(context)
end)

AddEventHandler("np-polyzone:enter", function(zone, data)
    if zone == "prison" then insidePrison = true end
end)

AddEventHandler("np-polyzone:exit", function(zone)
    if zone == "prison" then insidePrison = false end
end)

RegisterUICallback("np-phone:startPayPhoneCallAction", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
  exports['np-ui']:closeApplication('textbox')
  local number = data.values and data.values.number or data.key.phone
  RPC.execute("phone:callStart", data.character.number, number, 'PAYPHONE', "Unknown Number")
  Citizen.CreateThread(function()
    while entityPayPhoneCoords do
      if #(GetEntityCoords(PlayerPedId()) - entityPayPhoneCoords) > 2.0 then
        entityPayPhoneCoords = nil
        TriggerEvent("np:fiber:voice-event", 'callEnd')
      end
      Citizen.Wait(500)
    end
  end)
end)
