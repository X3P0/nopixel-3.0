local GeneralEntries, SubMenu = MenuEntries['general'], {}

local Blips = {
    -- {
    --     id = 'blips:gasstations',
    --     title = "Gas Stations",
    --     icon = "#blips-gasstations",
    --     event = "CarPlayerHud:ToggleGas"
    -- },
    -- {
    --     id = 'blips:trainstations',
    --     title = "Train Stations",
    --     icon = "#blips-trainstations",
    --     event = "Trains:ToggleTainsBlip"
    -- },
    {
        id = 'blips:barbershop',
        title = _L("menu-blips-barbershop", "Barber Shop"),
        icon = "#blips-barbershop",
        event = "np-clothing:toggleBarberBlips"
    },
    {
        id = 'blips:tattooshop',
        title = _L("menu-blips-tattooshop", "Tattoo Shop"),
        icon = "#blips-tattooshop",
        event = "np-clothing:toggleTattooBlips"
    },
    {
        id = 'blips:fishinglocation',
        title = _L("menu-blips-fishinglocation", "Fishing Location"),
        icon = "#blips-fishing",
        event = "fishing:addFishingBlip"
    },
}

Citizen.CreateThread(function()
    for index, data in ipairs(Blips) do
        SubMenu[index] = data.id
        MenuItems[data.id] = {data = data}
    end

    GeneralEntries[#GeneralEntries+1] = {
        data = {
            id = "blips",
            icon = "#blips",
            title = _L("menu-context-blips", "Blips")
        },
        subMenus = SubMenu,
        isEnabled = function()
            return not isDead
        end,
    }
end)

