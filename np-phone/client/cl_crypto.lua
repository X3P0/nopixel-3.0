RegisterUICallback("np-ui:getCrypto", function(data, cb)
  local character_id = data.character.id
  local success, message = RPC.execute("phone:getCrypto", character_id)
  cb({ data = message, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:cryptoExchange", function(data, cb)
  local character_id, crypto_id, target_number, amount = data.character.id, data.id, data.number, data.amount
  local success, message = RPC.execute("phone:transferCryptoByPhone", character_id, target_number, crypto_id, amount)
  if success then
    SendUIMessage({
      source = "np-nui",
      app = "phone",
      data = {
        action = "crypto-receive",
        number = target_number,
        message = ("You have received %s crypto."):format(pAmount)
      }
    })
  end
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterNetEvent("phone:crypto:use")
AddEventHandler("phone:crypto:use", function(pCryptoId, pAmount, pFunctionName, pIsServerFunction)
  local success, message = RPC.execute("phone:useCrypto", pCryptoId, pAmount)
  if success then
      if pIsServerFunction then
          TriggerServerEvent(pFunctionName)
      else
          TriggerEvent(pFunctionName)
      end
  else
      SendUIMessage({
        source = "np-nui",
        app = "phone",
        data = {
          action = "notification",
          target_app = "home-screen",
          title = "SYSTEM",
          body = message,
          show_even_if_app_active = true -- true | false, show this notification even if the app is active
        }
      })
      -- TODO: Replace this shitty email system :)
      TriggerEvent("chatMessage", "EMAIL ", 8, message)
  end
end)

-- phone:crypto:add
RegisterNetEvent("phone:crypto:add")
AddEventHandler("phone:crypto:add", function(pCryptoId, pAmount)
  local success, message = RPC.execute("phone:addCrypto", pCryptoId, pAmount)
  if success then
      TriggerEvent("chatMessage", "EMAIL ", 8, ("You have received %s crypto."):format(pAmount))
  else
      -- TODO: Replace this shitty email system :)
      TriggerEvent("chatMessage", "EMAIL ", 8, message)
  end
end)

local xcoinCids = {
  [1004] = true,
  [3503] = true,
  [3652] = true,
}
function processXCoinRedeem(cid)
  local hasItem = exports["np-inventory"]:hasEnoughOfItem("inkedmoneybag", 1, false, true)
  if not hasItem then
    TriggerEvent("DoLongHudText", "You don't have what they're looking for", 2)
    return
  end
  local canRedeem = RPC.execute("np-phone:xcoin:canRedeem", cid)
  if not canRedeem then
    TriggerEvent("DoLongHudText", "No more coins at the moment", 2)
    return
  end
  TriggerEvent("inventory:removeItem", "inkedmoneybag", 1)
end
AddEventHandler("np-phone:getXCoin", function()
  local cid = exports["isPed"]:isPed("cid")
  if not xcoinCids[cid] then
    TriggerEvent("DoLongHudText", "They don't recognize you", 2)
    return
  end
  processXCoinRedeem(cid)
end)

RegisterUICallback("np-ui:cryptoPurchase", function(data, cb)
  local character_id, bank_id, crypto_id, amount = data.character.id, data.character.bank_account_id, data.id, data.amount
  local success, message = RPC.execute("phone:purchaseCryptoByPhone", character_id, bank_id, crypto_id, amount)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)

RegisterUICallback("np-ui:cryptoSell", function(data, cb)
  local character_id, bank_id, crypto_id, amount = data.character.id, data.character.bank_account_id, data.id, data.amount
  local success, message = RPC.execute("phone:sellCryptoByPhone", character_id, bank_id, crypto_id, amount)
  cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
end)
