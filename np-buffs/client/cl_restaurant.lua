-- local testJson = json.decode([[{"_restaurant_code":"bs","_image_url":"https://i.imgur.com/q6WCfU2.png","_description":"Test moneyshot","_name":"Moneyshot","_key":1,"_remove_id":1}]])

local curJob = "none"
RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job)
  curJob = job
end)

local ingredientToBuffMap = {
  ["oil"] = function(percent)
    local removeStressAmount = math.floor(5000 * percent)
    -- print(removeStressAmount)
    TriggerEvent("client:newStress", false, removeStressAmount)
  end,
  ["protein"] = "strength",
  ["vegetables"] = "stamina",
  ["leavening"] = "int",
  ["dairy"] = "stressgain",
  ["grain"] = "fullness",
  ["seasoning"] = "jobluck",
  ["sugar"] = "alert",
}

local function processInfo(info)
  return info
end

local function configureBuffs(info)
  local buffs = {}
  -- print(json.encode(info, { indent = true }))
  if not info or not info._foodEnhancements then return buffs end

  for _, buffData in pairs(info._foodEnhancements.types) do
    local buffName = ingredientToBuffMap[buffData.category]
    if type(buffName) == "function" then
      buffName(buffData.percent)
    else
      buffs[#buffs + 1] = {
        buff = buffName,
        percent = buffData.percent,
      }
    end
  end
  return buffs
end

local buffConfig = {
  ["resfooditem"] = {
    attachItem = "sandwich",
    onUse = function(info)
      if info._foodEnhancements.restaurant == "maldinis" then
        TriggerEvent("changehunger", 75)
      else
        TriggerEvent("changehunger", 50)
      end
      return processInfo(info)
    end,
    remove = true,
    restaurantBaseBuff = {
      ["burger_shot"] = function(info)
        TriggerEvent("client:newStress", false, 10000)
        TriggerEvent("np-buffs:applyBuff", "burger_shot", { { buff = "stressblock", percent = 1.0, timeOverride = 180 * 60000 } })
        TriggerEvent("hadsugar")
        return processInfo(info)
      end,
      ["rooster"] = function(info)
        TriggerEvent("np-buffs:applyBuff", "rooster", { { buff = "jobluck", percent = 1.0 } })
        return processInfo(info)
      end,
      ["uwu_cafe"] = function(info)
        TriggerEvent("np-buffs:applyBuff", "uwu_cafe", { { buff = "strength", percent = 0.5, timeOverride = 60000 * 60 } })
        return processInfo(info)
      end,
      ["maldinis"] = function(info)
        TriggerEvent("np-buffs:applyBuff", "maldinis", { { buff = "fullness", percent = 1.0 } })
        return processInfo(info)
      end,
    },
  },
  ["ressideitem"] = {
    attachItem = "fries",
    onUse = function(info)
      TriggerEvent("changehunger", 30)
      TriggerEvent("healed:minors")
      return processInfo(info)
    end,
    remove = true,
  },
  ["resdessertitem"] = {
    attachItem = "donut",
    onUse = function(info)
      TriggerEvent("changehunger", 20)
      TriggerEvent("hadsugar")
      return processInfo(info)
    end,
    remove = true,
  },
  ["resdrinkitem"] = {
    attachItem = "water",
    onUse = function(info)
      TriggerEvent("changethirst", 50)
      return processInfo(info)
    end,
    remove = true,
  },
  ["resalcoholitem"] = {
    attachItem = "beer",
    onUse = function(info)
      return processInfo(info)
    end,
    remove = true,
  },
  ["sandwich"] = {
    attachItem = "sandwich",
    onUse = function(info)
      local config = exports["np-config"]:GetModuleConfig("misc")

      if config["sandwich.restore.hunger"] then
        TriggerEvent("changehunger", 15)
      end

      return processInfo(info)
    end,
    remove = true,
  }
}

local itemUseSuccess = nil
AddEventHandler("np-buffs:itemUsedSuccess", function(pSuccess)
  itemUseSuccess = pSuccess
end)
AddEventHandler("np-inventory:itemUsed", function(pItem, pInfo)
  local config = buffConfig[pItem]
  if not config then return end
  itemUseSuccess = nil
  TriggerEvent("np-inventory:attachPropPlayAnim", config.attachItem)
  while itemUseSuccess == nil do
    Wait(1000)
  end
  if not itemUseSuccess then return end
  local info = json.decode(pInfo)
  if config.onUse then
    info = config.onUse(info)
  end
  if config.restaurantBaseBuff
    and info._foodEnhancements
    and config.restaurantBaseBuff[info._foodEnhancements["restaurant"]]
  then
    info = config.restaurantBaseBuff[info._foodEnhancements["restaurant"]](info)
  end
  local buffs = configureBuffs(info)
  TriggerEvent("np-buffs:applyBuff", pItem, buffs)
  if config.remove then
    TriggerEvent("inventory:removeItemByMetaKV", pItem, 1, "_remove_id", info._remove_id)
  end
end)
-- TriggerEvent("player:receiveItem", ingredientsMap[result.item_type].craft, qty, false, {
--   _hideKeys = { "_image_url", "_name", "_description", "_remove_id" },
--   _image_url = result.image,
--   _name = result.name,
--   _description = result.description,
--   _remove_id = math.random(10000000, 999999999),
-- })
