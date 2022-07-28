Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("tuner_laptop", vector3(125.38, -3014.74, 7.04), 0.6, 0.8, {
    minZ=6.69,
    maxZ=7.49,
    heading=0
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget(
    "tuner_laptop",
    {
      {
        event = "np-business:openTunershopLaptop",
        id = "tunershop_laptop_1",
        icon = "laptop",
        label = "Open laptop"
      }
    },
    {
      distance = { radius = 3.0 },
      isEnabled = function ()
        return true
      end
    }
  )
  
  -- kettle 
  
  exports["np-polytarget"]:AddBoxZone(
    "tunashop_make_tea",
    vector3(150.51, -3010.42, 7.04), 0.8, 0.4,
    {
      minZ = 6.84,
      maxZ = 7.64
    }
  )

  exports["np-interact"]:AddPeekEntryByPolyTarget(
    "tunashop_make_tea",
    {{
      event = "np-business:kettle",
      id = "tunashop_make_tea",
      icon = "mug-hot",
      label = "Put the kettle on",
      parameters = {
        position = vector4(150.44, -3010.68, 6.94, 0.0)
      }
    }},
    {
      distance = { radius = 2.0 }
    }
  )

  exports["np-polyzone"]:AddBoxZone("np-fx:audio:stage", vector3(140.63, -3014.36, 10.7), 2.2, 1.4, {
    minZ = 9.7,
    maxZ = 12.3,
    heading = 0,
    data = {
        id = "ts:stage:upper_level",
        ranges = {
            {
                mode = 3,
                range = 60.0,
                priority = 3,
            },
        },
    },
  })

end)

RegisterNetEvent("np-business:openTunershopLaptop")
AddEventHandler("np-business:openTunershopLaptop", function()

  if not IsEmployedAt("tuner") then
    return TriggerEvent("DoLongHudText", "Doesn't seem like I have access to this...", 2)
  end

  exports["np-laptop"]:OpenLaptop({ }, { "tunershop:showBrowserTab" }, {
    laptopBackground = "https://i.imgur.com/me8TVzX.png"
  })
end)
