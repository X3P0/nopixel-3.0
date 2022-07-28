AddEventHandler("np-inventory:itemUsed", function(item, info)
  if item ~= "musictape" then return end
  if not exports["np-inventory"]:hasEnoughOfItem("musicwalkman", 1, false, true) then
    TriggerEvent("DoLongHudText", "You need a walkman!", 2)
    return
  end
  local info = json.decode(info)
  exports["np-ui"]:openApplication("musicplayer", { url = info.url })
  local characterId = exports["isPed"]:isPed('cid')
  RPC.execute("np-music:recordPlay", characterId, info.id)
end)

AddEventHandler("np-music:addMusicEntry", function(pParams)
  local business = pParams.business
  local characterId = exports["isPed"]:isPed('cid')
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = business } })
  if not jobAccess then
    TriggerEvent("DoLongHudText", "You cannot do that.", 2)
    return
  end
  exports['np-ui']:openApplication('textbox', {
      callbackUrl = 'np-ui:music:addMusicEntry',
      key = business,
      items = {
        {
          icon = "music",
          label = "Soundcloud URL",
          name = "url",
        },
        {
          icon = "user-injured",
          label = "Artist",
          name = "artist",
        },
        {
          icon = "user-edit",
          label = "Title",
          name = "title",
        },
        {
          icon = "edit",
          label = "Description",
          name = "description",
        },
      },
      show = true,
  })
end)

RegisterUICallback("np-ui:music:addMusicEntry", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')
  RPC.execute("np-music:addMusicEntry", data.key, data.values)
end)

AddEventHandler("np-music:createMusicTapes", function(pParams)
  local business = pParams.business
  local characterId = exports["isPed"]:isPed('cid')
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = business } })
  if not jobAccess then
    TriggerEvent("DoLongHudText", "You cannot do that.", 2)
    return
  end
  local songOptionsRaw = RPC.execute("np-music:getSongOptions", business)
  local songOptions = {}
  for _, option in pairs(songOptionsRaw) do
    songOptions[#songOptions + 1] = { id = option.id, name = option.title }
  end
  exports['np-ui']:openApplication('textbox', {
      callbackUrl = 'np-ui:music:createMusicTapes',
      key = business,
      items = {
        {
          _type = "select",
          options = songOptions,
          label = "Song",
          icon = "music",
          name = "song",
        },
        {
          icon = "copy",
          label = "Copies",
          name = "copies",
        },
      },
      show = true,
  })
end)

AddEventHandler("np-music:deleteMusicTapes", function(pParams)
  local business = pParams.business
  local characterId = exports["isPed"]:isPed('cid')
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = business } })
  if not jobAccess then
    TriggerEvent("DoLongHudText", "You cannot do that.", 2)
    return
  end
  local songOptionsRaw = RPC.execute("np-music:getSongOptions", business)
  local songOptions = {}
  for _, option in pairs(songOptionsRaw) do
    songOptions[#songOptions + 1] = { id = option.id, name = option.title }
  end
  exports['np-ui']:openApplication('textbox', {
      callbackUrl = 'np-ui:music:deleteMusicTapes',
      key = business,
      items = {
        {
          _type = "select",
          options = songOptions,
          label = "Song to delete",
          icon = "music",
          name = "song",
        }
      },
      show = true,
  })
end)

RegisterUICallback("np-ui:music:deleteMusicTapes", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')
  RPC.execute("np-music:deleteMusicTapes", data.key, data.values)
end)

RegisterUICallback("np-ui:music:createMusicTapes", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')
  RPC.execute("np-music:createMusicTapes", data.key, data.values)
end)

RegisterUICallback("np-ui:music:createMerchendise", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')
  local d = {
    description = data.values.description,
    _description = data.values.description,
    _image_url = data.values.image,
    _hideKeys = { "_description", "_image_url" },
  }
  TriggerEvent("player:receiveItem", "musicmerch", tonumber(data.values.quantity), false, d)
end)

AddEventHandler("np-music:createMerchandise", function(pParams)
  local business = pParams.business
  local characterId = exports["isPed"]:isPed('cid')
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = business } })
  if not jobAccess then
    TriggerEvent("DoLongHudText", "You cannot do that.", 2)
    return
  end
  exports['np-ui']:openApplication('textbox', {
      callbackUrl = 'np-ui:music:createMerchendise',
      key = business,
      items = {
        {
          icon = "pencil-alt",
          label = "Description",
          name = "description",
        },
        {
          icon = "image",
          label = "Image (100x100 px) (e.g.: https://imgur.com/123.png)",
          name = "image",
        },
        {
          icon = "copy",
          label = "Quantity",
          name = "quantity",
        },
      },
      show = true,
  })
end)
