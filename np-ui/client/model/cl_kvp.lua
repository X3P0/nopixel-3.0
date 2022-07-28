local firstCall = true
-- everything is stored as a string
RegisterNUICallback("np-ui:setKVPValue", function(data, cb)
  -- INCOMING
  -- data.key = key
  -- data.value = value

  SetResourceKvp(data.key, json.encode(data.value))

  if firstCall then
    firstCall = false
    Wait(30000)
  end
  TriggerEvent("np-hud:settings", data.key, data.value)

  -- RETURN
  -- void
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterNUICallback("np-ui:getKVPValue", function(data, cb)
  -- INCOMING
  -- data.key = key
  local result = GetResourceKvpString(data.key)
  local value = json.decode(result or "{}")
  -- RETURN
  cb({ data = { value = value }, meta = { ok = true, message = 'done' } })
end)

-- function GetUIKvp(pKey)
--   local result = GetResourceKvpString(pKey)
--   return json.decode(result or "{}")
-- end

-- exports('GetUIKvp', GetUIKvp)

function GetPreferences()
  local result = GetResourceKvpString('np-preferences')
  return json.decode(result or "{}")
end

exports('GetPreferences', GetPreferences)