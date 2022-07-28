CurrentVehicle, CurrentSeat, IsDriving, IsEmergencyVehicle = nil, nil, false, false

VerifiedVehicles = {}

AddEventHandler('baseevents:enteredVehicle', function(pVehicle, pSeat, pName, pClass)
    CurrentSeat = pSeat
    CurrentVehicle = pVehicle
    CurrentNetworkId = NetworkGetNetworkIdFromEntity(pVehicle)

    IsDriving = pSeat == -1
    IsEmergencyVehicle = pClass == 18

    if not IsDriving then return end

    PrepVehicle(CurrentVehicle, IsEmergencyVehicle)

    if not IsEmergencyVehicle then return end

    StartEmergencyDriverThread()
end)

AddEventHandler('baseevents:leftVehicle', function(pVehicle, pSeat, pName, pClass)
    CurrentSeat = nil
    CurrentVehicle = nil
    CurrentNetworkId = nil

    IsDriving = false
    IsEmergencyVehicle = false
end)

AddEventHandler('baseevents:vehicleChangedSeat', function(pVehicle, pCurrentSeat, pPreviousSeat)
    CurrentSeat = pCurrentSeat
    CurrentVehicle = pVehicle
    CurrentNetworkId = NetworkGetNetworkIdFromEntity(pVehicle)

    IsDriving = pCurrentSeat == -1

    if not IsDriving then return end

    PrepVehicle(CurrentVehicle, IsEmergencyVehicle)

    if not IsEmergencyVehicle then return end

    StartEmergencyDriverThread()
end)

AddEventHandler('baseevents:vehicleHotreload', function(pVehicle, pSeat, pEngineOn)
    CurrentSeat = pSeat
    CurrentVehicle = pVehicle
    CurrentNetworkId = NetworkGetNetworkIdFromEntity(pVehicle)

    IsDriving = pSeat == -1
    IsEmergencyVehicle = GetVehicleClass(pVehicle) == 18

    if not IsDriving then return end

    PrepVehicle(CurrentVehicle, IsEmergencyVehicle)

    if not IsEmergencyVehicle then return end

    StartEmergencyDriverThread()
end)

RegisterNetEvent('onPlayerJoining')
AddEventHandler('onPlayerJoining', function (player)
    Citizen.Wait(1000)

    local playerId = GetPlayerFromServerId(player)
    local playerPed = GetPlayerPed(playerId)

    if not IsPedInAnyVehicle(playerPed) then return end

    local vehicle = GetVehiclePedIsIn(playerPed)

    if not vehicle then return end

    VerifyVehicle(vehicle)
end)

function PrepVehicle(pVehicle, pEmergency)
    if EmergencyVehicles[vehicle] or SyncVehicles[vehicle] then return end

    for property, _ in pairs(Flags) do
        if not DecorExistOn(pVehicle, property) then
            DecorSetInt(pVehicle, property, 0)
        end
    end

    if not pEmergency or HasSirenPreset(pVehicle) then return end

    local model = GetEntityModel(pVehicle)
    local presetNumber = GetModelSirenPreset(model)

    if not presetNumber then return end

    SetVehicleSirenPreset(pVehicle, presetNumber)
end

function VerifyVehicle(pVehicle)
    local hasSirenPreset = HasSirenPreset(pVehicle)
    local hasSyncState = HasSyncState(pVehicle)

    if hasSirenPreset then
        UpdateSirenState(pVehicle)
    end

    if hasSyncState then
        UpdateSyncState(pVehicle)
    end
end

function VehicleCleanUp(pVehicle)
    CleanUpEntitySounds(pVehicle)

    SyncVehicles[pVehicle] = nil
    VerifiedVehicles[pVehicle] = nil
    EmergencyVehicles[pVehicle] = nil
end

Citizen.CreateThread(function()
    DecorRegister(PresetProperty, 3)

    for flag, _ in pairs(Flags) do
        DecorRegister(flag, 3)
    end

    while true do
        local vehicles = GetGamePool('CVehicle')

        for _, vehicle in ipairs(vehicles) do
            if not EmergencyVehicles[vehicle] and not SyncVehicles[vehicle] and not VerifiedVehicles[vehicle] then
                VerifyVehicle(vehicle)

                VerifiedVehicles[vehicle] = true
            end
        end

        Citizen.Wait(2000)
    end
end)

-- FKEN SIRENS PLZ STOP
Citizen.CreateThread(function ()
    while true do
        DistantCopCarSirens(false)
        Citizen.Wait(100)
    end
end)