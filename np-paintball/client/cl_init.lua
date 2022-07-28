DUI_URL = "https://prod-gta.nopixel.net/dui/?type=countdown&fontSize=5em&seconds=240"

Citizen.CreateThread(function()
  exports["np-polyzone"]:AddBoxZone("paintball_arena", vector3(2341.91, 2558.8, 46.66), 150, 120, {
    heading=0,
    debugPoly=false,
    minZ=43.06,
    maxZ=73.06
  })
end)
