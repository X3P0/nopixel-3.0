local hackAnimDict = "anim@heists@ornate_bank@hack"
local trolleyConfig = nil
local thermiteTimeMultiplier = 1.0
PanelTimeMultiplier = 1.0

local switchModels = {
  [`mp_m_freemode_01`] = true,
  [`mp_f_freemode_01`] = true,
}

function GetTrolleyConfig(name)
    if not trolleyConfig then
        trolleyConfig = RPC.execute("heists:getTrolleySpawnConfig")
    end
    return trolleyConfig[name]
end

local function loadDicts()
    RequestAnimDict(hackAnimDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestModel("hei_prop_heist_card_hack_02")
    while not HasAnimDictLoaded(hackAnimDict)
        or not HasModelLoaded("hei_prop_hst_laptop")
        or not HasModelLoaded("hei_p_m_bag_var22_arm_s")
        or not HasModelLoaded("hei_prop_heist_card_hack_02") do
        Wait(0)
    end
end

function ChangeDoorHeading(door, toHeading, frameCount)
    Citizen.CreateThread(function()
        frameCount = frameCount or 60
        FreezeEntityPosition(door, true)
        local current = GetEntityHeading(door)
        if not current or not toHeading or math.abs(current - toHeading) < 1 then return end
        local diff = math.abs(current - toHeading)
        local degPer = diff / frameCount
        local count = 0
        SetEntityCollision(door, false, false)
        while count <= frameCount do
            count = count + 1
            if current > toHeading then
                SetEntityHeading(door, current - (degPer * count))
            else
                SetEntityHeading(door, current + (degPer * count))
            end
            Wait(0)
        end
        SetEntityHeading(door, toHeading)
        FreezeEntityPosition(door, true)
        Wait(0)
        SetEntityCollision(door, true, true)
    end)
end

exports("panelMultiplier", function (value)
  PanelTimeMultiplier = math.min(value, 1.15)
end)

MinigameResult = nil
MinigameUICallbackUrl = "np-ui:heistsPanelMinigameResult"
RegisterUICallback(MinigameUICallbackUrl, function(data, cb)
    MinigameResult = data.success
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)
function UseBankPanel(panelCoords, panelHeading, location, withholdEmail)
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)
    local p = promise:new()

    ClearPedTasksImmediately(ply)
    Wait(0)
    TaskGoStraightToCoord(ply, panelCoords, 2.0, -1, panelHeading)
    loadDicts()
    Wait(0)
    while GetIsTaskActive(ply, 35) do
        Wait(0)
    end
    ClearPedTasksImmediately(ply)
    Wait(0)
    SetEntityHeading(ply, panelHeading)
    Wait(0)
    TaskPlayAnimAdvanced(ply, hackAnimDict, "hack_enter", panelCoords, 0, 0, 0, 1.0, 0.0, 8300, 0, 0.3, false, false, false)
    Wait(0)
    SetEntityHeading(ply, panelHeading)
    while IsEntityPlayingAnim(ply, hackAnimDict, "hack_enter", 3) do
        Wait(0)
    end
    local laptop = CreateObject(`hei_prop_hst_laptop`, GetOffsetFromEntityInWorldCoords(ply, 0.2, 0.6, 0.0), 1, 1, 0)
    Wait(0)
    SetEntityRotation(laptop, GetEntityRotation(ply, 2), 2, true)
    PlaceObjectOnGroundProperly(laptop)
    Wait(0)
    TaskPlayAnim(ply, hackAnimDict, "hack_loop", 1.0, 0.0, -1, 1, 0, false, false, false)

    Wait(1000)

    local gameDuration = 7000
    local gameRoundsTotal = 5
    local numberOfShapes = 5
    local minigameHackExp = 10
    local answersRequired = 3
    if location == "paleto" then
      gameRoundsTotal = 8
      numberOfShapes = 5
      gameDuration = 7500
      minigameHackExp = 100
    end
    if location == "vault_upper" then
      gameRoundsTotal = 6
      numberOfShapes = 6
      gameDuration = 8000
      minigameHackExp = 1000
    end
    if location == "vault_lower" then
      gameRoundsTotal = 7
      numberOfShapes = 7
      gameDuration = 8500
      minigameHackExp = 10000
    end
    exports["np-ui"]:openApplication("minigame-captcha", {
        gameFinishedEndpoint = MinigameUICallbackUrl,
        gameDuration = gameDuration * PanelTimeMultiplier,
        gameRoundsTotal = gameRoundsTotal,
        numberOfShapes = numberOfShapes,
        answersRequired = answersRequired,
    })

    TriggerEvent("client:newStress", true, 500)

    Citizen.CreateThread(function()
        while MinigameResult == nil do
            Citizen.Wait(1000)
            -- MinigameResult = true
        end
        if MinigameResult and not withholdEmail then
          Citizen.CreateThread(function()
            Citizen.Wait(2500)
            TriggerEvent(
              'phone:emailReceived',
              'Dark Market',
              '#A-1001',
              'Nice! You bypassed the captcha. Give me a few moments to open the door!'
            )
          end)
        end
        if MinigameResult then
          TriggerServerEvent("np-heists:hack:success", minigameHackExp)
        end
        TriggerServerEvent("np-heists:hack:track", MinigameResult, "laptop")
        p:resolve(MinigameResult)
        MinigameResult = nil
        Sync.DeleteObject(laptop)
        ClearPedTasksImmediately(ply)
    end)

    return p
end

UTK = {}
function Loot(currentgrab)
    TriggerEvent("client:newStress", true, 500)
    Grab2clear = false
    Grab3clear = false
    UTK.grabber = true
    Trolley = nil
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    if currentgrab == "cash" then
        Trolley = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, `np_prop_ch_cash_trolly_01c`, false, false, false) --GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, 269934519, false, false, false)
    else
        Trolley = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, `np_prop_gold_trolly_01c`, false, false, false)
        model = "np_prop_gold_bar_01a"
    -- elseif currentgrab == 5 then
    --     Trolley = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, 881130828, false, false, false)
    --     model = "ch_prop_vault_dimaondbox_01a"
    end
    local CashAppear = function()
        local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(0)
        end
        local grabobj = CreateObject(grabmodel, pedCoords, true)

        FreezeEntityPosition(grabobj, true)
        SetEntityInvincible(grabobj, true)
        SetEntityNoCollisionEntity(grabobj, ped)
        SetEntityVisible(grabobj, false, false)
        AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
        local startedGrabbing = GetGameTimer()

        Citizen.CreateThread(function()
            while GetGameTimer() - startedGrabbing < 37000 do
                Citizen.Wait(0)
                DisableControlAction(0, 73, true)
                if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
                    if not IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, true, false)
                    end
                end
                if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
                    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                        -- if currentgrab < 4 then
                        --     TriggerServerEvent("utk_oh:rewardCash")
                        -- elseif currentgrab == 4 then
                        --     TriggerServerEvent("utk_oh:rewardGold")
                        -- elseif currentgrab == 5 then
                        --     TriggerServerEvent("utk_oh:rewardDia")
                        -- end
                    end
                end
            end
            Sync.DeleteObject(grabobj)
        end)
    end
    local emptyobj = `np_prop_gold_trolly_01c_empty`

    if IsEntityPlayingAnim(Trolley, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
        return
    end
    local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Citizen.Wait(0)
    end
    local timeout = 1200
    while not NetworkHasControlOfEntity(Trolley) and timeout > 0 do
        Citizen.Wait(0)
        NetworkRequestControlOfEntity(Trolley)
        timeout = timeout - 1
    end
    if timeout < 0 then
      TriggerEvent('DoLongHudText', 'Could not get entity control.', 2)
      Sync.DeleteObject(Trolley)
      Wait(5000)
      return
    end
    GrabBag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    Grab1 = NetworkCreateSynchronisedScene(GetEntityCoords(Trolley), GetEntityRotation(Trolley), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, Grab1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(GrabBag, Grab1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    -- SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(Grab1)
    Citizen.Wait(1500)
    CashAppear()
    if not Grab2clear then
        Grab2 = NetworkCreateSynchronisedScene(GetEntityCoords(Trolley), GetEntityRotation(Trolley), 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Grab2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(GrabBag, Grab2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(Trolley, Grab2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(Grab2)
        Citizen.Wait(37000)
    end
    if not Grab3clear then
        Grab3 = NetworkCreateSynchronisedScene(GetEntityCoords(Trolley), GetEntityRotation(Trolley), 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Grab3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(GrabBag, Grab3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(Grab3)
        NewTrolley = CreateObject(emptyobj, GetEntityCoords(Trolley) + vector3(0.0, 0.0, - 0.985), true, false, false)
        SetEntityRotation(NewTrolley, GetEntityRotation(Trolley))
        Sync.DeleteObject(Trolley)
        while DoesEntityExist(Trolley) do
            Citizen.Wait(0)
            DeleteEntity(Trolley)
        end
        PlaceObjectOnGroundProperly(NewTrolley)
        SetEntityAsMissionEntity(NewTrolley, 1, 1)
        Citizen.SetTimeout(5000, function()
            Sync.DeleteObject(NewTrolley)
            while DoesEntityExist(NewTrolley) do
              Citizen.Wait(0)
              DeleteEntity(NewTrolley)
            end
        end)
    end
    Citizen.Wait(1800)
    if DoesEntityExist(GrabBag) then
        Sync.DeleteEntity(GrabBag)
    end
    -- SetPedComponentVariation(ped, 5, 45, 0, 0)
    RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
    SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
end

function LoopSkill(count)
    local loopCount = 0
    while loopCount < count do
        loopCount = loopCount + 1
        local finished = exports["np-ui"]:taskBarSkill(math.random(1000, 4000), math.random(7, 12))
        if finished ~= 100 then
            TriggerEvent("client:newStress", true, 200 * math.max(1, loopCount))
            return false
        end
        Wait(100)
    end
    TriggerEvent("client:newStress", true, 200 * loopCount)
    return true
end

-- Thermite
function ThermiteLocations(curLoc)
  local loc = { x, y, z, h }
  local ptfx
  local rotplus = 0
  if curLoc == "vault_upper_first_door" then
      loc.x = 257.40
      loc.y = 220.20
      loc.z = 106.35
      loc.h = 336.48
      ptfx = vector3(257.39, 221.20, 106.29)
  elseif curLoc == "vault_upper_inner_door_1" then
      loc.x = 252.95
      loc.y = 220.70
      loc.z = 101.76
      loc.h = 160
      ptfx = vector3(252.985, 221.70, 101.72)
      rotplus = 170.0
  elseif curLoc == "vault_upper_inner_door_2" then
      loc.x = 261.65
      loc.y = 215.60
      loc.z = 101.76
      loc.h = 252
      ptfx = vector3(261.68, 216.63, 101.75)
      rotplus = 270.0
  elseif curLoc == "bobcat_security_entry" then
      loc.x = 882.1626
      loc.y = -2258.358
      loc.z = -1000.0 -- 30.41816
      loc.h = 175.89
      ptfx = vector3(882.25,-2257.26,32.63)
  elseif curLoc == "bobcat_security_inner_1" then
      loc.x = 880.4458
      loc.y = -2264.525
      loc.z = 30.45313
      loc.h = 178.62
      ptfx = vector3(880.6,-2263.45,32.60)
  elseif curLoc == "fleeca_legion_inner_door" then
      loc.x = 148.96
      loc.y = -1047.06
      loc.z = 29.65
      loc.h = 160.16
      ptfx = vector3(148.96,-1047.06,29.65)
  elseif curLoc == "fleeca_pinkcage_inner_door" then
      loc.x = 313.3
      loc.y = -285.43
      loc.z = 54.45
      loc.h = 161.58
      ptfx = vector3(313.3,-285.43,54.45)
  elseif curLoc == "fleeca_harwick_inner_door" then
      loc.x = -351.74
      loc.y = -56.26
      loc.z = 49.33
      loc.h = 160.11
      ptfx = vector3(-351.74,-56.26,49.33)
  elseif curLoc == "fleeca_lifeinvader_inner_door" then
      loc.x = -1208.61
      loc.y = -335.69
      loc.z = 38.11
      loc.h = 205.0
      ptfx = vector3(-1208.61, -335.69, 38.11)
  elseif curLoc == "fleeca_greatocean_inner_door" then
      loc.x = -2956.2562109375
      loc.y = 484.02059326171877
      loc.z = 15.99530887603759
      loc.h = 260.0
      ptfx = vector3(-2956.2562109375,484.02059326171877,15.99530887603759)
  elseif curLoc == "fleeca_harmony_inner_door" then
      loc.x = 1173.791137695312
      loc.y = 2713.106240234375
      loc.z = 38.38625335693359
      loc.h = 0.0
      ptfx = vector3(1173.2911376953126,2713.146240234375,37.38625335693359)
  elseif curLoc == "paleto_inner_door" then
      loc.x = -105.52
      loc.y = 6475.1
      loc.z = 31.95
      loc.h = 315.16
      ptfx = vector3(-105.52,6475.1,31.95)
  elseif curLoc == "var_heist_door" then
      loc.x = -209.59
      loc.y = -302.97
      loc.z = -1000.0 -- 74.66
      loc.h = 336.0
      ptfx = vector3(-209.59,-302.97,74.66)
  elseif curLoc == "hasino_box_1" then
      loc.x = 1010.104
      loc.y = 22.23468
      loc.z = 54.50427
      loc.h = 66.62
      ptfx = vector3(1010.104, 22.23468, 54.50427)
  elseif curLoc == "hasino_box_2" then
      loc.x = 1013.174
      loc.y = 21.22041
      loc.z = 54.4674
      loc.h = 328.09
      ptfx = vector3(1013.174, 21.22041, 54.4674)
  elseif curLoc == "hasino_box_3" then
      loc.x = 1012.469
      loc.y = 17.53356
      loc.z = 54.42522
      loc.h = 243.12
      ptfx = vector3(1012.469, 17.53356, 54.42522)
  end
  return loc, ptfx, rotplus
end

exports("thermiteMultiplier", function (value)
  thermiteTimeMultiplier = math.min(value, 1.15)
end)

local thermiteMinigameResult = nil
local thermiteMinigameUICallbackUrl = "np-ui:heistsThermiteMinigameResult"
RegisterUICallback(thermiteMinigameUICallbackUrl, function(data, cb)
  thermiteMinigameResult = data.success
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)
function ThermiteCharge(loc, ptfx, rotplus, gameSettings)
  local p = promise:new()
  Citizen.CreateThread(function()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") do
      Citizen.Wait(0)
    end
    local ped = PlayerPedId()
    SetEntityHeading(ped, loc.h)
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz + rotplus, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), loc.x, loc.y, loc.z,  true,  true, false)
    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    local curVar = 0
    if switchModels[GetEntityModel(PlayerPedId())] then
      GetPedDrawableVariation(ped, 5)
      SetPedComponentVariation(ped, 5, 0, 0, 0)
    end
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.2,  true,  true, true)
    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(4000)
    DeleteObject(bag)
    if curVar > 0 and GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
      SetPedComponentVariation(ped, 5, curVar, 0, 0)
    end
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    NetworkStopSynchronisedScene(bagscene)

    if gameSettings then
      gameSettings.gameTimeoutDuration = gameSettings.gameTimeoutDuration * thermiteTimeMultiplier
      gameSettings.coloredSquares = (gameSettings.coloredSquares and gameSettings.coloredSquares or 0) + 2
      exports["np-ui"]:openApplication("memorygame", gameSettings)
    else
      exports["np-ui"]:openApplication("memorygame", {
        gameFinishedEndpoint = thermiteMinigameUICallbackUrl,
        gameTimeoutDuration = 17000 * thermiteTimeMultiplier,
      })
    end

    thermiteMinigameResult = nil
    while thermiteMinigameResult == nil do
      Citizen.Wait(1000)
      -- thermiteMinigameResult = true
    end
    TriggerServerEvent("np-heists:hack:track", thermiteMinigameResult, "thermite")
    if thermiteMinigameResult then
      TriggerServerEvent("fx:ThermiteChargeEnt", NetworkGetNetworkIdFromEntity(bomba))
      TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
      TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
      Citizen.Wait(2000)
      ClearPedTasks(ped)
      TriggerEvent('Evidence:StateSet', 16, 3600) -- apply thermite evidence in /status
      TriggerEvent("evidence:thermite")
      Citizen.Wait(2000)
    end
    if thermiteMinigameResult then
      Citizen.Wait(9000)
    end
    Sync.DeleteObject(bomba)
    p:resolve(thermiteMinigameResult == true)
    thermiteMinigameResult = nil
  end)
  return p
end

AddEventHandler("np-ui:application-closed", function(name)
  if name ~= "memorygame" then return end
  Citizen.CreateThread(function()
    Citizen.Wait(2500)
    if thermiteMinigameResult == nil then
      thermiteMinigameResult = false
    end
  end)
end)

-- cleaning
local billsCleaningStuff = {
  ["band"] = { extra = 5, price = 300 },
  ["markedbills"] = { extra = 8, price = 250 },
  ["rollcash"] = { extra = 15, price = 30 },
}
AddEventHandler("money:clean", function(pRandomChance)
  local payment = 0
  for typ, conf in pairs(billsCleaningStuff) do
    local randomAmount = math.random(4, 12)
    local randomChance = pRandomChance and pRandomChance or 0.4
    local totalAmount = randomAmount + conf.extra
    if math.random() < randomChance and exports["np-inventory"]:hasEnoughOfItem(typ, totalAmount, false) then
      TriggerEvent("inventory:removeItem", typ, totalAmount)
      payment = payment + (conf.price * totalAmount)
      payment = payment + math.random(10, 35)
    end
  end
  if payment ~= 0 then
    TriggerServerEvent('complete:job', payment, 'a' .. tostring(math.random(1, 10)))
  end
end)

local minigamePracResult = nil
local minigamePracUICallbackUrl = "np-ui:heistsPanelMinigameResultPrac"
RegisterUICallback(minigamePracUICallbackUrl, function(data, cb)
  minigamePracResult = data.success
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)
local practiceAttempts = 0
AddEventHandler("np-inventory:itemUsed", function(item)
  if item ~= "heistlaptopprac" then return end
  -- practiceAttempts = practiceAttempts + 1
  -- if practiceAttempts == 5 then
  --   TriggerEvent("inventory:removeItem", item, 1)
  --   practiceAttempts = 0
  -- end
  exports["np-ui"]:openApplication("minigame-captcha", {
    gameFinishedEndpoint = minigamePracUICallbackUrl,
    gameDuration = 5000,
    gameRoundsTotal = 10,
    numberOfShapes = 4,
  })
  TriggerEvent("client:newStress", true, 500)
  while minigamePracResult == nil do
    Wait(1000)
  end
  if minigamePracResult then
    TriggerServerEvent("np-heists:hack:success", 1)
  end
end)

AddEventHandler("np-heists:purchasePracticeLaptop", function()
  RPC.execute("np-heists:purchasePracticeLaptop")
end)

function map_range(s, a1, a2, b1, b2)
  return b1 + (s - a1) * (b2 - b1) / (a2 - a1)
end

function CheckRequiredItems(name)
  local hasItems = exports["np-inventory"]:GetItemsByItemMetaKV("heiststarttoken", "_code", name)
  if #hasItems > 0 then return true end
  Citizen.CreateThread(function()
    Wait(500)
    TriggerEvent("DoLongHudText", "Missing access codes.", 2)
  end)
  return false
end

function RemoveRequiredItems(name)
  TriggerEvent("inventory:removeItemByMetaKV", "heiststarttoken", 1, "_code", name)
end
