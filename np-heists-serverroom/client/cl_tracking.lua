local myEvents = {}
local isTracking = false
local trackingIndex = 1

function sendToServerThread()
  trackingIndex = 1
  Citizen.CreateThread(function()
    local sendToServer = {}
    local lastTrackingIndex = 1
    while isTracking do
      Wait(10000)
      local value = myEvents[trackingIndex]
      while value do
        sendToServer[#sendToServer + 1] = value
        if trackingIndex - lastTrackingIndex > 10 then
          TriggerServerEvent("np-heists-serverroom:trackPlayerDamage", sendToServer)
          Wait(100)
          lastTrackingIndex = trackingIndex
        end
        trackingIndex = trackingIndex + 1
        value = myEvents[trackingIndex]
      end
    end
  end)
end

function StartTracking()
  isTracking = true
  sendToServerThread()
end
function EndTracking()
  isTracking = false
end

local cid = 0
Citizen.CreateThread(function()
  while true do
    cid = exports["isPed"]:isPed("cid")
    Wait(60000)
  end
end)

AddEventHandler("DamageEvents:EntityDamaged", function(victim, attacker, pWeapon)
  if not isTracking then return end
  local playerPed = PlayerPedId()
  if victim ~= playerPed then
    return
  end
  local myCoords = GetEntityCoords(victim)
  local myHeading = GetEntityHeading(victim)
  local theirCoords = GetEntityCoords(attacker)
  local theirHeading = GetEntityHeading(attacker)
  -- myEvents[#myEvents + 1] = {
  --   cid = cid,
  --   myCoords = myCoords,
  --   myHeading = myHeading,
  --   theirCoords = theirCoords,
  --   theirHeading = theirHeading,
  --   weapon = pWeapon,
  -- }
  TriggerServerEvent("np-heists-serverroom:trackPlayerDamage", {{
    cid = cid,
    myCoords = myCoords,
    myHeading = myHeading,
    theirCoords = theirCoords,
    theirHeading = theirHeading,
    weapon = pWeapon,
  }})
end)

local myId = 0
local colors = {}
function drawData(data)
  myId = myId + 1
  local drawId = myId + 0
  colors[drawId] = {
    r = math.random(0, 255),
    g = math.random(0, 255),
    b = math.random(0, 255),
  }
  Wait(0)
  Citizen.CreateThread(function()
    while true do
      local myCoords = vector3(data.myCoords.x, data.myCoords.y, data.myCoords.z)
      local theirCoords = vector3(data.theirCoords.x, data.theirCoords.y, data.theirCoords.z)
      if #(theirCoords - vector3(0.0, 0.0, 0.0)) > 10 then
        DrawLine(myCoords, theirCoords, colors[drawId].r, colors[drawId].g, colors[drawId].b, 255)
        DrawText3D(theirCoords.x, theirCoords.y, theirCoords.z,
          "AI - heading: " .. math.floor(data.theirHeading)) -- .. " coords: " .. theirCoords.x .. " - " .. theirCoords.y .. " - " .. theirCoords.z)
        DrawText3D(myCoords.x, myCoords.y, myCoords.z, "Target - heading: " .. math.floor(data.myHeading) .. " cid: " .. data.cid)
      end
      Wait(0)
    end
  end)
end
DRAW_HEIST_ID = 7783782
Citizen.CreateThread(function()
  if DEBUG_MODE then
    RegisterCommand("sf:drawTracking", function()
      for _, data in pairs(TRACKING_DATA) do
        if data.heistId == DRAW_HEIST_ID and data.cid == 7186 then
          drawData(data)
        end
      end
    end, false)
  end
end)
