RegisterUICallback("np-ui:getBallots", function(data, cb)
  local success, message = RPC.execute("GetBallotsHistory")
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:createBallot", function(data, cb)
  local name, description, multi, start_date, end_date = data.name, data.description, data.multi, data.start_date, data.end_date
  local success, message = RPC.execute("CreateBallot", name, description, multi, start_date, end_date)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:editBallot", function(data, cb)
  local id, name, description, multi, start_date, end_date = data.id, data.name, data.description, data.multi, data.start_date, data.end_date
  local success, message = RPC.execute("EditBallot", id, name, description, multi, start_date, end_date)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:deleteBallot", function(data, cb)
  local id = data.id
  local success, message = RPC.execute("DeleteBallot", id)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:addBallotOption", function(data, cb)
  local ballot_id, name, description, icon, party = data.ballot_id, data.name, data.description, data.icon, data.party
  local success, message = RPC.execute("CreateBallotOption", ballot_id, name, description, icon, party)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:deleteBallotOption", function(data, cb)
  local id = data.id
  local success, message = RPC.execute("DeleteBallotOption", id)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:getCurrentBallotOptions", function(data, cb)
  local success, message = RPC.execute("GetBallots")
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:submitBallotChoices", function(data, cb)
  local choices = data.choices
  local success, message = RPC.execute("SubmitBallotResult", choices)
  if success then
    TriggerEvent("player:receiveItem", "ivotedsticker", 1)
  end
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)
