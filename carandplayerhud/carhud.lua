--SetEntityCoords(PlayerPedId(),1957.7397460938,5172.4497070313,47.9102439880379)


--1  Coords: 892.2587, -960.8538, 38.18458
--2 Coords: -1366.676, -316.9358, 38.28989
--3 Coords: 1957.7397460938,5172.4497070313,47.910243988037
--4 Coords: -341.86242675781,-2444.3217773438,6.000337600708

--FD05J2SX
local invehicle = false
local HudStage = 1

local isHandcuffed = false
local isHandcuffedAndWalking = false

local lastValues = {}
local currentValues = {
  ["hunger"] = 100,
  ["thirst"] = 100,
  ["oxy"] = 100,
  ["stress"] = 100,
  ["crosshair"] = false,
}

local flyingCars = {
  [`oppressor`] = true,
  [`oppressor2`] = true,
  [`deluxo`] = true,
  [`rcbandito`] = true,
  [`ruiner2`] = true,
}

local removedHatManually = false
local removedMaskManually = false

RegisterNetEvent('car:windowsdown')
AddEventHandler('car:windowsdown', function()
  local veh = GetVehiclePedIsUsing(PlayerPedId())
  for i = -1, 6 do
    if GetPedInVehicleSeat(veh, i) == PlayerPedId() then
      RollDownWindow(veh, i+1)
    end
  end
end)

local lastping = 0
local blipgps = {}
RegisterNetEvent('GPSTrack:Accepted')
AddEventHandler('GPSTrack:Accepted', function(x,y,z,srcid,stage)
  local job = exports["isPed"]:isPed("myjob")
  if job == "police" or job == "ems" then
    local radius = 50.0
    if stage == 1 then
      radius = 150.0
    elseif stage == 2 then
      radius = 75.0
    else
      radius = 15.0
    end
    if blipgps.srcid then
      RemoveBlip(blipgps.srcid)
    end
    blipgps.srcid = AddBlipForRadius(x,y,z,radius)
    SetBlipAlpha(blipgps.srcid,125)
    SetBlipSprite(blipgps.srcid,9)
    SetBlipColour(blipgps.srcid,41)

    Citizen.Wait(55000)
    RemoveBlip(blipgps.srcid)
  end
end)

RegisterNetEvent('GPSTrack:Create')
AddEventHandler('GPSTrack:Create', function()

  if lastping == 0 then
    lastping = 1
    x,y,z = GPSTrack(1)
    TriggerServerEvent("GPSTrack:Accepted",x,y,z,1)
    Citizen.Wait(60000)
    x,y,z = GPSTrack(2)
    TriggerServerEvent("GPSTrack:Accepted",x,y,z,2)
    Citizen.Wait(60000)
    x,y,z = GPSTrack(3)
    TriggerServerEvent("GPSTrack:Accepted",x,y,z,3)
    Citizen.Wait(120000)
    lastping = 0
  end

end)


function GPSTrack(stage)
  local multi = 50
  if stage == 1 then
    multi = 110
  elseif stage == 2 then
    multi = 55
  else
    multi = 5
  end
  local luck = math.random(2)
  local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, math.random(multi) + 0.0, 0.0))
  if luck == 1 then
    x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), math.random(multi) + 0.0, 0.0, 0.0))
  end
  return x,y,z
end

RegisterNetEvent('car:windowsup')
AddEventHandler('car:windowsup', function()
  local veh = GetVehiclePedIsUsing(PlayerPedId())
  for i = -1, 6 do
    if GetPedInVehicleSeat(veh, i) == PlayerPedId() then
      RollUpWindow(veh, i+1)
    end
  end
end)

RegisterNetEvent('car:windows')
AddEventHandler('car:windows', function(closeType,window)
  local veh = GetVehiclePedIsUsing(PlayerPedId())
  if tonumber(window) == nil then
    return
  end
  if veh ~= nil then
    if window == "all" or window == "All" then
      if closeType == "open" or closeType == "Open" or closeType == "OPEN" then
        for i=0,4 do
          RollDownWindow(veh, i)
        end
      else
        for i=0,4 do
          RollUpWindow(veh, i)
        end
      end
    else
      local window = tonumber(window)
      if window < 0 or window > 4  then
        return
      end
      if closeType == "open" or closeType == "Open" or closeType == "OPEN" then
        RollDownWindow( veh, window )
      else
        RollUpWindow( veh, window )
      end
    end
  end
end)

RegisterNetEvent('car:doors')
AddEventHandler('car:doors', function(closeType,door)

  local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
  local veh = GetVehiclePedIsUsing(PlayerPedId())
  local door = tonumber(door)

  if not isInVehicle then

        lastPlayerPos = GetEntityCoords(PlayerPedId(), 1)
        coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
        veh = getVehicleInDirection(lastPlayerPos, coordB)

      local Driver = GetPedInVehicleSeat(veh, -1)
      if DoesEntityExist(Driver) and not IsPedAPlayer(Driver) then
          TriggerEvent("DoLongHudText","The vehicle is locked!",2)
          return
      end
      local lockStatus = GetVehicleDoorLockStatus(veh)
      if lockStatus ~= 1 and lockStatus ~= 0 then
          TriggerEvent("DoLongHudText","The vehicle is locked!",2)
          return
      end

        if veh then

          local d1,d2 = GetModelDimensions(GetEntityModel(veh))
          local front = GetOffsetFromEntityInWorldCoords(veh, 0.0,d2["y"]+0.5,0.0)
          local back = GetOffsetFromEntityInWorldCoords(veh, 0.0,d1["y"]-0.5,0.0)

          local leftfront = GetOffsetFromEntityInWorldCoords(veh, d1["x"]-0.25,0.25,0.0)
          local rightfront = GetOffsetFromEntityInWorldCoords(veh, d2["x"]+0.25,0.25,0.0)

          local leftback = GetOffsetFromEntityInWorldCoords(veh, d1["x"]-0.25,-0.85,0.0)
          local rightback = GetOffsetFromEntityInWorldCoords(veh, d2["x"]+0.25,-0.85,0.0)

          local drawinfo = leftfront

          if door == 4 then
            drawInfo = front
          end

          if door == 5 then
            drawInfo = back
          end

           if door == 0 then
            drawInfo = leftfront
          end

          if door == 1 then
            drawInfo = rightfront
          end

           if door == 2 then
            drawInfo = leftback
          end

          if door == 3 then
            drawInfo = rightback
          end

          local dist = #(vector3(drawInfo["x"],drawInfo["y"],drawInfo["z"]) - lastPlayerPos)
            local count = 1000
            while dist > 1.0 and count > 0 do
                dist = #(vector3(drawInfo["x"],drawInfo["y"],drawInfo["z"]) - lastPlayerPos)
                Citizen.Wait(1)
                count = count - 1
                DrawText3D(drawInfo["x"],drawInfo["y"],drawInfo["z"],"Move here to " .. closeType .. ".")
            end

            local distfin = #(GetEntityCoords(veh) - lastPlayerPos)
            if distfin > 5.0 or GetEntitySpeed(veh) > 5 then
              return
            end
            loadAnimDict('anim@narcotics@trash')
            TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1500, 49, 3.0, 0, 0, 0)
            TaskTurnPedToFaceEntity(PlayerPedId(), veh, 1.0)
            Citizen.Wait(1600)
            ClearPedTasks(PlayerPedId())
      end
  end
  if veh ~= nil then
    if closeType == "open" or closeType == "Open" then
      SetVehicleDoorOpen(veh, door, 1, 1)
    else
      SetVehicleDoorShut(veh, door, 1, 1)
    end
  end
end)

function GetCauseOfDeath()

    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if distance < 3.0 and not IsPedAPlayer(ped) then
          if hashDeathToText['' .. GetPedCauseOfDeath(ped) .. ''] ~= nil then
            TriggerEvent("DoLongHudText","It seems they sustained injuries from a " .. hashDeathToText['' .. GetPedCauseOfDeath(ped) .. ''])
          else
            TriggerEvent("DoLongHudText","It seems they died from unknown causes")
          end
         --   SetEntityAsNoLongerNeeded(ped)
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped

end

function carryPed(ped)

  loadAnim('anim@narcotics@trash')
  TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1500, 49, 3.0, 0, 0, 0)
  TaskTurnPedToFaceEntity(PlayerPedId(), ped, 1.0)



  SetBlockingOfNonTemporaryEvents(ped, true)
  SetPedSeeingRange(ped, 0.0)
  SetPedHearingRange(ped, 0.0)
  SetPedFleeAttributes(ped, 0, false)
  SetPedKeepTask(ped, true)

      loadAnim( "dead" )
      TaskPlayAnim(ped, "dead", "dead_f", 8.0, 8.0, -1, 1, 0, 0, 0, 0)

  DetachEntity(ped)
  ClearPedTasks(ped)
  loadAnim( "amb@world_human_bum_slumped@male@laying_on_left_side@base" )
  TaskPlayAnim(ped, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
  attachCarryPed(ped)
  local holdingBody = true
  ClearPedTasksImmediately(PlayerPedId())
  while (holdingBody) do

    Citizen.Wait(1)


    if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
      loadAnim( "missfinale_c2mcs_1" )
      TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)

    end


    if IsControlJustPressed(0, 38) or (`WEAPON_UNARMED` ~= GetSelectedPedWeapon(PlayerPedId()))  then
      holdingBody = false
      DetachEntity(ped)
    end


  end
  ClearPedTasks(PlayerPedId())
  DetachEntity(ped)
end

function attachCarryPed(ped)
  AttachEntityToEntity(ped, PlayerPedId(), 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
  loadAnim( "missfinale_c2mcs_1" )
  TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
end
RegisterNetEvent('police:carryAI')
AddEventHandler('police:carryAI', function()
  local ped = carryPedNow()
  if DoesEntityExist(ped) then
    carryPed(ped)
  end
end)

RegisterNetEvent('police:reviveAI')
AddEventHandler('police:reviveAI', function()
  revivePeds()
end)

RegisterNetEvent('police:COD')
AddEventHandler('police:COD', function()
  GetCauseOfDeath()
end)

function carryPedNow()

    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if distance < 2.0 and not IsPedAPlayer(ped) then
          --ResurrectPed(ped)
            --ReviveInjuredPed(ped)
            ClearPedTasksImmediately(ped)
          carryPed(ped)
          return
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function revivePeds()

    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if distance < 2.0 and not IsPedAPlayer(ped) then
          if hashDeathToText['' .. GetPedCauseOfDeath(ped) .. ''] ~= nil then
            TriggerEvent("DoLongHudText","It seems they sustained injuries from a " .. hashDeathToText['' .. GetPedCauseOfDeath(ped) .. ''])
          else
            TriggerEvent("DoLongHudText","It seems they died from unknown causes")
          end
          ResurrectPed(ped)
            ReviveInjuredPed(ped)
            ClearPedTasksImmediately(ped)
            local crds = GetEntityCoords(ped)
            SetEntityCoords(ped,crds["x"],crds["y"],crds["z"]+1.2)

            TaskWanderStandard(ped, 10.0, 10)
            Citizen.Wait(1000)
            SetEntityCoords(ped,crds["x"],crds["y"],crds["z"]+1.2)
         --   SetEntityAsNoLongerNeeded(ped)
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped

end

hashDeathToText = {
['-102973651'] = "Hatchet",
['-1834847097'] = "Dagger",
['-102323637'] = "Glass Bottle",
['-2067956739'] = "Crowbar",
['-656458692'] = "Knuckle Dusters",
['-1786099057'] = "Baseball Bat",
['-1716189206'] = "Combat Knife",
['-2066285827'] = "Assault SMG",
['-270015777'] = "Bullpup Rifle",
['-1654528753'] = "Bullpup Shotgun",
['-494615257'] = "Auto Shotgun",
['-619010992'] = "Tec 9",
['-2009644972'] = "SNS Pistol",
['-1121678507'] = "Mini SMG",
['2725352035'] = "Unarmed",
['4194021054'] = "Animal",
['148160082'] = "Cougar",
['2578778090'] = "Knife",
['1737195953'] = "Nightstick",
['1317494643'] = "Hammer",
['2508868239'] = "Bat",
['1141786504'] = "Golfclub",
['2227010557'] = "Crowbar",
['453432689'] = "Pistol",
['1593441988'] = "Combat Pistol",
['584646201'] = "AP Pistol",
['2578377531'] = "Deagle",
['324215364'] = "Micro SMG",
['736523883'] = "SMG",
['4024951519'] = "Assault SMG",
['3220176749'] = "Assault Rifle",
['2210333304'] = "Carbine",
['2937143193'] = "Adv Rifle",
['2634544996'] = "MG",
['2144741730'] = "Combat MG",
['487013001'] = "Pump Action",
['2017895192'] = "Sawnoff",
['3800352039'] = "Assault Shotgun",
['2640438543'] = "Bullpup Shotgun",
['911657153'] = "Stun Gun",
['100416529'] = "Sniper",
['205991906'] = "Heavy Sniper",
['856002082'] = "Remote Sniper",
['2726580491'] = "GND Launcher",
['1305664598'] = "GND Launcher SMK",
['2982836145'] = "RPG",
['375527679'] = "Passenger Rocket",
['324506233'] = "Air Rocket",
['1752584910'] = "Stinger",
['1119849093'] = "Minigun",
['2481070269'] = "Grenade",
['741814745'] = "Stick Bomb",
['4256991824'] = "Smoke Grenade",
['2694266206'] = "Bz Gas",
['615608432'] = "Molotov",
['101631238'] = "Fire Ext",
['883325847'] = "Petrol Can",
['4256881901'] = "Digi Scanner",
['2294779575'] = "Briefcase",
['28811031'] = "Briefcase",
['600439132'] = "Ball",
['1233104067'] = "Flare",
['3204302209'] = "Veh Rocket",
['1223143800'] = "Barbed Wire",
['4284007675'] = "Drown",
['1936677264'] = "Drown Vehicle",
['2339582971'] = "Bleeding",
['2461879995'] = "Electric Fence",
['539292904'] = "Explosion",
['3452007600'] = "Fall",
['910830060'] = "Exhaustion",
['3425972830'] = "Water Cannon",
['133987706'] = "Rammed",
['2741846334'] = "Run Over",
['341774354'] = "Heli Crash",
['3750660587'] = "Fire",

----------------DLC Weapons----------------

------------------------------------
['3218215474'] = "SNS Pistol",
['4192643659'] = "Bottle",

------------------------------------
['1627465347'] = "Gusenberg",

------------------------------------
['3231910285'] = "Special Carbine",
['3523564046'] = "Heavy Pistol",

------------------------------------
['2132975508'] = "Bullpup",


------------------------------------
['2460120199'] = "Dagger",
['137902532'] = "Vintage Pistol",


------------------------------------
['2138347493'] = "Firework",
['2828843422'] = "Musket",


------------------------------------
['984333226'] = "Heavy Shotgun",
['3342088282'] = "Mark Rifle",


------------------------------------
['1672152130'] = "Homing Launcher",
['2874559379'] = "Proximity Mine",
['126349499'] = "Snowball",

------------------------------------
['1198879012'] = "Flaregun",
['3794977420'] = "Garbage Bag",
['3494679629'] = "Handcuffs",


------------------------------------
['171789620'] = "Combat PDW",


------------------------------------
['3696079510'] = "Mrk Pistol",
['3638508604'] = "Knuckle",


------------------------------------
['4191993645'] = "Hatchet",
['1834241177'] = "Railgun",


------------------------------------
['3713923289'] = "Machete",
['3675956304'] = "Mac Pistol",


------------------------------------
['738733437'] = "Air Defence",
['3756226112'] = "Switchblade",
['3249783761'] = "Revolver",


------------------------------------
['4019527611'] = "DB Shotgun",
['1649403952'] = "Cmp Rifle",


------------------------------------
['317205821'] = "Auto Shotgun",
['3441901897'] = "Battle Axe",
['125959754'] = "Cmp Launcher",
['3173288789'] = "SMG Mini",
['3125143736'] = "Pipebomb",
['2484171525'] = "Cue",
['419712736'] = "Wrench",
["-581044007"] = "Machete",
}
function loadAnim( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


xnmark = {}
xnmark.locations = {
  ["Doomsday Finale"] = {
    ["markin"] = {-360.8825378418, 4826.5556640625, 143.14414978028},
    ["markout"] = {1256.2868652344, 4798.3833007812, -39.471000671386},
    ["locin"] = {1259.5418701172, 4812.1196289062, -39.77448272705, 344.82873535156},
    ["locout"] = {-353.65161132812, 4815.8237304688, 142.7413635254},
  },
  ["Doomsday Silo"] = {
    ["markin"] = {598.3062133789, 5556.9243164062, -716.76141357422}, -- Not Used
    ["markout"] = {369.55322265625, 6319.6455078125, -159.92749023438},
    ["locin"] = {369.46231079102, 6319.7626953125, -659.92739868164}, -- Not Used
    ["locout"] = {602.27032470704, 5546.9267578125, 716.38928222656, 246.04162597656},
  },
  ["Doomsday Facility"] = {
    ["markin"] = {1286.9239501954, 2845.8833007812, 49.394256591796},
    ["markout"] = {489.0622253418, 4785.3623046875, -58.929149627686},
    ["locin"] = {483.2006225586, 4810.5405273438, -58.919288635254, 18.04705619812},
    ["locout"] = {1267.4091796875, 2830.9741210938, 48.444499969482, 128.1668395996},
  },
  ["IAA Facility"] = {
    ["markin"] = {2049.8181152344, 2949.5847167968, 47.735733032226},
    ["markout"] = {2155.0627441406, 2921.0417480468, -61.902416229248},
    ["locin"] = {2151.1369628906, 2921.3303222656, -61.901874542236, 85.827827453614},
    ["locout"] = {2053.8020019532, 2953.4047851562, 47.664855957032, 354.8461303711},
  },
  ["IAA Server"] = {
    ["markin"] = {2477.6774902344, -402.14556884766, 94.817413330078},
    ["markout"] = {2154.7639160156, 2921.0678710938, -81.075424194336},
    ["locin"] = {2158.1184082032, 2920.9382324218, -81.075386047364, 270.48007202148},
    ["locout"] = {2482.9174804688, -405.25631713868, 93.735389709472, 318.76651000976},
  },
  ["Doomsday Sub"] = {
    ["markin"] = {493.83395385742, -3222.7514648438, 10.49820137024},
    ["markout"] = {514.42980957032, 4888.4028320312, -62.589431762696},
    ["locin"] = {514.29266357422, 4885.8706054688, -62.589862823486, 180.25909423828},
    ["locout"] = {496.30267333984, -3222.6359863282, 6.0695104599, 270.0},
  },
}

--IsVehicleSirenSoundOn(vehicle)
--GetIsTaskActive(ped, 122)

function disabledPeds(dstscan)
  local fwdDst = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, dstscan, 0.0)
  local veh = GetClosestVehicle(fwdDst["x"],fwdDst["y"],fwdDst["z"], dstscan, 0, 70)
  if DoesEntityExist(veh) then
    if not IsPedAPlayer(GetPedInVehicleSeat(veh, -1)) then
      local myh = GetEntityHeading(PlayerPedId())
      local carh = GetEntityHeading(veh)
      if (myh - carh) > -45 and (myh - carh) < 45 then

        Citizen.Wait(1)
        TaskVehicleTempAction(GetPedInVehicleSeat(veh, -1), veh, 27, 25.0)
      end
    end
  else
    Citizen.Wait(15)
    disabledPeds(25.0)
  end
end

function disabledPeds2()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, veh = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(veh)
        local distance = #(playerCoords - pos)
        if distance < 80.0 then

        if IsPedAPlayer(GetPedInVehicleSeat(veh, -1)) then
        else
        TaskVehicleDriveWander(GetPedInVehicleSeat(veh, -1), veh, GetEntitySpeed(veh), 786603)
        SetPedKeepTask(GetPedInVehicleSeat(veh, -1), true)
        DeleteEntity(veh)

        end
        Citizen.Wait(50)
        end
        success, veh = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
end

function createObjectTest()
  local prop = `prop_mp_drug_package`
  local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, -1.0))
  RequestModel(prop)
  while not HasModelLoaded(prop) do
    Citizen.Wait(100)
  end
  local propobject = CreateObject(prop, x,y,z, true, false, false)
  Citizen.Wait(3000)
  SetEntityAsNoLongerNeeded(prop)
  DeleteEntity(propobject)
end


RegisterNetEvent("francisroll")
AddEventHandler("francisroll",function()

  local times = 3
  local weight = 6
  local strg = ""
  rollAnim()
  for i = 1, times do
    local rolled = math.random(weight)
    if exports["isPed"]:isPed("cid") == 1002 then
      rolled = rolled + 2
      if rolled > weight then
        rolled = weight
      end
    end
    if i == 1 then
      strg = strg .. " " .. rolled .. "/" .. weight
    else
      strg = strg .. " | " .. rolled .. "/" .. weight
    end
  end
  TriggerServerEvent("actionclose", GetPlayerServerId(PlayerId()), "Dice rolled " .. strg, GetPlayerServerId(PlayerId()))
end)



RegisterNetEvent("roll")
AddEventHandler("roll",function(times,weight)
  if IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then return end

  times = tonumber(times)
  weight = tonumber(weight)
  rollAnim()
  local strg = ""
  for i = 1, times do
    if i == 1 then
      strg = strg .. " " .. math.random(weight) .. "/" .. weight
    else
      strg = strg .. " | " .. math.random(weight) .. "/" .. weight
    end

  end
  TriggerServerEvent("actionclose", GetPlayerServerId(PlayerId()), "Dice rolled " .. strg, GetPlayerServerId(PlayerId()))
end)

function rollAnim()
    loadAnimDict( "anim@mp_player_intcelebrationmale@wank" )
    Citizen.Wait(500)
    TaskPlayAnim( PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'dice', 0.1)
    ClearPedTasks(PlayerPedId())
    Citizen.Wait(500)
end


local lastPlayerPos = GetEntityCoords(PlayerPedId())
Citizen.CreateThread(function()
  Wait(300)
  while true do
    lastPlayerPos = GetEntityCoords(PlayerPedId())
    Wait(300)
  end
end)


--SetPedMoveRateOverride(PlayerPedId(), 0.00)

deathanimations = {
  [1] = { ["dict"] = "combat@damage@injured_pistol@to_writhe", ["anim"] = "variation_b", ["info"] = "Hunch over to knees slowly holding stomach with pistol.", },
  [2] = { ["dict"] = "combat@damage@rb_writhe", ["anim"] = "rb_writhe_loop", ["info"] = "Laying on side injured.", },
  [3] = { ["dict"] = "move_strafe@injured", ["anim"] = "idle", ["info"] = "Holding weapon + injured stomach. - use for upper body injuries", },
}

--combat@damage@rb_writhe rb_writhe_loop
--combat@damage@writhe writhe_loop
--combat@damage@writheidle_a writhe_idle_a
--combat@damage@writheidle_b writhe_idle_e
--combat@damage@writheidle_c writhe_idle_g

--move_strafe@injured idle
--move_m@drunk@verydrunk_idles@ fidget_01

-- nm@recover@ nm_r_knee_down_recoveries






function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

local facialWear = {
  [1] = { ["Prop"] = -1, ["Texture"] = -1 },
  [2] = { ["Prop"] = -1, ["Texture"] = -1 },
  [3] = { ["Prop"] = -1, ["Texture"] = -1 },
  [4] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
  [5] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
  [6] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
}
--arms 4
-- face 0
RegisterNetEvent("facewear:update")
AddEventHandler("facewear:update",function()
  for i = 0, 3 do
    if GetPedPropIndex(PlayerPedId(), i) ~= -1 then
      facialWear[i+1]["Prop"] = GetPedPropIndex(PlayerPedId(), i)
    end
    if GetPedPropTextureIndex(PlayerPedId(), i) ~= -1 then
      facialWear[i+1]["Texture"] = GetPedPropTextureIndex(PlayerPedId(), i)
    end
  end

  if GetPedDrawableVariation(PlayerPedId(), 1) ~= -1 then
    facialWear[4]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 1)
    facialWear[4]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 1)
    facialWear[4]["Texture"] = GetPedTextureVariation(PlayerPedId(), 1)
  end

  if GetPedDrawableVariation(PlayerPedId(), 11) ~= -1 then
    facialWear[5]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 11)
    facialWear[5]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 11)
    facialWear[5]["Texture"] = GetPedTextureVariation(PlayerPedId(), 11)
  end

  removedHatManually = false
  removedMaskManually = false
end)

toggleFaceWear = function(pWearType, pShouldRemove)
  local AnimSet = "none"
  local AnimationOn = "none"
  local AnimationOff = "none"
  local PropIndex = 0

  local AnimSet = "mp_masks@on_foot"
  local AnimationOn = "put_on_mask"
  local AnimationOff = "put_on_mask"

  facialWear[6]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 0)
  facialWear[6]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 0)
  facialWear[6]["Texture"] = GetPedTextureVariation(PlayerPedId(), 0)

  for i = 0, 3 do
    if GetPedPropIndex(PlayerPedId(), i) ~= -1 then
      facialWear[i+1]["Prop"] = GetPedPropIndex(PlayerPedId(), i)
    end
    if GetPedPropTextureIndex(PlayerPedId(), i) ~= -1 then
      facialWear[i+1]["Texture"] = GetPedPropTextureIndex(PlayerPedId(), i)
    end
  end

  if GetPedDrawableVariation(PlayerPedId(), 1) ~= -1 then
    facialWear[4]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 1)
    facialWear[4]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 1)
    facialWear[4]["Texture"] = GetPedTextureVariation(PlayerPedId(), 1)
  end

  if GetPedDrawableVariation(PlayerPedId(), 9) ~= -1 then
    facialWear[5]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 9)
    facialWear[5]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 9)
    facialWear[5]["Texture"] = GetPedTextureVariation(PlayerPedId(), 9)
  end


  if pWearType == 1 then
    PropIndex = 0
  elseif pWearType == 2 then
    PropIndex = 1

    AnimSet = "clothingspecs"
    AnimationOn = "take_off"
    AnimationOff = "take_off"

  elseif pWearType == 3 then
    PropIndex = 2
  elseif pWearType == 4 then
    PropIndex = 1
    if pShouldRemove then
      AnimSet = "missfbi4"
      AnimationOn = "takeoff_mask"
      AnimationOff = "takeoff_mask"
    end
  elseif pWearType == 5 then
    PropIndex = 9
    AnimSet = "clothingtie"
    AnimationOn = "try_tie_positive_a"
    AnimationOff = "try_tie_positive_a"
  elseif pWearType == 6 then
    PropIndex = 6
  end

  if pWearType == 6 then
    local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
    local gender = LocalPlayer:getCurrentCharacter().gender
    local bareFootIndex = 34
    if not IsPedMale(PlayerPedId()) or gender ~= 0 or GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then
      bareFootIndex = 35
    end
    SetPedComponentVariation(PlayerPedId(), PropIndex, bareFootIndex, 0, -1)
    return
  end

  loadAnimDict( AnimSet )

  local currentDrawable = GetPedDrawableVariation(PlayerPedId(), tonumber(PropIndex))
  local currentProp = GetPedPropIndex(PlayerPedId(), tonumber(PropIndex))

  if pWearType == 1 and not pShouldRemove and removedHatManually then
    local hasHat = exports["np-inventory"]:hasEnoughOfItem("hat", 1, false, true, {hat = facialWear[PropIndex+1]["Prop"]})
    if not hasHat then
      TriggerEvent("DoLongHudText", "You don't have your current hat with you.")
      return
    end
  end

  if pWearType == 4 and not pShouldRemove and removedMaskManually then
    local hasMask = exports["np-inventory"]:hasEnoughOfItem("mask", 1, false, true, {mask = facialWear[pWearType]["Prop"]})
    if not hasMask then
      TriggerEvent("DoLongHudText", "You don't have your current mask with you.")
      return
    end
  end

  if pShouldRemove then
    TaskPlayAnim( PlayerPedId(), AnimSet, AnimationOff, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
    Citizen.Wait(500)
    if pWearType ~= 5 then
      if pWearType == 7 then
        SetPedComponentVariation(PlayerPedId(), 7, 1, 0, 0)
      end
      if pWearType == 4 then
        local texture = GetPedTextureVariation(PlayerPedId(), PropIndex)
        local pal = GetPedPaletteVariation(PlayerPedId(), PropIndex)
        SetPedComponentVariation(PlayerPedId(), PropIndex, -1, -1, -1)
        if currentDrawable ~= -1 then
          local itemMeta = { mask = currentDrawable, txd = texture, palette = pal }
          local hasPropItem = exports["np-inventory"]:hasEnoughOfItem("mask", 1, false, true, itemMeta)
          if not hasPropItem then
            TriggerEvent("player:receiveItem", "mask", 1, false, itemMeta)
            exports['np-clothing']:SaveCurrentClothing(PlayerPedId())
          end
          removedMaskManually = true
        end
      else
        if pWearType ~= 2 then
          local txdIndex = GetPedPropTextureIndex(PlayerPedId(), tonumber(PropIndex))
          ClearPedProp(PlayerPedId(), tonumber(PropIndex))
          if pWearType == 1 and currentProp ~= -1 then
            local itemMeta = { hat = currentProp, txd = txdIndex }
            local hasPropItem = exports["np-inventory"]:hasEnoughOfItem("hat", 1, false, true, itemMeta)
            if not hasPropItem then
              TriggerEvent("player:receiveItem", "hat", 1, false, itemMeta)
              exports['np-clothing']:SaveCurrentClothing(PlayerPedId())
            end
            removedHatManually = true
          end
        end
      end
    end
  else
    TaskPlayAnim( PlayerPedId(), AnimSet, AnimationOn, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
    Citizen.Wait(500)
    if pWearType ~= 5 and pWearType ~= 2 then
      if pWearType == 4 then
        SetPedComponentVariation(PlayerPedId(), PropIndex, facialWear[pWearType]["Prop"], facialWear[pWearType]["Texture"], facialWear[pWearType]["Palette"])
        if (currentDrawable == -1 or currentDrawable ~= facialWear[pWearType]["Prop"]) and removedMaskManually then
          TriggerEvent("inventory:removeItemByMetaKV", "mask", 1, "mask", facialWear[pWearType]["Prop"])
          exports['np-clothing']:SaveCurrentClothing(PlayerPedId())
          removedMaskManually = false
        end
      elseif pWearType == 7 then
        SetPedComponentVariation(PlayerPedId(), 7, 2, 0, 0)
      else
        SetPedPropIndex( PlayerPedId(), tonumber(PropIndex), tonumber(facialWear[PropIndex+1]["Prop"]), tonumber(facialWear[PropIndex+1]["Texture"]), false)
        if pWearType == 1 and currentProp == -1 and removedHatManually then

          TriggerEvent("inventory:removeItemByMetaKV", "hat", 1, "hat", facialWear[PropIndex+1]["Prop"])
          exports['np-clothing']:SaveCurrentClothing(PlayerPedId())
          removedHatManually = false
        end
      end
    end
  end

  if pWearType == 5 then
    if not pShouldRemove then
      SetPedComponentVariation(PlayerPedId(), PropIndex, facialWear[pWearType]["Prop"], facialWear[pWearType]["Texture"], facialWear[pWearType]["Palette"])
    else
      SetPedComponentVariation(PlayerPedId(), PropIndex, -1, -1, -1)
    end
    Citizen.Wait(1800)
  end


  if pWearType == 2 then
    Citizen.Wait(600)
    if pShouldRemove then
      ClearPedProp(PlayerPedId(), tonumber(PropIndex))
    end
    if not pShouldRemove then
      Citizen.Wait(140)
      SetPedPropIndex( PlayerPedId(), tonumber(PropIndex), tonumber(facialWear[PropIndex+1]["Prop"]), tonumber(facialWear[PropIndex+1]["Texture"]), false)
    end
  end
  if pWearType == 4 and pShouldRemove then
    Citizen.Wait(1200)
  end
  ClearPedTasks(PlayerPedId())
end

RegisterNetEvent("facewear:adjust")
AddEventHandler("facewear:adjust",function(pWearType, pShouldRemove, pIsPolice)
  local isPolice = pIsPolice or false
  if not (isHandcuffed and isHandcuffedAndWalking) or isPolice then
    if type(pWearType) == "table" then
      for _, wearType in pairs(pWearType) do
        toggleFaceWear(wearType.id, wearType.shouldRemove)
      end
    else
      toggleFaceWear(pWearType, pShouldRemove)
    end
  end
end)

RegisterNetEvent("facewear:setWear")
AddEventHandler("facewear:setWear",function(pWearType, pComponent, pTexture, pPalette)
  if pWearType == 1 then
    facialWear[1]["Prop"] = pComponent
    facialWear[1]["Texture"] = pTexture
  end
  if pWearType == 4 then
    facialWear[4]["Prop"] = pComponent
    facialWear[4]["Palette"] = pPalette
    facialWear[4]["Texture"] = pTexture
  end
end)


firstPersonActive = false



local recoils = {


  -- pistols
  [416676503] = 0.34,

  --smg
  [-957766203] = 0.22,

  -- rifles
  [970310034] = 0.14,

}


local myRecoilFactor = 0.0
RegisterNetEvent("recoil:updateposition")
AddEventHandler("recoil:updateposition", function(sendFactor)

    myRecoilFactor = sendFactor / 5 + 0.0

end)

function Drugs1()
  StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
  Citizen.Wait(8000)
  StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
  Citizen.Wait(8000)
  StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
  StopScreenEffect("DrugsMichaelAliensFightIn")
  StopScreenEffect("DrugsMichaelAliensFight")
  StopScreenEffect("DrugsMichaelAliensFightOut")

end

function Drugs2()
  StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, 0)
  Citizen.Wait(8000)
  StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
  Citizen.Wait(8000)
  StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, 0)
  StopScreenEffect("DrugsTrevorClownsFight")
  StopScreenEffect("DrugsTrevorClownsFightIn")
  StopScreenEffect("DrugsTrevorClownsFightOut")
end



function testAnim()

  local dic = "taxi_hail"
  local anim = "hail_taxi"
   loadAnimDict( dic )

  local lPed = PlayerPedId()
  if not IsEntityPlayingAnim(lPed, dic, anim, 3) then
    TaskPlayAnim(lPed, dic, anim, 1.0, 1.0, -1, 16, 1, 0, 0, 0 )
  end
  Citizen.Wait(1500)
  --ClearPedTasks(PlayerPedId())
end


currentValues["hunger"] = 100
currentValues["thirst"] = 100

hunger = "Full"
thirst = "Sustained"
local cruise = {enabled = false, speed = 0, airTime = 0}

function getVehicleInDirection(coordFrom, coordTo)
  local offset = 0
  local rayHandle
  local vehicle

  for i = 0, 100 do
    rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)
    a, b, c, d, vehicle = GetRaycastResult(rayHandle)

    offset = offset - 1

    if vehicle ~= 0 then break end
  end

  local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))

  if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

RegisterNetEvent("disableHUD")
AddEventHandler("disableHUD", function(passedinfo)
  HudStage = passedinfo
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name)
  if job ~= "police" then isCop = false else isCop = true end
end)

speedoON = false
RegisterNetEvent('stopSpeedo')
AddEventHandler('stopSpeedo', function()

  if speedoON then
    speedoON = false

    return
  end

end)



function ShowRadarMessage(message)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(message)
  DrawNotification(0,1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
  DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.3,0.3)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function canCruise(get_ped_veh)
  local ped = PlayerPedId()
  if not IsPedSittingInAnyVehicle(ped) then
    return false
  end
  if IsPedInAnyBoat(ped) or IsPedInAnySub(ped) or IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped) or IsPedInFlyingVehicle(ped) then
    return false
  end
  if IsThisModelABicycle(GetEntityModel(get_ped_veh)) then
    return false
  end
  if IsVehicleSirenOn(get_ped_veh) or IsPedJumpingOutOfVehicle(ped) or IsVehicleStopped(ped) then
    return false
  end
  if GetEntitySpeedVector(get_ped_veh, true).y < 1 or GetEntitySpeed(get_ped_veh) * 3.6 < 40 then
    return false
  end

  return true
end

function EnableCruise(get_ped_veh)
  cruise.airTime = 0
  cruise.enabled = true
  cruise.speed = GetEntitySpeed(get_ped_veh)
  TriggerEvent("DoLongHudText",'Cruise Activated',11)
end

function DisableCruise(showMsg)
  cruise.airTime = 0
  cruise.enabled = false
  if showMsg then
    TriggerEvent("DoLongHudText",'Cruise Deactivated',11)
  end
end


oxyOn = false
attachedProp = 0
attachedProp2 = 0

function removeAttachedProp2()
  DeleteEntity(attachedProp2)
  attachedProp2 = 0
end
function removeAttachedProp()
  DeleteEntity(attachedProp)
  attachedProp = 0
end
function attachProp2(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
  removeAttachedProp2()
  attachModel = GetHashKey(attachModelSent)
  boneNumber = boneNumberSent
  local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
  --local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
  RequestModel(attachModel)
  while not HasModelLoaded(attachModel) do
    Citizen.Wait(100)
  end
  attachedProp2 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(attachedProp2, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
  SetModelAsNoLongerNeeded(attachModel)
end
function attachProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
  removeAttachedProp()
  attachModel = GetHashKey(attachModelSent)
  boneNumber = boneNumberSent
  local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
  --local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
  RequestModel(attachModel)
  while not HasModelLoaded(attachModel) do
    Citizen.Wait(100)
  end
  attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
  SetModelAsNoLongerNeeded(attachModel)
end

RegisterNetEvent("OxyMenu")
AddEventHandler("OxyMenu",function()
  if currentValues["oxy"] > 25.0 then
    --RemoveOxyTank
    TriggerEvent('sendToGui','Remove Oxy Tank','RemoveOxyTank')
  end
end)

RegisterNetEvent("RemoveOxyTank")
AddEventHandler("RemoveOxyTank",function()
  if currentValues["oxy"] > 25.0 then
    currentValues["oxy"] = 25.0
  end
  TriggerEvent('menu:hasOxygenTank', false)
end)

local useBlackOxy = false
RegisterNetEvent("UseOxygenTank")
AddEventHandler("UseOxygenTank",function(pUseBlackOxygenTank)
  currentValues["oxy"] = 100.0
  TriggerEvent('menu:hasOxygenTank', true)
  useBlackOxy = pUseBlackOxygenTank and pUseBlackOxygenTank or false
end)

RegisterNetEvent("status:needs:restore")
AddEventHandler("status:needs:restore", function ()
  currentValues["hunger"] = 100
  currentValues["thirst"] = 100
end)

dstamina = 0
-- stress, 10000 is maximum, 0 being lowest.
RegisterNetEvent("client:updateStress")
AddEventHandler("client:updateStress",function(newStress)
  stresslevel = newStress
  if dstamina == 0 then
    RevertToStressMultiplier()
  end
end)
sitting = false

function RevertToStressMultiplier()
  local factor = (stresslevel / 2) / 10000
  local factor = 1.0 - factor
  
  if factor > 0.1 then
    SetSwimMultiplierForPlayer(PlayerId(), factor)
    SetRunSprintMultiplierForPlayer(PlayerId(), factor)
  else
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
  end
end

exports('revertToStress', RevertToStressMultiplier)

imdead = 0

RegisterNetEvent('hadtreat')
AddEventHandler('hadtreat', function(arg1,arg2,arg3)
  local model = GetEntityModel(PlayerPedId())
    if model ~= GetHashKey("a_c_chop") then return end

    dstamina = 400
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.25)

    while dstamina > 0 do

        Citizen.Wait(1000)
        RestorePlayerStamina(PlayerId(), 1.0)
        dstamina = dstamina - 1

    end

    dstamina = 0

    if IsPedRunning(PlayerPedId()) then
        SetPedToRagdoll(PlayerPedId(),1000,1000, 3, 0, 0, 0)
    end

    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    RevertToStressMultiplier()

end)

-- RegisterNetEvent('food:IceCream')
-- AddEventHandler('food:IceCream', function(q, itemid)

--   currentValues["thirst"] = currentValues["thirst"] + 40

--   if currentValues["thirst"] < 0 then
--     currentValues["thirst"] = 0
--   end

--   if currentValues["thirst"] > 100 then
--     currentValues["thirst"] = 100
--   end
-- end)

-- RegisterNetEvent('food:FishTaco')
-- AddEventHandler('food:FishTaco', function()
--   dstamina = 0

--   currentValues["hunger"] = currentValues["hunger"] + 80
--   if currentValues["hunger"] < 0 then
--     currentValues["hunger"] = 0
--   end

--   if currentValues["hunger"] > 100 then
--     currentValues["hunger"] = 100
--   end

--     if stresslevel > 500 then
--     SetSwimMultiplierForPlayer(PlayerId(), 1.15)
--       dstamina = math.random(30,60)
--   else
--       SetSwimMultiplierForPlayer(PlayerId(), 1.25)
--       dstamina = math.random(30,60)
--   end

--   while dstamina > 0 do
--     if (IsPedSwimmingUnderWater(PlayerPedId()) or IsPedSwimming(PlayerPedId())) then
--       RestorePlayerStamina(PlayerId(), 1.0)
--     end
--         Citizen.Wait(1000)
--         dstamina = dstamina - 1
--     end

--     dstamina = 0


--     SetSwimMultiplierForPlayer(PlayerId(), 1.0)
--     RevertToStressMultiplier()
-- end)

-- RegisterNetEvent('food:Taco')
-- AddEventHandler('food:Taco', function()
--   currentValues["hunger"] = 100
--   TriggerEvent("healed:minors")
-- end)

-- local lastBuffTime = 0
-- RegisterNetEvent('food:Condiment')
-- AddEventHandler('food:Condiment', function(q, itemid)
--   dstamina = 0
--   Citizen.Wait(1000)

--   currentValues["hunger"] = currentValues["hunger"] + 40

--   if currentValues["hunger"] < 0 then
--     currentValues["hunger"] = 0
--   end

--   if currentValues["hunger"] > 100 then
--     currentValues["hunger"] = 100
--   end
  
--   if lastBuffTime > 0 and lastBuffTime + (60000 * 2) > GetGameTimer() then return end
--   lastBuffTime = GetGameTimer()

--   local runSpeedMod = 1.15

--   if stresslevel > 500 then
--     runSpeedMod = 1.1
--   else
--     runSpeedMod = 1.15
--   end

--   if itemid == "franksmonster" then
--     runSpeedMod = 1.3
--     Citizen.CreateThread(function()
--       DoScreenFadeOut(dstamina * 1000)
--       Citizen.Wait(dstamina * 1000)
--       SetPedToRagdoll(PlayerPedId(), 55, 55, 3, 0, 0, 0)
--       Citizen.Wait(1000)
--       DoScreenFadeIn(200)
--     end)
--   end

--   SetRunSprintMultiplierForPlayer(PlayerId(), runSpeedMod)
--   dstamina = math.random(5, 8)

--   while dstamina > 0 do
--       Citizen.Wait(1000)
--       RestorePlayerStamina(PlayerId(), 1.0)
--       dstamina = dstamina - 1
--   end

--   dstamina = 0

--   SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
--   RevertToStressMultiplier()
-- end)

-- RegisterNetEvent('food:Fries')
-- AddEventHandler('food:Fries', function()
--   currentValues["hunger"] = currentValues["hunger"] + 50

--   if currentValues["hunger"] < 0 then
--     currentValues["hunger"] = 0
--   end

--   if currentValues["hunger"] > 100 then
--     currentValues["hunger"] = 100
--   end

--   TriggerEvent("healed:minors")
-- end)

-- RegisterNetEvent('food:SoftDrink')
-- AddEventHandler('food:SoftDrink', function()
--   dstamina = 0
--   Citizen.Wait(1000)
--   currentValues["thirst"] = currentValues["thirst"] + 80

--   if currentValues["thirst"] < 0 then
--     currentValues["thirst"] = 0
--   end

--   if currentValues["thirst"] > 100 then
--     currentValues["thirst"] = 100
--   end

--   if lastBuffTime > 0 and lastBuffTime + (60000 * 2) > GetGameTimer() then return end
--   lastBuffTime = GetGameTimer()

--   SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)
--   dstamina = math.random(5,8)

--   while dstamina > 0 do
--     Citizen.Wait(1000)
--     RestorePlayerStamina(PlayerId(), 1.0)
--     dstamina = dstamina - 1
--   end

--   dstamina = 0

--   SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
--   RevertToStressMultiplier()
-- end)

RegisterNetEvent('hadenergy')
AddEventHandler('hadenergy', function(arg1,arg2,arg3)
    dstamina = 0
    Citizen.Wait(1000)

    SetRunSprintMultiplierForPlayer(PlayerId(), 1.005)
    dstamina = 30

    if stresslevel > 1500 then
      SetRunSprintMultiplierForPlayer(PlayerId(), 1.0005)
      dstamina = 115
  elseif stresslevel > 5000 then
      SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
      dstamina = 60
  end

  TriggerEvent("client:newStress",true,math.ceil(40))

    while dstamina > 0 do
        Citizen.Wait(1000)
        RestorePlayerStamina(PlayerId(), 1.0)
        dstamina = dstamina - 1
        if IsPedRagdoll(PlayerPedId()) then
            SetPedToRagdoll(PlayerPedId(), math.random(55), math.random(55), 3, 0, 0, 0)
        end
        if math.random(100) > 85 and IsPedRunning(PlayerPedId()) then
            SetPedToRagdoll(PlayerPedId(), math.random(4000), math.random(4000), 3, 0, 0, 0)
        end
    end
    dstamina = 0
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    if IsPedRunning(PlayerPedId()) then
        SetPedToRagdoll(PlayerPedId(),6000,6000, 3, 0, 0, 0)
    end
    RevertToStressMultiplier()
end)

local stressIsDead = false
AddEventHandler("pd:deathcheck", function()
  stressIsDead = not stressIsDead
end)
Citizen.CreateThread(function()
  while true do
    if stressIsDead or IsPedArmed(PlayerPedId(), 6) then
      TriggerEvent("client:newStress", true, 25, true)
    end
    Wait(30000)
  end
end)


relaxing = false
RegisterNetEvent("client:stressHandler")
AddEventHandler("client:stressHandler",function(reduction)
  if relaxing then
   return
  end
  relaxing = true
  while relaxing do
    Citizen.Wait(30000)
    TriggerServerEvent("server:alterStress",false,reduction)
  end
end)

function GetInWheelChair()
  local ped = PlayerPedId()
  pos = GetEntityCoords(ped)
  head = GetEntityHeading(ped)

  local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.85, -0.45)

  local chair = CreateObject( `prop_wheelchair_01_s`, pos.x, pos.y, pos.z, true, true, true)

  SetEntityCoords(chair, pos.x, pos.y, pos.z-0.85)
  Citizen.Wait(1000)
  TaskStartScenarioAtPosition(ped, 'PROP_HUMAN_SEAT_BENCH', pos.x, pos.y, pos.z, GetEntityHeading(ped), 0, true, true)
  sitting = true
  while sitting do
    AttachEntityToEntity(chair, ped, 11816, 0.0, 0.0, -0.6, 0.0, 0.0, 180.0, true, true, true, true, 1, true)
    Citizen.Wait(1)
  end
end

sleeping = false
showInteraction = true

local beds = {
  2117668672,
  1631638868,
  -1787305376,
  666470117,
  -1182962909,
  -1519439119, -- operation
  -289946279, -- mri
  -1091386327,
}

local BedKeysDisabled = false

AddEventHandler('client:leavebed', function()
  sleeping = false
  DetachEntity(PlayerPedId(), 1, true)
end)

RegisterNetEvent("client:bed")
AddEventHandler("client:bed",function(disableKeys)
--v_med_bed1=1631638868
--v_med_bed2=2117668672
  BedKeysDisabled = disableKeys or false
  local ped = PlayerPedId()
  lastPlayerPos = GetEntityCoords(PlayerPedId())

  local objFound = nil
  local near = 999
  for i=1, #beds do

    local curobjFound = GetClosestObjectOfType(lastPlayerPos, 3.0, beds[i], 0, 0, 0)
    if curobjFound ~= 0 then
      local dist = #(GetEntityCoords(curobjFound) - GetEntityCoords(ped))

      if DoesEntityExist(curobjFound) then
        if dist ~= 0 and dist < near then
          near = dist
          objFound = curobjFound
        end
      end
    end
  end

  if DoesEntityExist(objFound) then
    -- TriggerEvent("DoLongHudText","Press [E] to leave the bed at any time.",1)
      loadAnimDict( "missfinale_c1@" )
      Citizen.Wait(500)

      sleeping = true
      if not disableKeys then
        showInteraction = true
        exports["np-ui"]:showInteraction("[E] Leave Bed; [F] Dismiss")
      end

    local bedOffset = vector3(-0.2, 0.1, 1.4)
    if GetEntityModel(objFound) == -289946279 or GetEntityModel(objFound) == -1519439119 then
      TaskPlayAnim( ped, "anim@gangops@morgue@table@", "body_search", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
      bedOffset = vector3(0, 0.05, 2)
    else
      TaskPlayAnim( ped, "missfinale_c1@", "lying_dead_player0", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    end

      while sleeping do
        AttachEntityToEntity(ped, objFound, 1, bedOffset.x, bedOffset.y, bedOffset.z, 0.0, 0.0, 180.0, true, true, true, true, 1, true)
        -- camOn()
        if not showInteraction and not disableKeys then
          exports["np-ui"]:hideInteraction()
        end
        Citizen.Wait(1000)
        -- SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(objFound, 0.0, 1.0, bedOffset.z + 0.8))
        -- SetCamRot(cam, -50.0, 0.0, GetEntityHeading(objFound) + 180)
    end

    if disableKeys then
      camOff()
      DetachEntity(PlayerPedId(), 1, true)
      return
    end

    exports["np-ui"]:hideInteraction()

    local counter = 0
      SetEntityHeading(GetEntityHeading(PlayerPedId()-90))
      TriggerEvent("animation:PlayAnimation","getup")
      local count=0
      while counter < 400 do
        counter = counter + 1

        if counter > 250 then
          count = count + 0.004
          AttachEntityToEntity(ped, objFound, 1, bedOffset.x+count, bedOffset.y, bedOffset.z / 2.0, 0.0, 0.0, -90.0, false, false, false, false, 0, false)
        else
          AttachEntityToEntity(ped, objFound, 1, bedOffset.x, bedOffset.y, bedOffset.z / 2.0, 0.0, 0.0, -90.0, false, false, false, false, 0, false)
        end
        Citizen.Wait(1)
      end


      camOff()
      DetachEntity(PlayerPedId(), 1, true)
      local bedcoords = GetEntityCoords(objFound) + vector3(0.0, 0.0, 1.0)
      SetEntityCoords(ped, bedcoords)



    end

end)

function camOn()
  if(not DoesCamExist(cam)) then
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)


    SetCamActive(cam,  true)

    RenderScriptCams(true,  false,  0,  true,  true)

  end
end

function camOff()
  RenderScriptCams(false, false, 0, 1, 0)
  DestroyCam(cam, false)
end

local stressDisabled = false
RegisterNetEvent("client:disableStress")
AddEventHandler("client:disableStress",function(stressNew)
  stressDisabled = stressNew
  -- if stressDisabled then
  --   TriggerServerEvent("server:resetStress")
  -- end
  -- if stressDisabled then
  --   TriggerEvent("DoLongHudText", "You feel relaxed.")
  -- else
  --   TriggerEvent("DoLongHudText", "You no longer feel relaxed.", 2)
  -- end
end)

local stressMultiplier = 0
AddEventHandler("client:stressMultiplier", function(pStressMultiplier)
  stressMultiplier = pStressMultiplier
end)
RegisterNetEvent("client:newStress")
AddEventHandler("client:newStress",function(positive, alteredValue, skipHudText)
  if stressDisabled and positive then
    -- only prevent extra stress.
    return
  end

  local nAlteredValue = alteredValue
  if stressMultiplier > 0 then
    nAlteredValue = (nAlteredValue / 2) + ((nAlteredValue / 2) * (1 - stressMultiplier))
  end

  TriggerServerEvent("server:alterStress", positive, math.ceil(nAlteredValue))
  if skipHudText then
    return
  end

  if positive then
    TriggerEvent("DoShortHudText", 'Stress Gained', 6)
  else
    TriggerEvent("DoShortHudText",'Stress Relieved', 6)
  end
end)

-- sitting event
local wasSitting = false
Citizen.CreateThread(function()
  while true do
    local isSitting = exports["np-flags"]:HasPedFlag(PlayerPedId(), "isSittingOnChair")
    if isSitting and (not wasSitting) then
      wasSitting = true
      TriggerEvent("player:sittingOnChair", true)
    elseif (not isSitting) and wasSitting then
      wasSitting = false
      TriggerEvent("player:sittingOnChair", false)
    end
    Citizen.Wait(1000)
  end
  
end)

RegisterNetEvent("stress:timed")
AddEventHandler("stress:timed",function(alteredValue,scenario)
  local removedStress = 0
  Wait(1000)

  TriggerEvent("DoShortHudText",'Stress is being relieved',6)
  exports['ragdoll']:SetMaxArmor()
  while true do
    removedStress = removedStress + 100
    if removedStress >= alteredValue then
      break
    end

    local armor = GetPedArmour(PlayerPedId())
    exports['ragdoll']:SetPlayerArmor(armor+3)

    if scenario ~= "None" then
      if not IsPedUsingScenario(PlayerPedId(),scenario) then
        TriggerEvent("animation:cancel")
        break
      end
    end
    Citizen.Wait(1000)
  end
  TriggerServerEvent("server:alterStress",false,removedStress)
end)

currentValues["oxy"] = 25.0

opacity = 0
fadein = false

stresslevel = 0

exports('getStressLevel', function()
  return stresslevel
end)

local opacityBars = 0
local Addition = 0.0

local GodEnabled = false
RegisterNetEvent("carandplayerhud:godCheck")
AddEventHandler("carandplayerhud:godCheck",function(arg)
  GodEnabled = arg
end)

HasNuiFocus, IsFocusThreadRunning = false, false

RegisterNetEvent('np-voice:focus:set')
AddEventHandler('np-voice:focus:set', function(hasFocus, hasKeyboard, hasMouse)
	HasNuiFocus = hasFocus

	if HasNuiFocus and not IsFocusThreadRunning then
		Citizen.CreateThread(function ()
      while HasNuiFocus do
        if hasKeyboard then
            DisableAllControlActions(0)
            EnableControlAction(0, 249, true)
        end

        if not hasKeyboard and hasMouse then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
        elseif hasKeyboard and not hasMouse then
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
        end

        Citizen.Wait(0)
			end
    end)
  end
end)


local HoldTime, LastStroke = 0

Citizen.CreateThread(function()
  while true do

    DisableControlAction(0, 200, true)

    Citizen.Wait(0)
  end
end)

Citizen.CreateThread(function()
  while true do

    if not IsPauseMenuActive() and IsDisabledControlJustReleased(0, 200) then
      local time  = GetGameTimer()

      HoldTime = (LastStroke and time - LastStroke > 1500) and 1 or HoldTime + 1

      if HoldTime >= 2 and not HasNuiFocus then
        HoldTime = 0
        ActivateFrontendMenu(`FE_MENU_VERSION_MP_PAUSE`, 0, 42)
      end

      LastStroke = time
    end

    Citizen.Wait(0)
  end
end)

function NotificationMessage(message)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(message)
  DrawNotification(0,1)
end

RegisterNetEvent("police:setClientMeta")
AddEventHandler("police:setClientMeta",function(meta)
  if meta == nil then return end
  if meta.thirst == nil then currentValues["thirst"] = 100 else currentValues["thirst"] = meta.thirst end
  if meta.hunger == nil then currentValues["hunger"] = 100 else currentValues["hunger"] = meta.hunger end
  if meta.health < 110.0 then
    exports['ragdoll']:SetPlayerHealth(110.0)
  else
    exports['ragdoll']:SetPlayerHealth(meta.health)
  end
  exports['ragdoll']:SetMaxArmor()
  exports['ragdoll']:SetPlayerArmor(meta.armour)
end)


RegisterNetEvent('setToMaxHungerThrist')
AddEventHandler('setToMaxHungerThrist', function()
  currentValues["thirst"] = 100
  currentValues["hunger"] = 100
end)

RegisterNetEvent('lowerthirst')
AddEventHandler('lowerthirst', function()
  currentValues["thirst"] = currentValues["thirst"] - 1

  if currentValues["thirst"] < 0 then
    currentValues["thirst"] = 0
  end

  if currentValues["thirst"] > 100 then
    currentValues["thirst"] = 100
  end
end)

RegisterNetEvent('changethirst')
AddEventHandler('changethirst', function(pNewValue)
  local value = (pNewValue and pNewValue > 0) and pNewValue or 10
  currentValues["thirst"] = currentValues["thirst"] + value

  if currentValues["thirst"] < 0 then
    currentValues["thirst"] = 0
  end

  if currentValues["thirst"] > 100 then
    currentValues["thirst"] = 100
  end

end)

RegisterNetEvent('addThirst')
AddEventHandler('addThirst', function(value)
  currentValues["thirst"] = currentValues["thirst"] + value

  if currentValues["thirst"] < 0 then
    currentValues["thirst"] = 0
  end

  if currentValues["thirst"] > 100 then
    currentValues["thirst"] = 100
  end

end)

RegisterNetEvent('coffee:drink')
AddEventHandler('coffee:drink', function()
  currentValues["thirst"] = currentValues["thirst"] + 45

  if currentValues["thirst"] < 0 then
    currentValues["thirst"] = 0
  end

  if currentValues["thirst"] > 100 then
    currentValues["thirst"] = 100
  end
end)

RegisterNetEvent('changehunger')
AddEventHandler('changehunger', function(pNewValue)
  local newValue = pNewValue or 10
  currentValues["hunger"] = currentValues["hunger"] + newValue

  if currentValues["hunger"] < 0 then
    currentValues["hunger"] = 0
  end

  if currentValues["hunger"] > 100 then
    currentValues["hunger"] = 100
  end
end)

local colorblind = false
RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
    colorblind = not colorblind
end)

local lastDamageTrigger = 0

RegisterNetEvent("fire:damageUser")
AddEventHandler("fire:damageUser", function(Reqeuester)
  local attacker = GetPlayerFromServerId(Reqeuester)
  local Attackerped = GetPlayerPed(attacker)

  if IsPedShooting(Attackerped) then
    local name = GetSelectedPedWeapon(Attackerped)
    if name == `WEAPON_FIREEXTINGUISHER` and not exports["isPed"]:isPed("dead") then
      lastDamageTrigger = GetGameTimer()
      currentValues["oxy"] = currentValues["oxy"] - 15
    end
  end
end)

local swimSpeedIncreased = false
AddEventHandler("carhud:increaseSwimSpeed", function(pIncrease)
  swimSpeedIncreased = pIncrease
  SetSwimMultiplierForPlayer(PlayerId(), pIncrease and 1.05 or 1.0)
end)
local hasChanged = false
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local plyPed = PlayerPedId()

    if IsPedSwimmingUnderWater(plyPed) then
      if currentValues["oxy"] > 0 then
        SetPedDiesInWater(plyPed, false)
        if not hasChanged then
          SetAudioSubmixEffectParamInt(0, 0, `enabled`, 1)
          hasChanged = true
        end
        if currentValues["oxy"] > 25.0 then
          currentValues["oxy"] = currentValues["oxy"] - 0.003125
        else
          currentValues["oxy"] = currentValues["oxy"] - (swimSpeedIncreased and 0.33 or 0.5)
        end
      else
        SetPedDiesInWater(plyPed, true)
      end
    end

    if (not IsPedSwimmingUnderWater(plyPed)) and hasChanged then
      SetAudioSubmixEffectParamInt(0, 0, `enabled`, 0)
      hasChanged = false
    end

    if not IsPedSwimmingUnderWater( plyPed ) and currentValues["oxy"] < 25.0 then
      if GetGameTimer() - lastDamageTrigger > 3000 then
        currentValues["oxy"] = currentValues["oxy"] + 1
        if currentValues["oxy"] > 25.0 then
          currentValues["oxy"] = 25.0
        end
      else
        if currentValues["oxy"] <= 0 then

          if exports["isPed"]:isPed("dead") then
            lastDamageTrigger = -7000
            currentValues["oxy"] = 25.0
          else
            exports['ragdoll']:SetPlayerHealth(GetEntityHealth(plyPed) - 20)
          end
        end
      end
    end

    if currentValues["oxy"] > 25.0 and (not oxyOn) and (useBlackOxy) then
      oxyOn = true
      attachProp("p_s_scuba_tank_s_black", 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)
      attachProp2("p_s_scuba_mask_s_black", 12844, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0)
    elseif currentValues["oxy"] > 25.0 and not oxyOn then
      oxyOn = true
      attachProp("p_s_scuba_tank_s", 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)
      attachProp2("p_s_scuba_mask_s", 12844, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0)
    elseif oxyOn and currentValues["oxy"] <= 25.0 then
      oxyOn = false
      removeAttachedProp()
      removeAttachedProp2()
      useBlackOxy = false
    end
    if not oxyOn then
      if IsPedSwimming(plyPed) then
        ResetPlayerStamina(plyPed)
      end
      Wait(200)
    else
      if (IsPedRunning(plyPed) or IsPedSprinting(plyPed)) and not IsPedSwimming(plyPed) then
        DisableControlAction(0, 21, true)
      end
    end
  end
end)

function lerp(min, max, amt)
  return (1 - amt) * min + amt * max
end

function rangePercent(min, max, amt)
  return (((amt - min) * 100) / (max - min)) / 100
end

-- this should just use nui instead of drawrect - it literally ass fucks usage.
Citizen.CreateThread(function()
  -- local minimap = RequestScaleformMovie("minimap")
  local counter = 0
  local get_ped = PlayerPedId() -- current ped
  local get_ped_veh = GetVehiclePedIsIn(get_ped,false) -- Current Vehicle ped is in
  local plate_veh = GetVehicleNumberPlateText(get_ped_veh) -- Vehicle Plate
  local veh_stop = IsVehicleStopped(get_ped_veh) -- Parked or not
  local veh_engine_health = GetVehicleEngineHealth(get_ped_veh) -- Vehicle Engine Damage
  local veh_body_health = GetVehicleBodyHealth(get_ped_veh)
  local veh_burnout = IsVehicleInBurnout(get_ped_veh) -- Vehicle Burnout
  local thespeed = GetEntitySpeed(get_ped_veh) * 3.6
  currentValues["parachute"] = HasPedGotWeapon(get_ped, `gadget_parachute`, false)

  local huntingRifleHash = `weapon_sniperrifle2` -- -646649097

  while true do

    if sleeping and not BedKeysDisabled then
      if IsControlJustReleased(0,38) then
        sleeping = false
        DetachEntity(PlayerPedId(), 1, true)
      end
      if IsControlJustReleased(0,75) then
        showInteraction = false
      end
    end

    Citizen.Wait(0)

    if counter == 0 then
       -- current ped
      get_ped = PlayerPedId()
      SetPedSuffersCriticalHits(get_ped,true)
      get_ped_veh = GetVehiclePedIsIn(get_ped,false) -- Current Vehicle ped is in
      plate_veh = GetVehicleNumberPlateText(get_ped_veh) -- Vehicle Plate
      veh_stop = IsVehicleStopped(get_ped_veh) -- Parked or not
      veh_engine_health = GetVehicleEngineHealth(get_ped_veh) -- Vehicle Engine Damage
      veh_body_health = GetVehicleBodyHealth(get_ped_veh)
      veh_burnout = IsVehicleInBurnout(get_ped_veh) -- Vehicle Burnout
      thespeed = GetEntitySpeed(get_ped_veh) * 3.6
      currentValues["stress"] = math.ceil(stresslevel / 100)
      currentValues["parachute"] = HasPedGotWeapon(get_ped, `gadget_parachute`, false)


      if currentValues["stress"] > 100 then currentValues["stress"] = 100 end

      if currentValues["hunger"] < 0 then
        currentValues["hunger"] = 0
      end
      if currentValues["thirst"] < 0 then
        currentValues["thirst"] = 0
      end

      if currentValues["hunger"] > 100 then currentValues["hunger"] = 100 end

      if currentValues["thirst"] > 100 then currentValues["thirst"] = 100 end
      local valueChanged = false

      if currentValues["oxy"] <= 0 then currentValues["oxy"] = 0 end

      for k,v in pairs(currentValues) do
        if lastValues[k] == nil or lastValues[k] ~= v then
          valueChanged = true
          lastValues[k] = v
        end
      end
      if valueChanged then
        -- TriggerEvent("np-ui:hud:values", currentValues)
        exports["np-ui"]:sendAppEvent("hud", {
            food = currentValues["hunger"],
            oxygen = currentValues["oxy"],
            oxygenShow = currentValues["oxy"] and currentValues["oxy"] ~= 25,
            stress = currentValues["stress"],
            water = currentValues["thirst"],
        })
        -- SendNUIMessage({
        --   type = "updateStatusHud",
        --   hasParachute = currentValues["parachute"],
        --   varSetHealth = currentValues["health"],
        --   varSetArmor = lerp(0,100, rangePercent(0,60,currentValues["armor"])),
        --   varSetHunger = currentValues["hunger"],
        --   varSetThirst = currentValues["thirst"],
        --   varSetOxy = currentValues["oxy"],
        --   varSetStress = currentValues["stress"],
        --   colorblind = colorblind,
        --   varSetVoice = currentValues["voice"],
        --   varDev = currentValues["dev"],
        --   varDevDebug = currentValues["devdebug"],
        --   varCrosshair = currentValues["crosshair"],
        -- })
      end

      counter = 360

    end

    counter = counter - 1

    if get_ped_veh ~= 0 then
      local model = GetEntityModel(get_ped_veh)
      local roll = GetEntityRoll(get_ped_veh)

      if not IsThisModelABoat(model)
        and not IsThisModelAHeli(model)
        and not IsThisModelAPlane(model)
        and not IsThisModelABicycle(model)
        and not IsThisModelABike(model)
        and not IsThisModelAJetski(model)
        and not IsThisModelAQuadbike(model)
        and not flyingCars[model]
        and (IsEntityInAir(get_ped_veh) or (roll < -50 or roll > 50)) then
          DisableControlAction(0, 59) -- leaning left/right
          DisableControlAction(0, 60) -- leaning up/down
      end

      if GetPedInVehicleSeat(GetVehiclePedIsIn(get_ped, false), 0) == get_ped then
        if GetIsTaskActive(get_ped, 165) then
          SetPedIntoVehicle(get_ped, GetVehiclePedIsIn(get_ped, false), 0)
        end
      end
    end
    -- BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
    -- ScaleformMovieMethodAddParamInt(3)
    -- EndScaleformMovieMethod()
  end
end)

Citizen.CreateThread(function()
  local hadCrosshair = false
  local exemptHashes = {
    [`weapon_sniperrifle2`] = true,
    [100416529] = true,
    [-1536150836] = true,
  }
  while true do
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local hasCrosshair =  IsPedArmed(PlayerPedId(), 6)
                      and IsPlayerFreeAiming(PlayerId())
                      and not exemptHashes[GetSelectedPedWeapon(PlayerPedId())]
    if hasCrosshair then
      if GetFollowPedCamViewMode() == 4 and veh == 0 then
        hasCrosshair = false
      end
      if veh ~= 0 and 
        ((GetFollowVehicleCamViewMode() ~= 4 and GetFollowPedCamViewMode() ~= 4)
        or not IsPedDoingDriveby(PlayerPedId()))
      then
        hasCrosshair = false
      end
    end
    if hadCrosshair ~= hasCrosshair then
      hadCrosshair = hasCrosshair
      exports["np-ui"]:sendAppEvent("hud", {
        crosshairShow = hasCrosshair,
      })
    end
    Citizen.Wait(250)
  end
end)

RegisterNetEvent('hud:saveCurrentMeta')
AddEventHandler('hud:saveCurrentMeta', function()
  TriggerServerEvent("police:setServerMeta",GetEntityHealth(PlayerPedId()),GetPedArmour(PlayerPedId()),currentValues["thirst"],currentValues["hunger"])
end)

local buffStartTime = 0
local buffItems = {
  ["craftedgemjade"] = true,
}
AddEventHandler("buffs:triggerBuff", function(item)
  if not buffItems[item] then return end
  if buffStartTime ~= 0 then return end
  buffStartTime = GetGameTimer()
  TriggerEvent("np-buffs:addUIBuff", { buffedHunger = true, buffedThirst = true })
  Citizen.CreateThread(function()
    Citizen.Wait(60000 * 60 * 6) -- 6hr
    buffStartTime = 0
    TriggerEvent("np-buffs:addUIBuff", { buffedHunger = false, buffedThirst = false })
  end)
end)

local buffHungerMultiplier = 0
AddEventHandler("carhud:slowHunger", function(percent)
  buffHungerMultiplier = percent
end)

local citrineStartTime = 0
local citrineBuffItems = {
  ["craftedgemcitrine"] = true,
}
AddEventHandler("buffs:triggerBuff", function(item)
  if not citrineBuffItems[item] then return end
  if citrineStartTime ~= 0 then return end
  citrineStartTime = GetGameTimer()
  TriggerEvent("np-buffs:addUIBuff", { buffedHealth = true, buffedArmor = true })
  Citizen.CreateThread(function()
    Citizen.Wait(60000 * 60 * 6) -- 3hr
    citrineStartTime = 0
    TriggerEvent("np-buffs:addUIBuff", { buffedHealth = false, buffedArmor = false })
  end)
end)
Citizen.CreateThread(function()
  while true do
    if citrineStartTime ~= 0 and (not stressIsDead) then
      DepleteFood()
      exports['ragdoll']:SetPlayerHealth(GetEntityHealth(PlayerPedId()) + 4, true)
      exports['ragdoll']:SetPlayerArmor(GetPedArmour(PlayerPedId()) + 4)
    end
    Citizen.Wait(12000)
  end
end)

function DepleteFood()
  local pedid = PlayerPedId()
  local maxHealth = GetPedMaxHealth(pedid)
  if math.random(30) == 1 then
    if currentValues["hunger"] > 0 then
      currentValues["hunger"] = currentValues["hunger"] - math.random(3)
    end
    if currentValues["thirst"] > 0 then
      currentValues["thirst"] = currentValues["thirst"] - math.random(3)
    end
  end
end


local itemCooldownExpiresAt = 0
local chapReductionTime = 60000 * 60 * 2 -- Two hours

AddEventHandler("np-inventory:itemUsed", function(item)
  if item ~= "bobmulet_chapstick" then return end

  if GetGameTimer() < itemCooldownExpiresAt then
    TriggerEvent("DoLongHudText", "You need to wait before you can do that!", 2)
    return
  end

  local finished = exports["np-taskbar"]:taskBar(4000, "Using Chapstick")
  if finished ~= 100 then
    ClearPedTasks(PlayerPedId())
    TriggerEvent("DoLongHudText", "Chapstick Cancelled", 2)
    return
  end

  itemCooldownExpiresAt = GetGameTimer() + chapReductionTime
  TriggerEvent("inventory:removeItem", "bobmulet_chapstick", 1)
end)

Citizen.CreateThread(function()
  while true do
    if currentValues["hunger"] > 0 then
      currentValues["hunger"] = currentValues["hunger"] - math.random(3)
    end
    if currentValues["thirst"] > 0 then

      if GetGameTimer() < itemCooldownExpiresAt then
        currentValues["thirst"] = currentValues["thirst"] - 0.7 -- 30% Reduction for `chapReductionTime` time
      else
        currentValues["thirst"] = currentValues["thirst"] - 1
      end

    end

    if GodEnabled then currentValues["hunger"] = 100 end
    if GodEnabled then currentValues["thirst"] = 100 end

    if currentValues["thirst"] < 20 or currentValues["hunger"] < 20 then
      local newhealth = GetEntityHealth(PlayerPedId()) - math.random(10)
      exports['ragdoll']:SetPlayerHealth(newhealth)
    end
			
    if currentValues["thirst"] < 2 or currentValues["hunger"] < 2 then
      local newhealth = GetEntityHealth(PlayerPedId()) - math.random(50)
      exports['ragdoll']:SetPlayerHealth(math.max(newhealth, 1))
    end

    TriggerServerEvent(
      "police:setServerMeta",
      GetEntityHealth(PlayerPedId()),
      GetPedArmour(PlayerPedId()),
      currentValues["thirst"],
      currentValues["hunger"]
    )
    local hungerDecayTimer = 300000
    Citizen.Wait(hungerDecayTimer)
    if buffStartTime ~= 0 then
      Citizen.Wait(hungerDecayTimer / 4)
    elseif buffHungerMultiplier > 0 then
      Citizen.Wait(hungerDecayTimer / (2 + (1 - buffHungerMultiplier)))
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)
    ped = PlayerPedId()
    if not IsPedInAnyVehicle(plyr, false) then
      if IsPedUsingActionMode(ped) then
        SetPedUsingActionMode(ped, -1, -1, 1)
      end
    else
      Citizen.Wait(3000)
    end
  end
end)

Citizen.CreateThread( function()
  local resetcounter = 0
  local jumpDisabled = false

  while true do
    Citizen.Wait(100)
    if jumpDisabled and resetcounter > 0 and IsPedJumping(PlayerPedId()) then
      SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
      resetcounter = 0
    end

    if not jumpDisabled and IsPedJumping(PlayerPedId()) then
      jumpDisabled = true
      resetcounter = 10
      Citizen.Wait(1200)
    end

    if resetcounter > 0 then
      resetcounter = resetcounter - 1
    else
      if jumpDisabled then
        resetcounter = 0
        jumpDisabled = false
      end
    end
  end
end)

AddEventHandler("carhud:focus", function()
  SetNuiFocus(true, false)
  Wait(1)
  SetNuiFocus(false, false)
end)

local recentlyStolenShoes = {}
local shoeCooldown = 60000 * 5 -- 5 Minute cooldown for this player
RegisterNetEvent("shoes:steal")
AddEventHandler("shoes:steal", function(pArgs, pEntity)
  if recentlyStolenShoes[pEntity] ~= nil and (GetGameTimer() - recentlyStolenShoes[pEntity]) < shoeCooldown then
    return TriggerEvent("DoLongHudText", "Need to wait before trying to steal their shoes again!", 1)
  end
  
  recentlyStolenShoes[pEntity] = GetGameTimer()
  loadAnimDict('random@domestic')
  TaskTurnPedToFaceEntity(PlayerPedId(), pEntity, -1)
  TaskPlayAnim(PlayerPedId(),'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  Citizen.Wait(1600)
  ClearPedTasks(PlayerPedId())
  TriggerServerEvent("np-clothing:removeShoes", GetPlayerServerId(NetworkGetPlayerIndexFromPed(pEntity)))
  TriggerEvent("player:receiveItem", "-828058162", 2)
end)

RegisterNetEvent("np-police:cuffs:state")
AddEventHandler("np-police:cuffs:state", function(pIsHandcuffed, pIsHandcuffedAndWalking)
    isHandcuffedAndWalking = pIsHandcuffedAndWalking
    isHandcuffed = pIsHandcuffed
end)

local inVehicle = false
local isDriver = false
local turbulenceMin = 9.2
local turbulenceMax = 19.2

RegisterNetEvent("baseevents:enteredVehicle")
AddEventHandler("baseevents:enteredVehicle", function(pVehicle)
  local vehicleModel = GetEntityModel(pVehicle)
  local ped = PlayerPedId()
  inVehicle = true

  SetHeliTurbulenceScalar(pVehicle, 0.1)

  local myJob = exports["isPed"]:isPed("myJob")
  if myJob == "police" or myJob == "ems" then
    return
  end

  local hasLicense = exports["np-gov"]:HasLicense("pilot_license")
  if hasLicense then
    return
  end

  Citizen.CreateThread(function()
    while inVehicle do
      local driverPed = GetPedInVehicleSeat(pVehicle, -1)
      isDriver = driverPed == ped

      if not isDriver then
        goto continue
      end

      if IsThisModelAHeli(vehicleModel) then
        local height = GetEntityHeightAboveGround(pVehicle)
        if height >= 10.0 and IsThisModelAHeli(GetEntityModel(pVehicle)) then
          local turbulence = turbulenceMin + ((height / 100) * 20.0)
          if turbulence < turbulenceMin then turbulence = turbulenceMin end
          if turbulence > turbulenceMax then turbulence = turbulenceMax end
          SetHeliTurbulenceScalar(pVehicle, turbulence)
        end
      end

      if IsThisModelAPlane(vehicleModel) then
        TriggerEvent('DoLongHudText', 'I cannot operate this vehicle.', 2)
        SetVehicleEngineOn(pVehicle,0,1,1)
        SetVehicleUndriveable(pVehicle,true)
      end

      ::continue::
      Wait(1000)
    end
    SetHeliTurbulenceScalar(pVehicle, 0.1)
  end)
end)

RegisterNetEvent("baseevents:leftVehicle")
AddEventHandler("baseevents:leftVehicle", function()
  inVehicle = false
end)

-- delete when fat siz isn't fat
local isFatSizEnabled = true
RegisterCommand("togglefatsiztyres", function()
    isFatSizEnabled = not isFatSizEnabled
end)

local isGettingUpRunning = false
function gettingUpThread()
  if isGettingUpRunning then return end
  isGettingUpRunning = true
  Citizen.CreateThread(function()
    while true do
      if IsPedGettingUp(PlayerPedId()) and math.random() < 0.2 then
        ClearPedTasksImmediately(PlayerPedId())
        SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
      end
      Citizen.Wait(1000)
    end
  end)
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if isFatSizEnabled and GetEntityModel(ped) == `ig_siz_fat` and IsPedInAnyVehicle(ped) then
            gettingUpThread()
            local veh = GetVehiclePedIsIn(ped)
            local model = GetEntityModel(veh)
            local mapping = {
                [-1] = 0,
                [0] = 1,
                [1] = 4,
                [2] = 5,
            }
            if IsThisModelABike(model) then
                mapping = {
                    [-1] = 4,
                    [0] = 4,
                }
            end
            if IsThisModelAQuadbike(model) then
                mapping = {
                    [-1] = 0,
                    [0] = 0,
                }
            end
            
            local chance = 0.1
            if IsThisModelAQuadbike(model) then
                chance = 0.04
            end
            if IsThisModelACar(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
                local i = -1
                while i < 6 do
                    local seatPed = GetPedInVehicleSeat(veh, i)
                    local tyre = mapping[i]
                    if tyre and seatPed == ped and not IsVehicleTyreBurst(veh, tyre, false) and math.random() < chance then
                        Citizen.CreateThread(function()
                            if not NetworkHasControlOfEntity(veh) then
                                local vehicleOwnerId = NetworkGetEntityOwner(veh)
                                TriggerServerEvent("vehicle:poptire", GetPlayerServerId(vehicleOwnerId), VehToNet(veh), tyre)
                            else
                                SetVehicleTyreBurst(veh, tyre, true, 1000.0)
                            end
                        end)
                    end
                    i = i + 1
                end
            end
        end
        Citizen.Wait(60000)
    end
end)

RegisterNetEvent("vehicle:poptire")
AddEventHandler("vehicle:poptire", function(pVehicle, pTire)
    SetVehicleTyreBurst(NetToVeh(pVehicle), pTire, true, 1000.0)
end)

exports('GetHunger', function()
    return currentValues["hunger"]
end)
