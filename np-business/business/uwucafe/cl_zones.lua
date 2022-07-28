local Zones = {
    { id = "ktown", zone = "uwucafe", coords = vector3(-583.79, -1067.19, 22.35), length = 36.8, width = 36.8, options = { minZ = 20.5, maxZ = 32.3 } },
}

local Targets = {
    { id = "screen01", event = "uwucafe-screen", coords = vector3(-587.1, -1060.58, 24.20), length = 0.6, width = 0.25, options = { minZ = 23.54, maxZ = 24.74 } },
    { id = "screen02", event = "uwucafe-screen", coords = vector3(-587.08, -1059.97, 24.20), length = 0.6, width = 0.25, options = { minZ = 23.54, maxZ = 24.74 } },
    { id = "screen03", event = "uwucafe-screen", coords = vector3(-587.08, -1059.38, 24.20), length = 0.6, width = 0.25, options = { minZ = 23.54, maxZ = 24.74 } },
    { id = "screen04", event = "uwucafe-screen", coords = vector3(-587.07, -1058.78, 24.20), length = 0.6, width = 0.25, options = { minZ = 23.54, maxZ = 24.74 } },
    { id = "screen05", event = "uwucafe-screen", coords = vector3(-587.13, -1062.79, 23.8), length = 0.6, width = 0.25, options = { minZ = 23.44, maxZ = 24.34 } },
    { id = "screen06", event = "uwucafe-screen", coords = vector3(-587.22, -1062.79, 22.9), length = 0.6, width = 0.25, options = { minZ = 22.54, maxZ = 23.44 } },
    { id = "Painting_Atlas", event = "uwucafe-painting", coords = vector3(-596.22, -1052.89, 22.34), length = 0.4, width = 0.4, options = { minZ = 22.14, maxZ = 22.34 } },
}

Citizen.CreateThread(function ()
    for _, target in ipairs(Zones) do
        NPX.Zones.addBoxZone(target.id, target.zone, target.coords, target.length, target.width, target.options)
    end

    for _, target in ipairs(Targets) do
        NPX.Zones.addBoxTarget(target.id, target.event, target.coords, target.length, target.width, target.options)
    end
end)