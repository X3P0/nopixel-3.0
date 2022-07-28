RegisterUICallback("np-ui:createBusiness", function(data, cb)
  local success, message = RPC.execute("CreateBusiness", data)
  cb({ data = {}, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:getBusinessTypes", function(data, cb)
  local success, message = RPC.execute("GetBusinessTypes")
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:getBusinesses", function(data, cb)
  local success, message = RPC.execute("GetBusinesses")
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:getEmploymentInformation", function(data, cb)
  local success, message = RPC.execute("GetEmploymentInformation", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:getBusinessEmployees", function(data, cb)
  local success, message = RPC.execute("GetBusinessEmployees", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:getBusinessRoles", function(data, cb)
  local success, message = RPC.execute("GetBusinessRoles", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:createBusinessRole", function(data, cb)
  local success, message = RPC.execute("CreateBusinessRole", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:changeBusinessRole", function(data, cb)
  local success, message = RPC.execute("ChangeBusinessRole", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:hireBusinessEmployee", function(data, cb)
  local success, message = RPC.execute("HireBusinessEmployee", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:editBusinessRole", function(data, cb)
  local success, message = RPC.execute("EditBusinessRole", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:deleteBusinessRole", function(data, cb)
  local success, message = RPC.execute("DeleteBusinessRole", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:removeBusinessEmployee", function(data, cb)
  local success, message = RPC.execute("RemoveBusinessEmployee", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:businessPayEmployee", function(data, cb)
  local success, message = RPC.execute("BusinessPayEmployee", data)
  cb({ data = message or {}, meta = { ok = success, message = message or "Unknown Error; check account balance" } })
end)

RegisterUICallback("np-ui:businessPayExternal", function(data, cb)
  local success, message = RPC.execute("BusinessPayExternal", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:businessChargeExternal", function(data, cb)
  RPC.execute("ChargeExternal", data)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:businessChargeAccept", function(data, cb)
  local success, message = RPC.execute("BusinessChargeAccept", data)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:businessChargeReject", function(data, cb)
  local success, message = RPC.execute("BusinessChargeAccept", data, true)
  cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:businessGetLogs", function(data, cb)
    local success, message = RPC.execute("np-business:getLogs", data, true)
    cb({ data = message, meta = { ok = success, message = message } })
end)

RegisterNetEvent("business:chargeAcceptPrompt")
AddEventHandler("business:chargeAcceptPrompt", function(data)
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "charge-accept",
      data = data,
    },
  })
end)

AddEventHandler("np-business:collectAirXParachute", function()
  local employed = IsEmployedAt("flight_school")
  if not employed then
    TriggerEvent("DoLongHudText", "He does not recognize you", 2)
    return
  end
  TriggerEvent("player:receiveItem", "airxchute", 1)
end)

AddEventHandler("np-business:purchaseHandler", function(pParameters, pEntity, pContext)
  RPC.execute("np-business:purchaseHandler", pParameters.price, pParameters.item_id, pParameters.amount)
end)
