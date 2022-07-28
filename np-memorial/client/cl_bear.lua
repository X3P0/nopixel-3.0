function LoadAnimationDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

local isHuggingBear = false

function HugBear()
    local playerPedId = PlayerPedId()
    if isHuggingBear or exports["isPed"]:isPed("dead") or exports["isPed"]:isPed("intrunk") then
        return
    end
    isHuggingBear = true

    Citizen.CreateThread(function()
        exports["np-taskbar"]:taskBar(4500, "Hugging Bear")
    end)

    local animDic = "mp_ped_interaction"
    local anim = "hugs_guy_b"
    LoadAnimationDic(animDic)
    Citizen.Wait(500)
    TriggerEvent("attachItem", "boe_bear")
    --TaskPlayAnim(playerPedId, animDic, anim, 2.0, 2.0, -1, 49, 0, 0, 0, 0)
    local coords = GetEntityCoords(playerPedId)
    local rot = GetEntityRotation(playerPedId)
    SetFacialIdleAnimOverride(playerPedId, 'mood_happy_1', 0)
    TaskPlayAnimAdvanced(
        playerPedId, animDic, anim, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z,
        2.0, 2.0, -1, 49, 0.25, 0, 0
    )

    Citizen.Wait(750)
    SetEntityAnimSpeed(playerPedId, animDic, anim, 0.1)
    Citizen.Wait(2250)
    SetEntityAnimSpeed(playerPedId, animDic, anim, 1.0)
    Citizen.Wait(750)
    StopAnimTask(playerPedId, animDic, anim, 1.0)
    ClearFacialIdleAnimOverride(playerPedId)

    TriggerEvent("destroyProp")

    isHuggingBear = false
end

AddEventHandler('np-inventory:itemUsed', function(itemId)
    if itemId == 'boebear' then
        HugBear()
    end
end)

