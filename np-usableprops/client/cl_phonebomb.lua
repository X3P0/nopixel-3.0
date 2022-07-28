RegisterNetEvent('np-usableprops:detonateVehicle', function(pNetId, pExplosionSource)
    print('Detonating vehicle', pNetId, pExplosionSource)
    local vehicle = NetworkGetEntityFromNetworkId(pNetId)
    AddVehiclePhoneExplosiveDevice(vehicle)
    local planted = true
    Citizen.CreateThread(function()
        while planted do
            local soundId = GetSoundId()
            PlaySoundFromEntity(soundId, 'Landing_Tone', vehicle, 'DLC_PILOT_ENGINE_FAILURE_SOUNDS', true, 1)
            Wait(665)
            if not HasSoundFinished(soundId) then
                StopSound(soundId)
                ReleaseSoundId(soundId)
            end
        end
    end)
    Wait(5000)
    if not HasSoundFinished(soundId) then
        StopSound(soundId)
        ReleaseSoundId(soundId)
    end
    planted = false
    DetonateVehiclePhoneExplosiveDevice()
end)
