local closeToCasino = false
local closestChair = -1
local closestChairDist = 1000 
local Local_198f_247 = -1
local closestDealerPed = nil 
local closestDealerPedDist = 1000
local dealerPeds = {}
local Local_198f_255 = nil
local waitingForBetState = false
local waitingForSitDownState = false
local waitingForStandOrHitState = false
local blackjackInstructional = nil
local bettingInstructional = nil
local timeoutHowToBlackjack = false
local currentBlackjackGameID = 0
local timeLeft = 20
local drawTimerBar = false
local bettedThisRound = false
local standOrHitThisRound = false
local globalGameId = -1
local globalNextCardCount = -1
cardObjects = {}
deckObjects = {}
local drawCurrentHand = false
local currentHand = 0
local dealersHand = 0
currentBetAmount = 0
sittingAtBlackjackTable = false
local canExitBlackjack = false
local dealerSecondCardFromGameId = {} 
local blackjackGameInProgress = false
local shouldForceIdleCardGames = false
local shownHitStandContextOptions = false
local dwTotalCardsDealt = 0
local dwWaitingForBetTimeout = 0

local canPlayAtCurrentTable = false

local cfg = {}

cfg.blackjackTables = {
    [0] = {
        dealerPos = vector3(1043.63,56.02,69.07),
        dealerHeading = 11.06,
        tablePos = vector3(1043.424, 56.79709, 68.06007),
        tableHeading = 193.46598815918,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01",
        limits = { max = 100, min = 100 },
        highroller = false,
        texture = 0,
    },
    [1] = {
        dealerPos = vector3(1044.19,53.51,69.07),
        dealerHeading = 189.43,
        tablePos = vector3(1044.392, 52.66409, 68.06007),
        tableHeading = 13.465969085693,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01",
        limits = { max = 250, min = 250 },
        highroller = false,
        texture = 0,
    },
    [2] = {
        dealerPos = vector3(1022.24,60.56,69.87),
        dealerHeading = 283.55,
        tablePos = vector3(1023.02, 60.77129, 68.86001),
        tableHeading = 103.46606445312,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01b",
        limits = { max = 25000, min = 25000 },
        highroller = true,
        hotelvip = true,
        texture = 3,
    },
    [3] = {
        dealerPos = vector3(1027.07,39.89,69.87),
        dealerHeading = 287.69,
        tablePos = vector3(1027.855, 40.08385, 68.86001),
        tableHeading = 103.46606445312,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01b",
        limits = { max = 10000, min = 10000 },
        highroller = false,
        texture = 3,
    },
    [4] = {
        dealerPos = vector3(1036.05,54.24,69.07),
        dealerHeading = 12.0,
        tablePos = vector3(1035.85, 55.02458, 68.06007),
        tableHeading = 193.15667724609,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01",
        limits = { max = 1000, min = 1000 },
        highroller = false,
        texture = 2,
    },
    [5] = {
        dealerPos = vector3(1036.62,51.71,69.07),
        dealerHeading = 188.86,
        tablePos = vector3(1036.813, 50.90566, 68.06007),
        tableHeading = 13.156546592712,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01",
        limits = { max = 500, min = 500 },
        highroller = false,
        texture = 2,
    },
    [6] = {
        dealerPos = vector3(1029.78,62.41,69.87),
        dealerHeading = 106.96,
        tablePos = vector3(1028.989, 62.16921, 68.86008),
        tableHeading = 283.15670776367,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01b",
        limits = { max = 2000, min = 2000 },
        highroller = false,
        texture = 1,
    },
    [7] = {
        dealerPos = vector3(1034.62,41.72,69.87),
        dealerHeading = 104.66,
        tablePos = vector3(1033.818, 41.51279, 68.86008),
        tableHeading = 283.15670776367,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01b",
        limits = { max = 2000, min = 2000 },
        highroller = false,
        texture = 1,
    },
}

local dwCurrentChipCount = 0
local dwRefreshChipCount = true
function dwStatusHud(pValues)
  if dwRefreshChipCount then
    dwRefreshChipCount = false
    dwCurrentChipCount = RPC.execute("np-casino:getCurrentChipCount")
  end
  local title = "Blackjack " .. dwGetLimitTitleString()
  local values = {}
  values[#values + 1] = "Balance: $" .. format_int(dwCurrentChipCount)
  for _, v in pairs(pValues) do
    values[#values + 1] = v
  end
  exports["np-ui"]:sendAppEvent("status-hud", {
    show = true,
    title = title,
    i18nTitle = "Blackjack",
    i18nValues = { "Dealer", "Bet", "Balance", "You", "Waiting for Dealer", "Waiting for bet" },
    values = values,
  })
end

local inCasino = false
AddEventHandler("np-casino:casinoExitedEvent", function()
  inCasino = false
  for k, v in pairs(dealerPeds) do
    if DoesEntityExist(v) then
      DeleteEntity(v)
      dealerPeds[k] = nil
    end
  end
  for idx,deckObject in pairs(deckObjects) do
    if deckObject ~= nil then
        DeleteObject(deckObject)
    end
  end

  deckObjects = {}
end)

local dealerPedSeeds = {}
Citizen.CreateThread(function()
  --Wait(10000)
  dealerPedSeeds = RPC.execute("np-casino:getDealerPedSeeds")
  -- TriggerEvent("np-casino:casinoEnteredEvent")
end)

AddEventHandler("np-casino:casinoEnteredEvent", function()
    inCasino = true
    dealerAnimDict = "anim_casino_b@amb@casino@games@shared@dealer@"
    dealerAnimDictPoker = "anim_casino_b@amb@casino@games@threecardpoker@dealer"
    RequestAnimDict(dealerAnimDict)
    while not HasAnimDictLoaded(dealerAnimDict) do
        Wait(0)
    end
    RequestAnimDict(dealerAnimDictPoker)
    while not HasAnimDictLoaded(dealerAnimDictPoker) do
        Wait(0)
    end
    
    for i=0,#cfg.blackjackTables,1 do
        randomBlackShit = dealerPedSeeds[i + 1].seed
        dealerModel = dealerPedSeeds[i + 1].model
        RequestModel(dealerModel)
        while not HasModelLoaded(dealerModel) do
            RequestModel(dealerModel)
            Wait(0)
        end
        dealerEntity = CreatePed(26,dealerModel,cfg.blackjackTables[i].dealerPos.x,cfg.blackjackTables[i].dealerPos.y,cfg.blackjackTables[i].dealerPos.z,cfg.blackjackTables[i].dealerHeading,false,true)
        while not DoesEntityExist(dealerEntity) do
          Wait(0)
        end
        table.insert(dealerPeds,dealerEntity)
        SetModelAsNoLongerNeeded(dealerModel)     
        SetEntityCanBeDamaged(dealerEntity, 0)
        SetPedAsEnemy(dealerEntity, 0)
        SetPedResetFlag(dealerEntity, 249, 1)
        SetPedConfigFlag(dealerEntity, 185, true)
        SetPedConfigFlag(dealerEntity, 108, true)
        SetPedCanEvasiveDive(dealerEntity, 0)
        SetPedCanRagdollFromPlayerImpact(dealerEntity, 0)
        SetPedConfigFlag(dealerEntity, 208, true)
        SetBlockingOfNonTemporaryEvents(dealerEntity, 1)
        TaskSetBlockingOfNonTemporaryEvents(dealerEntity, 1)
        setBlackjackDealerPedVoiceGroup(randomBlackShit,dealerEntity)
        setBlackjackDealerClothes(randomBlackShit,dealerEntity)
        SetEntityCoordsNoOffset(dealerEntity, cfg.blackjackTables[i].dealerPos.x,cfg.blackjackTables[i].dealerPos.y,cfg.blackjackTables[i].dealerPos.z, 0,0,1)
        SetEntityHeading(dealerEntity, cfg.blackjackTables[i].dealerHeading)
        if dealerModel == maleCasinoDealer then
            if cfg.blackjackTables[i].isPokerTable then
              TaskPlayAnim(dealerEntity, dealerAnimDictPoker, "deck_idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
            else
              TaskPlayAnim(dealerEntity, dealerAnimDict, "idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
            end
        else
            if cfg.blackjackTables[i].isPokerTable then
                TaskPlayAnim(dealerEntity, dealerAnimDictPoker, "deck_idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
            else
                TaskPlayAnim(dealerEntity, dealerAnimDict, "female_idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
            end
        end
        PlayFacialAnim(dealerEntity, "idle_facial", dealerAnimDict)
        RemoveAnimDict(dealerAnimDict)

        if cfg.blackjackTables[i].isPokerTable then
            local deckProps = {
                ["bone"] = GetPedBoneIndex(dealerEntity, 0x49D9),
                ["x"] = 0.09,
                ["y"] = 0.005,
                ["z"] = 0.02,
                ["xR"] = 190.0,
                ["yR"] = 10.0,
                ["zR"] = 125.0
            }

            local deckHash = GetHashKey(cfg.blackjackTables[i].deckObject)
            RequestModel(deckHash)
            while not HasModelLoaded(deckHash) do
                Wait(0)
            end
            deckObjects[i] = CreateObject(deckHash, 1.0, 1.0, 1.0, 0, 0, 1)
            SetModelAsNoLongerNeeded(deckHash)
            SetEntityVisible(deckObjects[i], true, 0)
            AttachEntityToEntity(deckObjects[i], dealerEntity, deckProps.bone, deckProps.x, deckProps.y, deckProps.z, deckProps.xR, deckProps.yR, deckProps.zR, 1, 0, 0, 0, 2, 1)
        end
    end

    Citizen.CreateThread(function()
      while inCasino do
        for _, tblConfig in pairs(cfg.blackjackTables) do
          if tblConfig.texture and not tblConfig.isPokerTable then
            local blackjackTable = GetClosestObjectOfType(tblConfig.tablePos,1.0,GetHashKey(tblConfig.prop),0,0,0)
            while blackjackTable == 0 do
              Citizen.Wait(100)
              blackjackTable = GetClosestObjectOfType(tblConfig.tablePos,1.0,GetHashKey(tblConfig.prop),0,0,0)
            end
            if GetObjectTextureVariation(blackjackTable) ~= tblConfig.texture then
              SetObjectTextureVariant(blackjackTable, tblConfig.texture)
            end
          end
        end
        Citizen.Wait(10000)
      end
    end)
end)

function resetDealerIdle(dealerPed)
    local gender = getDealerGenderFromPed(dealerPed)
    if DoesEntityExist(dealerPed) then
        if gender == "male" then 
            genderAnimString = "" 
        end 
        if gender == "female" then 
            genderAnimString = "female_" 
        end 
        dealerAnimDict = "anim_casino_b@amb@casino@games@shared@dealer@"
        RequestAnimDict(dealerAnimDict)
        while not HasAnimDictLoaded(dealerAnimDict) do
            Wait(0)
        end
        TaskPlayAnim(dealerPed, dealerAnimDict, genderAnimString .. "idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
        PlayFacialAnim(dealerPed, "idle_facial", dealerAnimDict)
    end
end

function CasinoWaitTimer()
    if not closeToCasino then
        Wait(5000)
    else
        Wait(0)
    end
end

Citizen.CreateThread(function()
    while true do 
        if shouldForceIdleCardGames and (sittingAtBlackjackTable or isSittingAtPokerTable) then
            TaskPlayAnim(GetPlayerPed(-1), "anim_casino_b@amb@casino@games@shared@player@", "idle_cardgames", 1.0, 1.0, -1, 0)
        end
        CasinoWaitTimer()
    end
end)

local playedCasinoGuiSound = false

function format_int(number)
  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  int = int:reverse():gsub("(%d%d%d)", "%1,")
  return minus .. int:reverse():gsub("^,", "") .. fraction .. '.00'
end
function dwGetLimitTitleString()
  local tableId = blackjack_func_368(closestChair)
  local limits = cfg.blackjackTables[tableId].limits
  return "($" .. format_int(limits.min) .. ")"
end

Citizen.CreateThread(function()
    local uiIntShown = false
    while true do 
        if not sittingAtBlackjackTable then
            if closestChair ~= nil and closestChairDist < 1.6 then
                if not timeoutHowToBlackjack then
                    if not uiIntShown then
                        local tableId = blackjack_func_368(closestChair)
                        local isHighRoller = cfg.blackjackTables[tableId].highroller
                        local background = "info"
                        if exports['np-inventory']:hasEnoughOfItem("casinomember", 1, false, true) and not isHighRoller then
                            background = "success"
                            canPlayAtCurrentTable = true
                        elseif exports['np-inventory']:hasEnoughOfItem("casinovip", 1, false, true) then
                            background = "success"
                            canPlayAtCurrentTable = true
                        else
                            background = "error"
                            canPlayAtCurrentTable = false
                        end
                        exports["np-ui"]:showInteraction(
                          "[E] Play! " .. dwGetLimitTitleString(),
                          background
                        )
                        uiIntShown = true
                    end
                end
            elseif uiIntShown then
                uiIntShown = false
                local background = "info"
                if exports['np-inventory']:hasEnoughOfItem("casinomember", 1, false, true) or exports['np-inventory']:hasEnoughOfItem("casinovip", 1, false, true) then
                    background = "success"
                else
                    background = "error"
                end
                exports["np-ui"]:hideInteraction(background)
            end
        elseif uiIntShown then
            uiIntShown = false
            local background = "info"
            if exports['np-inventory']:hasEnoughOfItem("casinomember", 1, false, true) or exports['np-inventory']:hasEnoughOfItem("casinovip", 1, false, true) then
                background = "success"
            else
                background = "error"
            end
            exports["np-ui"]:hideInteraction(background)
        end            
        CasinoWaitTimer()
    end
end)

local prevCurrentHand = currentHand
local prevDealersHand = dealersHand
Citizen.CreateThread(function()
    while true do
        if drawCurrentHand and (prevCurrentHand ~= currentHand or prevDealersHand ~= dealersHand) then -- @HERE
          prevCurrentHand = currentHand
          if dealersHand ~= 0 and currentHand ~= 0 then
            dwStatusHud({ "Dealer: " .. tostring(dealersHand), "You: " .. tostring(currentHand) })
          else
            dwStatusHud({ "Waiting for dealer..." })
          end
        end
        CasinoWaitTimer()
    end
end)

RegisterNetEvent("Blackjack:successBlackjackBet")
AddEventHandler("Blackjack:successBlackjackBet",function()
    bettedThisRound = true 
    dwWaitForBet(false)
    canExitBlackjack = false
    blackjackInstructional = nil
end)

Citizen.CreateThread(function()
    while true do
        if closestChair ~= -1 and closestChairDist < 2 then 
            if IsControlJustPressed(0, 38) then
                if canPlayAtCurrentTable then
                    TriggerServerEvent("Blackjack:requestSitAtBlackjackTable", closestChair) 
                end
            end
        end
        CasinoWaitTimer()
    end
end)

RegisterNetEvent("Blackjack:sitAtBlackjackTable")
AddEventHandler("Blackjack:sitAtBlackjackTable",function(chair)
    goToBlackjackSeat(chair)
end)

RegisterUICallback("np-ui:blackjackHitStand", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  local action = data.key
  waitingForStandOrHitState = false
  drawTimerBar = false
  standOrHitThisRound = true
  shownHitStandContextOptions = false
  if action == "hit" then
    TriggerServerEvent("Blackjack:hitBlackjack", globalGameId, globalNextCardCount)
    requestCard()
  elseif action == "double" then
    local dwUseChipsResult = RPC.execute("np-casino:useChips", currentBetAmount)
    if dwUseChipsResult then
      dwCurrentChipCount = dwCurrentChipCount - currentBetAmount
      currentBetAmount = currentBetAmount * 2
    else
      TriggerEvent("DoLongHudText", "No balance to double; regular hit", 2)
    end
    TriggerServerEvent("Blackjack:hitBlackjack", globalGameId, globalNextCardCount, dwUseChipsResult)
    requestCard()
  elseif action == "surrender" then
    dwRefreshChipCount = true
    -- RPC.execute("np-casino:winChips", currentBetAmount / 2)
    TriggerServerEvent("Blackjack:standBlackjack", true, currentBetAmount)
    declineCard()
  elseif action == "stand" then
    TriggerServerEvent("Blackjack:standBlackjack")
    declineCard()
  end
end)
AddEventHandler("np-ui:application-closed", function(name)
  if name ~= "contextmenu" then return end
  if sittingAtBlackjackTable and waitingForStandOrHitState then
    waitingForStandOrHitState = false
    drawTimerBar = false
    standOrHitThisRound = true
    shownHitStandContextOptions = false
    TriggerServerEvent("Blackjack:standBlackjack")
  end
end)

local isDwIdleStateActive = false
function dwIdleState(act)
  if act and not isDwIdleStateActive then
    isDwIdleStateActive = true
    dwStatusHud({ "Waiting for dealer..." })
  elseif not act and isDwIdleStateActive then
    isDwIdleStateActive = false
    exports["np-ui"]:sendAppEvent("status-hud", {
      show = false,
    })
  end
end

Citizen.CreateThread(function()
    while true do
        dwIdleState(sittingAtBlackjackTable)
        if sittingAtBlackjackTable and canExitBlackjack then
            SetPedCapsule(PlayerPedId(),0.2) 
            if IsControlJustPressed(0, 202) and not waitingForSitDownState then
                TriggerServerEvent("Blackjack:leaveBlackjackTable")
                FreezeEntityPosition(PlayerPedId(), 0)
                shouldForceIdleCardGames = false
                sittingAtBlackjackTable = false
                timeoutHowToBlackjack = true
                blackjackInstructional = nil
                bettingInstructional = nil
                waitingForStandOrHitState = false
                shownHitStandContextOptions = false
                SetEntityCollision(PlayerPedId(), 1, 1)
                dwWaitForBet(false)
                drawCurrentHand = false
                drawTimerBar = false
                closestDealerPed, closestDealerPedDistance = getClosestDealer()
                Wait(0)
                blackjackAnimDictToLoad = "anim_casino_b@amb@casino@games@shared@player@"
                RequestAnimDict(blackjackAnimDictToLoad)
                while not HasAnimDictLoaded(blackjackAnimDictToLoad) do 
                    Wait(0)
                end
                NetworkStopSynchronisedScene(Local_198f_255)
                ClearPedTasksImmediately(PlayerPedId())
                TaskPlayAnim(GetPlayerPed(-1), blackjackAnimDictToLoad, "sit_exit_left", 1.0, 1.0, 2500, 0)
                PlayAmbientSpeech1(closestDealerPed,"MINIGAME_DEALER_LEAVE_NEUTRAL_GAME","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
                SetTimeout(5000,function()
                    timeoutHowToBlackjack = false
                end)
            end
        end
        -- if waitingForStandOrHitState and sittingAtBlackjackTable and blackjackGameInProgress then
        --     if not shownHitStandContextOptions then
        --       shownHitStandContextOptions = true
        --       local data = {}
        --       if dwTotalCardsDealt == 2 then
        --         data[#data + 1] = {
        --           action = "np-ui:blackjackHitStand",
        --           title = "Double ($" .. format_int(currentBetAmount) .. ")",
        --           description = "Do it pussy",
        --           key = "double",
        --         }
        --       end
        --       data[#data + 1] = {
        --         action = "np-ui:blackjackHitStand",
        --         title = "Hit",
        --         description = "Draw another card",
        --         key = "hit",
        --       }
        --       data[#data + 1] = {
        --         action = "np-ui:blackjackHitStand",
        --         title = "Stand",
        --         description = "Be a pussy",
        --         key = "stand",
        --       }
        --       exports["np-ui"]:showContextMenu(data)
        --     end
        -- end
        CasinoWaitTimer()
    end
end)

Citizen.CreateThread(function()
    while true do 
        local playerCoords = GetEntityCoords(GetPlayerPed(-1))
        closeToCasino = false
        for k,v in pairs(cfg.blackjackTables) do
            cfg.blackjackTables[k].distance = #(playerCoords-cfg.blackjackTables[k].tablePos)
            if cfg.blackjackTables[k].distance < 100.0 then
                closeToCasino = true
            end
        end
        Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do 
        if closeToCasino then
            closestChairDist = 1000
            closestChair = -1
            prevClosestChair = -1
            local playerCoords = GetEntityCoords(GetPlayerPed(-1))
            for i=0,((#cfg.blackjackTables+1)*4)-1,1 do
                local vectorOfBlackjackSeat = blackjack_func_348(i)
                local distToBlackjackSeat = #(playerCoords - vectorOfBlackjackSeat)
                if distToBlackjackSeat < closestChairDist then 
                    closestChairDist = distToBlackjackSeat
                    closestChair = i
                end
            end
        end
        Wait(500)
    end
end)

local timerBarHasBeenDrawn = false
Citizen.CreateThread(function()
    while true do
        if drawTimerBar and not timerBarHasBeenDrawn then
            timerBarHasBeenDrawn = true
            exports["np-ui"]:sendAppEvent("hud", {
              displayBlackjackTimer = true,
            })
        elseif not drawTimerBar and timerBarHasBeenDrawn then
            timerBarHasBeenDrawn = false
            exports["np-ui"]:sendAppEvent("hud", {
              displayBlackjackTimer = false,
            })
        end
        CasinoWaitTimer()
    end
end)

RegisterNetEvent("Blackjack:syncChipsPropBlackjack")
AddEventHandler("Blackjack:syncChipsPropBlackjack",function(betAmount,chairId)
    if closeToCasino then
        betBlackjack(betAmount,chairId)
    end
end)

RegisterUICallback("np-ui:blackJackBet", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  -- exports["np-ui"]:closeApplication("textbox")
  currentBetAmount = tonumber(data.key)
  local tableId = blackjack_func_368(closestChair)
  local limits = cfg.blackjackTables[tableId].limits
  dwTotalCardsDealt = 0
  if dwWaitingForBetTimeout + 19000 < GetGameTimer() then
    TriggerEvent("DoLongHudText", "Took too long.", 2)
    return
  end
  if currentBetAmount and currentBetAmount >= limits.min and currentBetAmount <= limits.max then
      local dwUseChipsResult = RPC.execute("np-casino:useChips", currentBetAmount)
      dwRefreshChipCount = true
      if dwUseChipsResult then
        dwStatusHud({ "Bet: $" .. format_int(currentBetAmount) })
        TriggerServerEvent("Blackjack:setBlackjackBet", globalGameId, currentBetAmount, closestChair)
        closestDealerPed = getClosestDealer()
        PlayAmbientSpeech1(closestDealerPed,"MINIGAME_DEALER_PLACE_CHIPS","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1) --TODO check this is the right sound?
        putBetOnTable()
        Wait(1000)
      else
        currentBetAmount = 0
        TriggerEvent("DoLongHudText", "Not enough chips!", 2)
        Wait(1000)
        if not sittingAtBlackjackTable and waitingForBetState then
            dwWaitForBet(true)
        end
      end
  else
      currentBetAmount = 0
      TriggerEvent("DoLongHudText", "Invalid amount entered", 2)
      Wait(1000)
      if not sittingAtBlackjackTable and waitingForBetState then
          dwWaitForBet(true)
      end
  end
end)

AddEventHandler("np-ui:application-closed", function(name, data)
  if sittingAtBlackjackTable and name == "textbox" and data and data.fromEscape then
    currentBetAmount = 0
    dwStatusHud({ "Waiting for dealer..." })
  end
end)

function dwWaitForBet(act)
  waitingForBetState = act
  if waitingForBetState then
    dwWaitingForBetTimeout = GetGameTimer()
    Wait(2000)
    if sittingAtBlackjackTable then
      -- shownHitStandContextOptions = false
      local tableId = blackjack_func_368(closestChair)
      local limits = cfg.blackjackTables[tableId].limits
      local data = {}
      data[#data + 1] = {
        action = "np-ui:blackJackBet",
        title = "Place bet",
        i18nTitle = true,
        description = dwGetLimitTitleString(),
        key = limits.max,
      }
      exports["np-ui"]:showContextMenu(data)
      dwStatusHud({ "Waiting for bet..." })
    end
    return
  end
end

RegisterNetEvent("Blackjack:beginBetsBlackjack")
AddEventHandler("Blackjack:beginBetsBlackjack",function(gameID,tableId)
    globalGameId = gameID
    blackjackInstructional = nil
    ClearHelp(true)
    bettedThisRound = false
    drawTimerBar = true
    drawCurrentHand = false
    standOrHitThisRound = false
    canExitBlackjack = true
    ---- print("waitingForBetState = true from beginbets")
    dwWaitForBet(true) -- waitingForBetState = true
    dealerPed = getDealerFromTableId(tableId)
    PlayAmbientSpeech1(dealerPed,"MINIGAME_DEALER_PLACE_BET","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
    currentBetAmount = 0
    dealersHand = 0
    currentHand = 0
    dwTotalCardsDealt = 0
    SetEntityCoordsNoOffset(dealerPed, cfg.blackjackTables[tableId].dealerPos.x,cfg.blackjackTables[tableId].dealerPos.y,cfg.blackjackTables[tableId].dealerPos.z, 0,0,1)
    SetEntityHeading(dealerPed, cfg.blackjackTables[tableId].dealerHeading)
    Citizen.CreateThread(function()
        drawTimerBar = true
        while sittingAtBlackjackTable and timeLeft > 0 do 
            timeLeft = timeLeft - 1
            Wait(1000)
        end
        timeLeft = 20
        drawTimerBar = false
    end)
end)

RegisterNetEvent("Blackjack:beginCardGiveOut")
AddEventHandler("Blackjack:beginCardGiveOut",function(gameId, cardData, chairId, cardIndex, gotCurrentHand, tableId)
    if closeToCasino then
        blackjackGameInProgress = true
        ---- print("Blackjack:beginCardGiveOut",gameId,cardData,chairId,cardIndex,gotCurrentHand,tableId)
        blackjackAnimsToLoad = {
            "anim_casino_b@amb@casino@games@blackjack@dealer",
            "anim_casino_b@amb@casino@games@shared@dealer@",
            "anim_casino_b@amb@casino@games@blackjack@player",  
            "anim_casino_b@amb@casino@games@shared@player@",
        }
        for k,v in pairs(blackjackAnimsToLoad) do 
            RequestAnimDict(v)
            while not HasAnimDictLoaded(v) do 
                Wait(0)
            end
        end
        if sittingAtBlackjackTable and bettedThisRound then
            drawCurrentHand = true
        end
        dealerPed = getDealerFromTableId(tableId)
        cardObj = startDealing(dealerPed,gameId,cardData,chairId,cardIndex+1,gotCurrentHand,((tableId+1)*4)-1)
        if blackjack_func_368(closestChair) == tableId and gameId == chairId and cardIndex == 0 then
            dealersHand = gotCurrentHand
            blackjackInstructional = nil
        end
        dealerSecondCardFromGameId[gameId] = cardObj
        if chairId == closestChair and gameId ~= chairId then
            dwTotalCardsDealt = dwTotalCardsDealt + 1
            currentHand = gotCurrentHand
            blackjackInstructional = nil
        end
    end
end)

RegisterNetEvent("Blackjack:singleCard")
AddEventHandler("Blackjack:singleCard",function(gameId,cardData,chairID,nextCardCount,gotCurrentHand,tableId)
    if closeToCasino then
        dealerPed = getDealerFromTableId(tableId)
        startSingleDealing(chairID,dealerPed,gameId,cardData,nextCardCount+1,gotCurrentHand)
    end
end)

RegisterNetEvent("Blackjack:singleDealerCard")
AddEventHandler("Blackjack:singleDealerCard",function(gameId,cardData,nextCardCount,gotCurrentHand,tableId)
    if closeToCasino then
        dealerPed = getDealerFromTableId(tableId)
        startSingleDealerDealing(dealerPed,gameId,cardData,nextCardCount+1,gotCurrentHand,((tableId+1)*4)-1,tableId)
    end
end)

RegisterNetEvent("Blackjack:standOrHitPrompt")
AddEventHandler("Blackjack:standOrHitPrompt", function()
  local data = {}
  if dwTotalCardsDealt == 2 then
    data[#data + 1] = {
      action = "np-ui:blackjackHitStand",
      i18nTitle = "Double",
      i18nDescription = true,
      title = "Double ($" .. format_int(currentBetAmount) .. ")",
      description = "Do it pussy",
      key = "double",
    }
  end
  data[#data + 1] = {
    action = "np-ui:blackjackHitStand",
    i18nTitle = true,
    i18nDescription = true,
    title = "Hit",
    description = "Draw another card",
    key = "hit",
  }
  data[#data + 1] = {
    action = "np-ui:blackjackHitStand",
    i18nTitle = true,
    i18nDescription = true,
    title = "Stand",
    description = "Be a pussy",
    key = "stand",
  }
  if dwTotalCardsDealt == 2 then
    data[#data + 1] = {
      action = "np-ui:blackjackHitStand",
      i18nTitle = true,
      i18nDescription = true,
      title = "Surrender",
      description = "The easy way out",
      key = "surrender",
    }
  end
  exports["np-ui"]:showContextMenu(data)
end)

RegisterNetEvent("Blackjack:standOrHit")
AddEventHandler("Blackjack:standOrHit", function(gameId, chairId, nextCardCount, tableId)
    if closeToCasino then
        dealerPed = getDealerFromTableId(tableId)
        standOrHitThisRound = false
        if closestChair == chairId then
            globalNextCardCount = nextCardCount
            waitingForStandOrHitState = true
            PlayAmbientSpeech1(dealerPed,"MINIGAME_BJACK_DEALER_ANOTHER_CARD","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
            startStandOrHit(gameId,dealerPed,chairId,true)
            Citizen.CreateThread(function()
                if sittingAtBlackjackTable then
                    drawTimerBar = true
                    timeLeft = 20
                    while timeLeft > 0 do 
                        timeLeft = timeLeft - 1
                        if timeLeft == 6 then
                            PlayAmbientSpeech1(dealerPed,"MINIGAME_DEALER_COMMENT_SLOW","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
                        end
                        if standOrHitThisRound then
                            timeLeft = 20
                            drawTimerBar = false
                            return
                        end
                        Wait(1000)
                    end
                end
                if not standOrHitThisRound and sittingAtBlackjackTable then
                    waitingForStandOrHitState = false
                    TriggerServerEvent("Blackjack:standBlackjack")
                    declineCard()
                end
            end)
        else 
            startStandOrHit(gameId,dealerPed,chairId,false)
        end
    end
end)

function getClosestDealer()
    local tmpclosestDealerPed = nil
    local tmpclosestDealerPedDistance = 100000
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(dealerPeds) do 
        local dealerPed = v
        local distanceToDealer = #(playerCoords - GetEntityCoords(dealerPed))
        if distanceToDealer < tmpclosestDealerPedDistance then 
            tmpclosestDealerPedDistance = distanceToDealer
            tmpclosestDealerPed = dealerPed
        end
    end
    closestDealerPed = tmpclosestDealerPed
    closestDealerPedDistance = tmpclosestDealerPedDistance
    return closestDealerPed, closestDealerPedDistance
end

function getDealerFromChairId(chairId)
    tableId = blackjack_func_368(chairId)
    closestDealerPed = dealerPeds[tableId+1]
    return closestDealerPed
end

function getDealerFromTableId(tableId)
    closestDealerPed = dealerPeds[tableId+1]
    return closestDealerPed
end

function goToBlackjackSeat(blackjackSeatID)
    sittingAtBlackjackTable = true
    waitingForSitDownState = true
    shownHitStandContextOptions = false
    canExitBlackjack = true
    currentHand = 0
    dwTotalCardsDealt = 0
    dealersHand = 0
    closestDealerPed, closestDealerPedDistance = getClosestDealer()
    PlayAmbientSpeech1(closestDealerPed,"MINIGAME_DEALER_GREET","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
    blackjackAnimsToLoad = {
      "anim_casino_b@amb@casino@games@blackjack@dealer",
      "anim_casino_b@amb@casino@games@shared@dealer@",
      "anim_casino_b@amb@casino@games@blackjack@player",  
      "anim_casino_b@amb@casino@games@shared@player@",
    }
    for k,v in pairs(blackjackAnimsToLoad) do 
      RequestAnimDict(v)
      while not HasAnimDictLoaded(v) do 
          Wait(0)
      end
    end
    Local_198f_247 = blackjackSeatID
    fVar3 = blackjack_func_217(PlayerPedId(),blackjack_func_218(Local_198f_247, 0), 1)
    fVar4 = blackjack_func_217(PlayerPedId(),blackjack_func_218(Local_198f_247, 1), 1)
    fVar5 = blackjack_func_217(PlayerPedId(),blackjack_func_218(Local_198f_247, 2), 1)
    if (fVar4 < fVar5 and fVar4 < fVar3) then 
      Local_198f_251 = 1
    elseif (fVar5 < fVar4 and fVar5 < fVar3) then 
      Local_198f_251 = 2
    else
      Local_198f_251 = 0
    end
    local walkToVector = blackjack_func_218(Local_198f_247, Local_198f_251)
    local targetHeading = blackjack_func_216(Local_198f_247, Local_198f_251)
    TaskGoStraightToCoord(PlayerPedId(), walkToVector.x, walkToVector.y, walkToVector.z, 1.0, 5000, targetHeading, 0.01)

    local goToVector = blackjack_func_348(Local_198f_247)
    local xRot,yRot,zRot = blackjack_func_215(Local_198f_247)
    Local_198f_255 = NetworkCreateSynchronisedScene(goToVector.x, goToVector.y, goToVector.z, xRot, yRot, zRot, 2, 1, 0, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), Local_198f_255, "anim_casino_b@amb@casino@games@shared@player@", blackjack_func_213(Local_198f_251), 2.0, -2.0, 13, 16, 2.0, 0) -- 8.0, -1.5, 157, 16, 1148846080, 0) ?
    NetworkStartSynchronisedScene(Local_198f_255)
    Citizen.InvokeNative(0x79C0E43EB9B944E2, -2124244681)
    Wait(6000)
    Locali98f_55 = NetworkCreateSynchronisedScene(goToVector.x, goToVector.y, goToVector.z, xRot, yRot, zRot, 2, 1, 1, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), Locali98f_55, "anim_casino_b@amb@casino@games@shared@player@", "idle_cardgames", 2.0, -2.0, 13, 16, 1148846080, 0)
    NetworkStartSynchronisedScene(Locali98f_55)
    StartAudioScene("DLC_VW_Casino_Table_Games") --need to stream this
    Citizen.InvokeNative(0x79C0E43EB9B944E2, -2124244681)
    waitingForSitDownState = false
    shouldForceIdleCardGames = true
    FreezeEntityPosition(PlayerPedId(), 1)
    SetEntityCollision(PlayerPedId(), 0, 1)
end 

function betBlackjack(amount,chairId)
    local chipsProp = getChipPropFromAmount(amount)
    for i,v in ipairs(chipsProp) do 
        betChipsForNextHand(100,v,0,chairId,false,(i-1)/200) --false or true no clue
    end
end

function startSingleDealerDealing(dealerPed,gameId,cardData,nextCardCount,gotCurrentHand,chairId,tableId)
    N_0x469f2ecdec046337(1)
    StartAudioScene("DLC_VW_Casino_Cards_Focus_Hand") --need to stream this
    ensureCardModelsLoaded()
    local gender = getDealerGenderFromPed(dealerPed)
    if DoesEntityExist(dealerPed) then
        cardPosition = nextCardCount
        nextCard = getCardFromNumber(cardData, true)
        local nextCardObj = getNewCardFromMachine(nextCard,chairId,gameId)
        AttachEntityToEntity(nextCardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
        if gender == "male" then 
            genderAnimString = "" 
        end 
        if gender == "female" then 
            genderAnimString = "female_" 
        end 
        dealerGiveSelfCard(genderAnimString,dealerPed,3,nextCardObj)
        DetachEntity(nextCardObj,false,true)
        if blackjack_func_368(closestChair) == tableId then
            dealersHand = gotCurrentHand
        end
        local soundCardString = "MINIGAME_BJACK_DEALER_" .. tostring(gotCurrentHand)
        PlayAmbientSpeech1(dealerPed,soundCardString,"SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
        vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId)))
        local tablePosX,tablePosY,tablePosZ = getTableCoords(blackjack_func_368(chairId))
        local cardQueue = cardPosition -- number of card
        local iVar5 = cardQueue
        cardOffsetX,cardOffsetY,cardOffsetZ = blackjack_func_377(iVar5, 4, 1) --iVar9 is seat number 0-3
        local cardPos = GetObjectOffsetFromCoords(tablePosX, tablePosY, tablePosZ, vVar8.z, cardOffsetX, cardOffsetY, cardOffsetZ)
        SetEntityCoordsNoOffset(nextCardObj, cardPos.x, cardPos.y, cardPos.z, 0, 0, 1)
        Wait(400)
    end
end

function startSingleDealing(chairId,dealerPed,gameId,cardData,nextCardCount,gotCurrentHand)
    N_0x469f2ecdec046337(1)
    StartAudioScene("DLC_VW_Casino_Cards_Focus_Hand")
    ensureCardModelsLoaded()
    local gender = getDealerGenderFromPed(dealerPed)
    if DoesEntityExist(dealerPed) then
        local localChairId = getLocalChairIdFromGlobalChairId(chairId)
        cardPosition = nextCardCount
        nextCard = getCardFromNumber(cardData,true)
        local nextCardObj = getNewCardFromMachine(nextCard,chairId)
        AttachEntityToEntity(nextCardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
        if gender == "male" then 
            genderAnimString = "" 
        end 
        if gender == "female" then 
            genderAnimString = "female_" 
        end 
        dealerGiveCards(chairId,genderAnimString,dealerPed,nextCardObj) 
        DetachEntity(nextCardObj,false,true)
        if chairId == closestChair then
            dwTotalCardsDealt = dwTotalCardsDealt + 1
            currentHand = gotCurrentHand
        end
        local soundCardString = "MINIGAME_BJACK_DEALER_" .. tostring(gotCurrentHand)
        PlayAmbientSpeech1(dealerPed,soundCardString,"SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
        vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId)))
        local tablePosX,tablePosY,tablePosZ = getTableCoords(blackjack_func_368(chairId))
        local cardQueue = cardPosition -- number of card
        local iVar5 = cardQueue
        local iVar9 = localChairId - 1-- <-ChairID 0-3
        if iVar9 <= 4 then
            cardOffsetX,cardOffsetY,cardOffsetZ = blackjack_func_377(iVar5, iVar9, 0) --iVar9 is seat number 0-3
        else 
            cardOffsetX,cardOffsetY,cardOffsetZ = 0.5737, 0.2376, 0.948025
        end
        local cardPos = GetObjectOffsetFromCoords(tablePosX, tablePosY, tablePosZ, vVar8.z, cardOffsetX, cardOffsetY, cardOffsetZ)
        SetEntityCoordsNoOffset(nextCardObj, cardPos.x, cardPos.y, cardPos.z, 0, 0, 1)
        vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId)))
        cardObjectOffsetRotation = vVar8 + func_376(iVar5, iVar9, 0, false)
        SetEntityRotation(nextCardObj, cardObjectOffsetRotation.x, cardObjectOffsetRotation.y, cardObjectOffsetRotation.z, 2, 1)
        Wait(400)
    end
end

function startDealing(dealerPed,gameId,cardData,chairId,cardIndex,gotCurrentHand,fakeChairIdForDealerTurn)
    N_0x469f2ecdec046337(1)
    StartAudioScene("DLC_VW_Casino_Cards_Focus_Hand")
    ensureCardModelsLoaded()
    local gender = getDealerGenderFromPed(dealerPed)
    if DoesEntityExist(dealerPed) then
        nextCard = getCardFromNumber(cardData[cardIndex],true)
        local nextCardObj = getNewCardFromMachine(nextCard,chairId)
        AttachEntityToEntity(nextCardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
        if gender == "male" then 
            genderAnimString = "" 
        end 
        if gender == "female" then 
            genderAnimString = "female_" 
        end 
        if chairId <= 1000 then
            dealerGiveCards(chairId,genderAnimString,dealerPed,nextCardObj) 
        else 
            dealerGiveSelfCard(genderAnimString,dealerPed,cardIndex,nextCardObj) 
        end
        DetachEntity(nextCardObj,false,true)
        if chairId ~= gameId or cardIndex ~= 2 then
            local soundCardString = "MINIGAME_BJACK_DEALER_" .. tostring(gotCurrentHand)
            PlayAmbientSpeech1(dealerPed,soundCardString,"SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
        end
        cardQueue = cardIndex
        iVar5 = cardQueue
        iVar9 = chairId
        if chairId <= 1000 then
            vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId)))
            tablePosX,tablePosY,tablePosZ = getTableCoords(blackjack_func_368(chairId))
            cardOffsetX,cardOffsetY,cardOffsetZ = blackjack_func_377(iVar5, getLocalChairIndexFromGlobalChairId(chairId), 0)
        else
            vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(fakeChairIdForDealerTurn)))
            tablePosX,tablePosY,tablePosZ = getTableCoords(blackjack_func_368(fakeChairIdForDealerTurn))
            cardOffsetX,cardOffsetY,cardOffsetZ = blackjack_func_377(iVar5, 4, 1)
        end
        local cardPos = GetObjectOffsetFromCoords(tablePosX, tablePosY, tablePosZ, vVar8.z, cardOffsetX, cardOffsetY, cardOffsetZ)
        SetEntityCoordsNoOffset(nextCardObj, cardPos.x, cardPos.y, cardPos.z, 0, 0, 1)
        if chairId <= 1000 then
            vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId))) 
            cardObjectOffsetRotation = vVar8 + func_376(iVar5, getLocalChairIndexFromGlobalChairId(chairId), 0, false)
            SetEntityRotation(nextCardObj, cardObjectOffsetRotation.x, cardObjectOffsetRotation.y, cardObjectOffsetRotation.z, 2, 1)
        else 
            cardObjectOffsetRotation = blackjack_func_398(blackjack_func_368(fakeChairIdForDealerTurn))
        end
        return nextCardObj
    end 
end

function startStandOrHit(gameId,dealerPed,chairId,actuallyPlaying)
    chairAnimId = getLocalChairIdFromGlobalChairId(chairId)
    gender = getDealerGenderFromPed(dealerPed)
    if gender == "male" then 
        genderAnimString = "" 
    end 
    if gender == "female" then 
        genderAnimString = "female_" 
    end
    RequestAnimDict("anim_casino_b@amb@casino@games@blackjack@dealer")
    while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@dealer") do 
        Wait(0)
    end
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle_intro", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    PlayFacialAnim(dealerPed, genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
    Wait(0)
    while IsEntityPlayingAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle_intro") do 
        Wait(10)
    end
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    if actuallyPlaying then
        waitingForPlayerToHitOrStand = true
    end
end

function flipDealerCard(dealerPed,gotCurrentHand,tableId,gameId)
    cardObj = dealerSecondCardFromGameId[gameId]
    local cardX,cardY,cardZ = GetEntityCoords(cardObj)
    local gender = getDealerGenderFromPed(dealerPed)
    if gender == "male" then 
        genderAnimString = "" 
    end 
    if gender == "female" then 
        genderAnimString = "female_" 
    end 
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "check_and_turn_card", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    while not HasAnimEventFired(dealerPed,-1345695206) do
        Wait(0)
    end
    AttachEntityToEntity(cardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
    while not HasAnimEventFired(dealerPed,585557868) do
        Wait(0)
    end
    DetachEntity(cardObj,false,true)
    if blackjack_func_368(closestChair) == tableId then
        dealersHand = gotCurrentHand
    end    
    local soundCardString = "MINIGAME_BJACK_DEALER_" .. tostring(gotCurrentHand)
    PlayAmbientSpeech1(dealerPed,soundCardString,"SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
    SetEntityCoordsNoOffset(cardObj, cardX,cardY,cardZ)
end

function checkCard(dealerPed,cardObj)
    local cardX,cardY,cardZ = GetEntityCoords(cardObj)
    AttachEntityToEntity(cardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
    local gender = getDealerGenderFromPed(dealerPed)
    if gender == "male" then 
        genderAnimString = "" 
    end 
    if gender == "female" then 
        genderAnimString = "female_" 
    end 
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "check_card", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    PlayFacialAnim(dealerPed, genderAnimString .. "check_card_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
    while not HasAnimEventFired(dealerPed,585557868) do
        Wait(0)
    end
    Wait(100)
    DetachEntity(cardObj,false,true)
    SetEntityCoordsNoOffset(cardObj, cardX,cardY,cardZ)
end

RegisterNetEvent("Blackjack:endStandOrHitPhase")
AddEventHandler("Blackjack:endStandOrHitPhase",function(chairId,tableId)
    if closeToCasino then
        dealerPed = getDealerFromTableId(tableId)
        waitingForPlayerToHitOrStand = false
        chairAnimId = getLocalChairIdFromGlobalChairId(chairId)
        gender = getDealerGenderFromPed(dealerPed)
        if gender == "male" then 
            genderAnimString = "" 
        end 
        if gender == "female" then 
            genderAnimString = "female_" 
        end
        TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle_outro", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
        PlayFacialAnim(dealerPed, genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle_outro_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
    end
end)

RegisterNetEvent("Blackjack:bustBlackjack")
AddEventHandler("Blackjack:bustBlackjack",function(chairID,tableId)
    if closeToCasino then
        dealerPed = getDealerFromTableId(tableId)
        PlayAmbientSpeech1(dealerPed,"MINIGAME_BJACK_DEALER_PLAYER_BUST","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
        TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", "reaction_bad", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
        if chairID == closestChair and sittingAtBlackjackTable then 
            angryIBust()
            drawCurrentHand = false
            currentHand = 0
            dwTotalCardsDealt = 0
            dealersHand = 0
        end
    end
end)

RegisterNetEvent("Blackjack:flipDealerCard")
AddEventHandler("Blackjack:flipDealerCard",function(gotCurrentHand,tableId,gameId)
    if closeToCasino then
        dealerPed = getDealerFromTableId(tableId)
        flipDealerCard(dealerPed,gotCurrentHand,tableId,gameId)
    end
end)

RegisterNetEvent("Blackjack:dealerBusts")
AddEventHandler("Blackjack:dealerBusts",function(tableId)
    if closeToCasino then
        dealerPed = getDealerFromTableId(tableId)
        PlayAmbientSpeech1(dealerPed,"MINIGAME_DEALER_BUSTS","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
    end
end)

RegisterNetEvent("Blackjack:blackjackLose")
AddEventHandler("Blackjack:blackjackLose",function(tableId)
    if closeToCasino then
        blackjackGameInProgress = false
        dealerPed = getDealerFromTableId(tableId)
        PlayAmbientSpeech1(dealerPed,"MINIGAME_DEALER_WINS","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
        TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", "reaction_bad", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
        angryILost()
        canExitBlackjack = true
        drawCurrentHand = false
        currentHand = 0
        dwTotalCardsDealt = 0
        dealersHand = 0
    end
end)

RegisterNetEvent("Blackjack:blackjackPush")
AddEventHandler("Blackjack:blackjackPush",function(tableId)
    -- RPC.execute("np-casino:winChips", currentBetAmount)
    dwRefreshChipCount = true
    if closeToCasino then
        blackjackGameInProgress = false
        dealerPed = getDealerFromTableId(tableId)
        TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", "reaction_impartial", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
        annoyedIPushed()
        canExitBlackjack = true
        drawCurrentHand = false
        currentHand = 0
        dwTotalCardsDealt = 0
        dealersHand = 0
    end
end)

RegisterNetEvent("Blackjack:blackjackWin")
AddEventHandler("Blackjack:blackjackWin",function(tableId, dwHitBlackjack)
    local extra = 0
    if dwHitBlackjack then
      extra = currentBetAmount / 2
    end
    -- RPC.execute("np-casino:winChips", (currentBetAmount * 2) + extra)
    dwRefreshChipCount = true
    if closeToCasino then
        blackjackGameInProgress = false
        dealerPed = getDealerFromTableId(tableId)
        TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", "reaction_good", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
        happyIWon()
        canExitBlackjack = true
        drawCurrentHand = false
        currentHand = 0
        dwTotalCardsDealt = 0
        dealersHand = 0
    end
end)


function chipsCleanUp(chairId, tableId)
    if closeToCasino then
        if string.sub(chairId, -5) ~= "chips" then
            dealerPed = getDealerFromTableId(tableId)
            local gender = getDealerGenderFromPed(dealerPed)
            if gender == "male" then 
                genderAnimString = "" 
            end 
            if gender == "female" then 
                genderAnimString = "female_" 
            end
            localChairId = getLocalChairIdFromGlobalChairId(chairId)
            if chairId > 99 then
                TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "retrieve_own_cards_and_remove", 3.0, 1.0, -1, 2, 0, 0, 0, 0)
                PlayFacialAnim(dealerPed, genderAnimString .. "retrieve_own_cards_and_remove_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
            else
                TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "retrieve_cards_player_0" .. tostring(localChairId), 3.0, 1.0, -1, 2, 0, 0, 0, 0)
                PlayFacialAnim(dealerPed, genderAnimString .. "retrieve_cards_player_0" .. tostring(localChairId).."_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
            end
            while not HasAnimEventFired(dealerPed,-1345695206) do
                Wait(0)
            end
            for k,v in pairs(cardObjects) do
                if k == chairId then
                    for k2,v2 in pairs(v) do
                        AttachEntityToEntity(v2, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
                    end
                end
            end
            while not HasAnimEventFired(dealerPed, 585557868) do
                Wait(0)
            end
            for k,v in pairs(cardObjects) do
                if k == chairId then
                    for k2,v2 in pairs(v) do
                        DeleteEntity(v2)
                    end
                end
            end
        else
            for k,v in pairs(cardObjects) do
                if k == chairId then
                    for k2,v2 in pairs(v) do
                        DeleteEntity(v2)
                    end
                end
            end
        end
    end
end

RegisterNetEvent("Blackjack:chipsCleanup")
AddEventHandler("Blackjack:chipsCleanup",function(chairId, tableId)
    chipsCleanUp(chairId, tableId)
    chipsCleanUp(tostring(chairId).."chips", tableId)
end)

RegisterNetEvent("Blackjack:chipsCleanupNoAnim")
AddEventHandler("Blackjack:chipsCleanupNoAnim",function(chairId,tableId)
    for k,v in pairs(cardObjects) do
        if k == chairId then
            for k2,v2 in pairs(v) do
                DeleteEntity(v2)
            end
        end
    end
end)

function betChipsForNextHand(chipsAmount,chipsProp,something,chairID,someBool,zOffset)
    RequestModel(chipsProp)
    while not HasModelLoaded(chipsProp) do  
        Wait(0)
        RequestModel(chipsProp)
    end
    vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairID)))
    local tablePosX,tablePosY,tablePosZ = getTableCoords(blackjack_func_368(chairID))
    local chipsVector = blackjack_func_374(chipsAmount,something,getLocalChairIndexFromGlobalChairId(chairID),someBool)
    local chipsOffset = GetObjectOffsetFromCoords(tablePosX,tablePosY,tablePosZ, vVar8.z, chipsVector.x, chipsVector.y, chipsVector.z)
    
    local chipsObj = CreateObjectNoOffset(GetHashKey(chipsProp), chipsOffset.x,chipsOffset.y,chipsOffset.z, false, false, 1)
    if cardObjects[tostring(chairID) .. "chips"] ~= nil then
        table.insert(cardObjects[tostring(chairID) .. "chips"], chipsObj)
    else 
        cardObjects[tostring(chairID) .. "chips"] = {}
        table.insert(cardObjects[tostring(chairID) .. "chips"],chipsObj)
    end
    SetEntityCoordsNoOffset(chipsObj, chipsOffset.x, chipsOffset.y, chipsOffset.z+zOffset, 0, 0, 1)
    local chipOffsetRotation = blackjack_func_373(chipsAmount,0,getLocalChairIndexFromGlobalChairId(chairID),someBool)
    SetEntityRotation(chipsObj,vVar8 + chipOffsetRotation, 2, 1)
end 

function getDealerGenderFromPed(dealerPed)
    maleCasinoDealer = GetHashKey("S_M_Y_Casino_01")
    femaleCasinoDealer = GetHashKey("S_F_Y_Casino_01")

    if GetEntityModel(dealerPed) == maleCasinoDealer then 
        return "male" 
    end 
    return "female"
end

function getNewCardFromMachine(nextCard, chairId, gameId)
    RequestModel(nextCard)
    while not HasModelLoaded(nextCard) do  
        Wait(0)
        RequestModel(nextCard)
    end
    nextCardHash = GetHashKey(nextCard)
    local cardObjectOffset = blackjack_func_399(blackjack_func_368(chairId))
    local nextCardObj = CreateObjectNoOffset(nextCardHash, cardObjectOffset.x, cardObjectOffset.y, cardObjectOffset.z, false, false, 1)
    if cardObjects[chairId] ~= nil then 
        if gameId then
            table.insert(cardObjects[gameId], nextCardObj)
        else
            table.insert(cardObjects[chairId], nextCardObj)
        end
    else
        cardObjects[chairId] = {}
        if gameId then
            table.insert(cardObjects[gameId],nextCardObj)
        else
            table.insert(cardObjects[chairId],nextCardObj)
        end
    end
    SetEntityVisible(nextCardObj,false)
    SetModelAsNoLongerNeeded(nextCardHash)
    local cardObjectOffsetRotation = blackjack_func_398(blackjack_func_368(chairId))
    SetEntityCoordsNoOffset(nextCardObj, cardObjectOffset.x, cardObjectOffset.y, cardObjectOffset.z, 0, 0, 1)
    SetEntityRotation(nextCardObj, cardObjectOffsetRotation.x, cardObjectOffsetRotation.y, cardObjectOffsetRotation.z, 2, 1)
    return nextCardObj
end

function dealerGiveCards(chairId,gender,dealerPed,cardObj) --func_36
    local seatNumber = tostring(getLocalChairIdFromGlobalChairId(chairId))
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", gender .. "deal_card_player_0" .. seatNumber, 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    PlayFacialAnim(dealerPed,"deal_card_player_0"..seatNumber.."_facial")
    Wait(300)
    SetEntityVisible(cardObj,true)
    while not HasAnimEventFired(dealerPed, 585557868) do 
        Wait(0)
    end 
end

function dealerGiveSelfCard(gender,dealerPed,cardIndex,cardObj)
    if cardIndex == 1 then 
        cardAnim = "deal_card_self_second_card"
    elseif cardIndex == 2 then 
        cardAnim = "deal_card_self"
    else 
        cardAnim = "deal_card_self_card_10"
    end
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", gender .. cardAnim, 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    PlayFacialAnim(dealerPed, gender .. cardAnim.."_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
    Wait(300)
    SetEntityVisible(cardObj,true)
    while not HasAnimEventFired(dealerPed, 585557868) do 
        Wait(0)
    end
    Wait(100)
end

local chipsProps = {
    "vw_prop_chip_10dollar_x1",
    "vw_prop_chip_50dollar_x1",
    "vw_prop_chip_100dollar_x1",
    "vw_prop_chip_50dollar_st",
    "vw_prop_chip_100dollar_st",
    "vw_prop_chip_500dollar_x1",
    "vw_prop_chip_1kdollar_x1",
    "vw_prop_chip_500dollar_st",
    "vw_prop_chip_5kdollar_x1",
    "vw_prop_chip_1kdollar_st",
    "vw_prop_chip_10kdollar_x1",
    "vw_prop_chip_5kdollar_st",
    "vw_prop_chip_10kdollar_st",
    "vw_prop_plaq_5kdollar_x1",
    "vw_prop_plaq_5kdollar_st",
    "vw_prop_plaq_10kdollar_x1",
    "vw_prop_plaq_10kdollar_st", 
    "vw_prop_vw_chips_pile_01a",
    "vw_prop_vw_chips_pile_02a",
    "vw_prop_vw_chips_pile_03a",
    "vw_prop_vw_coin_01a",
}

function dwDoAnim(a, b)
  local duration = GetAnimDuration(a, b)
  TaskPlayAnim(PlayerPedId(), a, b, 2.0, 0.0, duration, 48, 0.0, 0, 0, 0)
  return (duration * 1000) - ((duration * 1000) * 0.1)
end

function declineCard()
    shouldForceIdleCardGames = false
    local duration = dwDoAnim("anim_casino_b@amb@casino@games@blackjack@player", "decline_card_001")
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end

function putBetOnTable()
    shouldForceIdleCardGames = false
    local duration = dwDoAnim("anim_casino_b@amb@casino@games@blackjack@player", getAnimNameFromBet(100))
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end

function requestCard()
    shouldForceIdleCardGames = false
    local duration = dwDoAnim("anim_casino_b@amb@casino@games@blackjack@player", "request_card")
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end 

function angryIBust()
    if math.random() < 0.8 then return end
    shouldForceIdleCardGames = false
    local duration = dwDoAnim("anim_casino_b@amb@casino@games@shared@player@", "reaction_terrible_var_01")
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end 

function angryILost()
    if math.random() < 0.8 then return end
    shouldForceIdleCardGames = false
    local duration = dwDoAnim("anim_casino_b@amb@casino@games@shared@player@", "reaction_bad_var_01")
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end 

function annoyedIPushed()
    if math.random() < 0.8 then return end
    shouldForceIdleCardGames = false
    local duration = dwDoAnim("anim_casino_b@amb@casino@games@shared@player@", "reaction_impartial_var_01")
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end 

function happyIWon()
    if math.random() < 0.8 then return end
    shouldForceIdleCardGames = false
    local duration = dwDoAnim("anim_casino_b@amb@casino@games@shared@player@", "reaction_good_var_01")
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end 

function blackjack_func_398(iParam0)
	local vVar0 = vector3(0.0, 164.52, 11.5)
	return vector3(getTableHeading(iParam0), 0.0, 0.0) + vVar0;
end

function blackjack_func_399(iParam0)
    local vVar0 = vector3(0.526, 0.571, 0.963)
    local x,y,z = getTableCoords(iParam0)
    return GetObjectOffsetFromCoords(x, y, z, getTableHeading(iParam0), vVar0.x, vVar0.y, vVar0.z)
end


function ensureCardModelsLoaded()
    cardNum = 0;
	while cardNum < 52 do 
        iVar1 = cardNum + 1
        local Local_198f_236 = 1
		iVar2 = getCardFromNumber(iVar1, Local_198f_236)
        if not HasModelLoaded(iVar2) then
            RequestModel(iVar2)
            while not HasModelLoaded(iVar2) do  
                Wait(0)
            end
        end
        cardNum = cardNum + 1
    end
end 


function blackjack_func_204(iParam0, iParam1, bParam2)
    if bParam2 then 
        return vector3(getTableHeading(iParam1), 0.0, 0.0) + vector3(0, 0.061, -59.1316);
    else
        vVar0 = blackjack_func_215(iParam0)
        return vector3(vVar0.z, 0.0, 0.0) + vector3(-87.48, 0, -60.84);
    end
    return 0.0, 0.0, 0.0
end 

function blackjack_func_205(iParam0, iParam1, bParam2)
    if bParam2 then 
        return GetObjectOffsetFromCoords(getTableCoords(iParam1), getTableHeading(iParam1),-0.0094, -0.0611, 1.5098)
    else
        vVar0 = blackjack_func_215(iParam0)
        return GetObjectOffsetFromCoords(blackjack_func_348(iParam0), vVar0.z,0.245, 0.0, 1.415)
    end
    return 0.0, 0.0, 0.0
end

function blackjack_func_216(iParam0, iParam1)
    local goToVector = blackjack_func_348(iParam0)
    local xRot,yRot,zRot = blackjack_func_215(iParam0)
    vVar0 = GetAnimInitialOffsetRotation("anim_casino_b@amb@casino@games@shared@player@", blackjack_func_213(iParam1), goToVector.x, goToVector.y, goToVector.z, xRot, yRot, zRot, 0.01, 2)
    return vVar0.z
end

function blackjack_func_217(iParam0, vParam1, bParam2)
	local vVar0 = {}
    
    if not IsEntityDead(iParam0,0) then 
        vVar0 = GetEntityCoords(iParam0,1)
    else
        vVar0 = GetEntityCoords(iParam0,0)
    end
    return #(vVar0-vParam1)
end

function blackjack_func_218(iParam0, iParam1)
    local goToVector = blackjack_func_348(iParam0)
    local xRot,yRot,zRot = blackjack_func_215(iParam0)
    vVar0 = GetAnimInitialOffsetPosition("anim_casino_b@amb@casino@games@shared@player@", blackjack_func_213(iParam1), goToVector.x, goToVector.y, goToVector.z, xRot, yRot, zRot, 0.01, 2)
    return vVar0
end

function blackjack_func_213(sitAnimID) 
    if sitAnimID == 0 then 
        return "sit_enter_left"
    elseif sitAnimID == 1 then
        return "sit_enter_left_side"
    elseif sitAnimID == 2 then
        return "sit_enter_right_side"
    end
    return "sit_enter_left"
end

function getInverseChairId(chairId)
    if chairId == 0 then return 3 end
    if chairId == 1 then return 2 end
    if chairId == 2 then return 1 end
    if chairId == 3 then return 0 end
end

function blackjack_func_348(iParam0)
    if iParam0 == -1 then
        return vector3(0.0,0.0,0.0)
    end
    local blackjackTableObj
    local tableId = blackjack_func_368(iParam0)
    local x,y,z = getTableCoords(tableId)
    blackjackTableObj = GetClosestObjectOfType(x, y, z, 1.0, cfg.blackjackTables[tableId].prop, 0, 0, 0)
    
    if DoesEntityExist(blackjackTableObj) and DoesEntityHaveDrawable(blackjackTableObj) then
        local localChairId = getLocalChairIndexFromGlobalChairId(iParam0)
        localChairId = getInverseChairId(localChairId) + 1
        return GetWorldPositionOfEntityBone_2(blackjackTableObj,GetEntityBoneIndexByName(blackjackTableObj, "Chair_Base_0"..localChairId))
    end
    return vector3(0.0,0.0,0.0)
end

function blackjack_func_215(iParam0)
    if iParam0 == -1 then
        return vector3(0.0,0.0,0.0)
    end
    local blackjackTableObj
    local tableId = blackjack_func_368(iParam0)
    local x,y,z = getTableCoords(tableId)
    blackjackTableObj = GetClosestObjectOfType(x, y, z, 1.0, cfg.blackjackTables[tableId].prop, 0, 0, 0)
    if DoesEntityExist(blackjackTableObj) and DoesEntityHaveDrawable(blackjackTableObj) then
        local localChairId = getLocalChairIndexFromGlobalChairId(iParam0)
        localChairId = getInverseChairId(localChairId) + 1
        return GetWorldRotationOfEntityBone(blackjackTableObj,GetEntityBoneIndexByName(blackjackTableObj, "Chair_Base_0"..localChairId))
    else
        return vector3(0.0,0.0,0.0)
    end 
end 

function blackjack_func_368(chairId) --returns tableID based on chairID
    local tableId = -1
    for i=0,chairId,4 do
        tableId = tableId + 1
    end
    return tableId
end

function getLocalChairIdFromGlobalChairId(globalChairId) --returns tableID based on chairID
    if globalChairId ~= -1 then 
        return (globalChairId % 4) + 1
    else 
        return 100
    end
end

function getLocalChairIndexFromGlobalChairId(globalChairId) --returns tableID based on chairID
    if globalChairId ~= -1 then 
        return (globalChairId % 4)
    else 
        return 100
    end
end

function getTableHeading(id) --previously blackjack_func_69
    if cfg.blackjackTables[id] ~= nil then 
        return cfg.blackjackTables[id].tableHeading
    else
        return 0.0 --for when tableId = gameId (i.e for dealer)
    end
end

function getTableCoords(id) --previously blackjack_func_70
    if cfg.blackjackTables[id] ~= nil then 
        return cfg.blackjackTables[id].tablePos.x,cfg.blackjackTables[id].tablePos.y,cfg.blackjackTables[id].tablePos.z 
    else
        return 0.0,0.0,0.0 --for when tableId = gameId (i.e for dealer)
    end
end

function getCardFromNumber(iParam0, bParam1)
	if bParam1 then 
        if iParam0 == 1 then
            return "vw_prop_vw_club_char_a_a"
        elseif iParam0 == 2 then
            return "vw_prop_vw_club_char_02a"
        elseif iParam0 == 3 then
            return "vw_prop_vw_club_char_03a"
        elseif iParam0 == 4 then
            return "vw_prop_vw_club_char_04a"
        elseif iParam0 == 5 then
            return "vw_prop_vw_club_char_05a"
        elseif iParam0 == 6 then
            return "vw_prop_vw_club_char_06a"
        elseif iParam0 == 7 then
            return "vw_prop_vw_club_char_07a"
        elseif iParam0 == 8 then
            return "vw_prop_vw_club_char_08a"
        elseif iParam0 == 9 then
            return "vw_prop_vw_club_char_09a"
        elseif iParam0 == 10 then
            return "vw_prop_vw_club_char_10a"
        elseif iParam0 == 11 then
            return "vw_prop_vw_club_char_j_a"
        elseif iParam0 == 12 then
            return "vw_prop_vw_club_char_q_a"
        elseif iParam0 == 13 then
            return "vw_prop_vw_club_char_k_a"
        elseif iParam0 == 14 then
            return "vw_prop_vw_dia_char_a_a"
        elseif iParam0 == 15 then
            return "vw_prop_vw_dia_char_02a"
        elseif iParam0 == 16 then
            return "vw_prop_vw_dia_char_03a"
        elseif iParam0 == 17 then
            return "vw_prop_vw_dia_char_04a"
        elseif iParam0 == 18 then
            return "vw_prop_vw_dia_char_05a"
        elseif iParam0 == 19 then
            return "vw_prop_vw_dia_char_06a"
        elseif iParam0 == 20 then
            return "vw_prop_vw_dia_char_07a"
        elseif iParam0 == 21 then
            return "vw_prop_vw_dia_char_08a"
        elseif iParam0 == 22 then
            return "vw_prop_vw_dia_char_09a"
        elseif iParam0 == 23 then
            return "vw_prop_vw_dia_char_10a"
        elseif iParam0 == 24 then
            return "vw_prop_vw_dia_char_j_a"
        elseif iParam0 == 25 then
            return "vw_prop_vw_dia_char_q_a"
        elseif iParam0 == 26 then
            return "vw_prop_vw_dia_char_k_a"
        elseif iParam0 == 27 then
            return "vw_prop_vw_hrt_char_a_a"
        elseif iParam0 == 28 then
            return "vw_prop_vw_hrt_char_02a"
        elseif iParam0 == 29 then
            return "vw_prop_vw_hrt_char_03a"
        elseif iParam0 == 30 then
            return "vw_prop_vw_hrt_char_04a"
        elseif iParam0 == 31 then
            return "vw_prop_vw_hrt_char_05a"
        elseif iParam0 == 32 then
            return "vw_prop_vw_hrt_char_06a"
        elseif iParam0 == 33 then
            return "vw_prop_vw_hrt_char_07a"
        elseif iParam0 == 34 then
            return "vw_prop_vw_hrt_char_08a"
        elseif iParam0 == 35 then
            return "vw_prop_vw_hrt_char_09a"
        elseif iParam0 == 36 then
            return "vw_prop_vw_hrt_char_10a"
        elseif iParam0 == 37 then
            return "vw_prop_vw_hrt_char_j_a"
        elseif iParam0 == 38 then
            return "vw_prop_vw_hrt_char_q_a"
        elseif iParam0 == 39 then
            return "vw_prop_vw_hrt_char_k_a"
        elseif iParam0 == 40 then
            return "vw_prop_vw_spd_char_a_a"
        elseif iParam0 == 41 then
            return "vw_prop_vw_spd_char_02a"
        elseif iParam0 == 42 then
            return "vw_prop_vw_spd_char_03a"
        elseif iParam0 == 43 then
            return "vw_prop_vw_spd_char_04a"
        elseif iParam0 == 44 then
            return "vw_prop_vw_spd_char_05a"
        elseif iParam0 == 45 then
            return "vw_prop_vw_spd_char_06a"
        elseif iParam0 == 46 then
            return "vw_prop_vw_spd_char_07a"
        elseif iParam0 == 47 then
            return "vw_prop_vw_spd_char_08a"
        elseif iParam0 == 48 then
            return "vw_prop_vw_spd_char_09a"
        elseif iParam0 == 49 then
            return "vw_prop_vw_spd_char_10a"
        elseif iParam0 == 50 then
            return "vw_prop_vw_spd_char_j_a"
        elseif iParam0 == 51 then
            return "vw_prop_vw_spd_char_q_a"
        elseif iParam0 == 52 then
            return "vw_prop_vw_spd_char_k_a"
        end
	else
        if iParam0 == 1 then
            return "vw_prop_cas_card_club_ace"
        elseif iParam0 == 2 then
            return "vw_prop_cas_card_club_02"
        elseif iParam0 == 3 then
            return "vw_prop_cas_card_club_03"
        elseif iParam0 == 4 then
            return "vw_prop_cas_card_club_04"
        elseif iParam0 == 5 then
            return "vw_prop_cas_card_club_05"
        elseif iParam0 == 6 then
            return "vw_prop_cas_card_club_06"
        elseif iParam0 == 7 then
            return "vw_prop_cas_card_club_07"
        elseif iParam0 == 8 then
            return "vw_prop_cas_card_club_08"
        elseif iParam0 == 9 then
            return "vw_prop_cas_card_club_09"
        elseif iParam0 == 10 then
            return "vw_prop_cas_card_club_10"
        elseif iParam0 == 11 then
            return "vw_prop_cas_card_club_jack"
        elseif iParam0 == 12 then
            return "vw_prop_cas_card_club_queen"
        elseif iParam0 == 13 then
            return "vw_prop_cas_card_club_king"
        elseif iParam0 == 14 then
            return "vw_prop_cas_card_dia_ace"
        elseif iParam0 == 15 then
            return "vw_prop_cas_card_dia_02"
        elseif iParam0 == 16 then
            return "vw_prop_cas_card_dia_03"
        elseif iParam0 == 17 then
            return "vw_prop_cas_card_dia_04"        
        elseif iParam0 == 18 then
            return "vw_prop_cas_card_dia_05"
        elseif iParam0 == 19 then
            return "vw_prop_cas_card_dia_06"
        elseif iParam0 == 20  then
            return "vw_prop_cas_card_dia_07"
        elseif iParam0 == 21 then
            return "vw_prop_cas_card_dia_08"
        elseif iParam0 == 22 then
            return "vw_prop_cas_card_dia_09"
        elseif iParam0 == 23 then
            return "vw_prop_cas_card_dia_10"
        elseif iParam0 == 24 then
            return "vw_prop_cas_card_dia_jack"
        elseif iParam0 == 25 then
            return "vw_prop_cas_card_dia_queen"
        elseif iParam0 == 26 then
            return "vw_prop_cas_card_dia_king"
        elseif iParam0 == 27 then
            return "vw_prop_cas_card_hrt_ace"
        elseif iParam0 == 28 then
            return "vw_prop_cas_card_hrt_02"
        elseif iParam0 == 29 then
            return "vw_prop_cas_card_hrt_03"
        elseif iParam0 == 30 then
            return "vw_prop_cas_card_hrt_04"
        elseif iParam0 == 31 then
            return "vw_prop_cas_card_hrt_05"
        elseif iParam0 == 32 then
            return "vw_prop_cas_card_hrt_06"
        elseif iParam0 == 33 then
            return "vw_prop_cas_card_hrt_07"
        elseif iParam0 == 34 then
            return "vw_prop_cas_card_hrt_08"
        elseif iParam0 == 35 then
            return "vw_prop_cas_card_hrt_09"
        elseif iParam0 == 36 then
            return "vw_prop_cas_card_hrt_10"
        elseif iParam0 == 37 then
            return "vw_prop_cas_card_hrt_jack"
        elseif iParam0 == 38 then
            return "vw_prop_cas_card_hrt_queen"
        elseif iParam0 == 39 then
            return "vw_prop_cas_card_hrt_king"
        elseif iParam0 == 40 then
            return "vw_prop_cas_card_spd_ace"
        elseif iParam0 == 41 then
            return "vw_prop_cas_card_spd_02"
        elseif iParam0 == 42 then
            return "vw_prop_cas_card_spd_03"
        elseif iParam0 == 43 then
            return "vw_prop_cas_card_spd_04"
        elseif iParam0 == 44 then
            return "vw_prop_cas_card_spd_05"
        elseif iParam0 == 45 then
            return "vw_prop_cas_card_spd_06"
        elseif iParam0 == 46 then
            return "vw_prop_cas_card_spd_07"
        elseif iParam0 == 47 then
            return "vw_prop_cas_card_spd_08"
        elseif iParam0 == 48 then
            return "vw_prop_cas_card_spd_09"
        elseif iParam0 == 49 then
            return "vw_prop_cas_card_spd_10"
        elseif iParam0 == 50 then
            return "vw_prop_cas_card_spd_jack"
        elseif iParam0 == 51 then
            return "vw_prop_cas_card_spd_queen"
        elseif iParam0 == 52 then
            return "vw_prop_cas_card_spd_king"
        end
    end
	if bParam1 then
		return "vw_prop_vw_jo_char_01a"
    end
	return "vw_prop_casino_cards_single"
end

function getAnimNameFromBet(betAmount)
    --TODO sort this out once bet amounts decided
    -- return "place_bet_small";
    -- return "place_bet_small_alt1";
    -- return "place_bet_small_alt2";
    -- return "place_bet_small_alt3";
    -- return "place_bet_large";
    -- return "place_bet_double_down";
    -- return "place_bet_small_player_02";
    -- return "place_bet_large_player_02";
    -- return "place_bet_double_down_player_02";
    -- return "place_bet_small_split";
    -- return "place_bet_large_split";

    --default for now
    return "place_bet_small"
end 


function blackjack_func_377(iParam0, iParam1, bParam2) --iVar5, iVar9, 0
    ---- print("blackjack_func_377")
    ---- print("iParam0: " .. tostring(iParam0))
    ---- print("iParam1: " .. tostring(iParam1))
    ---- print("bParam2: " .. tostring(bParam2))
    if bParam2 == 0 then 
        ---- print("first check [OK]")
        ---- print("iParam1: " .. tostring(iParam1))
        ---- print("iParam0: " .. tostring(iParam0))
		if iParam1 == 0 then
            if iParam0 == 0 then
                return 0.5737, 0.2376, 0.948025
            elseif iParam0 == 1 then
                return 0.562975, 0.2523, 0.94875
            elseif iParam0 == 2 then
                return 0.553875, 0.266325, 0.94955
            elseif iParam0 == 3 then
                return 0.5459, 0.282075, 0.9501
            elseif iParam0 == 4 then
                return 0.536125, 0.29645, 0.95085
            elseif iParam0 == 5 then
                return 0.524975, 0.30975, 0.9516
            elseif iParam0 == 6 then
                return 0.515775, 0.325325, 0.95235
            end 
		elseif iParam1 == 1 then
            if iParam0 == 0 then
                return 0.2325, -0.1082, 0.94805
            elseif iParam0 == 1 then
                return 0.23645, -0.0918, 0.949
            elseif iParam0 == 2 then
                return 0.2401, -0.074475, 0.950225
            elseif iParam0 == 3 then
                return 0.244625, -0.057675, 0.951125
            elseif iParam0 == 4 then
                return 0.249675, -0.041475, 0.95205
            elseif iParam0 == 5 then
                return 0.257575, -0.0256, 0.9532
            elseif iParam0 == 6 then
                return 0.2601, -0.008175, 0.954375
            end 
        elseif iParam1 == 2 then
            if iParam0 == 0 then
                return -0.2359, -0.1091, 0.9483
            elseif iParam0 == 1 then
                return -0.221025, -0.100675, 0.949
            elseif iParam0 == 2 then
                return -0.20625, -0.092875, 0.949725
            elseif iParam0 == 3 then
                return -0.193225, -0.07985, 0.950325
            elseif iParam0 == 4 then
                return -0.1776, -0.072, 0.951025
            elseif iParam0 == 5 then
                return -0.165, -0.060025, 0.951825
            elseif iParam0 == 6 then
                return -0.14895, -0.05155, 0.95255
            end
		elseif iParam1 == 3 then
            if iParam0 == 0 then
                return -0.5765, 0.2229, 0.9482
            elseif iParam0 == 1 then
                return -0.558925, 0.2197, 0.949175
            elseif iParam0 == 2 then
                return -0.5425, 0.213025, 0.9499
            elseif iParam0 == 3 then
                return -0.525925, 0.21105, 0.95095
            elseif iParam0 == 4 then
                return -0.509475, 0.20535, 0.9519
            elseif iParam0 == 5 then
                return -0.491775, 0.204075, 0.952825
            elseif iParam0 == 6 then
                return -0.4752, 0.197525, 0.9543
            end
        end  
	else
		if iParam1 == 0 then 
            if iParam0 == 0 then
                return 0.6083, 0.3523, 0.94795
            elseif iParam0 == 1 then
                return 0.598475, 0.366475, 0.948925
            elseif iParam0 == 2 then
                return 0.589525, 0.3807, 0.94975
            elseif iParam0 == 3 then
                return 0.58045, 0.39435, 0.950375
            elseif iParam0 == 4 then
                return 0.571975, 0.4092, 0.951075
            elseif iParam0 == 5 then
                return 0.5614, 0.4237, 0.951775
            elseif iParam0 == 6 then
                return 0.554325, 0.4402, 0.952525
            end 
        elseif iParam1 == 1 then 
            if iParam0 == 0 then
				return 0.3431, -0.0527, 0.94855
            elseif iParam0 == 1 then
                return 0.348575, -0.0348, 0.949425
            elseif iParam0 == 2 then
                return 0.35465, -0.018825, 0.9502
            elseif iParam0 == 3 then
                return 0.3581, -0.001625, 0.95115
            elseif iParam0 == 4 then
                return 0.36515, 0.015275, 0.952075
            elseif iParam0 == 5 then
                return 0.368525, 0.032475, 0.95335
            elseif iParam0 == 6 then
                return 0.373275, 0.0506, 0.9543
            end 
        elseif iParam1 == 2 then 
            if iParam0 == 0 then
                return -0.116, -0.1501, 0.947875
            elseif iParam0 == 1 then
                return -0.102725, -0.13795, 0.948525
            elseif iParam0 == 2 then
                return -0.08975, -0.12665, 0.949175
            elseif iParam0 == 3 then
                return -0.075025, -0.1159, 0.949875
            elseif iParam0 == 4 then
                return -0.0614, -0.104775, 0.9507
            elseif iParam0 == 5 then
                return -0.046275, -0.095025, 0.9516
            elseif iParam0 == 6 then
                return -0.031425, -0.0846, 0.952675
            end 
        elseif iParam1 == 3 then 
            if iParam0 == 0 then
                return -0.5205, 0.1122, 0.9478
            elseif iParam0 == 1 then
                return -0.503175, 0.108525, 0.94865
            elseif iParam0 == 2 then
                return -0.485125, 0.10475, 0.949175
            elseif iParam0 == 3 then
                return -0.468275, 0.099175, 0.94995
            elseif iParam0 == 4 then
                return -0.45155, 0.09435, 0.95085
            elseif iParam0 == 5 then
                return -0.434475, 0.089725, 0.95145
            elseif iParam0 == 6 then
                return -0.415875, 0.0846, 0.9523
            end
        elseif iParam1 == 4 then --estimated
            if iParam0 == 0 then
                return -0.293,0.253,0.950025
            elseif iParam0 == 1 then
                return -0.093,0.253,0.950025
            elseif iParam0 == 2 then
                return 0.0293,0.253,0.950025
            elseif iParam0 == 3 then
                return 0.1516,0.253,0.950025
            elseif iParam0 == 4 then
                return 0.2739,0.253,0.950025
            elseif iParam0 == 5 then
                return 0.3962,0.253,0.950025
            elseif iParam0 == 6 then
                return 0.5185,0.253,0.950025
            end             
        end
    end  
	return 0.0, 0.0, 0.947875
end

function func_376(iParam0, iParam1, bParam2, bParam3)
	if not bParam2 then
		if iParam1 == 0 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, 69.12)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, 67.8)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, 66.6)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, 70.44)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, 70.84)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, 67.88)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, 69.56)
            end
        elseif iParam0 == 1 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, 22.11)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, 22.32)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, 20.8)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, 19.8)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, 19.44)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, 26.28)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, 22.68)
            end
        elseif iParam0 == 2 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, -21.43)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, -20.16)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, -16.92)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, -23.4)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, -21.24)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, -23.76)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, -19.44)
            end
        elseif iParam0 == 3 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, -67.03)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, -69.12)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, -64.44)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, -67.68)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, -63.72)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, -68.4)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, -64.44)
            end
        end      
	else
		if iParam1 == 0 then 
            if iParam0 == 0 then
                return vector3(0.0, 0.0, 68.57)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, 67.52)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, 67.76)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, 67.04)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, 68.84)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, 65.96)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, 67.76)
            end
        elseif iParam1 == 1 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, 22.11)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, 22)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, 24.44)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, 21.08)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, 25.96)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, 26.16)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, 28.76)
            end
        elseif iParam1 == 2 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, -14.04)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, -15.48)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, -16.56)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, -15.84)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, -16.92)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, -14.4)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, -14.28)
            end
        elseif iParam1 == 3 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, -67.03)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, -67.6)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, -69.4)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, -69.04)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, -68.68)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, -66.16)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, -63.28)
            end
        end
    end
	if bParam3 then 
        vVar0.z = (vVar0.z + 90.0)
    end
	return vVar0
end

function getChipPropFromAmount(amount)
    --? _x1 is 1 chip _st is stack of 10 chips
    --vw_prop_chip_10dollar_x1 --! £10
    --vw_prop_chip_50dollar_x1 --! £50
    --vw_prop_chip_100dollar_x1 --! £100
    --vw_prop_chip_50dollar_st --!  £50 stack
    --vw_prop_chip_100dollar_st --!  £100 stack
    --vw_prop_chip_500dollar_x1 --! £500 
    --vw_prop_chip_1kdollar_x1 --!  £1,000
    --vw_prop_chip_500dollar_st --! £500 stack
    --vw_prop_chip_5kdollar_x1 --!  £5,000
    --vw_prop_chip_1kdollar_st --!  £1,000 stack
    --vw_prop_chip_10kdollar_x1 --! £10,000 
    --vw_prop_chip_5kdollar_st --! £5,000 stack
    --vw_prop_chip_10kdollar_st --! £10,000 stack
    --vw_prop_plaq_5kdollar_x1 --! £5,000
    --vw_prop_plaq_5kdollar_st --! £5,000 stack
    --vw_prop_plaq_10kdollar_x1 --! £10,0000
    --vw_prop_plaq_10kdollar_st --! £10,0000 stack
    --* below not included in func in decompiled code
    --vw_prop_vw_chips_pile_01a.ydr
    --vw_prop_vw_chips_pile_02a.ydr
    --vw_prop_vw_chips_pile_03a.ydr
    --vw_prop_vw_coin_01a.ydr
    amount = tonumber(amount)
    if amount < 1000000 then 
        denominations = {10,50,100,500,1000,5000,10000}  
        chips = {} 
        local max = 7
        for k,v in ipairs(denominations) do 
            while amount >= denominations[max] do 
                table.insert(chips,denominations[max])
                amount = amount - denominations[max]
            end
            max = max - 1
        end
        for k,v in ipairs(chips) do 
            chips[k] = getChipFromAmount(v) 
        end
        return chips
    elseif amount < 5000000 then  
        return {"vw_prop_vw_chips_pile_01a"}
    elseif amount < 10000000 then  
        return {"vw_prop_vw_chips_pile_02a"}
    else
        return {"vw_prop_vw_chips_pile_03a"}
    end
    return {"vw_prop_chip_500dollar_st"}
end 

local chipsFromAmount = {
    [1] = "vw_prop_vw_coin_01a",
    [10] = "vw_prop_chip_10dollar_x1",
    [50] = "vw_prop_chip_50dollar_x1",
    [100] = "vw_prop_chip_100dollar_x1",
    [500] = "vw_prop_chip_500dollar_x1",
    [1000] = "vw_prop_chip_1kdollar_x1",
    [5000] = "vw_prop_plaq_5kdollar_x1",
    [10000] = "vw_prop_plaq_10kdollar_x1",
}

function getChipFromAmount(amount) 
    return chipsFromAmount[amount]
end 

function blackjack_func_374(betAmount, iParam1, chairId, bParam3) --returns vector3
    fVar0 = 0.0
    vVar1 = vector3(0,0,0)
    if not bParam3 then 
        if betAmount == 10 then 
            fVar0 = 0.95
        elseif betAmount == 20 then
            fVar0 = 0.896
        elseif betAmount == 30 then
            fVar0 = 0.901
        elseif betAmount == 40 then
            fVar0 = 0.907
        elseif betAmount == 50 then
            fVar0 = 0.95
        elseif betAmount == 60 then
            fVar0 = 0.917
        elseif betAmount == 70 then
            fVar0 = 0.922
        elseif betAmount == 80 then
            fVar0 = 0.927
        elseif betAmount == 90 then
            fVar0 = 0.932
        elseif betAmount == 100 then
            fVar0 = 0.95
        elseif betAmount == 150 then
            fVar0 = 0.904
        elseif betAmount == 200 then
            fVar0 = 0.899
        elseif betAmount == 250 then
            fVar0 = 0.914
        elseif betAmount == 300 then
            fVar0 = 0.904
        elseif betAmount == 350 then
            fVar0 = 0.924
        elseif betAmount == 400 then
            fVar0 = 0.91
        elseif betAmount == 450 then
            fVar0 = 0.935
        elseif betAmount == 500 then
            fVar0 = 0.95
        elseif betAmount == 1000 then
            fVar0 = 0.95
        elseif betAmount == 1500 then
            fVar0 = 0.904
        elseif betAmount == 2000 then
            fVar0 = 0.899
        elseif betAmount == 2500 then
            fVar0 = 0.915
        elseif betAmount == 3000 then
            fVar0 = 0.904
        elseif betAmount == 3500 then
            fVar0 = 0.925
        elseif betAmount == 4000 then
            fVar0 = 0.91
        elseif betAmount == 4500 then
            fVar0 = 0.935
        elseif betAmount == 5000 then
            fVar0 = 0.95
        elseif betAmount == 6000 then
            fVar0 = 0.919
        elseif betAmount == 7000 then
            fVar0 = 0.924
        elseif betAmount == 8000 then
            fVar0 = 0.93
        elseif betAmount == 9000 then
            fVar0 = 0.935
        elseif betAmount == 10000 then
            fVar0 = 0.95
        elseif betAmount == 15000 then
            fVar0 = 0.902
        elseif betAmount == 20000 then
            fVar0 = 0.897
        elseif betAmount == 25000 then
            fVar0 = 0.912
        elseif betAmount == 30000 then
            fVar0 = 0.902
        elseif betAmount == 35000 then
            fVar0 = 0.922
        elseif betAmount == 40000 then
            fVar0 = 0.907
        elseif betAmount == 45000 then
            fVar0 = 0.932
        elseif betAmount == 50000 then
            fVar0 = 0.912
        end
		if chairId == 0 then 
			if iParam1 == 0 then 
                vVar1 = vector3(0.712625, 0.170625, 0.0001)
            elseif iParam1 == 1 then
                vVar1 = vector3(0.6658, 0.218375, 0.0)
            elseif iParam1 == 2 then
                vVar1 = vector3(0.756775, 0.292775, 0.0)
            elseif iParam1 == 3 then
                vVar1 = vector3(0.701875, 0.3439, 0.0)
            end 
        elseif chairId == 1 then 
            if iParam1 == 0 then
                vVar1 = vector3(0.278125, -0.2571, 0.0)
            elseif iParam1 == 1 then
                vVar1 = vector3(0.280375, -0.190375, 0.0)
            elseif iParam1 == 2 then
                vVar1 = vector3(0.397775, -0.208525, 0.0)
            elseif iParam1 == 3 then
                vVar1 = vector3(0.39715, -0.1354, 0.0)
            end 
        elseif chairId == 2 then 
            if iParam1 == 0 then
                vVar1 = vector3(-0.30305, -0.2464, 0.0)
            elseif iParam1 == 1 then
                vVar1 = vector3(-0.257975, -0.19715, 0.0)
            elseif iParam1 == 2 then
                vVar1 = vector3(-0.186575, -0.2861, 0.0)
            elseif iParam1 == 3 then
                vVar1 = vector3(-0.141675, -0.237925, 0.0)
            end
        elseif chairId == 3 then 
            if iParam1 == 0 then
                vVar1 = vector3(-0.72855, 0.17345, 0.0)
            elseif iParam1 == 1 then
                vVar1 = vector3(-0.652825, 0.177525, 0.0)
            elseif iParam1 == 2 then
                vVar1 = vector3(-0.6783, 0.0744, 0.0)
            elseif iParam1 == 3 then
                vVar1 = vector3(-0.604425, 0.082575, 0.0)
            end
        end 
    else 
        if betAmount == 10 then
            fVar0 = 0.95
        elseif betAmount == 20 then
            fVar0 = 0.896
        elseif betAmount == 30 then
            fVar0 = 0.901
        elseif betAmount == 40 then
            fVar0 = 0.907
        elseif betAmount == 50 then
            fVar0 = 0.95
        elseif betAmount == 60 then
            fVar0 = 0.917
        elseif betAmount == 70 then
            fVar0 = 0.922
        elseif betAmount == 80 then
            fVar0 = 0.927
        elseif betAmount == 90 then
            fVar0 = 0.932
        elseif betAmount == 100 then
            fVar0 = 0.95
        elseif betAmount == 150 then
            fVar0 = 0.904
        elseif betAmount == 200 then
            fVar0 = 0.899
        elseif betAmount == 250 then
            fVar0 = 0.914
        elseif betAmount == 300 then
            fVar0 = 0.904
        elseif betAmount == 350 then
            fVar0 = 0.924
        elseif betAmount == 400 then
            fVar0 = 0.91
        elseif betAmount == 450 then
            fVar0 = 0.935
        elseif betAmount == 500 then
            fVar0 = 0.95
        elseif betAmount == 1000 then
            fVar0 = 0.95
        elseif betAmount == 1500 then
            fVar0 = 0.904
        elseif betAmount == 2000 then
            fVar0 = 0.899
        elseif betAmount == 2500 then
            fVar0 = 0.915
        elseif betAmount == 3000 then
            fVar0 = 0.904
        elseif betAmount == 3500 then
            fVar0 = 0.925
        elseif betAmount == 4000 then
            fVar0 = 0.91
        elseif betAmount == 4500 then
            fVar0 = 0.935
        elseif betAmount == 5000 then
            fVar0 = 0.953
        elseif betAmount == 6000 then
            fVar0 = 0.919
        elseif betAmount == 7000 then
            fVar0 = 0.924
        elseif betAmount == 8000 then
            fVar0 = 0.93
        elseif betAmount == 9000 then
            fVar0 = 0.935
        elseif betAmount == 10000 then
            fVar0 = 0.95
        elseif betAmount == 15000 then
            fVar0 = 0.902
        elseif betAmount == 20000 then
            fVar0 = 0.897
        elseif betAmount == 25000 then
            fVar0 = 0.912
        elseif betAmount == 30000 then
            fVar0 = 0.902
        elseif betAmount == 35000 then
            fVar0 = 0.922
        elseif betAmount == 40000 then
            fVar0 = 0.907
        elseif betAmount == 45000 then
            fVar0 = 0.932
        elseif betAmount == 50000 then
            fVar0 = 0.912
        end 
        -- case 5000:
        -- case 10000:
        -- case 15000:
        -- case 20000:
        -- case 25000:
        -- case 30000:
        -- case 35000:
        -- case 40000:
        -- case 45000:
        if betAmount ==  50000 then
            if chairId == 0 then
                if iParam1 == 0 then
                    vVar1 = vector3(0.6931, 0.1952, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.724925, 0.26955, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.7374, 0.349625, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.76415, 0.419225, 0.0)
                end
            elseif chairId == 1 then
                if iParam1 == 0 then
                    vVar1 = vector3(0.2827, -0.227825, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.3605, -0.1898, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(0.4309, -0.16365, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(0.49275, -0.111575, 0.0)
                end
            elseif chairId == 2 then    
                if iParam1 == 0 then
                    vVar1 = vector3(-0.279425, -0.2238, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(-0.200775, -0.25855, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(-0.125775, -0.26815, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(-0.05615, -0.29435, 0.0)
                end 
            elseif chairId ==  3 then
                if iParam1 == 0 then
                    vVar1 = vector3(-0.685925, 0.173275, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(-0.6568, 0.092525, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(-0.612875, 0.033025, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(-0.58465, -0.0374, 0.0)
                end 
            end 
        else 
            if chairId == 0 then 
                if iParam1 == 0 then
                    vVar1 = vector3(0.712625, 0.170625, 0.0)       
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.6658, 0.218375, 0.0)      
                elseif iParam1 ==  2 then
                    vVar1 = vector3(0.756775, 0.292775, 0.0)
                elseif iParam1 ==  3 then
                    vVar1 = vector3(0.701875, 0.3439, 0.0)
                end 
            elseif chairId == 1 then 
                if iParam1 == 0 then 
                    vVar1 = vector3(0.278125, -0.2571, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.280375, -0.190375, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(0.397775, -0.208525, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(0.39715, -0.1354, 0.0)
                end
            elseif chairId == 2 then
                if iParam1 == 0 then
                    vVar1 = vector3(-0.30305, -0.2464, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(-0.257975, -0.19715, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(-0.186575, -0.2861, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(-0.141675, -0.237925, 0.0)
                end 
            elseif chairId == 3 then
                if iParam1 == 0 then
                    vVar1 = vector3(-0.72855, 0.17345, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(-0.652825, 0.177525, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(-0.6783, 0.0744, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(-0.604425, 0.082575, 0.0)
                end 
            end 
        end
    end
    vVar1 = vVar1 + vector3(0.0,0.0,fVar0)
    return vVar1
end 

function blackjack_func_373(iParam0, iParam1, iParam2, bParam3)
	if not bParam3 then 
		if iParam2 == 0 then 
            if iParam1 == 0 then
                return vector3(0.0, 0.0, 72)
            elseif iParam1 == 1 then
                return vector3(0.0, 0.0, 64.8)
            elseif iParam1 == 2 then
                return vector3(0.0, 0.0, 74.52)
            elseif iParam1 == 3 then
                return vector3(0.0, 0.0, 72)
            end
        elseif iParam2 == 1 then 
            if iParam1 == 0 then
                return vector3(0.0, 0.0, 12.96)
            elseif iParam1 == 1 then
                return vector3(0.0, 0.0, 29.16)
            elseif iParam1 == 2 then
                return vector3(0.0, 0.0, 32.04)
            elseif iParam1 == 3 then
                return vector3(0.0, 0.0, 32.04)
            end 
		elseif iParam2 == 2 then
            if iParam1 == 0 then
                return vector3(0.0, 0.0, -18.36)
            elseif iParam1 == 1 then
                return vector3(0.0, 0.0, -18.72)
            elseif iParam1 == 2 then
                return vector3(0.0, 0.0, -15.48)
            elseif iParam1 == 3 then
                return vector3(0.0, 0.0, -18)
            end 
        elseif iParam2 == 3 then
            if iParam1 == 0 then
                return vector3(0.0, 0.0, -79.2)
            elseif iParam1 == 1 then
                return vector3(0.0, 0.0, -68.76)
            elseif iParam1 == 2 then
                return vector3(0.0, 0.0, -57.6)
            elseif iParam1 == 3 then
                return vector3(0.0, 0.0, -64.8)
            end
		end 
	else
        if iParam0 == 50000 then 
            if iParam2 == 0 then 
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -16.56)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -22.32)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -10.8)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -9.72)
                end
            elseif iParam2 == 1 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -69.12)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -64.8)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -58.68)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -51.12)
                end
            elseif iParam2 == 2 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -112.32)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -108.36)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -99.72)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -102.6)
                end
            elseif iParam2 == 3 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -155.88)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -151.92)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -147.24)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -146.52)
                end
            end 
        else
            if iParam2 == 0 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, 72)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, 64.8)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, 74.52)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, 72)
                end
            elseif iParam2 == 1 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, 12.96)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, 29.16)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, 32.04)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, 32.04)
                end 
            elseif iParam2 == 2 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -18.36)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -18.72)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -15.48)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -18)
                end 
            elseif iParam2 == 3 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -79.2)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -68.76)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -57.6)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -64.8)
                end
            end
        end  
    end
    return vector3(0.0, 0.0, 0)
end

function getDealerIdFromEntity(dealerEntity)
    local closestID = nil
    local closestDist = 10000
    local dealerCoords = GetEntityCoords(dealerEntity)
    for k,v in pairs(cfg.blackjackTables) do 
        local actualDealerPos = v.dealerPos
        if #(dealerCoords-dealerPos) < closestDist then 
            closestID = k
            closestDist = #(dealerCoords-dealerPos)
        end
    end
    return closestID
end

function setBlackjackDealerPedVoiceGroup(randomNumber,dealerPed)
    if randomNumber == 0 then
        SetPedVoiceGroup(dealerPed,GetHashKey("S_M_Y_Casino_01_WHITE_01"))
	elseif randomNumber == 1 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_M_Y_Casino_01_ASIAN_01"))
    elseif randomNumber == 2 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_M_Y_Casino_01_ASIAN_02"))
    elseif randomNumber == 3 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_M_Y_Casino_01_ASIAN_01"))
    elseif randomNumber == 4 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_M_Y_Casino_01_WHITE_01"))
	elseif randomNumber == 5 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_M_Y_Casino_01_WHITE_02"))
    elseif randomNumber == 6 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_M_Y_Casino_01_WHITE_01"))	
    elseif randomNumber == 7 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_F_Y_Casino_01_ASIAN_01"))	
    elseif randomNumber == 8 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_F_Y_Casino_01_ASIAN_02"))
    elseif randomNumber == 9 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_F_Y_Casino_01_ASIAN_01"))
    elseif randomNumber == 10 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_F_Y_Casino_01_ASIAN_02"))
    elseif randomNumber == 11 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_F_Y_Casino_01_LATINA_01"))
    elseif randomNumber == 12 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_F_Y_Casino_01_LATINA_02"))
    elseif randomNumber == 13 then
		SetPedVoiceGroup(dealerPed,GetHashKey("S_F_Y_Casino_01_LATINA_01"))
    end
end

function setBlackjackDealerClothes(randomNumber,dealerPed)
    if randomNumber == 0 then 
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 1 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 2, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 2 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 3 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 4 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 2, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 5 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 6 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 7 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 8 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 9 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 2, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 10 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 3, 3, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 11 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 1, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
            SetPedPropIndex(dealerPed, 1, 0, 0, false)
    elseif randomNumber == 12 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 3, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 1, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 13 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
        SetPedPropIndex(dealerPed, 1, 0, 0, false)
	end
end

--Use this command to get the coords you need for setting up new tables. 
--Some maps use the prop vw_prop_casino_blckjack_01 some use vw_prop_casino_blckjack_01b, so change accordingly.
RegisterCommand("getcasinotable",function()
  local playerCoords = GetEntityCoords(PlayerPedId())
  local blackjackTable = GetClosestObjectOfType(
    playerCoords.x,playerCoords.y,playerCoords.z,
    2.0,
    GetHashKey("vw_prop_casino_blckjack_01"),0,0,0)
  if DoesEntityExist(blackjackTable) then
      print("Found entity")
      print("tablePos pos",GetEntityCoords(blackjackTable))
      print("tableHeading heading",GetEntityHeading(blackjackTable))
      print("prop: vw_prop_casino_blckjack_01")
  else
      local blackjackTable2 = GetClosestObjectOfType(playerCoords.x,playerCoords.y,playerCoords.z,2.0,GetHashKey("vw_prop_casino_blckjack_01b"),0,0,0)
      if DoesEntityExist(blackjackTable2) then
          print("Found entity")
          print("tablePos pos:",GetEntityCoords(blackjackTable2))
          print("tableHeading heading:",GetEntityHeading(blackjackTable2))
          print("prop: vw_prop_casino_blckjack_01b")
      else
          print("Could not find entity")
      end
  end
end)
