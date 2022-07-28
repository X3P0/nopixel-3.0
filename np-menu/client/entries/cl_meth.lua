local GeneralEntries, SubMenu = MenuEntries['meth'], {}

local MethActions = {
    {
        data = {
            id = 'meth:enterDoor',
            title = _L('menu-meth-enterdoor', 'Enter Door'),
            icon = '#meth-enter-door',
            event = 'np-meth:enterDoor',
            parameters = {}
        },
        isEnabled = function ()
            return exports['np-inventory']:hasEnoughOfItem('methlabkey', 1, false) or exports['np-meth']:isInsideUnlockedDoorZone() or isPolice
        end
    },
    {
        data = {
            id = 'meth:destroyProperty',
            title = _L('menu-meth-destroyproperty', 'Destroy Property'),
            icon = '#meth-destroy-property',
            event = 'np-meth:seizeLab',
            parameters = {}
        },
        isEnabled = function ()
            return isPolice
        end
    },
}

Citizen.CreateThread(function()
    for index, data in ipairs(MethActions) do
        SubMenu[index] = data.data.id
        MenuItems[data.data.id] = data
    end
    GeneralEntries[#GeneralEntries+1] = {
        data = {
            id = 'meth',
            icon = '#meth-actions',
            title = _L('menu-context-methactions', 'Door Actions'),
        },
        subMenus = SubMenu,
        isEnabled = function()
            local inside = exports['np-meth']:isInsideDoorZone()
            local hasKey = exports['np-inventory']:hasEnoughOfItem('methlabkey', 1, false)
            local insideUnlocked = exports['np-meth']:isInsideUnlockedDoorZone()
            return not isDead and inside and (hasKey or insideUnlocked or isPolice)
        end,
    }
end)
