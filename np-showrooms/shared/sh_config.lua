local config = {
  -- FASTLANE YEETED
  -- fastlane = {
  --   carSpawns = {
  --     {
  --       ["coords"] = vector4(-787.03, -243.37, 36.32, 85.14),
  --       ["info"] = "Car Spot 1",
  --       ["model"] = "r1",
  --     },
  --     {
  --       ["coords"] = vector4(-790.26, -237.81, 36.32, 95.3),
  --       ["info"] = "Car Spot 2",
  --       ["model"] = "fnfrx7",
  --     },
  --     {
  --       ["coords"] = vector4(-792.6, -233.09, 36.32, 100.49),
  --       ["info"] = "Car Spot 3",
  --       ["model"] = "r1",
  --     },
  --     {
  --       ["coords"] = vector4(-795.7, -228.24, 36.32, 94.29),
  --       ["info"] = "Car Spot 4",
  --       ["model"] = "fnf4r34",
  --     },
  --     {
  --       ["coords"] = vector4(-783.25, -223.68, 36.56, 171.93),
  --       ["info"] = "Car Spot 5",
  --       ["model"] = "gt63",
  --     },
  --   },
  --   polyZone = {
  --     coords = {
  --       vector2(-833.13543701172, -183.4736328125),
  --       vector2(-858.15698242188, -197.16130065918),
  --       vector2(-825.49865722656, -254.89807128906),
  --       vector2(-815.40686035156, -272.62399291992),
  --       vector2(-818.42425537109, -283.65115356445),
  --       vector2(-774.29351806641, -302.78747558594),
  --       vector2(-770.70660400391, -290.49176025391),
  --       vector2(-775.77282714844, -272.02325439453),
  --       vector2(-746.96704101563, -260.69543457031),
  --       vector2(-736.48358154297, -255.03248596191),
  --       vector2(-795.85998535156, -159.32734680176),
  --     },
  --     options = {
  --       name = "fastlane",
  --       minZ = 30.5,
  --       maxZ = 50.5,
  --       gridDivisions = 25,
  --       debugGrid = false,
  --     },
  --   },
  --   testDriveSpawnPoint = vector4(-789.3, -196.07, 37.1, 298.95),
  -- },
  pdm = {
    carSpawns = {
      {
        ["coords"] = vector4(798.53, -815.82, 26.05, 270.41),
        ["info"] = "Car Spot 1",
        ["model"] = "gauntlet",
      },
      {
        ["coords"] = vector4(798.53, -812.32, 26.06, 270.65),
        ["info"] = "Car Spot 2",
        ["model"] = "dubsta3",
      },
      {
        ["coords"] = vector4(798.99, -807.96, 26.12, 226.12),
        ["info"] = "Car Spot 3",
        ["model"] = "landstalker",
      },
      {
        ["coords"] = vector4(803.38, -807.01, 26.12, 179.65),
        ["info"] = "Car Spot 4",
        ["model"] = "bobcatxl",
      },
      {
        ["coords"] = vector4(807.43, -808.07, 26.09, 145.20),
        ["info"] = "Car Spot 5",
        ["model"] = "surfer",
      },
      {
        ["coords"] = vector4(807.75, -812.54, 26.06, 92.63),
        ["info"] = "Car Spot 6",
        ["model"] = "glendale",
      },
      {
        ["coords"] = vector4(807.71, -815.92, 26.07, 89.36),
        ["info"] = "Car Spot 7",
        ["model"] = "washington",
      },
    },
    polyZone = {
      coords = {
        vector2(-17.224317550659, -1125.9611816406),
        vector2(-70.010810852051, -1128.2976074219),
        vector2(-76.185691833496, -1127.8470458984),
        vector2(-79.25121307373, -1123.7583007813),
        vector2(-79.670585632324, -1118.4036865234),
        vector2(-59.549613952637, -1063.388671875),
        vector2(-1.2465063333511, -1081.7679443359),
      },
      options = {
        name = "pdm",
        minZ = 0,
        maxZ = 40.5,
        gridDivisions = 25,
        debugGrid = false,
      },
    },
    testDriveSpawnPoint = vector4(804.14, -820.33, 26.27, 269.82),
  },
  tuner = {
    carSpawns = {
      {
        ["coords"] = vector4(151.76,-3039.76,6.78,31.26),
        ["info"] = "Car Spot 1",
        ["model"] = "zx10",
      },
      {
        ["coords"] = vector4(151.24,-3044.06,6.33,32.22),
        ["info"] = "Car Spot 2",
        ["model"] = "m4",
      },
      {
        ["coords"] = vector4(144.61,-3048.05,6.32,269.87),
        ["info"] = "Car Spot 3",
        ["model"] = "dc5",
      },
      {
        ["coords"] = vector4(139.24,-3047.0,6.5,323.89),
        ["info"] = "Car Spot 4",
        ["model"] = "raid",
      },
      {
        ["coords"] = vector4(132.81,-3047.58,6.57,0.86),
        ["info"] = "Car Spot 5",
        ["model"] = "lwlp670",
      },
      {
        ["coords"] = vector4(0.0,-3030.38,-16.39,0.09),
        ["info"] = "Lift Bay 1",
        ["model"] = "gt2rwb",
      },
      {
        ["coords"] = vector4(0.0,-3030.38,-16.39,0.09),
        ["info"] = "Center Vehicle",
        ["model"] = "bdragon",
      },
    },
    polyZone = {
      coords = {
        vector2(901.94128417969, -944.42016601563),
        vector2(901.19378662109, -988.61682128906),
        vector2(937.08911132813, -986.65545654297),
        vector2(938.18969726563, -995.44683837891),
        vector2(949.73962402344, -995.05004882813),
        vector2(953.41033935547, -995.00726318359),
        vector2(952.57049560547, -985.20684814453),
        vector2(963.91479492188, -984.59216308594),
        vector2(964.98822021484, -983.99652099609),
        vector2(961.36340332031, -933.67346191406),
        vector2(926.74658203125, -933.97003173828),
      },
      options = {
        name = "tuner",
        minZ = 0,
        maxZ = 55,
        gridDivisions = 25,
        debugGrid = false,
      },
    },
    testDriveSpawnPoint = vector4(124.87,-3022.83,7.05,267.48),
  },
}

function getConfigFor(showroom)
  return config[showroom]
end
