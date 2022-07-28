AddEventHandler("np-casino:openMegaMallStore", function()
  local cid = exports["isPed"]:isPed("cid")
  local isTennant = RPC.execute("np-hotel:rooms:isTennant", cid)
  if not isTennant then
    TriggerEvent("DoLHudText", 2, "casino-dont-recognize", "They don't recognize you")
    return
  end
  -- Disable because of new shops
  return
  TriggerEvent("server-inventory-open", "4", "Shop");
end)

RegisterUICallback("np-ui:casinohotel:genDiscountCard", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')
  TriggerEvent("player:receiveItem", "casinodiscountcard", 1, false, {
    state_id = data.values.state_id,
    expires = data.values.expiry,
  })
end)

AddEventHandler("np-casino:hotel:getDiscountCard", function()
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "casino_hotel"} })
  if not jobAccess then
    TriggerEvent("DoLHudText", 2, "casino-please-talk-to-floor-staff", "Please talk to a member of floor staff")
    return
  end
  exports['np-ui']:openApplication('textbox', {
    callbackUrl = 'np-ui:casinohotel:genDiscountCard',
    key = 1,
    items = {
      {
        icon = "id-card-alt",
        label = _L("casino-state-id", "State ID"),
        name = "state_id",
      },
      {
        icon = "calendar",
        label = _L("casino-expiry-date", "Expiry Date"),
        name = "expiry",
      },
    },
    show = true,
  })
end)

AddEventHandler("np-inventory:itemUsed", function(pItem)
  if pItem ~= "casinosoap" then return end
  TriggerEvent("DoLHudText", 1, "casino-clean-lucky", "You feel clean and lucky!")
  TriggerEvent("inventory:removeItem", "casinosoap", 1)
end)

AddEventHandler("np-casino:getSoap", function()
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "casino_hotel"} })
  if not jobAccess then
    TriggerEvent("DoLHudText", 2, "casino-please-talk-to-floor-staff", "Please talk to a member of floor staff")
    return
  end
  TriggerEvent("player:receiveItem", "casinosoap", 1)
end)

AddEventHandler("np-casino:getHotelVIPCard", function()
  local cid = exports["isPed"]:isPed("cid")
  local isTennant = RPC.execute("np-hotel:rooms:isTennant", cid)
  if not isTennant then
    TriggerEvent("DoLHudText", 2, "casino-dont-recognize", "They don't recognize you")
    return
  end
  TriggerEvent("player:receiveItem", "casinovip", 1)
end)

AddEventHandler("np-casino:getCasinoBag", function()
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "casino_hotel"} })
  if not jobAccess then
    TriggerEvent("DoLHudText", 2, "casino-please-talk-to-floor-staff", "Please talk to a member of floor staff")
    return
  end
  RPC.execute("np-casino:getCasinoBag")
end)

AddEventHandler("np-casino:getCasinoCoin", function()
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "casino_hotel"} })
  if not jobAccess then
    TriggerEvent("DoLHudText", 2, "casino-please-talk-to-floor-staff", "Please talk to a member of floor staff")
    return
  end
  local function pad(k)
    if k < 10 then
      return "0" .. tostring(k)
    end
    return tostring(k)
  end
  TriggerEvent("DoLongHudText", "Getting a new coin will invalidate this rooms previous ones")
  local options = {}
  for i = 1, 24 do
    options[#options + 1] = { id = i, name = "Room 5" .. pad(i) }
  end
  exports["np-ui"]:openApplication("textbox", {
    callbackUrl = "np-ui:casino:hotel:getCasinoCoin",
    key = "np-business:hotel:ui:listTenants",
    items = {
      {
        _type = "select",
        options = options,
        icon = "user-edit",
        label = "Room",
        name = "room",
      },
    },
    show = true,
  })
end)

RegisterUICallback("np-ui:casino:hotel:getCasinoCoin", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "" } })
  exports["np-ui"]:closeApplication("textbox")
  local room = data.values.room
  RPC.execute("np-casino:getGoldCoinForRoom", room)
end)
