local GeneralEntries, SubMenu = MenuEntries['general'], {}

local MenuOptions = {
  {
      id = 'radio:switchChannel1',
      title = _L("menu-radio-switchchannel1", "1"),
      icon = "#general-door-keyFob",
      event = "np-radio:setChannel",
      parameters = { "1" }
  },
  {
      id = 'radio:switchChannel2',
      title = _L("menu-radio-switchchannel2", "2"),
      icon = "#general-door-keyFob",
      event = "np-radio:setChannel",
      parameters = { "2" }
  },
  {
      id = 'radio:switchChannel3',
      title = _L("menu-radio-switchchannel3", "3"),
      icon = "#general-door-keyFob",
      event = "np-radio:setChannel",
      parameters = { "3" }
  },
  {
      id = 'radio:switchChannel4',
      title = _L("menu-radio-switchchannel4", "4"),
      icon = "#general-door-keyFob",
      event = "np-radio:setChannel",
      parameters = { "4" }
  },
  {
      id = 'radio:switchChannel5',
      title = _L("menu-radio-switchchannel5", "5"),
      icon = "#general-door-keyFob",
      event = "np-radio:setChannel",
      parameters = { "5" }
  },
  {
      id = 'radio:switchChannel6',
      title = _L("menu-radio-switchchannel6", "6"),
      icon = "#general-door-keyFob",
      event = "np-radio:setChannel",
      parameters = { "6" }
  },
}

Citizen.CreateThread(function()
  for index, data in ipairs(MenuOptions) do
      SubMenu[index] = data.id
      MenuItems[data.id] = {data = data}
  end
  GeneralEntries[#GeneralEntries+1] = {
      data = {
          id = "radio:switchChannel",
          icon = "#general-door-keyFob",
          title = _L("menu-context-radio", "Radio"),
      },
      subMenus = SubMenu,
      isEnabled = function()
          return (isPolice or isMedic) and not isDead
      end,
  }
end)
