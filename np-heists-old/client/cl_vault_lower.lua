
IS_LOWER_VAULT_ON_COOLDOWN = false
local keypadCoords = vector3(271.77,231.05,97.69)
local keypadHeading = 334.09
local bicBoiVaultDoorStates = nil
local upperVaultEntityState = nil
local cityPowerState = true

local keypadHash = 623406777
local activeKeypadId = nil
local keypadLocations = {
  {
    coords = vector3(286.8705, 227.4326, 98.27712),
    id = 1,
  },
  {
    coords = vector3(289.1876, 227.4275, 98.27712),
    id = 2,
  },
  {
    coords = vector3(286.5231, 220.1748, 98.27712),
    id = 3,
  },
  {
    coords = vector3(284.7573, 221.6077, 98.27712),
    id = 4,
  },
}

function VaultLowerCanUsePanel()
    local playerCoords = GetEntityCoords(PlayerPedId())
    return #(playerCoords - keypadCoords) < 1.0
end

function VaultLowerUsePanel(laptopId)
    local canOpen, message = RPC.execute("heists:vaultLowerDoorAttempt", activeKeypad, laptopId)
    if not canOpen then
        TriggerEvent("DoLongHudText", message, 2)
        return
    end
    
    local success = Citizen.Await(UseBankPanel(keypadCoords, keypadHeading, "vault_lower", true))

    if not success then
        RPC.execute("np-heists:vaultLowerPanelFail")
        return
    end

    TriggerEvent("inventory:removeItemByMetaKV", "heistlaptop1", 1, "id", laptopId)
    RPC.execute("heists:vaultLowerDoorOpen")
    local trolleyNames = {
        "vault_lower_cash_1",
        "vault_lower_cash_2",
        "vault_lower_cash_3",
        "vault_lower_cash_4",
        "vault_lower_cash_5",
        "vault_lower_cash_6",
        "vault_lower_cash_7",
    }
    Citizen.CreateThread(function()
        for idx, v in pairs(trolleyNames) do
            local trolleyConfig = GetTrolleyConfig(v)
            if idx > 4 and math.random() > 0.5 then
              SpawnTrolley(trolleyConfig.goldCoords, "gold", trolleyConfig.goldHeading)
            else
              SpawnTrolley(trolleyConfig.cashCoords, "cash", trolleyConfig.cashHeading)
            end
        end
    end)
end

function refreshVaultDoor()
    RequestIpl("np_int_placement_ch_interior_6_dlc_casino_vault_milo_")
    local interiorid = GetInteriorAtCoords(259.2812, 203.5071, 96.77954)
    for k, s in pairs(bicBoiVaultDoorStates) do
        DisableInteriorProp(interiorid, k)
    end
    for k, s in pairs(bicBoiVaultDoorStates) do
        if s then
            EnableInteriorProp(interiorid, k)
        end
    end
    RefreshInterior(interiorid)

    RequestIpl("hei_hw1_02_interior_2_heist_ornate_bank_milo_")
    interiorid = GetInteriorAtCoords(247.913, 218.042, 105.283)
    for k, s in pairs(upperVaultEntityState) do
      DisableInteriorProp(interiorid, k)
    end
    for k, s in pairs(upperVaultEntityState) do
      if s then
        EnableInteriorProp(interiorid, k)
      end
    end
    RefreshInterior(interiorid)
end

RegisterNetEvent("np-heists:swapLowerVaultIPL")
AddEventHandler("np-heists:swapLowerVaultIPL", function(state, uState)
    bicBoiVaultDoorStates = state
    upperVaultEntityState = uState
    refreshVaultDoor()
end)

Citizen.CreateThread(function()
    local result = RPC.execute("np-heists:getVaultLowerState")
    bicBoiVaultDoorStates = result.doorState
    upperVaultEntityState = result.upperVaultEntityState
    cityPowerState = result.cityPowerState
    IS_LOWER_VAULT_ON_COOLDOWN = not result.lasersActive
    if not cityPowerState then
      TriggerEvent("weather:blackout", true)
    end
    refreshVaultDoor()
end)

RegisterNetEvent("sv-heists:cityPowerState")
AddEventHandler("sv-heists:cityPowerState", function(state)
    cityPowerState = state
end)

exports("CityPowerState", function ()
  return cityPowerState
end)

AddEventHandler("np-polyzone:enter", function(name)
    if name ~= "vault_lower_entrance" then return end
    RPC.execute("np-heists:lowerVaultEntranceEnter")
end)

AddEventHandler("heists:vaultLowerTrolleyGrab", function(loc, type)
    local canGrab = RPC.execute("np-heists:vaultLowerCanGrabTrolley", loc, type)
    if canGrab then
        Loot(type)
        TriggerEvent("DoLongHudText", "You discarded the counterfeit items", 1)
        RPC.execute("np-heists:payoutTrolleyGrab", loc, type)
    else
        TriggerEvent("DoLongHudText", "You can't do that yet...", 2)
    end
end)

Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("lower_vault_keypad", vector3(286.53, 220.17, 97.69), 0.4, 0.4, {
    heading=0,
    minZ=98.09,
    maxZ=98.49,
    data = {
      id = "kp_1",
    },
  })
  exports["np-polytarget"]:AddBoxZone("lower_vault_keypad", vector3(284.7, 221.63, 97.69), 0.4, 0.4, {
    heading=340,
    minZ=98.09,
    maxZ=98.49,
    data = {
      id = "kp_2",
    },
  })
  exports["np-polytarget"]:AddBoxZone("lower_vault_keypad", vector3(286.83, 227.45, 97.69), 0.4, 0.4, {
    heading=340,
    minZ=98.09,
    maxZ=98.49,
    data = {
      id = "kp_3",
    },
  })
  exports["np-polytarget"]:AddBoxZone("lower_vault_keypad", vector3(289.21, 227.46, 97.69), 0.4, 0.4, {
    heading=325,
    minZ=98.09,
    maxZ=98.49,
    data = {
      id = "kp_4",
    },
  })
  exports['np-interact']:AddPeekEntryByPolyTarget('lower_vault_keypad', {{
    event = "np-heists:lowerVaultPanelPush",
    id = "lowervaultpanelpush",
    icon = "circle",
    label = "Enter Code",
    parameters = {},
  }}, {
    distance = { radius = 1.5 },
  })
end)

local publicGameFinishedEndpointNumbers = 'np-ui:heistsLVPublicMinigameNumbersEndpoint'
local activePanelId = 0
RegisterUICallback(publicGameFinishedEndpointNumbers, function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  RPC.execute("np-heists:lowerVaultPanelPublicPush", activePanelId, data.success)
  activePanelId = 0
end)
AddEventHandler("np-heists:lowerVaultPanelPush", function(p1, p2, pArgs)
  local id = pArgs.zones["lower_vault_keypad"].id
  exports['np-ui']:openApplication('textbox', {
    callbackUrl = 'np-ui:heists:lowerVaultPanel',
    key = id,
    items = {
      {
        icon = "user-secret",
        label = "Access Code",
        name = "code",
      },
    },
    show = true,
  })
end)

RegisterUICallback("np-ui:heists:lowerVaultPanel", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')
  local currentKeypadId = data.key
  RPC.execute("heists:lowerVaultPanelPush", currentKeypadId, data.values.code)
  local animSettings = {
    time = 2500,
    dictionary = "anim@amb@business@meth@meth_monitoring_cooking@monitoring@",
    name = "look_around_v5_monitor",
    flag = 1,
    text = "Pressing buttons",
  }
  local animation = AnimationTask:new(
    PlayerPedId(), 'normal', animSettings.text, animSettings.time, animSettings.dictionary, animSettings.name, animSettings.flag
  )
  animation:start()
end)

--
local gameFinishedEndpointNumbers = 'np-ui:heistsLVMinigameNumbersEndpoint'
AddEventHandler("np-heists:vaultLowerKeyboardInteract", function()
  local hasUsb = exports['np-inventory']:hasEnoughOfItem('vcomputerusb', 1, false, true)
  if not hasUsb then
    TriggerEvent("DoLongHudText", "Missing PC USB stick", 2)
    return
  end
  RPC.execute("np-heists:registerLVUsbUse")
  exports["np-ui"]:openApplication("minigame-numbers", {
    gameFinishedEndpoint = gameFinishedEndpointNumbers,
    gameTimeoutDuration = 14000,
    numberOfDigits = 12,
  })
end)
RegisterUICallback(gameFinishedEndpointNumbers, function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  if data.success then
    TriggerEvent("inventory:removeItem", "vcomputerusb", 1)
    Wait(500)
    TriggerEvent("player:receiveItem", "lvaccesscodes", 1, true)
  end
end)

-- door / screen fx stuff
-- local allScreenEffects = {
--     ["SwitchHUDIn"] = true,
--     ["SwitchHUDOut"] = true,
--     ["FocusIn"] = true,
--     ["FocusOut"] = true,
--     ["MinigameEndNeutral"] = true,
--     ["MinigameEndTrevor"] = true,
--     ["MinigameEndFranklin"] = true,
--     ["MinigameEndMichael"] = true,
--     ["MinigameTransitionOut"] = true,
--     ["MinigameTransitionIn"] = true,
--     ["SwitchShortNeutralIn"] = true,
--     ["SwitchShortFranklinIn"] = true,
--     ["SwitchShortTrevorIn"] = true,
--     ["SwitchShortMichaelIn"] = true,
--     ["SwitchOpenMichaelIn"] = true,
--     ["SwitchOpenFranklinIn"] = true,
--     ["SwitchOpenTrevorIn"] = true,
--     ["SwitchHUDMichaelOut"] = true,
--     ["SwitchHUDFranklinOut"] = true,
--     ["SwitchHUDTrevorOut"] = true,
--     ["SwitchShortFranklinMid"] = true,
--     ["SwitchShortMichaelMid"] = true,
--     ["SwitchShortTrevorMid"] = true,
--     ["DeathFailOut"] = true,
--     ["CamPushInNeutral"] = true,
--     ["CamPushInFranklin"] = true,
--     ["CamPushInMichael"] = true,
--     ["CamPushInTrevor"] = true,
--     ["SwitchOpenMichaelIn"] = true,
--     ["SwitchSceneFranklin"] = true,
--     ["SwitchSceneTrevor"] = true,
--     ["SwitchSceneMichael"] = true,
--     ["SwitchSceneNeutral"] = true,
--     ["MP_Celeb_Win"] = true,
--     ["MP_Celeb_Win_Out"] = true,
--     ["MP_Celeb_Lose"] = true,
--     ["MP_Celeb_Lose_Out"] = true,
--     ["DeathFailNeutralIn"] = true,
--     ["DeathFailMPDark"] = true,
--     ["DeathFailMPIn"] = true,
--     ["MP_Celeb_Preload_Fade"] = true,
--     ["PeyoteEndOut"] = true,
--     ["PeyoteEndIn"] = true,
--     ["PeyoteIn"] = true,
--     ["PeyoteOut"] = true,
--     ["MP_race_crash"] = true,
--     ["SuccessFranklin"] = true,
--     ["SuccessTrevor"] = true,
--     ["SuccessMichael"] = true,
--     ["DrugsMichaelAliensFightIn"] = true,
--     ["DrugsMichaelAliensFight"] = true,
--     ["DrugsMichaelAliensFightOut"] = true,
--     ["DrugsTrevorClownsFightIn"] = true,
--     ["DrugsTrevorClownsFight"] = true,
--     ["DrugsTrevorClownsFightOut"] = true,
--     ["HeistCelebPass"] = true,
--     ["HeistCelebPassBW"] = true,
--     ["HeistCelebEnd"] = true,
--     ["HeistCelebToast"] = true,
--     ["MenuMGHeistIn"] = true,
--     ["MenuMGTournamentIn"] = true,
--     ["MenuMGSelectionIn"] = true,
--     ["ChopVision"] = true,
--     ["DMT_flight_intro"] = true,
--     ["DMT_flight"] = true,
--     ["DrugsDrivingIn"] = true,
--     ["DrugsDrivingOut"] = true,
--     ["SwitchOpenNeutralFIB5"] = true,
--     ["HeistLocate"] = true,
--     ["MP_job_load"] = true,
--     ["RaceTurbo"] = true,
--     ["MP_intro_logo"] = true,
--     ["HeistTripSkipFade"] = true,
--     ["MenuMGHeistOut"] = true,
--     ["MP_corona_switch"] = true,
--     ["MenuMGSelectionTint"] = true,
--     ["SuccessNeutral"] = true,
--     ["ExplosionJosh3"] = true,
--     ["SniperOverlay"] = true,
--     ["RampageOut"] = true,
--     ["Rampage"] = true,
--     ["Dont_tazeme_bro"] = true,
--     ["DeathFailOut"] = true,
-- }

-- -- delete this stuff before prod
-- local cleanToggle = true
-- RegisterCommand("vault:swap", function(s, args)
--     if cleanToggle then
--         bicBoiVaultDoorStates = {
--             ["np_vault_broken"] = true,
--             ["np_vault_clean"] = false,
--         }
--         cleanToggle = false
--     else
--         bicBoiVaultDoorStates = {
--             ["np_vault_broken"] = false,
--             ["np_vault_clean"] = true,
--         }
--         cleanToggle = true
--     end
    
--     refreshVaultDoor()

--     if not cleanToggle and not args[1] then
        
--         DoScreenFadeOut(0)
--         Wait(32)
--         DoScreenFadeIn(1000)
--         Wait(32)
--         StartScreenEffect("DrugsTrevorClownsFightOut", 5000, true)
--         Wait(5000)
--         StopScreenEffect("DrugsTrevorClownsFightOut")
--         DoScreenFadeOut(0)
--         Wait(0)
--         DoScreenFadeIn(400)
--         Wait(1000)
--     end
-- end)
