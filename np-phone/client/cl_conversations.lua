RegisterUICallback("np-ui:smsSend", function(data, cb)
  local number_from, number_to, source_number ,text_message = data.character.number, data.number,data.source_number, data.message
  
  local success, message
  if source_number ~= nil then
    success, message = RPC.execute("phone:sendMessage", source_number, number_to, text_message)
  else
    success, message = RPC.execute("phone:sendMessage", number_from, number_to, text_message)
  end
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:getMessages", function(data, cb)
  local number, target_number , source_number = data.character.number, data.target_number ,data.source_number
  local success, message
  if source_number ~= nil then
    success, message = RPC.execute("phone:getMessages", source_number, target_number)
  else
    success, message = RPC.execute("phone:getMessages", number, target_number)
  end
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:getConversations", function(data, cb)
  local number, source_number = data.character.number ,data.source_number
  local success, message
  if source_number ~= nil then
    success, message = RPC.execute("phone:getConversations", source_number)
  else
    success, message = RPC.execute("phone:getConversations", number)
  end
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)


RegisterNetEvent("phone:sms:receive")
AddEventHandler("phone:sms:receive", function(pNumber, pMessage)
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "sms-receive",
      number = pNumber,
      message = pMessage
    }
  })
end)

RegisterNetEvent("burner:sms:receive")
AddEventHandler("burner:sms:receive", function(pNumber, pMessage)
  SendUIMessage({
    source = "np-nui",
    app = "burner",
    data = {
      action = "sms-receive",
      number = pNumber,
      message = pMessage
    }
  })
end)

AddEventHandler("phone:readPlayerconversations", function(pServerId)
  local success, pPhoneNumber
  -- print(variable1 .. variable2)
  if pServerId ~= nil then
    success, pPhoneNumber = RPC.execute("phone:readPlayerconversations", pServerId)
    if success then
      LoadAnimDict("cellphone@")
      TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
      TriggerEvent("attachItemPhone", "phone01")
      exports["np-ui"]:openApplication("burner", { source_number  = pPhoneNumber, isOwner = false })
    end
  end
end)

