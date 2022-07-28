HasRadarEnabled = false

RegisterNetEvent('np-atc:enableRadar', function ()
    if HasRadarEnabled then return end

    HasRadarEnabled = true

    TriggerEvent('np-voice:atc:connect')

    TriggerEvent('DoLongHudText', 'Connected to ATC Network')

    RPC.execute('np-atc:setRadarStatus', HasRadarEnabled)
end)

RegisterNetEvent('np-atc:disableRadar', function ()
    if not HasRadarEnabled then return end

    HasRadarEnabled = false

    DeleteBlipHandlers()

    TriggerEvent('np-voice:atc:disconnect')

    TriggerEvent('DoLongHudText', 'Disconnected from ATC Network')

    RPC.execute('np-atc:setRadarStatus', HasRadarEnabled)
end)

RegisterNetEvent('np-atc:setAirSpace', function (pAirspace)
    if not HasRadarEnabled then return end

    SetBlipHandlers(pAirspace)

    SetAirTraffic(pAirspace)
end)

RegisterNetEvent('np-atc:addToAirSpace', function (pAircraft)
    if not HasRadarEnabled then return end

    AddBlipHandler(pAircraft.netId, pAircraft.type, pAircraft.callsign or pAircraft.plate, pAircraft.coords)

    AddAircraftToTraffic(pAircraft.netId, pAircraft)
end)

RegisterNetEvent('np-atc:removeFromAirSpace', function (pNetId)
    if not HasRadarEnabled then return end

    RemoveBlipHandler(pNetId)

    RemoveAircraftFromTraffic(pNetId)
end)

RegisterNetEvent('np-atc:updateAirSpace', function (pAirspace)
    if not HasRadarEnabled then return end

    UpdateBlipHandlers(pAirspace)

    UpdateAirTraffic(pAirspace)
end)

RegisterNetEvent('np-atc:updateFlightData', function (pNetID, pData)
    if not HasRadarEnabled then return end

    UpdateFlightData(pNetID, pData)

    if not pData.callsign then return end

    UpdateBlipCallsign(pNetID, pData.callsign)
end)