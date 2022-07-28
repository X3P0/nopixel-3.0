local AirTraffic = {}

local aircraftData = CacheableMap(function (ctx, netId, aircraft)
    local aircraftPlate = not aircraft.jammed and aircraft.plate or _L("atc-undisclosed", "Undisclosed")
    local aircraftType = aircraft.type == 'helicopter' and _L("helicopter", 'Helicopter') or _L("plane", 'Plane')
    local aircraftModel = GetModelName(aircraft.model)

    local pilotName = aircraft.pilot or _L("atc-undisclosed", "Undisclosed")
    local callsign = aircraft.callsign or aircraftPlate

    local altitude = math.floor((aircraft.coords.z  * 3.6) * 3.2) -- Meters to feet
    local speed = math.floor((aircraft.speed * 3.6) * 1.609344) -- Meters to knot

    local deperturePoint = aircraft.deperture  or _L("atc-undisclosed", "Undisclosed")
    local arrivalPoint = aircraft.arrival or _L("atc-undisclosed", "Undisclosed")

    local passengers = aircraft.passengers or _L("atc-undisclosed", "Undisclosed")

    local entry = {
        title = ("%s | %s"):format(aircraftType, aircraftModel),
        description = _L("atc-traffic-list-description", "Pilot: {0} | Callsign: {1}", pilotName, callsign),
        children = {
            {
                title = _L("atc-aircraft-info", "Aircraft Info"),
                description = _L("atc-aircraft-info-description", "Pilot: {0} | Callsign: {1}", pilotName, callsign)
            },
            {
                title = _L("atc-aircraft-flight-plan", "Aircraft Flight Plan"),
                description = _L("atc-aircraft-flight-plan", "Deperture: {0} | Arrival: {1}", deperturePoint, arrivalPoint)
            },
            {
                title = _L("atc-aircraft-metrics", "Aircraft Metrics"),
                description = _L("atc-aircraft-metrics-description", "Speed: {0} kts | Altitude: {1} feet MSL", speed, altitude)
            },
            {
                title = _L("atc-set-flight-data", "Set Aircraft Data"),
                action = "np-atc:setFlightData",
                key = netId
            },
        }
    }

    return true, entry
end, { timeToLive = 60 * 1000 })

function SetAirTraffic(pAirspace)
    AirTraffic = pAirspace
end

function GetAirTraffic()
    return AirTraffic
end

function AddAircraftToTraffic(pNetId, pAircraft)
    AirTraffic[pNetId] = pAircraft
end

function RemoveAircraftFromTraffic(pNetId)
    AirTraffic[pNetId] = nil
end

function UpdateAirTraffic(pAirspace)
    local updated = false

    for netId, data in pairs(pAirspace) do
        if not data or not AirTraffic[netId] then goto continue end

        local aircraft = AirTraffic[netId]

        if not data.transmitting then goto continue end

        for k,v in pairs(data) do
            aircraft[k] = v
        end

        updated = true

        aircraftData.reset(netId)

        :: continue ::
    end

    if not updated then return end

    exports['np-fx']:PlayEntitySound(PlayerPedId(), 'IDLE_BEEP', 'EPSILONISM_04_SOUNDSET')
end

function ShowAirTraffic()
    if not HasRadarEnabled then return end

    local elements = {}

    for netId, aircraft in pairs(AirTraffic) do
        if not aircraft then goto continue end

        elements[#elements+1] = aircraftData.get(netId, aircraft)

        :: continue ::
    end

    if #elements == 0 then
        elements[#elements+1] = { title = "Not Found", description = "No active aircraft were found"}
    end

    exports['np-ui']:showContextMenu(elements)
end

function SetFlightData(pNetId)
    local result = exports['np-ui']:OpenInputMenu({
        { name = "pilot", label = "Pilot Name", icon = "user-edit"},
        { name = "callsign", label = "Aircraft Callsign", icon = "file-signature"},
        { name = "passengers", label = "Passengers Aboard", icon = "users"},
        { name = "deperture", label = "Deperture Location", icon = "plane-departure"},
        { name = "arrival", label = "Arrival Location", icon = "plane-arrival"},
    })

    if not result then return end

    local data = {}

    if result.pilot then data['pilot'] = result.pilot end

    if result.callsign then data['callsign'] = result.callsign end

    if result.passengers then data['passengers'] = result.passengers end

    if result.deperture then data['deperture'] = result.deperture end

    if result.arrival then data['arrival'] = result.arrival end

    RPC.execute('np-atc:updateFlightData', pNetId, data)
end

function UpdateFlightData(pNetID, pData)
    if not AirTraffic[pNetID] then return end

    AirTraffic[pNetID] = pData

    aircraftData.reset(pNetID)
end

AddEventHandler('np-atc:setFlightData', function ()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    if netId == 0 then return end

    SetFlightData(netId)
end)

RegisterUICallback('np-atc:setFlightData', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } });

    if not data.key or data.key == 0 then return end

    Citizen.Wait(1000)

    SetFlightData(data.key)
end)



AddEventHandler('np-atc:showAirTraffic', function ()
    if not HasRadarEnabled then return end

    ShowAirTraffic()
end)

