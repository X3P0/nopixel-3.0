---------------------------------- VAR ----------------------------------
isCop = false
curJob = nil

local jobs = {
  {name="Unemployed", id="unemployed"},
  {name="Tow Truck Driver", id="towtruck"},  
  {name="Taxi Driver", id="taxi"},
  {name="Delivery Job", id="trucker"},
  {name="News Reporter", id = "news"},
  {name="Food Truck", id = "foodtruck"},
}

---------------------------------- CITIZEN ----------------------------------

RegisterNetEvent('jobssystem:getJob')
AddEventHandler('jobssystem:getJob', function(cb)
  cb(curJob)
end)

RegisterNetEvent('jobssystem:updateJob')
AddEventHandler('jobssystem:updateJob', function(nameJob)
  if nameJob ~= curJob then
    TriggerEvent('clearJobBlips')
  end

  local id = PlayerId()

  curJob = nameJob

  if nameJob == "unemployed" then
    TriggerEvent('nowUnemployed')
  end

  if nameJob == "news" then
    TriggerEvent("DoLongHudText", "Press H to pull item news items.")
  end
end)

RegisterNetEvent('jobssystem:current')
AddEventHandler('jobssystem:current', function(cb)
  LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
  cb(LocalPlayer:getVar("job"))
end)
