Config = {}

-- Default Values
Config.populationDensity = 0.8

Config.antiGhostDebug = false
Config.antiGhostYeetVehicles = true
Config.antiGhostScaleX = 10.0
Config.antiGhostScaleY = 5.0

Citizen.CreateThread(function ()
    while not NetworkIsSessionStarted() do Citizen.Wait(0) end

    local resourceConfig = exports['np-config']:GetModuleConfig('np-density')

    if resourceConfig == nil then return end

    Config = resourceConfig
end)

AddEventHandler('np-config:configLoaded', function (pId, pConfig)
    if (pId ~= 'np-density') then return end

    Config = pConfig
end)