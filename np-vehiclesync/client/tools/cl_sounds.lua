TrackedSounds = {}

function CreateEntitySound(pEntity, pSoundName, pAttempts)
    if not TrackedSounds[pEntity] then TrackedSounds[pEntity] = {} end

    local sounds = TrackedSounds[pEntity]

    if sounds[pSoundName] ~= nil then return end

    local soundId = GetSoundId()

    if (soundId <= 0) then
        local attempts = pAttempts ~= nil and pAttempts + 1 or 1

        if (attempts < 3) then CreateEntitySound(pEntity, pSoundName, attempts) end

        return print(('SHIT FUCK BUTT FARTS DESU: %s'):format(soundId))
    end

    sounds[pSoundName] = soundId

    PlaySoundFromEntity(soundId, pSoundName, pEntity, 0, 0, 0)
end

function DeleteEntitySound(pEntity, pSoundName)
    local sounds = TrackedSounds[pEntity]

    if not sounds or sounds[pSoundName] == nil then return end

    local soundId = sounds[pSoundName]

    sounds[pSoundName] = nil

    StopSound(soundId)
    ReleaseSoundId(soundId)
end

function CleanUpEntitySounds(pEntity)
    if not TrackedSounds[pEntity] then return end

    local sounds = TrackedSounds[pEntity]

    for _, soundId in pairs(sounds) do
        if soundId ~= nil then
            StopSound(soundId)
            ReleaseSoundId(soundId)
        end
    end

    TrackedSounds[pEntity] = nil
end

function FeedbackSound(pActive)
    local sound = pActive and "NAV_LEFT_RIGHT" or "NAV_UP_DOWN"
    PlaySoundFrontend(-1, sound, "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end