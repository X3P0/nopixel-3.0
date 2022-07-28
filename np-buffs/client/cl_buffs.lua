-- STAMINA

local staminaBuffEnabled = false
local baseRechargeRate = 30000
local localRechargeRate = 30000
local restorationCount = 0

AddEventHandler("np-buffs:stamina", function(pEnabled, pPercent)
  local percent = pPercent or 1
  localRechargeRate = baseRechargeRate + (60000 * (1 - percent))
  if staminaBuffEnabled == pEnabled then return end
  staminaBuffEnabled = pEnabled
  restorationCount = 0
  Citizen.CreateThread(function()
    while staminaBuffEnabled do
      local plyId = PlayerId()
      local curStam = (100 - GetPlayerSprintStaminaRemaining(plyId))
      if curStam < 34 and restorationCount < 1 then
        restorationCount = restorationCount + 1
        RestorePlayerStamina(plyId, 1.0)
      end
      if restorationCount > 0 then
        Wait(localRechargeRate)
        restorationCount = 0
      end
      Wait(1000)
    end
  end)
end)

-- JOB LUCK
local jobLuckMultiplier = 1.0
AddEventHandler("np-buffs:setJobLuckMultiplier", function(pJobLuckMultiplier)
  jobLuckMultiplier = 1 + pJobLuckMultiplier + 0.0
  TriggerServerEvent("np-buffs:setBuffValue", "jobluck", jobLuckMultiplier)
end)
exports('getJobLuckMultiplier', function(pSource, pCeiling)
  return math.min(jobLuckMultiplier, pCeiling or 2.0)
end)
local baseLuckPercent = 0.25
exports('shouldIncreaseJobPayout', function(pCeiling)
  return (math.random() < baseLuckPercent) and (math.random() < (jobLuckMultiplier - 1))
end)

-- ALERTNESS
local alertLevelMultiplier = 1.0
AddEventHandler("np-buffs:setAlertLevelMultiplier", function(pAlertLevelMultiplier)
  alertLevelMultiplier = 1 + pAlertLevelMultiplier + 0.0
end)
exports('getAlertLevelMultiplier', function(pCeiling)
  return alertLevelMultiplier
end)

-- SITTING NEAR RESTAURANTS
local isSitting = false
local inRestaurantBuffZone = false
AddEventHandler("np-buffs:inDoubleBuffZone", function(pBool)
  inRestaurantBuffZone = pBool
end)
AddEventHandler("player:sittingOnChair", function(pSitting)
  if not inRestaurantBuffZone then return end
  if isSitting then return end
  isSitting = pSitting
  Citizen.CreateThread(function()
    local minuteCount = 0
    while isSitting and inRestaurantBuffZone do
      if minuteCount >= 5 then
        local percent = tonumber(string.format("%.2f", math.min(1.0, (minuteCount - 4) / 5)))
        TriggerEvent("np-buffs:applyBuff", "restaurant_double", {{ buff = "double", percent = percent }})
      end
      Citizen.Wait(60000)
      minuteCount = minuteCount + 1
    end
  end)
end)
