local inCasino = false
local postGateTriggered = false
local carOnShow = `neo`
local carOnShowAppearence = json.decode('{"colors":{"primary":61,"secondary":146,"pearlescent":157,"wheels":143,"tyre":{"r":255,"g":255,"b":255},"neon":{"r":255,"g":0,"b":255},"xenon":255,"dashboard":65,"interior":13},"tint":3,"neon":{"left":false,"right":false,"front":false,"back":false},"extras":[],"wheelType":0,"oldLivery":-1,"plateIndex":1}')
local carOnShowMods = json.decode('{"Spoilers":4,"FrontBumper":6,"RearBumper":2,"SideSkirt":0,"Exhaust":12,"Frame":5,"Grille":1,"Hood":5,"Fender":-1,"RightFender":-1,"Roof":3,"Engine":3,"Brakes":2,"Transmission":3,"Horns":-1,"Suspension":-1,"Armor":-1,"UNK17":0,"Turbo":1,"UNK19":0,"TireSmoke":0,"UNK21":0,"XenonHeadlights":0,"FrontWheels":60,"BackWheels":-1,"PlateHolder":-1,"VanityPlates":-1,"InteriorTrim":-1,"Ornaments":-1,"Dashboard":-1,"Dials":-1,"DoorSpeakers":-1,"Seats":-1,"SteeringWheel":-1,"ShiftLeavers":-1,"Plaques":-1,"Speakers":-1,"Trunk":-1,"Hydraulics":-1,"EngineBlock":-1,"AirFilter":-1,"Struts":-1,"ArchCover":-1,"Aerials":-1,"ExteriorTrim":-1,"Tank":-1,"Windows":-1,"UNK47":-1,"Livery":4}')
local carOnShow2 = `panamera17turbo`
local carOnShow2Active = false
local polyEntryTimeout = false
local enterFirstTime = true
local entranceTeleportCoords = vector3(1089.73, 206.36, -48.99 + 0.05)
local exitTeleportCoords = vector3(934.46, 45.83, 81.1 + 0.05)
local inVRHeadset = false

local spinningObject = nil
local spinningCar = nil
local auxCar = nil

local duiList = {}
local wheelDui = nil
local tvDui = nil
local tvUri = "https://i.imgur.com/fg3KHD1.jpeg" -- "https://prod-gta.nopixel.net/dui/?type=video&src=https://i.imgur.com/bgn4RKc.mp4&encoding=mp4"
local wheelUrl = nil

local isPowerOut = false

Citizen.CreateThread(function()
  wheelUrl = GetConvar("sv_wheelUrl", "")
end)

-- CAR FOR WINS
function drawCarForWins()
  if DoesEntityExist(spinningCar) then
    DeleteEntity(spinningCar)
  end
  if DoesEntityExist(auxCar) then
    DeleteEntity(auxCar)
  end
  RequestModel(carOnShow)
	while not HasModelLoaded(carOnShow) do
		Citizen.Wait(0)
  end
  RequestModel(carOnShow2)
	while not HasModelLoaded(carOnShow2) do
		Citizen.Wait(0)
  end
  SetModelAsNoLongerNeeded(carOnShow)
  if carOnShow2Active then
    SetModelAsNoLongerNeeded(carOnShow2)
  end
  spinningCar = CreateVehicle(carOnShow, 975.5, 40.41, 72.16 + 0.05, 0.0, 0, 0)
  Wait(0)
  if carOnShow2Active then
    auxCar = CreateVehicle(carOnShow2, 1007.23, 46.5, 70.47 + 0.05, 197.13, 0, 0)
  end
  if carOnShowAppearence then
    exports['np-vehicles']:SetVehicleAppearance(spinningCar, carOnShowAppearence)
  end
  if carOnShowMods then
    exports['np-vehicles']:SetVehicleMods(spinningCar, carOnShowMods)
  end
  SetVehicleDirtLevel(spinningCar, 0.0)
  SetVehicleOnGroundProperly(spinningCar)
  SetVehicleNumberPlateText(spinningCar, "SPIN2WIN")
  if carOnShow2Active then
    SetVehicleDirtLevel(auxCar, 0.0)
    SetVehicleOnGroundProperly(auxCar)
    SetVehicleNumberPlateText(auxCar, "SPIN2WIN")
    SetVehicleDoorsLocked(auxCar, 2)
    SetVehicleUndriveable(auxCar, true)
  end
  Wait(0)
  FreezeEntityPosition(spinningCar, 1)
  if carOnShow2Active then
    FreezeEntityPosition(auxCar, 1)
  end
end
-- END CAR FOR WINS

AddEventHandler("np-casino:elevatorEnterCasino", function()
  enterCasino(true)
end)
AddEventHandler("np-casino:elevatorExitCasino", function()
  enterCasino(false)
end)

AddEventHandler("np-polyzone:enter", function(zone)
  if zone == "casino_entrance" then
    enterCasino(true)
  elseif zone == "casino_exit" then
    enterCasino(false)
  end
end)

-- local lastPostGateTrigger = 0
-- AddEventHandler("np-polyzone:enter", function(zone)
--   if zone ~= "casino_post_gate" then return end
--   -- postGateTriggered = true
--   -- if lastPostGateTrigger ~= 0 and lastPostGateTrigger + (60 * 60000) > GetGameTimer() then
--   --   return
--   -- end
--   -- lastPostGateTrigger = GetGameTimer()
--   -- TriggerServerEvent("np-bugs:playerLogAction", {
--   --   title = "Entered Casino Post-Gate",
--   --   content = "(" .. exports["isPed"]:isPed("cid") .. ") "
--   --     .. exports["isPed"]:isPed("firstname") .. " "
--   --     .. exports["isPed"]:isPed("lastname")
--   -- })
-- end)

-- AddEventHandler("np-polyzone:enter", function(zone)
--   if zone ~= "casino_betting_screen" then return end
--   doDuiStuffMate()
-- end)
-- AddEventHandler("np-polyzone:exit", function(zone)
--   if zone ~= "casino_betting_screen" then return end
--   RemoveReplaceTexture('vw_vwint01_betting_screen', 'script_rt_casinoscreen_02')
--   -- for i=1,16 do
--   --   local txd = tostring(i)
--   --   local txn = tostring(i + 2)
--   --   if i < 10 then 
--   --     txd = "0" .. tostring(i)
--   --   end
--   --   if i < 8 then
--   --     txn = "0" .. tostring(i + 2)
--   --   end
--   --   RemoveReplaceTexture('vw_vwint01_betting_sreen_' .. txd, 'script_rt_casinoscreen_' .. txn)
--   -- end
--   -- for idx,obj in ipairs(duiList) do
--   --     DestroyDui(obj)
--   --     duiList[idx] = nil
--   -- end
-- end)

function enterCasino(pIsInCasino)
  if pIsInCasino == inCasino then return end
  inCasino = pIsInCasino
  if DoesEntityExist(spinningCar) then
    DeleteEntity(spinningCar)
  end
  if isPowerOut then
    TriggerEvent("weather:blackout", not inCasino)
  end
  local function doInitStuff()
    spinMeRightRoundBaby()
    showDiamondsOnScreenBaby()
    playSomeBackgroundAudioBaby()
    doSomeTextureReplacesBruv(true)
    showThe6StrImage(true)
    -- doWeaponBlock()
    -- stopRunningInMyCasino()
    -- doRaffleTickets()
  end
  -- if not pFromElevator then
  --   DoScreenFadeOut(500)
  --   Wait(500)
  --   NetworkFadeOutEntity(PlayerPedId(), true, true)
  --   Wait(300)
  --   SetPedCoordsKeepVehicle(PlayerPedId(), pCoords)
  --   SetEntityHeading(PlayerPedId(), pHeading)
  --   Citizen.CreateThread(function()
  --     -- if enterFirstTime and inCasino then
  --     --   enterFirstTime = false
  --     --   Citizen.Wait(500)
  --     --   SetPedCoordsKeepVehicle(PlayerPedId(), exitTeleportCoords)
  --     --   Citizen.Wait(500)
  --     --   SetPedCoordsKeepVehicle(PlayerPedId(), entranceTeleportCoords)
  --     -- end
  --     if inCasino then
  --       local pedCoords = RPC.execute("np-casino:getSpawnedPedCoords", true)
  --       handlePedCoordsBaby(pedCoords)
  --       Citizen.Wait(250)
  --     else
  --       Citizen.Wait(800)
  --     end
  --     ClearPedTasksImmediately(PlayerPedId())
  --     SetGameplayCamRelativeHeading(0.0)
  --     NetworkFadeInEntity(PlayerPedId(), true)
  --     if inCasino then
  --       doInitStuff()
  --     end
  --     Citizen.Wait(500)
  --     DoScreenFadeIn(500)
  --   end)
  -- end
  if not inCasino then
    doSomeTextureReplacesBruv(false)
    showThe6StrImage(false)
    RPC.execute("np-casino:getSpawnedPedCoords", false)
    TriggerEvent("np-casino:casinoExitedEvent")
    TriggerServerEvent('np-infinity:scopes:casino', false)
    postGateTriggered = false
    return
  end
  -- local pedCoords = RPC.execute("np-casino:getSpawnedPedCoords", true)
  -- handlePedCoordsBaby(pedCoords)
  doInitStuff()
  TriggerEvent("np-casino:casinoEnteredEvent")
  TriggerServerEvent('np-infinity:scopes:casino', true)
end

Citizen.CreateThread(function()
  -- enterCasino(true)
  Wait(10000)
  RPC.execute("np-casino:getCurrentInteriorSetName")
  local data = RPC.execute("np-heists:getVaultLowerState")
  isPowerOut = not data.cityPowerState
end)

local casinoRaffleThreadActive = false
function doRaffleTickets()
  if casinoRaffleThreadActive then return end
  casinoRaffleThreadActive = true
  Citizen.CreateThread(function()
    while inCasino do
      Citizen.Wait(5 * 60000)
      if inCasino and postGateTriggered then
        if hasMembership() then
          --RPC.execute("np-casino:generateRaffleTicket")
        end
      end
    end
    casinoRaffleThreadActive = false
  end)
end

RegisterNetEvent("sv-heists:cityPowerState", function(pIsPowerOut)
  isPowerOut = not pIsPowerOut
  if not isPowerOut then return end
  if not inCasino then return end
  for i = 1, 5 do
    Citizen.Wait(200)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
  end
  Wait(1000)
  TriggerEvent("chatMessage", "^2[Diamond Casino & Resort]", {100, 100, 100}, "Power outage detected. Backup generators will enable momentarily.", "feed", false, { i18n = { "Power outage detected. Backup generators will enable momentarily" } })
  Wait(3500)
  for i = 1, 5 do
    Citizen.Wait(200)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
  end
  TriggerEvent("weather:blackout", false)
end)

RegisterNetEvent("sv-heists:casinoPowerBlip", function()
  if not isPowerOut then return end
  if not inCasino then return end
  for i = 1, 5 do
    Citizen.Wait(200)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
  end
  Wait(1000)
  TriggerEvent("chatMessage", "^2[Diamond Casino & Resort]", {100, 100, 100}, "Backup generator disturbed, switching power routing.", "feed", false, { i18n = "Backup generator disturbed, switching power routing" })
  Wait(3500)
  TriggerEvent("weather:blackout", true)
  for i = 1, 5 do
    Citizen.Wait(200)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
  end
  TriggerEvent("weather:blackout", false)
end)

--First one is big screen, 2-17 are the small betting screens
--currently setup to use the 1st link for everything
--also: doing this many duis likes to crash a lot
local linkList = {
  [1] = 'https://prod-gta.nopixel.net/casinowall/',
  -- [2] = 'https://i.imgur.com/0S2zo4z.png',
  -- [3] = "https://i.imgur.com/0S2zo4z.png",
  -- [4] = "https://i.imgur.com/0S2zo4z.png",
  -- [5] = "https://i.imgur.com/0S2zo4z.png",
  -- [6] = "https://i.imgur.com/0S2zo4z.png",
  -- [7] = "https://i.imgur.com/0S2zo4z.png",
  -- [8] = "https://i.imgur.com/0S2zo4z.png",
  -- [9] = "https://i.imgur.com/0S2zo4z.png",
  -- [10] = "https://i.imgur.com/0S2zo4z.png",
  -- [11] = "https://i.imgur.com/0S2zo4z.png",
  -- [12] = "https://i.imgur.com/0S2zo4z.png",
  -- [13] = "https://i.imgur.com/0S2zo4z.png",
  -- [14] = "https://i.imgur.com/0S2zo4z.png",
  -- [15] = "https://i.imgur.com/0S2zo4z.png",
  -- [16] = "https://i.imgur.com/0S2zo4z.png",
  -- [17] = "https://i.imgur.com/0S2zo4z.png"
}

function doDuiStuffMate()
  for idx,link in ipairs(linkList) do
    if not duiList[idx] then
      local resolution = (idx == 1 and {2048, 1024} or {1280, 800})
      duiList[idx] = CreateDui(link, resolution[1], resolution[2])
    -- else
    --   SetDuiUrl(duiList[idx], link)
      local dui = GetDuiHandle(duiList[idx])
      local txd = CreateRuntimeTxd('duiTxdBetScreen_' .. idx)
      local txd2 = CreateRuntimeTextureFromDuiHandle(txd, 'duiTexBetScreen_' .. idx, dui)
    end
  end
  AddReplaceTexture('vw_vwint01_betting_screen', 'script_rt_casinoscreen_02', 'duiTxdBetScreen_1', 'duiTexBetScreen_1')
  -- for i=1,16 do
  --   local txd = tostring(i)
  --   local txn = tostring(i + 2)
  --   if i < 10 then 
  --     txd = "0" .. tostring(i) 
  --   end
  --   if i < 8 then
  --     txn = "0" .. tostring(i + 2)
  --   end
  --   --AddReplaceTexture('vw_vwint01_betting_sreen_' .. txd, 'script_rt_casinoscreen_' .. txn, 'duiTxdBetScreen_' .. tostring(i + 1), 'duiTexBetScreen_' .. tostring(i + 1))
  --   --AddReplaceTexture('vw_vwint01_betting_sreen_' .. txd, 'script_rt_casinoscreen_' .. txn, 'duiTxdBetScreen_1', 'duiTexBetScreen_1')
  -- end
end

function doSomeTextureReplacesBruv(apply)
  if not apply then
    RemoveReplaceTexture('vw_prop_vw_luckywheel_01a', 'script_rt_casinowheel')
    if wheelDui then exports["np-lib"]:releaseDui(wheelDui.id) end
    wheelDui = nil
    return
  end
  if wheelUrl == nil or wheelUrl == "" then
    print("Error: No url for wheel")
    return
  end
  if wheelDui == nil then
    wheelDui = exports["np-lib"]:getDui(wheelUrl, 1024, 1024)
    AddReplaceTexture('vw_prop_vw_luckywheel_01a', 'script_rt_casinowheel', wheelDui.dictionary, wheelDui.texture)
  else
    exports["np-lib"]:changeDuiUrl(wheelDui.id, wheelUrl)
  end
end

function showThe6StrImage(apply)
  if not apply then
    RemoveReplaceTexture('vw_prop_vw_cinema_tv_01', 'script_rt_tvscreen')
    exports["np-lib"]:releaseDui(tvDui.id)
    tvDui = nil
    return
  end
  if tvDui == nil then
    tvDui = exports["np-lib"]:getDui(tvUri, 512, 256)
    AddReplaceTexture('vw_prop_vw_cinema_tv_01', 'script_rt_tvscreen', tvDui.dictionary, tvDui.texture)
  else
    exports["np-lib"]:changeDuiUrl(tvDui.id, tvUri)
  end
end

function doWeaponBlock()
  Citizen.CreateThread(function()
    while inCasino do
      Citizen.Wait(1500)
      if IsPedArmed(PlayerPedId(), 7) then
        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
      end
    end
  end)
end

function stopRunningInMyCasino()
  Citizen.CreateThread(function()
    while inCasino do
      DisableControlAction(0, 21, true) -- disable sprint
      Citizen.Wait(0)
    end
  end)
end

function spinMeRightRoundBaby()
  Citizen.CreateThread(function()
    while inCasino do
      if not spinningObject or spinningObject == 0 or not DoesEntityExist(spinningObject) then
        spinningObject = GetClosestObjectOfType(974.22, 39.76, 72.16, 10.0, -1561087446, 0, 0, 0)
        drawCarForWins()
      end
      if spinningObject ~= nil and spinningObject ~= 0 then
        local curHeading = GetEntityHeading(spinningObject)
        local curHeadingCar = GetEntityHeading(spinningCar)
        if curHeading >= 360 then
          curHeading = 0.0
          curHeadingCar = 0.0
        elseif curHeading ~= curHeadingCar then
          curHeadingCar = curHeading
        end
        SetEntityHeading(spinningObject, curHeading + 0.075)
        SetEntityHeading(spinningCar, curHeadingCar + 0.075)
      end
      Wait(0)
    end
    spinningObject = nil
  end)
end

-- Casino Screens
local Playlists = {
  "CASINO_DIA_PL", -- diamonds
  "CASINO_SNWFLK_PL", -- snowflakes
  "CASINO_WIN_PL", -- win
  "CASINO_HLW_PL", -- skull
}
-- Render
function CreateNamedRenderTargetForModel(name, model)
  local handle = 0
  if not IsNamedRendertargetRegistered(name) then
    RegisterNamedRendertarget(name, 0)
  end
  if not IsNamedRendertargetLinked(model) then
    LinkNamedRendertarget(model)
  end
  if IsNamedRendertargetRegistered(name) then
    handle = GetNamedRendertargetRenderId(name)
  end
  return handle
end
-- render tv stuff
function showDiamondsOnScreenBaby()
  Citizen.CreateThread(function()
    local propNames = {"vw_vwint01_video_overlay", "gbz_casino_video_overlay"}
    for _, propName in pairs(propNames) do
      Citizen.CreateThread(function()
        local model = GetHashKey(propName)
        local timeout = 21085 -- 5000 / 255
        local casinoScreenStr = propName == "vw_vwint01_video_overlay" and "CasinoScreen_01" or "CasinoScreen_02"
        local handle = CreateNamedRenderTargetForModel(casinoScreenStr, model)
        --print(model, propName, casinoScreenStr, handle)
        RegisterScriptWithAudio(0)
        SetTvChannel(-1)
        SetTvVolume(0)
        SetScriptGfxDrawOrder(4)
        SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
        SetTvChannel(2)
        EnableMovieSubtitles(1)

        function doAlpha()
          Citizen.SetTimeout(timeout, function()
            SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
            SetTvChannel(2)
            if inCasino then
              doAlpha()
            end
          end)
        end
        doAlpha()

        Citizen.CreateThread(function()
          while inCasino do
            SetTextRenderId(handle)
            DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
            SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            Citizen.Wait(0)
          end
          SetTvChannel(-1)
          ReleaseNamedRendertarget(GetHashKey(casinoScreenStr))
          SetTextRenderId(GetDefaultScriptRendertargetRenderId())
        end)
      end)
    end
  end)
end

function showDiamondsOnInsideTrackScreenBaby()
  Citizen.CreateThread(function()
    local model = GetHashKey("vw_vwint01_betting_screen")
    local timeout = 21085 -- 5000 / 255

    local handle = CreateNamedRenderTargetForModel("CasinoScreen_02", model)

    RegisterScriptWithAudio(0)
    SetTvChannel(-1)
    SetTvVolume(0)
    SetScriptGfxDrawOrder(4)
    SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
    SetTvChannel(2)
    EnableMovieSubtitles(1)

    function doAlpha()
      Citizen.SetTimeout(timeout, function()
        SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
        SetTvChannel(2)
        if inCasino then
          doAlpha()
        end
      end)
    end
    doAlpha()

    Citizen.CreateThread(function()
      while inCasino do
        SetTextRenderId(handle)
        DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
        Citizen.Wait(0)
      end
      SetTvChannel(-1)
      ReleaseNamedRendertarget(GetHashKey("CasinoScreen_02"))
      SetTextRenderId(GetDefaultScriptRendertargetRenderId())
    end)
  end)
end

function playSomeBackgroundAudioBaby()
  Citizen.CreateThread(function()
    local function audioBanks()
      while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1) do
        Citizen.Wait(0)
      end
      while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1) do
        Citizen.Wait(0)
      end
      while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02", false, -1) do
        Citizen.Wait(0)
      end
      while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03", false, -1) do
        Citizen.Wait(0)
      end
      -- while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_INTERIOR_STEMS", false, -1) do
      --   print('load 5')
      --   Wait(0)
      -- end
    end
    audioBanks()
    while inCasino do
      if inVRHeadset and IsStreamPlaying() then
        StopStream()
      end
      if inVRHeadset and IsAudioSceneActive("DLC_VW_Casino_General") then
        StopAudioScene("DLC_VW_Casino_General")
      end
      if not inVRHeadset and not IsStreamPlaying() and LoadStream("casino_walla", "DLC_VW_Casino_Interior_Sounds") then
        PlayStreamFromPosition(996.13,38.48,71.07)
      end
      if not inVRHeadset and IsStreamPlaying() and not IsAudioSceneActive("DLC_VW_Casino_General") then
        StartAudioScene("DLC_VW_Casino_General")
      end
      Citizen.Wait(1000)
    end
    if IsStreamPlaying() then
      StopStream()
    end
    if IsAudioSceneActive("DLC_VW_Casino_General") then
      StopAudioScene("DLC_VW_Casino_General")
    end
    ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL")
    ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01")
    ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02")
    ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03")
  end)
end

local myPeds = {}
function handlePedCoordsBaby(pPedCoords)
  if not pPedCoords or not inCasino then return end
  for _, pedData in pairs(pPedCoords) do
    RequestModel(pedData.model)
    while not HasModelLoaded(pedData.model) do
      Wait(0)
    end
    SetModelAsNoLongerNeeded(pedData.model)
    local ped = CreatePed(pedData._pedType, pedData.model, pedData.coords, pedData.heading, 1, 1)
    while not DoesEntityExist(ped) do
      Wait(0)
    end
    SetPedRandomComponentVariation(ped, 0)
    local pedNetId = 0
    while NetworkGetNetworkIdFromEntity(ped) == 0 do
      Wait(0)
    end
    TaskSetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    pedNetId = NetworkGetNetworkIdFromEntity(ped)
    SetNetworkIdCanMigrate(ped, true)
    myPeds[#myPeds + 1] = { entity = ped, scenario = pedData.scenario, netId = pedNetId }
    Wait(0)
  end
  RPC.execute("np-casino:handoffPedData", myPeds)
  Citizen.CreateThread(function()
    while inCasino do
      for _, ped in pairs(myPeds) do
        if IsPedDeadOrDying(ped.entity, 1) then
          DeleteEntity(ped.entity)
        elseif math.random() < 0.002 then
          TaskWanderStandard(ped.entity)
        elseif not IsPedActiveInScenario(ped.entity) then
          ClearPedTasks(ped.entity)
          TaskStartScenarioInPlace(ped.entity, ped.scenario, 0, 1)
        end
      end
      Wait(15000)
    end
  end)
  -- debug
  -- Citizen.CreateThread(function()
  --   while inCasino do
  --     for _, ped in pairs(myPeds) do
  --       if #(GetEntityCoords(ped.entity) - GetEntityCoords(PlayerPedId())) < 1.2 then
  --         print(ped.entity, ped.scenario)
  --       end
  --     end
  --     Wait(1000)
  --   end
  -- end)
end

-- chips
RegisterUICallback("np-ui:casinoPurchaseChipsAmount", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  local amount = data.values.amount
  RPC.execute("np-casino:purchaseChips", amount)
  exports['np-ui']:closeApplication('textbox')
end)

RegisterUICallback("np-ui:transferChipsAmount", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  local amount = data.values.amount
  local stateId = data.values.state_id
  RPC.execute("np-casino:transferChips", stateId, amount)
  exports['np-ui']:closeApplication('textbox')
end)

AddEventHandler("np-casino:purchaseChipsAction", function(pArgs)
  local action = pArgs[1]
  if not hasMembership() then
    TriggerEvent("DoLHudText", 2, "casino-members-only", "Members only")
    return
  end
  if action == "purchase" then
    Wait(100)
    exports['np-ui']:openApplication('textbox', {
      callbackUrl = 'np-ui:casinoPurchaseChipsAmount',
      key = 1,
      items = {
        {
          icon = "dollar-sign",
          label = _L("casino-purchase-amount", "Purchase Amount"),
          name = "amount",
        },
      },
      show = true,
    })
  elseif action == "purchase:dirty" then
    local payment = math.random(10, 110)
    if exports["np-inventory"]:hasEnoughOfItem("markedbills", 20, false, true) then
      TriggerEvent("inventory:removeItem", "markedbills", 20)
      payment = payment + (250 * 20) -- $5k / $250 per
    end
    if exports["np-inventory"]:hasEnoughOfItem("rollcash", 5, false, true) then
      TriggerEvent("inventory:removeItem", "rollcash", 5)
      payment = payment + (30 * 5) -- $150 / $30 per
    end
    if exports["np-inventory"]:hasEnoughOfItem("band", 5, false, true) then
      TriggerEvent("inventory:removeItem", "band", 5)
      payment = payment + (300 * 5) -- $1500, / $300 per
    end
    RPC.execute("np-casino:purchaseChipsDirty", payment)
  elseif action == "withdraw:cash" then
    RPC.execute("np-casino:withdrawChips", "cash")
  elseif action == "withdraw:bank" then
    RPC.execute("np-casino:withdrawChips", "bank")
  elseif action == "transfer" then
    Wait(100)
    exports['np-ui']:openApplication('textbox', {
      callbackUrl = 'np-ui:transferChipsAmount',
      key = 1,
      items = {
        {
          icon = "user",
          label = _L("casino-state-id", "State ID"),
          name = "state_id",
        },
        {
          icon = "dollar-sign",
          label = _L("casino-amount", "Amount"),
          name = "amount",
        },
      },
      show = true,
    })
  end
end)

AddEventHandler("np-casino:purchaseMembership", function()
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "casino"} })
  if not jobAccess then
    TriggerEvent("DoLHudText", 2, "casino-please-talk-to-floor-staff", "Please talk to a member of floor staff")
    return
  end
  exports['np-ui']:openApplication('textbox', {
    callbackUrl = 'np-ui:casinoGetMembership',
    key = 1,
    items = {
      {
        icon = "user",
        label = _L("casino-state-id", "State ID"),
        name = "state_id",
      },
    },
    show = true,
  })
end)
RegisterUICallback("np-ui:casinoGetMembership", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  exports['np-ui']:closeApplication('textbox')
  TriggerEvent("player:receiveItem", "casinomember", 1, false, { state_id = data.values.state_id }, { state_id = data.values.state_id })
end)

AddEventHandler("np-casino:purchaseMembershipCard", function()
  local characterId = exports["isPed"]:isPed("cid")
  RPC.execute("np-casino:purchaseMembershipCard", characterId)
end)

AddEventHandler("np-casino:getLoyaltyCard", function()
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "casino"} })
  if not jobAccess then
    TriggerEvent("DoLHudText", 2, "casino-please-talk-to-floor-staff", "Please talk to a member of floor staff")
    return
  end
  TriggerEvent("player:receiveItem", "casinoloyalty", 1, false, { state_id = characterId }, { state_id = characterId })
end)

AddEventHandler("np-casino:purchaseVipMembership", function()
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "casino"} })
  if not jobAccess then
    TriggerEvent("DoLHudText", 2, "casino-please-talk-to-floor-staff", "Please talk to a member of floor staff")
    return
  end
  exports['np-ui']:openApplication('textbox', {
    callbackUrl = 'np-ui:casinoGetVipMembership',
    key = 1,
    items = {
      {
        icon = "user",
        label = _L("casino-state-id", "State ID"),
        name = "state_id",
      },
    },
    show = true,
  })
end)
RegisterUICallback("np-ui:casinoGetVipMembership", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  exports['np-ui']:closeApplication('textbox')
  TriggerEvent("player:receiveItem", "casinovip", 1, false, { state_id = data.values.state_id }, { state_id = data.values.state_id })
end)

AddEventHandler("np-casino:purchaseDrinks", function(data)
  TriggerEvent("server-inventory-open", "46", "Shop")
end)

function hasMembership(hrOnly)
  if exports['np-config']:GetMiscConfig("casino.membership.bypass") then
    return true
  end
  -- if    (not hrOnly and not exports['np-inventory']:hasEnoughOfItem("casinomember", 1, false, true))
  --   and not exports['np-inventory']:hasEnoughOfItem("casinovip", 1, false, true)
  -- then
  --   return false
  -- end
  local characterId = exports["isPed"]:isPed("cid")
  -- local info = hrOnly and nil or exports["np-inventory"]:GetInfoForFirstItemOfName("casinomember")
  -- if not info then
  --   info = exports["np-inventory"]:GetInfoForFirstItemOfName("casinovip")
  -- end
  local info = exports["np-inventory"]:GetInfoForFirstItemOfName("casinomember")
  if not info then
    return false
  end
  info = json.decode(info.information)
  return tonumber(info.state_id) == tonumber(characterId)
end
exports('hasMembership', hasMembership)

AddEventHandler("np-casino:inVRHeadset", function(pInVRHeadset)
  inVRHeadset = pInVRHeadset
end)

RegisterUICallback("np-ui:casinoCheckSpentWheelAmount", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  local stateId = data.values.state_id
  RPC.execute("np-casino:checkSpentAmount", stateId)
  exports['np-ui']:closeApplication('textbox')
end)
AddEventHandler("np-casino:wheel:checkSpentAmount", function()
  local cid = exports["isPed"]:isPed("cid")
  if cid ~= 3503 then
    TriggerEvent("DoLHudText", 2, "casino-cannot-do-that", "You cannot do that.")
    return
  end
  exports['np-ui']:openApplication('textbox', {
    callbackUrl = 'np-ui:casinoCheckSpentWheelAmount',
    key = 1,
    items = {
      {
        icon = "user-alt",
        label = _L("casino-state-id", "State ID"),
        name = "state_id",
      },
    },
    show = true,
  })
end)

-- RegisterCommand("incas", function()
--   inCasino = not inCasino
-- end)

-- Citizen.CreateThread(function()
--   -- StartScreenEffect("SwitchOpenNeutralFIB5", 2000, 0)
--   -- Wait(400)
--   -- StartScreenEffect("PeyoteOut", 4000, 0)
--   -- Wait(1600)
--   -- StopScreenEffect("SwitchOpenNeutralFIB5")
--   -- Wait(3000)
--   -- StopScreenEffect("PeyoteOut")
--   SetTimecycleModifier("BarryFadeOut")
--   Wait(4000)
--   local idx = 1.0
--   while idx > 0 do
--     Wait(32)
--     SetTimecycleModifierStrength(idx)
--     idx = idx - 0.02
--   end
--   ClearTimecycleModifier()
-- end)

--testing and setup
-- local casinoEntranceCoords = vector3(1089.73, 206.36, -48.99)
-- local coordsBro = {}
-- RegisterCommand("+addCasinoCoords", function()
--   local coords = GetEntityCoords(PlayerPedId())
--   local heading = GetEntityHeading(PlayerPedId())
--   print('regular', coords, heading)
--   -- local interior = GetInteriorAtCoords(1100.000, 220.000, -50.000)
--   -- local offset = GetOffsetFromInteriorInWorldCoords(interior, coords)
--   local entity = GetClosestObjectOfType(1100.0, 220.0, -51.0, 10.0, -1561087446, 0, 0, 0) -- spinny boi
--   print(entity)
--   SetEntityHeading(entity, 0.0)
--   local offset = GetOffsetFromEntityGivenWorldCoords(entity, coords)
--   print('offset', offset)
--   coordsBro[#coordsBro + 1] = {
--     entityExists = entity ~= 0,
--     coords = coords,
--     offset = offset,
--     heading = heading,
--     flag = 0,
--   }
--   print(json.encode(coordsBro))
--   print(json.encode(coordsBro[#coordsBro]))
-- end, false)
-- RegisterCommand("-addCasinoCoords", function() end, false)

-- -- 1 = FILM SHOCKING
-- -- 2 = BROWSE
-- -- 3 = RANDOM
-- -- 4 = SIT
-- RegisterCommand("doflag", function(src, args)
--   print(src, json.encode(args))
--   coordsBro[#coordsBro].flag = args[1]
--   print(json.encode(coordsBro[#coordsBro]))
-- end, false)
-- Citizen.CreateThread(function()
--   exports["np-keybinds"]:registerKeyMapping("", "Casino", "Add Coords", "+addCasinoCoords", "-addCasinoCoords")
-- end)

-- Citizen.CreateThread(function()
--   for _, v in pairs(exports["np-casino"]:getPedCoordsC()) do
--     if #(vector3(v.coords.x, v.coords.y, v.coords.z) - vector3(1094.15,220.64,-48.99) ) < 2.5 then
--       print(v.coords.x, v.coords.y, v.coords.z)
--       SetEntityCoords(PlayerPedId(), v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0)
--       Wait(1000)
--     end
--   end
-- end)
