RegisterUICallback("np-ui:getDocuments", function(data, cb)
  local character_id, document_type_id = data.character.id, data.type_id

  local success, message = false, {}
  if document_type_id == 2 then
    success, message = RPC.execute("phone:getLicenses", character_id)
  elseif document_type_id == 4 then
    success, message = true, RPC.execute("np:vehicles:getVehicleIds", character_id)
  else
    success, message = RPC.execute("phone:getDocuments", character_id, document_type_id)
  end
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:getDocumentContent", function(data, cb)
  local document_id, document_type_id = data.document.id, data.document.type_id

  local success, message = false, {}
  if document_type_id == 2 then
    success, message = RPC.execute("phone:getLicenseContent", document_id)
  elseif document_type_id == 4 then
    success, message = true, RPC.execute("np:vehicles:getRegistrationDocument", document_id)
  else
    success, message = RPC.execute("phone:getDocumentContent", document_id)
  end

  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:getDocumentTypes", function(data, cb)
  local success, message = RPC.execute("phone:getDocumentTypes")
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:editDocument", function(data, cb)
  local document_id, document_title, document_content = data.document.id, data.document.title, data.document.content
  local success, message = RPC.execute("phone:editDocument", document_id, document_content, document_title)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:createDocument", function(data, cb)
  local character_id, document_title, document_content, document_type_id = data.character.id, data.document.title, data.document.content, data.type_id
  local success, message = RPC.execute("phone:createDocument", character_id, document_content, document_title, document_type_id)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:deleteDocument", function(data, cb)
  local character_id, document_id = data.character.id, data.document.id
  local success, message = RPC.execute("phone:deleteDocument", document_id, character_id)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:finalizeDocument", function(data, cb)
  local document_id = data.document.id
  local success, message = RPC.execute("phone:finalizeDocument", document_id)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:dropDocument", function(data, cb)
  local location = GetEntityCoords(PlayerPedId())
  if data.document and data.document.content then
    data.document.content = ""
  end
  local success, message = RPC.execute("phone:dropDocument", data, location)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:startEditDocument", function(data, cb)
  if data.document and data.document.content then
    data.document.content = ""
  end
  local success, message = RPC.execute("phone:documentUnlock", data)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:getDocumentSignatures", function(data, cb)
  local document_id, document_type_id = data.document.id, data.document.type_id

  local success, message = false, {}
  if document_type_id == 2 then
    success, message = RPC.execute("GetLicenseIssuer", document_id)
  else
    success, message = RPC.execute("phone:getDocumentSignatures", document_id)
  end

  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:signDocument", function(data, cb)
  if data.document and data.document.content then
    data.document.content = ""
  end
  local success, message = RPC.execute("phone:signDocument", data)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:requestDocumentSignature", function(data, cb)
  if data.document and data.document.content then
    data.document.content = ""
  end
  local success, message = RPC.execute("phone:requestDocumentSignature", data)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:shareDocumentLocal", function(data, cb)
  local id, typeId = data.document.id, data.document.type_id
  RPC.execute("phone:shareDocumentLocal", id, typeId)
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)

RegisterUICallback("np-ui:shareDocumentPermanent", function(data, cb)
  if data.document and data.document.content then
    data.document.content = ""
  end
  local success, message = RPC.execute("phone:shareDocumentPermanent", data)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterNetEvent("np-phone:showDocumentLocal")
AddEventHandler("np-phone:showDocumentLocal", function(pTriggerer, pId, pTypeId)
  if GetPlayerServerId(PlayerId()) ~= pTriggerer then
    SendUIMessage({
      source = "np-nui",
      app = "phone",
      data = {
        action = "view-document",
        id = pId,
        type_id = pTypeId,
      },
    })
  end
end)
