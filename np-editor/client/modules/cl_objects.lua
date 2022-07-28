FAV_OBJECTS = nil
CURRENT_OBJECTS = nil
CURRENT_ENTITY = nil
CURRENT_NAME = nil
CURRENT_DELETED = {}
AUTOSAVE_TIME = 300000 -- 5 mins
AUTOSAVE_RUNNING = false
BANNED_ENTITY = {}
CURRENT_SPECIAL = nil
CURRENT_EDITED = {}
CURRENT_REMOVED = {}

CURRENT_ISSAVING = false
CURRENT_DONTDELETE = {}
CURRENT_NPC = {}
CURRENT_ISSHOP = false

RegisterNuiCallbackType('update_fav')
AddEventHandler('__cfx_nui:update_fav', function(data, callback)
   local fav = data.fav
   FAV_OBJECTS = fav
   exports["storage"]:set(fav,"furnitureFav")
   callback({})
end)


function getCurrentFav()
    FAV_OBJECTS = exports["storage"]:tryGet("table","furnitureFav")
    return FAV_OBJECTS
end


RegisterNuiCallbackType('add_entity_current')
AddEventHandler('__cfx_nui:add_entity_current', function(data, callback)
    addEntityCurrent(data)
    callback(ObjectToNui(CURRENT_NAME,false))
end)

function addEntityCurrent(data)

    local entityId = data.id
    if CURRENT_NAME == nil then return end

    if DoesEntityExist(entityId) and IsEntityAnObject(entityId) then
        
        if CURRENT_ENTITY and CURRENT_ENTITY[CURRENT_NAME] then
            local found = false
            for k,v in pairs(CURRENT_ENTITY[CURRENT_NAME]) do
                if entityId == v then
                    found = true
                    break
                end
            end
            if found then return end
        end

        local placedName = GetEntityModel(entityId)
        if PLACED_LIST[placedName] then
            placedName = PLACED_LIST[placedName]
        end
        local x,y,z,w = GetEntityQuaternion(entityId)


        SetEntityQuaternion(entityId,0.0 ,0.0 ,0.0 ,0.0)
        local d1,d2 = GetModelDimensions(GetEntityModel(entityId))
        local pos = GetEntityCoords(entityId)
        local bot = GetOffsetFromEntityInWorldCoords(entityId, 0.0,0.0,d1["z"])

        local newZ = vector3(pos-bot)
        SetEntityQuaternion(entityId,x,y,z,w) 

        local addData = {
            name = CURRENT_NAME,
            modelHash = GetEntityModel(entityId),
            coords = vector3(pos.x,pos.y,pos.z-newZ.z),
            quat = vector4(x,y,z,w),
            realName = placedName
        }

        local addedItem = addItemToCurrent(addData)

        if addedItem then
            if CURRENT_ENTITY == nil then CURRENT_ENTITY = {} end
            if CURRENT_ENTITY[CURRENT_NAME] == nil then CURRENT_ENTITY[CURRENT_NAME] = {} end
            
            CURRENT_ENTITY[CURRENT_NAME][#CURRENT_ENTITY[CURRENT_NAME]+1] = entityId
        end
    end
    
end

RegisterNuiCallbackType('remove_entity_current')
AddEventHandler('__cfx_nui:remove_entity_current', function(data, callback)
    removeObject(data.id)
    callback({})
end)

RegisterNuiCallbackType('rebuild_current')
AddEventHandler('__cfx_nui:rebuild_current', function(data, callback)
    rebuildCurrent(CURRENT_NAME)
    callback({})
end)

RegisterCommand('rebuild', function()
    rebuildCurrent(CURRENT_NAME)
    callback({})
end)

RegisterNuiCallbackType('force_save')
AddEventHandler('__cfx_nui:force_save', function(data, callback)
    if CURRENT_NAME then
        updateAllEntity()
        saveObjects(CURRENT_NAME)
    end
    callback({})
end)

RegisterNuiCallbackType('removeFromValid')
AddEventHandler('__cfx_nui:removeFromValid', function(data, callback)
    local info = data.info
    --CURRENT_REMOVED[info] = true
    --print("Added "..info)
    callback({})
end)


function rebuildCurrent(name)

    cleanUpArea(name)

    if CURRENT_OBJECTS and CURRENT_OBJECTS[name] then
        for k,v in pairs(CURRENT_OBJECTS[name]) do
            local modelHash = v.model
            if IsModelValid(modelHash) and LoadModel(modelHash) then
                if CURRENT_ISSHOP and v.realName == 'prop_ped_gib_01' then
                    goto continueSkip
                end
                local modelHashName = GetHashName(modelHash)
                local coords = applyOffsets(v.coords)
                local entityId = CreateObject(modelHash, coords.x, coords.y, coords.z, false, false, false, true, true)
                if entityId then
                    FreezeEntityPosition(entityId, true)
                    SetEntityQuaternion(entityId,v.quat)
                    CURRENT_ENTITY[name][#CURRENT_ENTITY[name]+1] = entityId
                end
            end
            ::continueSkip::
        end
    end
end

exports('rebuildCurrent', rebuildCurrent)

RegisterNetEvent("np-editor:buildName")
AddEventHandler("np-editor:buildName", function(name,objects, offsets, isShop)
    if objects then
        BANNED_ENTITY[name] = objects
    end

    if offsets then
        CURRENT_OFFSETS = offsets
    end

    CURRENT_ISSHOP = isShop
    loadObjects(name)
    rebuildCurrent(name)
    ObjectToNui(name,true)

    
end)

RegisterNetEvent("np-editor:destroyName")
AddEventHandler("np-editor:destroyName", function(name)
    cleanUpArea(name)
    BANNED_ENTITY[name] = nil
    CURRENT_ISSHOP = false
    removeNPC()
end)

function cleanUpArea(name)
    if CURRENT_ENTITY and CURRENT_ENTITY[name] then
        for k,v in pairs(CURRENT_ENTITY[name]) do
            if DoesEntityExist(v) and not CURRENT_DONTDELETE[v] then
                SetEntityAsMissionEntity(v, true, true)
                DeletePed(v)
                DeleteEntity(v)
                DeleteObject(v)
            end
        end
    end


    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 50.0 and ObjectFound ~= playerped then
            local model = GetEntityModel(ObjectFound)
            local ignore = false
            if BANNED_ENTITY[name] and BANNED_ENTITY[name][ObjectFound] then
                ignore = true
            end
            if not ignore then
                if IsEntityAPed(ObjectFound) then
                    if IsPedAPlayer(ObjectFound) then
                    else
                        DeleteObject(ObjectFound)
                    end
                else
                    if not IsEntityAVehicle(ObjectFound) and not IsEntityAttached(ObjectFound) and not DecorGetBool(ObjectFound, "DontClear") then
                        DeleteObject(ObjectFound)
                    end
                end
            end           
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    EndFindObject(handle)

    CURRENT_ENTITY = {}
    CURRENT_ENTITY[name] = {}
end

function removeObject(entityId,forcedId)
    if CURRENT_NAME == nil then return end
    if CURRENT_OBJECTS == nil then return end
    if CURRENT_OBJECTS[CURRENT_NAME] == nil then return end

    local foundID = -1
    if not forcedId then
        local modelHash = GetEntityModel(entityId)
        local coords = GetEntityCoords(entityId, true, true)

        for k,v in pairs(CURRENT_OBJECTS[CURRENT_NAME]) do
            if CURRENT_ENTITY[CURRENT_NAME] and CURRENT_ENTITY[CURRENT_NAME][k] == entityId then
                local x,y,z,w = GetEntityQuaternion(entityId)
                CURRENT_OBJECTS[CURRENT_NAME][k].coords = GetEntityCoords(entityId, true, true)
                CURRENT_OBJECTS[CURRENT_NAME][k].quat = vector4(x,y,z,w)
            
                if v.model == modelHash then
                    if(CURRENT_OFFSETS.zone.x == 0.0 and CURRENT_OFFSETS.zone.y == 0.0) then
                        if #(v.coords - coords) < 1 then
                            foundID = k
                        end
                    else
                        if #(applyOffsets(v.coords) - coords) < 1 then
                            foundID = k
                        end
                    end
                end
            end
        end
        if foundID == -1 then return end
        removeFromTable(foundID)
    else
        for k,v in pairs(CURRENT_OBJECTS[CURRENT_NAME]) do
            if v.id == forcedId then
                foundID = k
            end
        end

        if foundID == -1 then return end
        removeFromTable(foundID)
        rebuildCurrent(CURRENT_NAME)
    end

    ObjectToNui(CURRENT_NAME,true)
    saveObjects(CURRENT_NAME)

end

function removeFromTable(foundID)
    CURRENT_DELETED[#CURRENT_DELETED+1] = CURRENT_OBJECTS[CURRENT_NAME][foundID].id
    table.remove(CURRENT_OBJECTS[CURRENT_NAME], foundID)
    if CURRENT_ENTITY ~= nil and CURRENT_ENTITY[CURRENT_NAME] ~= nil and CURRENT_ENTITY[CURRENT_NAME][foundID] ~= nil then 
        table.remove(CURRENT_ENTITY[CURRENT_NAME], foundID)
    end
end

function ObjectToNui(name,pass)
    local sortedObject = {}
    if not CURRENT_OBJECTS or not CURRENT_OBJECTS[name] then return end

    for k,v in pairs(CURRENT_OBJECTS[name]) do
        sortedObject[k] = {CURRENT_ENTITY[name][k],v.realName,v.id}
    end

    if pass then
        SendNuiMessage(json.encode({
            action = 'update_currentObjects',
            objects = sortedObject
        }))
    end

    return {currentObjects = sortedObject}
end

function closingUI()
    updateAllEntity()
    saveObjects(CURRENT_NAME)
    modelToPed(CURRENT_NAME)
end

function modelToPed(name)
    if not CURRENT_ISSHOP then return end
    for k,v in pairs(CURRENT_ENTITY[name]) do
        if GetEntityModel(v) == GetHashKey('prop_ped_gib_01') then
            DeleteEntity(v)
            DeleteObject(v)
        end
    end
    CURRENT_DONTDELETE = {}

    if CURRENT_OBJECTS then
        for k,v in pairs(CURRENT_OBJECTS[name]) do
            if v.realName == 'prop_ped_gib_01' then
                local coords = applyOffsets(v.coords)
                local entityId = CreateObject(v.model, coords.x, coords.y, coords.z, false, false, false, true, true)

                if entityId then
                    FreezeEntityPosition(entityId, true)
                    SetEntityQuaternion(entityId,v.quat)
                    local heading = GetEntityHeading(entityId) - 180
                    DeleteEntity(entityId)
                    DeleteObject(entityId)
                    buildNPC(coords, heading)
                end
            end
        end
    end
end


function buildNPC(coords, heading)
    if not NPC_CONFIG then return end
    if not CURRENT_ISSHOP then return end
    
    local npc = NPC_CONFIG['store']

    local data = {
        id = npc.id..math.random(10000)..'x'..math.random(10000),
        position = {
            coords = coords,
            heading = heading,
        },
        pedType = npc.pedType,
        model = npc.model,
        networked = npc.networked,
        distance = npc.distance,
        settings = npc.settings,
        flags = npc.flags,
    }

    local seller = exports["np-npcs"]:RegisterNPC(data, "np-build")
    exports["np-npcs"]:EnableNPC(seller.id)
    CURRENT_NPC[seller.id] = true


    for o,i in pairs(npc.peek) do
        exports["np-interact"]:AddPeekEntryByFlag({ "isNPC" }, {
            {
            id = i.id..o,
            label = i.label,
            icon = i.icon,
            event = i.event,
            parameters = {},
            },
        }, {
            distance = { radius = 2.5 },
            npcIds = { seller.id },
        })
    end

end

function removeNPC()
    if CURRENT_NPC then
        for k,v in pairs(CURRENT_NPC) do
            exports["np-npcs"]:DisableNPC(k)
            exports["np-npcs"]:RemoveNPC(k)
        end

        CURRENT_NPC = {}
    end
end

function pedToModel(name)
    if CURRENT_OBJECTS and CURRENT_ISSHOP then
        for k,v in pairs(CURRENT_OBJECTS[name]) do
            if v.realName == 'prop_ped_gib_01' then

                local found = false;
                for u,j in pairs(CURRENT_ENTITY[name]) do
                    if GetEntityModel(j) == v.model and #(GetEntityCoords(j) - v.coords) < 0.2 then
                        found = true;
                    end
                end

                if not found then
                    local coords = applyOffsets(v.coords)
                    local entityId = CreateObject(v.model, coords.x, coords.y, coords.z, false, false, false, true, true)

                    if entityId then
                        FreezeEntityPosition(entityId, true)
                        SetEntityQuaternion(entityId,v.quat)
                        CURRENT_DONTDELETE[entityId] = true
                        CURRENT_ENTITY[name][k] = entityId
                    end
                end

                removeNPC()
            end
        end
    end
end

--[[
    data to be passed
    - storage name, string
    - modelHash, string 
    - Coords, vector3
    - Rotation, vector3

]]
function addItemToCurrent(data, fromObjects)
    if data == nil or data.name == nil or data.modelHash == nil then return false end
    local name = data.name

    if CURRENT_OBJECTS == nil then CURRENT_OBJECTS = {} end
    if CURRENT_OBJECTS[name] == nil then CURRENT_OBJECTS[name] = {} end

    local object = {
        model = data.modelHash,
        coords = data.coords,
        quat = type(data.quat) == 'vector4' and data.quat or vector4(data.quat.x, data.quat.y, data.quat.z, data.quat.w),
        realName = data.realName,
        id = -1,
        changed = false
    }

    CURRENT_OBJECTS[name][#CURRENT_OBJECTS[name]+1] = object
    saveObjects(name)
    return true

end

exports('addItemToCurrent', addItemToCurrent)


function saveObjects(name)
    if name == nil then return end
    if CURRENT_OBJECTS == nil or CURRENT_OBJECTS[name] == nil  then return end
    if CURRENT_ISSAVING then
        TriggerEvent("DoLongHudText", "Saving already in progress", 2)
        print("Error: Saving already in progress")
        return
    end

    local ToRecompile = {
        ["objects"] = {}
    }

    local jsonObject = nil
    for k,data in pairs(CURRENT_OBJECTS[name]) do
        local coord = vector3Conversion(removeOffsets(data.coords))
        local quat = vector4Conversion(data.quat)
        if quat == nil or coord == nil then return end

        local object = {
            model = data.model,
            coords = coord,
            quat = quat,
            realName = data.realName,
            id = data.id,
            changed = data.changed,
            dataK = k 
        }

        if jsonObject == nil then jsonObject = {} end
        
        if object.changed or object.id == -1 then
            jsonObject[#jsonObject+1] = object
        end

        ToRecompile.objects[k] = object
    end

    local dataToSend = {
        name = name,
        objects = jsonObject,
        deleted = CURRENT_DELETED,
    }
    
    CURRENT_ISSAVING = true
    local changedTable = RPC.execute("objects:saveObjects",dataToSend)
    CURRENT_DELETED = {}

    if changedTable == nil then
        CURRENT_ISSAVING = false
        TriggerEvent("DoLongHudText", "Saving has failed..", 2)
        print("Error: return payload is empty , Saving Failed")
    else
        CURRENT_ISSAVING = false
        if changedTable.name ~= name then return end
        if changedTable.objects == nil then return end
        

        for k,v in pairs(changedTable.objects) do
            ToRecompile.objects[v.dataK] = v
        end

        recompileObjects(ToRecompile,name)
    end

    
    
    return finished
end

function recompileObjects(data,name)
    for k,v in pairs(data.objects) do
        local model = v.model
        local coord = vector3Conversion(v.coords)
        local quat = vector4Conversion(v.quat)

        local matching = nil
        local oldID = nil
        if CURRENT_OBJECTS ~= nil and CURRENT_OBJECTS[name] and CURRENT_OBJECTS[name][k] then
            matching = CURRENT_OBJECTS[name][k]
            oldID = CURRENT_OBJECTS[name][k].id
        end

        local object = {
            model = model,
            coords = coord,
            quat = quat,
            realName = v.realName,
            id = v.id,
            changed = false
        }

        if matching == nil then
            if CURRENT_OBJECTS == nil then CURRENT_OBJECTS = {} end
            if CURRENT_OBJECTS[name] == nil then CURRENT_OBJECTS[name] = {} end

            CURRENT_OBJECTS[name][k] = object
            
        else
            if matching.model == model and matching.coords == coord then
                if oldID == -1 then
                    CURRENT_OBJECTS[name][k] = nil
                    CURRENT_OBJECTS[name][k] = object
                end
            else
                CURRENT_OBJECTS[name][k] = nil
                CURRENT_OBJECTS[name][k] = object
            end
        end
    end

end

function loadObjects(name)
    local data = RPC.execute("objects:getObjects",name)
    if data.name ~= name then return end

    if data.objects == nil then return end
    recompileObjects(data,name)

    CURRENT_DELETED = {}
    rebuildCurrent(name)
    ObjectToNui(name,true)
    loadPeekingModels()
    modelToPed(name)
    return true
end

exports('loadObjects', loadObjects)

function vector3Conversion(vector,encode)
    local result = nil

    if type(vector) == "string" and not encode then
        local vectorTable = json.decode(vector)
        if vectorTable.x == nil then return nil end
        result = vector3(vectorTable.x,vectorTable.y,vectorTable.z)
    elseif type(vector) == "table" then
        if encode then
            result = json.encode(vector)
        else
            result = vector3(vector.x,vector.y,vector.z)
        end
        
    elseif type(vector) == "vector3" then
        local vectorTable = {x = vector.x, y = vector.y, z = vector.z}
        result = json.encode(vectorTable)
    end

    return result
end

function vector4Conversion(vector)
    local result = nil
    if type(vector) == "string" then
        local vectorTable = json.decode(vector)
        if vectorTable.x == nil then return nil end
        result = vector4(vectorTable.x,vectorTable.y,vectorTable.z,vectorTable.w)
    elseif type(vector) == "table" then
        result = vector4(vector.x,vector.y,vector.z,vector.w)    
    elseif type(vector) == "vector4" then
        local vectorTable = {x = vector.x, y = vector.y, z = vector.z, w = vector.w}
        result = json.encode(vectorTable)
    end

    return result
end

function updateAllEntity()
    if CURRENT_ENTITY and CURRENT_NAME and CURRENT_ENTITY[CURRENT_NAME] then
        for k,v in pairs(CURRENT_ENTITY[CURRENT_NAME]) do
            if DoesEntityExist(v) then

                local placedName = GetEntityModel(v)
                if PLACED_LIST[placedName] then
                    placedName = PLACED_LIST[placedName]
                end
                local x,y,z,w = GetEntityQuaternion(v)

                local shouldChange = false

                if CURRENT_OBJECTS[CURRENT_NAME][k] then
                    if #(GetEntityCoords(v, true, true) - CURRENT_OBJECTS[CURRENT_NAME][k].coords) > 1.2  and vector4(x,y,z,w) == vector4(0.0,0.0,0.0,0.0)then
                        shouldChange = true
                    end
    
                    if #(vector4(x,y,z,w) - CURRENT_OBJECTS[CURRENT_NAME][k].quat) > 0.2  then
                        shouldChange = true
                    end
                end

                if CURRENT_EDITED[v] then
                        shouldChange = true
                end

                SetEntityQuaternion(v,0.0 ,0.0 ,0.0 ,0.0)
                local d1,d2 = GetModelDimensions(GetEntityModel(v))
                local pos = GetEntityCoords(v)
                local bot = GetOffsetFromEntityInWorldCoords(v, 0.0,0.0,d1["z"])

                local newZ = vector3(pos-bot)
                SetEntityQuaternion(v,x,y,z,w)

                local object = {
                    model = GetEntityModel(v),
                    coords = vector3(pos.x,pos.y,pos.z-newZ.z),
                    quat = vector4(x,y,z,w),
                    realName = placedName,
                    id = CURRENT_OBJECTS[CURRENT_NAME][k] and CURRENT_OBJECTS[CURRENT_NAME][k].id or -1,
                    changed = shouldChange
                }
            
                CURRENT_OBJECTS[CURRENT_NAME][k] = object
            end
        end
    end
    CURRENT_EDITED = {}
end

function autoSave()
    Citizen.CreateThread(function()
        while AUTOSAVE_RUNNING do
            Wait(AUTOSAVE_TIME)
            if CURRENT_NAME then
                updateAllEntity()
                saveObjects(CURRENT_NAME)
            end
        end
    end)
end

function applyOffsets(vec3)
    if CURRENT_OFFSETS then
        vec3 = vector3(vec3.x + CURRENT_OFFSETS.zone.x, vec3.y + CURRENT_OFFSETS.zone.y, vec3.z + CURRENT_OFFSETS.z)
        vec3 = vec3 + CURRENT_OFFSETS.origin
    end
    return vec3
end

function removeOffsets(vec3)
    if CURRENT_OFFSETS then
        vec3 = vector3(vec3.x - CURRENT_OFFSETS.zone.x, vec3.y - CURRENT_OFFSETS.zone.y, vec3.z - CURRENT_OFFSETS.z)
        vec3 = vec3 - CURRENT_OFFSETS.origin
    end
    return vec3
end
