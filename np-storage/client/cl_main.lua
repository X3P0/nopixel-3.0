Storages = {}
activeZones = {}

local thermiteMinigameResult = {}

CreateThread(function ()
    for crate, data in pairs(Config.crates) do
        exports["np-interact"]:AddPeekEntryByModel({ GetHashKey(data.model) }, {{
            id = "storage_lifetime",
            event = "np-storage:checkLifetime",
            icon = "heart",
            label = _L("storage-check-wear", "Check wear")
        }}, {
            distance = { radius = data.distance },
            isEnabled = function(entity, context)
                local stash, dist = getClosestStash(data.distance)
                return stash ~= nil
            end
        })
        exports["np-interact"]:AddPeekEntryByModel({ GetHashKey(data.model) }, {{
            id = "storage_repair",
            event = "np-storage:repairStorage",
            icon = "screwdriver",
            label = _L("storage-repair", "Repair")
        }}, {
            distance = { radius = data.distance },
            isEnabled = function(entity, context)
                local stash, dist = getClosestStash(data.distance)
                return stash ~= nil and exports["np-inventory"]:hasEnoughOfItem('craterepairkit', 1, false, true)
            end
        })
        exports["np-interact"]:AddPeekEntryByModel({ GetHashKey(data.model) }, {{
            id = "storage_destroy",
            event = "np-storage:destroyStash",
            icon = "trash-alt",
            label = _L("storage-destroy", "Destroy container"),
        }}, {
            distance = { radius = data.distance },
            isEnabled = function(entity, context)
                local stash, dist = getClosestStash(data.distance)
                return stash ~= nil and (exports["isPed"]:isPed("myjob") == "police" or Storages[stash].placed_by == exports["isPed"]:isPed("cid"))
            end
        })
        if not data.vendor then
            exports["np-interact"]:AddPeekEntryByModel({ GetHashKey(data.model) }, {{
                id = "storage_open",
                event = "np-storage:openStash",
                icon = "box-open",
                label = _L("storage-open", "Open stash"),
            }}, {
                distance = { radius = data.distance },
                isEnabled = function(entity, context)
                    local stash, dist = getClosestStash(data.distance)
                    return stash ~= nil
                end
            })
            exports["np-interact"]:AddPeekEntryByModel({ GetHashKey(data.model) }, {{
                id = "storage_breakin",
                event = "np-storage:breakinStash",
                icon = "exclamation-triangle",
                label = _L("storage-breakin", "Break in container"),
            }}, {
                distance = { radius = data.distance },
                isEnabled = function(entity, context)
                    local stash, dist = getClosestStash(data.distance)
                    if not stash or not Storages[stash].is_locked then return end
                    local hasDetCord = exports["np-inventory"]:hasEnoughOfItem("detcord", 1, false, true)
                    local hasThermite = exports["np-inventory"]:hasEnoughOfItem("thermitecharge", 1, false, true)
                    local hasHacking = exports["np-inventory"]:hasEnoughOfItem("hackingdevice", 1, false, true)
                    local hasPdHacking = exports["np-inventory"]:hasEnoughOfItem("elevatorhackingdevice", 1, false, true)
                    local canUnlockKeyCode = (hasHacking or hasPdHacking) and Storages[stash].key_code
                    local canUnlockLock = (hasDetCord or hasThermite) and not Storages[stash].key_code
                    return (canUnlockKeyCode or canUnlockLock)
                end
            })
        end
    end
    Wait(5000)
    if #Storages == 0 then
        TriggerServerEvent("np-storage:requestStorages")
    end
end)

RegisterNetEvent("np-storage:loadStorages")
AddEventHandler("np-storage:loadStorages", function (_storages)
    for id, storage in pairs(_storages) do
        addStorage(storage)
    end
end)

RegisterNetEvent("np:storage:prepareNewStorage")
AddEventHandler("np:storage:prepareNewStorage", function (storage)
    addStorage(storage)
end)

AddEventHandler("np-polyzone:enter", function (name, data)
    if name ~= "mobile_stash" then return end
    if not Storages[data.id] then return end
    if Storages[data.id].object then return end

    local coords = Storages[data.id].coordinates
    Storages[data.id].object = createStash(Storages[data.id].size, coords.x, coords.y, coords.z, coords.h)
    activeZones[data.id] = vector3(coords.x, coords.y, coords.z)
end)

AddEventHandler("np-polyzone:exit", function (name, data)
    if name ~= "mobile_stash" then return end
    if not Storages[data.id] then return end
    if not Storages[data.id].object then return end

    DeleteObject(Storages[data.id].object)
    Storages[data.id].object = nil
    activeZones[data.id] = nil
end)

AddEventHandler("np-storage:openStash", function ()
    local closestStash, closestStashDist = getClosestStash(10)
    if closestStash == nil then return end
    local stash = Storages[closestStash]
    if closestStashDist > Config.crates[stash.size].distance then return end
    if Config.crates[stash.size].trap then
        return explodeCrate(stash)
    end
    if stash.is_locked then
        if stash.key_code then
            return openKeyPad(stash)
        end
        local hasKey = #exports["np-inventory"]:getItemsOfType("mobilecratekey", 1, true, {
            crateId = stash.id
        }) > 0
        if not hasKey then return TriggerEvent("DoLongHudText", _L("storage-no-key", "This crate seems to be locked")) end
    end
    TriggerEvent("server-inventory-open", "1", string.format("mobile-stash-%s_%s", Config.crates[stash.size].invPrefix, closestStash))
end)

function openKeyPad (stash)
    exports['np-ui']:openApplication('textbox', {
        callbackUrl = 'np-storage:enterKeyPad',
        key = { crateId = stash.id, item = name },
        items = {
            {
                type = "password",
                icon = "circle",
                label = _L("storage-key-code", "Key Code"),
                name = "keycode",
            }
        },
        show = true,
    })
end

RegisterUICallback("np-storage:enterKeyPad", function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['np-ui']:closeApplication('textbox')

    local stash = Storages[data.key.crateId]
    if not stash then return end
    if stash.key_code ~= data.values.keycode then
        return TriggerEvent("DoLongHudText", _L("storage-wrong-key", "Wrong key code"))
    end
    TriggerEvent("server-inventory-open", "1", string.format("mobile-stash-%s_%s", Config.crates[stash.size].invPrefix, data.key.crateId))
end)

AddEventHandler("np-storage:breakinStash", function ()
    local closestStash, closestStashDist = getClosestStash(10)
    if closestStash == nil then return end
    local stash = Storages[closestStash]
    if closestStashDist > Config.crates[stash.size].distance then return end
    if not stash.is_locked then
        return TriggerEvent("DoLongHudText", _L("storage-not-locked", "This crate is not locked"))
    end

    local itemUsed = nil
    local gameSettings = {
        gameFinishedEndpoint = "np-storage:crackStorage",
        gameTimeoutDuration = 14000,
        coloredSquares = 21,
        gridSize = 8
    }

    if stash.key_code then
        if not itemUsed and exports["np-inventory"]:hasEnoughOfItem("hackingdevice", 1, false, true) then
            itemUsed = "hackingdevice"
        end
        if not itemUsed and exports["np-inventory"]:hasEnoughOfItem("elevatorhackingdevice", 1, false, true) then
            itemUsed = "elevatorhackingdevice"
        end
        if not itemUsed or (itemUsed ~= "hackingdevice" and itemUsed ~= "elevatorhackingdevice") then
            return TriggerEvent("DoLongHudText", _L("storage-cant-be-broken-open", "You can not break into this lock for some reason"))
        end

        gameSettings.coloredSquares = 23
        gameSettings.gridSize = 10
        gameSettings.gameTimeoutDuration = 17000
    else
        if exports["np-inventory"]:hasEnoughOfItem("detcord", 1, false, true) then
            itemUsed = "detcord"
        end
        if not itemUsed and exports["np-inventory"]:hasEnoughOfItem("thermitecharge", 1, false, true) then
            itemUsed = "thermitecharge"
        end
    end

    if not itemUsed then
        return TriggerEvent("DoLongHudText", _L("storage-cant-be-broken-open", "You can not break into this lock for some reason"))
    end

    if itemUsed ~= "hackingdevice" then
        TriggerEvent("inventory:removeItem", itemUsed, 1)
    else
        TriggerEvent("inventory:DegenItemType", 20, itemUsed)
    end
    local success = Citizen.Await(ThermiteCharge(gameSettings))

    if not success then
        return TriggerServerEvent("np-storage:breakInStorageFailed", closestStash, itemUsed)
    end

    loadAnimDict(Config.anims.unlock.dict)
    TaskPlayAnim(PlayerPedId(), Config.anims.unlock.dict, Config.anims.unlock.name, 8.0, -8.0, -1, 1, 1.0, false, false, false)

    local progress = exports["np-taskbar"]:taskBar(Config.crates[stash.size].openLength, _L("storage-breaking-open", "Breaking open..."))
    ClearPedTasks(PlayerPedId())
    if progress ~= 100 then return end

    TriggerServerEvent("np-storage:breakInStorage", closestStash, itemUsed)
    TriggerEvent("DoLongHudText", _L("storage-broken-open", "You have opened the container"))
end)

RegisterNetEvent("np-storage:clearStorages")
AddEventHandler("np-storage:clearStorages", function (deletedStorages)
    for _, id in pairs(deletedStorages) do
        if activeZones[id] then
            activeZones[id] = nil
        end
        if Storages[id] then
            if Storages[id].object then
                DeleteObject(Storages[id].object)
            end
            Storages[id] = nil
        end
    end
end)

AddEventHandler("np-storage:destroyStash", function ()
    local closestStash, closestStashDist = getClosestStash(10)
    if closestStash == nil then return end
    local stash = Storages[closestStash]
    if closestStashDist > Config.crates[stash.size].distance then return end

    local employmentState = exports["np-business"]:IsEmployedAt("statecontracting")

    if Config.crates[stash.size].vendor and not employmentState then
        return TriggerEvent("DoLHudText", 2, "storage-cannot-destroy", "You cannot destroy this.")
    end

    local isPD = exports["isPed"]:isPed("myjob") == "police"
    local isOwner = stash.placed_by == exports["isPed"]:isPed("cid")
    if not isPD and not isOwner then
        return TriggerEvent("DoLHudText", 2, "storage-cannot-destroy", "You cannot destroy this.")
    end

    loadAnimDict(Config.anims.destroy.dict)
    TaskPlayAnim(PlayerPedId(), Config.anims.destroy.dict, Config.anims.destroy.name, 8.0, -8.0, -1, 1, 1.0, false, false, false)

    local finished = exports["np-taskbar"]:taskBar(Config.crates[stash.size].destroyLength, _L("storage-destroying", "Destroying..."))

    ClearPedTasksImmediately(PlayerPedId())

    if finished == 100 then
        TriggerServerEvent("np-storage:destroyStash", closestStash)
        if not Config.crates[stash.size].vendor then return end
        local isCrateYoung = RPC.execute("np-storage:canBeDeplaced", stash.id)
        if isCrateYoung and employmentState then
            TriggerEvent("player:receiveItem", stash.size, 1)
        end
    end
end)

AddEventHandler("np-storage:checkLifetime", function ()
    local closestStash, closestStashDist = getClosestStash(10)
    if closestStash == nil then return end
    local stash = Storages[closestStash]
    if closestStashDist > Config.crates[stash.size].distance then return end

    TriggerServerEvent("np-storage:getRemainingLife", closestStash)
end)

AddEventHandler("np-storage:repairStorage", function ()
    local closestStash, closestStashDist = getClosestStash(10)
    if closestStash == nil then return end
    local stash = Storages[closestStash]
    local definition = Config.crates[stash.size]
    if not definition then return end
    if closestStashDist > definition.distance then return end

    if not definition.repairCharges then
        return TriggerEvent("DoLongHudText", _L("storage-cannot-repair", "This container cannot be repaired"))
    end

    local hasRepairKit = exports["np-inventory"]:hasEnoughOfItem("craterepairkit", 1, false, true)
    if not hasRepairKit then
        return TriggerEvent("DoLongHudText", _L("storage-repairing-no-kit", "You do not have a repair kit"))
    end

    local info = exports["np-inventory"]:GetInfoForFirstItemOfName("craterepairkit")
    local chargesLeft = json.decode(info.information).charges
    if definition.repairCharges > chargesLeft then
        return TriggerEvent("DoLongHudText", _L("storage-repairing-kit-breaking", "This repair kit would break during repairing."))
    end

    loadAnimDict(Config.anims.repair.dict)
    TaskPlayAnim(PlayerPedId(), Config.anims.repair.dict, Config.anims.repair.name, 8.0, -8.0, -1, 1, 1.0, false, false, false)

    local finished = exports["np-taskbar"]:taskBar(definition.repairLength, _L("storage-repairing", "Repairing..."))

    ClearPedTasksImmediately(PlayerPedId())

    if finished ~= 100 then return end

    TriggerServerEvent("np-storage:repairStorage", closestStash, chargesLeft, info.slot)
end)

AddEventHandler("np-inventory:itemUsed", function (name, info)
    if name ~= "mobilecratelock" and name ~= "mobilecratekeylock" then return end

    local closestStash, closestStashDist = getClosestStash(10)
    if closestStash == nil then return end
    local stash = Storages[closestStash]
    if closestStashDist > Config.crates[stash.size].distance then return end

    if stash.is_locked then
        return TriggerEvent("DoLongHudText", _L("storage-already-locked", "This container is already locked"))
    end

    if not Config.crates[stash.size].lockLength then
        return TriggerEvent("DoLongHudText", _L("storage-no-lock-length", "This container can not be locked"))
    end

    loadAnimDict(Config.anims.lock.dict)
    TaskPlayAnim(PlayerPedId(), Config.anims.lock.dict, Config.anims.lock.name, 8.0, -8.0, -1, 1, 1.0, false, false, false)

    local progress = exports["np-taskbar"]:taskBar(Config.crates[stash.size].lockLength, _L("storage-locking", "Locking..."))
    ClearPedTasks(PlayerPedId())
    if progress ~= 100 then return end

    local element = {
        icon = "circle",
        label = _L("storage-key-name", "Key Name"),
        name = "name",
    }
    if name == "mobilecratekeylock" then
        element = {
            type = "password",
            icon = "circle",
            label = _L("storage-key-code", "Key Code"),
            name = "keycode",
        }
    end

    exports['np-ui']:openApplication('textbox', {
        callbackUrl = 'np-storage:lockStorage',
        key = { crateId = stash.id, item = name },
        items = {element},
        show = true,
    })
end)

RegisterUICallback("np-storage:lockStorage", function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['np-ui']:closeApplication('textbox')

    if data.key.item == "mobilecratekeylock" then
        if #data.values.keycode > 4 then
            return TriggerEvent("DoLongHudText", _L("storage-key-code-too-long", "The key code must be 4 characters or less"))
        end
        if tonumber(data.values.keycode) == nil then
            return TriggerEvent("DoLongHudText", _L("storage-key-code-not-number", "The key code must be a number"))
        end
        return TriggerServerEvent("np-storage:lockStorage", data.values.keycode, data.key.crateId, true)
    end
    TriggerServerEvent("np-storage:lockStorage", data.values.name, data.key.crateId)
end)

RegisterNetEvent("np-storage:updateLockState")
AddEventHandler("np-storage:updateLockState", function (id, state, keyCode)
    if not Storages[id] then return end

    Storages[id].is_locked = state
    Storages[id].key_code = keyCode
end)

function addStorage(storage)
    if not Config.crates[storage.size] then return end

    local vector = vector3(storage.coordinates.x, storage.coordinates.y, storage.coordinates.z)
    exports["np-polyzone"]:AddCircleZone(
        "mobile_stash",
        vector,
        math.max(75, Config.crates[storage.size].distance * 20),
        { data = { id = storage.id } }
    )

    local object = nil
    if #(GetEntityCoords(PlayerPedId()) - vector) < 25 then
        local heading = storage.coordinates.h
        if heading == nil then heading = 0 end
        object = createStash(storage.size, vector.x, vector.y, vector.z, heading)
        activeZones[storage.id] = vector
    end

    Storages[storage.id] = {
        id = storage.id,
        size = storage.size,
        coordinates = storage.coordinates,
        placed_by = storage.placed_by,
        placed_at = storage.placed_at,
        despawn_at = storage.despawn_at,
        is_locked = storage.is_locked,
        key_code = storage.key_code,
        object = object
    }
end

function explodeCrate(stash)
    AddExplosion(
        stash.coordinates.x,
        stash.coordinates.y,
        stash.coordinates.z,
        2,
        5.0,
        true,
        false,
        1
    )
    TriggerServerEvent("np-storage:destroyStash", stash.id)
end

function getClosestStash(range, coords)
    local closestStash, closestStashDist = nil, 9999
    if coords == nil then
        coords = GetEntityCoords(PlayerPedId())
    end
    for id, crateCoords in pairs(activeZones) do
        local dist = #(coords-crateCoords)
        if dist < closestStashDist then
            closestStashDist = dist
            closestStash = id
        end
    end
    if closestStashDist > range then
        return nil
    end
    return closestStash, closestStashDist
end

function createStash(size, x,y,z, heading)
    local obj = CreateObject(Config.crates[size].model, x, y, z, 0, 0, 0)
    if not heading then heading = 0 end
    SetEntityHeading(obj, heading + 0.0)
    FreezeEntityPosition(obj, true)
    return obj
end

AddEventHandler("onResourceStop", function (resource)
    if resource ~= "np-storage" then return end
    for id, storage in pairs(Storages) do
        if storage.object then
            DeleteObject(storage.object)
        end
    end
end)

function ThermiteCharge(gameSettings)
    local p = promise:new()
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        Citizen.Wait(100)

        local index = #thermiteMinigameResult + 1
        thermiteMinigameResult[index] = nil
        gameSettings.parameters = {
            ["id"] = index,
        }
    
        exports["np-ui"]:openApplication("memorygame", gameSettings)
    
        while thermiteMinigameResult[index] == nil do
            Citizen.Wait(1000)
        end
        p:resolve(thermiteMinigameResult[index])
        Wait(500)
        exports["np-ui"]:closeApplication("memorygame")
    end)
    return p
end

RegisterUICallback("np-storage:crackStorage", function(data, cb)
    thermiteMinigameResult[data.parameters.id] = data.success
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)