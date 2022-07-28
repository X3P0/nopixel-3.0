local spawnedKeys = {}
local isDead = false
local allPeds = {}
local inArea = false

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
  isDead = not isDead
  if isDead then
    spawnedKeys = {}
    for _, ped in pairs(allPeds) do
      if DoesEntityExist(ped) then
        DeleteEntity(ped)
      end
    end
    allPeds = {}
    if not inArea then return end
    DoScreenFadeOut(4000)
    Wait(6000)
    ClearPedTasksImmediately(PlayerPedId())
    SetEntityCoords(PlayerPedId(), vector3(-1131.62, 5410.5, 2.89))
    Wait(2000)
    DoScreenFadeIn(2000)
    Wait(2000)
    TriggerEvent("chatMessage", "Military", 1, "This is a controlled military zone, do not attempt to enter.", "feed", false, {{
      i18n = { "This is a controlled military zone, do not attempt to enter." },
    }})
  end
end)

local function cleanUp()
  if not inArea then return end
  inArea = false
  spawnedKeys = {}
  for _, ped in pairs(allPeds) do
    if DoesEntityExist(ped) then
      DeleteEntity(ped)
    end
  end
  allPeds = {}
end

local function InDefaultWorld()
  local state = LocalPlayer.state
  local world = state.routingBucketName
  if world == 'default' then
    return true
  end
  return false
end

local function spawnPedToDestroy(k, coords)
  if spawnedKeys[k] then
    local ped = spawnedKeys[k]
    TaskShootAtEntity(ped, PlayerPedId(), 10000, `FIRING_PATTERN_FULL_AUTO`)
    return
  end
  Citizen.CreateThread(function()
    RequestModel(`s_m_m_marine_01`)
    while not HasModelLoaded(`s_m_m_marine_01`) do
      Wait(0)
    end
    local ped = CreatePed(4, `s_m_m_marine_01`, coords, 0, 1)
    allPeds[#allPeds + 1] = ped
    spawnedKeys[k] = ped
    while not DoesEntityExist(ped) do
      Wait(0)
    end
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    if math.random() < 0.2 then
      GiveWeaponToPed(ped, -1312131151, 9999, false, true)
      SetCurrentPedWeapon(ped, -1312131151, true)
      SetPedAmmo(ped, -1312131151, 9999)
      SetAmmoInClip(ped, -1312131151, 9999)
    else
      GiveWeaponToPed(ped, 1192676223, 9999, false, true)
      SetCurrentPedWeapon(ped, 1192676223, true)
      SetPedAmmo(ped, 1192676223, 9999)
      SetAmmoInClip(ped, 1192676223, 9999)
    end
    Wait(0)
    TaskShootAtEntity(ped, PlayerPedId(), 10000, `FIRING_PATTERN_FULL_AUTO`)
  end)
end

Citizen.CreateThread(function()
  while true do
    Wait(5000)
    if not isDead then
      if not InDefaultWorld() then
        cleanUp()
      else
        local coords = GetEntityCoords(PlayerPedId())
        coords = vector4(coords.x, coords.y, coords.z, 0.0)
        local spawnedCount = 0
        for k, spawnCoords in pairs(SPAWN_COORDS) do
          if #(coords - spawnCoords) < 150 then
            spawnedCount = spawnedCount + 1
            spawnPedToDestroy(k, spawnCoords)
          end
        end
        if spawnedCount > 0 then
          inArea = true
        else
          cleanUp()
        end
      end
    end
  end
end)

SPAWN_COORDS = {
  vector4(-3565.27,7342.92,32.54,114.91),
  vector4(-3585.13,7353.59,32.54,71.76),
  vector4(-3583.45,7387.29,32.56,64.67),
  vector4(-3571.4,7399.54,32.53,7.9),
  vector4(-3553.09,7403.18,32.53,1.21),
  vector4(-3539.61,7402.58,32.52,323.18),
  vector4(-3524.38,7386.13,32.53,255.46),
  vector4(-3520.84,7378.32,32.53,216.01),
  vector4(-3529.24,7348.92,32.54,207.43),
  vector4(-3543.36,7336.7,32.56,179.48),
  vector4(-3544.92,7342.54,52.28,176.95),
  vector4(-3560.68,7341.37,52.3,188.84),
  vector4(-3572.39,7356.57,52.24,81.99),
  vector4(-3561.74,7386.53,52.28,20.57),
  vector4(-3540.53,7380.38,52.21,287.5),
  vector4(-3534.25,7364.22,52.21,340.97),
  vector4(-3528.04,7344.27,32.46,294.91),
  vector4(-3560.84,7377.11,32.51,20.9),
  vector4(-3589.12,7342.8,1.59,141.99),
  vector4(-3528.28,7344.31,33.54,172.46),
  vector4(-3535.41,7342.12,33.54,106.25),
  vector4(-3541.05,7337.66,33.54,164.46),
  vector4(-3547.66,7335.06,33.54,102.34),
  vector4(-3564.13,7342.13,33.54,177.92),
  vector4(-3571.52,7341.6,33.54,109.81),
  vector4(-3578.86,7342.09,33.54,85.28),
  vector4(-3581.75,7351.65,33.54,55.67),
  vector4(-3587.57,7358.66,33.54,39.1),
  vector4(-3580.33,7367.32,33.54,3.47),
  vector4(-3579.74,7379.75,33.54,2.03),
  vector4(-3582.87,7390.54,33.54,19.6),
  vector4(-3571.14,7394.76,33.54,301.92),
  vector4(-3568.47,7402.81,33.54,345.94),
  vector4(-3553.9,7401.38,33.54,17.58),
  vector4(-3546.71,7401.74,33.54,358.55),
  vector4(-3539.92,7401.55,33.54,358.76),
  vector4(-3531.5,7395.58,33.54,271.7),
  vector4(-3552.13,7393.62,43.91,83.2),
  vector4(-3562.05,7396.6,43.92,80.54),
  vector4(-3574.09,7397.49,43.92,83.87),
  vector4(-3582.45,7398.09,43.92,74.49),
  vector4(-3569.28,7380.57,43.89,116.06),
  vector4(-3571.42,7369.1,43.92,183.31),
  vector4(-3572.1,7355.27,43.92,172.37),
  vector4(-3572.64,7342.27,43.92,183.64),
  vector4(-3566.13,7343.78,43.92,292.22),
  vector4(-3558.75,7353.18,43.92,267.07),
  vector4(-3547.94,7353.27,43.92,267.2),
  vector4(-3536.4,7353.38,43.92,270.82),
  vector4(-3531.77,7360.18,43.92,323.71),
  vector4(-3530.4,7371.39,43.92,320.14),
  vector4(-3534.17,7372.59,54.29,282.88),
  vector4(-3532.63,7358.84,54.29,179.71),
  vector4(-3535.31,7351.22,54.29,150.43),
  vector4(-3540.94,7342.38,54.29,184.74),
  vector4(-3550.48,7340.49,54.29,126.54),
  vector4(-3559.14,7341.12,54.29,95.99),
  vector4(-3568.83,7340.42,54.29,90.95),
  vector4(-3573.98,7354.18,54.29,21.63),
  vector4(-3573.58,7375.22,54.28,27.58),
  vector4(-3563.34,7376.03,57.93,263.43),
  vector4(-3556.03,7376.29,57.94,270.79),
  vector4(-3549.02,7373.46,57.94,220.04),
  vector4(-3550.99,7361.62,57.95,162.89),
  vector4(-3550.35,7353.86,59.57,222.03),
  vector4(-3532.43,7348.41,64.55,219.11),
  vector4(-3539.46,7348.24,64.67,72.53),
  vector4(-3556.61,7349.77,64.67,96.34),
  vector4(-3562.59,7359.54,69.53,83.28),
  vector4(-3552.94,7359.77,69.53,232.32),
  vector4(-3548.34,7366.57,69.53,313.28),
  vector4(-3553.24,7377.14,69.53,36.17),
  vector4(-3562.05,7378.01,69.53,79.89),
  vector4(-3565.4,7370.73,69.53,146.35),
  vector4(-3572.81,7350.25,72.75,151.79),
  vector4(-3535.35,7359.7,84.15,291.16),
  vector4(-3527.42,7342.03,30.21,109.58),
  vector4(-3546.22,7345.78,30.22,83.04),
  vector4(-3573.24,7344.89,30.2,93.91),
  vector4(-3580.23,7358.93,30.21,6.59),
  vector4(-3583.25,7387.78,30.21,7.22),
  vector4(-3559.96,7393.11,30.21,282.26),
  vector4(-3534.95,7398.52,30.23,323.6),
  vector4(-3526.36,7395.3,30.21,262.73),
}
