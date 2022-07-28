
------
-- InteractionSound by Scott
-- Version: v0.0.1
-- Path: client/main.lua
--
-- Allows sounds to be played on single clients, all clients, or all clients within
-- a specific range from the entity to which the sound has been created.
------

local standardVolumeOutput = 1.0;

------
-- RegisterNetEvent LIFE_CL:Sound:PlayOnOne
--
-- @param soundFile    - The name of the soundfile within the client/html/sounds/ folder.
--                     - Can also specify a folder/sound file.
-- @param soundVolume  - The volume at which the soundFile should be played. Nil or don't
--                     - provide it for the default of standardVolumeOutput. Should be between
--                     - 0.1 to 1.0.
--
-- Starts playing a sound locally on a single client.
------
RegisterNetEvent('InteractSound_CL:PlayOnOne')
AddEventHandler('InteractSound_CL:PlayOnOne', function(soundFile, soundVolume, pTransactionType)
    SendNUIMessage({
        transactionType     = pTransactionType or 'playSound',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume,
    })
end)

------
-- RegisterNetEvent LIFE_CL:Sound:PlayOnAll
--
-- @param soundFile    - The name of the soundfile within the client/html/sounds/ folder.
--                     - Can also specify a folder/sound file.
-- @param soundVolume  - The volume at which the soundFile should be played. Nil or don't
--                     - provide it for the default of standardVolumeOutput. Should be between
--                     - 0.1 to 1.0.
--
-- Starts playing a sound on all clients who are online in the server.
------
RegisterNetEvent('InteractSound_CL:PlayOnAll')
AddEventHandler('InteractSound_CL:PlayOnAll', function(soundFile, soundVolume, pTransactionType)
    SendNUIMessage({
        transactionType     = pTransactionType or 'playSound',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume
    })
end)

------
-- RegisterNetEvent LIFE_CL:Sound:PlayWithinDistance
--
-- @param playOnEntity    - The entity network id (will be converted from net id to entity on client)
--                        - of the entity for which the max distance is to be drawn from.
-- @param maxDistance     - The maximum float distance (client uses Vdist) to allow the player to
--                        - hear the soundFile being played.
-- @param soundFile       - The name of the soundfile within the client/html/sounds/ folder.
--                        - Can also specify a folder/sound file.
-- @param soundVolume     - The volume at which the soundFile should be played. Nil or don't
--                        - provide it for the default of standardVolumeOutput. Should be between
--                        - 0.1 to 1.0.
--
-- Starts playing a sound on a client if the client is within the specificed maxDistance from the playOnEntity.
-- @TODO Change sound volume based on the distance the player is away from the playOnEntity.
------

RegisterNetEvent('InteractSound_CL:PlayWithinDistance')
AddEventHandler('InteractSound_CL:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume)
    if not DoesPlayerExist(playerNetId) then return end

    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
    if(distIs <= maxDistance) then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = soundVolume
        })
    end
end)


------
--3D Audio
------
local audioPlayers = {}
local shouldUpdate3dAudio = false
local HeadBone = 0x796e

local runAlarm = false
local gameTimer = 0

RegisterNetEvent('InteractSound_CL:GetPlayersAround')
AddEventHandler('InteractSound_CL:GetPlayersAround', function(maxDistance, soundFile, soundVolume)
    local playerList = {}
    local position = GetEntityCoords(PlayerPedId())
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        local dist = #(position - GetEntityCoords(ped))
        if dist <= maxDistance * 2 then
            playerList[#playerList + 1] = GetPlayerServerId(player)
        end
    end
    TriggerServerEvent("InteractSound_SV:PlayAudioToPlayerList", position, maxDistance, soundFile, soundVolume, playerList)
end)



RegisterNetEvent('InteractSound_CL:PlayAudioAtPosition')
AddEventHandler('InteractSound_CL:PlayAudioAtPosition', function(position, maxDistance, soundFile, soundVolume, refDistance, fallOff)
    --adds support for JS events
    position = vector3(position[1], position[2], position[3])
    StartPositionalAudio(position, maxDistance, soundFile, soundVolume, false, refDistance, fallOff)
end)

-- RegisterNetEvent('InteractSound_CL:PlayAudioFromPlayer')
-- AddEventHandler('InteractSound_CL:PlayAudioFromPlayer', function(position, maxDistance, soundFile, soundVolume)
--     StartPositionalAudio(position, maxDistance, soundFile, soundVolume, false, soundVolume * 1.0, (1 - soundVolume) * 0.5 + 1.0)
-- end)

-- RegisterNetEvent('InteractSound_CL:PlayRemoteFile')
-- AddEventHandler('InteractSound_CL:PlayRemoteFile', function(position, maxDistance, soundFile, soundVolume)
--     --adds support for JS events
--     position = vector3(position[1], position[2], position[3])
--     StartPositionalAudio(position, maxDistance, soundFile, soundVolume, true, soundVolume * 1.0, (1 - soundVolume) * 0.5 + 1.0)
-- end)

function StartPositionalAudio(position, maxDistance, soundFile, soundVolume, remote, refDistance, fallOff)
    local lCoords = GetEntityCoords(PlayerPedId())
    shouldUpdate3dAudio = true
    UpdatePosition()
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, position.x, position.y, position.z)
    if(distIs <= maxDistance) then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = soundVolume,
            transactionPosition = {position.x, position.y, position.z},
            transactionMaxDistance = maxDistance,
            transactionRefDistance = refDistance,
            transactionFallOff  = fallOff,
            transactionRemote   = remote
        })
    end
end

function UpdatePosition() 
    local pos = GetPedBoneCoords(PlayerPedId(), HeadBone);
    local heading = GetGameplayCamRot(2)
    local direction = RotationToDirection(heading)
    SendNUIMessage({
        transactionType = 'updatePosition',
        transactionListener = {pos.x, pos.y, pos.z},
        transactionOrientation = {direction.x, direction.y, direction.z}
    })
end

Citizen.CreateThread(function()
    while true do
        --40ms waits seem to be the best for dynamic sound
        Citizen.Wait(40)
        if (#audioPlayers > 0 and shouldUpdate3dAudio) or runAlarm then
            UpdatePosition()
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNUICallback('StopPlaying', function(data, cb)
    if data.is3d ~= nil then
        shouldUpdate3dAudio = false
    end
    for idx,audioId in ipairs(audioPlayers)  do
        if audioId == data.audioId then
            table.remove(audioPlayers, idx)
            break
        end
    end
    cb('ok')
end)

RegisterNUICallback('StartedPlaying', function(data, cb)
    table.insert(audioPlayers, data.audioId)
    --print("started: " .. #audioPlayers)
    --print(json.encode(audioPlayers))
    cb('ok')
end)

RegisterNetEvent('InteractSound_CL:StopPlaying')
AddEventHandler('InteractSound_CL:StopPlaying', function(id)
    SendNUIMessage({
        transactionType = 'stopPlaying',
        transactionId = id
    })
end)

--https://forum.cfx.re/t/get-camera-coordinates/183555/14
function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

RegisterNetEvent("InteractSound_CL:StopLooped")
AddEventHandler("InteractSound_CL:StopLooped", function(soundFile)
  SendNUIMessage({
    transactionType = 'stopLooped',
    transactionFile = soundFile,
  })
end)

RegisterNetEvent('InteractSound_CL:playAlarm')
AddEventHandler('InteractSound_CL:playAlarm', function(position,clearAlarm)
    if clearAlarm then
        runAlarm = false
        return
    end

    if runAlarm then return end
    runAlarm = true

    gameTimer = GetGameTimer()
    local failedAlarm = false
    while runAlarm do
        if (GetGameTimer() - gameTimer) > 10000 then
            StartPositionalAudio(position, 70.0, "Alarm3", 0.3, false, 20.0, 0.1)
        else
            StartPositionalAudio(position, 70.0, "Alarm1", 0.3, false, 20.0, 0.1)
        end

        if (GetGameTimer() - gameTimer) > 25000 then
            failedAlarm = true
            runAlarm = false
        end
        
        local waiting = 2000
        local time = (GetGameTimer() - gameTimer)
        if time > 5000 then waiting = 1500 end
        if time > 8000 then waiting = 1000 end
        if time > 10000 then waiting = 900 end
        if time > 20000 then waiting = 500 end

        Wait(waiting)
    end



    if failedAlarm then
        TriggerEvent("np-housing:alarmFail")
        StartPositionalAudio(position, 70.0, "Alarm2", 0.2, false, 20.0, 0.1)
    end

end)
