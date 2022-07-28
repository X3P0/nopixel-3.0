local targets = {
  { 
      id = "bar:grabDrink", 
      center = vector3(127.39, -1282.16, 29.27), 
      width = 0.95, 
      height = 0.85, 
      options = { heading = 300, minZ = 29.27, maxZ = 29.47, data = { name = 'vu_bar_1' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(128.2, -1283.59, 29.27), 
      width = 0.95, 
      height = 0.85, 
      options = { heading = 300, minZ = 29.27, maxZ = 29.47, data = { name = 'vu_bar_2' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(128.88, -1284.78, 29.27), 
      width = 0.95, 
      height = 0.85, 
      options = { heading = 300, minZ = 29.27, maxZ = 29.47, data = { name = 'vu_bar_3' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(129.56, -1285.89, 29.27), 
      width = 0.95, 
      height = 0.85, 
      options = { heading = 300, minZ = 29.27, maxZ = 29.47, data = { name = 'vu_bar_4' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(130.07, -1287.27, 29.27), 
      width = 0.55, 
      height = 1.25, 
      options = { heading = 300, minZ = 29.27, maxZ = 29.47, data = { name = 'vu_bar_5' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(117.5, -1283.03, 28.26), 
      width = 1.5, 
      height = 1.5, 
      options = { heading = 346, minZ = 27.26, maxZ = 28.36, data = { name = 'vu_bar_6' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(115.87, -1286.81, 28.88), 
      width = 1.5, 
      height = 1.5, 
      options = { heading = 346, minZ = 27.26, maxZ = 28.36, data = { name = 'vu_bar_7' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(112.78, -1283.14, 28.88), 
      width = 1.5, 
      height = 1.5, 
      options = {  heading = 346, minZ = 27.26, maxZ = 28.36, data = { name = 'vu_bar_8' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(120.96, -1285.2, 28.26), 
      width = 0.8, 
      height = 1.05, 
      options = { heading = 30, minZ = 27.26, maxZ = 28.06, data = { name = 'vu_bar_9' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(122.0, -1287.05, 28.26), 
      width = 0.8, 
      height = 1.05, 
      options = { heading = 30, minZ = 27.16, maxZ = 28.06, data = { name = 'vu_bar_10' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(116.51, -1291.33, 28.26), 
      width = 0.8, 
      height = 1.1, 
      options = { heading = 306, minZ = 27.16, maxZ = 28.06, data = { name = 'vu_bar_11' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(123.37, -1294.85, 29.27), 
      width = 0.8, 
      height = 1.1, 
      options = { heading = 298, minZ = 28.17, maxZ = 28.97, data = { name = 'vu_bar_12' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(119.98, -1296.78, 29.27), 
      width = 0.8, 
      height = 1.1, 
      options = { heading = 303, minZ = 28.17, maxZ = 28.97, data = { name = 'vu_bar_13' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(113.35, -1303.07, 29.89), 
      width = 1.5, 
      height = 1.5, 
      options = { heading = 35, minZ = 27.64, maxZ = 29.24, data = { name = 'vu_bar_14' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(114.65, -1305.58, 29.29), 
      width = 0.8, 
      height = 1.1, 
      options = { heading = 30, minZ = 25.99, maxZ = 28.99, data = { name = 'vu_bar_15' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(125.83, -1286.79, 29.27), 
      width = 0.8, 
      height = 1.1, 
      options = { heading = 35, minZ = 28.87, maxZ = 29.67, data = { name = 'vu_bar_16' } }
  },
  { 
      id = "bar:grabDrink", 
      center = vector3(124.25, -1284.04, 29.27), 
      width = 0.8, 
      height = 0.8, 
      options = { heading = 35, minZ = 28.87, maxZ = 29.67, data = { name = 'vu_bar_17' } }
  },
  { 
      id = "bar:openFridge",
      center = vector3(129.95, -1280.39, 29.27), 
      width = 0.95, 
      height = 2.2, 
      options = { heading = 300, minZ = 29.27, maxZ = 29.47, data = { name = 'vu_fridge_1' } }
  },
  {
    id = "vu_towels",
    center = vector3(111.66, -1281.07, 28.26),
    width = 1.0,
    height = 1.0,
    options = { minZ = 27.26, maxZ = 28.86 }
  },
  {
    id = "vu_towels",
    center = vector3(125.41, -1291.66, 29.27),
    width = 2.0,
    height = 1.0,
    options = { heading = 120.0, minZ = 28.27, maxZ = 30.27 }
  },
  {
    id = "vu_laptop",
    center = vector3(119.79, -1282.7, 28.28),
    width = 0.6,
    height = 0.8,
    options = { heading = 30.0, minZ = 28.23, maxZ = 29.03 }
  }
}

local zones = {
  {
    id = "vu_dj",
    center = vector3(120.72, -1281.43, 29.48),
    width = 2.6,
    height = 1.4,
    options = { heading = 30.0, minZ = 28.08, maxZ = 31.28 }
  }
}


Citizen.CreateThread(function()

  for _, zone in ipairs(zones) do
    exports["np-polyzone"]:AddBoxZone(zone.id, zone.center, zone.width, zone.height, zone.options)
  end

  for _, target in ipairs(targets) do
    exports["np-polytarget"]:AddBoxZone(target.id, target.center, target.width, target.height, target.options)
  end

  -- vu building
  exports["np-polyzone"]:AddPolyZone("vanilla_unicorn", {
    vector2(90.151443481445, -1290.5842285156),
    vector2(99.329360961914, -1283.6525878906),
    vector2(132.82504272461, -1276.8958740234),
    vector2(141.96463012695, -1290.7845458984),
    vector2(114.44309997559, -1306.5148925781),
    vector2(114.71855163574, -1308.8446044922),
    vector2(106.34483337402, -1314.2183837891)
  }, {
    gridDivisions = 25
  })
end)
