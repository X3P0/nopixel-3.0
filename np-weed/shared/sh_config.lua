local TrackedModules, ConfigHandlers = {}, {}

AddEventHandler('np-config:configLoaded', function (pModule, pConfig)
    if not TrackedModules[pModule] then return end

    TrackedModules[pModule] = pConfig

    if not ConfigHandlers[pModule] then return end

    ConfigHandlers[pModule](pConfig)
end)

function GetModuleConfig(pModule, pKey)
    if not TrackedModules[pModule] then
        local config = exports['np-config']:GetModuleConfig(pModule);

        if not config then return end

        TrackedModules[pModule] = config
    end

    return pKey ~= nil and TrackedModules[pModule][pKey] or TrackedModules[pModule]
end

PlantConfig, WeedConfig, CornerConfig, MaterialHashes, WhitelistedZones, RepThreshholds = {}, {}, {}, {}, {}, {}

ConfigHandlers['np-weed'] = function (pConfig)
    for hash,value in pairs(pConfig.validMaterials) do
        MaterialHashes[tonumber(hash)] = value
    end
    for rep,name in pairs(pConfig.repThreshholds) do
        RepThreshholds[tonumber(rep)] = name
    end
end

ConfigHandlers['np-weed:plant'] = function (pConfig)
    PlantConfig = pConfig
end

ConfigHandlers['np-weed:weed'] = function (pConfig)
    WeedConfig = pConfig
end

ConfigHandlers['np-weed:corner'] = function (pConfig)
    for zone,name in pairs(pConfig.validZones) do
        WhitelistedZones[zone] = name
    end
    CornerConfig = pConfig
end

Citizen.CreateThread(function ()
    for configId, func in pairs(ConfigHandlers) do
        func(GetModuleConfig(configId))
    end
end)
