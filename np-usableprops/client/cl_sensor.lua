local ActiveSensors = {}
local polyzoneCreated = {}

local lastTrigger = 0

function SensorCreated(pObject, pEntity)
    if ActiveSensors[pObject.id] then
        return
    end

    if not polyzoneCreated[pObject.id] then
        local length = pObject.data.metadata.length or 3.5
        local offset = GetOffsetFromEntityInWorldCoords(pEntity, 0.0, -(length / 2), 0)
        exports['np-polyzone']:AddBoxZone('movement_sensor', offset, pObject.data.metadata.length, 1.0, {
            data = { id = pObject.id },
            heading = pObject.data.rotation.z,
            minZ = pObject.z - 0.5,
            maxZ = pObject.z + 1.25,
        })
        polyzoneCreated[pObject.id] = true
    end

    ActiveSensors[pObject.id] = true
end

function SensorRemoved(pObject, pEntity)
    ActiveSensors[pObject.id] = nil
end

RegisterNetEvent('np-usableprops:toggleSensor', function(pId, pToggle)
    if ActiveSensors[pId] == nil then return end
    ActiveSensors[pId] = pToggle
end)

AddEventHandler('np-polyzone:enter', function(pZone, pData)
    if pZone ~= 'movement_sensor' then return end

    local sensorId = pData.id
    if not sensorId then return end

    if ActiveSensors[sensorId] and lastTrigger + 10000 < GetGameTimer() then
        lastTrigger = GetGameTimer()
        RPC.execute('np-usableprops:sensorTriggered', sensorId)
    end
end)

local lastHackAttempt = 0
AddEventHandler('np-usableprops:hackSensor', function(pParameters, pEntity, pContext)
    local id = pContext.meta and pContext.meta.id
    if not id then return end

    if lastHackAttempt + 60000 > GetGameTimer() then
        return
    end

    local difficulty = math.random(1000,2000)

    local failed = false
    exports['np-ui']:clearSkillCheck()
    for i=1,10 do
        local skillGap = math.random(5, 15)
        exports['np-ui']:taskBarSkill(difficulty, skillGap, function(result)
            if result ~= 100 then
                TriggerEvent('DoLongHudText', 'Failed', 2)
                failed = true
                lastHackAttempt = GetGameTimer()
            
                if ActiveSensors[id] then
                    RPC.execute('np-usableprops:sensorTriggered', id)
                end
                return
            end
        end, i % 2 == 0, true)
        if failed then
            return
        end
    end
    TriggerEvent('np-usableprops:disableSensor', id, 180000)
    TriggerEvent('DoLongHudText', 'Sensor disabled for a short time')
end)
