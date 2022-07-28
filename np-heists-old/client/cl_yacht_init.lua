YACHT_STASH_NAMES = {
  ["tf_bar_stash"] = true,
  ["tf_side_stash_1"] = true,
  ["tf_side_stash_2"] = true,
  ["tf_side_stash_3"] = true,
  ["tf_side_stash_4"] = true,
  ["tf_side_stash_5"] = true,
  ["tf_side_stash_6"] = true,
  ["ud_stash_1"] = true,
  ["md_stash_1"] = true,
  ["md_stash_2"] = true,
  ["md_stash_3"] = true,
  ["md_stash_4"] = true,
  ["md_stash_5"] = true,
  ["md_stash_6"] = true,
  ["md_stash_7"] = true,
  ["md_stash_8"] = true,
  ["md_stash_9"] = true,
  ["md_stash_10"] = true,
  ["md_stash_11"] = true,
  ["md_stash_12"] = true,
}

YACHT_STEAM_NAMES = {
  ["ld_steam_1"] = true,
  ["ld_steam_2"] = true,
  ["ld_steam_3"] = true,
  ["ld_steam_4"] = true,
}

YACHT_PHONE_NAMES = {
  ["ud_phone_1"] = true,
  ["ud_phone_2"] = true,
}

YACHT_LAPTOP_NAMES = {
  ["mf_laptop_1"] = true,
  ["mf_laptop_2"] = true,
}

YACHT_TV_NAMES = {
  ["ud_tvplayer_1"] = true,
}

YACHT_SOUND_SYSTEM_NAMES = {
  ["sound_system"] = true,
}

YACHT_ALARM_CLOCK_NAMES = {
  ["mf_alarmclock_1"] = true,
}

YACHT_HORSE_STATUE_NAMES = {
  ["mf_horse_1"] = true,
}

Citizen.CreateThread(function()
  -- targets
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2084.17, -1014.22, 8.97), 0.6, 1, {
    heading=342,
    minZ=8.37,
    maxZ=9.17,
    data = {
      id = "sound_system",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2059.04, -1022.8, 11.91), 0.6, 1, {
    heading=253,
    minZ=12.31,
    maxZ=13.11,
    data = {
      id = "ud_phone_1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2061.34, -1029.66, 11.91), 0.6, 1, {
    heading=253,
    minZ=12.31,
    maxZ=13.11,
    data = {
      id = "ud_phone_2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2052.91, -1026.99, 2.6), 0.6, 1, {
    heading=341,
    minZ=2.8,
    maxZ=3.6,
    data = {
      id = "ld_steam_1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2057.02, -1034.78, 3.01), 0.6, 1, {
    heading=341,
    minZ=3.21,
    maxZ=4.01,
    data = {
      id = "ld_steam_2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2061.13, -1024.67, 3.05), 0.6, 1, {
    heading=251,
    minZ=3.25,
    maxZ=4.05,
    data = {
      id = "ld_steam_3",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2067.1, -1024.9, 3.05), 2.2, 1.2, {
    heading=345,
    minZ=2.85,
    maxZ=4.05,
    data = {
      id = "ld_steam_4",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2079.41, -1015.98, 5.88), 0.6, 1, {
    heading=73,
    minZ=5.28,
    maxZ=6.08,
    data = {
      id = "mf_laptop_1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2081.51, -1022.41, 8.97), 0.6, 0.6, {
    heading=70,
    minZ=8.17,
    maxZ=8.77,
    data = {
      id = "mf_laptop_2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2083.61, -1019.67, 5.88), 0.6, 0.6, {
    heading=70,
    minZ=5.68,
    maxZ=6.28,
    data = {
      id = "mf_horse_1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2098.79, -1012.79, 5.88), 0.6, 0.6, {
    heading=70,
    minZ=5.48,
    maxZ=6.08,
    data = {
      id = "mf_alarmclock_1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2076.85, -1020.79, 8.97), 0.6, 0.6, {
    heading=70,
    minZ=8.37,
    maxZ=8.97,
    data = {
      id = "ud_tvplayer_1",
    },
  })

  -- hidden spots
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2096.96, -1014.14, 8.98), 0.6, 1, {
    heading=257,
    minZ=7.98,
    maxZ=8.90,
    data = {
      id = "tf_bar_stash",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2089.89, -1009.93, 8.97), 0.6, 1, {
    heading=174,
    minZ=7.97,
    maxZ=8.90,
    data = {
      id = "tf_side_stash_1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2092.17, -1009.8, 8.97), 0.6, 1, {
    heading=186,
    minZ=7.97,
    maxZ=8.90,
    data = {
      id = "tf_side_stash_2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2095.45, -1020.55, 8.97), 0.6, 1, {
    heading=146,
    minZ=7.97,
    maxZ=8.90,
    data = {
      id = "tf_side_stash_3",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2086.89, -1021.52, 8.97), 0.6, 1, {
    heading=73,
    minZ=7.97,
    maxZ=8.90,
    data = {
      id = "tf_side_stash_4",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2050.6, -1023.81, 8.97), 0.6, 1, {
    heading=78,
    minZ=7.97,
    maxZ=8.90,
    data = {
      id = "tf_side_stash_5",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2052.02, -1023.52, 8.97), 0.6, 1, {
    heading=338,
    minZ=7.97,
    maxZ=8.90,
    data = {
      id = "tf_side_stash_6",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2082.73, -1018.22, 12.78), 0.6, 1, {
    heading=253,
    minZ=11.78,
    maxZ=12.70,
    data = {
      id = "ud_stash_1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2070.43, -1020.9, 5.88), 0.6, 1, {
    heading=253,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2071.46, -1024.1, 5.88), 0.6, 1, {
    heading=253,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2077.85, -1021.97, 5.88), 0.6, 1, {
    heading=253,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_3",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2079.9, -1018.74, 5.88), 0.6, 1, {
    heading=251,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_4",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2092.32, -1019.92, 5.91), 0.6, 1, {
    heading=166,
    minZ=5.11,
    maxZ=5.98,
    data = {
      id = "md_stash_5",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2085.15, -1014.02, 5.88), 0.6, 1, {
    heading=71,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_6",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2089.77, -1009.44, 5.88), 0.6, 1, {
    heading=71,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_7",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2091.09, -1013.44, 5.88), 0.6, 1, {
    heading=71,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_8",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2091.79, -1015.79, 5.89), 0.6, 1, {
    heading=71,
    minZ=5.09,
    maxZ=5.98,
    data = {
      id = "md_stash_9",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2097.86, -1009.43, 5.88), 0.6, 1, {
    heading=71,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_10",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2101.84, -1015.25, 5.88), 0.6, 1, {
    heading=341,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_11",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_target", vector3(-2099.06, -1006.58, 5.88), 0.6, 1, {
    heading=341,
    minZ=5.08,
    maxZ=5.98,
    data = {
      id = "md_stash_12",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_start", vector3(-2055.93, -1027.5, 2.59), 1.2, 0.4, {
    heading=342,
    minZ=2.84,
    maxZ=3.44,
    data = {
      id = "1",
    },
  })
  -- loot zones
  exports["np-polytarget"]:AddBoxZone("heist_yacht_loot", vector3(-2073.52, -1019.4, 3.05), 0.4, 1, {
    heading=342,
    minZ=2.45,
    maxZ=3.45,
    data = {
      id = "1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_loot", vector3(-2074.61, -1017.52, 3.05), 0.4, 1, {
    heading=252,
    minZ=2.45,
    maxZ=3.45,
    data = {
      id = "2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_loot", vector3(-2074.13, -1015.85, 3.05), 0.4, 1, {
    heading=252,
    minZ=2.45,
    maxZ=3.45,
    data = {
      id = "3",
    },
  })
  exports["np-polytarget"]:AddBoxZone("heist_yacht_loot", vector3(-2072.21, -1014.93, 3.05), 0.4, 1, {
    heading=162,
    minZ=2.45,
    maxZ=3.45,
    data = {
      id = "4",
    },
  })

  -- interact
  function isEnabledFn(pList)
    return function(p1, pContext)
      local id = getContextId(pContext)
      return YACHT_HEIST_ACTIVE and (pList[id] and true or false)
    end
  end
  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_target', {{
    event = "np-heists:yacht:targetEntry",
    id = "heist_yacht_target_1",
    icon = "search",
    label = "Search",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = isEnabledFn(YACHT_STASH_NAMES),
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_target', {{
    event = "np-heists:yacht:targetEntry",
    id = "heist_yacht_target_2",
    icon = "smog",
    label = "Adjust Steam Settings",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = isEnabledFn(YACHT_STEAM_NAMES),
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_target', {{
    event = "np-heists:yacht:targetEntry",
    id = "heist_yacht_target_3",
    icon = "phone",
    label = "Make Call",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = isEnabledFn(YACHT_PHONE_NAMES),
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_target', {{
    event = "np-heists:yacht:targetEntry",
    id = "heist_yacht_target_4",
    icon = "laptop-code",
    label = "Insert Password",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = isEnabledFn(YACHT_LAPTOP_NAMES),
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_target', {{
    event = "np-heists:yacht:targetEntry",
    id = "heist_yacht_target_5",
    icon = "compact-disc",
    label = "Insert Disc",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = isEnabledFn(YACHT_TV_NAMES),
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_target', {{
    event = "np-heists:yacht:targetEntry",
    id = "heist_yacht_target_6",
    icon = "file-audio",
    label = "Change Station",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = isEnabledFn(YACHT_SOUND_SYSTEM_NAMES),
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_target', {{
    event = "np-heists:yacht:targetEntry",
    id = "heist_yacht_target_7",
    icon = "clock",
    label = "Change Time",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = isEnabledFn(YACHT_ALARM_CLOCK_NAMES),
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_target', {{
    event = "np-heists:yacht:targetEntry",
    id = "heist_yacht_target_8",
    icon = "horse-head",
    label = "Turn Statue",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = isEnabledFn(YACHT_HORSE_STATUE_NAMES),
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_start', {{
    event = "np-heists:yacht:startHeist",
    id = "heist_yacht_start_1",
    icon = "laptop-code",
    label = "Begin Override",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = function()
      local hasItem = exports["np-inventory"]:hasEnoughOfItem("heistpadyacht", 1, false, true)
      return hasItem
    end,
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget('heist_yacht_loot', {{
    event = "np-heists:yacht:loot",
    id = "heist_yacht_loot_1",
    icon = "hand-holding",
    label = "Search",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
  })
end)
