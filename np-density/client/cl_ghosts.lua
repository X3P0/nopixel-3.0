
local Checking, Ack, Ghosted, Zone, IsSpeeding = {}, {}, {}, nil, false

AddEventHandler('np-config:configLoaded', function (pId)
    if (pId ~= 'np-density') then return end

    if Zone == nil then return end

    local playerVehicle = Zone.entity

    Citizen.Wait(1000)

    Zone:destroy()

    Zone = EntityZone:Create(playerVehicle, { scale = { Config.antiGhostScaleX, Config.antiGhostScaleY, 5.0 }, debugPoly = Config.antiGhostDebug })
end)

AddEventHandler('baseevents:vehicleSpeeding', function (isSpeeding)
    IsSpeeding = isSpeeding

    if not isSpeeding then return end

    Ghosted = {}

    Citizen.CreateThread(function ()
        while IsSpeeding and Zone do
            for vehicle, enabled in pairs(Checking) do

                if not enabled then goto continue end

                local coord = GetEntityCoords(vehicle)

                local inside = Zone:isPointInside(coord)

                if inside and not Ghosted[vehicle] then
                    local driver = GetPedInVehicleSeat(vehicle, -1)
                    local isPlayer = driver ~= 0 and IsPedAPlayer(driver)
                    if not isPlayer then
                        NetworkConcealEntity(vehicle, true)
                        Ghosted[vehicle] = true
                        if Config.antiGhostYeetVehicles then
                            TriggerEvent('np-density:yeet', vehicle)
                        end
                    end
                elseif not inside and Ghosted[vehicle] then
                    NetworkConcealEntity(vehicle, false)
                    Ghosted[vehicle] = false
                end

                ::continue::
            end

            Citizen.Wait(IsSpeeding and 0 or 50)
        end

        for vehicle, _ in pairs(Ghosted) do
            NetworkConcealEntity(vehicle, false)
        end
    end)
end)

AddEventHandler('baseevents:enteredVehicle', function (playerVehicle)
    Zone = EntityZone:Create(playerVehicle, { scale = { Config.antiGhostScaleX, Config.antiGhostScaleY, 5.0 }, debugPoly = Config.antiGhostDebug })

    Ack, Checking, Ghosted = {}, {}, {}

    Citizen.CreateThread(function ()
        local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        while Zone do
            local vehicles = GetGamePool('CVehicle')

            for _, vehicle in ipairs(vehicles) do
                if vehicle ~= playerVehicle and not Ack[vehicle] and not Checking[vehicle] then
                    local driver = GetPedInVehicleSeat(vehicle, -1)

                    local isPlayer = driver ~= 0 and IsPedAPlayer(driver)

                    if not isPlayer then
                        Checking[vehicle] = true
                    end
                end
            end

            Citizen.Wait(IsSpeeding and 0 or 50)
        end
    end)

    Citizen.CreateThread(function ()
        local prevCoords = {}

        while Zone do
            local idle = 500

            for vehicle, v in pairs(Checking) do
                Ack[vehicle] = (Ack[vehicle] or 0) + 1

                if Ack[vehicle] > 5 then
                    Checking[vehicle] = nil
                end
            end

            for vehicle, checks in pairs(Ack) do
                if not DoesEntityExist(vehicle) then
                    Ack[vehicle] = nil

                    Ghosted[vehicle] = nil

                    Checking[vehicle] = nil

                    goto continue
                end

                if checks > 5 then
                    local coords = GetEntityCoords(vehicle)

                    if not prevCoords[vehicle] then prevCoords[vehicle] = coords end

                    local change = #(prevCoords[vehicle] - coords)

                    if change > 100.0 then
                        Ack[vehicle] = 0
                        Checking[vehicle] = true
                    end

                    if Ghosted[vehicle] and not Checking[vehicle] and not Zone:isPointInside(coords) then
                        NetworkConcealEntity(vehicle, false)
                        Ghosted[vehicle] = false
                    end

                    prevCoords[vehicle] = coords
                end

                ::continue::
            end

            Citizen.Wait(idle)
        end
    end)
end)

AddEventHandler('baseevents:leftVehicle', function ()
    if Zone == nil then return end

    Zone:destroy()

    Zone = nil
end)

AddEventHandler('np-density:yeet', function (vehicle)
    local vin = exports['np-vehicles']:GetVehicleIdentifier(vehicle)

    if vin then return end

    exports['np-sync']:SyncedExecution('DeleteEntity', vehicle)
end)

--[[
    BUBBLE POPPER 3000
    While in a race, check for all player-controlled vehicles within 35 units
    If other vehicle is a RACER then ENABLE ghost for ourselves
    If ANY other player vehicle is close (NON RACER) then we have to DISABLE ghost
    If the RACER vehicle is CLOSE (ie. touching distance) then we need to DISABLE ghost
    Every RACER client will run this, allowing for bubbles to not actually affect anything
--]]

local isRacing = false
SetLocalPlayerAsGhost(false)
-- Set our alpha to others as 254 (near ghost)
SetGhostedEntityAlpha(254)

-- local nosActive = true
-- AddEventHandler('vehicles:nitro:started', function()
--     nosActive = true
-- end)

-- AddEventHandler('vehicles:nitro:stopped', function()
--     nosActive = false
-- end)

local PlayersInScope = {}

RegisterNetEvent('onPlayerJoining')
AddEventHandler('onPlayerJoining', function(serverId)
    local playerId = GetPlayerFromServerId(serverId)
    if (playerId == PlayerId()) then return end

    PlayersInScope[serverId] = playerId
end)

RegisterNetEvent('onPlayerDropped')
AddEventHandler('onPlayerDropped', function(serverId)
    if (not PlayersInScope[serverId]) then return end

    PlayersInScope[serverId] = nil
end)

function startBubblePopper(pRace)
    if not pRace.bubblePopper and pRace.phasing == 'none' then return end

    local fullPhase = pRace.phasing == 'full'

    -- print('Starting Race', json.encode(pRace))

    isRacing = true

    local closePlayers = {}
    local playerIds = {}
    local playerPed = PlayerPedId()

    local myServerId = GetPlayerServerId(PlayerId())
    local myVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    for _, player in pairs(pRace.players) do
        if myServerId ~= player.id then
            playerIds[player.id] = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(player.id)), false)
        end
    end

    for i, playerId in ipairs(GetActivePlayers()) do
        local serverId = GetPlayerServerId(playerId)
        if serverId and not PlayersInScope[serverId] then PlayersInScope[serverId] = playerId end
    end

    -- print('Starting vehicle tracking...')

    local ghosted = false
    local forceOff = false

    if pRace.phasing ~= 'none' and pRace.phasing ~= 'full' then
        local phasingSeconds = tonumber(pRace.phasing)
        if phasingSeconds ~= nil then
            fullPhase = true
            TriggerEvent('DoLongHudText', 'Phase Active (' .. pRace.phasing .. 's)')
            SetTimeout((phasingSeconds - 5) * 1000, function()
                TriggerEvent('DoLongHudText', 'Phase disabling in 5 seconds', 2)
            end)
            SetTimeout(phasingSeconds * 1000, function()
                fullPhase = pRace.phasing == 'full' or false
                SetLocalPlayerAsGhost(false)
                ghosted = false
                TriggerEvent('DoLongHudText', 'Phase disabled', 2)
            end)
        end
    end

    -- Update playerPed, playerIds, and closePlayers
    Citizen.CreateThread(function()
        while isRacing do
            playerPed = PlayerPedId()
            local myCoords = GetEntityCoords(playerPed)

            myVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            for playerId, _ in pairs(playerIds) do
                playerIds[playerId] = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
            end

            for serverId, playerId in pairs(PlayersInScope) do
                -- Only check player if they are not in the race.
                if not playerIds[serverId] then
                    local ped = GetPlayerPed(playerId)
                    local dist = #(myCoords - GetEntityCoords(ped))
                    local closeVehicle = dist < 100.0 and GetVehiclePedIsIn(ped, false) or 0
                    -- If `ped` is in a vehicle, it's close enough, and it's not a vehicle of a player in the race
                    if closeVehicle ~= 0 and closeVehicle ~= myVehicle and not tableContains(playerIds, closeVehicle) then
                        closePlayers[serverId] = ped
                    else
                        closePlayers[serverId] = nil
                    end
                end
            end

            Wait(250)
        end
    end)

    -- Tracks close players
    Citizen.CreateThread(function()
        while isRacing do
            forceOff = false
            local myCoords = GetEntityCoords(playerPed)

            for serverId, ped in pairs(closePlayers) do
                local dist = #(myCoords - GetEntityCoords(ped))
                if dist < 30.0 and ped ~= playerPed and not playerIds[serverId] then
                    forceOff = true -- Some other vehicle is too close, disable ghost mode
                end
            end

            Wait(0)
        end
    end)

    Citizen.CreateThread(function()
        while isRacing do
            Wait(0) -- Update time, this will determine how fast we should disable when ramming someone, should be LOW

            local inRange = false
            local toClose = false
            local myCoords = GetEntityCoords(playerPed)
            local myVehicle = GetVehiclePedIsIn(playerPed, false)
            if myVehicle ~= 0 then
                if fullPhase then
                    if (not ghosted) and (not forceOff) then
                        -- print('Phase Active, ghosting', ghosted, forceOff)
                        SetLocalPlayerAsGhost(true)
                        ghosted = true
                    end
                end

                if pRace.bubblePopper then
                    local myVelocity = GetEntityVelocity(myVehicle)
                    for _, vehicle in pairs(playerIds) do
                        local innerBubbleThreshold = 10.0
                        local dist = #(myCoords - GetEntityCoords(vehicle))
                        if dist < 25.0 then
                            inRange = true -- At least one vehicle close enough, enable ghost mode
                            local relativeVelocity = #(GetEntityVelocity(vehicle) - myVelocity)
                            innerBubbleThreshold = math.max(6.5, math.min(10.0, relativeVelocity + 2.5))
                        end
                        if dist < innerBubbleThreshold then
                            toClose = true -- At least one vehicle inside of us, disable ghost mode
                        end
                    end

                    if inRange and not toClose and not ghosted then
                        SetLocalPlayerAsGhost(true)
                        ghosted = true
                        -- print('In range, ghosting')
                    end

                    if (toClose or forceOff) and ghosted and (not fullPhase) then
                        SetLocalPlayerAsGhost(false)
                        ghosted = false
                        -- print('To close, disabling')
                    end

                    if not inRange and not toClose and ghosted and (not fullPhase) then
                        SetLocalPlayerAsGhost(false)
                        ghosted = false
                        -- print('Nobody in range and not to close, disabling')
                    end
                end

                if ghosted and forceOff then
                    -- print('Forced off, unghosting', ghosted, forceOff)
                    SetLocalPlayerAsGhost(false)
                    ghosted = false
                end
            elseif ghosted then
                -- print('out of vehicle, disabling')
                SetLocalPlayerAsGhost(false)
                ghosted = false
            end
        end
        SetLocalPlayerAsGhost(false)
        ghosted = false
    end)
end

AddEventHandler("mkr_racing:api:currentRace", function(currentRace)
    isRacing = currentRace ~= nil
    if isRacing then
        startBubblePopper(currentRace)
    end
end)
