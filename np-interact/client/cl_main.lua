local PeekEntries = { ['model'] = {}, ['flag'] = {}, ['entity'] = {}, ['polytarget'] = {} }

CurrentZones, CurrentTarget, CurrentTargetType, IsPeeking, IsPeakActive, NearZones = {}, nil, nil, false, false, {}

EntryCount, ListCount, UpdateRequired, RefreshingList = 0, 0, false, false

local enableWorldPrompts = true

local function convertNpcIds(npcIds)
    if npcIds == nil then return nil end
    local idHashes = {}
    for i=1, #npcIds do
        idHashes[i] = GetHashKey(npcIds[i])
    end
    return idHashes
end

local function hasNpcId(entity, npcIds)
    if npcIds == nil then return true end
    for i=1, #npcIds do
        if DecorGetInt(entity, "NPC_ID") == npcIds[i] then
            return true
        end
    end
    return false
end

function AddPeekEntry(pType, pGroup, pData, pOptions)
    local entries = PeekEntries[pType]

    if not entries then return error(pType .. ' Is not a valid Peek Type') end

    local addEntry = function(group, data, options)
        options.npcIds = convertNpcIds(options.npcIds)
        if not entries[group] then entries[group] = {} end

        local groupEntries = entries[group]

        for _, entry in ipairs(data) do
            if not entry.id then error('Missing ID in entry for '.. group) end

            EntryCount = EntryCount + 1

            entry.index = EntryCount

            groupEntries[entry.id] = { data = entry, options = options }
        end
    end

    if type(pGroup) ~= 'table' then
        addEntry(pGroup, pData, pOptions)
        return RefreshPeekList()
    end

    for _, group in ipairs(pGroup) do
        addEntry(group, pData, pOptions)
    end

    RefreshPeekList()
end

exports('AddPeekEntry', AddPeekEntry)

function AddPeekEntryByModel(pModel, pData, pOptions)
    AddPeekEntry('model', pModel, pData, pOptions)
end

exports('AddPeekEntryByModel', AddPeekEntryByModel)

function AddPeekEntryByFlag(pFlag, pData, pOptions)
    AddPeekEntry('flag', pFlag, pData, pOptions)
end

exports('AddPeekEntryByFlag', AddPeekEntryByFlag)

function AddPeekEntryByEntityType(pEntityType, pData, pOptions)
    AddPeekEntry('entity', pEntityType, pData, pOptions)
end

exports('AddPeekEntryByEntityType', AddPeekEntryByEntityType)

function AddPeekEntryByPolyTarget(pEvent, pData, pOptions)
    AddPeekEntry('polytarget', pEvent, pData, pOptions)
end

exports('AddPeekEntryByPolyTarget', AddPeekEntryByPolyTarget)

function RefreshPeekList()
    if RefreshingList then return end

    RefreshingList = true

    Citizen.SetTimeout(250, function()
        local entries = {}

        for _, groups in pairs(PeekEntries) do
            for _, group in pairs(groups) do
                for id, entry in pairs(group) do
                    entries[id] = entry.data
                end
            end
        end

        RefreshingList = false

        exports["np-ui"]:sendAppEvent('eye', {
            action = "refresh",
            payload = entries or {}
        })
    end)
end

function UpdatePeekEntryList(pEntries)
    local active = IsActive(pEntries)

    if not IsPeakActive and active then
        IsPeakActive = true
    elseif IsPeakActive and not active then
        IsPeakActive = false
    end

    exports["np-ui"]:sendAppEvent('eye', {
        action = "update",
        payload = { active = IsPeakActive, options = pEntries }
    })
end

function GetCurrentPeekEntryList()
    local entity, context = CurrentTarget, GetEntityContext(CurrentTarget)

    ListCount = ListCount + 1

    local listId, entries, tracked = ListCount, {}, {}

    local addEntry = function(pId, pEntry, pContext, pRelated)
        local data, options = pEntry.data, pEntry.options

        local metadata = (pContext.meta and pContext.meta.data) and pContext.meta.data.metadata or {}

        if options.job then
            local hasJob = false

            for _, job in ipairs(options.job) do
                if job == CurrentJob or job == myJob then
                    hasJob = true
                    break
                end
            end

            if not hasJob then return end
        end

        if options.npcIds then
            if not hasNpcId(entity, options.npcIds) then return end
        end

        if options.ns and pContext.meta and pContext.meta.ns ~= options.ns then return end

        if metadata and options.meta then
            for k,v in pairs(options.meta) do
                if metadata[k] ~= v then return end
            end
        end

        local hasChecks = options.isEnabled or options.distance

        entries[pId] = not hasChecks

        if not hasChecks then return end

        if options.distance and pContext.zones[pRelated] then
            options.distance.zone = pRelated
        end

        tracked[pId] = options
    end

    if CurrentTarget then
        if PeekEntries['model'][context.model] then
            for id, entry in pairs(PeekEntries['model'][context.model]) do
                addEntry(id, entry, context, entity)
            end
        end

        for flag, active in pairs(context.flags) do
            if active and PeekEntries['flag'][flag] then
                for id, entry in pairs(PeekEntries['flag'][flag]) do
                    addEntry(id, entry, context, entity)
                end
            end
        end

        if PeekEntries['entity'][context.type] then
            for id, entry in pairs(PeekEntries['entity'][context.type]) do
                addEntry(id, entry, context, entity)
            end
        end
    end

    for zoneName, zone in pairs(CurrentZones) do
        if zone then
            context.zones[zoneName] = zone.data

            if PeekEntries['polytarget'][zoneName] then
                for id, entry in pairs(PeekEntries['polytarget'][zoneName]) do
                    addEntry(id, entry, context, zoneName)
                end
            end
        end
    end

    StartTrackerThread(listId, entries, tracked, context)

    return entries, context
end

function StartTrackerThread(pTrackerId, pEntries, pTracked, pContext)
    local entity = CurrentTarget or 0
    local playerPed = PlayerPedId()

    local bones, normal, zones = {}, {}, {}

    local entries, updateRequired = pEntries, true

    for id, options in pairs(pTracked) do
        local distance = options.distance

        local visible, callbacks = false, normal

        if distance and distance.boneId then
            local bone = distance.boneId
            local boneIndex = type(bone) == 'string' and GetEntityBoneIndexByName(entity, bone) or GetPedBoneIndex(entity, bone)

            if not bones[boneIndex] then bones[boneIndex] = {} end

            callbacks = bones[boneIndex]
        elseif distance and distance.zone then
            if not zones[distance.zone] then zones[distance.zone] = {} end

            callbacks = zones[distance.zone]
        end

        callbacks[#callbacks + 1] = function(pDistance)
            local inRange = not distance or pDistance <= distance.radius
            local isEnabled = inRange and (not options.isEnabled or options.isEnabled(entity, pContext))

            if inRange and isEnabled and not visible then
                visible = true
                updateRequired = true
                entries[id] = true
            elseif not inRange or not isEnabled and visible then
                visible = false
                updateRequired = true
                entries[id] = false
            end
        end
    end

    Citizen.CreateThread(function()
        while IsPeeking and ListCount == pTrackerId do
            local playerCoords = GetEntityCoords(playerPed)

            if entity then
                for boneIndex, callbacks in pairs(bones) do
                    local targetCoords = GetWorldPositionOfEntityBone(entity, boneIndex)
                    local targetDistance = #(playerCoords - targetCoords)

                    for _, callback in ipairs(callbacks) do
                        callback(targetDistance)
                    end
                end

                if #normal > 0 then
                    local targetCoords = GetEntityCoords(entity)
                    local targetDistance = #(playerCoords - targetCoords)

                    for _, callback in ipairs(normal) do
                        callback(targetDistance)
                    end
                end
            end

            for zoneId, callbacks in pairs(zones) do
                local zone = CurrentZones[zoneId]
                local targetDistance = not zone and 9999.9 or #(playerCoords - zone.vectors)

                for _, callback in ipairs(callbacks) do
                    callback(targetDistance)
                end
            end

            if updateRequired then
                updateRequired = false
                UpdatePeekEntryList(entries)
            end

            if enableWorldPrompts then
                FindNearestZones(playerCoords, 3, entity, pContext)
            end
            Citizen.Wait(150)
        end
    end)
end

function FindNearestZones(playerCoords, count, entity, context)
    NearZones = {}

    local function checkIsEnabled(zone)
        local peekEntries = PeekEntries['polytarget'][zone.name]
        local isEnabled = not peekEntries
        if peekEntries then
            for id,entry in pairs(peekEntries) do
                isEnabled = isEnabled or (not entry.options.isEnabled or entry.options.isEnabled(entity, context))
            end
        end
        return isEnabled
    end

    -- Add `CurrentZones` to `NearZones` first
    for _, zone in ipairs(nearbyZones) do
        local currentZone = CurrentZones[zone.name]
        if currentZone and currentZone.vectors == zone.center and checkIsEnabled(zone) then
            NearZones[#NearZones+1] = {
                id = zone.id,
                center = zone.center,
                active = true,
                dist = #(playerCoords - zone.center),
                opacity = 255
            }
        end
    end

    -- Filter `nearbyZones` to all zones that are not in `CurrentZones` and are closer than 5.0 units from the player
    -- and sort them by their distance to the player
    local sortedNearbyZones = Array(nearbyZones)
        :Filter(function (zone)
            local currentZone = CurrentZones[zone.name]
            zone.distanceToPlayer = #(playerCoords - zone.center)
            return (currentZone == nil or currentZone.vectors ~= zone.center) and zone.distanceToPlayer < 5.0 and checkIsEnabled(zone)
        end)
        :Sort(-1, function (a, b) return (a.distanceToPlayer - b.distanceToPlayer) > 0 end)

    -- Until `NearZones` has `count` number of zones, keep popping zones off the end of `sortedNearbyZones`
    while #NearZones < count and not sortedNearbyZones:isEmpty() do
        local zone = sortedNearbyZones:Pop()
        NearZones[#NearZones+1] = {
            id = zone.id,
            center = zone.center,
            active = false,
            dist = zone.distanceToPlayer,
            opacity = 200
        }
    end
end

function IsActive(pEntries)
    if not pEntries then return end

    for _, active in pairs(pEntries) do
        if active then return true end
    end

    return false
end

local blockInteractHint = {}
function StartPeekin()
    if IsPeeking then return end
    if IsPedArmed(PlayerPedId(), 6) then return end

    local entries, context

    IsPeeking = true
    UpdateRequired = true

    NearZones = {}
    nearbyZones = exports["np-polytarget"]:GetZones(GetEntityCoords(PlayerPedId())) or {}
    for _, zone in pairs(nearbyZones) do
        if zone.data and zone.data.blockInteractHint then
            blockInteractHint[zone.id] = true
        end
    end
    -- print(nearbyZones, json.encode(nearbyZones, { indent = true }))

    Citizen.CreateThread(function()
        local rgbGreen, rgbWhite = {0, 248, 185}, {255, 255, 255}
        local previousZones = {}
        local drawingZones = {}
        local lastUpdate = GetGameTimer()

        RequestStreamedTextureDict("shared")
        while IsPeeking do
            DisablePlayerFiring(PlayerPedId(), true)

            if UpdateRequired then
                UpdateRequired = false
                entries, context = GetCurrentPeekEntryList()
            end

            if IsPeakActive and (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                SetCursorLocation(0.5, 0.5)

                exports["np-ui"]:openApplication("eye", {
                    action = "interact",
                    payload = { active = true, display = true, context = context, entity = CurrentTarget }
                })
            end

            if enableWorldPrompts then
                local activeZones, nearZoneLookup = {}, {}

                -- Insert all `NearZones` that aren't already being drawn into `drawingZones`
                for _, zone in ipairs(NearZones) do
                    nearZoneLookup[zone.id] = true
                    if zone.active then activeZones[zone.id] = true end
                    if not drawingZones[zone.id] then
                        drawingZones[zone.id] = { zone = zone, type = "in", fade = 0 }
                    end
                end

                -- Insert all `previousZones` that aren't in `NearZones` and aren't already being drawn (or whose fade type == 'in') into `drawingZones`
                for _, zone in ipairs(previousZones) do
                    local inNear = nearZoneLookup[zone.id]
                    if not inNear and (not drawingZones[zone.id] or drawingZones[zone.id].type == "in") then
                        drawingZones[zone.id] = { zone = zone, type = "out", fade = 100 }
                    end
                end

                -- Draw prompts for all zones in `drawingZones`
                local currentTime = GetGameTimer()
                for id, fz in pairs(drawingZones) do
                    if not blockInteractHint[fz.zone.id] then
                        local isActive = activeZones[fz.zone.id] ~= nil
                        local opacity = map_range(fz.fade, 0, 100, 0, isActive and 255 or 200)
                        if fz.type == "in" then
                            fz.fade = math.min(fz.fade + 0.15 * (currentTime - lastUpdate), 100)
                        elseif fz.type == "out" then
                            fz.fade = math.max(fz.fade - 0.15 * (currentTime - lastUpdate), 0)
                            if fz.fade == 0 then drawingZones[id] = nil end
                        end

                        SetDrawOrigin(fz.zone.center, 0)
                        local rgb = isActive and rgbGreen or rgbWhite
                        DrawSprite("shared", "emptydot_32", 0, 0, 0.02, 0.035, 0, rgb[1], rgb[2], rgb[3], math.floor(opacity + 0.5))
                        ClearDrawOrigin()
                    end
                end

                lastUpdate = currentTime
                previousZones = {table.unpack(NearZones)}
            end

            Citizen.Wait(0)
        end
    end)

    exports["np-ui"]:sendAppEvent('eye', { action = "peek", payload = { display = true, active = false } })
end

function StopPeekin()
    if not IsPeeking then return end

    IsPeeking = false

    exports["np-ui"]:sendAppEvent('eye', {
        action = "peek",
        payload = { display = false, active = false }
    })
end

function CanSellOrBuyCar(pEntity, pSell)
  local vehicleOwner = getVehicleOwner(pEntity)

  if pSell and vehicleOwner == 2 then return true end
  if not pSell and vehicleOwner ~= 2 and vehicleOwner ~= -1 then return true end

  return false
end


AddEventHandler("np:target:changed", function(pTarget, pEntityType, pEntityOffset)
    CurrentTarget = pTarget
    CurrentTargetType = pEntityType
    CurrentTargetOffset = pEntityOffset

    UpdateRequired = true
end)

AddEventHandler('np-polyzone:enter', function(zoneName, zoneData, zoneCenter)
    if not PeekEntries['polytarget'][zoneName] then return end

    CurrentZones[zoneName] = { data = zoneData, vectors = zoneCenter }

    if not IsPeeking then return end

    UpdateRequired = true
end)

AddEventHandler('np-polyzone:exit', function(zoneName)
    if not PeekEntries['polytarget'][zoneName] then return end

    CurrentZones[zoneName] = nil

    UpdateRequired = true
end)

RegisterUICallback("np-ui:targetSelectOption", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = 'done' } })

    IsPeeking = false

    exports["np-ui"]:closeApplication("eye")

    Wait(100)

    local option = data.option
    local context = data.context or {}

    local event = option.event
    local NPXEvent = option.NPXEvent
    local target = data.entity or 0
    local parameters = option.parameters or {}
    
    if event == nil and NPXEvent ~= nil then
        return NPX.Events.emit(NPXEvent, parameters, target, context)
    end

    TriggerEvent(event, parameters, target, context)
end)

AddEventHandler('np-ui:phoneReady', function()
    RefreshPeekList()
end)

RegisterCommand('+targetInteract', StartPeekin, false)

RegisterCommand('-targetInteract', StopPeekin, false)

Citizen.CreateThread(function()
    exports["np-keybinds"]:registerKeyMapping("", "Player", "Peek at Target", "+targetInteract", "-targetInteract", "LMENU")
end)

function map_range(s, a1, a2, b1, b2)
    return b1 + (s - a1) * (b2 - b1) / (a2 - a1)
end

AddEventHandler("np-preferences:setPreferences", function(data)
    enableWorldPrompts = not data["interact.disablePrompts"]
end)

exports('IsPeeking', function() return IsPeeking end)
