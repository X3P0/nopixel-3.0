local GeneralEntries, SubMenu = MenuEntries['judge'], {}

local JudgeActions = {
    {
        id = 'judge-raid:checkowner',
        title = _L('menu-judge-checkowner', 'Check Owner'),
        icon = '#judge-raid-check-owner',
        event = 'property:menuAction',
        parameters = {action = 'checkOwner'}
    },
    {
        id = 'judge-raid:lockdown',
        title = _L('menu-judge-togglelockdown', 'Toggle Lockdown Property'),
        icon = '#judge-raid-lock-down',
        event = 'property:menuAction',
        parameters = {action = 'lockdown'}
    },
    {
        id = 'judge-raid:forfeit',
        title = _L('menu-judge-forfeitproperty', 'Forfeit Property'),
        icon = '#judge-raid-forfeit',
        event = 'property:menuAction',
        parameters = {action = 'forfeit'}
    },
    {
        id ='judge-action:checkbank',
        title = _L('menu-judge-checkbank', 'Check Bank'),
        icon = '#police-check-bank',
        event = 'police:checkBank'
    }
}

Citizen.CreateThread(function()
    for index, data in ipairs(JudgeActions) do
        SubMenu[index] = data.id
        MenuItems[data.id] = {data = data}
    end
    GeneralEntries[#GeneralEntries+1] = {
        data = {
            id = 'judge',
            icon = '#judge-actions',
            title = _L('menu-context-judgeactions', 'Judge Actions'),
        },
        subMenus = SubMenu,
        isEnabled = function()
            return not isDead
        end,
    }
end)
