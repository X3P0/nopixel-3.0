local phoneItems = {"mobilephone", "stoleniphone", "stolennokia", "stolenpixel3", "stolens8", "boomerphone"}
RegisterNetEvent("phone:twatter:receive")
AddEventHandler("phone:twatter:receive", function(pTwat)
  local hasPhone = false
  for _,itemId in ipairs(phoneItems) do
    hasPhone = exports['np-inventory']:hasEnoughOfItem(itemId, 1, false, true) or hasPhone
  end
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "twatter-receive",
      character = pTwat.character,
      timestamp = pTwat.timestamp,
      text = pTwat.text,
      hasPhone = hasPhone
    }
  })
end)

RegisterUICallback("np-ui:twatSend", function(data, cb)
  local character_id, first_name, last_name, text = data.character.id, data.character.first_name, data.character.last_name, data.text
  local success, message = RPC.execute("phone:addTwatterEntry", character_id, first_name, last_name, text)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:getTwats", function(data, cb)
  local success, message = RPC.execute("phone:getTwatterEntries")
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

-- TODO: Iterate over online admins.
-- report a twat
RegisterUICallback("np-ui:twatReport", function(data, cb)
  -- INCOMING
  -- data.character = character data from np-ui:init
  -- data.twat = tweet content

  -- RETURN
  -- cb data = {},
  --    meta = { ok: true | false, message: string }
  cb({ data = {}, meta = { ok = true, message = '' } });
end)
