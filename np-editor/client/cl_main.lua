local menuOpen = false
local camera = false
local CURRENT_MODULES = {
    ["objects"] = false
}

local firstSelect = false

CURRENT_FLAGS = {}
CURRENT_OFFSETS = {
    zone = vector3(0, 0, 0),
    z = 0,
    origin = vector3(0, 0, 0),
}

-- Resource Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    DestoryCameras()
    SendNuiMessage(json.encode({ action = 'hide' }))
    SetNuiFocus(false)
end)

function LoadModel(model)
    local attempts = 0
    while attempts < 100 and not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
        attempts = attempts + 1
    end
    return IsModelValid(model)
end

function GetHashName(hash)
    if HASH_MODELS[hash] then
        return HASH_MODELS[hash]
    end
    return hash
end



local playerOriginalCoords = false

function CreateCameras()
    Citizen.CreateThread(function()
        camera = CreateCamera(`DEFAULT_SCRIPTED_CAMERA`, false)
        if DoesCamExist(camera) then
            SetCamCoord(camera, GetGameplayCamCoord())
            SetCamRot(camera, GetGameplayCamRot())
            SetCamFov(camera, 70.0)

            --print('camera', camera)
            SetCamActive(camera, true)
            SetCamFov(camera, 50.0)
            RenderScriptCams(true, true, 1000)
            local player = PlayerPedId()
            playerOriginalCoords = GetEntityCoords(player) - vector3(0.0, 0.0, 1.0)
            --print(playerOriginalCoords)
            FreezeEntityPosition(player, true)
            SetEntityVisible(player, false)
            SetEntityCoords(player, GetGameplayCamCoord())
        end
    end)
end

function DestoryCameras()
    if DoesCamExist(camera) then
        RenderScriptCams(false, true, 1000)
        Citizen.CreateThread(function()
            Wait(250)
            DestroyCam(camera)
        end)
        local player = PlayerPedId()
        if not IsEntityVisible(player) then
            FreezeEntityPosition(player, false)
            SetEntityVisible(player, true)
            SetEntityCoords(player, playerOriginalCoords)
        end
    end
end

function loadModuleInserts(data)
    SendNuiMessage(json.encode({ action = 'insert', info = data }))
end

RegisterNetEvent("np-editor:loadEditor")
AddEventHandler("np-editor:loadEditor", function(data)
    loadEditor(data)
end)

function loadEditor(data)
    CURRENT_NAME  = data.name
    AUTOSAVE_RUNNING = data.autosave
    CURRENT_FLAGS = data.flags

    for k,v in pairs(data.modules) do
        if CURRENT_MODULES[v] ~= nil then
            CURRENT_MODULES[v] = true
        end
    end

    if AUTOSAVE_RUNNING then
        autoSave()
    end

    if data.zone then
        local zone = data.zone
        createZone(zone.pos,zone.length,zone.width,zone.minZ,zone.maxZ,zone.heading)
    end

    CreateCameras()
    pedToModel(data.name)
    SendNuiMessage(json.encode({ action = 'show', modules = CURRENT_MODULES }))
    menuOpen = true
    SetNuiFocus(true, true)
    SendNuiMessage(json.encode({ action = 'rebuild_valid' }))
end

--[[
RegisterCommand('edit', function()
    local data = {
        name = "housing-180",
        flags = {['isShop'] = true},
        autosave = true,
        zone = {
            pos = GetEntityCoords(PlayerPedId()),
            length = 40.0,
            width = 30.0,
            minZ = 10.0,
            maxZ = 10.0,
            heading = 340.0
        },
        modules = {
            "objects",
        }
    }
    loadEditor(data)
    --loadPeekingModels()
end)
]]

RegisterCommand('save', function()
    TriggerServerEvent("SaveRemovedObjects",CURRENT_REMOVED)
end)

RegisterCommand('check', function()
    check()
end)


RegisterNuiCallbackType('close_ui')
AddEventHandler('__cfx_nui:close_ui', function(data, callback)
    SetNuiFocus(false)
    DestoryCameras()
    TriggerServerEvent("exitFurniture",CURRENT_NAME)
    TriggerEvent("np-editor:closeEditor",CURRENT_NAME)
    closingUI()
    menuOpen = false
    clearActionObjects()
    destroyZone()
    SendNuiMessage(json.encode({ action = 'rebuild_valid' }))
    CURRENT_NAME = nil
    CURRENT_FLAGS = {}
    callback({})
end)



RegisterNuiCallbackType('valid_objects')
AddEventHandler('__cfx_nui:valid_objects', function(data, callback)
    getCurrentFav()

    readyModels(true)

    local callbackTable = {
        validObjects = json.encode(HASH_MODELS),
        fav = json.encode(FAV_OBJECTS)
    }

    callback(callbackTable)
end)



local drawLineToEntity = false

RegisterNuiCallbackType('spawn')
AddEventHandler('__cfx_nui:spawn', function(data, callback)
    --print('data.model', data.model)
    local modelHash = GetHashKey(data.model)
    if IsModelValid(modelHash) and LoadModel(modelHash) then
        local modelHashName = GetHashName(modelHash)
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local entityId = CreateObject(modelHash, playerCoords.x, playerCoords.y, playerCoords.z, false, false, false, true, true)
        if DoesEntityExist(entityId) then
            drawLineToEntity = entityId
            local entityAlpha = GetEntityAlpha(entityId)
            local entityRotation = GetEntityRotation(entityId, 2)
            FreezeEntityPosition(entityId, true)
            callback({
                exists = true,
                hash = modelHashName,
                id = entityId,
                alpha = entityAlpha,
                x = playerCoords.x,
                y = playerCoords.y,
                z = playerCoords.z,
                pitch = entityRotation.x,
                roll = entityRotation.y,
                yaw = entityRotation.z,
            })
        else
            drawLineToEntity = false
            callback({ exists = false })
        end
    else
        drawLineToEntity = false
        callback({ exists = false })
    end
end)

RegisterNuiCallbackType('load_entity_info')
AddEventHandler('__cfx_nui:load_entity_info', function(data, callback)
    local entityId = data.id
    if DoesEntityExist(entityId) and IsEntityAnObject(entityId) then
        
        if not firstSelect then
            ObjectToNui(CURRENT_NAME,true)
            firstSelect = true
        end 

        local modelHash = GetEntityModel(entityId)
        local modelHashName = GetHashName(modelHash)
        drawLineToEntity = entityId
        local entityAlpha = GetEntityAlpha(entityId)
        local entityCoords = GetEntityCoords(entityId, true, true)
        local entityRotation = GetEntityRotation(entityId, 2)
        local camCoords = GetGameplayCamCoord()
        callback({
            exists = true,
            id = entityId,
            hash = modelHashName,
            alpha = entityAlpha,
            x = entityCoords.x,
            y = entityCoords.y,
            z = entityCoords.z,
            pitch = entityRotation.x,
            roll = entityRotation.y,
            yaw = entityRotation.z,
            distance = #(camCoords - entityCoords),
        })
    else
        drawLineToEntity = false
        callback({ exists = false })
    end
end)

RegisterNuiCallbackType('edit_entity')
AddEventHandler('__cfx_nui:edit_entity', function(data, callback)
    local entityId = data.id
    if DoesEntityExist(entityId) then
        if CURRENT_ZONE then
            if not CURRENT_ZONE:isPointInside(vector3(data.x * 1.0, data.y * 1.0, data.z * 1.0)) then return end
        end
        CURRENT_EDITED[entityId] = true
        SetEntityAlpha(entityId, data.alpha, false)
        SetEntityCoords(entityId, data.x * 1.0, data.y * 1.0, data.z * 1.0)
        SetEntityRotation(entityId, data.pitch * 1.0, data.roll * 1.0, data.yaw * 1.0, 0, true)
    end
    callback({})
end)

RegisterNuiCallbackType('ground_object')
AddEventHandler('__cfx_nui:ground_object', function(data, callback)
    local entityId = data.id
    if DoesEntityExist(entityId) then
        PlaceObjectOnGroundProperly(entityId)
        local modelHash = GetEntityModel(entityId)
        local modelHashName = GetHashName(modelHash)
        drawLineToEntity = entityId
        local entityAlpha = GetEntityAlpha(entityId)
        local entityCoords = GetEntityCoords(entityId, true, true)
        local entityRotation = GetEntityRotation(entityId, 2)
        local camCoords = GetGameplayCamCoord()
        callback({
            exists = true,
            id = entityId,
            hash = modelHashName,
            alpha = entityAlpha,
            x = entityCoords.x,
            y = entityCoords.y,
            z = entityCoords.z,
            pitch = entityRotation.x,
            roll = entityRotation.y,
            yaw = entityRotation.z,
            distance = #(camCoords - entityCoords),
        })
    else
        callback({})
    end
end)

RegisterNuiCallbackType('delete_entity')
AddEventHandler('__cfx_nui:delete_entity', function(data, callback)
    local entityId = data.id
    local forcedId = data.forcedId
    removeObject(entityId,forcedId)

    if DoesEntityExist(entityId) then
        SetEntityAsMissionEntity(entityId, true, true)
        DeletePed(entityId)
        DeleteEntity(entityId)
    end
    drawLineToEntity = false
    callback({})
end)

RegisterNuiCallbackType('rotate_camera')
AddEventHandler('__cfx_nui:rotate_camera', function(data, callback)
    --local screenX, screenY = GetScreenResolution()
    local screenX = data.screenX
    local screenY = data.screenY
    local xMult = 2 * 360 / screenX
    local yMult = 2 * 360 / screenY
    if camera then
        local cameraRot = GetCamRot(camera)
        cameraRot = cameraRot + vector3(-data.y * yMult, 0.0, -data.x * xMult)
        SetCamRot(camera, cameraRot)
        SetEntityRotation(PlayerPedId(), cameraRot, 0, true)
    end
    callback({})
end)

RegisterNuiCallbackType('move_camera')
AddEventHandler('__cfx_nui:move_camera', function(data, callback)
    if camera then
        if CURRENT_ZONE then
            if not CURRENT_ZONE:isPointInside(vector3(data.x, data.y, data.z)) then return end
        end
        SetCamCoord(camera, vector3(data.x, data.y, data.z))
        SetEntityCoords(PlayerPedId(), vector3(data.x, data.y, data.z))
    end
    callback({})
end)

Citizen.CreateThread(function()
    while true do
        Wait(10)
        if not menuOpen then
            Wait(1000)
        end
        local camCoords = GetGameplayCamCoord()
        local camRot = GetGameplayCamRot(1)
        local camFov = GetGameplayCamFov()
        local entity = {}
        if camera and IsCamActive(camera) then
            camCoords = GetCamCoord(camera)
            camRot = GetCamRot(camera, 1)
            camFov = GetCamFov(camera)
        end
        if drawLineToEntity then
            entity.position = GetEntityCoords(drawLineToEntity)
            entity.rotation = GetEntityRotation(drawLineToEntity)
        end
        SendNuiMessage(json.encode({
            action = 'update_positions',
            cam = {
                position = camCoords,
                rotation = camRot,
                fov = camFov,
            },
            entity = entity,
        }))
    end
end)

RegisterNuiCallbackType('select_entity')
AddEventHandler('__cfx_nui:select_entity', function(data, callback)

        local offset = vector2(data.x,data.y)
        local coords = ScreenRelToWorld(GetCamCoord(camera), GetCamRot(camera,2),offset)
        local hit, endCoords, entityHit = LocationInWorld(coords,camera,1 + 16 + 32 + 64 + 256)
        if BANNED_ENTITY[CURRENT_NAME] and BANNED_ENTITY[CURRENT_NAME][entityHit] then
            entityHit = 0
            hit = 0
        end
        callback({
            hit = hit,
            entity = entityHit
        })
end)

local spawnGhost = false
local currentModel = nil
RegisterNuiCallbackType('start_entity_placement')
AddEventHandler('__cfx_nui:start_entity_placement', function(data, callback)
    --print('data.model', data.model)
    local modelHash = GetHashKey(data.model)
    if IsModelValid(modelHash) and LoadModel(modelHash) then
        if currentModel == modelHash then return end
        currentModel = modelHash
        if spawnGhost then
            if DoesEntityExist(spawnGhost) then
                DeletePed(spawnGhost)
                DeleteEntity(spawnGhost)
            end
        end

        local offset = vector2(0.5,0.5)
        local coords = ScreenRelToWorld(GetCamCoord(camera), GetCamRot(camera,2),offset)
        local hit, endCoords, entityHit = LocationInWorld(coords,camera,-1)

        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)

        if hit then
            local midPoint = GetOffsetFromEntityInWorldCoords(player, 0.0, 4.0, -2.0 )

            spawnGhost = CreateObject(modelHash, midPoint.x, midPoint.y, midPoint.z, false, false, false, true, true)

            local d1,d2 = GetModelDimensions(GetEntityModel(spawnGhost))
            local pos = GetEntityCoords(spawnGhost)
            local bot = GetOffsetFromEntityInWorldCoords(spawnGhost, 0.0,0.0,d1["z"])

            local newZ = vector3(pos-bot)
        else
            spawnGhost = CreateObject(modelHash, playerCoords.x, playerCoords.y, playerCoords.z, false, false, false, true, true)
        end


        --print('spawnGhost', spawnGhost)
        SetEntityAlpha(spawnGhost, 200)
        FreezeEntityPosition(spawnGhost, true)
    end
    callback({
        entity = spawnGhost
    })
end)


RegisterNuiCallbackType('end_entity_placement')
AddEventHandler('__cfx_nui:end_entity_placement', function(data, callback)
    if data.create then
        SetEntityAlpha(spawnGhost, 255)
        local data = {
            id = spawnGhost
        }
        addEntityCurrent(data)
        ObjectToNui(CURRENT_NAME,true)
        spawnGhost = false

    else
        SetEntityAsMissionEntity(spawnGhost, true, true)
        DeleteEntity(spawnGhost)
        spawnGhost = false
    end
    callback({})
end)
