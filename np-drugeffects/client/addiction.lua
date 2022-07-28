-- Each drug has an addiction factor. The more you take in a specified time period, the higher the factor goes.
-- The factor can affect many things like how long certain effects last to possibly having negative effects at higher factors.
local addiction = {
  ["oxy"] = {factor = 0.0, lastTaken = nil},
  ["crack"] = {factor = 0.0, lastTaken = nil},
  ["cocaine"] = {factor = 0.0, lastTaken = nil},
  ["weed"] = {factor = 0.0, lastTaken = nil},
  ["ketamine"] = {factor = 0.0, lastTaken = nil},
  ["heroin"] = {factor= 0.0, lastTaken = nil},
}

RegisterNetEvent("addiction:drugTaken")
AddEventHandler("addiction:drugTaken", function(drug)
  drugTaken(drug)
end)

function drugTaken(drug)
  if not getLastTaken(drug) then
    setLastTaken(drug)
    TriggerServerEvent("addiction:updateFactor", GetPlayerServerId(PlayerId()), addiction)
    return
  end

  local lastTakenBefore = getLastTaken(drug)
  setLastTaken(drug)
  local lastTakenAfter = getLastTaken(drug)

  local timediff = lastTakenAfter - lastTakenBefore

  if timediff <= 30 then
    addToFactor(drug, 1.0)
  elseif timediff <= 60 then
    addToFactor(drug, 0.8)
  elseif timediff <= 120 then
    addToFactor(drug, 0.6)
  elseif timediff <= 300 then
    addToFactor(drug, 0.4)
  elseif timediff <= 600 then
    addToFactor(drug, 0.2)
  elseif timediff <= 1800 then
    addToFactor(drug, 0.1)
  end

  TriggerServerEvent("addiction:updateFactor", GetPlayerServerId(PlayerId()), addiction)
end

function addToFactor(drug, amount)
  if not addiction[drug].factor then
    return
  end

  local verbage = ""
  local factor = addiction[drug].factor
  if factor < 2.0 then
    verbage = " slightly"
  end
  if factor > 4.0 then
    verbage = " heavily"
  end

  TriggerEvent("DoLongHudText", "You are" .. verbage .. " addicted to " .. drug)

  addiction[drug].factor = addiction[drug].factor + amount
end

function removeFromFactor(drug, amount)
  if (addiction[drug].factor - amount) <= 0.0 then
    addiction[drug].factor = 0.0
  else
    addiction[drug].factor = addiction[drug].factor - amount
  end
end

function getFactor(drug)
  return addiction[drug].factor
end

function setLastTaken(drug)
  addiction[drug].lastTaken = GetCloudTimeAsInt()
end

function getLastTaken(drug)
  return addiction[drug].lastTaken
end

-- Thread that removes addiction over time
Citizen.CreateThread(function()
  while true do
    for k, v in pairs(addiction) do
      if getFactor(k) and getFactor(k) ~= 0.0 and getFactor(k) > 0.0 then
        removeFromFactor(k, 0.1)
      end
    end
    Wait(60000)
  end
end)

exports('getOwnAddictionFactor', getFactor)
