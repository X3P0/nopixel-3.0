local function hasScale()
  return exports['np-inventory']:hasEnoughOfItem('qualityscales', 1, false) or
    exports['np-inventory']:hasEnoughOfItem('smallscales', 1, false)
end

local function rollJoints(pItem, pAmount, pItemInfo)
  local itemInfo = {
    _hideKeys = {'quality', '_remove_id'},
    _remove_id = math.random(1000, 99999999),
    quality = pItemInfo.quality,
    strain = pItemInfo.strain
  }
  TriggerEvent('inventory:removeItem', 'rollingpaper', pAmount)
  TriggerEvent('inventory:removeItemByMetaKV', pItem, 1, 'strain', pItemInfo.strain)
  TriggerEvent('player:receiveItem', 'joint2', pAmount, false, itemInfo)
end

local rollAnimDict = 'anim@amb@business@weed@weed_sorting_seated@'
local rollAnim = 'sorter_left_sort_v2_sorter01'

local gramsPerJoint = 2

AddEventHandler('np-inventory:itemUsed', function(item, passedItemInfo, inventoryName, slot)
  if item == 'driedbud' then
    local parsedInfo = json.decode(passedItemInfo)
    local finished = exports['np-taskbar']:taskBar(5000, _L('weed-pack-bud', 'Packing'), false, true, false, false, nil, 5.0, PlayerPedId())
    if finished == 100 and exports['np-inventory']:hasEnoughOfItem(item, 1, false, true, { quality = parsedInfo.quality }) then
      TriggerEvent('inventory:removeItemByMetaKV', item, 1, 'quality', parsedInfo.quality)
      local budData = {
        strain = parsedInfo.strain,
        quality = parsedInfo.quality,
        grower = parsedInfo.grower,
        id = parsedInfo.id,
        _hideKeys = { 'quality', 'grower', 'id' },
      }
      TriggerEvent('player:receiveItem', 'smallbud', WeedConfig.BudPerDried, false, budData)
    end
  end

  if item == 'weedpackage' then
    TriggerEvent('np-weed:prepareBaggies', {}, PlayerPedId())
    -- local parsedInfo = json.decode(passedItemInfo)
    -- local budData = {
    --     strain = getStrainNameFromQuality(parsedInfo.quality),
    --     quality = parsedInfo.quality,
    --     _hideKeys = {"quality"}
    -- }
    -- TriggerEvent("player:receiveItem", "smallbud", 10, false, budData)
    -- TriggerEvent("inventory:removeItemByMetaKV", item, 1, "quality", parsedInfo.quality)
  end

  if item == 'smallbud' then
    if not hasScale() then
      TriggerEvent('DoLongHudText', _L('weed-roll-scale', 'You need a scale to pack joints'), 2)
      return
    end

    local amount = math.floor(20 / gramsPerJoint * WeedConfig.JointLossRate)
    local hasPaper = exports['np-inventory']:hasEnoughOfItem('rollingpaper', amount, false)
    if not hasPaper then
      TriggerEvent('DoLongHudText', _L('weed-roll-paper', 'Not enough papers'), 2)
      return
    end

    loadAnimDict(rollAnimDict)
    TaskPlayAnim(PlayerPedId(), rollAnimDict, rollAnim, 8.0, 1.0, -1, 17, 0, 0, 0, 0)
    local finished = exports['np-taskbar']:taskBar(15000, _L('weed-roll-bud', 'Packing Joints'), false, true, false, false, nil, 5.0, PlayerPedId())
    ClearPedTasks(PlayerPedId())
    if finished == 100 and exports['np-inventory']:hasEnoughOfItem(item, 1, false, true) then
      rollJoints(item, amount, json.decode(passedItemInfo))
    end
  end

  if item == 'weedbaggie' then
    local amount = math.floor(8 / gramsPerJoint * WeedConfig.JointLossRate)
    local hasPaper = exports['np-inventory']:hasEnoughOfItem('rollingpaper', amount, false)
    if not hasPaper then
      TriggerEvent('DoLongHudText', _L('weed-roll-paper', 'Not enough papers'), 2)
      return
    end
    loadAnimDict(rollAnimDict)
    TaskPlayAnim(PlayerPedId(), rollAnimDict, rollAnim, 8.0, 1.0, -1, 17, 0, 0, 0, 0)
    local finished = exports['np-taskbar']:taskBar(5000, _L('weed-roll-joint', 'Rolling Joints'), false, true, false, false, nil, 5.0, PlayerPedId())
    ClearPedTasks(PlayerPedId())
    if finished == 100 and exports['np-inventory']:hasEnoughOfItem(item, 1, false, true) then
      rollJoints(item, amount, json.decode(passedItemInfo))
    end
  end
end)
