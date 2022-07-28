local GeneralEntries, SubMenu = MenuEntries['general'], {}

local Animations = {
    {
        id = 'animations:arrogant',
        title = _L("menu-animation-arrogant", "Arrogant"),
        icon = "#animation-arrogant",
        event = "Animation:Set:Gait",
        parameters = { 'move_f@arrogant@a' }
    },
    {
        id = 'animations:casual',
        title = _L("menu-animation-casual", "Casual"),
        icon = "#animation-casual",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@casual@a' }
    },
    {
        id = 'animations:casual2',
        title = _L("menu-animation-casual2", "Casual 2"),
        icon = "#animation-casual",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@casual@b' }
    },
    {
        id = 'animations:casual3',
        title = _L("menu-animation-casual3", "Casual 3"),
        icon = "#animation-casual",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@casual@c' }
    },
    {
        id = 'animations:casual4',
        title = _L("menu-animation-casual4", "Casual 4"),
        icon = "#animation-casual",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@casual@d' }
    },
    {
        id = 'animations:casual5',
        title = _L("menu-animation-casual5", "Casual 5"),
        icon = "#animation-casual",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@casual@e' }
    },
    {
        id = 'animations:casual6',
        title = _L("menu-animation-casual6", "Casual 6"),
        icon = "#animation-casual",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@casual@f' }
    },
    {
        id = 'animations:confident',
        title = _L("menu-animation-confident", "Confident"),
        icon = "#animation-confident",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@confident' }
    },
    {
        id = 'animations:business',
        title = _L("menu-animation-business", "Business"),
        icon = "#animation-business",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@business@a' }
    },
    {
        id = 'animations:business2',
        title = _L("menu-animation-business2", "Business 2"),
        icon = "#animation-business",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@business@b' }
    },
    {
        id = 'animations:business3',
        title = _L("menu-animation-business3", "Business 3"),
        icon = "#animation-business",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@business@c' }
    },

    {
        id = 'animations:femme',
        title = _L("menu-animation-femme", "Femme"),
        icon = "#animation-female",
        event = "Animation:Set:Gait",
        parameters = { 'move_f@femme@' }
    },
    {
        id = 'animations:flee',
        title = _L("menu-animation-flee", "Flee"),
        icon = "#animation-flee",
        event = "Animation:Set:Gait",
        parameters = { 'move_f@flee@a' }
    },
    {
        id = 'animations:gangster',
        title = _L("menu-animation-gangster", "Gangster"),
        icon = "#animation-gangster",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@gangster@generic' }
    },
    {
        id = 'animations:gangster2',
        title = _L("menu-animation-gangster2", "Gangster 2"),
        icon = "#animation-gangster",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@gangster@ng' }
    },
    {
        id = 'animations:gangster3',
        title = _L("menu-animation-gangster3", "Gangster 3"),
        icon = "#animation-gangster",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@gangster@var_e' }
    },
    {
        id = 'animations:gangster4',
        title = _L("menu-animation-gangster4", "Gangster 4"),
        icon = "#animation-gangster",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@gangster@var_f' }
    },
    {
        id = 'animations:gangster5',
        title = _L("menu-animation-gangster5", "Gangster 5"),
        icon = "#animation-gangster",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@gangster@var_i' }
    },
    {
        id = 'animations:heels',
        title = _L("menu-animation-heels", "Heels"),
        icon = "#animation-female",
        event = "Animation:Set:Gait",
        parameters = { 'move_f@heels@c' }
    },
    {
        id = 'animations:heels2',
        title = _L("menu-animation-heels2", "Heels 2"),
        icon = "#animation-female",
        event = "Animation:Set:Gait",
        parameters = { 'move_f@heels@d' }
    },
    {
        id = 'animations:hiking',
        title = _L("menu-animation-hiking", "Hiking"),
        icon = "#animation-hiking",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@hiking' }
    },
    {
        id = 'animations:muscle',
        title = _L("menu-animation-muscle", "Muscle"),
        icon = "#animation-tough",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@muscle@a' }
    },
    {
        id = 'animations:quick',
        title = _L("menu-animation-quick", "Quick"),
        icon = "#animation-quick",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@quick' }
    },
    {
        id = 'animations:wide',
        title = _L("menu-animation-wide", "Wide"),
        icon = "#animation-wide",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@bag' }
    },
    {
        id = 'animations:scared',
        title = _L("menu-animation-scared", "Scared"),
        icon = "#animation-scared",
        event = "Animation:Set:Gait",
        parameters = { 'move_f@scared' }
    },
    {
        id = 'animations:brave',
        title = _L("menu-animation-brave", "Brave"),
        icon = "#animation-brave",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@brave' }
    },
    {
        id = 'animations:tipsy',
        title = _L("menu-animation-tipsy", "Tipsy"),
        icon = "#animation-tipsy",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@drunk@slightlydrunk' }
    },
    {
        id = 'animations:injured',
        title = _L("menu-animation-injured", "Injured"),
        icon = "#animation-injured",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@injured' }
    },
    {
        id = 'animations:tough',
        title = _L("menu-animation-tough", "Tough"),
        icon = "#animation-tough",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@tough_guy@' }
    },
    {
        id = 'animations:sassy',
        title = _L("menu-animation-sassy", "Sassy"),
        icon = "#animation-sassy",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@sassy' }
    },
    {
        id = 'animations:sad',
        title = _L("menu-animation-sad", "Sad"),
        icon = "#animation-sad",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@sad@a' }
    },
    {
        id = 'animations:posh',
        title = _L("menu-animation-posh", "Posh"),
        icon = "#animation-posh",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@posh@' }
    },
    {
        id = 'animations:alien',
        title = _L("menu-animation-alien", "Alien"),
        icon = "#animation-alien",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@alien' }
    },
    {
        id = 'animations:nonchalant',
        title = _L("menu-animation-nonchalant", "Nonchalant"),
        icon = "#animation-nonchalant",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@non_chalant' }
    },
    {
        id = 'animations:hobo',
        title = _L("menu-animation-hobo", "Hobo"),
        icon = "#animation-hobo",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@hobo@a' }
    },
    {
        id = 'animations:money',
        title = _L("menu-animation-money", "Money"),
        icon = "#animation-money",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@money' }
    },
    {
        id = 'animations:swagger',
        title = _L("menu-animation-swagger", "Swagger"),
        icon = "#animation-swagger",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@swagger' }
    },
    {
        id = 'animations:shady',
        title = _L("menu-animation-shady", "Shady"),
        icon = "#animation-shady",
        event = "Animation:Set:Gait",
        parameters = { 'move_m@shadyped@a' }
    },
    {
        id = 'animations:maneater',
        title = _L("menu-animation-maneater", "Man Eater"),
        icon = "#animation-maneater",
        event = "Animation:Set:Gait",
        parameters = { 'move_f@maneater' }
    },
    {
        id = 'animations:chichi',
        title = _L("menu-animation-chichi", "ChiChi"),
        icon = "#animation-chichi",
        event = "Animation:Set:Gait",
        parameters = { 'move_f@chichi' }
    },
    {
        id = 'animations:dean',
        title = _L("menu-animation-dean", "Dean"),
        icon = "#animation-dean",
        event = "Animation:Set:Gait",
        parameters = { 'move_chubby' }
    },
    {
        id = 'animations:default',
        title = _L("menu-animation-default", "Default"),
        icon = "#animation-default",
        event = "AnimSet:default"
    }
}

Citizen.CreateThread(function()
    for index, data in ipairs(Animations) do
        SubMenu[index] = data.id
        MenuItems[data.id] = {data = data}
    end
    GeneralEntries[#GeneralEntries+1] = {
        data = {
            id = "animations",
            icon = "#walking",
            title = "Walk Style",
        },
        subMenus = SubMenu,
        isEnabled = function()
            return not isDead
        end,
    }
end)




