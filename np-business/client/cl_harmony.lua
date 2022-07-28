Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("harmony_make_tea", vector3(1187.15, 2635.31, 38.4), 0.4, 0.4, {
    minZ=38.2,
    maxZ=38.8
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget(
    "harmony_make_tea",
    {{
      event = "np-business:kettle",
      id = "harmony_make_tea",
      icon = "mug-hot",
      label = "Put the kettle on",
      parameters = {
        position = vector4(1187.59, 2635.27, 38.27,144.00)
      }
    }},
    {
      distance = { radius = 2.0 }
    }
  )

end)
