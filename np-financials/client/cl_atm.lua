-- ATMS
local atmModels = {
    -1126237515, 506770882, -870868698, 150237004, -239124254, -1364697528
}

function isNearATM()
  for i = 1, #atmModels do
    local objFound = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 0.75, atmModels[i], 0, 0, 0)
    if DoesEntityExist(objFound) then
      TaskTurnPedToFaceEntity(PlayerPedId(), objFound, 3.0)
      return true
    end
  end
  return false
end

function financialAnimation(pIsATM, pIsOpening)
  local playerId = PlayerPedId()
  if pIsATM then
    loadAnimDict("amb@prop_human_atm@male@enter")
    loadAnimDict("amb@prop_human_atm@male@exit")
    loadAnimDict("amb@prop_human_atm@male@idle_a")
    if pIsOpening then
      TaskPlayAnim(playerId, "amb@prop_human_atm@male@idle_a", "idle_b", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
      local finished = exports["np-taskbar"]:taskBar(3000, "Inserting card")
      ClearPedSecondaryTask(playerId)
    else
      ClearPedTasks(playerId)
      TaskPlayAnim(playerId, "amb@prop_human_atm@male@exit", "exit", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
      local finished = exports["np-taskbar"]:taskBar(1000, "Retrieving Card")
      ClearPedTasks(playerId)
    end
  else
    loadAnimDict("mp_common")
    if pIsOpening then
      ClearPedTasks()
      TaskPlayAnim(playerId, "mp_common", "givetake1_a", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
      local finished = exports["np-taskbar"]:taskBar(1000, "Showing bank documentation")
      ClearPedTasks(playerId)
    else
      TaskPlayAnim(playerId, "mp_common", "givetake1_a", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
      local finished = exports["np-taskbar"]:taskBar(1000, "Collecting documentation")
      Citizen.Wait(1000)
      ClearPedTasks(playerId)
    end
  end
end