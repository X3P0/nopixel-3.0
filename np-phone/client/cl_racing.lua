local function getAlias(alias, character)
  if alias ~= nil then return alias end
  return character.first_name .. " " .. character.last_name
end

RegisterUICallback("np-ui:racingGetAllRaces", function(data, cb)
  local res = exports["mkr-racing"]:getAllRaces()
  local completed = RPC.execute("mkr_racing:getFinishedRaces")
  res.completed = completed
  cb({ data = res, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingGetEventConversation", function(data, cb)
  local res = RPC.execute("np-racing:getEventConversation", data.eventId)
  cb({ data = res.data, meta = { ok = res.success, message = res.message or 'done' } })
end)

RegisterUICallback("np-ui:racingSendMessage", function(data, cb)
  local success, message = RPC.execute("np-racing:sendEventMessage", data.characterId, data.alias, data.eventId, data.message)
  cb({ data = res, meta = { ok = success, message = message or 'done' } })
end)

RegisterUICallback("np-ui:racingPreviewRace", function(data, cb)
  exports["mkr-racing"]:previewRace(data.id)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingLocateRace", function(data, cb)
  exports["mkr-racing"]:locateRace(data.id, data.eventId, data.race.reverse)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingNotifyRacers", function(data, cb)
  local success, message = RPC.execute("np-racing:notifyRacers", data.alias, data.message, data.playerIds)
  cb({ data = {}, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:racingCreateRace", function(data, cb)
  data.options.characterId = data.character.id
  data.options.alias = getAlias(data.options.alias, data.character)

  -- Hard-coded options
  data.options.lineBasedCheckpoints = true

  local err = exports["mkr-racing"]:createPendingRace(data.id, data.options)
  if err ~= nil then
    cb({ data = res, meta = { ok = false, message = err } })
    return
  end
  cb({ data = res, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingDeleteRace", function(data, cb)
  local success = false
  local message = "Failed to delete race"
  if data.id then
    success = RPC.execute('mkr_racing:deleteRace', data.id)
    if success then message = "" end
  end
  cb({ data = res, meta = { ok = success, message = message } })
end)

RegisterUICallback("np-ui:racingJoinRace", function(data, cb)
  local canJoinOrErr = exports["np-racing"]:canJoinOrStartRace(data.race.vehicleClass)
  if canJoinOrErr ~= true then
    cb({ data = {}, meta = { ok = false, message = canJoinOrErr } })
    return
  end
  local err = exports["mkr-racing"]:joinRace(data.race.eventId, getAlias(data.alias, data.character), data.character.id)
  if err ~= nil then
    cb({ data = res, meta = { ok = false, message = err } })
    return
  end
  Wait(500)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingStartRace", function(data, cb)
  local canJoinOrErr = exports["np-racing"]:canJoinOrStartRace(data.race.vehicleClass)
  if canJoinOrErr ~= true then
    cb({ data = {}, meta = { ok = false, message = canJoinOrErr } })
    return
  end
  local err = exports["mkr-racing"]:startRace(data.race.countdown)
  if err ~= nil then
    cb({ data = res, meta = { ok = false, message = err } })
    return
  end
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingLeaveRace", function(data, cb)
  exports["mkr-racing"]:leaveRace()
  Wait(500)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingEndRace", function(data, cb)
  exports["mkr-racing"]:endRace()
  Wait(500)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingKickFromRace", function(data, cb)
  RPC.execute("mkr_racing:kickFromRace", data.raceId, data.playerId)
  Wait(500)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingBanFromRace", function(data, cb)
  RPC.execute("mkr_racing:banFromRace", data.raceId, data.playerId)
  Wait(500)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingCreateMap", function(data, cb)
  local canCreate, errorMessage = RPC.execute("np-racing:canCreateNewRace", data)
  if not canCreate then
    cb({ data = {}, meta = { ok = false, message = errorMessage } })
    return
  end
  local ped = PlayerPedId()
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
    TriggerEvent("mkr_racing:cmd:racecreate", data)
    cb({ data = {}, meta = { ok = true, message = 'done' } })
    exports["np-ui"]:closeApplication("phone")
  else
    cb({ data = {}, meta = { ok = false, message = 'You are not driving a vehicle' } })
  end
end)

RegisterUICallback("np-ui:racingFinishMap", function(data, cb)
  TriggerEvent("mkr_racing:cmd:racecreatedone")
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingCancelMap", function(data, cb)
  TriggerEvent("mkr_racing:cmd:racecreatecancel")
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingBestLapTimes", function(data, cb)
  local bestLapTimes = RPC.execute("mkr_racing:bestLapTimes", data.id, data.vehicleClass, 10)
  local bestLapTimesForAlias = RPC.execute("mkr_racing:bestLapTimesForAlias", data.id, exports["isPed"]:isPed("cid"), data.alias, data.vehicleClass, 1)
  local bestLapTimeForAlias = bestLapTimesForAlias ~= nil and bestLapTimesForAlias[1] or nil
  cb({ data = { bestLapTimes = bestLapTimes, bestLapTimeForAlias = bestLapTimeForAlias }, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingSetNightTime", function(data, cb)
  exports["np-ui"]:sendAppEvent("phone", {
    action = "racing-night-time",
    isNightTime = exports["np-weathersync"]:isNightTime(),
  })
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingGetAllTournaments", function(data, cb)
  local res = exports["mkr-racing"]:getAllTournaments()
  cb({ data = res, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingCreateTournament", function(data, cb)
  local err = RPC.execute("mkr_racing:createTournament", data.options.name, getAlias(data.options.alias, data.character))
  if err then
    cb({ data = nil, meta = { ok = false, message = err } })
    return
  end
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingJoinTournament", function(data, cb)
  local err = RPC.execute("mkr_racing:joinTournament", data.tournament.name, getAlias(data.alias, data.character), data.character.id)
  if err ~= nil then
    cb({ data = res, meta = { ok = false, message = err } })
    return
  end
  Wait(500)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingLeaveTournament", function(data, cb)
  RPC.execute("mkr_racing:leaveTournament", data.character.id)
  Wait(500)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingEndTournament", function(data, cb)
  RPC.execute("mkr_racing:endTournament", data.tournament.name)
  Wait(500)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:racingGiveDongle", function(data, cb)
  local err = RPC.execute("np-racing:giveRaceDongle", data.options.characterId)
  if err ~= nil then
    cb({ data = res, meta = { ok = false, message = err } })
    return
  end
  Wait(500)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)


AddEventHandler("mkr_racing:api:startingRace", function(startTime)
  TriggerEvent('DoLongHudText', "Starting in " .. tostring(startTime / 1000) .. " seconds", 1, 12000, { i18n = { "Starting in", "seconds" } })
end)

AddEventHandler("mkr_racing:api:updatedState", function(state)
  local data = {action = "racing-update"}
  if state.finishedRaces then data.completed = state.finishedRaces end
  if state.races then data.maps = state.races end
  if state.pendingRaces then data.pending = state.pendingRaces end
  if state.activeRaces then data.active = state.activeRaces end
  if state.tournaments then data.tournaments = state.tournaments end
  exports["np-ui"]:sendAppEvent("phone", data)
end)

function TriggerPhoneNotification(title, body)
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "notification",
      target_app = "racing",
      title = title,
      body = body,
      show_even_if_app_active = true
    }
  })
end

AddEventHandler("mkr_racing:api:addedPendingRace", function(race)
  if not race.sendNotification then return end
  local hasRaceUsbAndAlias = exports["np-racing"]:getHasRaceUsbAndAlias()
  if not hasRaceUsbAndAlias.has_usb_racing or not hasRaceUsbAndAlias.racingAlias then return end
  exports["np-ui"]:sendAppEvent("phone", {
    action = "racing-new-event",
    title = "From the PM",
    text = "Pending race available...",
  })
end)

AddEventHandler("mkr_racing:api:playerJoinedYourRace", function(characterId, name)
  TriggerPhoneNotification("Race Join", name .. " joined your race")
end)

AddEventHandler("mkr_racing:api:playerLeftYourRace", function(characterId, name)
  TriggerPhoneNotification("Race Leave", name .. " left your race")
end)
