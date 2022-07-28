local currentJob = nil
local showDispatchLog = false
local isDead = false
local disableNotifications = false
local disableNotificationSounds = false
local currentCallSign = 0
local currentDepartment = "lspd"
local dispatchersOnDuty = 0
local selfIsDispatch = false

Citizen.CreateThread(function()
  dispatchersOnDuty = RPC.execute("np-dispatch:getDispatchersOnDuty")
end)

RegisterNetEvent("np-dispatch:dispatchersOnDuty")
AddEventHandler("np-dispatch:dispatchersOnDuty", function(pOnDuty)
	dispatchersOnDuty = 0 -- pOnDuty
end)

RegisterNetEvent("np-dispatch:becomeDispatchSelf")
AddEventHandler("np-dispatch:becomeDispatchSelf", function(pOnDuty)
	selfIsDispatch = pOnDuty == "on"
  TriggerEvent("DoLongHudText", selfIsDispatch and "Marked self as dispatcher" or "No longer dispatcher")
end)

function belowDispatchLimit()
  return (not dispatchersOnDuty or dispatchersOnDuty < 2) or selfIsDispatch
end

RegisterNetEvent("police:setCallSign")
AddEventHandler("police:setCallSign", function(pCallSign, pDepartment)
	if pCallSign ~= nil then currentCallSign = pCallSign end
  if pDepartment ~= nil then
    currentDepartment = pDepartment
  else
    currentDepartment = "lspd"
  end
end)

local function randomizeBlipLocation(pOrigin)
    local x = pOrigin.x
    local y = pOrigin.y
    local z = pOrigin.z
    local luck = math.random(2)
    y = math.random(35) + y
    if luck == 1 then
        x = math.random(35) + x
    end
    return {x = x, y = y, z = z}
end

--- Utility generate UUID for Event
local function uuid()
  math.random()
  math.random()
  math.random()
  local template ='xxxxxxxx-xxxx-5xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
      local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
      return string.format('%x', v)
  end)
end


local function sendNewsBlip(pNotificationData)
    addBlip({
        currentJob = currentJob,
        isImportant = pNotificationData.isImportant,
        blipTenCode = pNotificationData.dispatchCode == nil and '' or pNotificationData.dispatchCode,
        blipDescription = pNotificationData.dispatchMessage,
        blipLocation = pNotificationData.origin,
        blipSprite = pNotificationData.blipSprite,
        blipColor = pNotificationData.blipColor,
        blipArea = pNotificationData.blipArea,
        blipId = pNotificationData.eventId,
        isTracker = pNotificationData.isTracker
    })
end

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent('dispatch:clNotify')
AddEventHandler('dispatch:clNotify', function(pNotificationData)
    if pNotificationData == nil then return end
    if pNotificationData.recipientList then
        for key, value in pairs(pNotificationData.recipientList) do
            if key == currentJob and value and not disableNotifications then
                if pNotificationData.origin ~= nil and pNotificationData.origin ~= false then
                    if pNotificationData.originStatic == nil or not pNotificationData.originStatic or pNotificationData.blipArea ~= nil then
                        pNotificationData.origin = randomizeBlipLocation(pNotificationData.origin)
                    else
                        pNotificationData.origin = pNotificationData.origin
                    end
                end
                if currentJob ~= "news" then
                    sendNewsBlip(pNotificationData)
                elseif currentJob == "news" and exports["np-inventory"]:getQuantity("scanner") > 0 then
                    sendNewsBlip(pNotificationData)
                end
                if pNotificationData.getStreetCord then
                    local streetName, crossingRoad = GetStreetNameAtCoord(pNotificationData.origin.x, pNotificationData.origin.y, pNotificationData.origin.z)
                    pNotificationData.firstStreet = GetStreetNameFromHashKey(streetName)
                    pNotificationData.secondStreet = GetStreetNameFromHashKey(crossingRoad)
                end
                if pNotificationData.playSound
                  and currentJob ~= "news"
                  and not disableNotificationSounds
                  and belowDispatchLimit()
                then
                    TriggerServerEvent('np-fx:sound:playDispatch', pNotificationData.soundName);
                end
            end
        end
    end
end)

local isDispatchActive = false
RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job)
    currentJob = job
    if currentJob == "police" or currentJob == "doc" or currentJob == "ems" or currentJob == "news" then
        isDispatchActive = true
        exports["np-ui"]:sendAppEvent("dispatch", {
            action = "initLoad",
            data = { active = true },
        })
    elseif isDispatchActive then
        isDispatchActive = false
        exports["np-ui"]:sendAppEvent("dispatch", {
            action = "initLoad",
            data = { active = false },
        })
    end
end)

function displayFastDispatch()
    if (currentJob == "police" or currentJob == "ems") and not isDead then
        showDispatchLog = not showDispatchLog
        TriggerEvent("np-vehicles:isDispatchOpen", showDispatchLog)
        exports["np-ui"]:SendUIMessage({
            source = "np-nui",
            app = "dispatch",
            show = showDispatchLog,
            data = data or {},
        })
        exports["np-ui"]:SetUIFocusCustom(showDispatchLog, showDispatchLog)
    end
end
function hideFastDispatch()
    showDispatchLog = false
    TriggerEvent("np-vehicles:isDispatchOpen", showDispatchLog)
    exports["np-ui"]:SendUIMessage({
        source = "np-nui",
        app = "dispatch",
        show = showDispatchLog,
        data = data or {},
    })
    exports["np-ui"]:SetUIFocusCustom(showDispatchLog, showDispatchLog)
end
RegisterCommand('+showFastDispatch', displayFastDispatch, false)
RegisterCommand('-showFastDispatch', hideFastDispatch, false)

Citizen.CreateThread(function()
    exports["np-keybinds"]:registerKeyMapping("","Gov", "View Dispatch", "+showFastDispatch", "-showFastDispatch")
end)

RegisterNetEvent('dispatch:toggleNotifications')
AddEventHandler('dispatch:toggleNotifications', function(state)
    state = string.lower(state)
    if state == "on" then
        disableNotifications = false
        disableNotificationSounds = false
        TriggerEvent('DoLongHudText', "Dispatch is now enabled.")
    elseif state == "off" then
        disableNotifications = true
        disableNotificationSounds = true
        TriggerEvent('DoLongHudText', "Dispatch is now disabled.")
    elseif state == "mute" then
        disableNotifications = false
        disableNotificationSounds = true
        TriggerEvent('DoLongHudText', "Dispatch is now muted.")
    else
        TriggerEvent('DoLongHudText', "You need to type in 'on', 'off' or 'mute'.")
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if showDispatchLog then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(0, 47, true) -- disable weapon
            DisableControlAction(0, 58, true) -- disable weapon
            DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
            DisableControlAction(0, 81, true) -- radio scroll down
            DisableControlAction(0, 82, true) -- radio scroll up
        end
    end
end)

--
local mapOpen = false
AddEventHandler("np-ui:application-closed", function(name)
    if name == "dispatch" and showDispatchLog then
        showDispatchLog = false
        TriggerEvent("np-vehicles:isDispatchOpen", true)
        mapOpen = false
        exports["np-ui"]:SetUIFocusCustom(false, false)
        TriggerServerEvent("np-dispatch:mapIsOpen", mapOpen)
    end
end)

RegisterNetEvent("np-dispatch:openFull")
AddEventHandler("np-dispatch:openFull", function(pData)
    mapOpen = true
    exports["np-ui"]:openApplication("dispatch", {
        showWithMap = true
    })
    TriggerServerEvent("np-dispatch:mapIsOpen", mapOpen)
end)

-- v2

RegisterNetEvent("np-dispatch:updateUnits")
AddEventHandler("np-dispatch:updateUnits", function(units)
    exports["np-ui"]:sendAppEvent("dispatch", {
        action = "updateUnits",
        data = units,
    })
end)

RegisterNetEvent('dispatch:clNotify')
AddEventHandler('dispatch:clNotify', function(pNotificationData)
    if not pNotificationData then return end
    for job, enabled in pairs(pNotificationData.recipientList) do
      if job == currentJob and not enabled then return end
    end
    pNotificationData._hideNotification = not belowDispatchLimit()
    if currentJob ~= "news" then
        exports["np-ui"]:sendAppEvent("dispatch", {
            action = "addPing",
            data = pNotificationData,
        })
    end
    if currentJob == "news" and exports["np-inventory"]:getQuantity("scanner") > 0 then
        pNotificationData._hideNotification = false
        pNotificationData.dispatchMessage = "A 911 call has been picked up on your radio scanner! " .. 
          "(" .. pNotificationData.dispatchMessage and pNotificationData.dispatchMessage or "Unknown" .. ")"
        pNotificationData.displayCode = nil
        pNotificationData.isImportant = false
        pNotificationData.priority = 1
        pNotificationData._isNewsAlert = true
        exports["np-ui"]:sendAppEvent("dispatch", {
            action = "addPing",
            data = pNotificationData,
        })
    end
end)

RegisterNetEvent("np-dispatch:updateUnitCoords")
AddEventHandler("np-dispatch:updateUnitCoords", function(pCoords)
    if not mapOpen then return end
    exports["np-ui"]:sendAppEvent("dispatch", {
        action = "updateUnitLocations",
        data = pCoords,
    })
end)

RegisterNetEvent("np-dispatch:updateDispatch")
AddEventHandler("np-dispatch:updateDispatch", function(pData)
    exports["np-ui"]:sendAppEvent("dispatch", pData)
end)

-- show = false
-- RegisterCommand("dispatcheroo", function()
--     show = not show
--     if show then
--         exports["np-ui"]:openApplication("dispatch")
--     else
--         exports["np-ui"]:closeApplication("dispatch")
--     end
-- end)

RegisterUICallback("np-ui:dispatchAction", function(data, cb)
    if data.action == "createCall" then
        RPC.execute("np-dispatch:createCall", data.ctxId)
    end
    if data.action == "dismissPing" then
        RPC.execute("np-dispatch:dismissPing", data.ctxId)
    end
    if data.action == "dismissCall" then
        RPC.execute("np-dispatch:dismissCall", data.ctxId)
    end
    if data.action == "toggleUnit" then
        RPC.execute("np-dispatch:toggleUnitAssignment", data.ctxId, data.unit)
    end
    if data.action == "setGPSLocation" then
        SetNewWaypoint(data.ping.origin.x, data.ping.origin.y)
    end
    if data.action == "setUnitVehicle" then
        RPC.execute("np-dispatch:setUnitVehicle", data.data)
    end
    if data.action == "setUnitRidingWith" then
        RPC.execute("np-dispatch:setUnitRidingWith", data.data)
    end
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)
RegisterUICallback("np-ui:getDispatchData", function(data, cb)
    local result = RPC.execute("np-dispatch:getDispatchData")
    cb({ data = result, meta = { ok = true, message = result } })
end)

-- old blip shit
local myBlips = {}

RegisterNetEvent('phone:assistClear')
AddEventHandler('phone:assistClear', function(id,jobsent)
  TriggerEvent('jobssystem:current', function(job)
    if myBlips[id] ~= nil and not myBlips[id].onRoute and (job == jobsent or (job == "police" and jobsent == "911")) then
      clearBlip(myBlips[id], false)
    end
  end)
end)

RegisterNetEvent('dispatch:clUpdatePosition')
AddEventHandler('dispatch:clUpdatePosition', function(pNotificationId, coords, pNotificationData)
  if myBlips[pNotificationId] ~= nil then
    SetBlipCoords(myBlips[pNotificationId].blip, coords.x, coords.y, coords.z)
  elseif myBlips[pNotificationId] == nil and pNotificationData ~= nil then
    pNotificationData.origin = coords
    TriggerEvent("dispatch:clNotify", pNotificationData)
  end
end)

RegisterNetEvent('dispatch:clRemoveNotificationById')
AddEventHandler('dispatch:clRemoveNotificationById', function(pNotificationId)
  if myBlips[pNotificationId] ~= nil then
    clearBlip(myBlips[pNotificationId], true)
   end
end)

RegisterNetEvent("clearJobBlips")
AddEventHandler("clearJobBlips", function()
  -- Clear all our blips as our job has changed
  for key, item in pairs(myBlips) do
    if (key ~= nil and item ~= nil) then
      clearBlip(item, true)
    end
  end
end)

function addBlip(data)
  local blip = nil
 
  if data.blipLocation == nil and (belowDispatchLimit() or currentJob == "news") then
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    return
  end

  if data.blipArea and data.blipArea >= 1 then
    local blipLocation = randomizeBlipLocation(data.blipLocation)
    blip = AddBlipForRadius(blipLocation.x, blipLocation.y, blipLocation.z, data.blipArea + 0.0)
    SetBlipAlpha(blip, 90)
  elseif data.blipLocation then
    blip = AddBlipForCoord(data.blipLocation.x, data.blipLocation.y, data.blipLocation.z)
    SetBlipScale(blip, 2.0)
    SetBlipAlpha(blip, 180)
  end

  if data.isImportant then
    SetBlipFlashesAlternate(blip,true)
  end

  SetBlipSprite(blip, data.blipSprite)
  SetBlipColour(blip, data.blipColor)

  if data.currentJob == "news" then
    SetBlipSprite(blip, 459)
  end

  SetBlipHighDetail(blip, 1)
  BeginTextCommandSetBlipName("STRING")
  local displayText = data.blipDescription
  if data.currentJob == "news" then
    displayText = 'Scanner | ' .. data.blipDescription
  else
    displayText = data.blipTenCode .. " | " .. data.blipDescription
  end
  AddTextComponentString(displayText)
  EndTextCommandSetBlipName(blip)

  if data.blipLocation then
    local blipId = data.blipId and data.blipId or uuid()
    if myBlips[blipId] then
      blipId = uuid()
    end
    myBlips[blipId] = {
      timestamp = GetGameTimer(),
      pos = data.blipLocation and {
        x = data.blipLocation.x,
        y = data.blipLocation.y,
        z = data.blipLocation.z
      } or nil,
      blip = blip,
      id = blipId,
      jobType = data.currentJob,
      isTracker = data.isTracker
    }
  end
  if (belowDispatchLimit() or currentJob == "news") then
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  end
end

function clearBlip(item, forceClear)
  if item == nil then
    return
  end

  -- If this is a boosting car or like a bank truck skip it unless manually /clear
  if item.isTracker and not forceClear then
    return
  end

  local id = item.id
  local pedb = item.blip

  if item.onRoute then
    SetBlipRoute(pedb, false)
  end

  if pedb ~= nil and DoesBlipExist(pedb) then
    myBlips[id] = nil
    SetBlipSprite(pedb, 2)
    SetBlipDisplay(pedb, 3)
    RemoveBlip(pedb)
  end
end

Citizen.CreateThread(function()
  local timer = 0
  local canPay = true
  while true do
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local curTime = GetGameTimer()
    if timer >= 300 then canPay = true end -- Time limit ,300 = 5 min ,1000 ms * 300 = 5 min 
    timer = timer +1

    for key, item in pairs(myBlips) do
      if (key ~= nil and item ~= nil) then
        -- If we are within 10 units of a blip that is not our own, clear the blip and message the server to clear for everyone
        if #(vector2(pos.x, pos.y) - vector2(item.pos.x, item.pos.y)) < 50.0 then
          if item.jobType == "ems" then
            if exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "ems" then
              TriggerServerEvent('phone:assistRemove', item.id, item.jobType) -- Send message of clear to others
              clearBlip(item, false)
              if GetTimeDifference(curTime, item.timestamp) > 2000 then
                if canPay then
                  canPay = false
                  timer = 0
                  TriggerServerEvent('phone:checkJob')
                end
              end
            end
          elseif item.jobType == "news" then 
            if exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "news" then
              TriggerServerEvent('phone:assistRemove', item.id, item.jobType) -- Send message of clear to others
              clearBlip(item, false)
              if GetTimeDifference(curTime, item.timestamp) > 2000 then
                if canPay then
                  canPay = false
                  timer = 0
                  TriggerServerEvent('phone:checkJob')
                end
              end
            end
          else
             TriggerServerEvent('phone:assistRemove', item.id, item.jobType) -- Send message of clear to others
              clearBlip(item, false)
              if GetTimeDifference(curTime, item.timestamp) > 2000 then
                if canPay then
                  canPay = false
                  timer = 0
                  TriggerServerEvent('phone:checkJob')
                end

              end
          end
        elseif GetTimeDifference(curTime, item.timestamp) > 600000 and not item.onRoute then
          -- If its been passed 10 minutes, clear the bip locally unless it's a blip we are on route to
          clearBlip(item, false)
        end
      end
    end

    Citizen.Wait(1000)
  end
end)
