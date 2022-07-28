local horseModel = "a_c_horse"
local horseHash = GetHashKey(horseModel)
local currentPed = nil

function goHorseMode()
    RequestModel(horseModel)
    while not HasModelLoaded(horseModel) do
        Wait(0)
    end
    SetPlayerModel(PlayerId(), horseHash)
end

function goNormalMode()
    TriggerEvent('np-clothing:applyCurrentClothing')
end

function cloneMyPed()
    local ped = ClonePed(PlayerPedId(), 1)
    while not DoesEntityExist(ped) do
        Wait(0)
    end
    return ped
end

local inHorseMode = false
local ped = nil
-- RegisterCommand("gohorse", function()

    
--     -- AttachEntityBoneToEntityBone(ped, PlayerPedId(), 11816, 0, 0, 0)
--     -- 11816
-- end, false)
-- RegisterCommand("endhorse", function()
-- end, false)

-- RegisterCommand("horse", function()
--     goHorseMode()
-- end, false)
-- RegisterCommand("normal", function()
--     goNormalMode()
-- end, false)
-- RegisterCommand("clone", function()
--     cloneMyPed()
-- end, false)

RegisterNetEvent("np-admin:horse", function(pOn)
    if not pOn then
        inHorseMode = false
        DetachEntity(ped, 0, 0)
        DeleteEntity(ped)
        goNormalMode()
        return
    end
    ped = cloneMyPed()
    goHorseMode()
    Wait(200)
    -- local boneIdx = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine0")
    -- print(boneIdx)
    AttachEntityToEntity(ped, PlayerPedId(), 0, 0.4, 0.0, 0.3, 90.0, 180.0, 90.0, 0, 1, 0, 1, 0, 1)
    -- AttachEntityBoneToEntityBone(ped, PlayerPedId(), 11816, 0, 0, 0)
    inHorseMode = true
    Citizen.CreateThread(function()
        local dict = "amb@code_human_on_bike_idles@quad@front@idle_a"
        local anim = "idle_d"
        while not HasAnimDictLoaded(dict) do
            RequestAnimDict(dict)
            Citizen.Wait(0)
        end
        
        while inHorseMode do
            if not IsEntityPlayingAnim(ped, dict, anim, 3) then
                TaskPlayAnim(ped, dict, anim, 1.0, 0.0, 4000, 0, 0.1, false, false, false)
            end
            Wait(500)
        end
    end)
    Citizen.CreateThread(function()
        while inHorseMode do
            SetGameplayCamFollowPedThisUpdate(ped)
            Wait(0)
        end
    end)
end)

RegisterCommand("np-admin:horseon", function()
    TriggerServerEvent("np-admin:shorseon")
end, false)
RegisterCommand("np-admin:horseoff", function()
    TriggerServerEvent("np-admin:shorseoff")
end, false)

    -- Citizen.CreateThread(function()
    --     local i = 0
    --     while inHorseMode do
    --         DetachEntity(ped, 0, 0)
    --         Wait(0)
    --         i = i + 1
    --         AttachEntityToEntity(ped, PlayerPedId(), 0, 0.0, -0.2, 0.35, 90.0, 0.0, 90.0, 0, 1, 0, 1, 0, 1)
    --         Wait(100)
    --         print(i)
    --     end
    -- end)