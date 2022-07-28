AddEventHandler("np-inventory:itemUsed", function(pItem)
  if pItem ~= "goldpantray" then return end
  -- local dict, anim = "amb@world_human_yoga@male@base", "base_a"
  local finished = exports["np-ui"]:taskBarSkill(3000, math.random(15, 20))
  if finished ~= 100 then return end
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  if veh ~= 0 then return end
  if not IsEntityInWater(PlayerPedId()) then return end
  if IsPedSwimming(PlayerPedId()) or IsPedSwimmingUnderWater(PlayerPedId()) then return end
  local dict, anim = 'amb@world_human_bum_wash@male@high@idle_a', 'idle_a'
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
    Wait(0)
  end
  TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, -1.0, -1, 1, false, false, false)
  -- TaskPlayAnimAdvanced(
  --   PlayerPedId(),
  --   dict,
  --   anim,
  --   GetEntityCoords(PlayerPedId()),
  --   0.0,
  --   0.0,
  --   0.0,
  --   1.0,
  --   1.0,
  --   10000,
  --   1,
  --   0.8
  -- )
  Wait(800)
  TriggerEvent('attachItem', 'goldpantray')
  Wait(7000)
  ClearPedTasks(PlayerPedId())
  TriggerEvent('destroyProp')
  TriggerServerEvent("np-goldpanning:getLoot", GetEntityCoords(PlayerPedId()))
end)
