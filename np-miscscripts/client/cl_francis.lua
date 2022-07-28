local obj = nil

function ToggleBush()
  local ped = PlayerPedId()

  if obj == nil then
    obj = CreateObject(GetHashKey("prop_bush_med_03"), GetEntityCoords(ped), true, true, false)

    SetEntityCollision(obj, false, false)

    AttachEntityToEntity(obj, ped, 23553, 0.0, 0.0, -0.90, 0.0, 0.0, 0.0, 0, 1, 0, 1, 0, 1)
    return
  end

  DeleteEntity(obj)
  ClearPedTasksImmediately(PlayerPedId())
  DetachEntity(PlayerPedId(), true, true)
  obj = nil
end

AddEventHandler("np-inventory:itemUsed", function(item)
  if item ~= "francis_bush" then return end
  ToggleBush()
end)

AddEventHandler('onResourceStop', function (resource)
  if (resource ~= GetCurrentResourceName()) then return end
  
  DeleteEntity(obj)
  ClearPedTasksImmediately(PlayerPedId())
  DetachEntity(PlayerPedId(), true, true)
end)
