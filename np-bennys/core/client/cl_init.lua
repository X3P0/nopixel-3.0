Citizen.CreateThread(function()
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(452.12, -975.34, 25.7), 5.4, 13.2, {
      minZ = 24.7,
      maxZ = 27.7,
    }) -- MRPD
    -- exports["np-polyzone"]:AddBoxZone("bennys", vector3(-34.12, -1054.31, 28.4), 6.0, 12.4, {
    --   minZ = 27.4,
    --   maxZ = 33.0,
    --   heading = 312,
    -- }) -- Hub
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(110.8, 6626.46, 31.89), 7.4, 8, {
      minZ = 30.0,
      maxZ = 36.0,
      heading = 44.0,
    }) -- Paleto
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(-458.6, 5980.71, 31.33), 9.8, 5.4, {
      heading=314,
      minZ=29.93,
      maxZ=33.33,
    }) -- Paleto PD
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(-809.83, -1507.21, 14.4), 14.2, 13.4, {
      minZ = -0.4,
      maxZ = 6.8,
      heading = 291,
      data = { type = "boats" },
    }) -- Boats
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(-1652.52, -3143.0, 13.99), 10, 10, {
      minZ = 12.99,
      maxZ = 16.99,
      heading = 240,
      data = { type = "planes" },
    }) -- Planes
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(2522.64, 2621.78, 37.96), 7.4, 5.8, {
      minZ = 36.96,
      maxZ = 39.96,
      heading = 270,
    }) -- Rex
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(340.39, -570.6, 28.8), 8.4, 4.4, {
      minZ=27.8,
      maxZ=31.8,
      heading = 340,
    }) -- Pillbox
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(-1818.56, 2966.05, 32.81), 14.6, 15.6, {
      minZ=31.61,
      maxZ=35.61,
      heading = 330,
      data = { type = "planes" },
    }) 
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(-1117.81, -826.58, 3.75), 6.25, 4.0, {
      minZ=2.75,
      maxZ=5.95,
      heading = 36
    })
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(1812.69, 3687.77, 33.97), 5, 7.0, {
      heading=30,
      minZ=32.37,
      maxZ=37.57
    })
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(145.01, -3030.59, 7.04), 6.8, 4.4, {
      heading=0,
      minZ=6.04,
      maxZ=9.24
    })
    --pdm preview bennys
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(840.87, -814.2, 26.31), 10.0, 4.8, {
      heading=359,
      minZ=24.51,
      maxZ=29.11
    })

    -- tuner catalog
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(135.88, -3030.43, 7.04), 6.4, 4.0, {
      heading = 0,
      minZ = 6.04,
      maxZ = 9.04
    })

    exports["np-polyzone"]:AddBoxZone("bennys", vector3(124.54, -3047.26, 7.04), 6.4, 4.0, {
      heading = 90,
      minZ = 6.04,
      maxZ = 9.04
    })

    -- Park Rangers PD
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(373.04, 787.57, 186.81), 6.8, 4.6, {
      heading=0,
      minZ=185.31,
      maxZ=189.91
    })

    -- Bogg Bikes
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(-1114.66, -1686.83, 4.37), 5.0, 4.2, {
      heading=35,
      minZ=3.17,
      maxZ=6.57
    })

    -- Davis PD
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(378.69, -1626.95, 28.77), 8.4, 6.4, {
      heading=139,
      minZ=27.97,
      maxZ=31.97
    })

    -- La Mesa PD
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(869.73, -1350.39, 26.3), 6, 5, {
      heading=90,
      minZ=25.1,
      maxZ=29.1
    })

    -- Overboost Drift School
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(-169.98, -2463.46, 6.3), 4.6, 7, {
      heading=45,
      minZ=5.3,
      maxZ=8.9
    })

    -- EMS El Burro
    exports["np-polyzone"]:AddBoxZone("bennys", vector3(1213.69, -1511.25, 34.7), 4.6, 9.6, {
      heading=0,
      minZ=33.7,
      maxZ=37.7
    })

    -- Flight school
    -- disabled the below in favor of civ hub
    -- exports["np-polyzone"]:AddBoxZone("bennys", vector3(-211.88, -1323.91, 30.89), 8.4, 6.6, {minZ=29.0, maxZ=35.0}) -- pdm
    -- exports["np-polyzone"]:AddBoxZone("bennys", vector3(731.57, -1088.78, 22.17), 5.0, 11.2, {minZ=21.0, maxZ=28.0}) -- bridge
    -- exports["np-polyzone"]:AddBoxZone("bennys", vector3(938.14, -970.93, 39.51), 6, 8, {minZ=37.0, maxZ=43.0}) -- tuner
    -- exports["np-polyzone"]:AddBoxZone("bennys", vector3(-771.46, -233.66, 37.08), 7.4, 8, {minZ=36.0, maxZ=42.0}) -- import
end)
