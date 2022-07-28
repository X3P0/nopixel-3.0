local listening, currentPrompt = false, nil
local defaultDuiUrl = 'https://i.imgur.com/5Ust2GQ.jpg'
local currentBoardUrl = 'https://i.imgur.com/5Ust2GQ.jpg'
local currentMeetingRoomBoardUrl, currentSDSOMeetingRoomBoardUrl = 'https://i.imgur.com/5Ust2GQ.jpg', 'https://i.imgur.com/jQmFuUY.png'
local inClassRoom, inMeetingRoom, inSDSOMeetingRoom = false, false, false
local dui = nil

Citizen.CreateThread(function()

  exports["np-polyzone"]:AddPolyZone("mrpd_classroom", {
    vector2(448.41372680664, -990.47613525391),
    vector2(439.50704956055, -990.55731201172),
    vector2(439.43478393555, -981.08758544922),
    vector2(448.419921875, -981.26306152344),
    vector2(450.23190307617, -983.00885009766),
    vector2(450.25042724609, -988.77667236328)
  }, {
    gridDivisions = 25,
    minZ = 34.04,
    maxZ = 37.69
  })
  exports["np-polyzone"]:AddBoxZone("mrpd_meetingroom", vector3(474.07, -995.08, 30.69), 10.2, 5.2, {
    heading=0,
    minZ=29.64,
    maxZ=32.84
  })
  

  exports["np-polyzone"]:AddBoxZone("mrpd_clothing_lockers", vector3(461.81, -997.79, 30.69), 4.4, 4.8, {
    heading=0,
    minZ=29.64,
    maxZ=32.84
  })

  exports["np-polyzone"]:AddBoxZone("mrpd_armory", vector3(481.59, -995.35, 30.69), 3.2, 0.8, {
    heading=90,
    minZ=29.69,
    maxZ=32.49
  })

  exports["np-polyzone"]:AddBoxZone("mrpd_evidence", vector3(474.84, -996.26, 26.27), 1.2, 3.0, {
    heading=90,
    minZ=25.27,
    maxZ=27.87
  })

  exports["np-polyzone"]:AddBoxZone("mrpd_trash", vector3(472.88, -996.28, 26.27), 1.2, 3.0, {
    heading=90,
    minZ=25.27,
    maxZ=27.87
  })

  exports["np-polyzone"]:AddBoxZone("mrpd_character_switcher", vector3(478.88, -983.49, 30.69), 1.35, 1.3, {
    heading=0,
    minZ=29.74,
    maxZ=32.74
  })

  -- Davis PD
  exports["np-polyzone"]:AddBoxZone("davispd_character_switcher", vector3(358.51, -1597.88, 25.45), 1.65, 4.8, {
    heading=320,
    minZ=24.45,
    maxZ=27.25
  })

  exports["np-polyzone"]:AddBoxZone("davispd_clothing_lockers", vector3(362.38, -1593.53, 25.45), 5.0, 4.2, {
    heading=320,
    minZ=24.45,
    maxZ=27.05
  })

  exports["np-polyzone"]:AddBoxZone("davispd_armory", vector3(365.28, -1603.51, 25.45), 3.2, 1.4, {
    heading=319,
    minZ=24.25,
    maxZ=26.65
  })

  -- Armory, VBPD
  exports["np-polyzone"]:AddBoxZone("vbpd_armory", vector3(-1075.05, -830.85, 19.3), 4.6, 1.2, {
    heading=308,
    minZ=18.3,
    maxZ=21.1
  })

  exports["np-polyzone"]:AddBoxZone("vbpd_clothing_lockers", vector3(-1087.41, -832.43, 19.3), 4.2, 11.2, {
    heading=308,
    minZ=18.15,
    maxZ=21.95
  })

  exports["np-polyzone"]:AddCircleZone("vbpd_character_switcher", vector3(-1081.85, -834.42, 19.3), 0.5, {
    useZ=true,
  })

  exports["np-polyzone"]:AddCircleZone("vbpd_evidence", vector3(-1099.11, -824.35, 19.3), 0.7, {
    useZ=true,
  })

  exports["np-polyzone"]:AddCircleZone("vbpd_trash", vector3(-1096.47, -818.9, 19.3), 0.3, {
    useZ=true,
  })

  exports["np-polyzone"]:AddBoxZone("sandy_clothing_lockers_character_switch", vector3(1841.77, 3679.39, 34.18), 2.6, 2.6, {
    heading=30,
    minZ=32.38,
    maxZ=36.38
  })


  exports["np-polyzone"]:AddBoxZone("sandy_evidence_trash_armory", vector3(1837.23, 3686.15, 34.19), 4.0, 3.8, {
    heading=30,
    minZ=32.59,
    maxZ=36.59
  })

  exports["np-polyzone"]:AddBoxZone("paleto_clothing_lockers_character_switch_evidence_trash_armory", vector3(-449.45, 6015.25, 37.0), 1.4, 3.0, {
    heading=44,
    minZ=35.8,
    maxZ=38.8
  })

  exports["np-polyzone"]:AddBoxZone("paleto_clothing_lockers_character_switch", vector3(-438.57, 6010.16, 37.0), 4.8, 3.6, {
    heading=316,
    minZ=35.8,
    maxZ=38.4
  })

  exports["np-polyzone"]:AddBoxZone("lamesa_clothing_lockers_character_switch_evidence_trash_armory", vector3(853.24, -1313.53, 28.24), 2, 2, {
    heading=0,
    minZ=26.24,
    maxZ=30.24
  })
  

  exports["np-polyzone"]:AddBoxZone("beaverpd_clothing_lockers_character_switch_evidence_trash_armory", vector3(387.19, 799.6, 187.46), 1.0, 2.2, {
    heading=359,
    minZ=184.86,
    maxZ=188.86
  })

  exports["np-polyzone"]:AddBoxZone("doc_clothing_lockers", vector3(1834.65, 2571.73, 46.01), 2.8, 2.2, {
    heading=0,
    minZ=45.01,
    maxZ=47.81
  })

  exports["np-polyzone"]:AddBoxZone("doc_armory", vector3(1841.37, 2573.99, 46.01), 1.6, 1.6, {
    heading=0,
    minZ=45.01,
    maxZ=47.61
  })

  exports["np-polyzone"]:AddBoxZone("doc_character_switcher", vector3(1841.34, 2569.78, 46.05), 2.2, 1.8, {
    heading=0,
    minZ=45.05,
    maxZ=47.85
  })

  -- davis pd
  exports["np-polyzone"]:AddBoxZone("davispd_evidence", vector3(361.84, -1599.58, 25.45), 2.0, 2.0, {
    heading=50,
    minZ=24.15,
    maxZ=26.95
  })

  exports["np-polyzone"]:AddBoxZone("davispd_trash", vector3(360.72, -1602.23, 25.45), 2, 1.5, {
    heading=90,
    minZ=23.35,
    maxZ=27.35
  })

  -- Prison - Bus Spawn
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(1689.371948, 2605.291992, 44.564999), 5.8, 15.0, {
    heading=0,
    minZ=44.56,
    maxZ=47.56
  })

  -- MRPD - Underground B
    exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(425.97, -980.22, 25.7), 11.6, 6.4, {
      heading=0,
      minZ=24.7,
      maxZ=29.7
    })


  -- MRPD - Bus Spawn
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(479.43, -1019.49, 27.96), 6.0, 15.0, {
    heading=0,
    minZ=26.96,
    maxZ=28.96
  })

  -- MRPD Helipads
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(466.16, -981.74, 43.69), 13.6, 46.8, {
    heading=0,
    minZ=39.89,
    maxZ=46.89
  })

  -- Vespucci PD Helipad
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(-1095.58, -834.96, 37.68), 14.0, 13.6, {
    heading=40,
    minZ=36.48,
    maxZ=40.68
  })

  -- Paleto PD Helipad
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(-475.69, 5988.67, 31.34), 14.0, 13.6, {
    heading=40,
    minZ=30.34,
    maxZ=34.54
  })

  -- VBPD Garage
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(-1131.84, -836.9, 3.75), 37.35, 62.6, {
    heading=37,
    minZ=2.55,
    maxZ=6.75
  })

  -- Paleto PD Garage
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(-474.19, 6029.99, 31.34), 28.4, 12.8, {
    heading=315,
    minZ=30.24,
    maxZ=34.24
  })

  -- Courthouse PD Shared Garage
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(-585.92, -236.39, 35.7), 36.0, 4.4, {
    heading=30,
    minZ=34.7,
    maxZ=37.9
  })

  -- Sandy PD Shared Garage Heli
  exports["np-polyzone"]:AddBoxZone("pd_shared",vector3(1853.46, 3706.41, 33.97), 10.6, 10.8, {
    heading=300,
    minZ=32.97,
    maxZ=37.57
  })
  
  -- Beaver Bush PD Shared Garage
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(374.53, 795.94, 187.28), 10, 8, {
    heading= 180.0,
    minZ=186.08,
    maxZ=191.28
  })

  -- Sandy Airfield Heli PD Shared
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(1770.36, 3239.85, 41.36), 14.0, 14.8, {
    heading=15,
    minZ=40.79,
    maxZ=45.79
  })


  -- Davis PD
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(397.73, -1623.0, 29.29), 19.0, 5.8, {
    heading=320,
    minZ=28.29,
    maxZ=31.69
  })

  -- La Mesa PD
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(843.88, -1342.51, 26.09), 7.2, 28.0, {
    heading=90,
    minZ=25.09,
    maxZ=29.69
  })

  -- Sandy PD Car Parking
  exports["np-polyzone"]:AddBoxZone("pd_shared", vector3(1825.67, 3685.59, 33.97), 27.4, 5.4, {
    heading=120,
    minZ=32.97,
    maxZ=37.37
  })
  
  exports["np-polyzone"]:AddBoxZone("pd_shared_bike", vector3(-1119.91, -859.81, 13.41), 23.8, 9.6, {
    heading=304,
    minZ=12.31,
    maxZ=17.31
  })

  exports["np-polyzone"]:AddBoxZone("pd_shared_bike", vector3(-457.98, 6044.63, 31.34), 16.2, 7.0, {
    heading=45,
    minZ=30.14,
    maxZ=35.34
  })

  -- Davis PD Shared Bike Garage
  exports["np-polyzone"]:AddBoxZone("pd_shared_bike", vector3(389.89, -1611.71, 29.29), 12.4, 6.0, {
    heading=321,
    minZ=28.29,
    maxZ=31.89
  })

  -- La Mesa PD Shared Bike Garage
  exports["np-polyzone"]:AddBoxZone("pd_shared_bike", vector3(818.87, -1347.14, 26.1), 5.4, 39.2, {
    heading=90,
    minZ=24.7,
    maxZ=28.7
  })

  -- sandy pd shared bike
  exports["np-polyzone"]:AddBoxZone("pd_shared_bike", vector3(1863.06, 3696.4, 33.97), 6.0, 12.6, {
    heading=120,
    minZ=32.97,
    maxZ=36.97
  })

  exports["np-polyzone"]:AddBoxZone("ems_shared", vector3(352.26, -588.32, 74.36), 15.8, 16.4, {
    name="emschop",
    heading=330,
    minZ=73.0,
    maxZ=76.36
  })

  exports["np-polyzone"]:AddBoxZone("ems_shared", vector3(-790.76, -1191.65, 53.03), 14.2, 13.2, {
    name="ems3",
    heading=320,
    minZ=51.03,
    maxZ=55.03
  })

  exports["np-polyzone"]:AddBoxZone("ems_shared", vector3(1217.43, -1525.4, 34.69), 16.6, 6.4, {
    name="emsrancho",
    heading=90,
    minZ=33.49,
    maxZ=39.69
  })

  -- el burro helicopter
  exports["np-polyzone"]:AddBoxZone("ems_shared", vector3(1177.98, -1474.65, 39.1), 10.4, 8.6, {
    name="emsrancho_heli",
    heading=0,
    minZ=38.21,
    maxZ=42.81
  })


  exports["np-polytarget"]:AddBoxZone("mrdp_change_picture", vector3(439.44, -985.89, 34.97), 1.0, 0.4, {
    heading=0,
    minZ=35.37,
    maxZ=36.17
  })

  exports["np-polytarget"]:AddBoxZone("mrpd_meetingroom_screen", vector3(474.02, -1001.79, 30.69), 3.6, 2.8, {
    heading=1,
    minZ=30.54,
    maxZ=32.54
  })

  exports["np-polytarget"]:AddBoxZone("sdso_meetingroom_screen", vector3(1823.7, 3666.99, 29.52), 1.0, 1.0, {
    heading=210,
    minZ=30.17,
    maxZ=32.12
  })

  exports["np-polyzone"]:AddBoxZone("sdso_meetingroom", vector3(1827.52, 3670.53, 29.52), 12.0, 15.0, {
    heading=30,
    minZ=28.07,
    maxZ=32.67
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget("mrdp_change_picture", {{
      event = "np-polce:changewhiteboardurl",
      id = 'polcechangewhiteboardurlc',
      icon = "circle",
      label = "Change URL",
      parameters = {
        room = "classroom"
      }
  }}, { distance = { radius = 2.5 } })

  exports["np-interact"]:AddPeekEntryByPolyTarget("mrpd_meetingroom_screen", {{
      event = "np-polce:changewhiteboardurl",
      id = 'polcechangewhiteboardurlm',
      icon = "circle",
      label = "Change URL",
      parameters = {
        room = "meetingroom"
      }
  }}, { distance = { radius = 2.5 } })

  exports["np-interact"]:AddPeekEntryByPolyTarget("sdso_meetingroom_screen", {{
    event = "np-polce:changewhiteboardurl",
    id = 'polcechangewhiteboardurls',
    icon = "circle",
    label = "Change URL",
    parameters = {
      room = "sdso_meetingroom"
    }
}}, { distance = { radius = 2.5 } })

end)

local EVENTS = {
  LOCKERS = 1,
  CLOTHING = 2,
  SWITCHER = 3,
  EVIDENCE = 4,
  TRASH = 5,
  ARMORY = 6
}

local zoneData = {
  mrpd_clothing_lockers = {
    promptText = "[E] Lockers & Clothes",
    menuData = {
      {
        title = "Lockers",
        description = "Access your personal locker",
        action = "np-police:handler",
        key = EVENTS.LOCKERS
      },
      {
        title = "Clothing",
        description = "Gotta look Sharp",
        action = "np-police:handler",
        key = EVENTS.CLOTHING
      }
    }
  },
  vbpd_clothing_lockers = {
    promptText = "[E] Lockers & Clothes",
    menuData = {
      {
        title = "Lockers",
        description = "Access your personal locker",
        action = "np-police:handler",
        key = EVENTS.LOCKERS
      },
      {
        title = "Clothing",
        description = "Gotta look Sharp",
        action = "np-police:handler",
        key = EVENTS.CLOTHING
      }
    }
  },
  davispd_clothing_lockers = {
    promptText = "[E] Lockers & Clothes",
    menuData = {
      {
        title = "Lockers",
        description = "Access your personal locker",
        action = "np-police:handler",
        key = EVENTS.LOCKERS
      },
      {
        title = "Clothing",
        description = "Gotta look Sharp",
        action = "np-police:handler",
        key = EVENTS.CLOTHING
      }
    }
  },
  sandy_clothing_lockers_character_switch = {
    promptText = "[E] Lockers & Clothes",
    menuData = {
      {
        title = "Lockers",
        description = "Access your personal locker",
        action = "np-police:handler",
        key = EVENTS.LOCKERS
      },
      {
        title = "Clothing",
        description = "Gotta look Sharp",
        action = "np-police:handler",
        key = EVENTS.CLOTHING
      },
      {
        title = "Character switch",
        description = "Go bowling with your cousin",
        action = "np-police:handler",
        key = EVENTS.SWITCHER
      }
    }
  },
  doc_clothing_lockers = {
    promptText = "[E] Lockers & Clothes",
    menuData = {
      {
        title = "Lockers",
        description = "Access your personal locker",
        action = "np-police:handler",
        key = EVENTS.LOCKERS
      },
      {
        title = "Clothing",
        description = "Gotta look Sharp",
        action = "np-police:handler",
        key = EVENTS.CLOTHING
      }
    }
  },
  mrpd_character_switcher = {
    promptText = "[E] Switch Character",
    menuData = {
      {
        title = "Character switch",
        description = "Go bowling with your cousin",
        action = "np-police:handler",
        key = EVENTS.SWITCHER
      }
    }
  },
  davispd_character_switcher = {
    promptText = "[E] Switch Character",
    menuData = {
      {
        title = "Character switch",
        description = "Go bowling with your cousin",
        action = "np-police:handler",
        key = EVENTS.SWITCHER
      }
    }
  },
  vbpd_character_switcher = {
    promptText = "[E] Switch Character",
    menuData = {
      {
        title = "Character switch",
        description = "Go bowling with your cousin",
        action = "np-police:handler",
        key = EVENTS.SWITCHER
      }
    }
  },
  doc_character_switcher = {
    promptText = "[E] Switch Character",
    menuData = {
      {
        title = "Character switch",
        description = "Go bowling with your cousin",
        action = "np-police:handler",
        key = EVENTS.SWITCHER
      }
    }
  },
  sandy_evidence_trash_armory = {
    promptText = "[E] Station Services",
    menuData = {
      {
        title = "Armory",
        description = "WEF - Weapons, Equipment, Fun!",
        action = "np-police:handler",
        key = EVENTS.ARMORY
      },
      {
        title = "Evidence",
        description = "Drop off some evidence",
        action = "np-police:handler",
        key = EVENTS.EVIDENCE
      },
      {
        title = "Trash",
        description = "Where Spaghetti Code belongs",
        action = "np-police:handler",
        key = EVENTS.TRASH
      }
    }
  },
  mrpd_trash = {
    promptText = "[E] Trash"
  },
  vbpd_trash = {
    promptText = "[E] Trash"
  },
  davispd_trash = {
    promptText = "[E] Trash"
  },
  mrpd_armory = {
    promptText = "[E] Armory"
  },
  vbpd_armory = {
    promptText = "[E] Armory"
  },
  davispd_armory = {
    promptText = "[E] Armory"
  },
  doc_armory = {
    promptText = "[E] Armory"
  },
  mrpd_evidence = {
    promptText = "[E] Evidence"
  },
  vbpd_evidence = {
    promptText = "[E] Evidence"
  },
  davispd_evidence = {
    promptText = "[E] Evidence"
  },
  doc_trash = {
    promptText = "[E] Trash"
  },
  doc_trash2 = {
    promptText = "[E] Trash"
  },
  paleto_clothing_lockers_character_switch = {
    promptText = "[E] Station Services",
    menuData = {
      {
        title = "Lockers",
        description = "Access your personal locker",
        action = "np-police:handler",
        key = EVENTS.LOCKERS
      },
      {
        title = "Clothing",
        description = "Gotta look Sharp",
        action = "np-police:handler",
        key = EVENTS.CLOTHING
      },
      {
        title = "Character switch",
        description = "Go bowling with your cousin",
        action = "np-police:handler",
        key = EVENTS.SWITCHER
      }
    }
  },
  paleto_clothing_lockers_character_switch_evidence_trash_armory = {
    promptText = "[E] Station Services",
    menuData = {
      {
        title = "Armory",
        description = "WEF - Weapons, Equipment, Fun!",
        action = "np-police:handler",
        key = EVENTS.ARMORY
      },
      {
        title = "Evidence",
        description = "Drop off some evidence",
        action = "np-police:handler",
        key = EVENTS.EVIDENCE
      },
      {
        title = "Trash",
        description = "Where Spaghetti Code belongs",
        action = "np-police:handler",
        key = EVENTS.TRASH
      }
    }
  },
  lamesa_clothing_lockers_character_switch_evidence_trash_armory = {
    promptText = "[E] Station Services",
    menuData = {
      {
        title = "Lockers",
        description = "Access your personal locker",
        action = "np-police:handler",
        key = EVENTS.LOCKERS
      },
      {
        title = "Clothing",
        description = "Gotta look Sharp",
        action = "np-police:handler",
        key = EVENTS.CLOTHING
      },
      {
        title = "Armory",
        description = "WEF - Weapons, Equipment, Fun!",
        action = "np-police:handler",
        key = EVENTS.ARMORY
      },
      {
        title = "Evidence",
        description = "Drop off some evidence",
        action = "np-police:handler",
        key = EVENTS.EVIDENCE
      },
      {
        title = "Trash",
        description = "Where Spaghetti Code belongs",
        action = "np-police:handler",
        key = EVENTS.TRASH
      },
      {
        title = "Character switch",
        description = "Go bowling with your cousin",
        action = "np-police:handler",
        key = EVENTS.SWITCHER
      },
    }
  },
  beaverpd_clothing_lockers_character_switch_evidence_trash_armory = {
    promptText = "[E] Station Services",
    menuData = {
      {
        title = "Lockers",
        description = "Access your personal locker",
        action = "np-police:handler",
        key = EVENTS.LOCKERS
      },
      {
        title = "Clothing",
        description = "Gotta look Sharp",
        action = "np-police:handler",
        key = EVENTS.CLOTHING
      },
      {
        title = "Armory",
        description = "WEF - Weapons, Equipment, Fun!",
        action = "np-police:handler",
        key = EVENTS.ARMORY
      },
      {
        title = "Evidence",
        description = "Drop off some evidence",
        action = "np-police:handler",
        key = EVENTS.EVIDENCE
      },
      {
        title = "Trash",
        description = "Where Spaghetti Code belongs",
        action = "np-police:handler",
        key = EVENTS.TRASH
      },
      {
        title = "Character switch",
        description = "Go bowling with your cousin",
        action = "np-police:handler",
        key = EVENTS.SWITCHER
      },
    }
  }
}

RegisterUICallback("np-police:handler", function(data, cb)
  local eventData = data.key
  local location = currentPrompt ~= nil and string.match(currentPrompt, "(.-)_") or ''
  local job = exports["isPed"]:isPed("myjob")
  if eventData == EVENTS.LOCKERS and (job == "police" or job == "doc") then
    local cid = exports["isPed"]:isPed("cid")
    TriggerEvent("server-inventory-open", "1", ("personalStorage-%s-%s"):format(location, cid))
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
  elseif eventData == EVENTS.CLOTHING then
    exports["np-ui"]:hideInteraction()
    Wait(500)
    TriggerEvent("np-clothing:openClothing", false, false)
  elseif eventData == EVENTS.SWITCHER then
    isCop = false
    TransitionToBlurred(500)
    DoScreenFadeOut(500)
    Wait(1000)
    TriggerEvent("np-base:clearStates")
    exports["np-base"]:getModule("SpawnManager"):Initialize()
    Wait(1000)
  elseif eventData == EVENTS.EVIDENCE and (job == "police" or job == "doc") then
    TriggerEvent("server-inventory-open", "1", ("%s_evidence"):format(location))
  elseif eventData == EVENTS.TRASH and (job == "police" or job == "doc") then
    TriggerEvent("server-inventory-open", "1", ("%s_trash"):format(location))
  elseif eventData == EVENTS.ARMORY and (job == "police" or job == "doc") then
    TriggerEvent("server-inventory-open", "10", "Shop")
  end
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)

local function listenForKeypress(pZone)
  listening = true
  Citizen.CreateThread(function()
    while listening do
      if IsControlJustReleased(0, 38) then
        local job = exports["isPed"]:isPed("myjob")
        if pZone == "mrpd_clothing_lockers" or pZone == "vbpd_clothing_lockers" or pZone == "sandy_clothing_lockers_character_switch" or pZone == "doc_clothing_lockers" or pZone == "paleto_clothing_lockers_character_switch_evidence_trash_armory" or pZone == "lamesa_clothing_lockers_character_switch_evidence_trash_armory" or pZone == "davispd_clothing_lockers" or pZone == "paleto_clothing_lockers_character_switch" then
          exports["np-ui"]:showContextMenu(zoneData[pZone].menuData)
        elseif pZone == "beaverpd_clothing_lockers_character_switch_evidence_trash_armory" and (job == "police" or job == "doc") then
          exports["np-ui"]:showContextMenu(zoneData[pZone].menuData)
        elseif pZone == "mrpd_character_switcher" or pZone == "vbpd_character_switcher" or pZone == "sandy_evidence_trash_armory" or pZone == 'doc_character_switcher' or pZone == 'davispd_character_switcher' then
          exports["np-ui"]:showContextMenu(zoneData[pZone].menuData)
        elseif (pZone == "mrpd_armory" or pZone == "vbpd_armory" or pZone == "doc_armory" or pZone == "davispd_armory") and (job == "police" or job == "doc") then
          TriggerEvent("server-inventory-open", "10", "Shop")
        elseif pZone == "mrpd_trash" or pZone == "vbpd_trash" or pZone == "doc_trash" or pZone == "davispd_trash" or pZone == "doc_trash2" and (job == "police" or job == "doc") then
          TriggerEvent("server-inventory-open", "1", pZone)
        elseif pZone == "mrpd_evidence" or pZone == "vbpd_evidence" or pZone == "davispd_evidence" and (job == "police" or job == "doc") then
          TriggerEvent("server-inventory-open", "1", pZone)
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
        end
      end
      Wait(0)
    end
  end)
end

AddEventHandler("np-polyzone:enter", function(zone)
  local currentZone = zoneData[zone]
  if zone == "mrpd_classroom" then
    if not dui then
      dui = exports["np-lib"]:getDui(currentBoardUrl)
      AddReplaceTexture('prop_planning_b1', 'prop_base_white_01b', dui.dictionary, dui.texture)
    else
      exports["np-lib"]:changeDuiUrl(dui.id, currentBoardUrl)
    end
    inClassRoom = true
  elseif zone == "mrpd_meetingroom" then
    if not dui then
      dui = exports["np-lib"]:getDui(currentMeetingRoomBoardUrl)
      AddReplaceTexture('prop_planning_b1', 'prop_base_white_01b', dui.dictionary, dui.texture)
    else
      exports["np-lib"]:changeDuiUrl(dui.id, currentMeetingRoomBoardUrl)
    end
    inMeetingRoom = true
  elseif zone == "sdso_meetingroom" then
    if not dui then
      dui = exports["np-lib"]:getDui(currentSDSOMeetingRoomBoardUrl, 512, 256)
      AddReplaceTexture('v_ilev_mm_screen2', 'script_rt_tvscreen', dui.dictionary, dui.texture)
    else
      exports["np-lib"]:changeDuiUrl(dui.id, currentSDSOMeetingRoomBoardUrl)
    end
    inSDSOMeetingRoom = true
  elseif currentZone then --and isCop
    currentPrompt = zone
    local prompt = type(currentZone.promptText) == 'function' and currentZone.promptText() or currentZone.promptText
    exports["np-ui"]:showInteraction(prompt)
    listenForKeypress(zone)
  end
end)

AddEventHandler("np-polyzone:exit", function(zone)
  local currentZone = zoneData[zone]
  if zone == "mrpd_classroom" then
    RemoveReplaceTexture('prop_planning_b1', 'prop_base_white_01b')
    if dui ~= nil then
      exports["np-lib"]:releaseDui(dui.id)
      dui = nil
    end
    inClassRoom = false
  elseif zone == "mrpd_meetingroom" then
    RemoveReplaceTexture('prop_planning_b1', 'prop_base_white_01b')
    if dui ~= nil then
      exports["np-lib"]:releaseDui(dui.id)
      dui = nil
    end
    inMeetingRoom = false
  elseif zone == "sdso_meetingroom" then
    RemoveReplaceTexture('v_ilev_mm_screen2', 'script_rt_tvscreen')
    if dui ~= nil then
      exports["np-lib"]:releaseDui(dui.id)
      dui = nil
    end
    inSDSOMeetingRoom = false
  elseif currentZone then
    exports["np-ui"]:hideInteraction()
    listening = false
    currentPrompt = nil
  end
end)

RegisterNetEvent("police:changewhiteboardcli")
AddEventHandler("police:changewhiteboardcli", function(pUrl, pRoom)
  if pRoom == "classroom" and inClassRoom and dui then
    currentBoardUrl = pUrl
    exports["np-lib"]:changeDuiUrl(dui.id, currentBoardUrl)
  elseif pRoom == "meetingroom" and inMeetingRoom and dui then
    currentMeetingRoomBoardUrl = pUrl
    exports["np-lib"]:changeDuiUrl(dui.id, currentMeetingRoomBoardUrl)
  elseif pRoom == "sdso_meetingroom" and inSDSOMeetingRoom and dui then
    currentSDSOMeetingRoomBoardUrl = pUrl
    exports["np-lib"]:changeDuiUrl(dui.id, currentSDSOMeetingRoomBoardUrl)
  end
end)

RegisterUICallback("np-ui:policechangeurl", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')
  TriggerServerEvent("police:changewhiteboard", data.values.url, data.hiddenItems.room)
end)

AddEventHandler("np-polce:changewhiteboardurl", function(pParams)
  exports['np-ui']:openApplication('textbox', {
    callbackUrl = 'np-ui:policechangeurl',
    key = 1,
    items = {
      {
        icon = "circle",
        label = "URL",
        name = "url",
      },
    },
    hiddenItems = {
      room = pParams.room
    },
    show = true,
  })
end)

AddEventHandler('np-inventory:itemUsed', function(itemId, itemInfo, inventoryName, slot)
  if itemId ~= "pdevidencebag" then return end
  local metaData = json.decode(itemInfo)
  if not metaData.inventoryId then
    exports['np-ui']:openApplication('textbox', {
      callbackUrl = 'np-ui:saveEvidenceBag',
      key = { slot = slot },
      items = {
        {
          icon = "circle",
          label = "Bag Name",
          name = "name",
        },
      },
      show = true,
    })
    return
  end
  TriggerEvent("inventory-open-container", metaData.inventoryId, metaData.slots, metaData.weight)
end)

RegisterUICallback("np-ui:saveEvidenceBag", function (data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')

  local genId = tostring(math.random(10000, 99999999))
  local invId = "container-" .. genId .. "-evidence bag"
  local metaData = json.encode({
    inventoryId = invId,
    bagName = data.values.name,
    slots = 15,
    weight = 10,
    _hideKeys = {'inventoryId', 'slots', 'weight'},
  })
  TriggerEvent('inventory:updateItem', 'pdevidencebag', data.key.slot, metaData)
end)
