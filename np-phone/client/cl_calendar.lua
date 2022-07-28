local UpcomingEvents = {}

RegisterUICallback("np-ui:calendar:createEvent", function(data, cb)
  local result, message = RPC.execute("np-phone:calendar:createEvent", data)
  cb({ data = "ok", meta = { ok = result, message = message } })
end)

RegisterUICallback("np-ui:calendar:joinEvent", function(data, cb)
  -- text: Event Code
  local result, message = RPC.execute("np-phone:calendar:joinEvent", data.text)
  cb({ data = "ok", meta = { ok = result, message = message } })
end)

RegisterUICallback("np-ui:calendar:sendInvite", function(data, cb)
  -- text: State ID to invite
  local result, message = RPC.execute("np-phone:calendar:sendInvite", data.id, data.text)
  cb({ data = "ok", meta = { ok = result, message = message } })
end)

RegisterUICallback("np-ui:calendar:leaveEvent", function(data, cb)
  -- id: Event ID to leave
  local result = RPC.execute("np-phone:calendar:leaveEvent", data.id)
  cb({ data = "ok", meta = { ok = result, message = "done" } })
end)

RegisterUICallback("np-ui:calendar:getEvents", function(data, cb)
  local data = RPC.execute("np-phone:calendar:getEvents", data.character.id) or {}
  UpcomingEvents = data
  cb({ data = data, meta = { ok = true, message = "done" } })
end)

RegisterUICallback("np-ui:calendar:editEvent", function(data, cb)
  local result, message = RPC.execute("np-phone:calendar:editEvent", data)
  cb({ data = "ok", meta = { ok = result, message = message } })
end)

RegisterUICallback("np-ui:calendar:forceAddEvent", function(data, cb)
  local result, message = RPC.execute("np-phone:calendar:forceAddEvent", data.id, data.text)
  cb({ data = "ok", meta = { ok = result, message = message } })
end)

RegisterNetEvent("np-phone:calendar:eventInvite", function(pEventId, pName)
  local result = DoPhoneConfirmation("Event Invite", pName)
  if result then
    RPC.execute("np-phone:calendar:joinEventById", pEventId)
  end
end)

RegisterNetEvent("np-phone:calendar:checkEvent", function(pEventId)
  for _, event in ipairs(UpcomingEvents) do
    if event.id == pEventId then
      SendUIMessage({
        source = "np-nui",
        app = "phone",
        data = {
          action = "notification",
          target_app = "calendar",
          title = "Calendar",
          body = event.name .. " is starting!",
          icon = { background = "#171717", color = "white", name = "calendar-alt" },
          show_even_if_app_active = true,
        },
      })
      return
    end
  end
end)

function getUpcomingEvents(pCharacterId)
  UpcomingEvents = RPC.execute("np-phone:calendar:getUpcomingEvents", pCharacterId) or {}
  if #UpcomingEvents > 0 then
    SendUIMessage({
      source = "np-nui",
      app = "phone",
      data = {
        action = "notification",
        target_app = "calendar",
        title = "Calendar",
        body = "You have " .. #UpcomingEvents .. " event" .. (#UpcomingEvents > 1 and "s" or "") .. " happening soon",
        icon = { background = "#171717", color = "white", name = "calendar-alt" },
        show_even_if_app_active = true,
      },
    })
  end
end

AddEventHandler("np-spawn:characterSpawned", getUpcomingEvents)
