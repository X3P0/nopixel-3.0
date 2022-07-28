RegisterUICallback("np-ui:getLicenses", function(data, cb)
  local character_id = data.character.id
  local success, message = RPC.execute("GetActiveLicenses", character_id)
  cb({ data = message, meta = { ok = success, message = 'done' }})
end)
RegisterUICallback("np-ui:getAllLicenses", function(data, cb)
  local success, message = RPC.execute("GetAllLicenses")
  cb({ data = message, meta = { ok = success, message = 'done' }})
end)

RegisterUICallback("np-ui:getCharacterPermissions", function(data, cb)
  local success, message = RPC.execute("GetStateAccess")
  cb({ data = message, meta = { ok = success, message = 'done' }})
end)

RegisterUICallback("np-ui:getStateCharacterDetails", function(data, cb)
  local success, message = RPC.execute("GetCharacterDetails", data)
  cb({ data = message, meta = { ok = success, message = 'done' }})
end)

RegisterUICallback("np-ui:revokeLicense", function(data, cb)
  local license, target_id, character_id = data.license.name, data.target_id, data.character.id
  local success, message = RPC.execute("RevokeLicense", license, target_id, character_id)
  cb({ data = message, meta = { ok = success, message = 'done' }})
end)

RegisterUICallback("np-ui:grantLicense", function(data, cb)
  local license, target_id, character_id = data.license.id, data.target_id, data.character.id
  local success, message = RPC.execute("GrantLicense", target_id, license, character_id)
  cb({ data = message, meta = { ok = success, message = 'done' }})
end)
