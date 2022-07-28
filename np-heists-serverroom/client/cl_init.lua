Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2168.03, 2925.81, -81.08), 1.2, 0.6, {
    heading=300,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2171.37, 2927.75, -81.08), 1.2, 0.6, {
    heading=300,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2174.8, 2927.67, -81.08), 1.0, 0.6, {
    heading=240,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp3",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2178.01, 2925.84, -81.08), 1.0, 0.6, {
    heading=240,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp4",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2179.72, 2922.78, -81.08), 1.0, 0.6, {
    heading=180,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp5",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2179.7, 2919.2, -81.08), 1.0, 0.6, {
    heading=180,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp6",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2177.99, 2916.18, -81.08), 1.0, 0.6, {
    heading=120,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp7",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2174.68, 2914.36, -81.08), 1.0, 0.6, {
    heading=120,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp8",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2171.27, 2914.54, -81.08), 1.0, 0.6, {
    heading=60,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp9",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer", vector3(2168.02, 2916.32, -81.08), 1.0, 0.6, {
    heading=60,
    minZ=-81.48,
    maxZ=-81.08,
    data = {
      id = "comp10",
    },
  })

  exports["np-polytarget"]:AddBoxZone("server_farm_computer_down", vector3(2185.7, 2928.58, -84.8), 1.0, 0.6, {
    heading=5,
    minZ=-85.2,
    maxZ=-84.8,
    data = {
      id = "comp1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer_down", vector3(2185.78, 2913.3, -84.8), 0.8, 0.6, {
    heading=355,
    minZ=-85.2,
    maxZ=-84.8,
    data = {
      id = "comp2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer_down", vector3(2150.32, 2913.39, -84.8), 0.8, 0.6, {
    heading=5,
    minZ=-85.2,
    maxZ=-84.8,
    data = {
      id = "comp3",
    },
  })
  exports["np-polytarget"]:AddBoxZone("server_farm_computer_down", vector3(2150.43, 2928.61, -84.8), 0.8, 0.6, {
    heading=355,
    minZ=-85.2,
    maxZ=-84.8,
    data = {
      id = "comp4",
    },
  })

  exports["np-polytarget"]:AddBoxZone("vr_room_entrance", vector3(-211.23, -301.07, 74.49), 0.4, 0.6, {
    heading = 340,
    minZ = 74.29,
    maxZ = 74.49,
    data = {
      id = "comp1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("vr_room_entrance", vector3(-212.52, -298.18, 74.49), 0.4, 0.6, {
    heading = 340,
    minZ = 74.39,
    maxZ = 74.59,
    data = {
      id = "comp2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("vr_room_entrance", vector3(-210.86, -292.98, 74.49), 0.4, 0.6, {
    heading = 340,
    minZ = 74.79,
    maxZ = 75.19,
    data = {
      id = "comp3",
    },
  })
  exports["np-polytarget"]:AddBoxZone("vr_room_entrance", vector3(-209.3, -293.49, 74.49), 0.4, 0.6, {
    heading = 340,
    minZ = 74.19,
    maxZ = 74.59,
    data = {
      id = "comp4",
    },
  })
  exports["np-polytarget"]:AddBoxZone("vr_room_entrance", vector3(-206.94, -294.25, 74.49), 0.4, 0.6, {
    heading = 340,
    minZ = 74.19,
    maxZ = 74.59,
    data = {
      id = "comp5",
    },
  })
  exports["np-polytarget"]:AddBoxZone("vr_room_entrance", vector3(-206.81, -297.37, 74.49), 0.4, 0.6, {
    heading = 340,
    minZ = 74.19,
    maxZ = 74.59,
    data = {
      id = "comp6",
    },
  })

  -- exports["np-polytarget"]:AddBoxZone("vr_room_exit", vector3(2156.26, 2922.27, -81.08), 0.6, 0.6, {
  --   heading = 305,
  --   minZ = -81.28,
  --   maxZ = -80.68,
  -- })

  exports["np-interact"]:AddPeekEntryByPolyTarget('vr_room_entrance', {{
    event = "np-heists-serverroom:vr-room-enter",
    id = "heist_vr_room_enter",
    icon = "user-secret",
    label = "Access VAR Environment",
    parameters = {}
  }}, { distance = { radius = 1.5 }})
  -- exports["np-interact"]:AddPeekEntryByPolyTarget('vr_room_exit', {{
  --   event = "np-heists-serverroom:vr-room-exit",
  --   id = "heist_vr_room_exit",
  --   icon = "user-secret",
  --   label = "Exit VAR Environment",
  --   parameters = {}
  -- }}, { distance = { radius = 1.5 }})
end)
