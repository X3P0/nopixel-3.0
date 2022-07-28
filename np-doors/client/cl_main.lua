local doors = {}
local currentDoorCoords, currentDoorId, currentDoorLockState, currentZone = vector3(0, 0, 0), nil, nil, nil
local listening = false
local bollards = {
    mrpd_bollards_01 = {
        doorId = 314,
        inside = false
    },
    mrpd_bollards_02 = {
        doorId = 315,
        inside = false
    },
}

RegisterNetEvent('np-doors:initial-lock-state')
AddEventHandler('np-doors:initial-lock-state', function(pDoors)
    for k, door in pairs(pDoors) do
      doors[k] = door
    end
    -- doors = pDoors
    setSecuredAccesses(doors, 'door')
    for doorId, door in ipairs(doors) do
        if doorId ~= door.id then
            print("we should not see this message - door id mismatch", doorId, " - id: ", door.id)
        end
        if door.active and not IsDoorRegisteredWithSystem(doorId) then
            AddDoorToSystem(doorId, door.model, door.coords, false, false, false)
            if door.automatic then
                if door.automatic.distance then
                    DoorSystemSetAutomaticDistance(doorId, door.automatic.distance, 0, 1)
                end
                if door.automatic.rate then
                    DoorSystemSetAutomaticRate(doorId, door.automatic.rate, 0, 1)
                end
            end
            DoorSystemSetDoorState(doorId, door.lock, 0, 1)
        end
    end
end)

function changeLockState(pDoorId, pDoorLockState, pDoorForceUnlock)
    doors[pDoorId].lock = pDoorLockState
    doors[pDoorId].forceUnlocked = pDoorForceUnlock
    DoorSystemSetAutomaticRate(pDoorId, 1.0, 0, 0)
    DoorSystemSetDoorState(pDoorId, pDoorLockState, 0, 1)
    if pDoorId == currentDoorId then
        currentDoorLockState = pDoorLockState
    end
end

RegisterNetEvent('np-doors:change-lock-state')
AddEventHandler('np-doors:change-lock-state', function(pDoorId, pDoorLockState, pDoorForceUnlock)
    if doors and doors[pDoorId] then
        changeLockState(pDoorId, pDoorLockState, pDoorForceUnlock)
        if doors[pDoorId].connected then
            changeLockState(doors[pDoorId].connected, pDoorLockState, pDoorForceUnlock)
        end
    end
end)

local function listenForKeypress()
    listening = true
    Citizen.CreateThread(function()

        local newDoorId, newLockState = currentDoorId

        currentDoorLockState = (DoorSystemGetDoorState(currentDoorId) ~= 0 and true or false)

        local hasAccess = hasSecuredAccess(currentDoorId, 'door')

        local isHidden = doors[currentDoorId] and doors[currentDoorId].hidden or false

        if not hasAccess and currentDoorLockState and not isHidden then
            exports["np-ui"]:showInteraction('Locked', 'error')
        end

        while listening do

            local idle = 0

            if currentDoorId ~= newDoorId then
                currentDoorLockState = (DoorSystemGetDoorState(currentDoorId) ~= 0 and true or false)
                newDoorId = currentDoorId
            end

            if currentDoorLockState ~= newLockState then
                if #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), currentDoorCoords)) <= 1.2 then
                    newLockState = currentDoorLockState
                    if hasAccess and not isHidden then
                        exports["np-ui"]:showInteraction(("[E] %s"):format(newLockState and 'Locked' or 'Unlocked'), newLockState and 'error' or 'success')
                    else
                    end
                else
                    idle = 100
                end
            end

            if currentDoorId ~= nil and IsControlJustReleased(0, 38) and #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), currentDoorCoords)) <= 1.2 then
                    hasAccess = hasSecuredAccess(currentDoorId, 'door')
                    if hasAccess then
                        loadAnimDict("anim@heists@keycard@")
                        TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 48, 0, 0, 0, 0)
                        TriggerServerEvent("np-doors:change-lock-state", currentDoorId, not currentDoorLockState)
                    end
            end

            Wait(idle)
        end

        exports["np-ui"]:hideInteraction((not hasAccess or newLockState) and 'error' or 'success')
    end)
end

function AllowsKeyFob(pDoorId)
    if not doors[pDoorId] then return false end

    return doors[pDoorId]['keyFob'] == true
end

function AllowsDetCord(pDoorId)
    if not doors[pDoorId] then return false end

    return doors[pDoorId]["ignoreDetCord"] ~= true
end

function GetTargetDoorId(pEntity)
    local activeDoors = DoorSystemGetActive()

    for _, activeDoor in pairs(activeDoors) do
        if activeDoor[2] == pEntity then
            return activeDoor[1]
        end
    end
end

exports('GetTargetDoorId', GetTargetDoorId)

local printEntityDetails = false
RegisterCommand("doors:print-entity", function()
    printEntityDetails = not printEntityDetails
end)

local lastDoorData = {}

AddEventHandler("np:target:changed", function(pEntity, pEntityType, pEntityCoords)
    if pEntityType == nil or pEntityType ~= 3 then
        listening, currentDoorCoords, currentDoorId, currentDoorLockState = nil
        return
    end

    if printEntityDetails then
        print(pEntity, pEntityType, pEntityCoords, GetEntityModel(pEntity), GetEntityCoords(pEntity))
        local model = GetEntityModel(pEntity)
        local coords = GetEntityCoords(pEntity)
        local function getCoords()
            local function fmt(s)
                return tonumber(string.format("%.2f", s))
            end
            return "vector3(" .. fmt(coords.x) .. "," .. fmt(coords.y) .. "," .. fmt(coords.z) .. ")"
        end
        local function getSceneRef()
            local opts = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
            local str = ""
            for i = 0, 5 do
              str = str .. opts[math.random(#opts)]
            end
            return str
          end
        lastDoorData =
[[
  {
    info = "",
    active = true,
    id = getDoorId(),
    coords = ]] .. getCoords() .. [[,
    model = ]] .. model .. [[,
    lock = true,
    desc = "",
    access = {
        job = {},
        business = {},
    },
    forceUnlocked = false,
    hidden = false,
    keyFob = false,
    sceneRef = "]] .. getSceneRef() .. [[",
  },
]]
    end

    local doorId = GetTargetDoorId(pEntity)

    if printEntityDetails then
        print(doorId)
    end

    if (doorId) then
        currentDoorId = doorId
        currentDoorCoords = pEntityCoords

        if not listening then
            listenForKeypress()
        end
    end
end)

exports("GetCurrentDoor", function()
  return currentDoorId
end)

exports("GetDoorLocations", function()
  local doorLocations = {}
  for k, v in pairs(DOOR_CONFIG) do
    doorLocations[#doorLocations + 1] = { v.coords.x, v.coords.y, v.coords.z }
  end
  return doorLocations
end)

local function printDoorData()
    if not printEntityDetails then return end
    TriggerServerEvent("np-doors:printDoorData", lastDoorData)
end

Citizen.CreateThread(function()
  if GetConvar('sv_environment', 'prod') == 'debug' then
    exports['np-keybinds']:registerKeyMapping('', 'zzAdmin', 'Print Door Data', '+printDoorData', '-printDoorData', 'E');
    RegisterCommand("+printDoorData", function() printDoorData() end, false)
    RegisterCommand("-printDoorData", function() end, false)
  end
end)

AddEventHandler("np-doors:doorKeyFob", function()
    local doorId, isBollard = -1, false

    if currentZone ~= nil and bollards[currentZone].inside then
        doorId = bollards[currentZone].doorId
        isBollard = true
    else
        local entity = exports['np-target']:GetEntityPlayerIsLookingAt(10.0, 2.0, 16)

        if not entity then
            return TriggerEvent("DoLongHudText","Door not found.",2)
        end
    
        if printEntityDetails then
            print(entity, GetEntityType(entity), GetEntityCoords(entity), GetEntityModel(entity), GetEntityCoords(entity))
        end
    
        doorId = GetTargetDoorId(entity)
    
        if printEntityDetails then
            print(doorId)
        end
    end


    if not doorId then
        return TriggerEvent("DoLongHudText","Door not found.",2)
    end

    if (not hasSecuredAccess(doorId, 'door') or not AllowsKeyFob(doorId)) then
        PlaySoundFromEntity(-1, "Keycard_Fail", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0);
        return TriggerEvent("DoLongHudText", "The key fob is not working for this door.",2)
    end

    local isLocked = (DoorSystemGetDoorState(doorId) ~= 0 and true or false)

    TriggerEvent('InteractSound_CL:PlayOnOne',isLocked and "GarageOpen" or "GarageClose", 0.2)

    TriggerServerEvent("np-doors:change-lock-state", doorId, isBollard and (not isLocked and 6 or 0) or (not isLocked))
end)

Citizen.CreateThread(function()
    exports["np-polyzone"]:AddBoxZone("mrpd_bollards_01", vector3(411.66, -1027.95, 29.24), 7.8, 23.4, {
        heading=0,
        minZ=28.14,
        maxZ=32.14
    })
    exports["np-polyzone"]:AddBoxZone("mrpd_bollards_02", vector3(411.66, -1020.09, 29.34), 7.8, 23.4, {
        heading=0,
        minZ=28.14,
        maxZ=32.14
    })
    doors = DOOR_CONFIG
    TriggerServerEvent("np-doors:request-lock-state")
end)

RegisterNetEvent("np-doors:add")
AddEventHandler("np-doors:add", function(pArgs, pEntity, pContext)
  if GetConvar("sv_environment", "prod") == "debug" then
    TriggerServerEvent("np-door:add", GetEntityCoords(pEntity), GetEntityModel(pEntity))
  end
end)

AddEventHandler("np-polyzone:enter", function(zone, data)
    if zone == "mrpd_bollards_01" or zone == "mrpd_bollards_02" then
        bollards[zone].inside = true
        currentZone = zone
    end
end)

AddEventHandler("np-polyzone:exit", function(zone)
    if zone == "mrpd_bollards_01" or zone == "mrpd_bollards_02" then
        bollards[zone].inside = false
        currentZone = nil
    end
end)

function getNumDoors()
    return #doors
end

exports('GetNumberOfDoors', getNumDoors)

Citizen.CreateThread(function()
    Citizen.Wait(60000)
    for _, door in pairs(DOOR_CONFIG) do
        TriggerEvent("np-cleanup:addBlacklistedProp", door.model)
    end
end)

-- GetUserInput function inspired by vMenu (https://github.com/TomGrobbe/vMenu/blob/master/vMenu/CommonFunctions.cs)
-- function GetUserInput(windowTitle, defaultText, maxInputLength)
--     -- Create the window title string.
--     local resourceName = string.upper(GetCurrentResourceName())
--     local textEntry = resourceName .. "_WINDOW_TITLE"
--     if windowTitle == nil then
--       windowTitle = "Enter:"
--     end
--     AddTextEntry(textEntry, windowTitle)
  
--     -- Display the input box.
--     DisplayOnscreenKeyboard(1, textEntry, "", defaultText or "", "", "", "", maxInputLength or 30)
--     Wait(0)
--     -- Wait for a result.
--     while true do
--       local keyboardStatus = UpdateOnscreenKeyboard();
--       if keyboardStatus == 3 then -- not displaying input field anymore somehow
--         return nil
--       elseif keyboardStatus == 2 then -- cancelled
--         return nil
--       elseif keyboardStatus == 1 then -- finished editing
--         return GetOnscreenKeyboardResult()
--       else
--         Wait(0)
--       end
--     end
--   end

-- local doorIndex = 0
-- local doorsCache = {}
-- RegisterCommand("door-next", function()
--     doorIndex = doorIndex + 1
--     local door = doors[doorIndex]
--     doorsCache[doorIndex] = door
--     doorsCache[doorIndex]["id"] = doorIndex
--     doorsCache[doorIndex]["access"] = {
--         job = { "PD" },
--         business = {},
--     }
--     doorsCache[doorIndex]["forceOpened"] = false
--     SetEntityCoords(PlayerPedId(), door.coords)

--     Wait(1000)
--     doorsCache[doorIndex]["desc"] = GetUserInput("Desc")
--     Wait(0)
--     doorsCache[doorIndex]["access"]["job"][#doorsCache[doorIndex]["access"]["job"] + 1] = GetUserInput("Job")
--     Wait(0)
--     doorsCache[doorIndex]["access"]["business"][#doorsCache[doorIndex]["access"]["business"] + 1] = GetUserInput("Business")
-- end)
-- -- RegisterCommand("door-desc", function(s, args)
-- --     doorsCache[doorIndex]["desc"] = args[1]
-- -- end)
-- -- RegisterCommand("door-business", function(s, args)
-- --     doorsCache[doorIndex]["access"]["business"][#doorsCache[doorIndex]["access"]["business"] + 1] = args[1]
-- -- end)
-- -- RegisterCommand("door-job", function(s, args)
-- --     doorsCache[doorIndex]["access"]["job"][#doorsCache[doorIndex]["access"]["job"] + 1] = args[1]
-- -- end)
-- RegisterCommand("door-print", function()
--     print(json.encode(doorsCache, { indent = true }))
-- end)
-- RegisterCommand("doors-save", function()
--     TriggerServerEvent("np-doors:save-config", doorsCache)
-- end)

function GetDoorPlayerFacing(pDistance)
    if pDistance == nil then
        pDistance = 1
    end

    local playerPed = PlayerPedId()
    local position = GetEntityCoords(playerPed, false)
    local endPosition = position + GetEntityForwardVector(playerPed) * pDistance
    local raycast = StartShapeTestSweptSphere(position.x, position.y, position.z, endPosition.x, endPosition.y, endPosition.z, 0.2, 16, playerPed, 4)
    local retval, hit, endCoords, surfaceNormal, entity = GetShapeTestResult(raycast)
    local targetDoor = GetTargetDoorId(entity)
    return targetDoor
end

exports("GetDoorPlayerFacing", GetDoorPlayerFacing)
