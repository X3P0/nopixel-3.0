DefaultLockBoxModel = GetHashKey('ch_prop_ch_sec_cabinet_01j')
ReplaceLockBoxModel = GetHashKey('ch_prop_ch_sec_cabinet_01h')
local drillBagHash = GetHashKey("hei_p_m_bag_var22_arm_s")
local keypadModel = GetHashKey('prop_ld_keypad_01b')

local boxes = {
    { vector3(1013.31, -0.75, -9.55), -80.72 },
    { vector3(1013.57, -3.40, -9.55), -88.22 },
    { vector3(1012.26, -11.25, -9.55), -110.72 },
    { vector3(1009.75, -15.94, -9.55), -125.72 },
    { vector3(996.47, -24.17, -9.55), -170.72 },
    { vector3(993.82, -24.43, -9.55), -178.22 },
    { vector3(988.52, -23.90, -9.55), 166.78 },
    { vector3(981.27, -20.61, -9.55), 144.28 },
    { vector3(975.82, -14.80, -9.55), 121.06 },
    { vector3(973.64, -9.93, -9.55), 106.78 },
    { vector3(972.79, -4.68, -9.55), 91.78 },
    { vector3(972.85, -2.00, -9.55), 85.26 },
    { vector3(973.32, 0.62, -9.55), 76.78 },
    { vector3(980.26, 11.75, -9.55), 39.28 },
    { vector3(984.78, 14.55, -9.55), 24.28 },
    { vector3(989.88, 16.09, -9.55), 9.28 },
    { vector3(995.2, 16.26, -9.55), -5.72 },
}

local bags = {
    { vector3(990.02, -0.30, -8.61), 151.00 },
    { vector3(1000.06, -4.49, -8.61), 151.00 },
    { vector3(1000.34, -3.48, -8.61), -26.00 },
    { vector3(988.80, -17.54, -8.65), -40.00 },
    { vector3(990.24, 0.78, -8.67), -41.00 },
    { vector3(982.34, 5.18, -8.61), 46.00 },
}

local keypads = {
    vector3(996.66, 8.84, -7.96),
    vector3(998.43, 10.27, -7.96),
    vector3(1003.69, 6.99, -7.96),
    vector3(1003.20, 4.73, -7.96),
}

InHasinoVault = false

RegisterNetEvent('np-hasino:hideModel', function(box, coords, model)
  CreateModelHide(coords.x, coords.y, coords.z, 0.5, model, false)
  if boxes[box] then
    boxes[box][3] = true
    -- print('Hiding box ' .. box, boxes[box][3])
  end
end)

RegisterNetEvent('np-hasino:createBags', function()
    loadModel(drillBagHash)
    for _,bag in ipairs(bags) do
        local obj = CreateObjectNoOffset(drillBagHash, bag[1], true, false, false)
        FreezeEntityPosition(obj, true)
        SetEntityHeading(obj, bag[2])
    end
end)

-- RegisterCommand('createBags', function()
--     TriggerEvent('np-hasino:createBags')
-- end)

local function hasHackLaptop()
    return exports['np-inventory']:hasEnoughOfItem('heistlaptop5', 1, false, true)
    or exports['np-inventory']:hasEnoughOfItem('heistlaptop6', 1, false, true)
    or exports['np-inventory']:hasEnoughOfItem('heistlaptop7', 1, false, true)
    or exports['np-inventory']:hasEnoughOfItem('heistlaptop8', 1, false, true)
end

Citizen.CreateThread(function()
    exports["np-interact"]:AddPeekEntryByModel({ ReplaceLockBoxModel }, {{
        event = "np-hasino:robLockBox",
        id = "np-hasino:robLockBox",
        icon = "hammer",
        label = "Rob!",
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function(pEntity)
            if not InHasinoVault then
                return false
            end
            local coords = GetEntityCoords(pEntity)
            for _, box in ipairs(boxes) do
                if #(box[1] - coords) < 0.5 then
                    return box[3]
                end
            end
          return false
        end,
    })

    exports["np-interact"]:AddPeekEntryByModel({ DefaultLockBoxModel }, {{
        event = "np-hasino:hackLockBox",
        id = "np-hasino:hackLockBox",
        icon = "laptop",
        label = "Access LAN",
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function(pEntity)
            if not InHasinoVault then
                return false
            end
            local coords = GetEntityCoords(pEntity)
            for _, box in ipairs(boxes) do
                if #(box[1] - coords) < 0.5 then
                    return hasHackLaptop() and not box[3]
                end
            end
            return false
        end,
    })

    exports["np-interact"]:AddPeekEntryByModel({ keypadModel }, {{
        event = "np-hasino:enterLVKeypad",
        id = "np-hasino:enterLVKeypad",
        icon = "calculator",
        label = "Enter Input",
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function(pEntity)
          return InHasinoVault
        end,
    })

    exports["np-interact"]:AddPeekEntryByModel({ drillBagHash }, {{
        event = "np-hasino:takeHeistBag",
        id = "np-hasino:takeHeistBag",
        icon = "hand-holding",
        label = "Grab",
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function(pEntity)
          return InHasinoVault and not IsEntityAttachedToAnyPed(pEntity)
        end,
    })

    TriggerServerEvent('np-hasino:requestHideLockboxes')
    -- SetAudioFlag('LoadMPData', true)
    -- RequestScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL', false, -1)
    -- RequestScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2', false, -1)
end)

AddEventHandler('np-hasino:robLockBox', function(pArgs, pEntity, pContext)
    if GetEntityModel(pEntity) ~= ReplaceLockBoxModel or NetworkGetEntityIsNetworked(pEntity) ~= 1 then
        return
    end
    local hasBag = exports['np-inventory']:hasEnoughOfItem('heistduffelbag', 1, false, true)
    if not hasBag then
        TriggerEvent('DoLongHudText', 'Missing duffel bag', 2)
        return
    end
    local plyCoords = GetEntityCoords(PlayerPedId())
    local boxIdFound
    local closestBox = 99
    for boxId,box in ipairs(boxes) do
        local dist = #(box[1] - plyCoords)
        if dist < closestBox then
            closestBox = dist
            boxIdFound = boxId
        end
    end
    if not boxIdFound then
        print('[HASINO] no box found')
        return
    end
    local netId = NetworkGetNetworkIdFromEntity(pEntity)
    TriggerServerEvent('np-hasino:robLockBox', netId, boxIdFound)
end)

AddEventHandler('np-hasino:hackLockBox', function(pArgs, pEntity, pContext)
    if GetEntityModel(pEntity) ~= DefaultLockBoxModel then
        return
    end
    if not hasHackLaptop() then
        return
    end
    local plyCoords = GetEntityCoords(PlayerPedId())
    local boxIdFound
    local closestBox = 99
    for boxId,box in ipairs(boxes) do
        local dist = #(box[1] - plyCoords)
        if dist < closestBox then
            closestBox = dist
            boxIdFound = boxId
        end
    end
    local laptopType = 'fleeca'
    if exports['np-inventory']:hasEnoughOfItem('heistlaptop6', 1, false, true) then
        laptopType = 'thermite'
    elseif exports['np-inventory']:hasEnoughOfItem('heistlaptop7', 1, false, true) then
        laptopType = 'var'
    elseif exports['np-inventory']:hasEnoughOfItem('heistlaptop8', 1, false, true) then
        laptopType = 'maze'
    end
    TriggerServerEvent('np-hasino:requestHack', boxIdFound, laptopType)
end)

AddEventHandler('np-hasino:enterLVKeypad', function(pArgs, pEntity, pContext)
    local coords = GetEntityCoords(pEntity)
    local keypad
    for id,pos in ipairs(keypads) do
        if #(coords - pos) < 0.5 then
            keypad = id
            break
        end
    end
    if not keypad then
        return
    end
    local prompt = exports['np-ui']:OpenInputMenu({
        {
            label = 'Enter Access Code',
            icon = 'user-secret',
            name = 'code',
            preventPaste = false,
        }
    }, function(values)
        return values and values.code and tonumber(values.code)
    end)
    if not prompt then return end

    TriggerServerEvent('np-hasino:lvKeypadInput', keypad, prompt.code)
end)

RegisterNetEvent('np-hasino:keypadSounds', function()
    PlaySoundFrontend(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', true)
    Wait(1000)
    PlaySoundFrontend(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', true)
    Wait(1000)
    PlaySoundFrontend(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', true)
    Wait(1000)
    PlaySoundFrontend(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', true)
    Wait(1000)
    PlaySoundFrontend(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', true)
end)

RegisterNetEvent('np-hasino:keypadSound', function()
    PlaySoundFrontend(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', true)
end)

RegisterNetEvent('np-hasino:keypadFailure', function()
    PlaySoundFrontend(-1, 'Hack_Failed', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', true)
end)

RegisterNetEvent('np-hasino:keypadSuccess', function()
    PlaySoundFrontend(-1, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', true)
end)

AddEventHandler('np-hasino:accessLowerComputer', function()
    if not IsLVComputerLoggedIn then
        TriggerEvent('DoLongHudText', 'Not Authorized', 2)
        return
    end
    local hasKeyCard = exports['np-inventory']:hasEnoughOfItem('casinoexeckeycard', 1, false, true)
    -- if not hasKeyCard then
    --     TriggerEvent('DoLongHudText', 'Missing keycard', 2)
    --     return
    -- end
    local prompt,a,b,c = RPC.execute('np-hasino:getCurrentLockboxPrompt', hasKeyCard)
    if not prompt then
        return
    end
    exports['np-ui']:openApplication('hasino-lower-pc', {
        prompts = prompt,
        a = a,
        b = b,
        c = c,
    })
end)

AddEventHandler('np-hasino:takeHeistBag', function(pArgs, pEntity, pContext)
    if DoesEntityExist(pEntity) and pContext.model == drillBagHash then
        TriggerServerEvent('np-hasino:takeHeistBag', NetworkGetNetworkIdFromEntity(pEntity))
    end
end)

RegisterNetEvent('np-hasino:drillBox', function(coords, totalRewards, pantherGiven, giveLaptops)
    local ped = PlayerPedId()
    local cabinet = GetHashKey('ch_prop_ch_sec_cabinet_01h')
    local lockbox = GetClosestObjectOfType(coords, 1.0, cabinet, false, false, false)

    if not DoesEntityExist(lockbox) then
        return
    end

    local bagItem = exports["np-inventory"]:getItemsOfType("heistduffelbag", 1, true)
    if not bagItem or not bagItem[1] then
        TriggerEvent('DoLongHudText', 'No bag found.', 2)
        return
    end
    local bagInvId = json.decode(bagItem[1].information).inventoryId

    drilling = true
    local pantherHash = GetHashKey("h4_prop_h4_art_pant_01a")
    local moneyBagHash = giveLaptops and GetHashKey("p_cs_laptop_02_w") or GetHashKey("ch_prop_ch_moneybag_01a")
    local drillHash = GetHashKey("ch_prop_vault_drill_01a")
    RequestModel(drillBagHash)
    RequestModel(drillHash)
    RequestModel(moneyBagHash)
    RequestModel(pantherHash)
    RequestScriptAudioBank('DLC_HEIST3\\CASINO_HEIST_FINALE_GENERAL_01', 1)
    while not HasModelLoaded(drillHash) and not HasModelLoaded(drillBagHash) and not HasModelLoaded(moneyBagHash) and not HasModelLoaded(pantherHash) do
        Citizen.Wait(0)
    end

    local lockboxCoords = GetEntityCoords(lockbox)
    local lockboxRotation = GetEntityRotation(lockbox, 2)

    local deleteBag = false
    local drillBag = exports['np-inventory']:GetAttachedBag()
    if drillBag == 0 then
        deleteBag = true
        drillBag = CreateObject(drillBagHash, GetEntityCoords(PlayerPedId()), true, false, false)
    end
    local drill = CreateObject(drillHash, GetEntityCoords(PlayerPedId()), true, false, false)
    local moneyBag = CreateObject(moneyBagHash, lockboxCoords + vector3(0, 0, -0.5), true, false, false)
    local panther
    if pantherGiven then
        panther = CreateObject(pantherHash, lockboxCoords + vector3(0, 0, -0.5), true, false, false)
        SetEntityCollision(panther, false, false)
        SetEntityVisible(panther, false, false)
    end
    SetEntityCollision(drillBag, false, false)
    SetEntityCollision(drill, false, false)
    SetEntityCollision(moneyBag, false, false)
    SetEntityVisible(moneyBag, false, false)

    Citizen.CreateThread(function()
        while drilling do
            DisableCamCollisionForEntity(drill)
            DisableCamCollisionForEntity(drillBag)
            Wait(0)
        end
    end)

    local function playSyncScene(dict, type, loop, rewardObject)
        local netScene = NetworkCreateSynchronisedScene(lockboxCoords, lockboxRotation, 2, true, false, 1.0, -1, 1.0)
        NetworkAddPedToSynchronisedScene(ped, netScene, dict, type, 1.5, -4.0, 1, 16, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(lockbox, netScene, dict, type .. "_ch_Prop_CH_Sec_Cabinet_01GHI", 4.0, -0.005, 1)
        NetworkAddEntityToSynchronisedScene(drill, netScene, dict, type .. "_ch_Prop_Vault_Drill_01a", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(drillBag, netScene, dict, type .. "_P_M_bag_var22_Arm_S", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(rewardObject and rewardObject or moneyBag, netScene, dict, type .. "_ch_Prop_CH_Moneybag_01a", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(netScene)
    end

    local function getAnimDict(step)
        return "ANIM_HEIST@HS3F@IG10_LOCKBOX_DRILL@PATTERN_0" .. "3" .. "@LOCKBOX_0" .. tostring(step) .. "@MALE@"
    end

    loadAnimDict("ANIM_HEIST@HS3F@IG10_LOCKBOX_DRILL@PATTERN_03@LOCKBOX_01@MALE@")
    loadAnimDict("ANIM_HEIST@HS3F@IG10_LOCKBOX_DRILL@PATTERN_03@LOCKBOX_02@MALE@")
    loadAnimDict("ANIM_HEIST@HS3F@IG10_LOCKBOX_DRILL@PATTERN_03@LOCKBOX_03@MALE@")
    loadAnimDict("ANIM_HEIST@HS3F@IG10_LOCKBOX_DRILL@PATTERN_03@LOCKBOX_04@MALE@")

    local syncScenes = {}
    local animDict1 = getAnimDict(1)
    syncScenes[#syncScenes+1] = playSyncScene(animDict1, "ENTER", false)

    Wait(3000)
    local gotPanther = false
    local rewardsGiven = 0
    local function getReward(step)
        local reward = {
            "NO_REWARD",
            "REWARD",
        }
        local rng = math.random(1, 2)
        if rewardsGiven < totalRewards then
            if math.random(1, step) > 2 then
                rng = 2
            end
        end
        if giveLaptops then
            rng = 2
        end
        Citizen.SetTimeout(1000, function()
            SetEntityVisible(moneyBag, rng == 2, false)
        end)
        Citizen.SetTimeout(3500, function()
            SetEntityVisible(moneyBag, false, false)
        end)
        return reward[rng]
    end

    local function playAudio()
        local soundId = GetSoundId()
        PlaySoundFromCoord(soundId, "drill", lockboxCoords, "dlc_ch_heist_finale_lockbox_drill_sounds", true, 0, false)
        return soundId
    end

    local audio1 = playAudio()
    syncScenes[#syncScenes+1] = playSyncScene(animDict1, 'IDLE', true)
    Wait(3000)
    if pantherGiven and not gotPanther then
        syncScenes[#syncScenes+1] = playSyncScene(animDict1, 'REWARD', true, panther)
        Wait(300)
        SetEntityVisible(panther, true, false)
        Citizen.SetTimeout(2500, function()
            SetEntityVisible(panther, false, false)
        end)
    else
        syncScenes[#syncScenes+1] = playSyncScene(animDict1, getReward(1), true)
    end
    Wait(500)
    StopSound(audio1)
    Wait(4500)
    local animDict2 = getAnimDict(2)
    local audio2 = playAudio()
    syncScenes[#syncScenes+1] = playSyncScene(animDict2, 'IDLE', true)
    Wait(3000)
    syncScenes[#syncScenes+1] = playSyncScene(animDict2, getReward(2), true)
    Wait(500)
    StopSound(audio2)
    Wait(4500)
    local animDict3 = getAnimDict(3)
    local audio3 = playAudio()
    Wait(3000)
    syncScenes[#syncScenes+1] = playSyncScene(animDict3, getReward(3), true)
    Wait(500)
    StopSound(audio3)
    Wait(4500)
    local animDict4 = getAnimDict(4)
    local audio4 = playAudio()
    syncScenes[#syncScenes+1] = playSyncScene(animDict4, 'IDLE', true)
    Wait(3000)
    syncScenes[#syncScenes+1] = playSyncScene(animDict4, getReward(4), true)
    Wait(500)
    StopSound(audio4)
    drilling = false
    Citizen.Wait(5000)
    for _,scene in ipairs(syncScenes) do
        NetworkStopSynchronisedScene(scene)
    end
    ReleaseSoundId(audio1)
    ReleaseSoundId(audio2)
    ReleaseSoundId(audio3)
    ReleaseSoundId(audio4)
    PlayEntityAnim(lockbox, 'IDLE_ch_Prop_CH_Sec_Cabinet_01GHI', animDict4, 0.0, true, true, false, 0.99, 0)
    TriggerServerEvent('np-hasino:robbedLockBox', NetworkGetNetworkIdFromEntity(lockbox), totalRewards, bagInvId)
    Sync.DeleteEntity(drill)
    Sync.DeleteEntity(moneyBag)
    if panther and DoesEntityExist(panther) then
        Sync.DeleteEntity(panther)
    end
    if deleteBag then
        Sync.DeleteEntity(drillBag)
    else
        TriggerEvent("AttachWeapons")
    end
    SetModelAsNoLongerNeeded(drillHash)
    SetModelAsNoLongerNeeded(drillBagHash)
    SetModelAsNoLongerNeeded(moneyBagHash)
end)

function enterHasinoVault()
    InHasinoVault = true
    RequestScriptAudioBank('DLC_HEIST3\\CASINO_HEIST_FINALE_GENERAL_01', 1)
    RequestScriptAudioBank('Vault_Door', 1)
    for _,box in ipairs(boxes) do
        local entity = GetClosestObjectOfType(box[1], 0.5, ReplaceLockBoxModel, false, false, false)
        if entity and DoesEntityExist(entity) then
            SetEntityCoords(entity, box[1])
            SetEntityHeading(entity, box[2])
        end
    end
end

RegisterNetEvent('np-hasino:beginLowerVault', function()
    enterHasinoVault()
end)

AddEventHandler("np-polyzone:enter", function(pZone, pData)
    if pZone ~= "hasino_lower_vault" then return end
    enterHasinoVault()
end)

AddEventHandler("np-polyzone:exit", function(pZone, pData)
    if pZone ~= "hasino_lower_vault" then return end
    InHasinoVault = false
    ReleaseNamedScriptAudioBank('DLC_HEIST3\\CASINO_HEIST_FINALE_GENERAL_01')
end)
