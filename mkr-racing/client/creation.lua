local creating = false
local radius = 4.0

local raceName = nil
local raceType = nil
local raceCategory = nil
local raceThumbnail = nil
local raceMinLaps = nil
local checkpoints = {}
local blips = {}
local object1, object2

local function changeRadius(dir)
  if dir == "up" then
    radius = radius + 0.1
  elseif dir == "down" then
    radius = math.max(radius - 0.1, 1.0)
  end
end

local function changeRotation(dir)
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  local head = GetEntityHeading(veh)
  if dir == "left" then
    SetEntityHeading(veh, head + 1.0)
  elseif dir == "right" then
    SetEntityHeading(veh, head - 1.0)
  end
end

local function updateObjects()
  if object1 == nil then
    return
  end

  local plyPed = PlayerPedId()

  local coords = GetEntityCoords(plyPed)
  local heading = GetEntityHeading(plyPed)

  local objPos1, objPos2 = getCheckpointObjectPositions(coords, radius, heading)

  SetEntityCoords(object1, objPos1, 0.0, 0.0, 0.0, false)
  SetEntityCoords(object2, objPos2, 0.0, 0.0, 0.0, false)

  PlaceObjectOnGroundProperly(object1)
  PlaceObjectOnGroundProperly(object2)
end

local function spawnObjects(start)
  if object1 ~= nil then
    cleanupObjects()
  end

  local cpobject

  if start then
    cpobject = config.startObjectHash
  else
    cpobject = config.checkpointObjectHash
  end

  RequestModelAndLoad(cpobject)

  local plyPed = PlayerPedId()

  local coords = GetEntityCoords(plyPed)
  local heading = GetEntityHeading(plyPed)

  local objPos1, objPos2 = getCheckpointObjectPositions(coords, radius, heading)

  object1 = CreateObjectNoOffset(cpobject, objPos1, false, false, false)
  object2 = CreateObjectNoOffset(cpobject, objPos2, false, false, false)

  PlaceObjectOnGroundProperly(object1)
  PlaceObjectOnGroundProperly(object2)

  SetEntityCollision(object1, false, false)
  SetEntityCollision(object2, false, false)

  SetModelAsNoLongerNeeded(cpobject)
end

local function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 340
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

local function addCheckpoint()
  local pos = GetEntityCoords(PlayerPedId())
  local heading = GetEntityHeading(PlayerPedId())

  checkpoints[#checkpoints+1] = {
    pos = {
      x = tonumber(string.format("%.3f", pos.x)),
      y = tonumber(string.format("%.3f", pos.y)),
      z = tonumber(string.format("%.3f", pos.z)),
    },
    hdg = tonumber(string.format("%.3f", heading)),
    rad = tonumber(string.format("%.3f", radius))
  }

  PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)

  if #checkpoints == 1 then
    spawnObjects(false)
  end

  local blip = AddBlipForCoord(pos)

  ShowNumberOnBlip(blip, #checkpoints)
  SetBlipDisplay(blip, 8)
  SetBlipScale(blip, 1.0)
  SetBlipAsShortRange(blip, true)

  blips[#blips + 1] = blip

  print("Checkpoint Added")
end

local function removeCheckpoint()
  if #checkpoints == 0 then
    print("No checkpoints remain")
    return
  end

  checkpoints[#checkpoints] = nil

  PlaySound(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)

  if #checkpoints < 1 then
    spawnObjects(true)
  end

  RemoveBlip(blips[#blips])
  blips[#blips] = nil

  print("Checkpoint Removed")
end

function clearCreationBlips()
  for i=1, #blips do
    RemoveBlip(blips[i])
  end
  blips = {}
end

function startRaceCreation(options)
  options = options or {}
  raceName = options.raceName
  if raceName == nil then raceName = KBInput("Race Name", "", 30) end
  while raceName ~= nil and options.raceName == nil and RPC.execute("mkr_racing:isRaceNameTaken", raceName) == true do
    raceName = KBInput("Name already taken, try again", "", 30)
  end
  if raceName == nil then return end

  raceType = options.raceType
  if raceType == nil or (raceType ~= "Sprint" and raceType ~= "Lap") then
    ::typecheck::
    racetype = KBInput("Is this a Sprint race? (y/n)", "", 1)

    if racetype ~= "y" and racetype ~= "n" and racetype ~= nil then
      goto typecheck
    end
    if racetype == nil then return end

    if racetype == "y" then
      raceType = "Sprint"
    else
      raceType = "Lap"
    end
  end

  raceCategory = options.raceCategory
  if raceCategory == nil then raceCategory = KBInput("Race Category", "", 30) end
  if raceCategory == nil then return end

  raceThumbnail = options.raceThumbnail
  if raceThumbnail == nil then raceThumbnail = KBInput("Thumbnail URL", "", 30) end
  if raceThumbnail == nil then return end

  raceMinLaps = options.raceMinLaps
  if raceMinLaps == nil then raceMinLaps = KBInput("Min Laps", "", 30) end
  if raceMinLaps == nil then return end

  creating = true
  spawnObjects(true)
  CreateThread(function()
    while creating do
      if IsControlPressed(0, 172) then
        changeRadius("up")
      end
      if IsControlPressed(0, 173) then
        changeRadius("down")
      end
      if IsControlPressed(0, 174) then
        if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) <= 0 then
          changeRotation("left")
        end
      end
      if IsControlPressed(0, 175) then
        if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) <= 0 then
          changeRotation("right")
        end
      end
      if not IsControlPressed(0, 21)and IsControlJustPressed(0, 51) then
        addCheckpoint()
      end
      if IsControlPressed(0, 21) and IsControlJustPressed(0, 51) then
        removeCheckpoint()
      end
      Wait(0)
    end
  end)

  CreateThread(function()
    local ped = PlayerPedId()
    while creating do
      local pos = GetEntityCoords(ped)
      local rot = GetEntityHeading(PlayerPedId())

      DrawMarker(26, pos.x, pos.y, pos.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, rot, radius * 2, radius * 2, 5.0, 255, 128, 0, 25, false, false, 2, nil, nil, false)
      updateObjects()
      Wait(0)
    end
  end)

  CreateThread(function()
    local ped = PlayerPedId()
    while creating do
      local pos = GetEntityCoords(ped)
      local instructions = "#" .. tostring(#checkpoints) .. " | [E] Add | [Shift+E] Remove | ⬆ Radius ⬇ | ⬅ Rotation ➡"
      DrawText3Ds(pos.x, pos.y, pos.z + 1.5, instructions)
      Wait(0)
    end
  end)
end

function finishRaceCreation()
  if not creating then
    print("You are not creating a race")
    return
  end

  TriggerServerEvent("mkr_racing:recieveCreateData", raceName, raceType, raceCategory, raceThumbnail, raceMinLaps, checkpoints)

  cleanupCreation()
end

function cancelRaceCreation()
  if not creating then
    print("You are not creating a race")
    return
  end

  cleanupCreation()
end

function cleanupObjects()
  DeleteObject(object1)
  DeleteObject(object2)
  object1, object2 = nil, nil
end

function cleanupCreation()
  creating = false
  radius = 4.0
  raceName = nil
  raceType = nil
  raceThumbnail = nil
  checkpoints = {}
  cleanupObjects()
  clearCreationBlips()
end

RegisterNetEvent("mkr_racing:cmd:racecreate")
AddEventHandler("mkr_racing:cmd:racecreate", function(options)
  if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
    startRaceCreation(options)
  end
end)

RegisterNetEvent("mkr_racing:cmd:racecreatedone")
AddEventHandler("mkr_racing:cmd:racecreatedone", function()
  finishRaceCreation()
end)

RegisterNetEvent("mkr_racing:cmd:racecreatecancel")
AddEventHandler("mkr_racing:cmd:racecreatecancel", function()
  cancelRaceCreation()
end)

AddEventHandler("onResourceStop", function(resource)
  if resource ~= GetCurrentResourceName() then
    return
  end

  cleanupCreation()
end)
