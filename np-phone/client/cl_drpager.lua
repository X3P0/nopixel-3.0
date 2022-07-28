local lastTime = 0
RegisterNetEvent('phone:triggerPager')
AddEventHandler('phone:triggerPager', function(hospital, force)
  local job = exports["isPed"]:isPed("myjob")
  if job == "doctor" then
    local currentTime = GetGameTimer()
    if lastTime == 0 or lastTime + (5 * 60 * 1000) < currentTime or force then
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'pager', 0.4)
      exports["np-ui"]:openApplication("drpager", {hospital = hospital}, false)
      lastTime = currentTime
    end
  end
end)
