Citizen.CreateThread(function()
  -- bs
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1204.65, -891.94, 13.98), 3.4, 2.8, {
    heading=35,
    minZ = 13.0,
    maxZ = 15.0,
    data = {
      id = "burger_shot",
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1681.69, -1093.23, 13.16), 2.2, 1.0, {
    heading=220,
    minZ=12.36,
    maxZ=14.36,
    data = {
      id = "burgershot_pier",
      biz = "burger_shot",
    },
  })
  -- maldinis
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-588.35, -895.02, 25.72), 3.4, 4.4, {
    heading=35,
    minZ = 24.72,
    maxZ = 28.12,
    data = {
      id = "maldinis_freezer",
      biz = "maldinis",
      invSize = 1000,
      invSlots = 40,
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-578.41, -891.83, 25.72), 2.0, 1.2, {
    heading=359,
    minZ=24.72,
    maxZ=27.12,
    data = {
      id = "maldinis_counter",
      biz = "maldinis",
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-575.75, -1066.45, 26.61), 2.45, 1.4, {
    heading = 0,
    minZ = 25.61,
    maxZ = 27.21,
    data = {
      id = "uwu_main_office",
      biz = "uwu_cafe",
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-597.19, -1049.48, 22.34), 3.0, 2.4, {
    heading=0,
    minZ=21.34,
    maxZ=23.94,
    data = {
      id = "uwu_lockers",
      biz = "uwu_cafe",
    },
  })
  -- wuchang
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-826.78, -729.83, 28.06), 1, 1, {
    heading=0,
    minZ=27.06,
    maxZ=29.06,
    data = {
      id = "wuchang_2",
      biz = "wuchang",
    },
  }) -- behind bar
  -- pet store
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-294.91, 6296.41, 31.49), 1.6, 1, {
    name="petstore",
    heading=48,
    minZ=30.29,
    maxZ=32.89,
    data = {
      id = "petstore",
    },
  })
  -- creampie
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(972.33, 41.04, 116.16), 1.6, 1.4, {
    name="creampie",
    heading=60,
    minZ=114.96,
    maxZ=117.16,
    data = {
      id = "creampie",
    },
  })
  -- LSBB
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-902.57, -463.78, 141.51), 2.3, 2, {
    name="lsbb",
    heading=297,
    --debugPoly=true,
    minZ=140.51,
    maxZ=144.51,
    data = {
      id = "lsbb"
    }
  })
  -- Bob Mulet
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-822.54, -181.3, 37.57), 1.2, 2.6, {
    name="bobby_brown",
    heading=30,
    -- debugPoly=true,
    minZ=36.17,
    maxZ=37.77,
    data = {
      id = "bobby_brown"
    }
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(93.2, -1291.06, 29.26), 1.6, 2.4, {
    name="vanilla_unicorn_back_room",
    heading=30,
    minZ=28.06,
    maxZ=30.86,
    data = {
      id = "vanilla_unicorn_back_room",
      biz = "vanilla_unicorn"
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(131.28, -1284.55, 29.27), 3.6, 1.6, {
    name="vanilla_unicorn_bar",
    heading=30,
    minZ=28.27,
    maxZ=31.07,
    data = {
      id = "vanilla_unicorn_bar",
      biz = "vanilla_unicorn"
    },
  })
  -- bay city bank (locksley)
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1295.06, -836.97, 17.15), 2.2, 2.0, {
    heading=35,
    minZ=16.15,
    maxZ=18.55,
    data = {
      id = "locksley",
    },
  })
  -- H & O import/exports
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(913.72,-1803.03,22.37), 0.75, 1.9, {
    name="hno_office_stash",
    heading=0,
    minZ=19.25,
    maxZ=26.25,
    data = {
      id = "hno_imports_1",
      biz = "hno_imports"
    }
  })
  -- bean manor
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-808.28, 174.85, 76.74), 1.6, 2.0, {
    name="bean_manor",
    heading=21,
    minZ=75.74,
    maxZ=78.14,
    data = {
      id = "bean_manor"
    }
  })
  -- iron hog
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(1776.98, 3322.54, 41.46), 1.6, 1.2, {
    name = "iron_hog_stash",
    heading = 30,
    minZ = 40.46,
    maxZ = 42.86,
    data = {
      id = "iron_hog_stash",
      biz = "iron_hog"
    }
  })
  -- aunties (gsf)
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-16.74, -1430.42, 31.1), 1.4, 2.4, {
    heading=0,
    minZ=30.1,
    maxZ=32.7,
    data = {
      id = "gsf_house",
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(555.0, -2770.02, 6.09), 2.8, 2.0, {
    heading=239,
    --debugPoly=true,
    minZ=3.49,
    maxZ=7.49,
    data = {
      id = "lsbb_container",
      biz = "hades",
      policeAccess = true
    }
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-696.15, 628.92, 159.16), 2.0, 1, {
    name = "saco_stash",
    heading = 168,
    minZ = 158.16,
    maxZ = 160.56,
    data = {
      id = "saco_stash",
      biz = "saco"
    }
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1988.18, -500.57, 12.19), 1.2, 3.2, {
    name = "saco_beach_stash",
    heading = 230,
    minZ = 11.19,
    maxZ = 14.19,
    data = {
      id = "saco_beach_stash",
      biz = "saco_holdings"
    }
  })
  exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-806.9, 245.39, 79.2), 1.0, 1.4, {
    name = "hades_stash",
    heading = 10,
    minZ = 78.2,
    maxZ = 81.0,
    data = {
      id = "hades_stash",
      biz = "hades"
    }
  })
  --
  -- crafts
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(-1408.37, -447.21, 35.91), 1.0, 1.8, {
    heading = 32,
    minZ = 34.91,
    maxZ = 36.91,
    data = {
      id = "hayes_autos",
      inventory = "42121"
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(1172.67, 2635.41, 37.79), 2.6, 2.4, {
    heading = 91,
    minZ = 36.79,
    maxZ = 39.19,
    data = {
      id = "harmony_repairs",
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(1131.8, -467.03, 66.49), 1.2, 2.4, {
    name="ddcraft",
    heading=76,
    minZ=65.49,
    maxZ=67.69,
    data = {
      id = "digital_den",
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(836.42, -811.72, 26.33), 1.8, 3.8, {
    heading=90,
    minZ=24.53,
    maxZ=28.53,
    data = {
      id = "ottos_auto",
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(1084.69, -2002.3, 31.39), 4.0, 1.4, {
    heading=317,
    minZ=29.84,
    maxZ=32.84,
    data = {
        id = "sionis"
    }
  })
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(122.22, -3028.36, 7.04), 4.2, 2.2, {
    heading = 0,
    minZ = 6.04,
    maxZ = 8.24,
    data = {
      id = "tuner",
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(-760.67, -221.84, -5.37), 2, 2, {
    heading=30,
    minZ=-7.22,
    maxZ=-3.22,
    data = {
      id = "statecontracting",
      inventory = "42095"
    },
  })
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(1770.55, 3318.11, 41.44), 4.2, 3.2, {
    heading=300,
    minZ=40.24,
    maxZ=42.64,
    data = {
      id = "iron_hog",
      inventory = "42103"
    },
  })

  --
  --
  exports["np-polytarget"]:AddBoxZone("btat_chair_1", vector3(324.11, 181.3, 103.59), 1.0, 1.5, {
    heading=25,
    minZ=102.59,
    maxZ=103.79
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("btat_chair_1", {{
    event = "np-business:tattoo:sitChair",
    id = "btat_chairs_1",
    icon = "chair",
    label = "sit",
    parameters = { sitType = "upright" },
  }}, { distance = { radius = 3.5 }})

  exports["np-polytarget"]:AddBoxZone("btat_chair_2", vector3(325.73, 180.53, 103.59), 0.6, 1.4, {
    heading=50,
    minZ=102.59,
    maxZ=103.79
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("btat_chair_2", {{
    event = "np-business:tattoo:sitChair",
    id = "btat_chairs_2",
    icon = "chair",
    label = "sit",
    parameters = { sitType = "laying" },
  }}, { distance = { radius = 3.5 }})

  exports["np-polytarget"]:AddBoxZone("btat_chair_3", vector3(323.65, 182.12, 103.59), 0.6, 0.6, {
    heading=30,
    minZ=102.59,
    maxZ=103.79
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("btat_chair_3", {{
    event = "np-business:tattoo:sitChair",
    id = "btat_chairs_3",
    icon = "chair",
    label = "sit",
    parameters = { sitType = "tattooist" },
  }}, { distance = { radius = 3.5 }})
  exports["np-polytarget"]:AddBoxZone("business:digitalden:counter", vector3(1134.69, -468.89, 66.49), 0.8, 2.0, {
    heading=346,
    minZ=66.29,
    maxZ=66.89,
  })
  exports["np-polyzone"]:AddBoxZone("business_flight_school_hangar", vector3(-1868.54, 2800.68, 32.81), 20.4, 38.85, {
    heading=330,
    minZ=31.65,
    maxZ=40.89,
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("business:digitalden:counter", {{
    event = "np-business:openInventory",
    id = "digital_den_counter",
    icon = "box-open",
    label = "open",
    parameters = {invName="digital_den_counter"},
  }}, { distance = { radius = 3.5 }})
  exports["np-polytarget"]:AddBoxZone("business:bobmulet_store:crafting", vector3(-810.71, -186.2, 37.57), 1.8, 3.2, {
    heading=30,
    minZ=36.57,
    maxZ=38.57
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("business:bobmulet_store:crafting", {{
    event = "np-business:openCrafting",
    id = "bobmulet_store_crafting",
    icon = "pencil-ruler",
    label = "Craft",
    parameters = {invName="42083"},
  }}, { distance = { radius = 2.5 }  , isEnabled = function(pEntity, pContext) return IsEmployedAt("bobby_brown") and HasPermission("bobby_brown", "craft_access") end })
  exports["np-polytarget"]:AddBoxZone("business:comic_store:crafting", vector3(-144.24, 229.04, 81.17), 1.5, 1.5, {
    heading=0,
    minZ=78.17,
    maxZ=82.17
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("business:comic_store:crafting", {{
    event = "np-business:openCrafting",
    id = "comic_store_crafting",
    icon = "pencil-ruler",
    label = "Craft",
    parameters = {invName="42082"},
  }}, {
    distance = { radius = 2.5 },
    isEnabled = function(pEntity, pContext)
      return IsEmployedAt("comic_store") and HasPermission("comic_store", "craft_access")
    end
  })

  exports["np-polyzone"]:AddBoxZone("saco_log", vector3(-717.54, 639.76, 159.16), 3.0, 1.6, {
    name = "saco_log",
    heading = 349,
    minZ = 158.16,
    maxZ = 160.76,
    data = {
      id = "saco_log",
    }
  })

  exports["np-polyzone"]:AddBoxZone("saco_beach_log", vector3(-1980.71, -501.43, 20.73), 2.0, 1.2, {
    name = "saco_beach_log",
    heading = 320,
    minZ=19.73,
    maxZ=22.73,
    data = {
      id = "saco_beach_log",
    }
  })

  exports["np-polyzone"]:AddBoxZone("business_saco_beach", vector3(-2081.49, -472.24, 13.2), 15.2, 15.0, {
    name = "business_saco_beach",
    heading = 320,
    minZ=11.8,
    maxZ=18.6
  })

  exports["np-polyzone"]:AddBoxZone("hades_log", vector3(-817.34, 267.31, 82.8), 2.6, 2.2, {
    name = "hades_log",
    heading = 350,
    minZ = 81.75,
    maxZ = 84.35,
    data = {
      id = "hades_log",
    }
  })

  exports["np-polytarget"]:AddBoxZone("business:pixelperfect:counter", vector3(-659.92, -856.83, 24.52), 0.8, 1.9, {
    heading=270,
    minZ=24.22,
    maxZ=24.82
  })

  exports['np-interact']:AddPeekEntryByPolyTarget("business:pixelperfect:counter", {{
    event = "np-business:openInventory",
    id = "pixel_perfect_counter",
    icon = "box-open",
    label = "open",
    parameters = {invName="pixel_perfect_counter"},
  }}, { distance = { radius = 3.5 }})

  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(-662.47, -857.92, 24.52), 1.0, 1.65, {
    name="ppcraft",
    heading=0,
    minZ=23.47,
    maxZ=26.07,
    data = {
      id = "pixel_perfect",
    },
  })

  while not exports['np-config']:IsConfigReady() do
    Wait(100)
  end
  local areStashesPublic = exports['np-config']:GetMiscConfig("business.stashes.public")
  if areStashesPublic then
    --lost mc Orange County
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(977.0, -103.95, 74.85), 1.8, 2.0, {
      heading=45,
      minZ=73.85,
      maxZ=76.25,
      data = {
        id = "lostmc_orange",
      }
    })
    --split sides craft (public only)
    -- exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-448.21, 269.13, 83.02), 1.8, 3.2, {
    --   heading=355,
    --   minZ=82.02,
    --   maxZ=84.62,
    --   data = {
    --     id = "split_sides_backroom",
    --     biz= "split_sides"
    --   }
    -- })
    -- exports["np-polyzone"]:AddBoxZone("business_craft", vector3(-444.58, 266.76, 83.02), 2.6, 1, {
    --   heading=355,
    --   minZ=82.02,
    --   maxZ=84.02,
    --   data = {
    --     id = "split_sides",
    --     inventory = "42092"
    --   },
    -- })
    --bahama mamas public
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1387.0, -606.66, 30.32), 1.4, 2.8, {
      heading=35,
      minZ=29.32,
      maxZ=31.52,
      data = {
        id = "bahamas_public",
      }
    })
    exports["np-polyzone"]:AddBoxZone("business_craft", vector3(-1385.95, -608.09, 30.32), 1.4, 2.8, {
      heading=35,
      minZ=29.32,
      maxZ=31.52,
      data = {
        id = "bahamas_public",
        inventory = "42093"
      },
    })
    --teqilala public
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-562.79, 286.61, 82.18), 3.2, 1.4, {
      heading=355,
      minZ=81.18,
      maxZ=83.38,
      data = {
        id = "teqilala_public",
      }
    })
    exports["np-polyzone"]:AddBoxZone("business_craft", vector3(-561.74, 289.71, 82.18), 1.4, 1.6, {
      heading=355,
      minZ=81.18,
      maxZ=83.38,
      data = {
        id = "teqilala_public",
        inventory = "42091"
      },
    })
    -- replaced stashes on wl
    -- old stuff for public just in case
    -- Comic Store
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-145.47, 228.86, 81.17), 1.9, 1.5, {
      heading=0,
      minZ=78.57,
      maxZ=82.57,
      data = {
        id = "comic_store"
      }
    })
    -- iron hog materials
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(1771.73, 3322.2, 41.44), 3.8, 1.6, {
      name = "iron_hog_materials",
      heading=30,
      minZ=40.44,
      maxZ=42.24,
      data = {
        id = "iron_hog_materials",
        biz = "iron_hog"
      }
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(128.65, -3013.57, 7.04), 1.0, 2.6, {
      name="tunashop",
      heading=0,
      minZ=6.04,
      maxZ=8.84,
      data = {
        id = "tuner"
      }
    })
    -- Right of way (Tessa)
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-21.59, -209.52, 46.31), 1.2, 2.4, {
      heading = 70,
      minZ = 45.31,
      maxZ = 47.51,
      data = {
        id = "right_of_way",
      }
    })
    -- Weazel news stash (first floor)
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-603.47, -920.74, 23.78), 1.4, 1.0, {
      heading = 1,
      minZ = 22.78,
      maxZ = 25.18,
      data = {
        id = "weazel_news",
      }
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(1198.84, -3117.42, 5.54), 1.8, 1, {
      name="afterlife",
      heading=0,
      minZ=4.54,
      maxZ=6.54,
      data = {
        id = "afterlife_tuning"
      }
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(1074.35, -2010.11, 32.08), 2, 2, {
      heading=325,
      --debugPoly=true,
      minZ=30.88,
      maxZ=34.28,
      data = {
          id = "sionis"
      }
    })

    -- Construction Company
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-758.71, -218.04, -5.37), 3.2, 1.0, {
      heading=300.0,
      --debugPoly=true,
      minZ=-6.62,
      maxZ=-3.02,
      data = {
        id = "statecontracting",
        isLarge = true,
      },
    })

    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(5511.59, 5984.28, 590.0), 1.8, 1.4, {
      heading=0,
      minZ=588.8,
      maxZ=590.8,
      data = {
        id = "npa_1",
        biz = "npa",
      },
    })

    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(5514.25, 5970.03, 634.41), 1.4, 1.0, {
      heading=0,
      minZ=633.21,
      maxZ=635.41,
      data = {
        id = "npa_2",
        biz = "npa",
      },
    })

    -- comic store office
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-146.03, 218.35, 94.99), 1.4, 1.8, {
      heading=0,
      minZ=93.99,
      maxZ=96.19,
      data = {
        id = "comic_store_2",
        biz = "comic_store"
      }
    })
    -- Mojito Inn
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-114.49, 6368.91, 31.47), 2.8, 2.0, {
      name="mojito_inn",
      heading=30,
      -- debugPoly=true,
      minZ=30.27,
      maxZ=32.47,
      data = {
        id = "mojito_inn"
      }
    })

    -- Split Sides Comedy Club
    -- exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-429.13, 280.32, 83.02), 2.0, 1.8, {
    --   name="split_sides",
    --   heading=356,
    --   -- debugPoly=true,
    --   minZ=81.62,
    --   maxZ=83.82,
    --   data = {
    --     id = "split_sides"
    --   }
    -- })
    -- hayes_autos
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1415.15, -451.32, 35.91), 1.0, 1.8, {
      heading = 32,
      minZ = 34.91,
      maxZ = 36.91,
      data = {
        id = "hayes_autos",
      },
    })
    -- harmony
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(1189.45, 2636.6, 38.4), 2.4, 2.4, {
      heading = 89,
      minZ = 37.4,
      maxZ = 39.8,
      data = {
        id = "harmony_repairs",
      },
    })
    -- lostmc
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(120.59, 3607.22, -26.84), 1.5, 1.5, {
      heading = 0,
      minZ = -27.84,
      maxZ = -25.84,
      data = {
        id = "lostmc",
      },
    })
    -- casino
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(998.83, 61.3, 75.06), 1.2, 1.8, {
      heading = 0,
      minZ = 75.00,
      maxZ = 77.00,
      data = {
        id = "casino",
      },
    })
    exports["np-polyzone"]:AddCircleZone("business_stash", vector3(980.52, 22.78, 71.47), 1.8, {
      useZ=true,
      data = {
        id = "casino_drinks",
        biz = "casino",
      },
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(948.21, 14.71, 116.16), 3.4, 1, {
      heading=328,
      minZ=115.16,
      maxZ=117.36,
      data = {
        id = "casino_drinks_penthouse",
        biz = "casino",
      },
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(986.67, 69.76, 70.06), 2, 2, {
      heading=15,
      minZ=69.06,
      maxZ=71.06,
      data = {
        id = "casino_poker_room",
        biz = "casino",
      },
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(2949.04, 754.26, 3.05), 3.4, 2.6, {
      heading=15,
      minZ=1.85,
      maxZ=4.05,
      data = {
        id = "dean_beach",
        biz = "casino",
        cids = {
          [1004] = true,
          [3503] = true,
        },
      },
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(796.09, -749.56, 31.27), 1.0, 1.4, {
      heading=0,
      minZ = 30.07,
      maxZ = 32.27,
      data = {
        id = "maldinis_office",
        biz = "maldinis",
      },
    })
    -- uwu
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-597.79, -1064.26, 22.34), 1.4, 2.0, {
      heading=0,
      minZ=21.14,
      maxZ=23.34,
      data = {
        id = "uwu_freezer",
        biz = "uwu_cafe",
      },
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-586.31, -1061.67, 22.34), 1.2, 1.2, {
      heading=0,
      minZ = 21.14,
      maxZ = 23.34,
      data = {
        id = "uwu_counter",
        biz = "uwu_cafe",
      },
    })
    -- gallery
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-468.7, 44.87, 46.23), 1.8, 1, {
      heading = 355,
      minZ = 45.23,
      maxZ = 47.23,
      data = {
        id = "gallery",
      },
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-466.65, 30.4, 46.23), 1.0, 1.2, {
      heading=355,
      minZ=45.23,
      maxZ=47.23,
      data = {
        id = "gallery_2",
        biz = "gallery",
      },
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-462.78, -30.56, 44.52), 2.8, 2, {
      heading=357,
      minZ=43.32,
      maxZ=45.72,
      data = {
        id = "gallery_3",
        biz = "gallery",
      },
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-470.64, 39.72, 46.23), 1.4, 1.4, {
      heading=355,
      minZ=45.03,
      maxZ=47.43,
      data = {
        id = "pca",
      },
    })
    -- wuchang
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-816.65, -696.34, 32.14), 1.0, 1.4, {
      heading = 0,
      minZ = 31.14,
      maxZ = 33.34,
      data = {
        id = "wuchang",
      },
    })
    -- wuchang
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-826.31, -732.91, 23.78), 2, 2, {
      heading=0,
      minZ=22.58,
      maxZ=24.58,
      data = {
        id = "wuchang_3",
        biz = "wuchang",
      },
    })
    -- digitalden
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(1134.34, -467.21, 66.49), 0.8, 2.4, {
      name="ddstash",
      heading=345,
      minZ=65.49,
      maxZ=67.69,
      data = {
        id = "digital_den",
      },
    })
    -- roosterranch
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1097.33, 4949.38, 218.35), 5.6, 4, {
      name="roosterranch",
      heading=340,
      minZ=217.35,
      maxZ=220.55,
      data = {
        id = "roosterranch",
      },
    })
    -- rooster
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-175.68, 307.65, 101.07), 2.6, 2.2, {
      heading=0,
      minZ=100.07,
      maxZ=102.47,
      data = {
        id = "rooster",
      },
    })
    -- btat
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(322.5, 185.41, 103.59), 1.2, 1.2, {
      name="btat",
      heading=340,
      minZ=102.59,
      maxZ=104.79,
      data = {
        id = "btat",
      },
    })
    -- pegasus
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-310.13, 179.63, 87.92), 2.8, 2.2, {
      name="pegastash",
      heading=10,
      minZ=86.92,
      maxZ=89.52,
      data = {
        id = "pegasus",
      },
    })
    -- flight school
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1866.17, 2952.99, 32.81), 5.0, 3.2, {
      name="fsstash",
      heading=60,
      minZ=31.81,
      maxZ=35.81,
      data = {
        id = "flight_school",
      },
    })
    -- le fuente blanca
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(1403.13, 1158.94, 114.33), 1.8, 1.8, {
      heading=0,
      minZ=113.33,
      maxZ=115.93,
      data = {
        id = "le_fuente_blanca",
      },
    })
    -- lsbn
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-595.3, -920.59, 29.73), 1.4, 1.6, {
      heading=0,
      minZ=28.73,
      maxZ=30.93,
      data = {
        id = "lsbn",
      },
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-155.75, 322.04, 98.48), 1.5, 2, {
      name="business_stash",
      heading=0,
      --debugPoly=true,
      minZ=97.23,
      maxZ=100.83,
      data = {
        id = "leftpanel_stash",
        biz = "rooster"
      }
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1818.97, 447.86, 128.41), 1.2, 1.6, {
      name="clean_manor",
      heading=271,
      --debugPoly=true,
      minZ=126.81,
      maxZ=130.81,
      data = {
        id = "clean_manor"
      }
    })
    exports["np-polyzone"]:AddBoxZone("business_stash", vector3(-1797.18, 439.82, 128.25), 1.0, 1.4, {
      name="clean_manor_secret",
      heading=356,
      minZ=127.05,
      maxZ=128.85,
      data = {
        id = "clean_manor_secret",
        biz = "clean_manor"
      }
    })
    --
    --
  end

  -- Clean Manor 2nd level garage
  exports["np-polyzone"]:AddBoxZone("business_cleanmanor", vector3(-1791.6, 406.11, 112.79), 10.6, 8.6, {
    heading=359,
    minZ=111.39,
    maxZ=115.39
  })

  -- Overboost
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(-1413.63, -451.0, 35.91), 1.4, 2.8, {
    heading=30,
    minZ=33.51,
    maxZ=37.51,
    data = {
      id = "overboost_drift_school",
      inventory = "42125"
    },
  })

  -- bullet club
  exports["np-polyzone"]:AddBoxZone("business_craft", vector3(-840.54, -786.48, 19.43), 1.5, 1.5, {
    data = {
      id = "the_bullet_club",
      inventory = "42126"
    },
    heading=0,
    minZ=16.83,
    maxZ=20.83
  })

  -- pit parlor
  exports["np-polytarget"]:AddBoxZone("ptat_chair_1", vector3(-1154.36, -1427.54, 4.95), 1.0, 1.5, {
    heading=25,
    minZ=1.35,
    maxZ=2.85
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("ptat_chair_1", {{
    event = "np-business:tattoo:sitChair",
    id = "ptat_chair_1",
    icon = "chair",
    label = "sit",
    parameters = { sitType = "upright" },
  }}, { distance = { radius = 3.5 }})

  exports["np-polytarget"]:AddBoxZone("ptat_chair_2", vector3(-1155.9, -1428.57, 4.95), 0.6, 1.4, {
    heading=50,
    minZ=0.75,
    maxZ=2.75
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("ptat_chair_2", {{
    event = "np-business:tattoo:sitChair",
    id = "ptat_chair_2",
    icon = "chair",
    label = "sit",
    parameters = { sitType = "laying" },
  }}, { distance = { radius = 3.5 }})

  exports["np-polytarget"]:AddBoxZone("ptat_chair_3", vector3(-1153.49, -1427.72, 4.95), 0.6, 0.6, {
    heading=30,
    minZ=0.75,
    maxZ=2.75
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("ptat_chair_3", {{
    event = "np-business:tattoo:sitChair",
    id = "ptat_chair_3",
    icon = "chair",
    label = "sit",
    parameters = { sitType = "tattooist" },
  }}, { distance = { radius = 3.5 }})

  -- Disable Eclipse Audio
  SetAmbientZoneStatePersistent("aunderarm_aiming_turf", false, true)
end)
