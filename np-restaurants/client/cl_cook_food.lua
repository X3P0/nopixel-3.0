local appropriateFoodItems = nil
local foodItemEnhancements = {}
local function getAppropriateFoodItems()
  if appropriateFoodItems then return appropriateFoodItems end
  local items = exports["np-inventory"]:getFullItemList()
  appropriateFoodItems = {}
  for k, v in pairs(items) do
    if v.foodCategory then
      v.itemName = k
      appropriateFoodItems[#appropriateFoodItems + 1] = v
      foodItemEnhancements[k] = v.foodEnhancement
    end
  end
  return appropriateFoodItems
end
local function hasCategory(categories, category)
  for _, v in pairs(categories) do
    if v == category then
      return true
    end
  end
  return false
end

FoodItems = CacheableMap(function (ctx, pRestaurant)
  local items = RPC.execute("np-restaurants:getFoodItems", pRestaurant)
  if not items then return false, nil end

  return true, items
end, { timeToLive = 60 * 60 * 1000 })

function resetFoodItems(pRestaurant)
  FoodItems.reset(pRestaurant)
end

function getFoodItemsOfType(pRestaurant, pType)
  local items = FoodItems.get(pRestaurant)
  if not items then return {} end
  local foundItems = {}
  for _, item in pairs(items) do
    if item.food_type == pType then
      foundItems[#foundItems + 1] = item
    end
  end
  return foundItems
end

AvailableMainDishes = CacheableMap(function (ctx, pRestaurant)
  local items = RPC.execute("np-restaurants:fetchMenu", pRestaurant)
  if not items then return false, nil end

  return true, items
end, { timeToLive = 60 * 60 * 1000 })

function resetAvailableItems(pRestaurant)
  AvailableMainDishes.reset(pRestaurant)
end

local foodTypeToItemMap = {
  ["main"] = "resfooditem",
  ["side"] = "ressideitem",
  ["dessert"] = "resdessertitem",
  ["drink"] = "resdrinkitem",
}

local function inAvailableItems(pRestaurant, pItem)
  local items = AvailableMainDishes.get(pRestaurant)
  if not items then return false end
  for _, item in pairs(items) do
    if item and item == pItem then
      return true
    end
  end
  return false
end

AddEventHandler("np-restaurants:createFoodItem", function(pParams, p2, pContext)
  local data = pParams.isEditorPeek and pParams or pContext.zones["restaurant_create_food_item"]
  if pParams.isEditorPeek then
    data.restaurant = exports["np-housing"]:getCurrentPropertyID()
  end
  local foodItems = getFoodItemsOfType(data.restaurant, data.foodType)
  if #foodItems == 0 then
    TriggerEvent("DoLongHudText", "No menu configured.", 2)
    return
  end
  local contextMenu = {}
  for _, item in pairs(foodItems) do
    if data.foodType == "main" and not inAvailableItems(data.restaurant, item.id) then
      goto continue
    end
    local desc = ""
    for _, ingred in pairs(json.decode(item.data)["ingredients"]) do
      desc = desc .. ingred .. ","
    end
    desc = desc:sub(1, -2)
    contextMenu[#contextMenu + 1] = {
      title = item.name,
      description = item.description .. " (" .. desc .. ")",
      icon = "utensils",
      key = item,
      action = "np-ui:restaurant:cookFoodItem",
      image = item.image_url,
    }
    ::continue::
  end
  if #contextMenu == 0 then
    contextMenu[#contextMenu+1] = {
      title = "No items available",
      description = "Get your manager to update the menu!",
      icon = "times",
      disabled = true,
    }
  end
  exports["np-ui"]:showContextMenu(contextMenu)
end)

RegisterUICallback("np-ui:restaurant:cookFoodItem", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  local items = getAppropriateFoodItems()
  local foodType = data.key.food_type
  local ingredients = json.decode(data.key.data).ingredients
  local foodId = data.key.id
  local imageUrl = data.key.image_url
  local restaurant = data.key.restaurant
  local name = data.key.name
  local description = data.key.description

  local ingredCounts = {}
  local uniqueIngredients = {}
  for _, ingred in pairs(ingredients) do
    if not hasCategory(uniqueIngredients, ingred) then
      uniqueIngredients[#uniqueIngredients + 1] = ingred
    end
    if not ingredCounts[ingred] then
      ingredCounts[ingred] = 0
    end
    ingredCounts[ingred] = ingredCounts[ingred] + GetBusinessConfig(restaurant).ingredients
  end

  local animDictName = "anim@amb@business@coc@coc_unpack_cut@"
  RequestAnimDict(animDictName)
  while not HasAnimDictLoaded(animDictName) do
    Citizen.Wait(0)
  end
  TaskPlayAnim(PlayerPedId(), animDictName, "fullcut_cycle_v6_cokecutter", 1.0, 4.0, -1, 18, 0, 0, 0, 0)
  while true do
    if math.random() < 0.05 then
      local finished = exports["np-ui"]:taskBarSkill(math.random(2000, 8000), math.random(7, 12))
      if finished ~= 100 then break end
    end
    local currentIngredientCounts = {}
    local currentIngredientTotals = {}
    for _, item in pairs(items) do
      for _, ingred in pairs(uniqueIngredients) do
        if hasCategory(item.__og_food_cats and item.__og_food_cats or item.foodCategory, ingred) then
          if not currentIngredientCounts[ingred] then
            currentIngredientCounts[ingred] = {}
          end
          if not currentIngredientTotals[ingred] then
            currentIngredientTotals[ingred] = 0
          end
          local qty = exports["np-inventory"]:getQuantity(item.itemName, true)
          currentIngredientTotals[ingred] = currentIngredientTotals[ingred] + qty
          if qty > 0 then
            currentIngredientCounts[ingred][item.itemName] = qty
          end
        end
      end
    end
    local enoughIngredients = true
    for ingred, count in pairs(ingredCounts) do
      if (currentIngredientTotals[ingred] and currentIngredientTotals[ingred] or 0) < count then
        TriggerEvent("DoLongHudText", "Not enough ingredients!", 2)
        enoughIngredients = false
      end
    end
    if not enoughIngredients then break end
    local success = exports["np-taskbar"]:taskBar(5000, "Preparing...", true, false, false, false, nil, 0.5, PlayerPedId())
    if success ~= 100 then break end
    local metaDatas = {}
    for ingred, items in pairs(currentIngredientCounts) do
      local processedCount = 0
      for itemName, count in pairs(items) do
        local itemData = exports["np-inventory"]:getItemsOfType(itemName, count, true)
        for _, item in pairs(itemData) do
          if processedCount < ingredCounts[ingred] then
            if item.amount >= (ingredCounts[ingred] - processedCount) then
              processedCount = ingredCounts[ingred]
              TriggerEvent("inventory:removeItemBySlot", itemName, processedCount, item.slot)
            else
              processedCount = processedCount + item.amount
              TriggerEvent("inventory:removeItemBySlot", itemName, item.amount, item.slot)
            end
            if not metaDatas[ingred] then
              metaDatas[ingred] = {}
            end
            local metadata = json.decode(item.information or "{}")
            metaDatas[ingred][#metaDatas[ingred] + 1] =
              (metadata and metadata) and metadata.foodEnhancement or foodItemEnhancements[itemName]
          end
        end
      end
    end
    local enhancementData = {
      types = {},
      restaurant = restaurant,
    }
    for k, v in pairs(metaDatas) do
      local percent = 0
      for _, p in pairs(v) do
        percent = percent + p
      end
      local calcPercent = (percent / #v) * (ingredCounts[k] / (GetBusinessConfig(restaurant).ingredients * 5))
      enhancementData.types[#(enhancementData.types) + 1] = {
        category = k,
        percent = tonumber(string.format("%.2f", calcPercent)),
      }
    end
    local metaInfo = {
      _foodEnhancements = enhancementData,
      _name = name,
      _description = description,
      _image_url = imageUrl,
      _food_id = foodId,
      _remove_id = math.random(1000000, 9999999),
      _hideKeys = {
        "_food_id",
        "_foodEnhancements",
        "_image_url",
        "_name",
        "_description",
        "_remove_id",
      },
    }
    TriggerEvent("player:receiveItem", foodTypeToItemMap[foodType], 1, false, metaInfo, metaInfo)
    Wait(500)
  end
  Wait(500)
  ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("np-restaurants:changedFoodItems", function(pRestaurant)
  resetFoodItems(pRestaurant)
end)

RegisterNetEvent("np-restaurants:changedMenuItems", function(pRestaurant)
  resetAvailableItems(pRestaurant)
end)
