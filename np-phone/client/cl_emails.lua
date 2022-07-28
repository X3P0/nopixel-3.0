RegisterNetEvent('phone:addnotification')
AddEventHandler('phone:addnotification', function(name, message)
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "email-receive",
      subject = name,
      body = message
    }
  })
end)

RegisterNetEvent('phone:emailReceived')
AddEventHandler('phone:emailReceived', function(sender, subject, body, opts)
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "email-receive",
      sender = sender,
      subject = subject,
      body = body,
      opts = opts,
    }
  })
end)

RegisterNetEvent('phone:notification')
AddEventHandler('phone:notification', function(title, message, forced, app)
  SendUIMessage({
    source = "np-nui",
    app = "phone",
    data = {
      action = "notification",
      target_app = app or "home-screen",
      title = title,
      body = message,
      show_even_if_app_active = forced and true or false
    }
  })
end)
