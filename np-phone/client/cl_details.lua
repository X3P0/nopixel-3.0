local currentWeather = ""
RegisterUICallback("np-ui:getCharacterDetails", function(data, cb)
  local character_id, bank_account_id = data.character.id, data.character.bank_account_id
  local success, message = RPC.execute("GetLicenses", character_id)
  local gotBank, bankBalance = RPC.execute("GetCurrentBank", bank_account_id)
  local casinoBalance = RPC.execute("GetCurrentCasino", character_id)

  local details = {}
  --TODO: Fix this! Allow empty.
  details.licenses = success and message or {{ name = "drivers", status = false}}
  details.cash = RPC.execute("GetCurrentCash")
  details.bank = bankBalance
  details.casino = casinoBalance
  details.jobs = {
      ['primary'] = exports["isPed"]:isPed("myjob"),
      ['secondary'] = exports["isPed"]:isPed("secondaryjob")
  }
  details.pagerStatus = exports["isPed"]:isPed("pagerstatus")

  cb({ data = details, meta = { ok = true, message = message or {{ name = "drivers", status = false}} } })
end)
