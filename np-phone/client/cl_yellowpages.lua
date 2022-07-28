RegisterUICallback("np-ui:getYellowPages", function(data, cb)
  local success, message = RPC.execute("phone:getYellowPageEntries")
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:addYellowPagesEntry", function(data, cb)
  local character_id, first_name, last_name, number, text = data.character.id, data.character.first_name, data.character.last_name, data.character.number, data.text
  local success, message = RPC.execute("phone:addYellowPageEntry", character_id, first_name, last_name, number, text)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:deleteYellowPagesEntry", function(data, cb)
  local character_id = data.character.id
  local success, message = RPC.execute("phone:removeYellowPageEntry", character_id)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

-- TODO: Add removal of Yellow Page ad job upon disconnect

RegisterCommand("phone:twatter-receive", function()
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "twatter-receive",
      character = { -- this is sent with the tweet (np-ui:twatSend) so just relay it
        id = 123,
        first_name = "Fuck",
        last_name = "Off"
      },
      text = "Hello you won a prize! Hello you won a prize!Hello you won a prize!Hello you won a prize!Hello you won a prize!Hello you won a prize!Hello you won a prize!Hello you won a prize!Hello you won a prize!Hello you won a prize!Hello you won a prize!"
    }
  });
end, false)