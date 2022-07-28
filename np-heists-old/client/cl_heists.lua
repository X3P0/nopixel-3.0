local nightVisionActive = false
local nightVisionActivePD = false
local lostCompound = vector3(55.65,3693.47,44.11)
local distanceToDisable = 500
local prevPropIdx = 0
local prevPropTextureIdx = 0
local isPowerOn = true
local supportedModels = {
  [`mp_f_freemode_01`] = 124,
  [`mp_m_freemode_01`] = 126,
}
local nvgItems = {
  ["nightvisiongoggles"] = true,
  ["nightvisiongogglespd"] = true,
}
local thermalItems = {
  ["thermalgoggles"] = true,
}

local myJob = "unemployed"
RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job)
  myJob = job
end)

local timecycleEnabled = false
local function isNightTime()
  local isNight = exports["np-weathersync"]:isNightTime()
  return isNight
end
RegisterNetEvent("sv-heists:cityPowerState", function(pIsPowerOn)
  isPowerOn = pIsPowerOn
  if isPowerOn then return end
--   if (#(GetEntityCoords(PlayerPedId()) - lostCompound) < distanceToDisable) then
--     if myJob ~= "police" and isNightTime() then
--       SetTimecycleModifier("BlackOut")
--       SetTimecycleModifierStrength(1.0)
--       timecycleEnabled = true
--     end
--   end
end)
-- Citizen.CreateThread(function()
--   while true do
--     if (#(GetEntityCoords(PlayerPedId()) - lostCompound) < distanceToDisable) then
--       if myJob ~= "police" and (not isPowerOn) and isNightTime() then
--         SetTimecycleModifier("BlackOut")
--         SetTimecycleModifierStrength(1.0)
--         timecycleEnabled = true
--       end
--     elseif timecycleEnabled then
--       ClearTimecycleModifier()
--       timecycleEnabled = false
--     end
--     Citizen.Wait(30000)
--   end
-- end)

AddEventHandler("np-inventory:itemUsed", function(item)
  if not nvgItems[item] then return end
  local sm = supportedModels[GetEntityModel(PlayerPedId())]
  if sm then
    TriggerEvent("animation:PlayAnimation", "hairtie")
    Wait(1000)
  end
  nightVisionActive = not nightVisionActive
  nightVisionActivePD = nightVisionActive and (item == "nightvisiongogglespd") or false
  if nightVisionActive
     and (not nightVisionActivePD)
     and (#(lostCompound - GetEntityCoords(PlayerPedId())) < distanceToDisable)
  then
    nightVisionActive = false
    TriggerEvent("DoLongHudText", "Signal interference.", 2)
    return
  end
  SetNightvision(nightVisionActive)
  if not sm then return end
  if nightVisionActive then
    prevPropIdx = GetPedPropIndex(PlayerPedId(), 0)
    prevPropTextureIdx = GetPedPropTextureIndex(PlayerPedId(), 0)
    SetPedPropIndex(PlayerPedId(), 0, sm, 0, true)
  else
    ClearPedProp(PlayerPedId(), 0)
    SetPedPropIndex(PlayerPedId(), 0, prevPropIdx, prevPropTextureIdx, true)
  end
end)

local lastThermalTime = 0
AddEventHandler("np-inventory:itemUsed", function(item, passedItemInfo, inventoryName, slot)
  if not thermalItems[item] then return end
  local sm = supportedModels[GetEntityModel(PlayerPedId())]
  if sm then
    TriggerEvent("animation:PlayAnimation", "hairtie")
    Wait(1000)
  end
  local meta = json.decode(passedItemInfo)
  local currentBattery = meta.battery or 300
  thermalVisionActive = not thermalVisionActive
  if thermalVisionActive then
    lastThermalTime = GetGameTimer()
    SetPedHeatscaleOverride(PlayerPedId(), 0)
    SetSeethrough(true)
    SeethroughSetMaxThickness(1.0)
    SeethroughSetFadeStartDistance(100.0)
    SeethroughSetFadeEndDistance(150.0)
    Citizen.CreateThread(function()
      while thermalVisionActive do
        Wait(0)
        local timer = GetGameTimer() - lastThermalTime
        if timer > (currentBattery * 1000) then
          thermalVisionActive = false
          break
        end
      end
      local totalTime = GetGameTimer() - lastThermalTime
      meta.battery = math.floor(math.max(0, currentBattery - (totalTime / 1000)) * 10) / 10
      TriggerEvent('inventory:updateItem', item, slot, json.encode(meta))
      DisablePedHeatscaleOverride(PlayerPedId())
      SetSeethrough(false)
    end)
  end
  if not sm then return end
  if thermalVisionActive then
    prevPropIdx = GetPedPropIndex(PlayerPedId(), 0)
    prevPropTextureIdx = GetPedPropTextureIndex(PlayerPedId(), 0)
    SetPedPropIndex(PlayerPedId(), 0, sm, 0, true)
  else
    ClearPedProp(PlayerPedId(), 0)
    SetPedPropIndex(PlayerPedId(), 0, prevPropIdx, prevPropTextureIdx, true)
  end
end)

local thermalsActive = false
function toggleThermalMode()
  if not nightVisionActivePD then return end
  if thermalsActive then
    DisablePedHeatscaleOverride(PlayerPedId())
    SetSeethrough(false)
    thermalsActive = false
  else
    SetPedHeatscaleOverride(PlayerPedId(), 0)
    SetSeethrough(true)
    SeethroughSetMaxThickness(1.0)
    SeethroughSetFadeStartDistance(100.0)
    SeethroughSetFadeEndDistance(150.0)
    thermalsActive = true
  end
end

Citizen.CreateThread(function()
  exports["np-keybinds"]:registerKeyMapping("", "Player", "Toggle Thermals", "+toggleThermalMode", "-toggleThermalMode", "END")
  RegisterCommand('+toggleThermalMode', function() toggleThermalMode() end, false)
	RegisterCommand('-toggleThermalMode', function() end, false)
end)

--

local grappleGunHash = -1654528753
local grappleGunTintIndex = 2
local grappleGunSuppressor = `COMPONENT_AT_AR_SUPP_02`
local grappleGunEquipped = false
local shownGrappleButton = false
local grappleGunItems = {
  ["grapplegun"] = true,
  ["grapplegunpd"] = true,
}
CAN_GRAPPLE_HERE = true
AddEventHandler("np-inventory:itemUsed", function(item)
  if not grappleGunItems[item] then return end
  if item == "grapplegun" and myJob == "police" then return end
  grappleGunEquipped = not grappleGunEquipped
  if grappleGunEquipped then
    GiveWeaponToPed(PlayerPedId(), grappleGunHash, 0, 0, 1)
    GiveWeaponComponentToPed(PlayerPedId(), grappleGunHash, grappleGunSuppressor)
    SetPedWeaponTintIndex(PlayerPedId(), grappleGunHash, item ~= "grapplegun" and 5 or 2)
    SetPedAmmo(PlayerPedId(), grappleGunHash, 0)
    SetAmmoInClip(PlayerPedId(), grappleGunHash, 0)
  else
    RemoveWeaponFromPed(PlayerPedId(), grappleGunHash)
  end
  local ply = PlayerId()
  Citizen.CreateThread(function()
    while grappleGunEquipped do
      Wait(500)
      local veh = GetVehiclePedIsIn(PlayerPedId(), false)
      if (veh and veh ~= 0) or GetSelectedPedWeapon(PlayerPedId()) ~= grappleGunHash then
        grappleGunEquipped = false
        RemoveWeaponFromPed(PlayerPedId(), grappleGunHash)
      end
    end
  end)
  Citizen.CreateThread(function ()
    while grappleGunEquipped do
      local freeAiming = IsPlayerFreeAiming(ply)
      local hit, pos, _, _ = GrappleCurrentAimPoint(40)
      if not shownGrappleButton and freeAiming and hit == 1 and CAN_GRAPPLE_HERE then
        shownGrappleButton = true
        exports["np-ui"]:showInteraction("[E] Grapple!")
      elseif shownGrappleButton and ((not freeAiming) or hit ~= 1 or (not CAN_GRAPPLE_HERE)) then
        shownGrappleButton = false
        exports["np-ui"]:hideInteraction("[E] Grapple!")
      end
      Wait(250)
    end
  end)
  Citizen.CreateThread(function()
    while grappleGunEquipped do
      local freeAiming = IsPlayerFreeAiming(ply)
      if IsControlJustReleased(0, 51) and freeAiming and grappleGunEquipped and CAN_GRAPPLE_HERE then
        local hit, pos, _, _ = GrappleCurrentAimPoint(40)
        if hit == 1 then
          grappleGunEquipped = false
          -- local area = {
          --   radius = 10.0,
          --   target = GetEntityCoords(PlayerPedId()),
          --   type = 1,
          -- }
          -- local event = {
          --   server = false,
          --   inEvent = "InteractSound_CL:PlayOnOne",
          --   outEvent = "InteractSound_CL:StopLooped",
          -- }
          -- TriggerServerEvent("infinity:playSound", event, area, "grapple-shot", 0.75)
          -- Citizen.Wait(1000)
          local grapple = Grapple.new(pos)
          grapple.activate()
          Citizen.Wait(1000)
          RemoveWeaponFromPed(PlayerPedId(), grappleGunHash)
          TriggerEvent("inventory:DegenLastUsedItem", 25)
          shownGrappleButton = false
          exports["np-ui"]:hideInteraction("[E] Grapple!")
        end
      end
      Citizen.Wait(0)
    end
  end)
end)

--
AddEventHandler("np-inventory:itemUsed", function(item)
  if item ~= "casinoblueprintscase" then return end
  local hasItem1 = exports["np-inventory"]:hasEnoughOfItem("casinocaseaccesshalf", 1, false, true)
  local hasItem2 = exports["np-inventory"]:hasEnoughOfItem("casinocaseaccesshalfsecond", 1, false, true)
  if (not hasItem1) or (not hasItem2) then
    TriggerEvent("DoLongHudText", "Missing codes.", 2)
    return
  end
  TriggerEvent("inventory:removeItem", "casinoblueprintscase", 1)
  Wait(500)
  TriggerEvent("inventory:removeItem", "casinocaseaccesshalf", 1)
  Wait(500)
  TriggerEvent("inventory:removeItem", "casinocaseaccesshalfsecond", 1)
  Wait(500)
  TriggerEvent("player:receiveItem", "casinoblueprints", 1)
end)

--
local wingsuiting = false
local usedSuperBoost = false
local superBoostActive = false
AddEventHandler("np-inventory:itemUsed", function(pItem)
  if pItem ~= "wingsuit" then return end
  if wingsuiting then return end
  local playerPed = PlayerPedId()
  local veh = GetVehiclePedIsIn(playerPed, false)
  if veh ~= 0 then return end
  if GetEntityHeightAboveGround(playerPed) < 3 then return end
  wingsuiting = true
  usedSuperBoost = false
  Citizen.CreateThread(function()
    TriggerEvent("inventory:removeItem", pItem, 1)
    Wait(200)
    TriggerEvent("np-props:attachProp", "np_wingsuit_open", 24817, 0.1, -0.15, 0.0, 0.0, 90.0, 0.0, true, true, "np_wingsuit_open")
  end)
  Citizen.CreateThread(function()
    SetPlayerParachuteModelOverride(PlayerId(), `p_parachute1_mp_s`)
    SetPedParachuteTintIndex(playerPed, 6)
    GiveWeaponToPed(playerPed, -72657034, 1, 0, 1)
    TriggerEvent("hud:equipParachute")
  end)
  Citizen.CreateThread(function()
    while not IsPedInParachuteFreeFall(playerPed) do
      Wait(0)
    end
    while (GetEntityHeightAboveGround(playerPed) > 1) and (GetPedParachuteState(PlayerPedId()) < 1) do
      Wait(500)
    end
    TriggerEvent("np-props:removePropByName", "np_wingsuit_open")
    wingsuiting = false
  end)
  Citizen.CreateThread(function()
    while not IsPedInParachuteFreeFall(playerPed) do
      Wait(0)
    end
    while (GetEntityHeightAboveGround(playerPed) > 1) and (GetPedParachuteState(PlayerPedId()) < 1) do
      if IsControlPressed(0, 8) and (not superBoostActive) then
        ApplyForceToEntity(playerPed, 1, 0.0, 30.0, 2.5, 0.0, 0.0, 0.0, 0, true, false, false, false, true)
      elseif IsControlPressed(0, 32) and (not superBoostActive) then
        ApplyForceToEntity(playerPed, 1, 0.0, 80.0, 75.0, 0.0, 0.0, -75.0, 0, true, false, false, false, true)
      end
      if IsControlPressed(0, 22) and (not usedSuperBoost) then
        usedSuperBoost = true
        Citizen.CreateThread(function()
          superBoostActive = true
          while superBoostActive do
            ApplyForceToEntity(playerPed, 1, 0.0, 200.0, 400.0, 0.0, 0.0, -300.0, 0, true, false, false, false, true)
            Wait(0)
          end
        end)
        Citizen.CreateThread(function()
          Wait(1500)
          superBoostActive = false
        end)
      end
      Wait(0)
    end
  end)
end)

AddEventHandler("np-inventory:itemUsed", function(pItem)
  if pItem ~= "wingsuitb" then return end
  if wingsuiting then return end
  local playerPed = PlayerPedId()
  local veh = GetVehiclePedIsIn(playerPed, false)
  if veh ~= 0 then return end
  if GetEntityHeightAboveGround(playerPed) < 3 then return end
  wingsuiting = true
  usedSuperBoost = false
  Citizen.CreateThread(function()
    TriggerEvent("inventory:removeItem", pItem, 1)
    Wait(200)
    TriggerEvent("np-props:attachProp", "np_wingsuit_b_open", 24817, 0.1, -0.15, 0.0, 0.0, 90.0, 0.0, true, true, "np_wingsuit_b_open")
  end)
  Citizen.CreateThread(function()
    SetPlayerParachuteModelOverride(PlayerId(), `p_parachute1_mp_s`)
    SetPedParachuteTintIndex(playerPed, 6)
    GiveWeaponToPed(playerPed, -72657034, 1, 0, 1)
    TriggerEvent("hud:equipParachute")
  end)
  Citizen.CreateThread(function()
    while not IsPedInParachuteFreeFall(playerPed) do
      Wait(0)
    end
    while (GetEntityHeightAboveGround(playerPed) > 1) and (GetPedParachuteState(PlayerPedId()) < 1) do
      Wait(500)
    end
    TriggerEvent("np-props:removePropByName", "np_wingsuit_b_open")
    wingsuiting = false
  end)
  Citizen.CreateThread(function()
    while not IsPedInParachuteFreeFall(playerPed) do
      Wait(0)
    end
    while (GetEntityHeightAboveGround(playerPed) > 1) and (GetPedParachuteState(PlayerPedId()) < 1) do
      if IsControlPressed(0, 8) and (not superBoostActive) then
        ApplyForceToEntity(playerPed, 1, 0.0, 30.0, 2.5, 0.0, 0.0, 0.0, 0, true, false, false, false, true)
      elseif IsControlPressed(0, 32) and (not superBoostActive) then
        ApplyForceToEntity(playerPed, 1, 0.0, 80.0, 75.0, 0.0, 0.0, -75.0, 0, true, false, false, false, true)
      end
      if IsControlPressed(0, 22) and (not usedSuperBoost) then
        usedSuperBoost = true
        Citizen.CreateThread(function()
          superBoostActive = true
          while superBoostActive do
            ApplyForceToEntity(playerPed, 1, 0.0, 200.0, 400.0, 0.0, 0.0, -300.0, 0, true, false, false, false, true)
            Wait(0)
          end
        end)
        Citizen.CreateThread(function()
          Wait(1500)
          superBoostActive = false
        end)
      end
      Wait(0)
    end
  end)
end)

AddEventHandler("np-inventory:itemUsed", function(pItem, pInfo)
  if pItem ~= "wingsuitc" then return end
  if wingsuiting then return end
  if not pInfo then return end
  local info = json.decode(pInfo)
  local cid = exports["isPed"]:isPed("cid")
  if info.cid ~= cid then return end
  local playerPed = PlayerPedId()
  local veh = GetVehiclePedIsIn(playerPed, false)
  if veh ~= 0 then return end
  if GetEntityHeightAboveGround(playerPed) < 3 then return end
  wingsuiting = true
  usedSuperBoost = false
  Citizen.CreateThread(function()
    Wait(200)
    TriggerEvent("np-props:attachProp", "np_wingsuit_b_open", 24817, 0.1, -0.15, 0.0, 0.0, 90.0, 0.0, true, true, "np_wingsuit_b_open")
  end)
  Citizen.CreateThread(function()
    SetPlayerParachuteModelOverride(PlayerId(), `p_parachute1_mp_s`)
    SetPedParachuteTintIndex(playerPed, 6)
    GiveWeaponToPed(playerPed, -72657034, 1, 0, 1)
    TriggerEvent("hud:equipParachute")
  end)
  Citizen.CreateThread(function()
    while not IsPedInParachuteFreeFall(playerPed) do
      Wait(0)
    end
    while (GetEntityHeightAboveGround(playerPed) > 1) and (GetPedParachuteState(PlayerPedId()) < 1) do
      Wait(500)
    end
    TriggerEvent("np-props:removePropByName", "np_wingsuit_b_open")
    wingsuiting = false
  end)
  Citizen.CreateThread(function()
    while not IsPedInParachuteFreeFall(playerPed) do
      Wait(0)
    end
    while (GetEntityHeightAboveGround(playerPed) > 1) and (GetPedParachuteState(PlayerPedId()) < 1) do
      if IsControlPressed(0, 8) and (not superBoostActive) then
        ApplyForceToEntity(playerPed, 1, 0.0, 30.0, 2.5, 0.0, 0.0, 0.0, 0, true, false, false, false, true)
      elseif IsControlPressed(0, 32) and (not superBoostActive) then
        ApplyForceToEntity(playerPed, 1, 0.0, 80.0, 75.0, 0.0, 0.0, -75.0, 0, true, false, false, false, true)
      end
      if IsControlPressed(0, 22) and (not usedSuperBoost) then
        usedSuperBoost = true
        Citizen.CreateThread(function()
          superBoostActive = true
          while superBoostActive do
            ApplyForceToEntity(playerPed, 1, 0.0, 200.0, 400.0, 0.0, 0.0, -300.0, 0, true, false, false, false, true)
            Wait(0)
          end
        end)
        Citizen.CreateThread(function()
          Wait(1500)
          superBoostActive = false
          Wait(10000)
          usedSuperBoost = false
        end)
      end
      Wait(0)
    end
  end)
end)

local isDead = false
AddEventHandler("pd:deathcheck", function()
  isDead = not isDead
  if not isDead then return end
  wingsuiting = false
  usedSuperBoost = false
  TriggerEvent("np-props:removePropByName", "np_wingsuit_open")
  TriggerEvent("np-props:removePropByName", "np_wingsuit_b_open")
end)
