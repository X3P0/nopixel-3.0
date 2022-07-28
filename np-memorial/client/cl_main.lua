Citizen.CreateThread(function()
    while true do
        local idle = 500

        PlayerPed = PlayerPedId()
        PlayerCoords = GetEntityCoords(PlayerPed)

        Citizen.Wait(idle)
    end
end)

function PlayHugAnimation(ped)
    local animDict = "mp_ped_interaction"
    local animation = "kisses_guy_a"

    LoadAnimDict(animDict)

    local animLength = GetAnimDuration(animDict, animation)

    TaskPlayAnim(ped, animDict, animation, 1.0, 4.0, animLength, 0, 0, 0, 0, 0)

    Citizen.Wait(100)

    while IsEntityPlayingAnim(ped, animDict, animation, 3) do
        Citizen.Wait(0)
    end
end

function PrepareHug(data)
    local playerPed = PlayerPedId()

    TaskPedSlideToCoordHdgRate(playerPed, data.coords, data.heading)

    Citizen.Wait(100)

    while GetScriptTaskStatus(PlayerPed, 0x3e5094a7) == 1 do
        Citizen.Wait(50)
    end

    SetEntityHeading(playerPed, data.heading)
end