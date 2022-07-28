function getIngredientOptions(num)
  return {
    icon = "circle",
    label = _L("ingredient", "Ingredient Type " .. num),
    name = "ingredient_type_" .. num,
    _type = "select",
    options = {
      {
        id = "oil",
        name = "Oil",
      },
      {
        id = "protein",
        name = "Protein",
      },
      {
        id = "vegetables",
        name = "Vegetables",
      },
      {
        id = "leavening",
        name = "Leavening",
      },
      {
        id = "dairy",
        name = "Dairy",
      },
      {
        id = "grain",
        name = "Grain",
      },
      {
        id = "seasoning",
        name = "Seasoning",
      },
      {
        id = "sugar",
        name = "Sugar",
      },
    }
  }
end

function manageFood(restaurant, foodType)
  local items = {
    {
      icon = "circle",
      label = _L("name", "Name"),
      name = "name",
    },
    {
      icon = "circle",
      label = _L("description", "Description"),
      name = "description",
    },
    {
      icon = "circle",
      label = _L("image-url", "Image URL (100px x 100px)"),
      name = "image_url",
    },
    getIngredientOptions(1),
  }
  if foodType == "main" then
    items[#items + 1] = getIngredientOptions(2)
    items[#items + 1] = getIngredientOptions(3)
    items[#items + 1] = getIngredientOptions(4)
    items[#items + 1] = getIngredientOptions(5)
  end
  exports['np-ui']:openApplication('textbox', {
    callbackUrl = 'np-ui:restaurants:createFood',
    key = { restaurant = restaurant, food_type = foodType },
    items = items,
    show = true,
  })
end

-- RegisterCommand("food:manage", function()
--   manageFood("bs", "main")
-- end, false)

RegisterUICallback("np-ui:restaurants:createFood", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  exports['np-ui']:closeApplication('textbox')
  RPC.execute('np-restaurants:createFoodItem', data)
end)

RegisterUICallback("np-ui:restaurants:createMenuItem", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  Wait(100)
  manageFood(data.key.restaurant, data.key.foodType)
end)

RegisterUICallback("np-ui:restaurants:manageFoodItem", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  Wait(100)
  if data.key.action == "delete" then
    RPC.execute("np-restaurants:deleteFoodItem", data.key.id, data.key.restaurant)
    return
  end
end)

AddEventHandler("np-restaurants:manageFoodMenu", function(pParams, p2, pContext)
  local restaurant = pParams.isEditorPeek and exports["np-housing"]:getCurrentPropertyID() or pContext.zones["restaurant_manage_food_menu"].id

  local jobAccess = pParams.isEditorPeek and {} or pContext.zones["restaurant_manage_food_menu"].jobs
  local hasJobAccess = false
  if jobAccess then
    local curJob = exports['isPed']:isPed('myjob')
    for _,job in ipairs(jobAccess) do
      if curJob == job then
        hasJobAccess = true
        break
      end
    end
  end

  -- local foodType = "main"
  -- manageFood(restaurant, foodType)
  local hasCraftAccess = exports["np-business"]:HasPermission(restaurant, "craft_access")
  if not hasCraftAccess and not hasJobAccess and not pParams.isEditorPeek then
    TriggerEvent("DoLongHudText", _L("no-access", "You are not recognized here."), 2)
    return
  end
  local contextMenu = {
    {
      i18nTitle = true,
      title = "Menu Management",
      icon = "hamburger",
    },
    {
      i18nTitle = true,
      title = "Create New Item",
      icon = "file",
      children = {
        {
          i18nTitle = true,
          title = "Main Dish",
          icon = "hamburger",
          key = { foodType = "main", restaurant = restaurant },
          action = "np-ui:restaurants:createMenuItem",
        },
        {
          i18nTitle = true,
          title = "Side Dish",
          icon = "bacon",
          key = { foodType = "side", restaurant = restaurant },
          action = "np-ui:restaurants:createMenuItem",
        },
        {
          i18nTitle = true,
          title = "Dessert",
          icon = "ice-cream",
          key = { foodType = "dessert", restaurant = restaurant },
          action = "np-ui:restaurants:createMenuItem",
        },
        {
          i18nTitle = true,
          title = "Drink",
          icon = "coffee",
          key = { foodType = "drink", restaurant = restaurant },
          action = "np-ui:restaurants:createMenuItem",
        },
      },
    },
    {
      i18nTitle = true,
      title = "Dishes",
      icon = "utensils",
    },
  }
  local foodItems = FoodItems.get(restaurant)
  if not foodItems then
    foodItems = {}
  end
  local dishes = { main = {}, side = {}, dessert = {}, drink = {} }
  for _, item in pairs(foodItems) do
    local desc = ""
    for _, ingred in pairs(json.decode(item.data)["ingredients"]) do
      desc = desc .. ingred .. ","
    end
    desc = desc:sub(1, -2)
    dishes[item.food_type][#dishes[item.food_type] + 1] = {
      title = item.name,
      description = item.description .. "(" .. desc .. ")",
      image = item.image_url,
      children = {
        {
          i18nTitle = true,
          title = "Delete Item",
          icon = "trash",
          key = { action = "delete", id = item.id, restaurant = restaurant },
          action = "np-ui:restaurants:manageFoodItem",
        },
      },
    }
  end
  for k, v in pairs(dishes) do
    if #v > 0 then
      contextMenu[#contextMenu + 1] = {
        i18nTitle = true,
        title = "Manage " .. k .. " dishes",
        icon = "tasks",
        children = v,
      }
    end
  end
  exports["np-ui"]:showContextMenu(contextMenu)
end)

AddEventHandler("np-restaurants:manageDailyMenu", function(pParams, p2, pContext)
  local restaurant = pParams.isEditorPeek and exports["np-housing"]:getCurrentPropertyID() or pContext.zones["restaurant_manage_food_menu"].id

  local jobAccess = pParams.isEditorPeek and {} or pContext.zones["restaurant_manage_food_menu"].jobs
  local hasJobAccess = false
  if jobAccess then
    local curJob = exports['isPed']:isPed('myjob')
    for _,job in ipairs(jobAccess) do
      if curJob == job then
        hasJobAccess = true
        break
      end
    end
  end

  local hasCraftAccess = exports["np-business"]:HasPermission(restaurant, "craft_access")
  if not hasCraftAccess and not hasJobAccess and not pParams.isEditorPeek then
    TriggerEvent("DoLongHudText", _L("no-access", "You are not recognized here."), 2)
    return
  end

  -- Get all main dishes
  local foodItems = getFoodItemsOfType(restaurant, "main")

  local foodElements = {}
  for _,item in pairs(foodItems) do
    foodElements[#foodElements + 1] = {
      id = item.id,
      name = item.name,
    }
  end

  local elements = {
    {
      label = "Select Main Dish 1",
      name = "dish1",
      _type = "select",
      icon = "list-alt",
      options = foodElements,
    },
    {
      label = "Select Main Dish 2",
      name = "dish2",
      _type = "select",
      icon = "list-alt",
      options = foodElements,
    },
    {
      label = "Select Main Dish 3",
      name = "dish3",
      _type = "select",
      icon = "list-alt",
      options = foodElements,
    },
    {
      label = "Select Main Dish 4",
      name = "dish4",
      _type = "select",
      icon = "list-alt",
      options = foodElements,
    },
    {
      label = "Select Main Dish 5",
      name = "dish5",
      _type = "select",
      icon = "list-alt",
      options = foodElements,
    }
  }

  local prompt = exports["np-ui"]:OpenInputMenu(elements)
  if not prompt then return end

  local dishes = { prompt.dish1, prompt.dish2, prompt.dish3, prompt.dish4, prompt.dish5 }
  RPC.execute("np-restaurants:setMenu", restaurant, dishes)
end)
