local GeneralEntries, SubMenu = MenuEntries['games'], {}

local GameOptions = {
    {
        data = {
            id = 'games:leaveGame',
            title = _L('menu-games-leave', 'Leave'),
            icon = '#arcade-game-leave',
            event = 'np-games:leaveLobby',
            parameters = {}
        },
        isEnabled = function ()
            return exports['np-games']:isInStartedLobby()
        end
    },
    {
        data = {
            id = 'games:restartGame',
            title = _L('menu-games-restart', 'Restart'),
            icon = '#arcade-game-restart',
            event = 'np-games:restartGame',
            parameters = {}
        },
        isEnabled = function ()
            local inLobby = exports['np-games']:isInStartedLobby()
            local isLeader = exports['np-games']:isLobbyLeader()
            local canBeRestarted = exports['np-games']:canBeRestarted()
            return inLobby and isLeader and canBeRestarted
        end
    },
    {
        data = {
            id = 'games:endGame',
            title = _L('menu-games-end', 'End Game'),
            icon = '#arcade-game-end',
            event = 'np-games:endGame',
            parameters = {}
        },
        isEnabled = function ()
            local inLobby = exports['np-games']:isInStartedLobby()
            local isLeader = exports['np-games']:isLobbyLeader()
            return inLobby and isLeader
        end
    },
    {
        data = {
            id = 'games:tdm:changeLoadout',
            title = _L('menu-games-airsoft-tdm-changeloadout', 'Change Loadout'),
            icon = '#arcade-airsoft-tdm-changeloadout',
            event = 'np-games:airsoft:tdm:showLoadoutMenu',
            parameters = {}
        },
        isEnabled = function ()
            local inLobby = exports['np-games']:isInStartedLobby()
            local isInTDM = exports['np-games-airsoft']:isInTDM()
            local isSpawned = exports['np-games-airsoft']:isSpawnedTDM()
            return inLobby and isInTDM and isSpawned
        end
    },
    {
        data = {
            id = 'games:vtag:flipVeh',
            title = "Flip vehicle over",
            icon = '#arcade-vtag-flip',
            event = 'np-games:vtag:flipVehicle',
            parameters = {}
        },
        isEnabled = function ()
            local inLobby = exports['np-games']:isInStartedLobby()
            local game = exports['np-games']:getGameOfLobby()
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if not vehicle then return false end
            local driver = GetPedInVehicleSeat(vehicle, -1)
            if not driver or driver ~= PlayerPedId() then return false end
            local rotation = GetEntityRotation(vehicle, 2)
            local isSideways = rotation.y < -88 or rotation.y > 88
            return inLobby and game == 'vehicle-tag' and (not IsVehicleOnAllWheels(vehicle) or isSideways)
        end
    },
    {
        data = {
            id = 'games:vtag:resetIntoPlaying',
            title = "Reset into area",
            icon = '#arcade-vtag-reset',
            event = 'np-games:vtag:resetArea',
            parameters = {}
        },
        isEnabled = function ()
            local inLobby = exports['np-games']:isInStartedLobby()
            local game = exports['np-games']:getGameOfLobby()
            local isInZone = exports['np-games-vehicletag']:isInZone()
            return inLobby and game == 'vehicle-tag' and not isInZone
        end
    },
    {
        data = {
            id = 'games:vtag:respawn',
            title = "Reset into area",
            icon = '#arcade-vtag-respawn',
            event = 'np-games:vtag:respawn',
            parameters = {}
        },
        isEnabled = function ()
            local inLobby = exports['np-games']:isInStartedLobby()
            local game = exports['np-games']:getGameOfLobby()
            return inLobby and game == 'vehicle-tag' and isDead
        end
    },
    {
        data = {
            id = 'games:stopSpectating',
            title = "Stop spectating",
            icon = '#arcade-stop-spectating',
            event = 'np-games:stopSpectating',
            parameters = {}
        },
        isEnabled = function ()
            local inSpectating = exports['np-games']:isSpectating()
            return inSpectating
        end
    },
    
}

Citizen.CreateThread(function()
    for index, data in ipairs(GameOptions) do
        SubMenu[index] = data.data.id
        MenuItems[data.data.id] = data
    end
    GeneralEntries[#GeneralEntries+1] = {
        data = {
            id = 'arcade:gameOptions',
            title = _L('menu-arcade-games-options', 'Arcade'),
            icon = '#arcade-game-options',
        },
        subMenus = SubMenu,
        isEnabled = function()
            local hasGame = exports['np-games']:isInStartedLobby()
            local isSpectating = exports['np-games']:isSpectating()
            return hasGame or isSpectating
        end,
    }
end)
