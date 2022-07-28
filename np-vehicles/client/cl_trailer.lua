local models = {
  [`tropic`] = { y = -0.75, z = 0.75 },
  [`suntrap`] = { y = -0.5, z = 0.35 },
}
local trailer = nil
AddEventHandler("vehicle:primeTrailerForMounting", function(params, pEntity)
  trailer = pEntity
end)

AddEventHandler("vehicle:mountBoatOnTrailer", function()
  if not trailer then
    TriggerEvent("DoLongHudText", "No trailer prepared.", 2)
    return
  end
  local ped = PlayerPedId()
  local boat = GetVehiclePedIsIn(ped)
  if #(GetEntityCoords(boat) - GetEntityCoords(trailer)) > 10.0 then
    TriggerEvent("DoLongHudText", "Trailer too far away", 2)
    return
  end
  local finished = exports["np-taskbar"]:taskBar(10000, "Mounting...")
  if finished ~= 100 then return end
  local boatCoords = GetEntityCoords(boat)
  local boatRot = GetEntityRotation(trailer)
  local trailerCoords = GetEntityCoords(trailer)
  SetEntityCollision(boat, false, false)
  SetEntityCoords(boat, trailerCoords.x, trailerCoords.y, trailerCoords.z + 0.005, 1, 0, 0, 1)
  SetEntityHeading(boat, GetEntityHeading(trailer))
  FreezeEntityPosition(boat, true, false)
  local boatModel = GetEntityModel(boat)
  local y = models[boatModel] and models[boatModel].y or 0.0
  local z = models[boatModel] and models[boatModel].z or 0.0
  AttachEntityToEntity(boat, trailer, 20, 0.0, y, z, 0.0, 0.0, 0.0, false, true, true, false, 20, true)
  FreezeEntityPosition(boat, false, false)
  trailer = nil
end)

Citizen.CreateThread(function()
  RegisterCommand("+detachBoat", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    if veh == 0 then
      return false
    end
    local seat = GetPedInVehicleSeat(veh, -1)
    if seat ~= ped then
      return false
    end
    local model = GetEntityModel(veh)
    if not (IsThisModelABoat(model) or IsThisModelAJetski(model) or IsThisModelAnAmphibiousCar(model)) then
      return false
    end
    DetachEntity(veh, false, true)
  end, false)
  RegisterCommand("-detachBoat", function() end, false)
  exports["np-keybinds"]:registerKeyMapping("", "Vehicle", "Detach Boat", "+detachBoat", "-detachBoat")
end)
