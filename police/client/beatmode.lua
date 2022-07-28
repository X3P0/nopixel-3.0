local isInBeatMode = false
local isDebuffedFromBeating = false
local beatingDebuffTime = nil
local debuffThread = false

AddEventHandler("police:startPutInBeatMode", function()
  local ped = PlayerPedId()
  local tped, tply, tplyId = getClosestPlayer(GetEntityCoords(ped), 3.5)

  if tped == nil or tped <= 0 then
    return
  end

  local isCuffed = RPC.execute("isPedCuffed", tplyId)

  if not isCuffed then
    return
  end

  TriggerServerEvent("police:sendBeatMode", tplyId)
end)

RegisterNetEvent("police:recieveBeatMode")
AddEventHandler("police:recieveBeatMode", function()
  isInBeatMode = not isInBeatMode

  if isInBeatMode then
    startBeatMode()
  else
    TriggerEvent("np-police:cuffs:cuffed", GetPlayerServerId(PlayerId()))
  end
end)

function startBeatMode()
  local ped = PlayerPedId()
  local isMale = IsPedMale(ped)

  ClearPedTasks(PlayerPedId())

  animThread()
end

function startDebuffThread()
  if not debuffThread then
    CreateThread(function()
      debuffThread = true
      while isDebuffedFromBeating do
        if GetGameTimer() >= beatingDebuffTime then
          isDebuffedFromBeating = false
          debuffThread = false
        end
        Wait(1000)
      end
    end)
  end
end

function animThread()
  CreateThread(function()
    while isInBeatMode do
      if not IsEntityPlayingAnim(PlayerPedId(), "random@homelandsecurity", "knees_loop_girl", 1) then
        PerformAnimation("random@homelandsecurity", "knees_loop_girl", 1)
      end

      Wait(500)
    end
  end)
end

function PerformAnimation(dict, anim, flag)
  if not DoesAnimDictExist(dict) then
    print("INVALID DICT")
    return
  end

  while (not HasAnimDictLoaded(dict)) do
    RequestAnimDict(dict)
    Citizen.Wait(0)
  end

  TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, -1, flag, 0.0, 0, 0, 0)
  RemoveAnimDict(dict)
end

RPC.register("isPlyCuffed", function()
  local isCuffed = exports["isPed"]:isPed("handcuffed")
  return isCuffed
end)

function getClosestPlayer(coords, pDist)
  local closestPlyPed
  local closestPly
  local dist = -1

  for _, player in ipairs(GetActivePlayers()) do
    if player ~= PlayerId() then
      local ped = GetPlayerPed(player)
      local pedcoords = GetEntityCoords(ped)
      local newdist = #(coords - pedcoords)

      if (newdist <= pDist) then
        if (newdist < dist) or dist == -1 then
          dist = newdist
          closestPlyPed = ped
          closestPly = player
        end
      end
    end
  end

  return closestPlyPed, closestPly, GetPlayerServerId(closestPly)
end

AddEventHandler("police:startBeatdownDebuff", function()
  beatingDebuffTime = GetGameTimer() + 900000
  startDebuffThread()
end)

exports("getIsInBeatmode", function()
  return isInBeatMode
end)

exports("setIsInBeatmode", function(pBool)
  isInBeatMode = pBool
end)

exports("getBeatmodeDebuff", function()
  return isDebuffedFromBeating
end)

exports("setBeatmodeDebuff", function(pBool)
  isDebuffedFromBeating = pBool
end)
