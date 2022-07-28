SIGN_ON_ZONES = {
  {
    vector3(-1191.49, -900.58, 13.98), 0.2, 1.4, {
      heading=304,
      minZ=14.08,
      maxZ=15.48,
      data = {
        biz = 'burger_shot',
        id = 'bs_main',
        type = 'burger_shot'
      }
    }
  },
  {
    vector3(-1679.07, -1094.64, 13.17), 1.8, 0.4, {
      heading=130,
      minZ=13.17,
      maxZ=14.37,
      data = {
        biz = 'burger_shot',
        id = 'bs_pier',
        type = 'burger_shot_pier'
      }
    }
  },
  {
    vector3(-594.2, -1052.47, 22.34), 1.8, 0.2, {
      heading=0,
      minZ=22.34,
      maxZ=23.74,
      data = {
        biz = 'uwu_cafe',
        id = 'uwu_1',
      }
    }
  },
  {
    vector3(-579.46, -893.21, 25.72), 0.4, 1.8, {
      heading=0,
      minZ=26.12,
      maxZ=27.52,
      data = {
        biz = 'maldinis',
        id = 'mald_1',
      }
    }
  },
  {
    vector3(-162.25, 327.26, 98.48), 0.6, 1, {
      heading=0,
      minZ=98.08,
      maxZ=98.68,
      data = {
        biz = 'rooster',
        id = 'rr_1',
      }
    }
  }
}

BUFF_ZONES = {
  {
    vector3(-579.2, -1062.65, 23.11), 75.0, {
      useZ=false,
      data = {
        id = 'uwu_cafe',
      }
    }
  },
  {
    vector3(-585.54, -897.21, 25.72), 75.0, {
      useZ=false,
      data = {
        id = 'maldinis'
      }
    }
  },
  {
    vector3(-1193.54, -893.53, 13.98), 75.0, {
      useZ=false,
      data = {
        id = 'burger_shot'
      }
    }
  },
  {
    vector3(-163.79, 302.25, 99.42), 75.0, {
      useZ=false,
      data = {
        id = 'rooster'
      }
    }
  },
  {
    vector3(1784.22, 2552.33, 45.67), 50.0, {
      useZ=false,
      data = {
        id = 'prison_cooks'
      }
    }
  }
}

MENU_ZONES = {
  {
    vector3(-1177.81, -896.13, 13.98), 0.4, 0.4, {
      heading=305,
      minZ=13.78,
      maxZ=14.18,
      data = {
        id = "burger_shot", -- biz code
      },
    }
  },
  {
    vector3(-155.55, 316.96, 98.87), 0.4, 0.4, {
      heading=265,
      minZ=98.67,
      maxZ=99.07,
      data = {
        id = "rooster", -- biz code
      },
    }
  },
  {
    vector3(-593.24, -888.06, 30.2), 0.4, 0.6, {
      heading=0,
      minZ=30.0,
      maxZ=30.2,
      data = {
        id = "maldinis", -- biz code
      },
    }
  },
  {
    vector3(-596.22, -1052.89, 22.34), 0.4, 0.4, {
      heading=0,
      minZ=22.14,
      maxZ=22.34,
      data = {
        id = "uwu_cafe", -- biz code
      },
    }
  },
  {
    vector3(1783.41, 2560.05, 45.67), 1.4, 1.0, {
      heading=0,
      minZ = 45.67,
      maxZ = 46.07,
      data = {
        id = "prison_cooks", -- biz code,
        jobs = { 'doc', 'police' },
      },
    }
  },
}

CREATE_ZONES = {
  {
    vector3(-1198.28, -897.26, 13.98), 0.8, 0.6, {
      heading=212,
      minZ=13.73,
      maxZ=14.73,
      data = {
        id = "bs1",
        restaurant = "burger_shot", -- biz code
        foodType = "main",
      },
    }
  },
  {
    vector3(-1200.84, -899.9, 13.98), 1.0, 0.4, {
      heading=212,
      minZ=13.73,
      maxZ=15.13,
      data = {
        id = "bs2",
        restaurant = "burger_shot", -- biz code
        foodType = "side",
      },
    }
  },
  {
    vector3(-1199.62, -895.28, 13.98), 0.6, 0.4, {
      heading=212,
      minZ=14.23,
      maxZ=14.63,
      data = {
        id = "bs3",
        restaurant = "burger_shot", -- biz code
        foodType = "drink",
      },
    }
  },
  {
    vector3(-1203.33, -895.66, 13.98), 1.0, 0.4, {
      heading=212,
      minZ=13.23,
      maxZ=15.63,
      data = {
        id = "bs4",
        restaurant = "burger_shot", -- biz code
        foodType = "dessert",
      },
    }
  },
  {
    vector3(-1685.24, -1087.85, 13.16), 0.6, 0.4, {
      heading=221,
      minZ=12.91,
      maxZ=13.91,
      data = {
        id = "pierbs1",
        restaurant = "burger_shot", -- biz code
        foodType = "main",
      },
    }
  },
  {
    vector3(-1684.46, -1086.03, 13.16), 0.6, 0.4, {
      heading=221,
      minZ=12.91,
      maxZ=13.91,
      data = {
        id = "pierbs2",
        restaurant = "burger_shot", -- biz code
        foodType = "side",
      },
    }
  },
  {
    vector3(-1685.39, -1090.07, 13.16), 0.6, 0.4, {
      heading=221,
      minZ=12.91,
      maxZ=13.91,
      data = {
        id = "pierbs3",
        restaurant = "burger_shot", -- biz code
        foodType = "drink",
      },
    }
  },
  {
    vector3(-1681.41, -1089.95, 13.16), 0.6, 0.4, {
      heading=221,
      minZ=12.91,
      maxZ=13.91,
      data = {
        id = "pierbs4",
        restaurant = "burger_shot", -- biz code
        foodType = "dessert",
      },
    }
  },
  {
    vector3(-173.84, 292.49, 99.2), 1.4, 1.0, {
      heading=0,
      minZ=99.2,
      maxZ=99.6,
      data = {
        id = "rr1",
        restaurant = "rooster", -- biz code
        foodType = "main",
      },
    }
  },
  {
    vector3(-172.59, 290.02, 99.2), 0.8, 0.8, {
      heading=265,
      minZ=99.05,
      maxZ=99.45,
      data = {
        id = "rr2",
        restaurant = "rooster", -- biz code
        foodType = "side",
      },
    }
  },
  {
    vector3(-173.92, 302.03, 98.53), 0.8, 0.8, {
      heading=265,
      minZ=98.38,
      maxZ=98.78,
      data = {
        id = "rr3",
        restaurant = "rooster", -- biz code
        foodType = "drink",
      },
    }
  },
  {
    vector3(-173.69, 297.64, 99.2), 0.8, 0.8, {
      heading=265,
      minZ=98.05,
      maxZ=99.45,
      data = {
        id = "rr4",
        restaurant = "rooster", -- biz code
        foodType = "dessert",
      },
    }
  },
  {
    vector3(-581.82, -899.0, 25.72), 0.8, 0.4, {
      heading=0,
      minZ=25.52,
      maxZ=25.92,
      data = {
        id = "maldinis1",
        restaurant = "maldinis", -- biz code
        foodType = "main",
      },
    }
  },
  {
    vector3(-581.94, -897.92, 25.72), 0.7, 0.7, {
      heading=265,
      minZ=25.52,
      maxZ=26.12,
      data = {
        id = "maldinis2",
        restaurant = "maldinis", -- biz code
        foodType = "side",
      },
    }
  },
  {
    vector3(-579.61, -901.12, 25.72), 0.7, 0.7, {
      heading=265,
      minZ=25.52,
      maxZ=26.32,
      data = {
        id = "maldinis3",
        restaurant = "maldinis", -- biz code
        foodType = "drink",
      },
    }
  },
  {
    vector3(-585.11, -898.75, 25.72), 0.7, 0.7, {
      heading=265,
      minZ=26.0,
      maxZ=27.0,
      data = {
        id = "maldinis4",
        restaurant = "maldinis", -- biz code
        foodType = "dessert",
      },
    }
  },
  {
    vector3(-590.97, -1056.51, 22.36), 0.8, 0.6, {
      heading=0,
      minZ=22.21,
      maxZ=22.41,
      data = {
        id = "uwu1",
        restaurant = "uwu_cafe", -- biz code
        foodType = "main",
      },
    }
  },
  {
    vector3(-591.21, -1063.16, 22.36), 1.6, 1.0, {
      heading=0,
      minZ=22.16,
      maxZ=22.56,
      data = {
        id = "uwu2",
        restaurant = "uwu_cafe", -- biz code
        foodType = "side",
      },
    }
  },
  {
    vector3(-587.02, -1061.82, 22.34), 1, 1, {
      heading=0,
      minZ=22.14,
      maxZ=22.94,
      data = {
        id = "uwu3",
        restaurant = "uwu_cafe", -- biz code
        foodType = "drink",
      },
    }
  },
  {
    vector3(-590.94, -1059.73, 22.34), 1.2, 1.0, {
      heading=0,
      minZ=21.34,
      maxZ=23.74,
      data = {
        id = "uwu4",
        restaurant = "uwu_cafe", -- biz code
        foodType = "dessert",
      },
    }
  },
  {
    vector3(1780.9, 2565.04, 45.67), 1.4, 1.4, {
      heading=0,
      minZ = 45.47,
      maxZ = 45.87,
      data = {
        id = "prison1",
        restaurant = "prison_cooks", -- biz code
        foodType = "main",
      },
    }
  },
  {
    vector3(1776.85, 2563.67, 45.67), 2.0, 0.8, {
      heading=0,
      minZ = 45.47,
      maxZ = 45.87,
      data = {
        id = "prison2",
        restaurant = "prison_cooks", -- biz code
        foodType = "side",
      },
    }
  },
  {
    vector3(1778.12, 2560.33, 45.67), 0.4, 1.4, {
      heading=0,
      minZ = 45.47,
      maxZ = 46.47,
      data = {
        id = "prison3",
        restaurant = "prison_cooks", -- biz code
        foodType = "drink",
      },
    }
  },
  {
    vector3(1786.66, 2564.35, 45.67), 1.8, 2.2, {
      heading=0,
      minZ = 44.67,
      maxZ = 47.07,
      data = {
        id = "prison4",
        restaurant = "prison_cooks", -- biz code
        foodType = "dessert",
      },
    }
  },
}

REGISTER_ZONES = {
  {
    vector3(-1196.33, -890.75, 13.98), 0.8, 1.0, {
      heading=35,
      minZ=13.78,
      maxZ=14.78,
      data = {
        id="bs_2",
        biz="burger_shot"
      }
    }
  },
  {
    vector3(-1195.26, -892.33, 13.98), 0.6, 1.0, {
      heading=35,
      minZ=13.78,
      maxZ=14.78,
      data = {
        id="bs_3",
        biz="burger_shot"
      }
    }
  },
  {
    vector3(-1194.28, -893.9, 13.98), 0.6, 1.0, {
      heading=35,
      minZ=13.78,
      maxZ=14.78,
      data = {
        id="bs_4",
        biz="burger_shot"
      }
    }
  },
  {
    vector3(-1687.26, -1091.37, 13.16), 1.2, 3.6, {
        heading=130,
        minZ=12.96,
        maxZ=13.56,
      data = {
        id="bs_5",
        biz="burger_shot"
      }
    }
  },
  {
    vector3(-1687.26, -1091.37, 13.16), 1.2, 3.6, {
      heading=130,
      minZ=12.96,
      maxZ=13.56,
      data = {
        id="bs_6",
        biz="burger_shot"
      }
    }
  },
  {
    vector3(-584.08, -1058.72, 22.34), 0.6, 1.2, {
      heading=0,
      minZ=22.34,
      maxZ=22.74,
      data = {
        id="uwu_1",
        biz="uwu_cafe"
      },
    },
  },
  {
    vector3(-584.02, -1061.48, 22.34), 0.6, 1.0, {
      heading=0,
      minZ=22.34,
      maxZ=22.74,
      data = {
        id="uwu_2",
        biz="uwu_cafe",
      },
    },
  },
  {
    vector3(-580.08, -886.61, 25.72), 0.6, 0.8, {
      heading=0,
      minZ=25.87,
      maxZ=26.27,
      data = {
        id="maldini_1",
        biz="maldinis",
      },
    },
  },
  {
    vector3(-171.01, 304.21, 98.52), 1.4, 0.6, {
      heading=0,
      minZ=98.52,
      maxZ=99.12,
      data = {
        id="rr_1",
        biz="rooster",
      },
    }
  },
  {
    vector3(-171.05, 300.79, 98.52), 1.2, 1.0, {
      heading=0,
      minZ=98.52,
      maxZ=98.92,
      data = {
        id="rr_2",
        biz="rooster",
      },
    }
  }
}

SHELF_ZONES = {
  {
    vector3(-587.33, -1059.59, 22.34), 2.4, 1.2, {
      heading=0,
      minZ=22.24,
      maxZ=22.74,
      data = {
        id="uwu_1",
        biz="uwu_cafe",
      },
    },
  },
  {
    vector3(-577.11, -886.0, 25.72), 2.0, 0.8, {
      heading=0,
      minZ=21.92,
      maxZ=25.92,
      data = {
        id="mald_1",
        biz="maldinis",
      },
    },
  },
  {
    vector3(-1197.52, -894.32, 14.0), 5.0, 1.4, {
      heading=34,
      minZ=13.0,
      maxZ=15.4,
      data = {
        id="bs_1",
        biz="burger_shot",
      },
    }
  },
  {
    vector3(-1686.16, -1088.73, 13.16), 1.0, 1.8, {
      heading=130,
      minZ=12.16,
      maxZ=14.16,
      data = {
        id="bs_2",
        biz="burger_shot",
      },
    }
  },
  {
    vector3(-174.0, 290.96, 99.2), 1.6, 1.0, {
      heading=0,
      minZ=99.0,
      maxZ=99.8,
      data = {
        id="rr_1",
        biz="rooster",
      },
    }
  }
}

FRIDGE_ZONES = {
  {
    vector3(-590.6, -1058.59, 22.34), 1.2, 0.2, {
      heading=0,
      minZ=21.34,
      maxZ=23.54,
      data = {
        id='uwu_1',
        biz="uwu_cafe",
      }
    }
  },
  {
    vector3(-587.98, -1067.06, 22.34), 1.6, 0.8, {
      heading=0,
      minZ=21.74,
      maxZ=23.14,
      data = {
        id='uwu_2',
        biz="uwu_cafe",
      }
    }
  },
  {
    vector3(-585.09, -901.62, 25.72), 1.4, 1.0, {
      heading=0,
      minZ=23.12,
      maxZ=27.12;
      data = {
        id='mald_1',
        biz="maldinis",
      }
    }
  },
  {
    vector3(-1196.67, -901.91, 13.98), 0.6, 1.4, {
      heading=214,
      minZ=13.18,
      maxZ=15.38,
      data = {
        id='bs_1',
        biz="burger_shot",
      }
    }
  },
  {
    vector3(-1687.3, -1086.29, 13.16), 0.8, 1.4, {
      heading=40,
      minZ=12.16,
      maxZ=14.36,
      data = {
        id='bs_2',
        biz="burger_shot",
      }
    }
  },
  {
    vector3(-171.38, 296.13, 99.2), 2.0, 1, {
      heading=0,
      minZ=98.2,
      maxZ=99.6,
      data = {
        id='rr_1',
        biz="rooster",
      }
    }
  }
}

--bento box, murder meal, etc.

local MURDER_MEAL = {
  restaurant = "burger_shot",
  box_item_id = 'murdermeal',
  name = 'murder meal',
  slots = 5,
  weight = 11,
  toy = 'randomtoy3'
}

local CUSTOM_TOY_BUSINESSES = {
  ['burger_shot'] = true,
}
TAKEOUT_ZONES = {
  {
    vector3(-585.51, -1055.45, 22.34), 1.2, 2.2, {
      heading=0,
      minZ=21.34,
      maxZ=23.74,
      data = {
        id = "uwu_1",
        restaurant = "uwu_cafe",
        box_item_id = 'bentobox',
        name = 'bento box',
        slots = 5,
        weight = 11,
        toy = 'uwutoy'
      },
    }
  },
  {
    vector3(-578.33, -892.21, 25.72), 2.0, 0.6, {
      heading=0,
      minZ=25.67,
      maxZ=26.27,
      data = {
        id = "mald_1",
        restaurant = "maldinis",
        box_item_id = 'pizzabox',
        name = 'pizza box',
        slots = 5,
        weight = 11,
        toy = nil
      },
    }
  },
  {
    vector3(-1688.73, -1087.47, 13.16), 0.8, 1.8, {
      heading=40,
      minZ=12.76,
      maxZ=13.56,
      data = MURDER_MEAL,
    }
  },
  {
    vector3(-1197.72, -891.31, 13.98), 0.8, 1.8, {
      heading=214,
      minZ=13.78,
      maxZ=14.58,
      data = MURDER_MEAL,
    }
  },
  {
    vector3(-1196.74, -904.8, 14.0), 2.8, 1.6, {
      heading=35,
      minZ=12.8,
      maxZ=14.6,
      data = MURDER_MEAL,
    }
  },
  {
    vector3(-172.62, 289.58, 99.2), 1.0, 1.6, {
      heading=0,
      minZ=98.4,
      maxZ=100.0,
      data = {
        id = "rr_1",
        restaurant = "rooster",
        box_item_id = 'cockbox',
        name = 'cock in a box',
        slots = 5,
        weight = 11,
        toy = 'cockegg'
      },
    }
  }
}

Citizen.CreateThread(function()
  SERVER_CODE = exports["np-config"]:GetServerCode()
  -- manage food menus
  for _, zone in ipairs(MENU_ZONES) do
    exports["np-polytarget"]:AddBoxZone("restaurant_manage_food_menu", table.unpack(zone))
  end

  exports["np-interact"]:AddPeekEntryByPolyTarget("restaurant_manage_food_menu",  {{
    event = "np-restaurants:manageFoodMenu",
    id = "restaurantfoodmenu",
    icon = "circle",
    label = "Manage Food",
  },
  {
    event = "np-restaurants:manageDailyMenu",
    id = "restaurantdailymenu",
    icon = "circle",
    label = "Manage Menu",
  }}, {
    distance = { radius = 2.0 },
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget("restaurant_manage_food_menu", {
  {
    event = "np-restaurants:manageToyMenu",
    id = "toyrestmenu",
    icon = "circle",
    label = "Manage Toys",
  }}, {
    distance = { radius = 2.0 },
    isEnabled = function(pEntity, pContext)
      return pContext.zones and pContext.zones["restaurant_manage_food_menu"] and CUSTOM_TOY_BUSINESSES[pContext.zones["restaurant_manage_food_menu"].id]
    end
  })

  for _, zone in ipairs(BUFF_ZONES) do
    exports['np-polyzone']:AddCircleZone("restaurant_buff_zone", table.unpack(zone))
  end

  for _, zone in ipairs(SHELF_ZONES) do
    exports['np-polytarget']:AddBoxZone("restaurant_shelf", table.unpack(zone))
  end

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_shelf', {{
    event = "np-restaurants:shelfPrompt",
    id = "restaurant_shelf_storage",
    icon = "box-open",
    label = _L("restaurant-open", "Open")
  }}, { distance = { radius = 3.5 } })

  exports["np-interact"]:AddPeekEntryByPolyTarget("restaurant_shelf", {{
    event = "np-restaurants:silentAlarm",
    id = "restaurant_silent_alarm",
    icon = "bell",
    label = _L("restaurant-alert-police", "Alert Police")
  }}, { distance = { radius = 3.0 }, isEnabled = isSignedOn })

  for _, zone in ipairs(REGISTER_ZONES) do
    exports["np-polytarget"]:AddBoxZone("restaurant_registers", table.unpack(zone))
  end

  -- Drive Thru window register
  exports["np-polyzone"]:AddBoxZone("restaurant_registers", vector3(-1193.81, -907.8, 13.98), 4.0, 2.4, {
    heading=355,
    minZ=12.98,
    maxZ=15.38,
    data = {
      id="bs_1",
      biz="burger_shot"
    }
  })

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_registers', {{
    event = "np-restaurants:makePayment",
    id = "restaurant_register_payment",
    icon = "cash-register",
    label = _L("restaurant-make-payment", "Make Payment"),
    parameters = {}
  }}, { distance = { radius = 3.5 } })

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_registers', {{
    event = "np-restaurants:chargeCustomer",
    id = "restaurant_register_charge",
    icon = "credit-card",
    label = _L("restaurant-charge-customer", "Charge Customer"),
    parameters = {}
  }}, { distance = { radius = 3.5 }, isEnabled = isSignedOn })

  -- sign on prompts
  for _, zone in ipairs(SIGN_ON_ZONES) do
    exports["np-polytarget"]:AddBoxZone("restaurant_sign_on", table.unpack(zone))
  end

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_sign_on', {{
      event = "np-restaurants:signOnPrompt",
      id = "restaurants_sign_on",
      icon = "clock",
      label = _L("restaurant-clock-in", "Clock In"),
      parameters = {}
  }}, { distance = { radius = 3.5 } , isEnabled = function(pEntity, pContext) return not SIGNED_IN end })

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_sign_on', {{
      event = "np-restaurants:signOffPrompt",
      id = "restaurants_sign_off",
      icon = "clock",
      label = _L("restaurant-clock-in", "Clock Out"),
      parameters = {}
  }}, { distance = { radius = 3.5 } , isEnabled = isSignedOn })

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_sign_on', {{
      event = "np-restaurants:viewActiveEmployees",
      id = "restaurants_active_employees",
      icon = "list",
      label = _L("restaurant-view-employee-list", "View Active Employees"),
  }}, { distance = { radius = 3.5 }, isEnabled = function(pEntity, pContext) return pContext.zones['restaurant_sign_on'] and exports['np-business']:IsEmployedAt(pContext.zones['restaurant_sign_on'].biz) end })

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_sign_on', {{
    event = "np-restaurants:setWorkHours",
    id = "restaurants_set_work_hours",
    icon = "history",
    label = _L("restaurant-set-work-hours", "Set Work Hours"),
  }}, { distance = { radius = 3.5 }, isEnabled = function(pEntity, pContext)
      return pContext.zones['restaurant_sign_on'] and exports['np-business']:HasPermission(pContext.zones['restaurant_sign_on'].biz, 'hire')
    end
  })

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_sign_on', {{
    event = "np-restaurants:viewWorkHours",
    id = "restaurants_view_work_hours",
    icon = "user-clock",
    label = _L("restaurant-view-work-hours", "View Work Hours"),
  }}, { distance = { radius = 3.5 }, isEnabled = function(pEntity, pContext)
      return pContext.zones['restaurant_sign_on'] and exports['np-business']:IsEmployedAt(pContext.zones['restaurant_sign_on'].biz)
    end
  })

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_sign_on', {{
    event = "np-restaurants:getHeadset",
    id = "restaurants_get_headset",
    icon = "headset",
    label = _L("restaurant-get-headset", "Get Headset"),
  }}, { distance = { radius = 3.5 }, isEnabled = function(pEntity, pContext)
      return pContext.zones['restaurant_sign_on'] and pContext.zones['restaurant_sign_on'].biz == 'burger_shot' and exports['np-business']:IsEmployedAt(pContext.zones['restaurant_sign_on'].biz)
    end
  })

  -- main dishes
  for _, zone in ipairs(CREATE_ZONES) do
    exports["np-polytarget"]:AddBoxZone("restaurant_create_food_item", table.unpack(zone))
  end

  exports["np-interact"]:AddPeekEntryByPolyTarget("restaurant_create_food_item",  {{
    event = "np-restaurants:createFoodItem",
    id = "restaurantfooditems",
    icon = "utensils",
    label = "Prepare Food",
  }}, {
    distance = { radius = 2.0 }, isEnabled = isSignedOn,
  })

  for _,zone in ipairs(FRIDGE_ZONES) do
    exports["np-polytarget"]:AddBoxZone("restaurant_fridge", table.unpack(zone))
  end

  exports['np-interact']:AddPeekEntryByPolyTarget('restaurant_fridge', {{
    event = "np-restaurants:openFridge",
    id = "restaurantfridge",
    icon = "box",
    label = _L("restaurant-open", "Open")
  }}, { distance = { radius = 3.5 }, isEnabled = isSignedOn })

  for _,zone in ipairs(TAKEOUT_ZONES) do
    exports["np-polytarget"]:AddBoxZone("restaurant_takeout", table.unpack(zone))
  end

  exports["np-interact"]:AddPeekEntryByPolyTarget("restaurant_takeout",  {{
    event = "np-restaurants:getTakeoutItem",
    id = "restauranttakeout",
    icon = "boxes",
    label = _L("restaurant-get-box", "get box"),
  }}, {
    distance = { radius = 2.0 }, isEnabled = isSignedOn,
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget("restaurant_takeout",  {{
    event = "np-restaurants:getToyItem",
    id = "restauranttoyitem",
    icon = "parachute-box",
    label = _L("restaurant-get-box", "get toys"),
  }}, {
    distance = { radius = 2.0 }, isEnabled = function(pEntity, pContext) return isSignedOn() and pContext.zones['restaurant_takeout'] and pContext.zones['restaurant_takeout'].restaurant ~= 'maldinis' end,
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget("restaurant_takeout",  {{
    event = "np-restaurants:getCustomToyItem",
    id = "restaurantcustomtoyitem",
    icon = "paint-brush",
    label = _L("restaurant-get-box", "get custom toys"),
  }}, {
    distance = { radius = 2.0 }, isEnabled = function(pEntity, pContext) return isSignedOn() and pContext.zones['restaurant_takeout'] and CUSTOM_TOY_BUSINESSES[pContext.zones['restaurant_takeout'].restaurant] end,
  })

  exports["np-interact"]:AddPeekEntryByModel({ `p_v_43_safe_s` }, {
    {
      id = "restaurant_safe_view",
      event = "np-restaurants:viewSafeCash",
      icon = "wallet",
      label = "Check Cash Amount",
    },
    {
      id = "restaurant_safe_take",
      event = "np-restaurants:takeSafeCash",
      icon = "money-bill",
      label = "Take Cash Envelope",
    },
  }, { distance = { radius = 5.0 }, isEnabled = function(pEntity, pContext)
    return pContext.meta and pContext.meta.data and pContext.meta.data.metadata.isBusinessSafe and exports['np-business']:HasPermission(pContext.meta.data.metadata.business, 'craft_access')
  end})

  exports["np-interact"]:AddPeekEntryByModel({ `p_v_43_safe_s` }, {
    {
      id = "restaurant_safe_crack",
      event = "np-restaurants:crackSafe",
      icon = "unlock",
      label = "crack safe",
    },
  }, { distance = { radius = 5.0 }, isEnabled = function(pEntity, pContext)
    return pContext.meta and pContext.meta.data and pContext.meta.data.metadata.isBusinessSafe and exports["np-inventory"]:hasEnoughOfItem("safecrackingkit", 1, false, true)
  end})

  exports['np-polyzone']:AddBoxZone("restaurant_bs_drivethru", vector3(-1207.32, -898.81, 13.04), 8.0, 6.4, {
    heading = 35,
    minZ = 12.04,
    maxZ = 15.44,
    data = {
      id = '1'
    }
  })
end)
