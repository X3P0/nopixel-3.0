local baseSettings = {
  ["xm_base_cia_serverhub_01"] = {
    coords = vector3(2348.5112, 2895.66511, -85.80048),
    heading = 0.0,
  },
  ["xm_base_cia_serverhub_02"] = {
    coords = vector3(2348.5146999999999, 2912.343535, -85.8003503003),
    heading = 0.0,
  },
}

local zones1 = {
  {
    vector3(2342.17, 2896.27, -84.8), 0.4, 1, {
      heading=0,
      minZ=-85.0,
      maxZ=-84.0,
    },
  },
  {
    vector3(2344.89, 2895.22, -84.72), 0.4, 1, {
      heading=0,
      minZ=-84.92,
      maxZ=-83.92,
    },
  },
  {
    vector3(2345.97, 2895.17, -84.72), 0.4, 1, {
      heading=0,
      minZ=-84.92,
      maxZ=-83.92,
    },
  },
  {
    vector3(2347.04, 2895.12, -84.72), 0.4, 1, {
      heading=0,
      minZ=-84.92,
      maxZ=-83.92,
    },
  },
  {
    vector3(2348.2, 2896.3, -84.72), 0.4, 1, {
      heading=0,
      minZ=-84.92,
      maxZ=-83.92,
    },
  },
  {
    vector3(2349.29, 2896.31, -84.72), 0.4, 1, {
      heading=0,
      minZ=-84.92,
      maxZ=-83.92,
    },
  },
  {
    vector3(2350.38, 2896.29, -84.72), 0.4, 1, {
      heading=0,
      minZ=-84.92,
      maxZ=-83.92,
    },
  },
  {
    vector3(2352.08, 2896.26, -84.72), 0.4, 1, {
      heading=0,
      minZ=-84.92,
      maxZ=-83.92,
    },
  },
  {
    vector3(2353.72, 2895.09, -84.72), 0.4, 1, {
      heading=0,
      minZ=-84.92,
      maxZ=-83.92,
    },
  },
  {
    vector3(2354.85, 2895.1, -84.72), 0.4, 1, {
      heading=0,
      minZ=-84.92,
      maxZ=-83.92,
    },
  },
}

local zones2 = {
  {
    vector3(2342.12, 2912.91, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
  {
    vector3(2344.83, 2911.9, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
  {
    vector3(2345.95, 2911.84, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
  {
    vector3(2347.02, 2911.85, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
  {
    vector3(2348.23, 2912.9, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
  {
    vector3(2349.29, 2912.87, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
  {
    vector3(2350.36, 2912.95, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
  {
    vector3(2352.06, 2912.97, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
  {
    vector3(2353.72, 2911.83, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
  {
    vector3(2354.85, 2911.84, -84.72), 0.4, 0.7, {
      heading=0,
      minZ=-84.72,
      maxZ=-83.92,
    },
  },
}

local rad, cos, sin = math.rad, math.cos, math.sin
function genRotation(origin, point, theta)
  if theta == 0.0 then return point end

  local p = point - origin
  local pX, pY = p.x, p.y
  theta = rad(theta)
  local cosTheta = cos(theta)
  local sinTheta = sin(theta)
  local x = pX * cosTheta - pY * sinTheta
  local y = pX * sinTheta + pY * cosTheta
  return vector2(x, y) + origin
end

local polycacheCheck = false
function createFarmPolys()
  if polycacheCheck then return end
  polycacheCheck = true
  local newZones = {}
  for _, settings in pairs(COORDS_FOR_SERVER_BOXES) do
    local baseCoords = baseSettings[settings.label].coords
    local baseHeading = baseSettings[settings.label].heading
    local newBaseCoords = vector3(settings.coords[1], settings.coords[2], settings.coords[3])
    local newBaseHeading = settings.heading + 0.0

    for k, z in pairs(((settings.label == "xm_base_cia_serverhub_01") and zones1 or zones2)) do
      local opts = {
        heading = z[4].heading,
        minZ = z[4].minZ,
        maxZ = z[4].maxZ,
      }
      opts.heading = newBaseHeading
      local offsetX = z[1].x - baseCoords.x
      local offsetY = z[1].y - baseCoords.y
      local rotation = genRotation(vector2(0.0, 0.0), vector2(offsetX, offsetY), opts.heading)
      local x = newBaseCoords.x + rotation.x
      local y = newBaseCoords.y + rotation.y
      local zz = opts.minZ + (opts.maxZ - opts.minZ) -- newBaseCoords.z + (baseCoords.z - z[1].z)
      local coords = vector3(x, y, zz)
      local w = z[2] + 0.0
      local h = z[3] + 0.0
      opts.data = {
        id = settings.code .. "_" .. k,
        code = settings.code,
        key = k,
      }
      -- TriggerServerEvent("np-scenes:addSceneToClients", {
      --   coords = coords,
      --   text = "<font size='20'>" .. opts.data.id .. ") </font>",
      --   distance = 33,
      --   color = "white",
      --   caret = false,
      --   font = 0,
      --   solid = false,
      --   background = {
      --     r = 0,
      --     g = 0,
      --     b = 0,
      --     alpha = 0,
      --   }
      -- })
      -- Wait(50)
      local zone = { coords, w, h, opts }
      newZones[#newZones + 1] = zone
    end
  end
  for _, z in pairs(newZones) do
    exports["np-polytarget"]:AddBoxZone("server_farm_hub_box", z[1], z[2], z[3], z[4])
  end

  exports["np-interact"]:AddPeekEntryByPolyTarget("server_farm_hub_box", {{
    event = "np-heists-serverroom:entryBoxInteract",
    id = "server_farm_hub_box",
    icon = "circle",
    label = "Insert USB Panel Reader",
  }}, {
    distance = { radius = 2.0 },
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget("server_farm_hub_box", {{
    event = "np-heists-serverroom:entryBoxDecrypt",
    id = "server_farm_hub_box_d",
    icon = "circle",
    label = "Decrypt USB Panel Reader",
  }}, {
    distance = { radius = 2.0 },
    isEnabled = function()
      local hasItem = exports["np-inventory"]:hasEnoughOfItem("heistusbsrmk", 1, false, true)
      return hasItem
    end,
  })
end
