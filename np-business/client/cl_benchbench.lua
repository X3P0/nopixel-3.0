local modelToSupply = {
  [`prop_bench_01a`] = "metalforbench",
  [`prop_bench_01b`] = "metalforbench",
  [`prop_bench_01c`] = "metalforbench",
  [`prop_bench_02`] = "metalforbench",
  [`prop_bench_03`] = "metalforbench",
  [`prop_bench_04`] = "woodforbench",
  [`prop_bench_05`] = "woodforbench",
  [`prop_bench_06`] = "woodforbench",
  [`prop_bench_07`] = "woodforbench",
  [`prop_bench_08`] = "woodforbench",
  [`prop_bench_09`] = "stoneforbench",
  [`prop_bench_10`] = "stoneforbench",
  [`prop_bench_11`] = "stoneforbench",
}

AddEventHandler("np-business:bench:dismantle", function(p1, pEntity, p3)
  local hasEnough = exports["np-inventory"]:hasEnoughOfItem("heavydutydrill", 1, false, true)
  if not hasEnough then
    TriggerEvent("DoLongHudText", "You need a heavy duty drill!", 2)
    return
  end
  TaskTurnPedToFaceEntity(PlayerPedId(), pEntity, 2000)
  Wait(2000)
  TriggerEvent("animation:runtextanim", "drill")
  Wait(math.random(15000, 30000))
  ClearPedTasks(PlayerPedId())
  local model = GetEntityModel(pEntity)
  if not modelToSupply[model] then return end
  TriggerEvent("player:receiveItem", modelToSupply[model], 1)
  SetEntityCoords(pEntity, -2406.44, -2237.14, -60.79)
end)
