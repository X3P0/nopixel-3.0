local InATCBoundary, Countdown = false, nil

Citizen.CreateThread(function ()
    exports['np-interact']:AddPeekEntryByPolyTarget('np-atc:radar', {
        {
            id = "np-atc:enableRadar",
            event = "np-atc:enableRadar",
            icon = "digital-tachograph",
            label = "Enable Flight Radar"
        }
    },
    {
        distance = { radius = 3.5 },
        isEnabled = function ()
            return not HasRadarEnabled
        end
    })

    exports['np-interact']:AddPeekEntryByPolyTarget('np-atc:radar', {
        {
            id = "np-atc:airtrafficData",
            event = "np-atc:showAirTraffic",
            icon = "plane-departure",
            label = "Show Air Traffic Data"
        },
        {
            id = "np-atc:disableRadar",
            event = "np-atc:disableRadar",
            icon = "digital-tachograph",
            label = "Disable Flight Radar"
        }
    },
    {
        distance = { radius = 3.5 },
        isEnabled = function ()
            return HasRadarEnabled
        end
    })

    -- MRPD ATC
    exports["np-polyzone"]:AddBoxZone("np-atc:boundary", vector3(444.89, -997.68, 34.97), 5.0, 11.0, {
        data = { id = "mrpd_atc" },
        heading = 0,
        minZ = 33.97,
        maxZ = 37.37,
    })

    --exports["np-polyzone"]:AddBoxZone("np-atc:boundary", vector3(1859.57, 3689.73, 38.23), 7.2, 5.6, {
    --    data = { id = "sandyso_atc" },
    --    heading=300,
    --    minZ=37.18,
    --    maxZ=40.38
    --})

    exports["np-polytarget"]:AddBoxZone("np-atc:radar", vector3(441.84, -999.63, 34.97), 1.2, 1.55, {
        data = { id = "mrpd_atc_2" },
        heading = 0,
        minZ = 34.67,
        maxZ = 35.27,
    })

    --exports["np-polytarget"]:AddBoxZone("np-atc:radar", vector3(1862.64, 3690.64, 38.22), 0.8, 1.8, {
    --    data = { id = "sandyso_atc" },
    --    heading=300,
    --    minZ=38.02,
    --    maxZ=38.82
    --})
end)

AddEventHandler('np-polyzone:enter', function (pName)
    if pName ~= 'np-atc:boundary' then return end

    InATCBoundary = true

    if Countdown then Countdown:resolve(false) end
end)

AddEventHandler('np-polyzone:exit', function (pName)
    if pName ~= 'np-atc:boundary' then return end

    Countdown = TimeOut(10 * 1000):next(function (continue)
        Countdown = nil

        if not continue then return end

        InATCBoundary = false

        if HasRadarEnabled then
            TriggerEvent('np-atc:disableRadar')
        end
    end)
end)