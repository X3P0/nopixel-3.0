local Blips = {}

function GetBlipSettings(pType, pCallsign)
    local settings = {}

    settings.short = true
    settings.category = 7

    if pType == 'helicopter' then
        settings.color = 69
        settings.sprite = 64
        settings.text = ('H-%s'):format(pCallsign)
    elseif pType == 'plane' then
        settings.color = 69
        settings.sprite = 423
        settings.text = ('P-%s'):format(pCallsign)
    end

    return settings
end

function AddBlipHandler(pNetId, pType, pCallsign, pCoords)
    local settings = GetBlipSettings(pType, pCallsign)

    local handler = EntityBlip:new('entity', pNetId, settings)

    handler:enable(true)

    handler:onModeChange('coords')

    handler:onUpdateCoords(pCoords)

    Blips[pNetId] = handler
end

function RemoveBlipHandler(pNetId)
    if not Blips[pNetId] then return end

    local handler = Blips[pNetId]

    handler:disable()

    Blips[pNetId] = nil
end

function GetBlipHandler(pNetId)
    return Blips[pNetId]
end

function UpdateBlipHandlers(pAirspace)
    for netId, data in pairs(pAirspace) do
        if not data or not Blips[netId] then goto continue end

        local handler = Blips[netId]

        if handler.mode == 'entity' then
            handler:onModeChange('coords')
        end

        if not data.transmitting then goto continue end

        handler:onUpdateCoords(data.coords)

        :: continue ::
    end
end

function UpdateBlipCallsign(pNetId, pCallsign)
    if not Blips[pNetId] then return end

    local handler = Blips[pNetId]

    handler.settings.text = pCallsign

    handler:setSettings()
end

function SetBlipHandlers(pAirspace)
    for _, aircraft in pairs(pAirspace) do
        AddBlipHandler(aircraft.netId, aircraft.type, aircraft.callsign or aircraft.plate, aircraft.coords)
    end
end

function DeleteBlipHandlers()
    for netId, handler in pairs(Blips) do
        RemoveBlipHandler(netId)
    end
end