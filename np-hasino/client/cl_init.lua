local interiorSetNamesUtil = {
  ["util_clean"] = { "set_xee_casino_utility", 982.18, 14.77, 51.22 },
  ["util_tun_end"] = { "set_xee_casino_tun_end", 0 },
  ["util_broke"] = { "set_xee_casino_utility_broken", 982.18, 14.77, 51.22 },
  ["util_tun_end_broke"] = { "set_xee_casino_tun_end_broken", 0 },
}
RegisterNetEvent("np-heists:casino:entitySetSwapUtil", function(sets)
  local interiors = {}
  for _, set in pairs(interiorSetNamesUtil) do
    local cInteriorId = (not set[3]) and set[2] or GetInteriorAtCoords(set[2], set[3], set[4])
    DeactivateInteriorEntitySet(cInteriorId, set[1])
  end
  for _, setName in pairs(sets) do
    local set = interiorSetNamesUtil[setName]
    local cInteriorId = not set[3] and set[2] or GetInteriorAtCoords(set[2], set[3], set[4])
    interiors[cInteriorId] = true
    ActivateInteriorEntitySet(cInteriorId, set[1])
  end
  for cInteriorId, _ in pairs(interiors) do
    RefreshInterior(cInteriorId)
  end
end)

Citizen.CreateThread(function()
  while true do
    local obj = GetClosestObjectOfType(981.05139, 10.1867103, 50.25782, 1.0, 702767871, 0, 0, 0)
    Wait(1000)
    if obj ~= 0 then
      local interior = GetInteriorFromEntity(obj)
      Wait(1000)
      if (interior ~= 0) and (interiorSetNamesUtil["util_tun_end"][2] == 0) then
        interiorSetNamesUtil["util_tun_end"][2] = interior
        interiorSetNamesUtil["util_tun_end_broke"][2] = interior
        TriggerServerEvent("np-heists:casino:getTunnelSet")
      end
    end
    Wait(30000)
  end
  -- print(interior, GetInteriorFromEntity(PlayerPedId()), GetInteriorAtCoords(GetEntityCoords(PlayerPedId())))
  -- while true do
  --   local cInteriorId = GetInteriorAtCoords(GetEntityCoords(PlayerPedId()))
  --   print(cInteriorId, 132098)
  --   Wait(1000)
  -- end
end)

local extraPed = nil
Citizen.CreateThread(function()
  local wasInVaultRoom = false
  local interiorCache = GetInteriorAtCoords(1011.42, 31.29, 66.03)
  while true do
    local idle = 2500
    local ped = PlayerPedId()
    local interior = GetInteriorFromEntity(ped)
    local roomHash = GetRoomKeyFromEntity(ped)
    if
      (interior == interiorCache and roomHash == 1301445169)
      or (wasInVaultRoom and interior == 0 and roomHash == 0)
    then
      wasInVaultRoom = true
      idle = 100
      ForceRoomForEntity(ped, interiorCache, 1301445169)
      ForceRoomForGameViewport(interiorCache, 1301445169)
      if extraPed then
        ForceRoomForEntity(extraPed, interiorCache, 1301445169)
        ForceRoomForGameViewport(interiorCache, 1301445169)
      end
    else
      wasInVaultRoom = false
      idle = 2500
    end
    Citizen.Wait(idle)
  end
end)
AddEventHandler("np-grapple:addPedId", function(pedId)
  extraPed = pedId
end)

Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("hasino_backupgenerator", vector3(994.54, 18.94, 63.46), 0.6, 0.4, {
    heading=325,
    minZ=62.86,
    maxZ=63.86,
    data = {
      id = "1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("hasino_backupgenerator", vector3(996.17, 21.72, 63.46), 0.6, 0.4, {
    heading=325,
    minZ=62.86,
    maxZ=63.86,
    data = {
      id = "2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("hasino_backupgenerator", vector3(1001.62, 26.99, 63.46), 0.6, 0.4, {
    heading=240,
    minZ=62.86,
    maxZ=63.86,
    data = {
      id = "3",
    },
  })
  exports["np-polytarget"]:AddBoxZone("hasino_backupgenerator", vector3(1004.73, 25.16, 63.46), 0.6, 0.4, {
    heading=240,
    minZ=62.86,
    maxZ=63.86,
    data = {
      id = "4",
    },
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_backupgenerator", {{
    event = "np-heists:casino:backupGenerator",
    id = "hasino_bkup_gen",
    icon = "user-secret",
    label = "Configure Panel",
    parameters = {}
  }}, { distance = { radius = 1.5 }})

  exports["np-polytarget"]:AddBoxZone("hasino_s_d_entry", vector3(936.77, -53.7, 21.57), 0.4, 0.4, {
    heading=335,
    minZ=21.82,
    maxZ=22.22,
    data = {
      blockInteractHint = true,
    },
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_s_d_entry", {{
    event = "np-heists:casino:sdKeypad",
    id = "hasino_s_d_entry",
    icon = "user-secret",
    label = "Open Door",
    parameters = {}
  }}, { distance = { radius = 1.5 }})
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_s_d_entry", {{
    event = "np-heists:casino:sdKeypadFlashlight",
    id = "hasino_s_d_entry_flash",
    icon = "circle",
    label = "Grab Flashlight",
    parameters = {}
  }}, { distance = { radius = 1.5 }})

  -- sec comps
  exports["np-polytarget"]:AddBoxZone("hasino_sec_comp", vector3(1014.12, 8.85, 71.47), 0.6, 0.6, {
    heading=330,
    minZ=71.02,
    maxZ=71.42,
    data = {
      id = "inner",
    },
  })
  -- exports["np-polytarget"]:AddBoxZone("hasino_sec_comp", vector3(1016.4, 9.99, 71.47), 0.6, 0.6, {
  --   heading=330,
  --   minZ=71.02,
  --   maxZ=71.42,
  --   data = {
  --     id = "mini",
  --   },
  -- })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_sec_comp", {{
    event = "np-hasino:secInnerDoor",
    id = "hasino_sec_inner_door",
    icon = "user-secret",
    label = "Access Computer",
    parameters = {}
  }}, { distance = { radius = 1.5 }})

  -- exec offices
  exports["np-polytarget"]:AddBoxZone("hasino_exec_office_pc", vector3(997.73, 53.82, 75.07), 0.4, 0.6, {
    heading=330,
    minZ=74.67,
    maxZ=75.07,
    data = {
      blockInteractHint = true,
      id = "1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("hasino_exec_office_pc", vector3(1006.57, 60.26, 75.07), 0.4, 0.6, {
    heading=330,
    minZ=74.67,
    maxZ=75.07,
    data = {
      blockInteractHint = true,
      id = "2",
    },
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_exec_office_pc", {{
    event = "np-hasino:accessExecOfficeComputer",
    id = "hasino_sec_exec_offices",
    icon = "user-secret",
    label = "Access Computer",
    parameters = {}
  }}, {
    distance = { radius = 2.0 },
    isEnabled = function()
      return ARE_EXEC_OFFICE_COMPUTERS_AVAILABLE
    end,
  })

  exports["np-polytarget"]:AddBoxZone("hasino_mini_vault_keypad", vector3(1004.96, 9.18, 71.47), 0.6, 0.4, {
    heading=335,
    minZ=71.87,
    maxZ=72.47,
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_mini_vault_keypad", {{
    event = "np-hasino:accessCodeMiniVault",
    id = "hasino_sec_mini_vault",
    icon = "user-secret",
    label = "Input Access Code",
    parameters = {}
  }}, {
    distance = { radius = 1.5 },
  })

  exports["np-polytarget"]:AddBoxZone("hasino_mini_vault_keycard", vector3(1002.83, 7.24, 71.47), 1.0, 0.6, {
    heading=325,
    minZ=71.27,
    maxZ=71.67,
    data = {
      blockInteractHint = true,
    },
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_mini_vault_keycard", {{
    event = "np-hasino:pickupExecutiveKeycard",
    id = "hasino_sec_exec_keycard",
    icon = "user-secret",
    label = "Grab Keycard",
    parameters = {}
  }}, {
    distance = { radius = 1.5 },
    isEnabled = function()
      return not EXECUTIVE_KEYCARD_PICKED_UP
    end,
  })

  exports["np-polyzone"]:AddCircleZone("hasino_lower_vault", vector3(993.53, -4.18, -7.66), 28.0, {
    useZ=true,
  })

  exports["np-polytarget"]:AddBoxZone("hasino_lower_computer", vector3(1007.93, 13.45, -9.05), 2.2, 1.2, {
    heading=146,
    minZ=-9.55,
    maxZ=-7.55,
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_lower_computer", {{
    event = "np-hasino:accessLowerComputer",
    id = "hasino_lower_access_computer",
    icon = "user-secret",
    label = "Inner Vault Controls",
    parameters = {}
  }}, {
    distance = { radius = 1.5 },
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_lower_computer", {{
    event = "np-hasino:loginLowerComputer",
    id = "hasino_lower_login_computer",
    icon = "user",
    label = "Login",
    parameters = {}
  }}, {
    distance = { radius = 1.5 },
    isEnabled = function()
      return not IsLVComputerLoggedIn
    end,
  })

  exports["np-polytarget"]:AddBoxZone("hasino_elevator_rappel", vector3(1015.39, 31.32, 62.41), 3.2, 2.3, {
    heading=239,
    minZ=61.41,
    maxZ=63.41,
    data = {
      id="rappel_1",
    }
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_elevator_rappel", {{
    event = "np-hasino:rappelDownElevator",
    id = "hasino_elevator_rappel",
    icon = "swatchbook",
    label = "Rappel",
    parameters = {}
  }}, {
    distance = { radius = 1.5 },
    isEnabled = function()
      -- check for vault rope item here
      return true
    end,
  })

  exports["np-polyzone"]:AddBoxZone("hasino_elevator_rappel", vector3(1014.52, 30.17, 74.06), 0.8, 1.2, {
    name="rappel",
    heading=149,
    minZ=72.81,
    maxZ=75.31,
    data = {
      blockInteractHint = true,
      id="rappel_2",
    }
  })

  -- elevators
  exports["np-polytarget"]:AddBoxZone("hasino_elevator_force_open", vector3(1014.5, 30.41, 75.06), 0.6, 0.8, {
    heading=330,
    minZ=75.06,
    maxZ=75.66,
    data = {
      blockInteractHint = true,
      id = "upper",
    },
  })
  exports["np-polytarget"]:AddBoxZone("hasino_elevator_force_open", vector3(1013.12, 27.62, -8.53), 0.6, 0.8, {
    heading=330,
    minZ=-8.53,
    maxZ=-7.93,
    data = {
      blockInteractHint = true,
      id = "lower",
    },
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_elevator_force_open", {{
    event = "np-hasino:elevatorForceOpen",
    id = "hasino_force_open_elevator",
    icon = "circle",
    label = "Force Open",
    parameters = {}
  }}, {
    distance = { radius = 1.5 },
    isEnabled = function()
      -- check elevators can be forced open
      local hasKeyCard = exports['np-inventory']:hasEnoughOfItem('casinoexeckeycard', 1, false, true)
      return hasKeyCard
    end,
  })
  exports["np-polytarget"]:AddBoxZone("hasino_elevator_force_open_lower", vector3(1014.66, 30.06, -5.95), 0.6, 1, {
    heading=330,
    minZ=-6.95,
    maxZ=-6.75,
  })
  exports["np-interact"]:AddPeekEntryByPolyTarget("hasino_elevator_force_open_lower", {{
    event = "np-hasino:elevatorDownForceOpen",
    id = "hasino_force_open_elevator_down",
    icon = "circle",
    label = "Open Emergency Hatch",
    parameters = {},
  }}, {
    distance = { radius = 4.0 },
  })

  exports['np-polyzone']:AddBoxZone("hasino_elevator_shaft", vector3(1011.95, 30.2, -14.05), 7.7, 10.5, {
    heading=149,
    minZ=-14.55,
    maxZ=80.45
  })

  exports["np-interact"]:AddPeekEntryByModel({ `tr_prop_tr_usb_drive_01a` }, {{
    event = "np-hasino:pickupUSB",
    id = "np-hasino:pickupUSB",
    icon = "hand-holding",
    label = "Pickup",
    parameters = {},
  }}, {
    distance = { radius = 2.0 },
    isEnabled = function(pEntity, pContext)
      return pContext.meta
    end,
  })
end)

AddEventHandler("np-heists:casino:sdKeypad", function()
  RPC.execute("np-heists:casino:sdKeypad")
end)
AddEventHandler("np-heists:casino:sdKeypadFlashlight", function()
  TriggerEvent("player:receiveItem", "2343591895", 1)
end)
