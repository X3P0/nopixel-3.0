Citizen.CreateThread(function()
    for id, zone in ipairs(HiveZones) do
        exports["np-polyzone"]:AddCircleZone("np-beekeeping:bee_zone", zone[1], zone[2],{
            zoneEvents={"np-beekeeping:trigger_zone"},
            data = {
                id = id,
            },
        })
    end
end)