local kettleTime = 30000

AddEventHandler("np-business:kettle", function(data)
  local src = source
  local hasWater = exports["np-inventory"]:hasEnoughOfItem("water", 1, false, true);
  if not hasWater then
    TriggerEvent("DoLongHudText", "You need some water for the kettle")
    return
  end

  RequestModel(`prop_mug_02`)
  while not HasModelLoaded(`prop_mug_02`) do
    Wait(10)
  end

  local coords = data.position

  local cup = CreateObject(`prop_mug_02`, coords.x, coords.y, coords.z, true, true, false)
  SetEntityHeading(cup, 0.0 + coords.w)
  
  TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
  Wait(1000)
  TriggerEvent("doAnim", "cokecut")

  local finished = exports["np-taskbar"]:taskBar(kettleTime, "Brewing a cuppa")
  
  ClearPedTasks(PlayerPedId())
  DeleteEntity(cup)

  if finished ~= 100 then
    return
  end

  TriggerEvent("inventory:removeItem", "water", 1)
  TriggerEvent("player:receiveItem", "mugoftea", 1)
end)


local isDrinking = false
AddEventHandler("np-inventory:itemUsed", function(item, info)
  if item ~= "mugoftea" then return end
  if isDrinking then return end

  isDrinking = true

  local animDict = "amb@world_human_drinking@coffee@male@idle_a"

  while not HasAnimDictLoaded(animDict) do
    RequestAnimDict(animDict)
    Citizen.Wait(0)
  end

  TriggerEvent("inventory:removeItem", "mugoftea", 1)

  TriggerEvent("attachItem", "mug")

  Citizen.CreateThread(function()
    while isDrinking do
      if not IsEntityPlayingAnim(PlayerPedId(), animDict, "idle_c", 3) then
        TaskPlayAnim(PlayerPedId(), animDict, "idle_c", 1.0, 0.1, -1, 49, 0, 0, 0, 0)
        Wait(100)
      end
      if IsControlJustReleased(0, 38) then
        TaskPlayAnim(PlayerPedId(), animDict, "idle_b", 1.0, 0.1, -1, 50, 0, 0, 0, 0)
        TriggerEvent("addThirst", 5)
        Wait(5500)
      end
      Wait(0)
    end
    TriggerEvent("destroyProp")
    ClearPedSecondaryTask(PlayerPedId())
  end)
end)

AddEventHandler("turnoffsitting", function()
  isDrinking = false
end)
