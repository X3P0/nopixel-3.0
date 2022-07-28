function LoadGazeModule()
    Citizen.CreateThread(function()
        while true do
            local players = GetActivePlayers()

            local currentPed = Player
            local currentCoords = PlayerCoords

            local closest, delay = {}, 3000

            for _, playerId in ipairs(players) do
                local ped = GetPlayerPed(playerId)

                local isTalking = DecorGetBool(ped, 'IsTalking')

                SetPlayerTalkingOverride(playerId, isTalking)

                if not isTalking then goto continue end

                if (playerId == -1 or ped == currentPed) then goto continue end

                local pedCoords = GetEntityCoords(ped)

                local distance = #(currentCoords - pedCoords)
                local heightDistance = math.abs(pedCoords.z - currentCoords.z)

                if (distance <= 10.0 and heightDistance <= 4.0) and (not closest.ped or closest.distance > distance) then
                    closest.ped = ped
                    closest.distance = distance
                end

                :: continue ::
            end

            TriggerEvent('np-ui:setGaze', closest.ped, delay)

            Citizen.Wait(delay)
        end
    end)

    Debug("[Gaze] Module Loaded")
end