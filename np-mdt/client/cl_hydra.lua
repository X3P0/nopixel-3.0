AddEventHandler("baseevents:enteredVehicle", function()
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  if GetEntityModel(veh) ~= `hydra` then return end
  DisableVehicleWeapon(true, -494786007, veh, PlayerPedId()) -- guns
  DisableVehicleWeapon(true, -123497569, veh, PlayerPedId()) -- missiles
  -- SetCurrentPedVehicleWeapon(PlayerPedId(), -123497569) -- missiles
end)

AddEventHandler("np-inventory:itemUsed", function(pItem)
  if pItem ~= "ci_missile_launcher" then return end
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  DisableVehicleWeapon(false, -123497569, veh, PlayerPedId()) -- missiles
  SetCurrentPedVehicleWeapon(PlayerPedId(), -123497569)
  local canShoot = true
  while canShoot do
    DisableControlAction(0, 114, true)
    local locked, target = GetVehicleLockOnTarget(veh)
    if locked then
      if IsControlJustPressed(0, 114) or IsDisabledControlJustPressed(0, 114) then
        if exports["np-inventory"]:hasEnoughOfItem(pItem, 1, false, true) then
          SetVehicleShootAtTarget(PlayerPedId(), target, GetEntityCoords(target))
          canShoot = false
          TriggerEvent("inventory:removeItem", pItem)
        end
      end
    end
    Wait(0)
  end
  DisableVehicleWeapon(true, -123497569, veh, PlayerPedId()) -- missiles
end, false)
