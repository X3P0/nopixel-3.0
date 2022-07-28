local ped = nil
local isDead = false

-- RegisterCommand("spawnped", function()
--   ped = CreatePed(4, `mp_m_freemode_01`, vector4(-1104.39, -3081.89, 13.95, 247.22), 1, 1)
--   GiveWeaponToPed(ped, 727643628, 9999, 0, 1)
--   SetCurrentPedWeapon(ped, 727643628, 1)
-- end, false)

-- RegisterCommand("shootme", function()
--   TaskShootAtEntity(ped, PlayerPedId(), 5000, `FIRING_PATTERN_FULL_AUTO`)
-- end)

local minorAnim = "cpr_pumpchest_idle"
local minorDict = "mini@cpr@char_b@cpr_def"
local tranqed = false
function loadAnimDict(dict)
  RequestAnimDict(dict)
  while(not HasAnimDictLoaded(dict)) do
      Citizen.Wait(0)
  end
end
AddEventHandler("DamageEvents:EntityDamaged", function(victim, attacker, pWeapon, isMelee)
  local playerPed = PlayerPedId()
  if victim ~= playerPed then return end
  if pWeapon ~= 727643628 then return end
  if tranqed then return end
  tranqed = true
  SetPedToRagdoll(playerPed, 1000, 10000, 0, false, false, false)
  TriggerEvent("np-voice:setTransmissionDisabled", { 
    ["phone"] = true,
    ["proximity"] = true,
    ["radio"] = true,
  })
  Wait(500)
  DoScreenFadeOut(500)
  Wait(500)
  Citizen.CreateThread(function()
    local waitTime = 500
    local loopCount = 0
    loadAnimDict(minorDict)
    while loopCount < 600 do
      loopCount = loopCount + 1
      if not IsEntityPlayingAnim(playerPed, minorDict, minorAnim, 3) then
        ClearPedTasksImmediately(playerPed)
        TaskPlayAnim(playerPed, minorDict, minorAnim, 8.0, -8, -1, 1, 0, 0, 0, 0)
      end
      Wait(waitTime)
    end
    exports["np-ui"]:hideInteraction("Tranquilized", "error")
    tranqed = false
    StopScreenEffect("DrugsMichaelAliensFight")
    ClearPedTasks(playerPed)
    TriggerEvent("np-voice:setTransmissionDisabled", {
      ["phone"] = false,
      ["proximity"] = false,
      ["radio"] = isDead,
    })
  end)
  Citizen.CreateThread(function()
    Citizen.Wait(5000)
    exports["np-ui"]:showInteraction("Tranquilized", "error")
    DoScreenFadeIn(5000)
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
  end)
end)

RegisterNetEvent('pd:deathcheck', function ()
  isDead = not isDead
  TriggerEvent("np-voice:setTransmissionDisabled", {
    ["radio"] = isDead,
  })
end)
