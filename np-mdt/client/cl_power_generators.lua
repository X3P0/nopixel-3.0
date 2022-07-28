local isPowerOut = false
local inGeneratorSpot = false

RegisterNetEvent("sv-heists:cityPowerState", function(pIsPowerOn)
  isPowerOut = not pIsPowerOn
  if not isPowerOut then return end
  if not inGeneratorSpot then return end
  Wait(1000)
  TriggerEvent("chatMessage", "^2[State Alert]", {100, 100, 100}, "Power outage detected. Backup generators will enable momentarily.", "feed", false, { i18n = { "Power outage detected. Backup generators will enable momentarily" }})
  Wait(3500)
  for i = 1, 5 do
    Citizen.Wait(200)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
  end
  TriggerEvent("weather:blackout", false)
end)

AddEventHandler("np-polyzone:enter", function(pZone)
  if pZone ~= "power_generator" then return end
  inGeneratorSpot = true
  if not isPowerOut then return end
  TriggerEvent("weather:blackout", false)
end)
AddEventHandler("np-polyzone:exit", function(pZone)
  if pZone ~= "power_generator" then return end
  inGeneratorSpot = false
  if not isPowerOut then return end
  TriggerEvent("weather:blackout", true)
end)

Citizen.CreateThread(function()
  Wait(15000)
  RPC.execute("np-casino:getCurrentInteriorSetName")
  local data = RPC.execute("np-heists:getVaultLowerState")
  isPowerOut = not data.cityPowerState
end)

Citizen.CreateThread(function()
  -- hospital
  exports["np-polyzone"]:AddBoxZone("power_generator", vector3(333.23, -585.39, 43.28), 45.4, 62.8, {
    heading=339,
    minZ=41.88,
    maxZ=45.68,
  })
  -- mrpd
  exports["np-polyzone"]:AddBoxZone("power_generator", vector3(455.67, -992.97, 30.68), 50.0, 65.0, {
    heading=0,
    minZ=16.68,
    maxZ=43.88,
  })
  -- court house
  exports["np-polyzone"]:AddPolyZone("power_generator", {
    vector2(-506.07803344727, -201.79862976074),
    vector2(-517.03790283203, -208.71363830566),
    vector2(-521.68615722656, -199.80276489258),
    vector2(-524.96588134766, -193.96635437012),
    vector2(-536.9501953125, -196.93641662598),
    vector2(-572.33013916016, -217.36175537109),
    vector2(-581.67498779297, -201.17190551758),
    vector2(-565.53167724609, -189.98175048828),
    vector2(-547.07885742188, -179.37126159668),
    vector2(-521.140625, -164.91171264648),
    vector2(-515.97747802734, -173.89521789551),
    vector2(-511.50854492188, -182.61334228516),
    vector2(-516.35174560547, -185.52281188965),
  }, {})
  -- prison
  exports["np-polyzone"]:AddPolyZone("power_generator", {
    vector2(1778.1744384766, 2503.4338378906),
    vector2(1762.9940185547, 2501.5783691406),
    vector2(1741.4533691406, 2489.1787109375),
    vector2(1739.9338378906, 2482.9553222656),
    vector2(1749.7613525391, 2466.5795898438),
    vector2(1774.8541259766, 2481.033203125),
    vector2(1785.3967285156, 2492.5827636719),
  }, {})

  -- Hades
  exports["np-polyzone"]:AddPolyZone("power_generator", {
    vector2(-821.05737304688, 259.58108520508),
    vector2(-814.60864257812, 242.36331176758),
    vector2(-804.69018554688, 243.87649536133),
    vector2(-805.27575683594, 267.29306030273),
    vector2(-819.13610839844, 269.33633422852),
    vector2(-819.60180664062, 266.56787109375),
    vector2(-836.17895507812, 269.31958007812),
    vector2(-838.66845703125, 256.46215820312),
    vector2(-818.04449462891, 253.46583557129)
  }, {})

  exports["np-polyzone"]:AddPolyZone("power_generator", {
    vector2(-421.51205444336, 21.064643859863),
    vector2(-422.71182250977, 23.174507141113),
    vector2(-426.73696899414, 23.453491210938),
    vector2(-427.60723876953, 21.640306472778),
    vector2(-489.20013427734, 27.874519348145),
    vector2(-489.02752685547, 29.18285369873),
    vector2(-491.67330932617, 29.636651992798),
    vector2(-493.24584960938, 28.20775604248),
    vector2(-490.29055786133, 55.042976379395),
    vector2(-488.81982421875, 65.964256286621),
    vector2(-462.89721679688, 55.188854217529),
    vector2(-403.28533935547, 55.720790863037),
    vector2(-404.46792602539, 42.144374847412),
    vector2(-404.72299194336, 30.879671096802),
    vector2(-406.94989013672, 25.643390655518),
    vector2(-412.32809448242, 22.265985488892)
  }, {
    minZ = 45.315093994141,
    maxZ = 59.474578857422
  })

  -- Tunershop
  exports["np-polyzone"]:AddBoxZone("power_generator", vector3(137.45, -3029.6, 7.04), 45.2, 34.4, {
    heading=0,
    minZ=5.44,
    maxZ=16.44,
  })

  exports["np-polyzone"]:AddBoxZone("power_generator", vector3(-586.41, -894.87, 25.72), 20.4, 20.4, {
    heading=0,
    minZ=17.17,
    maxZ=35.77,
  })
end)
