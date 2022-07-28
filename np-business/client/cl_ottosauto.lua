Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("ottosauto_make_tea", vector3(825.58, -825.23, 26.33), 0.25, 0.4, {
    minZ = 25.93,
    maxZ = 26.38
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget(
    "ottosauto_make_tea",
    {{
      event = "np-business:kettle",
      id = "ottosauto_make_tea",
      icon = "mug-hot",
      label = "Put the kettle on",
      parameters = {
        position = vector4(825.76, -825.50, 26.07, 144.00)
      }
    }},
    {
      distance = { radius = 2.0 }
    }
  )

end)
