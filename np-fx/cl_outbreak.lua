local ActivePortals = {}

RegisterNetEvent("np-fx:drawPortal", function(pId, pCoords)
    if ActivePortals[pId] then return end

    ActivePortals[pId] = true

    local coords = vector3(pCoords.x, pCoords.y, pCoords.z)
    local radius = 1.5

    Citizen.CreateThread(function()
      while ActivePortals[pId] do
        DrawMarker(
          28,
          coords.x,
          coords.y,
          coords.z + (radius / 2) + 0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          radius,
          radius,
          radius,
          0, -- r
          0, -- g
          0, -- b
          100, -- a
          false,
          false,
          2,
          nil,
          nil,
          false
        )
        Citizen.Wait(0)
      end
    end)
    Citizen.CreateThread(function()
      local portalCoords = { x = pCoords.x, y = pCoords.y, z = pCoords.z + (radius / 2) + 0.0 }
      local scale = 6.0
      local x1, y1, z1 = 0.0, 0.0, 0.0
      local x2, y2, z2 = 180.0, 90.0, 270.0
      local x3, y3, z3 = 90.0, 270.0, 180.0
      while ActivePortals[pId] do
        StartParticleAtCoord(
          "core",
          "veh_exhaust_afterburner",
          true,
          portalCoords,
          { x = x1, y = y1, z = z1 },
          scale,
          10.0,
          nil,
          0
        )
        x1 = x1 + 1.0 + 0.0
        y1 = y1 + 1.0 + 0.0
        z1 = z1 + 1.0 + 0.0
        StartParticleAtCoord(
          "core",
          "veh_exhaust_afterburner",
          true,
          portalCoords,
          { x = x2, y = y2, z = z2 },
          scale,
          10.0,
          nil,
          0
        )
        x2 = x2 + 1.0 + 0.0
        y2 = y2 + 1.0 + 0.0
        z2 = z2 + 1.0 + 0.0
        StartParticleAtCoord(
          "core",
          "veh_exhaust_afterburner",
          true,
          portalCoords,
          { x = x3, y = y3, z = z3 },
          scale,
          10.0,
          nil,
          0
        )
        x3 = x3 + 1.0 + 0.0
        y3 = y3 + 1.0 + 0.0
        z3 = z3 + 1.0 + 0.0
        Citizen.Wait(0)
      end
    end)
  end)

  RegisterNetEvent("np-fx:clearPortal", function(pId)
    ActivePortals[pId] = nil
  end)