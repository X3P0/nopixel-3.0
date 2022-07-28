DroppedEvidence, IsAccumulating, EvidenceDisabled = {}, false, false

AddEventHandler('np-evidence:disable', function (pDisable)
    EvidenceDisabled = pDisable
end)

AddEventHandler('np-evidence:dropEvidence', function (pCoords, pMeta, pSuffix)
    local uid = pCoords.x .. '-' .. pCoords.y .. '-' .. pCoords.z

    if pSuffix then uid = uid .. '-' .. pSuffix end

    DroppedEvidence[uid] = {
        ['x'] = pCoords.x,
        ['y'] = pCoords.y,
        ['z'] = pCoords.z,
        ['meta'] = pMeta
    }

    if IsAccumulating or EvidenceDisabled then return end

    IsAccumulating = true

    Citizen.SetTimeout(5000, function ()
        local dropped = DroppedEvidence

        DroppedEvidence = {}

        IsAccumulating = false

        RPC.execute('np-evidence:addEvidence', dropped)
    end)
end)