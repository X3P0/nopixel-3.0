RegisterNetEvent('cid_createFakeID')
AddEventHandler('cid_createFakeID', function()
  local elements = {
    { name = "first", label = _L("cid-firstname", "Firstname"), icon = "user" },
    { name = "last", label = _L("cid-lastname", "Lastname"), icon = "user" },
    { name = "sex", label = _L("cid-sex", "Sex"), icon = "genderless" },
    { name = "dob", label = _L("cid-dob", "Date of Birth (YYYY-MM-DD)"), icon = "calendar-day" }
  }

  local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
      if values.first == nil then
        TriggerEvent('DoLongHudText', _L('cid-missing-firstname', 'Please provide a firstname'), 2)
        return false
      end
      if values.last == nil then
        TriggerEvent('DoLongHudText', _L('cid-missing-lastname', 'Please provide a lastname'), 2)
        return false
      end
      if values.sex == nil then
        TriggerEvent('DoLongHudText', _L('cid-missing-sex', 'Please provide a sex'), 2)
        return false
      end
      if values.dob == nil then
        TriggerEvent('DoLongHudText', _L('cid-missing-dob', 'Please provide a date of birth'), 2)
        return false
      end
      return true
  end)

  local cid = exports["isPed"]:isPed("cid")
  local information = {
    ["fake"] = 1,
    ["Identifier"] = math.floor(math.random() * 1000) + 1000,
    ["Name"] = prompt.first,
    ["Surname"] = prompt.last,
    ["Sex"] = prompt.sex,
    ["DOB"] = prompt.dob,
    ["_hideKeys"] = { "fake" }
  }
  TriggerEvent('player:receiveItem', "idcard", 1, false, {}, json.encode(information))
  RPC.execute("np-cid:addLog", "fakeid", "created")
end)

AddEventHandler("cid_viewLogs", function ()
  local logs = RPC.execute("np-cid:getCreationLogs", "fakeid")

  local elements = {}
  for index, log in pairs(logs) do
    local description = _L("cid-created-fake-id", "Created Fake ID")
    table.insert(elements, {
      title = log.character_name .. " (" .. log.character_id .. ") at " .. log.timestamp,
      description = description
    })
  end

  exports['np-ui']:showContextMenu(elements)
end)

Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone(
    "pd_create_id",
    vector3(484.225, -994.029, 30.667), 1.00, 1.00,
    {
      minZ = 29.0,
      maxZ = 31.45
    }
  );

  exports["np-interact"]:AddPeekEntryByPolyTarget(
    "pd_create_id",
    {
      {
        event = "cid_createFakeID",
        id = "pd_create_id_main",
        icon = "book",
        label = _L("cid-create-id", "Create new ID card")
      },
      {
        event = "cid_viewLogs",
        id = "pd_create_id_logs",
        icon = "list",
        label = _L("cid-view-logs", "View logs")
      }
    },
    {
      distance = { radius = 2.0 },
      job = { 'police' }
    }
  )
end)
