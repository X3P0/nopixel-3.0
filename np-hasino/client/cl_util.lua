local switchModels = {
  [`mp_m_freemode_01`] = true,
  [`mp_f_freemode_01`] = true,
}

local magnetMinigameResult = nil
local magnetMinigameUICallbackUrl = "np-ui:heistsMagnetMinigameResult"
RegisterUICallback(magnetMinigameUICallbackUrl, function(data, cb)
  magnetMinigameResult = data.success
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)
function MagnetCharge(loc, ptfx, rotplus, gameSettings)
  local p = promise:new()
  Citizen.CreateThread(function()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") do
      Citizen.Wait(0)
    end
    local ped = PlayerPedId()
    SetEntityHeading(ped, loc.h)
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz + rotplus, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), loc.x, loc.y, loc.z,  true,  true, false)
    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    local curVar = 0
    if switchModels[GetEntityModel(PlayerPedId())] then
      GetPedDrawableVariation(ped, 5)
      SetPedComponentVariation(ped, 5, 0, 0, 0)
    end
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    RequestModel(`np_prop_magnet_01`)
    while not HasModelLoaded(`np_prop_magnet_01`) do
      Wait(0)
    end
    local bomba = CreateObject(GetHashKey("np_prop_magnet_01"), x, y, z + 0.2,  true,  true, true)
    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(4000)
    DeleteObject(bag)
    if curVar > 0 and GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
      SetPedComponentVariation(ped, 5, curVar, 0, 0)
    end
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    NetworkStopSynchronisedScene(bagscene)

    gameSettings.gameTimeoutDuration = gameSettings.gameTimeoutDuration
    gameSettings.gameFinishedEndpoint = gameSettings.gameFinishedEndpoint and gameSettings.gameFinishedEndpoint or magnetMinigameUICallbackUrl
    exports["np-ui"]:openApplication("memorygame", gameSettings)

    magnetMinigameResult = nil
    while magnetMinigameResult == nil do
      Citizen.Wait(1000)
      -- thermiteMinigameResult = true
    end
    TriggerServerEvent("np-heists:hack:track", magnetMinigameResult, "thermite")
    -- if magnetMinigameResult then
    --   TriggerServerEvent("fx:ThermiteChargeEnt", NetworkGetNetworkIdFromEntity(bomba))
    --   TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    --   TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
    --   Citizen.Wait(2000)
    --   ClearPedTasks(ped)
    --   TriggerEvent('Evidence:StateSet', 16, 3600) -- apply thermite evidence in /status
    --   TriggerEvent("evidence:thermite")
    --   Citizen.Wait(2000)
    -- end
    -- if magnetMinigameResult then
    --   Citizen.Wait(9000)
    -- end
    Citizen.CreateThread(function()
      Citizen.Wait(45000)
      Sync.DeleteObject(bomba)
    end)
    p:resolve(magnetMinigameResult == true)
    magnetMinigameResult = nil
  end)
  return p
end
AddEventHandler("np-ui:application-closed", function(name)
  if name ~= "memorygame" then return end
  Citizen.CreateThread(function()
    Citizen.Wait(2500)
    if magnetMinigameResult == nil then
      magnetMinigameResult = false
    end
  end)
end)

-- taken from np-heists
function ChangeDoorHeading(doorEntity, endHeading, direction, duration)
  Citizen.CreateThread(function()
      duration = duration or 1000
      FreezeEntityPosition(doorEntity, true)
      local current = GetEntityHeading(doorEntity)
      if not current or not endHeading or math.abs(current - endHeading) < 1 then return end
      local diff = math.abs(current - endHeading)
      local speed = diff / duration
      SetEntityCollision(doorEntity, false, false)
      local curHeading = current
      while math.floor(curHeading) ~= math.floor(endHeading) do
          curHeading = curHeading + (direction * speed * GetFrameTime())
          if curHeading > 360 then
            curHeading = curHeading - 360
          end
          if curHeading < 0 then
            curHeading = curHeading + 360
          end
          SetEntityHeading(doorEntity, curHeading)
          Wait(0)
      end
      SetEntityHeading(doorEntity, endHeading)
      FreezeEntityPosition(doorEntity, true)
      Wait(0)
      SetEntityCollision(doorEntity, true, true)
  end)
end
