Housing.housingBeingRobbedClient = {}
Housing.housingRobTargets = {}
Housing.currentlyRobInside = false

Housing.staticObjectRobPoints = nil
Housing.robPosLocations = nil

Housing.currentClosestSelected = nil
Housing.currentlyDisplayingPickup = false
Housing.destroyedObjects = {}
Housing.alarm = {}

Housing.attackedTarget = nil
Housing.lockpicking = false

Housing.lockout = false

Citizen.CreateThread(function()
    exports["np-interact"]:AddPeekEntryByModel({ `prop_ld_int_safe_01` }, {
        {
          id = "housing_take_safe",
          event = "housing:takeSafe",
          icon = "people-carry",
          label = "Take Safe",
        },
      }, 
      { distance = { radius = 3.0 },
      isEnabled = function(pEntity)
        return Housing.currentlyRobInside
      end
    })
end)

RegisterNetEvent("housing:attemptToLockPick")
AddEventHandler("housing:attemptToLockPick", function()
    attemptToLockPickHouse()
end)

function lockpickDoor()
    if Housing.lockpicking then return end
    Housing.lockpicking = true
    Citizen.CreateThread(function()
        local lPed = PlayerPedId()
        RequestAnimDict("veh@break_in@0h@p_m_one@")
        while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
            Citizen.Wait(0)
        end
        
        while Housing.lockpicking do        
            TaskPlayAnim(lPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)
            Citizen.Wait(2500)
        end
        ClearPedTasks(lPed)
    end)
end


RegisterNetEvent("housing:robbery:clearRobbery")
AddEventHandler("housing:robbery:clearRobbery", function()
    Housing.housingBeingRobbedClient = {}
    Housing.housingRobTargets = {}
    Housing.currentlyRobInside = false

    Housing.staticObjectRobPoints = nil
    Housing.robPosLocations = nil

    Housing.currentClosestSelected = nil
    Housing.currentlyDisplayingPickup = false
    Housing.destroyedObjects = {}

    Housing.attackedTarget = nil
    Housing.lockout = false
end)

function attemptToLockPickHouse(skipPicking)

    local isComplete, propertyID, dist, zone = Housing.func.findClosestProperty()
    if not isComplete then return end
    if not isPropertyActive(propertyID) then return end

    if dist > 2.0 then return end
    
    local player = GetEntityCoords(PlayerPedId())
    local finished,housingInformation,currentHousingLocks,isResult,housingLockdown,housingRobbed,robTargets = RPC.execute("getCurrentSelected",propertyID)

    if type(housingLockdown) == "table" then
        Housing.currentHousingLockdown = housingLockdown
    end

    if type(currentHousingLocks) == "table" then
        Housing.currentHousingLocks = currentHousingLocks
    end
    

    if type(housingRobbed) == "table" then
        Housing.housingBeingRobbedClient = housingRobbed
    end

    if not canRobProperty(propertyID) then 
        TriggerEvent("DoLongHudText","I do not think it is a good idea to rob a property without the permission from the boss, might lose a hand.",2)
        return 
    end

    if type(robTargets) == "table" then
        Housing.housingRobTargets = robTargets
    end
    
    local pickedToOpen = false
    if not skipPicking then
        if Housing.housingBeingRobbedClient[propertyID].hasBeenRobbed == false then
            lockpickDoor()
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)
            

            local failed = false
            for i=1,2 do
                if not failed then
                    local finished = exports["np-ui"]:taskBarSkill(1650,  math.random(10, 14))
                    if finished ~= 100 then
                        failed = true
                    end
                end
            end
        
            ClearPedTasks(PlayerPedId())
            if failed then 
                TriggerEvent('inventory:removeItem',"lockpick", 1)
                TriggerEvent("Evidence:StateSet",26,1200)
                TriggerEvent("evidence:bleeding",false)
                Housing.lockpicking = false
                return 
            end

            local finished,housingRobbed,robTargets,alarm = RPC.execute("housing:robbery:pickedLock",propertyID)

            if type(housingRobbed) == "table" then
                Housing.housingBeingRobbedClient = housingRobbed
            end

            if type(robTargets) == "table" then
                Housing.housingRobTargets = robTargets
            end

            Housing.alarm = alarm
            pickedToOpen = true

            Citizen.CreateThread(function()
                Citizen.Wait(2000)
                -- Should we spawn a safe for this person?
                local baseProg = exports["np-progression"]:GetProgression("streetrep") or 0
                local progression = math.floor(baseProg / 20000 + 1.0)

                local chance = 0.85
                if progression >= 25 then
                    chance = 0.75
                elseif progression >= 50 then
                    chance = 0.65
                elseif progression >= 75 then
                    chance = 0.60
                elseif progression >= 100 then
                    chance = 0.50
                end

                local ranNum = math.random()

                if robTargets.safeLocation and ranNum > chance then
                    local buildingVector = exports["np-build"]:getModule("func").currentBuildingVector()
                    local coords = getGlobalVector(robTargets.safeLocation, buildingVector)
                    local safe = CreateObject(`prop_ld_int_safe_01`, coords, false, false)
                    SetEntityHeading(safe, robTargets.safeLocation.w)
                    PlaceObjectOnGroundProperly(safe)
                    FreezeEntityPosition(safe, true)

                    Citizen.Wait(60000 * 10)
                    -- Yeet this shit after 10 minutes if they didnt take it
                    if DoesEntityExist(safe) then
                        DeleteObject(safe)
                    end
                end
            end)
            
        else
            TriggerEvent("DoLongHudText","You Can Interact With the Door, just a thought.",2)
            return
        end 
    end


    if pickedToOpen and not skipPicking then
        TriggerEvent("alert:houseRobbery")
    end
    
    if finished then    
        Housing.func.enterBuilding(propertyID,nil,false)
    else
        if Housing.attackedTarget == nil then
            Housing.lockout = false
            Housing.attackedTarget = propertyID
        end
        Housing.lockpicking = false
        Housing.currentlyRobInside = propertyID
        Housing.func.enterBuilding(propertyID,nil,true)
    end
end


function canRobProperty(propertyID)

    if Housing.housingBeingRobbedClient == nil then return false end
    if Housing.housingBeingRobbedClient[propertyID] == nil then return false end

    local found = false
    local cid = exports["isPed"]:isPed("cid")
    local myjob = exports["isPed"]:isPed("myjob")
    if myjob == "police" or  myjob == "judge" then return true end
    
    for k,v in pairs(Housing.housingBeingRobbedClient[propertyID].validCID) do
        if cid == v then
            found = true
            break
        end
    end

    return found
end

RegisterNetEvent("housing:exitFrontDoor")
AddEventHandler("housing:exitFrontDoor", function()
    local spawnInApartmentsOnly = (exports["np-config"]:GetMiscConfig("spawn.apartments.only") or false)
	if spawnInApartmentsOnly then
        TriggerEvent("DoLongHudText", "You can't leave yet", 2)
		return
	end
    Housing.currentlyRobInside = false
    DoScreenFadeOut(1)
    exports["np-build"]:getModule("func").exitCurrentRoom(Housing.info[Housing.currentHousingInteractions.id][1])
    exitingBuilding()
    DoScreenFadeIn(1900)
end)


function displayPickup(force,itemName)


    if force and Housing.currentlyDisplayingPickup == true then 
        Housing.currentlyDisplayingPickup = false
        exports["np-ui"]:hideInteraction()

    end

    if Housing.currentlyDisplayingPickup == false and not force then
        Housing.currentlyDisplayingPickup = true
        if type(itemName) == "string" then
            exports["np-ui"]:showInteraction("[E] Take Object")
        else
            exports["np-ui"]:showInteraction("[E] Search location")
        end
    end


end

Citizen.CreateThread(function()

    while true do
        if Housing.attackedTarget ~= nil then
            local playerCoords = GetEntityCoords(PlayerPedId())
            if Housing.currentlyRobInside ~= false then
        
                if Housing.robPosLocations ~= nil then
                    local closestDist = 999
                    local closest = nil

                    for i=1,#Housing.robPosLocations do
                        if not Housing.robPosLocations[i].completed then
                            local pos = Housing.robPosLocations[i].pos
                            local dist = #(pos-playerCoords)
                            if  dist <= 1.3 and dist < closestDist then
                                closestDist = dist
                                closest = i
                            end
                        end
                    end

                    Housing.currentClosestSelected = closest
                    local item = 0
                    if Housing.robPosLocations[Housing.currentClosestSelected] ~= nil then
                        item = Housing.robPosLocations[Housing.currentClosestSelected].id
                    end
                    if Housing.currentClosestSelected ~= nil then
                        displayPickup(false,item)
                    else
                        displayPickup(true)
                    end
                end
            end

            
            local propertyPos = vec3FromVec4(Housing.info[Housing.attackedTarget][1])
            if propertyPos ~= nil and Housing.currentlyRobInside == false and not Housing.lockout then
                local dist = #(playerCoords-propertyPos)
                if dist > 100 then
                    Housing.lockout = true
                    RPC.execute("housing:robbery:targetRemovePlayer",Housing.attackedTarget)
                end
            end
            Wait(500)
        else
            Wait(20000)
        end
       
    end
end)


function interactRob()
    if not Housing.currentlyDisplayingPickup then return end
    if Housing.currentClosestSelected == nil then return end

    local item = Housing.robPosLocations[Housing.currentClosestSelected].id
    local vec3 = Housing.robPosLocations[Housing.currentClosestSelected].pos
    local model = Housing.robPosLocations[Housing.currentClosestSelected].model


    local targetObject = GetClosestObjectOfType(vec3.x,vec3.y,vec3.z, 5.0,GetHashKey(model), 0, 0, 0)
    if targetObject == 0 and type(item) == "string" then return end

    if type(item) == "string" then
        local weight = exports["np-inventory"]:getCurrentWeight()
        local maxWeight = exports["np-inventory"]:getPlayerMaxWeight()
        if weight + 50 >= maxWeight then
            TriggerEvent("DoLongHudText", "You do not have enough room to pick this up.",2)
            return
        end
    end

    local finished,message = RPC.execute("housing:robbery:searchedPoint",Housing.currentlyRobInside,Housing.currentClosestSelected)

    local player = GetPlayerPed( -1 )
    if type(item) == "string" then

        local timer = 10000

        if Housing.WaitTimes[item] then
            timer = Housing.WaitTimes[item]
        end

        TaskTurnPedToFaceCoord(player,vec3.x,vec3.y,vec3.z,0.1)
        TriggerEvent("animation:PlayAnimation","search")
        local finished = exports["np-taskbar"]:taskBar(timer,"Securing Item")
        ClearPedTasks(PlayerPedId())
        if finished ~= 100 then
            return
        end
        TriggerEvent("doAnim","pickup")
        Wait(2000)
        ClearPedTasks(PlayerPedId())
    else
        TriggerEvent("animation:PlayAnimation","search")
        local finished = exports["np-taskbar"]:taskBar(15000,"Searching Location")
        ClearPedTasks(PlayerPedId())
        if finished ~= 100 then
            return
        end
        
    end

    if finished then
        if type(item) == "string" then
            DeleteEntity(targetObject)
            local complete,message = RPC.execute("housing:robbery:destroyedObject",Housing.currentlyRobInside,model,vec3)
            if complete then 
                TriggerEvent('player:receiveItem', item, 1)
                TriggerServerEvent("np-placeables:chance", "house-robbery")
            end
            
        else
            local propertyModel = Housing.typeInfo[Housing.info[Housing.currentlyRobInside].model].robberyCounterpart
            local cat = Housing.robInformation.staticLocations[propertyModel].staticPositions[Housing.currentClosestSelected].itemCat
            
            local itemList = Housing.robCat[cat].items
            local maxItems = Housing.robCat[cat].maxItems
            local itemListAmount = #itemList


            local items = 0
            local itemTable = {}
            
            for i=1,maxItems+10 do
                local rndItem = math.random(itemListAmount)
                local rndChanceItem = math.random(100)
                if items >= maxItems then break end
                if rndChanceItem < itemList[rndItem].chance then
                    
                    if itemTable[itemList[rndItem].name] == nil then 
                        itemTable[itemList[rndItem].name] = 1 
                    else
                        itemTable[itemList[rndItem].name] = itemTable[itemList[rndItem].name] + 1
                    end
                    items = items + 1
                end
            end

            for k,v in pairs(itemTable) do
                TriggerEvent('player:receiveItem', k, v, true)
                TriggerServerEvent("np-gallery:generateGem", "robbery")
                TriggerServerEvent("np-heists:generateSafeCrackingTool")
            end
            TriggerServerEvent("np-placeables:chance", "house-robbery")
        end

        local complete,destroyedTable = RPC.execute("getDestroyedTable",Housing.currentlyRobInside)
        if type(destroyedTable) == "table" then
            Housing.destroyedObjects = destroyedTable
        end
        
        Housing.robPosLocations[Housing.currentClosestSelected].completed = true
    end
end

function getIdfromObjectName(model,objectName)
    if Housing.robInformation.dynamic[objectName] ~= nil then
        return Housing.robInformation.dynamic[objectName]
    end

    return Housing.robInformation.staticLocations[model].staticObjects[objectName]

end

function getGlobalVector(vector,buildingVector)
    local vec3 = vec3FromVec4(vector)
    return (vec3 + buildingVector) 
end

function buildRobLocations(model,propertyID)

    local robLocations = {}

    local index1 = 1
    for k,v in pairs(Housing.staticObjectRobPoints) do
        robLocations[index1] = v
        robLocations[index1].model = robLocations[index1].id
        robLocations[index1].id = getIdfromObjectName(model,robLocations[index1].id)
        index1 = index1 + 1
    end
    
    local buildingVector = exports["np-build"]:getModule("func").currentBuildingVector()
    for k,v in pairs(Housing.housingRobTargets.pos) do
        local vector = Housing.robInformation.staticLocations[model].staticPositions[v].pos

        robLocations[index1] = {["pos"] = getGlobalVector(vector,buildingVector) ,["id"] = v,["model"] = "none"}
        index1 = index1 + 1
    end

    local finished,locations = RPC.execute("housing:robbery:robLocationsGenerated",robLocations,propertyID)
    Housing.robPosLocations = locations
    alarm(false)
end

function isInRobbery()
    if Housing.currentlyRobInside ~= nil and Housing.currentlyRobInside ~= 0  and Housing.currentlyRobInside ~= false then return true else return false end
end

function alarm(clearAlarm)

    if Housing.alarm then 
        local alarmOffset = exports["np-build"]:getModule("func").getAlarm()

        if alarmOffset ~= false then
            TriggerEvent("InteractSound_CL:playAlarm",alarmOffset,clearAlarm)
        end
    else
        TriggerEvent("InteractSound_CL:playAlarm",false,true)
    end
    
end

local failedAlarm = false
local insideGame = false
RegisterNetEvent("np-housing:alarmFail")
AddEventHandler("np-housing:alarmFail", function()
    if not insideGame then
        TriggerEvent("alert:houseRobbery",true)
        RPC.execute("property:alarmDisabled",Housing.attackedTarget)
    end
    failedAlarm = true
end)

RegisterNetEvent("np-housing:alarmEnter")
AddEventHandler("np-housing:alarmEnter", function()
    insideGame = true
    if not Housing.alarm then return end
    for i=1,2 do
        if not failedAlarm then
            local finished = exports["np-ui"]:taskBarSkill(3200,  math.random(10, 14))
            if finished ~= 100 then
                failedAlarm = true
            end
        end
    end

    if failedAlarm then
        TriggerEvent("alert:houseRobbery",true)
        RPC.execute("property:alarmDisabled",Housing.attackedTarget)
    else
        RPC.execute("property:alarmDisabled",Housing.attackedTarget)
    end

    failedAlarm = false
    insideGame = false
end)

RegisterNetEvent("property:updateAlarms")
AddEventHandler("property:updateAlarms", function(alarmPass)
    Housing.alarm = alarmPass
    if not Housing.alarm then
        alarm(true)
    end
end)

RegisterNetEvent("housing:takeSafe")
AddEventHandler("housing:takeSafe", function(pData, pEntity)
    if not DoesEntityExist(pEntity) then return end
    
	TriggerEvent("animation:PlayAnimation", "kneel");

    -- Between 5-10 seconds we will alert the cops since they got a safe and picked it up
    if not failedAlarm then
        Wait(math.random(5000, 10000))
        TriggerEvent("alert:houseRobbery", true)
    end

    local finished = exports['np-taskbar']:taskBar(20000, "Picking up safe", true, true, nil, false);
    if finished ~= 100 then return ClearPedTasks(PlayerPedId()) end

	TriggerEvent("animation:PlayAnimation", "pickup");
    TriggerEvent("player:receiveItem", "housesafe", 1)
    DeleteEntity(pEntity)
end)
