RegisterUICallback("np-ui:getContacts", function(data, cb)
  local character_id = data.id
  local success, message = RPC.execute("phone:getContacts", character_id)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:addContact", function(data, cb)
  local contact_cid, contact_name, contact_number = data.character.id, data.name, data.number
  local success, message = RPC.execute("phone:addContact", contact_cid, contact_name, contact_number)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:deleteContact", function(data, cb)
  local contact_id = data.id
  local success, message = RPC.execute("phone:deleteContact", contact_id)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)
