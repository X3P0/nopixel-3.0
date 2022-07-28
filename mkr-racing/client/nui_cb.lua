RegisterNUICallback('getConfig', function(data, cb)
  cb({config=config.nui, playerId=GetPlayerServerId(PlayerId())})
end)

RegisterNUICallback('closing', function(data, cb)
  SetNuiFocus(false, false)
  cb({status="ok"})
end)

RegisterNUICallback('customrace', function(data, cb)
  createPendingRace(data.id, data)
  cb({status="ok"})
end)

RegisterNUICallback('previewrace', function(id, cb)
  previewRace(id)
  cb({status="ok"})
end)

RegisterNUICallback('locaterace', function(id, cb)
  locateRace(id)
  cb({status="ok"})
end)
