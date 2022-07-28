RESTAURANT_DATA = {
    {
      name = "Player Shop",
      short = "ps",
      code = "playershop",
      ingredients = 1,
    },
    {
      name = "Burger Shot",
      short = "bs",
      code = "burger_shot",
      ingredients = 1,
    },
    {
      name = "Rooster's Rest",
      short = "rr",
      code = "rooster",
      ingredients = 1,
    },
    {
      name = "Maldinis",
      short = "mal",
      code = "maldinis",
      ingredients = 1,
    },
    {
      name = "Uwu Cafe",
      short = "uwu",
      code = "uwu_cafe",
      ingredients = 1,
    },
    {
      name = "Prison",
      short = "prison",
      code = "prison_cooks",
      ingredients = 1,
    },
}

function GetBusinessConfig(pCode)
  for _, r in pairs(RESTAURANT_DATA) do
    if r.code == pCode then
      return r
    end
  end
  return RESTAURANT_DATA[1]
end

MAX_EMPLOYEES = 6
MAX_RECEIPTS_PER_HOUR = 40
MENU_CHANGE_COOLDOWN = 60 * 60 * 1000 -- 1hr in ms
