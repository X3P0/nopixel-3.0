local lasers = {}
local LasersEnabled = true

Citizen.CreateThread(function()
  local firstLaserOrigin = { vector3(1008.599, 30.317, 54.281), vector3(1011.508, 28.511, 54.281), vector3(1014.212, 26.831, 54.281) }
  local firstLaserTarget = { vector3(1010.52, 33.271, 54.281), vector3(1013.369, 31.529, 54.281), vector3(1016.059, 29.825, 54.281) }
  local options = { travelTimeBetweenTargets = { 2.0, 2.0 }, waitTimeAtTargets = { 0.1, 0.1 }, name = 'elevator' }
  lasers[#lasers + 1] = { Laser.new(firstLaserOrigin, firstLaserTarget, options), 100 }
  lasers[#lasers + 1] = { Laser.new(firstLaserOrigin, firstLaserTarget, options), 100 }
  lasers[#lasers + 1] = { Laser.new(firstLaserOrigin, firstLaserTarget, options), 100 }
  lasers[#lasers + 1] = { Laser.new(firstLaserOrigin, firstLaserTarget, options), 100 }
  lasers[#lasers + 1] = { Laser.new(firstLaserOrigin, firstLaserTarget, options), 100 }
  lasers[#lasers + 1] = { Laser.new(firstLaserOrigin, firstLaserTarget, options), 100 }

  local secondLaserOrigin = {
    vector3(1008.613, 30.369, 30.257),
    vector3(1009.92, 29.558, 30.24),
    vector3(1011.487, 28.524, 30.254),
    vector3(1013.114, 27.574, 30.249),
    vector3(1014.284, 26.848, 30.25),
  }
  local secondLaserTarget = {
    vector3(1013.347, 31.546, 30.435),
    vector3(1010.252, 33.476, 30.432),
    vector3(1016.148, 29.775, 30.435),
    vector3(1011.638, 32.591, 30.434),
    vector3(1014.676, 30.731, 30.435),
  }
  local secondOptions = { travelTimeBetweenTargets = { 1.5, 2.0 }, waitTimeAtTargets = { 0.0, 0.0 }, name = 'elevator2' }

  lasers[#lasers + 1] = { Laser.new(secondLaserOrigin, secondLaserTarget, secondOptions), 500 }
  lasers[#lasers + 1] = { Laser.new(secondLaserOrigin, secondLaserTarget, secondOptions), 500 }
  lasers[#lasers + 1] = { Laser.new(secondLaserOrigin, secondLaserTarget, secondOptions), 500 }

  local thirdLaserOrigin = {
    vector3(1008.448, 30.508, 6.272),
    vector3(1013.357, 27.362, 6.272),
    vector3(1011.235, 28.68, 6.272),
    vector3(1009.871, 29.528, 6.272),
    vector3(1013.12, 27.51, 6.272),
    vector3(1010.495, 29.14, 6.272),
    vector3(1012.008, 28.277, 6.272),
    vector3(1011.611, 28.523, 6.272),
    vector3(1011.84, 28.381, 6.272),
  }
  local thirsLaserTarget = {
    vector3(1010.436, 33.419, 6.272),
    vector3(1013.359, 31.62, 6.272),
    vector3(1012.918, 31.865, 6.272),
    vector3(1012.144, 32.349, 6.272),
    vector3(1011.169, 32.902, 6.272),
    vector3(1011.66, 32.584, 6.272),
    vector3(1012.515, 32.09, 6.272),
    vector3(1016.005, 29.613, 6.272),
    vector3(1013.387, 31.587, 6.272),
  }
  local thirdOptions = { travelTimeBetweenTargets = { 0.0, 0.0 }, waitTimeAtTargets = { 2.5, 2.5 }, name = 'elevator3' }

  lasers[#lasers + 1] = { Laser.new(thirdLaserOrigin, thirsLaserTarget, thirdOptions), 2500 }
  lasers[#lasers + 1] = { Laser.new(thirdLaserOrigin, thirsLaserTarget, thirdOptions), 2500 }
  lasers[#lasers + 1] = { Laser.new(thirdLaserOrigin, thirsLaserTarget, thirdOptions), 2500 }

  lasers[#lasers + 1] = {
    Laser.new(vector3(1011.414, 28.569, 22.263), { vector3(1013.357, 31.565, 22.432) },
              { travelTimeBetweenTargets = { 1.0, 1.0 }, waitTimeAtTargets = { 0.0, 0.0 }, name = 'elevator4_2' }),
    0,
  }
  lasers[#lasers + 1] = {
    Laser.new(vector3(1008.455, 30.518, 22.254), { vector3(1015.315, 28.263, 22.266) },
              { travelTimeBetweenTargets = { 1.0, 1.0 }, waitTimeAtTargets = { 0.0, 0.0 }, name = 'elevator4_3' }),
    0,
  }

  lasers[#lasers + 1] = {
    Laser.new(vector3(1013.682, 27.221, 22.246), { vector3(1009.422, 32.23, 22.235) },
              { travelTimeBetweenTargets = { 1.0, 1.0 }, waitTimeAtTargets = { 0.0, 0.0 }, name = 'elevator4' }),
    0,
  }
end)

AddEventHandler('np-polyzone:enter', function(pZone, pData)
  if pZone ~= 'hasino_elevator_shaft' then return end
  enableLasers()
  -- Fixes casino sounds playing in vault area
  TriggerEvent("np-casino:elevatorExitCasino")
end)

AddEventHandler('np-polyzone:exit', function(pZone, pData)
  if pZone ~= 'hasino_elevator_shaft' then return end
  disableLasers()
end)

function enableLasers(pSetState)
  if pSetState then
    LasersEnabled = true
  end
  if not LasersEnabled then
    return
  end
  for _,laser in ipairs(lasers) do
    Wait(laser[2])
    laser[1].setActive(true)
  end
end

function disableLasers(pSetState)
  if pSetState then
    LasersEnabled = false
  end
  for _,laser in ipairs(lasers) do
    Wait(laser[2])
    laser[1].setActive(false)
  end
end
