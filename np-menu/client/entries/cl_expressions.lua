local GeneralEntries, SubMenu = MenuEntries['general'], {}

local Expressions = {
    {
        id = "expressions:angry",
        title= _L("menu-expressions-angry", "Angry"),
        icon="#expressions-angry",
        event = "expressions",
        parameters =  { "mood_angry_1" }
    },
    {
        id = "expressions:drunk",
        title= _L("menu-expressions-drunk", "Drunk"),
        icon="#expressions-drunk",
        event = "expressions",
        parameters =  { "mood_drunk_1" }
    },
    {
        id = "expressions:dumb",
        title= _L("menu-expressions-dumb", "Dumb"),
        icon="#expressions-dumb",
        event = "expressions",
        parameters =  { "pose_injured_1" }
    },
    {
        id = "expressions:electrocuted",
        title= _L("menu-expressions-electrocuted", "Electrocuted"),
        icon="#expressions-electrocuted",
        event = "expressions",
        parameters =  { "electrocuted_1" }
    },
    {
        id = "expressions:grumpy",
        title= _L("menu-expressions-grumpy", "Grumpy"),
        icon="#expressions-grumpy",
        event = "expressions",
        parameters =  { "mood_drivefast_1" }
    },
    {
        id = "expressions:happy",
        title= _L("menu-expressions-happy", "Happy"),
        icon="#expressions-happy",
        event = "expressions",
        parameters =  { "mood_happy_1" }
    },
    {
        id = "expressions:injured",
        title= _L("menu-expressions-injured", "Injured"),
        icon="#expressions-injured",
        event = "expressions",
        parameters =  { "mood_injured_1" }
    },
    {
        id = "expressions:joyful",
        title= _L("menu-expressions-joyful", "Joyful"),
        icon="#expressions-joyful",
        event = "expressions",
        parameters =  { "mood_dancing_low_1" }
    },
    {
        id = "expressions:mouthbreather",
        title= _L("menu-expressions-mouthbreather", "Mouthbreather"),
        icon="#expressions-mouthbreather",
        event = "expressions",
        parameters = { "smoking_hold_1" }
    },
    {
        id = "expressions:normal",
        title= _L("menu-expressions-normal", "Normal"),
        icon="#expressions-normal",
        event = "expressions:clear"
    },
    {
        id = "expressions:oneeye",
        title= _L("menu-expressions-oneeye", "One Eye"),
        icon="#expressions-oneeye",
        event = "expressions",
        parameters = { "pose_aiming_1" }
    },
    {
        id = "expressions:shocked",
        title= _L("menu-expressions-shocked", "Shocked"),
        icon="#expressions-shocked",
        event = "expressions",
        parameters = { "shocked_1" }
    },
    {
        id = "expressions:sleeping",
        title= _L("menu-expressions-sleeping", "Sleeping"),
        icon="#expressions-sleeping",
        event = "expressions",
        parameters = { "dead_1" }
    },
    {
        id = "expressions:smug",
        title= _L("menu-expressions-smug", "Smug"),
        icon="#expressions-smug",
        event = "expressions",
        parameters = { "mood_smug_1" }
    },
    {
        id = "expressions:speculative",
        title= _L("menu-expressions-speculative", "Speculative"),
        icon="#expressions-speculative",
        event = "expressions",
        parameters = { "mood_aiming_1" }
    },
    {
        id = "expressions:stressed",
        title= _L("menu-expressions-stressed", "Stressed"),
        icon="#expressions-stressed",
        event = "expressions",
        parameters = { "mood_stressed_1" }
    },
    {
        id = "expressions:sulking",
        title= _L("menu-expressions-sulking", "Sulking"),
        icon="#expressions-sulking",
        event = "expressions",
        parameters = { "mood_sulk_1" },
    },
    {
        id = "expressions:weird",
        title= _L("menu-expressions-weird", "Weird"),
        icon="#expressions-weird",
        event = "expressions",
        parameters = { "effort_2" }
    },
    {
        id = "expressions:weird2",
        title= _L("menu-expressions-weird2", "Weird 2"),
        icon="#expressions-weird2",
        event = "expressions",
        parameters = { "effort_3" }
    }
}

Citizen.CreateThread(function()
    for index, data in ipairs(Expressions) do
        SubMenu[index] = data.id
        MenuItems[data.id] = {data = data}
    end

    GeneralEntries[#GeneralEntries+1] = {
        data = {
            id = "expressions",
            icon = "#expressions",
            title = _L("menu-context-expressions", "Expressions"),
        },
        subMenus = SubMenu,
        isEnabled = function ()
            return not isDead
        end,
    }
end)

