local manager = nil
local managerCoords = nil
local managerNetId = nil
local safeHashes = {
    -170500011,
    1785922871,
}
local scenarioStarted = false
local scenarioOwner = false

function StoreIsManager(m)
    return m == manager
end

function startScenario()
    NetworkRequestControlOfEntity(manager)
    while not NetworkHasControlOfEntity(manager) do
        Wait(0)
    end

    TriggerEvent("civilian:alertPolice", 8.0, "robberyhouseMansion", 0)
    -- TriggerServerEvent("police:camrobbery", storeid)
    TriggerEvent("client:newStress", true, 200)

    Citizen.CreateThread(function()
        while scenarioStarted do
            if IsEntityDead(manager) or IsPedDeadOrDying(manager) then
                RPC.execute("heists:endManagerScenario", false)
                scenarioStarted = false
            end
            Citizen.Wait(500)
        end
    end)

    Citizen.CreateThread(function()
        if #(GetEntityCoords(manager) - vector3(managerCoords.spawn.x, managerCoords.spawn.y, managerCoords.spawn.z)) > 0.1 then
            SetEntityCoords(manager, managerCoords.spawn.x, managerCoords.spawn.y, managerCoords.spawn.z, 0, 0, 0, 0)
        end
        SetBlockingOfNonTemporaryEvents(manager, true)
        SetPedFleeAttributes(manager, 0, 0)
        RequestAnimDict("missfbi5ig_22")
        while not HasAnimDictLoaded("missfbi5ig_22") do
            Citizen.Wait(0)
        end
        ClearPedTasksImmediately(manager)
        TaskPlayAnim(manager, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, 1.0, -1, 1, -1, false, false, false)
        Citizen.Wait(5000)
        ClearPedTasksImmediately(manager)
        Citizen.Wait(0)
        TaskGoStraightToCoord(manager, managerCoords.safe, 1.0, -1, 0.0, 0.0)
        Citizen.Wait(0)
        FreezeEntityPosition(manager, false)
        local obj = nil
        for _, hash in pairs(safeHashes) do
            if obj == nil then
                obj = GetClosestObjectOfType(GetEntityCoords(manager), 20.0, hash, false, false, false)
            end
        end
        if obj == nil then
            RPC.execute("heists:endManagerScenario", false)
            return
        end
        Citizen.Wait(0)
        while GetIsTaskActive(manager, 35) do
            Citizen.Wait(500)
        end
        if #(GetEntityCoords(manager) - managerCoords.safe) > 0.1 then
            SetEntityCoords(manager, managerCoords.safe, 0, 0, 0, 0)
        end
        ClearPedTasksImmediately(manager)
        Citizen.Wait(0)
        TaskTurnPedToFaceEntity(manager, obj, 1000)
        Citizen.Wait(2500)
        FreezeEntityPosition(manager, true)
        RequestAnimDict("mini@safe_cracking")
        while not HasAnimDictLoaded("mini@safe_cracking") do
            Citizen.Wait(0)
        end
        TaskPlayAnim(manager, "mini@safe_cracking", "dial_turn_clock_slow", 8.0, 1.0, -1, 1, -1, false, false, false)
        local attempts = 0
        while scenarioStarted do
            attempts = attempts + 1
            Citizen.Wait(15000)
            local ply = PlayerId()
            local ent = nil
            local aiming, ent = GetEntityPlayerIsFreeAimingAt(ply)
            local freeAiming = IsPlayerFreeAiming(ply)
            if freeAiming and ent == manager then
                if math.random() < 0.25 then
                    RPC.execute("heists:endManagerScenario", true)
                    scenarioStarted = false
                end
            elseif attempts == 10 or math.random() < 0.25 then
                RPC.execute("heists:endManagerScenario", false)
                scenarioStarted = false
            end
        end
    end)
end

local waitingForFreeAim = false
function waitForFreeAim()
    if waitingForFreeAim then return end
    waitingForFreeAim = true
    Citizen.CreateThread(function()
        while not scenarioStarted and manager ~= nil do
            local ply = PlayerId()
            local ent = nil
            local aiming, ent = GetEntityPlayerIsFreeAimingAt(ply)
            local freeAiming = IsPlayerFreeAiming(ply)
            if freeAiming and ent == manager then
                scenarioStarted = true
                RPC.execute("heists:startManagerScenario")
            else
                Citizen.Wait(500)
            end
        end
        waitingForFreeAim = false
    end)
end

function idleManager()
    Citizen.CreateThread(function()
        while not scenarioStarted and managerNetId ~= nil do
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - vector3(managerCoords.spawn.x, managerCoords.spawn.y, managerCoords.spawn.z)) < 60 then
                netId = NetToPed(managerNetId)
                if netId ~= 0 then
                    manager = netId
                    if not IsPedActiveInScenario(manager) and NetworkHasControlOfEntity(manager) then
                        ClearPedTasksImmediately(manager)
                        Citizen.Wait(0)
                        TaskStartScenarioInPlace(manager, "WORLD_HUMAN_CLIPBOARD", -1, true)
                    end
                    waitForFreeAim()
                else
                    manager = nil
                end
            end
            Citizen.Wait(2500)
        end
    end)
end

RegisterNetEvent("heists:storeManagerDespawned")
AddEventHandler("heists:storeManagerDespawned", function()
    if scenarioOwner then
        SetBlockingOfNonTemporaryEvents(manager, false)
        SetPedFleeAttributes(manager, 1, 0)
        FreezeEntityPosition(manager, false)
        ClearPedTasksImmediately(manager)
        Wait(0)
        TaskSmartFleePed(manager, PlayerPedId(), -1, -1, 0, 0)
    end
    manager = nil
    managerNetId = nil
    scenarioStarted = false
    scenarioOwner = false
end)

RegisterNetEvent("heists:storeManagerScenarioStart")
AddEventHandler("heists:storeManagerScenarioStart", function(ownerId)
    scenarioStarted = true
    scenarioOwner = ownerId == GetPlayerServerId(PlayerId())
    if scenarioOwner then
        startScenario()
    end
end)

RegisterNetEvent("heists:storeManagerSpawned")
AddEventHandler("heists:storeManagerSpawned", function(netId, coords)
    manager = NetToPed(netId)
    managerNetId = netId
    managerCoords = coords
    idleManager()
end)

Citizen.CreateThread(function()
    managerNetId, managerCoords = RPC.execute("np-heists:getManagerPosition")
    if managerNetId == nil then return end
    manager = NetToPed(managerNetId)
    if manager ~= nil and manager ~= 0 then
        idleManager()
    end
end)
