RegisterUICallback("np-ui:heists:getQueue", function(data, cb)
  local results = RPC.execute("np-heists:queue:getQueue")
  local heistLevel = exports['np-heists'].GetHeistLevel()
  results.heistLevel = heistLevel
  cb({ data = results, meta = { ok = true, message = "done" } })
end)

RegisterUICallback("np-ui:heists:getGangs", function(data, cb)
  local results = RPC.execute("np-heists:queue:getGangs")
  cb({ data = results, meta = { ok = true, message = "done" } })
end)

RegisterUICallback("np-ui:heists:queue:alterWeight", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  RPC.execute("np-heists:queue:alterWeight", data)
end)

RegisterUICallback("np-ui:heists:queue:claimHeist", function(data, cb)
  local results = RPC.execute("np-heists:queue:claimHeist", data.id)
  cb({ data = results, meta = { ok = true, message = "done" } })
end)
