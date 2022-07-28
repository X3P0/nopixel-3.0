local drugEffectTime = 0

-- Sugar effects
RegisterNetEvent('hadsugar')
AddEventHandler('hadsugar', function()
  if drugEffectTime > 0 then return end
  SetRunSprintMultiplierForPlayer(PlayerId(), 1.05)
  SetSwimMultiplierForPlayer(pId, 1.05)
  drugEffectTime = 20
  
  local ped = PlayerPedId()
  local pId = PlayerId()
  local loops = 0

  while drugEffectTime > 0 do
    loops = loops + 1
    if loops > 10 then
      SetRunSprintMultiplierForPlayer(pId, 1.025)
      SetSwimMultiplierForPlayer(pId, 1.025)
    end
    Citizen.Wait(1000)
    RestorePlayerStamina(pId, 1.0)
    drugEffectTime = drugEffectTime - 1
    if IsPedRagdoll(ped) then
      SetPedToRagdoll(ped, math.random(5), math.random(5), 3, 0, 0, 0)
    end
  end
  drugEffectTime = 0
  SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
  SetSwimMultiplierForPlayer(pId, 1.0)
end)

-- Cocaine Effects
RegisterNetEvent('hadcocaine')
AddEventHandler('hadcocaine', function()
  if drugEffectTime > 0 then return end
  drugEffectTime = 60

  TriggerEvent("client:newStress", false, math.random(150, 1000))
  
  local ped = PlayerPedId()
  local pId = PlayerId()
  local loops = 0

  SetRunSprintMultiplierForPlayer(pId, 1.25)
  SetSwimMultiplierForPlayer(pId, 1.15)

  while drugEffectTime > 0 do
    if loops > 10 then
      SetRunSprintMultiplierForPlayer(pId, 1.15)
      SetSwimMultiplierForPlayer(pId, 1.1)
    end
    loops = loops + 1
    Citizen.Wait(1000)
    RestorePlayerStamina(pId, 1.0)
    drugEffectTime = drugEffectTime - 1
    if IsPedRagdoll(ped) then
      SetPedToRagdoll(ped, math.random(5), math.random(5), 3, 0, 0, 0)
    end
    -- if loops < 20 then
    --   SetPedArmour(ped, math.floor(GetPedArmour(ped) + 2))
    -- end
  end
  drugEffectTime = 0
  SetRunSprintMultiplierForPlayer(pId, 1.0)
  SetSwimMultiplierForPlayer(pId, 1.0)
end)

RegisterNetEvent('hadmeth')
AddEventHandler('hadmeth', function(quality)
  -- TriggerEvent("addiction:drugTaken", "meth")
  if drugEffectTime > 0 then return end
  drugEffectTime = 0
  -- TriggerEvent("fx:run", "cocaine", 8, 0.0, false, false)
  local addictionFactor = 0.0
  local drugEffectApplyArmorMulti = 0.0
  local drugEffectQualityMulti = 1.0
  local sprintEffectFactor = 1.0
  local drugEffectQuality = quality and quality or 20
  if drugEffectQuality > 25 and drugEffectQuality <= 50 then
    drugEffectQualityMulti = 2.0
    sprintEffectFactor = 1.05
  elseif drugEffectQuality > 50 and drugEffectQuality <= 62.5 then
    drugEffectQualityMulti = 3.0
    sprintEffectFactor = 1.1
    drugEffectApplyArmorMulti = 1.0
  elseif drugEffectQuality > 62.5 and drugEffectQuality <= 75 then
    drugEffectQualityMulti = 6.0
    sprintEffectFactor = 1.15
    drugEffectApplyArmorMulti = 1.0
  elseif drugEffectQuality > 75 and drugEffectQuality <= 90 then
    drugEffectQualityMulti = 12.0
    drugEffectApplyArmorMulti = 1.0
    sprintEffectFactor = 1.15
  elseif drugEffectQuality > 90 and drugEffectQuality <= 99 then
    drugEffectQualityMulti = 18.0
    drugEffectApplyArmorMulti = 2.0
    sprintEffectFactor = 1.16
  elseif drugEffectQuality > 99 then
    drugEffectQualityMulti = 30.0
    drugEffectApplyArmorMulti = 3.0
    sprintEffectFactor = 1.175
  end
  -- sets the sprint multipler based on the addictionfactor... if your addiction is higher then 5.0, you start slowing down. max sprint speep is 1.25
  -- local sprintfactor = map_range(addictionFactor, 0.0, 5.0, sprintEffectFactor, 1.00)
  -- if sprintfactor < 1.0 then
  --   sprintfactor = 1.0
  -- end
  -- SetRunSprintMultiplierForPlayer(PlayerId(), sprintEffectFactor)
  -- SetSwimMultiplierForPlayer(PlayerId(), sprintEffectFactor)
  drugEffectTime = drugEffectQualityMulti * 6
  if quality and quality < 40 then
    TriggerEvent("DoLongHudText", "This is some poor quality shit", 2)
  end
  TriggerEvent("client:newStress", false, math.random(150, 1000))
  local loops = 0
  while drugEffectTime > 0 do
    loops = loops + 1
    if loops > 20 then
      -- SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
      -- SetSwimMultiplierForPlayer(PlayerId(), 1.0)
    end
    if loops < 20 then
      -- SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
      -- SetSwimMultiplierForPlayer(PlayerId(), 1.0)
      -- RestorePlayerStamina(PlayerId(), 1.0)
    end
    Citizen.Wait(1000)
    drugEffectTime = drugEffectTime - 1
    if IsPedRagdoll(PlayerPedId()) then
      SetPedToRagdoll(PlayerPedId(), math.random(5), math.random(5), 3, 0, 0, 0)
    end
    if drugEffectApplyArmorMulti > 0 then
      local armor = GetPedArmour(PlayerPedId())
      exports['ragdoll']:SetPlayerArmor(math.floor(armor + drugEffectApplyArmorMulti))
    end
  end
  drugEffectTime = 0
  -- SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
  -- SetSwimMultiplierForPlayer(PlayerId(), 1.0)
  exports["carandplayerhud"]:revertToStress()
end)

RegisterNetEvent('hadnitrous')
AddEventHandler('hadnitrous', function()
  if drugEffectTime > 0 then return end
  drugEffectTime = 0

  TriggerEvent("fx:run", "cocaine", 8, 0.0, false, false)

  SetRunSprintMultiplierForPlayer(PlayerId(), 1.01)

  drugEffectTime = 200

  -- TriggerEvent("client:newStress", false, math.random(250))

  while drugEffectTime > 0 do
    Citizen.Wait(1000)
    drugEffectTime = drugEffectTime - 1

    if IsPedRagdoll(PlayerPedId()) then
      SetPedToRagdoll(PlayerPedId(), math.random(5), math.random(5), 3, 0, 0, 0)
    end
  end

  drugEffectTime = 0

  if IsPedRunning(PlayerPedId()) then
    SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
  end

  SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
  exports["carandplayerhud"]:revertToStress()
end)

-- Adrenaline (Swat) Effects
local adrenActive = false
RegisterNetEvent('inventory:adrenaline')
AddEventHandler('inventory:adrenaline', function()
  if adrenActive then return end
  adrenActive = true
  local ped = PlayerId()

  -- local armor = GetPedArmour(PlayerPedId())
  -- SetPedArmour(PlayerPedId(), math.floor(armor + 25.0))
  -- drugEffectTime = 18000

  SetRunSprintMultiplierForPlayer(ped, 1.25)
  SetSwimMultiplierForPlayer(ped, 1.25)
  exports['ragdoll']:SetPlayerArmor(60)

  Citizen.CreateThread(function()
    local innerLC = 0
    while innerLC < 6 do
      innerLC = innerLC + 1
      exports['ragdoll']:SetPlayerArmor(60)
      Wait(1000)
    end
  end)

  Wait(6000)

  SetRunSprintMultiplierForPlayer(ped, 1.0)
  SetSwimMultiplierForPlayer(ped, 1.0)

  local loopCount = 0
  while loopCount < 10 do
    loopCount = loopCount + 1
    exports['ragdoll']:SetPlayerArmor(math.max(0, math.floor(GetPedArmour(PlayerPedId()) - 1)))
    Wait(500)
  end

  -- add this here so they can tell its "over"
  exports['ragdoll']:SetPlayerArmor(10)

  adrenActive = false

  -- while drugEffectTime > 0 do
  --   Citizen.Wait(0)
  --   if math.random(300) == 69 then
  --     local armor = GetPedArmour(PlayerPedId())
  --     exports['ragdoll']:SetPlayerArmor(math.floor(armor + 5))
  --   end
  --   RestorePlayerStamina(ped, 1.0)
  --   drugEffectTime = drugEffectTime - 1
  -- end
  -- drugEffectTime = 0
end)

-- Special K (prison drug)
local ketaActive = false
RegisterNetEvent('inventory:ketamine')
AddEventHandler('inventory:ketamine', function(pPurity)
  if ketaActive then return end
  ketaActive = true
  local ped = PlayerId()

  local lastTaken = getLastTaken("ketamine")
  if not lastTaken then lastTaken = 0 end
  if GetCloudTimeAsInt() - lastTaken < 10 * 60 then return end
  TriggerEvent("addiction:drugTaken", "ketamine")

  TriggerEvent("fx:run", "cocaine", 10, 0.0, false, false)

  local armor = GetPedArmour(PlayerPedId())

  if not pPurity then pPurity = 20 end

  local armorFactor = map_range(pPurity, 0.0, 100.0, 1.1, 5.0)

  exports['ragdoll']:SetPlayerArmor(math.floor(armor + (armorFactor * 10.0)))

  local drugRunning = true

  Citizen.SetTimeout(3 * 60 * 1000, function()
    drugRunning = false
  end)

  TriggerEvent("healed:useOxy", false)
  TriggerServerEvent("np-drugeffects:forceStress", 1, 3 * 60 * 1000)

  local purityRng = (200 - math.floor(pPurity)) * 2
  while drugRunning do
    Citizen.Wait(0)
    if math.random(purityRng) == 69 then
      -- fast armor regen
      local armor = GetPedArmour(PlayerPedId())
      exports['ragdoll']:SetPlayerArmor(math.floor(armor + armorFactor))
      local health = GetEntityHealth(PlayerPedId())
      exports['ragdoll']:SetPlayerHealth(math.floor(health + armorFactor))
    end
  end
  ketaActive = false
  TriggerEvent("fx:run", "cocaine", 10, 0.0, false, false)
  TriggerServerEvent("np-drugeffects:forceStress", 5000, 10 * 60 * 1000)
end)

-- Heroin
local heroActive = false
RegisterNetEvent('inventory:heroin')
AddEventHandler('inventory:heroin', function(pPurity)
  if heroActive then return end
  heroActive = true
  local ped = PlayerId()
  if not pPurity then pPurity = 0.5 end
  local length = 30 + 30 * (pPurity / 100)

  local lastTaken = getLastTaken("heroin")
  if not lastTaken then lastTaken = 0 end
  if GetCloudTimeAsInt() - lastTaken < 10 * 60 then return end
  TriggerEvent("addiction:drugTaken", "heroin")

  TriggerEvent("fx:run", "heroin", length, -1, false, false)

  local armor = GetPedArmour(PlayerPedId())


  local armorFactor = map_range(pPurity, 0.0, 100.0, 1.1, 5.0)

  exports['ragdoll']:SetPlayerArmor(math.floor(armor + (armorFactor * 10.0)))

  local drugRunning = true

  Citizen.SetTimeout(length, function()
    drugRunning = false
  end)

  TriggerEvent("healed:useOxy", false)
  TriggerServerEvent("np-drugeffects:forceStress", 1, length)

  local purityRng = (200 - math.floor(pPurity)) * 2
  while drugRunning do
    Citizen.Wait(0)
    if math.random(purityRng) == 69 then
      -- fast armor regen
      local armor = GetPedArmour(PlayerPedId())
      exports['ragdoll']:SetPlayerArmor(math.floor(armor + armorFactor))
      local health = GetEntityHealth(PlayerPedId())
      exports['ragdoll']:SetPlayerHealth(math.floor(health + armorFactor))
    end
  end
  heroActive = false
  TriggerServerEvent("np-drugeffects:forceStress", 5000, 10 * 60 * 1000)
end)

-- Crack Effects
RegisterNetEvent('hadcrack')
AddEventHandler('hadcrack', function()
  if drugEffectTime > 0 then return end
  drugEffectTime = 40

  TriggerEvent("client:newStress", true, 1300)
  TriggerEvent("healed:useOxy", false, true)
  
  local ped = PlayerPedId()
  local pId = PlayerId()
  local loops = 0

  SetRunSprintMultiplierForPlayer(pId, 1.2)
  SetSwimMultiplierForPlayer(pId, 1.15)

  while drugEffectTime > 0 do
    if loops > 10 then
      SetRunSprintMultiplierForPlayer(pId, 1.1)
      SetSwimMultiplierForPlayer(pId, 1.1)
    end
    loops = loops + 1
    Citizen.Wait(1000)
    RestorePlayerStamina(pId, 1.0)
    drugEffectTime = drugEffectTime - 1
    if IsPedRagdoll(ped) then
      SetPedToRagdoll(ped, math.random(5), math.random(5), 3, 0, 0, 0)
    end
  end
  TriggerEvent("healed:useOxy", false, true)
  drugEffectTime = 0
  SetRunSprintMultiplierForPlayer(pId, 1.0)
  SetSwimMultiplierForPlayer(pId, 1.0)
end)

RegisterNetEvent("weed")
AddEventHandler("weed", function(alteredValue, scenario, multiply)
  local timeout = 500
  if not multiply then multiply = 1.0 end

  if scenario ~= nil then
    
    while not IsPedUsingScenario(PlayerPedId(), scenario) do
      Wait(0)
  
      timeout = timeout - 1
  
      if timeout == 0 then
        print("WEED ANIMATION TIMED OUT")
        return
      end
    end

  end
  

  TriggerEvent("addiction:drugTaken", "weed")
  local removedStress = 0

  TriggerEvent("DoShortHudText", 'Stress is being relieved', 6)

  exports['ragdoll']:SetMaxArmor()

  local addictionFactor = getFactor("weed")

  -- Addiction will scale the amount of armor you get over time between 0 and 3 dependiong on how addicted you are
  local armorchange = map_range(addictionFactor, 0.0, 5.0, 3.0, 0.0)

  if armorchange < 0 then
    armorchange = 0
  end

  while removedStress <= alteredValue do
    removedStress = removedStress + 100

    local armor = GetPedArmour(PlayerPedId())
    exports['ragdoll']:SetPlayerArmor(math.ceil(armor + (multiply * armorchange)))

    if scenario ~= "None" then
      if not IsPedUsingScenario(PlayerPedId(), scenario) then
        TriggerEvent("animation:cancel")
        break
      end
    end

    Citizen.Wait(1000)
  end

  TriggerServerEvent("server:alterStress", false, removedStress)
end)

function map_range(s, a1, a2, b1, b2)
  return b1 + (s - a1) * (b2 - b1) / (a2 - a1)
end
