Housing.positions = {}

Citizen.CreateThread(function()
    while true do
        if Housing.currentlyEditing and not Housing.currentlyInsideBuilding then
            if not playerInRangeOfProperty(Housing.currentlyEditing) and not Housing.currentlyInsideBuilding then
                exitEdit(false) -- leaving property range
            end
            if Housing.currentHousingInteractions ~= nil then
                Housing.positions = {
                    garage = {pos = Housing.currentHousingInteractions.garage_coordinates, text = "Garage Location" },
                    backdoor= {pos = Housing.currentHousingInteractions.backdoor_coordinates.external, text = "Back door outside location"}
                }
            end

            Wait(1000)
        else
            Wait(5000)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        if Housing.currentlyEditing ~= false then
            if playerInRangeOfProperty(Housing.currentlyEditing) then
                for k,v in pairs(Housing.positions) do
                    if type(v.pos) == "vector4" then 
                        if #(v.pos - vector4(0.0,0.0,0.0,0.0)) > 10.0  then
                            Draw3DText(v.pos.x,v.pos.y,v.pos.z, v.text)
                        end
                    else
                        if #(v.pos - vector3(0.0,0.0,0.0)) > 10.0  then
                            Draw3DText(v.pos.x,v.pos.y,v.pos.z, v.text)
                        end
                    end
                end
            else
                Wait(1000)
            end
            Wait(1)
        else
            Wait(5000)
        end
    end
end)

function canEdit()
    if Housing.currentlyEditing ~= false and Housing.currentOwned[Housing.currentlyEditing]  then
        return true
    end
end

function canPlaceAtLocation(pos,propertyID)
    if Housing.currentlyInsideBuilding then return false,"Cannot edit this inside property" end
    if not playerInRangeOfProperty(propertyID) then return false,"Outside of property Range" end

    local housingPos = vec3FromVec4(Housing.info[propertyID][1])

    local cast = Raycast()
    if not cast.Hit then return false,"Cannot Be floating" end

    if cast.SurfaceNormal.z <= 0.968 then return false,"To steep to place point" end

    local difference = math.abs(housingPos.z - pos.z)
    if difference > 15 then return false,"To far from the height of the door" end

    return true,""
end

function Housing.func.OpenStash(propertyID,cat)
    TriggerEvent('InteractSound_CL:PlayOnOne','StashOpen', 0.6)
    TriggerEvent("server-inventory-open", "1", cat.."-"..propertyID)
    TriggerEvent("actionbar:setEmptyHanded")
end




RegisterNetEvent("housing:inventory")
AddEventHandler("housing:inventory", function()
    if Housing.currentlyEditing ~= false then return end
    local propertyID = Housing.currentHousingInteractions.id
    local cat = getHousingCatFromPropertID(propertyID)
    local max = Housing.max[cat]

    if max.canHaveInventory then
        local myjob = exports["isPed"]:isPed("myjob")

        local ownerOnlyStash = exports["np-config"]:GetMiscConfig("housing.stash.ownerOnly")

        if not lockdownCheck(propertyID) then
            TriggerEvent("DoLongHudText","Property on lockdown , you may not open the stash",2)
            return
        end

        if Housing.currentOwned[propertyID] then -- owner
            Housing.func.OpenStash(propertyID,cat)
        elseif Housing.currentHousingLockdown[propertyID] and (myjob == "police" or  myjob == "judge") then
            Housing.func.OpenStash(propertyID,cat)
        elseif not Housing.currentOwned[propertyID] and (cat == "housing" and ownerOnlyStash) then
            TriggerEvent("DoLongHudText", "Seems like you don't have access to this...", 2)
        else
            if Housing.currentKeys ~= nil and Housing.currentKeys[propertyID] ~= nil then
                local designerOnly = Housing.currentKeys[propertyID].information.designerKey
                if designerOnly == 1 then
                    TriggerEvent("DoLongHudText","You do not have the key to open this stash",2)
                else
                    Housing.func.OpenStash(propertyID,cat)
                end
            end
        end
    end
end)

RegisterNetEvent("housing:charLogout")
AddEventHandler("housing:charLogout", function()
    if Housing.currentlyEditing ~= false then return end
    local cat = getHousingCatFromPropertID(Housing.currentHousingInteractions.id)
    local max = Housing.max[cat]
    if max.canHaveCharSelect then
        TransitionToBlurred(500)
        DoScreenFadeOut(500)
        exitingBuilding()
        TriggerServerEvent("jobssystem:jobs", "unemployed")
        Citizen.Wait(1000)
        exports["np-build"]:getModule("func").CleanUpArea()
        Citizen.Wait(1000)   
        TriggerEvent("np-base:clearStates")
        exports["np-ui"]:sendAppEvent("hud", { display = false })
        TriggerServerEvent("apartments:cleanUpRoom")
        exports["np-base"]:getModule("SpawnManager"):Initialize()
    
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent("housing:swapChars")
AddEventHandler("housing:swapChars", function()

        TransitionToBlurred(500)
        DoScreenFadeOut(500)
        Citizen.Wait(1000)   
        TriggerEvent("np-base:clearStates")
        exports["np-ui"]:sendAppEvent("hud", { display = false })
        TriggerServerEvent("apartments:cleanUpRoom")
        exports["np-base"]:getModule("SpawnManager"):Initialize()
    
        Citizen.Wait(1000)
end)

RegisterNetEvent("housing:internalBackdoor")
AddEventHandler("housing:internalBackdoor", function()
    local cat = getHousingCatFromPropertID(Housing.currentHousingInteractions.id)
    local max = Housing.max[cat]
    if max.canHaveBackDoor then
        if Housing.currentHousingInteractions.backdoor_coordinates.external == nil or Housing.currentHousingInteractions.backdoor_coordinates.external == vector3(0.0,0.0,0.0) then return end
        DoScreenFadeOut(1)
        exitingBuilding(Housing.currentHousingInteractions.backdoor_coordinates.external)
        DoScreenFadeIn(1900)
    end
end)

RegisterNetEvent("housing:frontdoor")
AddEventHandler("housing:frontdoor", function()
    DoScreenFadeOut(1)
    
    exitingBuilding(Housing.info[Housing.currentHousingInteractions.id][1])
    DoScreenFadeIn(1900)
end)

function exitingBuilding(overrideVector, skipExit)
    if Housing.currentlyRobInside and Housing.currentlyRobInside >= 1 then
        if math.random() < 0.25 then
            TriggerEvent("alert:houseRobbery")
        end
    end

    local id = Housing.currentHousingInteractions.id

    TriggerServerEvent("np-housing:halloween:playerExitProperty", id)

    if id then
        TriggerEvent("np-editor:destroyName","housing-"..id)
    end

    if Housing.currentlyEditing == false then
        Housing.currentHousingInteractions = nil
    end


    if not skipExit then
        exports["np-build"]:getModule("func").exitCurrentRoom(overrideVector)
    end
    Housing.currentAccess = nil
    Housing.currentlyInsideBuilding = false
end

AddEventHandler('np-housing:exitBuilding', exitingBuilding)

RegisterNetEvent("housing:kickFromHouse")
AddEventHandler("housing:kickFromHouse", function(propertyID)
    if Housing.currentHousingInteractions == nil then return end
    local id = Housing.currentHousingInteractions.id
    if id == propertyID then
        DoScreenFadeOut(1)
        exports["np-build"]:getModule("func").exitCurrentRoom(Housing.info[id][1])
        exitingBuilding()
        DoScreenFadeIn(1900)
    end
end)

function Housing.func.loadInteractions(model,overWrite)

    local interactionPoints = {}
    local publicCrafting = exports["np-config"]:GetMiscConfig("housing.crafting.public")

    for i=1,#Housing.interactionlist do
        local name = Housing.interactionlist[i].name
        if not overWrite then
            if name == "internal_exit" then
                goto skip_to_next
            end
        else    
            if name ~= "internal_exit" then
                name = "none"
            end
        end

        local interaction = Housing.currentHousingInteractions[name]
        if name == "backdoor_offset_internal" then 
            interaction = Housing.currentHousingInteractions.backdoor_coordinates.internal
        end

        if name == "internal_exit" and overWrite then
            interaction = Housing.typeInfo[model].exitOffset
        end

        local max = Housing.max[Housing.typeInfo[model].cat]

        if interaction == vector3(0.0,0.0,0.0) or interaction == nil then
            goto skip_to_next
        end

        if (name == "inventory_offset" and max.canHaveInventory) or (name == "charChanger_offset" and max.canHaveCharSelect) or (name == "crafting_offset" and (max.canHaveCrafting or (max.publicCrafting and publicCrafting))) or (name == "backdoor_offset_internal" and max.canHaveBackDoor) or (name == "internal_exit" and overWrite) then
            interactionPoints[#interactionPoints+1] = {
                ["offset"] = interaction,
                ["viewDist"] = 2.0,
                ["useDist"] = 2.0,
                ["generalUse"] = Housing.interactionlist[i].event["generalUse"],
                ["housingMain"] = Housing.interactionlist[i].event["housingMain"],
                ["housingSecondary"] = Housing.interactionlist[i].event["housingSecondary"],
            }
        end

        ::skip_to_next::
    end

    local isBuiltCoords = exports["np-build"]:getModule("func").addInteractionPoints(model,interactionPoints,overWrite)
end

RegisterNetEvent("housing:interactionTriggered")
AddEventHandler("housing:interactionTriggered", function()
    InteractionPressed()
end)

function isGov()
    local myjob = exports["isPed"]:isPed("myjob")
    if myjob == "police" then return true end
    if myjob == "judge" then return true end
    return false
end

local timeout = 0
function InteractionPressed()
    local curTime = GetGameTimer()

    if Housing.lockpicking then return end
    if Housing.currentlyInsideBuilding then
        if curTime - timeout < 2000 then
            return
        end
        timeout = GetGameTimer()
        interactRob()
        return 
    end


    local isComplete, propertyID, dist, zone = Housing.func.findClosestProperty()
    if not isComplete then return end
    if getHousingCatFromPropertID(propertyID) == "buisness" then return false end
    

    if curTime - timeout < 2000 then
        return
    end
    timeout = GetGameTimer()

    if dist > Housing.ranges.editRange then return end
    
    local player = GetEntityCoords(PlayerPedId())
    local finished,housingInformation,currentHousingLocks,isResult,housingLockdown,housingRobbed,robTargets,robLocations,alarm,currentAccess = RPC.execute("getCurrentSelected",propertyID)

    if type(housingLockdown) == "table" then
        Housing.currentHousingLockdown = housingLockdown
    end

    if type(currentHousingLocks) == "table" then
        Housing.currentHousingLocks = currentHousingLocks
    end

    if type(housingRobbed) == "table" then
        Housing.housingBeingRobbedClient = housingRobbed
    end

    if type(robTargets) == "table" then
        Housing.housingRobTargets = robTargets
    end

    if type(robLocations) == "table" then
        Housing.robPosLocations = robLocations
    end

    if type(currentAccess) == "table" then
        Housing.currentAccess = currentAccess
    end

    local cat = getHousingCatFromPropertID(propertyID)
    local max = Housing.max[cat] 

    local hasBeenRobbed = false
    if Housing.housingBeingRobbedClient ~= nil and Housing.housingBeingRobbedClient[propertyID] ~= nil and Housing.housingBeingRobbedClient[propertyID].hasBeenRobbed == true then
        hasBeenRobbed = true
    end

    if not isGov() then
        if (Housing.currentHousingLocks == nil or Housing.currentHousingLocks[propertyID] == nil) and #(vec3FromVec4(Housing.info[propertyID][1])-player) <= 4.5 and not hasBeenRobbed then
            TriggerEvent("DoLongHudText","Property is locked",2)
            return
        end
    end

    if not isPropertyActive(propertyID) then return end

    if hasBeenRobbed then

        local finished,destroyedTable = RPC.execute("getDestroyedTable",propertyID)
        if type(destroyedTable) == "table" then
            Housing.destroyedObjects = destroyedTable
        end

        attemptToLockPickHouse(true)
        return
    end

    local characterId = exports["isPed"]:isPed("cid")

    if Housing.currentlyEditing == false then
        local pos = housingInformation
        if #(pos.backdoor_coordinates.external-player) <= Housing.ranges.doorEnterRange and max.canHaveBackDoor then
            if not isLocked(propertyID) then
                if lockdownCheck(propertyID) then
                    if pos.backdoor_coordinates.internal ~= vector3(0.0,0.0,0.0) and pos.backdoor_coordinates.internal ~= nil then
                        Housing.func.enterBuilding(propertyID,pos.backdoor_coordinates.internal)
                    end
                else
                    TriggerEvent("DoLongHudText","Property on lockdown , you may not enter the building",2)
                end
            end
            return
        end
    end
    
    if #(vec3FromVec4(Housing.info[propertyID][1])-player) <= Housing.ranges.doorEnterRange then
        if not isGov() then
            if Housing.currentHousingLocks == nil or Housing.currentHousingLocks[propertyID] == nil then
                TriggerEvent("DoLongHudText","Property is locked",2)
                return
            end
        end
        
        if isGov() then
            Housing.func.enterBuilding(propertyID) 
        else
            if not isLocked(propertyID) then
                if lockdownCheck(propertyID) then 
                    Housing.func.enterBuilding(propertyID) 
                else
                    TriggerEvent("DoLongHudText","Property on lockdown , you may not enter the building",2)
                end
            end
        end

        return
    end

end

function canPlaceInteractionPoint(nameIncoming,pos)
    local canPlace = true
    for k,v in pairs(Housing.interactionlist) do
        local name = v.name
        if name == "backdoor_offset_internal" then
            if Housing.currentHousingInteractions.backdoor_coordinates.internal == vector3(0,0,0) then goto continue end
            local dist = #(Housing.currentHousingInteractions.backdoor_coordinates.internal-pos)
            if dist <= 2.0 then
                canPlace = false
                break
            end
        else
            if name ~= nameIncoming then
                if Housing.currentHousingInteractions[name] == nil or Housing.currentHousingInteractions[name] == vector3(0,0,0) then goto continue end
                local dist = #(Housing.currentHousingInteractions[name]-pos)
                if dist <= 2.0 then
                    canPlace = false
                    break
                end
            end
        end
        ::continue::
    end

    if not canPlace then
        TriggerEvent("DoLongHudText","Cannot place point here , may be to close to another point.",2)
    end
    
    return canPlace
end

function lockdownCheck(propertyID)
    local myjob = exports["isPed"]:isPed("myjob")

    if Housing.currentHousingLockdown == nil then return true end
    if Housing.currentHousingLockdown[propertyID] == nil then return true end
    if Housing.currentHousingLockdown[propertyID] and (myjob == "police" or myjob == "judge") then 
        return true
    end
    return false
end

function taxCheck(propertyId)
    local taxCheck = RPC.execute("housing:isOverdueOnTaxes", propertyId)
    return taxCheck
end
