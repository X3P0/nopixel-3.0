isSelecting = nil
isPlacing = false
local obj = nil
local heading = 0.0
local currentCoords = nil

AddEventHandler("np-inventory:itemUsed", function (itemId, itemInfo)
    if not Config.crates[itemId] then return end
    if isSelecting then return end

    local playerPed = PlayerPedId()
    isSelecting = itemId

    obj = CreateObject(GetHashKey(Config.crates[itemId].model), GetEntityCoords(playerPed), 0, 0, 0)
    SetEntityHeading(obj, 0)
    SetEntityAlpha(obj, 100)

    CreateThread(function ()
        while isSelecting ~= nil do
            Wait(1)
            DisableControlAction(0, 22, true)
            if not isPlacing then
                getSelection()
            end
            if currentCoords then
                local z = currentCoords.z
                if Config.crates[itemId].vendor then
                    z = z + Config.crates[itemId].offset
                end
                SetEntityCoords(obj, currentCoords.x, currentCoords.y, z)
                SetEntityHeading(obj, heading)
            end
            if IsControlJustPressed(0, 38) then
                placeContainer(currentCoords, heading)
            end
            if IsControlJustPressed(0, 177) then
                stopSelecting()
            end
            if IsControlJustPressed(0, 174) then
                heading = heading + 15
                if heading > 360 then heading = 360.0 end
            end
            if IsControlJustPressed(0, 175) then
                heading = heading - 15
                if heading < 0 then heading = 0.0 end
            end
        end
    end)
end)


function placeContainer(selection, heading)
    if not currentCoords then return stopSelecting() end
    local coordinates = vector3(
        selection.x,
        selection.y,
        selection.z
    )

    local dist = #(GetEntityCoords(PlayerPedId())-coordinates)
    if dist > 50 then
        return TriggerEvent("DoLongHudText", _L("storage-too-far", "You cannot place the container this far away"), 2)
    end

    if getClosestStash(5, coordinates) ~= nil then
        return TriggerEvent("DoLongHudText", _L("storage-too-close", "You are too close to another container, give it some room"), 2)
    end

    isPlacing = true

    if dist > 3 then
        TriggerEvent("DoLongHudText", _L("storage-placing-down", "Go to the location to place it down!"))
        CreateThread(function ()
            while #(GetEntityCoords(PlayerPedId())-coordinates) > 3 do
                Wait(100)
            end
            spawn(coordinates)
        end)
        return
    end

    spawn(coordinates)
end

function spawn(coordinates)
    local location = exports["np-housing"]:getCurrentLocation()
    if location then
        local canPlace = canPlaceInHouse(location)
        if not canPlace then
            return TriggerEvent("DoLongHudText", _L("storage-cannot-place", "You cannot place the container here"), 2)
        end
        local x,y,z,w = GetEntityQuaternion(obj)
        local data = {
            model = GetHashKey(Config.crates[isSelecting].model),
            coords = json.encode({ x = coordinates.x, y = coordinates.y, z = coordinates.z }),
            quat = json.encode({ x = x, y = y, z = z, w = w }),
            realName = Config.crates[isSelecting].model
        }
        TriggerServerEvent('objects:insertObject', location, data)
    end
    loadAnimDict(Config.anims.create.dict)
    TaskPlayAnim(PlayerPedId(), Config.anims.create.dict, Config.anims.create.name, 8.0, -8.0, 1000, 51, 1.0, false, false, false)
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("np-storage:prepareStorage", isSelecting, cid, coordinates, heading)
    TriggerServerEvent('server-remove-item', cid, isSelecting, 1)
    stopSelecting()
end

function canPlaceInHouse (location)
    local data = RPC.execute("objects:getObjects", location)
    local count = 0
    local crates = {}
    for _, crate in pairs(Config.crates) do
        crates[crate.model] = true
    end
    for _, obj in pairs(data.objects) do
        if crates[obj.realName] then
            count = count + 1
        end
    end
    return count <= Config.houseLimit
end

function stopSelecting()
    if obj then
        DeleteObject(obj)
    end
    heading = 0.0
    isSelecting = nil
    currentCoords = nil
    isPlacing = false
end

function cameraToWorld (flags, ignore)
    local coord = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(0)
    local rx = math.pi / 180 * rot.x
    local rz = math.pi / 180 * rot.z
    local cosRx = math.abs(math.cos(rx))
    local direction = {
        x = -math.sin(rz) * cosRx,
        y = math.cos(rz) * cosRx,
        z = math.sin(rx)
    }
    local sphereCast = StartShapeTestSweptSphere(
        coord.x + direction.x,
        coord.y + direction.y,
        coord.z + direction.z,
        coord.x + direction.x * 200,
        coord.y + direction.y * 200,
        coord.z + direction.z * 200,
        0.2,
        flags,
        ignore,
        7
    );
    return GetShapeTestResult(sphereCast);
end

function getSelection()
    local retval, hit, endCoords, _, entityHit = cameraToWorld(1, obj)
    if hit then
        currentCoords = endCoords
    end
end

AddEventHandler("onResourceStop", function (resource)
    if resource ~= "np-storage" then return end
    if obj then
        DeleteObject(obj)
    end
end)
