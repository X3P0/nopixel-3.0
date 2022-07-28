local sin, cos, atan2, abs, rad, deg = math.sin, math.cos, math.atan2, math.abs, math.rad, math.deg
local EARLY_STOP_MULTIPLIER = 0.5
local DEFAULT_GTA_FALL_DISTANCE = 8.3
local DEFAULT_OPTIONS = {waitTime=0.5, grappleSpeed=20.0}

Grapple = {}

--[[ Utility Functions ]]
local function DirectionToRotation(dir, roll)
  local x, y, z
  z = -deg(atan2(dir.x, dir.y))
  local rotpos = vector3(dir.z, #vector2(dir.x, dir.y), 0.0)
  x = deg(atan2(rotpos.x, rotpos.y))
  y = roll
  return vector3(x, y, z)
end

local function RotationToDirection(rot)
  local rotZ = rad(rot.z)
  local rotX = rad(rot.x)
  local cosOfRotX = abs(cos(rotX))
  return vector3(-sin(rotZ) * cosOfRotX, cos(rotZ) * cosOfRotX, sin(rotX))
end

local function RayCastGamePlayCamera(dist)
  local camRot = GetGameplayCamRot()
  local camPos = GetGameplayCamCoord()
  local dir = RotationToDirection(camRot)
  local dest = camPos + (dir * dist)
  local ray = StartShapeTestRay(camPos, dest, 17, -1, 0)
  local _, hit, endPos, surfaceNormal, entityHit = GetShapeTestResult(ray)
  if hit == 0 then endPos = dest end
  return hit, endPos, entityHit, surfaceNormal
end

function GrappleCurrentAimPoint(dist)
  return RayCastGamePlayCamera(dist)
end

-- TODO: This can eventually be removed once the logic is fully tested
local function DrawSphere(pos, radius, r, g, b, a)
  DrawMarker(28, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, r, g, b, a, false, false, 2, nil, nil, false)
end

-- Fill in defaults for any options that aren't present
local function _ensureOptions(options)
  for k, v in pairs(DEFAULT_OPTIONS) do
    if options[k] == nil then options[k] = v end
  end
end

local function _waitForFall(pid, ped, stopDistance)
  SetPlayerFallDistance(pid, 10.0)
  while GetEntityHeightAboveGround(ped) > stopDistance do
    SetPedCanRagdoll(ped, false)
    Wait(0)
  end
  SetPlayerFallDistance(pid, DEFAULT_GTA_FALL_DISTANCE)
end

local function PinRope(rope, ped, boneId, dest)
  PinRopeVertex(rope, 0, dest)
  PinRopeVertex(rope, GetRopeVertexCount(rope) - 1, GetPedBoneCoords(ped, boneId, 0.0, 0.0, 0.0))
end

-- local concealedPlayer = false
-- RegisterCommand("conceal", function(s, pargs)
--   concealedPlayer = true
--   Citizen.CreateThread(function()
--     while concealedPlayer do
--       NetworkConcealPlayer(GetPlayerFromServerId(tonumber(pargs[1])), true, false)
--       Wait(0)
--     end
--   end)
-- end, false)
-- RegisterCommand("unconceal", function(s, pargs)
--   concealedPlayer = false
--   NetworkConcealPlayer(GetPlayerFromServerId(tonumber(pargs[1])), false, false)
-- end, false)
function Grapple.new(dest, options)
  local self = {}
  options = options or {}
  _ensureOptions(options)
  local grappleId = math.random((-2^32)+1, 2^32-1)
  if options.grappleId then
    grappleId = options.grappleId
  end
  local pid = PlayerId()
  if options.plyServerId then
    pid = GetPlayerFromServerId(options.plyServerId)
  end
  
  local ped = GetPlayerPed(pid)
  local oldPedRef = ped
  local start = GetEntityCoords(ped)
  local notMyPed = options.plyServerId and options.plyServerId ~= GetPlayerServerId(PlayerId())
  local fromStartToDest = dest - start
  local dir = fromStartToDest / #fromStartToDest
  local length = #fromStartToDest
  local finished = false
  local rope
  if pid ~= -1 then
    rope = AddRope(dest, 0.0, 0.0, 0.0, 0.0, 5, 0.0, 0.0, 1.0, false, false, false, 5.0, false)
    local headingToSet = GetEntityHeading(ped)
    ped = ClonePed(ped, 0, 0, 0)
    TriggerEvent("np-grapple:addPedId", ped)
    SetEntityHeading(ped, headingToSet)
    SetEntityAlpha(oldPedRef, 0, 0)
  end

  local function _setupDestroyEventHandler()
    local event = nil
    local eventName = 'mka-grapple:ropeDestroyed:' .. tostring(grappleId)
    RegisterNetEvent(eventName)
    event = AddEventHandler(eventName, function()
      self.destroy(false)
      RemoveEventHandler(event)
    end)
  end

  function self._handleRope(rope, ped, boneIndex, dest)
    Citizen.CreateThread(function ()
      while not finished do
        PinRope(rope, ped, boneIndex, dest)
        Wait(0)
      end
      DeleteChildRope(rope)
      DeleteRope(rope)
    end)
  end

  function self.activateSync()
    if pid == -1 then return end
    local distTraveled = 0.0
    local currentPos = start
    local lastPos = currentPos
    local rotationMultiplier = -1
    local rot = DirectionToRotation(-dir * rotationMultiplier, 0.0)
    local lastRot = rot
    -- Offset pitch 90 degrees so player is facedown
    rot = rot + vector3(90.0 * rotationMultiplier, 0.0, 0.0)
    Wait(options.waitTime * 1000)
    while not finished and distTraveled < length do
      local fwdPerFrame = dir * options.grappleSpeed * GetFrameTime()
      distTraveled = distTraveled + #fwdPerFrame
      if distTraveled > length then
        distTraveled = length
        currentPos = dest
      else
        currentPos = currentPos + fwdPerFrame
      end
      SetEntityCoords(ped, currentPos)
      SetEntityRotation(ped, rot)
      if distTraveled > 3 and HasEntityCollidedWithAnything(ped) == 1 then
        SetEntityCoords(ped, lastPos - (dir * EARLY_STOP_MULTIPLIER))
        SetEntityRotation(ped, lastRot)
        break
      end
      lastPos = currentPos
      lastRot = rot
      if not notMyPed then
        SetGameplayCamFollowPedThisUpdate(ped)
      end
      Wait(0)
    end
    if not notMyPed then
      SetEntityCoords(oldPedRef, GetEntityCoords(ped))
      SetEntityRotation(oldPedRef, GetEntityRotation(ped))
    else
      FreezeEntityPosition(ped, true, true)
    end
    self.destroy()
    _waitForFall(pid, ped, 3.0)
  end

  function self.activate()
    CreateThread(self.activateSync)
  end

  function self.destroy(shouldTriggerDestroyEvent)
    finished = true
    if shouldTriggerDestroyEvent or shouldTriggerDestroyEvent == nil then
      if pid ~= -1 then
        Citizen.CreateThread(function()
          if notMyPed then
            loopCount = 0
            while #(GetEntityCoords(ped) - GetEntityCoords(oldPedRef)) > 2 and (loopCount < 20) do
              loopCount = loopCount + 1
              Wait(32)
            end
          end
          TriggerEvent("np-grapple:addPedId", nil)
          DeleteEntity(ped)
          SetEntityAlpha(oldPedRef, 255, 0)
        end)
      end
      -- Should trigger if shouldTriggerDestroyEvent is true or nil (not passed)
      TriggerServerEvent('mka-grapple:destroyRope', grappleId)
    end
  end

  if pid ~= -1 then
    self._handleRope(rope, ped, 0x49D9, dest)
    if notMyPed then
      self.activate()
    end
  end
  if options.plyServerId == nil then
    TriggerServerEvent('mka-grapple:createRope', grappleId, dest)
  else
    _setupDestroyEventHandler()
  end
  return self
end

--[[ Testing Thread ]]
-- Citizen.CreateThread(function ()
--   while true do
--     local hit, pos, _, _ = RayCastGamePlayCamera(MAX_DISTANCE)
--     if hit == 1 then
--       DrawSphere(pos, 0.1, 255, 0, 0, 255)
--       if IsControlJustReleased(0, 51) then
--         local grapple = Grapple.new(pos)
--         grapple.activate()
--       end
--     end
--     Wait(0)
--   end
-- end)
