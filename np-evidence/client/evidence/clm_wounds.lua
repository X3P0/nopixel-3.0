RegisterNetEvent('evidence:bleeding', function(corpse)
    if not Ped.characterId or Ped.isInVehicle and not corpse then return end

    local currentCoords = vector3(Ped.coords.x, Ped.coords.y, Ped.coords.z - 0.7)

    if WaterTest(currentCoords) and not corpse then return end

    local identifier = (not corpse and 'DNA' or 'CORPSE') .. '-' .. Ped.characterId

    local meta = {
        ["evidenceType"] = "blood",
        ["identifier"] = identifier,
        ["other"] = "DNA Type",
        ["raining"] = IsRaining(),
    }

    TriggerEvent('np-evidence:dropEvidence', currentCoords, meta)
end)

RegisterNetEvent('evidence:dna', function(dnaType)
    if not Ped.characterId then return end

    local currentCoords = vector3(Ped.coords.x, Ped.coords.y, Ped.coords.z - 0.7)

    local identifier = dnaType .. '-' .. Ped.characterId

    local meta = {
        ["evidenceType"] = "blood",
        ["identifier"] = identifier,
        ["other"] = "DNA Type",
        ["raining"] = IsRaining(),
    }

    TriggerEvent('np-evidence:dropEvidence', currentCoords, meta)
end)

RegisterNetEvent('evidence:thermite', function()
    if not Ped.characterId then return end

    local currentCoords = vector3(Ped.coords.x, Ped.coords.y, Ped.coords.z - 0.7)

    local identifier = "thrm-" .. Ped.characterId .. math.floor((math.random() * 100000))

    local meta = {
        ["evidenceType"] = "thermite",
        ["identifier"] = identifier,
        ["other"] = "Burn Markings",
        ["raining"] = IsRaining(),
    }

    TriggerEvent('np-evidence:dropEvidence', currentCoords, meta)
end)

RegisterNetEvent('evidence:drugs', function(drugType)
    if not Ped.characterId then return end

    local currentCoords = vector3(Ped.coords.x, Ped.coords.y, Ped.coords.z - 0.7)

    local identifier = drugType .. "-" .. Ped.characterId .. math.floor((math.random() * 100000))

    local meta = {
        ["evidenceType"] = "drugs",
        ["identifier"] = identifier,
        ["other"] = "Drug Sales/Use",
        ["raining"] = IsRaining(),
    }

    TriggerEvent('np-evidence:dropEvidence', currentCoords, meta)
end)