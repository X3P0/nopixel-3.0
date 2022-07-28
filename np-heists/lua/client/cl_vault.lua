local LaserList = {}

Citizen.CreateThread(function()
  local staticLasers = {
    { vector3(253.469, 221.149, 96.49), vector3(254.601, 224.315, 96.49), 5.0 },
    { vector3(253.467, 221.15, 97.073), vector3(254.601, 224.315, 97.073), 5.0 },
    { vector3(253.467, 221.15, 97.619), vector3(254.58, 224.323, 97.619), 5.0 },
    { vector3(253.477, 221.146, 98.148), vector3(254.574, 224.325, 98.148), 5.0 },
    { vector3(261.582, 216.625, 96.741), vector3(258.413, 217.737, 96.741), 19.0 },
    { vector3(261.58, 216.62, 97.723), vector3(258.413, 217.738, 97.723), 19.0 },
    { vector3(261.579, 216.617, 98.593), vector3(258.412, 217.735, 98.593), 19.0 },
    { vector3(258.311, 217.817, 96.752), vector3(260.418, 223.656, 96.752), 6.5 },
    { vector3(258.317, 217.811, 97.727), vector3(260.429, 223.652, 97.727), 6.5 },
    { vector3(258.311, 217.809, 98.583), vector3(260.443, 223.647, 98.583), 6.5 },
    { vector3(239.339, 226.292, 96.49), vector3(240.472, 229.458, 96.49), 5.0 },
    { vector3(239.331, 226.294, 97.073), vector3(240.471, 229.458, 97.073), 5.0 },
    { vector3(239.329, 226.295, 97.619), vector3(240.471, 229.458, 97.619), 5.0 },
    { vector3(239.327, 226.296, 98.148), vector3(240.473, 229.457, 98.148), 5.0 },
  }

  local frontDoorway = Laser.new({ vector3(262.776, 217.762, 96.819), vector3(262.749, 217.771, 98.389) },
                                 { vector3(263.899, 220.931, 96.819), vector3(263.896, 220.932, 98.389) },
                                 { travelTimeBetweenTargets = { 1.0, 1.0 }, waitTimeAtTargets = { 2.0, 3.0 }, name = "frontDoorway" })

  local frontRightMoving = Laser.new({ vector3(260.596, 223.737, 96.7), vector3(260.595, 223.734, 98.64) },
                                     { vector3(263.662, 222.611, 96.7), vector3(263.662, 222.61, 98.64) }, {
    travelTimeBetweenTargets = { 1.0, 1.0 },
    waitTimeAtTargets = { 2.0, 3.0 },
    name = "frontRightMoving",
  })

  local rightMiddleMoving = Laser.new({ vector3(260.7, 228.687, 96.716), vector3(260.688, 228.691, 98.679) },
                                      { vector3(259.629, 225.75, 96.716), vector3(259.632, 225.749, 98.679) }, {
    travelTimeBetweenTargets = { 1.0, 1.0 },
    waitTimeAtTargets = { 2.0, 3.0 },
    name = "rightMiddleMoving",
  })

  local rightBackMoving = Laser.new(
      {vector3(242.669, 223.47, 96.693), vector3(242.672, 223.479, 98.593)},
      {vector3(239.62, 224.638, 96.681), vector3(239.622, 224.644, 98.606)},
      {travelTimeBetweenTargets = {2.0, 3.0}, waitTimeAtTargets = {0.0, 0.0}, name = "leftbackmoving"}
    )

  LaserList = { frontDoorway, frontRightMoving, rightMiddleMoving, rightBackMoving }

  for _, coords in ipairs(staticLasers) do
    LaserList[#LaserList + 1] = Laser.new(coords[1], { coords[2] }, {
      travelTimeBetweenTargets = { 0.0, 0.0 },
      waitTimeAtTargets = { 2.5, 2.5 },
      maxDistance = coords[3],
      extensionEnabled = false,
      name = "static",
    })
  end

  for _, laser in ipairs(LaserList) do
    laser.onPlayerHit(function(playerBeingHit, hitPos)
      if playerBeingHit then
        TriggerEvent("np-heists:vault:laserHit", laser, hitPos)
      end
    end)
  end
end)

RegisterNetEvent("np-heists:vault:laserState", function(pState)
  for _, laser in ipairs(LaserList) do
    laser.setActive(pState)
  end
end)

