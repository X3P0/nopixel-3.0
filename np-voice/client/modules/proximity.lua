
local ModuleConfig, PlayersInScope, ScanningNearby = {}, {}, false


AddEventHandler('np-config:configLoaded', function (pId, pConfig)
    if (pId ~= 'np-voice') then return end

    ModuleConfig = pConfig

    local isScanning = ScanningNearby

    ScanningNearby = not ModuleConfig.useScopeSize

    if ModuleConfig.useScopeSize then return TargetPlayersInScope() end

    if not ScanningNearby or isScanning then return end

    StartProximityThread()
end)

RegisterNetEvent('onPlayerJoining')
AddEventHandler('onPlayerJoining', function(player)
    if not Config.enableProximity then return end

    local playerId = GetPlayerFromServerId(player)

    if (playerId == PlayerId()) then return end

    local playerData = {}

    playerData['id'] = playerId

    playerData['targeted'] = false

    PlayersInScope[player] = playerData

    if ModuleConfig.useScopeSize then return end

    playerData['targeted'] = true

    AddChannelToTargetList(player, 'proximity')

    if not isCloaked or playerData['listening'] then return end

    playerData['listening'] = true

    AddChannelToListeningList(player, 'proximity')
end)

RegisterNetEvent('onPlayerDropped')
AddEventHandler('onPlayerDropped', function(player)
    if not Config.enableProximity then return end

    local data = PlayersInScope[player]

    PlayersInScope[player] = nil

    if data == nil then return end

    if data['targeted'] then
        RemoveChannelFromTargetList(player, 'proximity', true)
    end

    if data['listening'] then
        RemoveChannelFromListeningList(player, 'proximity')
    end
end)

RegisterNetEvent('np-admin:cloakStatus', function (pCloaked)
    if not pCloaked then return end

    TargetPlayersInScope()
end)

function TargetPlayersInScope()
    for serverId, data in pairs(PlayersInScope) do
        if not data then goto continue end

        if not data['targeted'] then
            data['targeted'] = true

            AddChannelToTargetList(serverId, 'proximity')
        end

        if isCloaked and not data['listening'] then
            data['listening'] = true

            AddChannelToListeningList(serverId, 'proximity')
        end

        :: continue ::
    end
end

function StartProximityThread()
    Citizen.CreateThread(function ()
        while ScanningNearby do
            for _, data in pairs(PlayersInScope) do
                if not data then goto continue end

                data['ped'] = GetPlayerPed(data['id'])

                :: continue ::
            end

            Citizen.Wait(1000)
        end
    end)

    Citizen.CreateThread(function ()
        while ScanningNearby do
            local removed, update = {}, false

            local range = CurrentVoiceRange * 4

            for serverId, data in pairs(PlayersInScope) do
                if not data then goto continue end

                local coords = GetEntityCoords(data['ped'])

                local inDistance = #(PlayerCoords - coords) <= range

                if inDistance and not data['targeted'] then
                    data['targeted'] = true

                    AddChannelToTargetList(serverId, 'proximity')
                elseif not inDistance and data['targeted'] then
                    data['targeted'] = false

                    removed[#removed+1] = serverId

                    update = true
                end

                if isCloaked and not data['listening'] then
                    data['listening'] = true

                    AddChannelToListeningList(serverId, 'proximity')
                elseif not isCloaked and data['listening'] then
                    data['listening'] = false

                    RemoveChannelFromListeningList(serverId, 'proximity')
                end

                :: continue ::
            end

            if update then
                RemoveChannelGroupFromTargetList(removed, 'proximity')
            end

            Citizen.Wait(ModuleConfig.updateInterval)
        end
    end)
end

function LoadProximityModule()
    RegisterModuleContext("proximity", 0)

    UpdateContextVolume("proximity", -1.0)

    Citizen.CreateThread(function ()
        SetVoiceChannel(ServerId)

        while not exports['np-config']:IsConfigReady() do
            Citizen.Wait(500)
        end

        ModuleConfig = exports['np-config']:GetModuleConfig('np-voice')

        local playerId = PlayerId()

        local players = GetActivePlayers()

        for _, player in ipairs(players) do
            if player == playerId then goto continue end

            local serverId = GetPlayerServerId(player)

            local data = {}

            data['id'] = player

            data['ped'] = GetPlayerPed(player)

            data['targeted'] = false

            PlayersInScope[serverId] = data

            if ModuleConfig.useScopeSize then
                data['targeted'] = true

                AddChannelToTargetList(serverId, 'proximity')
            end

            :: continue ::
        end

        if ModuleConfig.useScopeSize then return end

        ScanningNearby = true

        StartProximityThread()
    end)
end