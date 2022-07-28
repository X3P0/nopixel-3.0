local inBinder = false
local inPackOpening = false

RegisterNetEvent("np-tcg:client:show-trading-card")
AddEventHandler("np-tcg:client:show-trading-card", function(pSource, pInventoryData)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local isInCar = veh ~= 0 and veh ~= nil
    local isDead = exports["isPed"]:isPed("dead")
    local isInTrunk = exports["isPed"]:isPed("intrunk")
    if isInCar or isDead or isInTrunk then return end
    if GetPlayerServerId(PlayerId()) == pSource and not inBinder and not inPackOpening then
        TriggerEvent("attachItem", "tcg_card")

        LoadAnimationDic("paper_1_rcm_alt1-9")
        TaskPlayAnim(PlayerPedId(), "paper_1_rcm_alt1-9", "player_one_dual-9", 3.0, 3.0, -1, 49, 0, 0, 0, 0)

        Citizen.Wait(3250)
        StopAnimTask(PlayerPedId(), "paper_1_rcm_alt1-9", "player_one_dual-9", 1.0)

        TriggerEvent("destroyProp")
    end
end)

RegisterNetEvent("np-tcg:client:burn-trading-card")
AddEventHandler("np-tcg:client:burn-trading-card", function(pSource, pInventoryData)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local isInCar = veh ~= 0 and veh ~= nil
    local isDead = exports["isPed"]:isPed("dead")
    local isInTrunk = exports["isPed"]:isPed("intrunk")
    if isInCar or isDead or isInTrunk then return end
    if GetPlayerServerId(PlayerId()) == pSource and not inBinder and not inPackOpening then
        TriggerEvent("attachItem", "tcg_card_inspect")

        LoadAnimationDic("amb@world_human_tourist_map@male@idle_a")
        TaskPlayAnim(PlayerPedId(), "amb@world_human_tourist_map@male@idle_a", "idle_b", 3.0, 3.0, -1, 49, 0, 0, 0, 0)

        Citizen.Wait(5000)
        StopAnimTask(PlayerPedId(), "amb@world_human_tourist_map@male@idle_a", "idle_b", 1.0)


        TriggerEvent("destroyProp")
    end
end)

function LoadAnimationDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

local function playBinderAnimation()
    inBinder = true
    TriggerEvent('closeInventoryGui')
    Citizen.Wait(500)
    ClearPedTasksImmediately()
    Citizen.Wait(500)
    LoadAnimationDic("amb@code_human_in_bus_passenger_idles@female@tablet@base")
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    TriggerEvent("attachItemPhone", "binder01")
end

local function stopBinderAnimation()
    Citizen.Wait(1000)
    StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 1.0)
    TriggerEvent("destroyPropPhone")
    inBinder = false
end

local function playPackOpeningAnimation()
    inPackOpening = true
    Citizen.Wait(500)
    ClearPedTasksImmediately()
    Citizen.Wait(500)
    LoadAnimationDic("amb@world_human_tourist_map@male@idle_a")
    TaskPlayAnim(PlayerPedId(), "amb@world_human_tourist_map@male@idle_a", "idle_b", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    TriggerEvent("attachItemPhone", "tcg_card_inspect")
end

local function stopPackOpeningAnimation()
    Citizen.Wait(1000)
    StopAnimTask(PlayerPedId(), "amb@world_human_tourist_map@male@idle_a", "idle_b", 1.0)
    TriggerEvent("destroyPropPhone")
    inPackOpening = false
end

AddEventHandler('np-tcg:open-binder', function()
    --print('np-tcg:open-binder')
    local isDead = exports["isPed"]:isPed("dead")
    local isInTrunk = exports["isPed"]:isPed("intrunk")
    if isDead or isInTrunk then return end
    playBinderAnimation()
end)

AddEventHandler('np-tcg:open-pack', function()
    --print('np-tcg:open-binder')
    local isDead = exports["isPed"]:isPed("dead")
    local isInTrunk = exports["isPed"]:isPed("intrunk")
    if isDead or isInTrunk then return end
    playPackOpeningAnimation()
end)

RegisterUICallback( 'np-ui:close-pack-opening', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = 'done' } })
    stopPackOpeningAnimation()
end)

AddEventHandler("np-ui:application-closed", function(name)
    if name == "tcg-binder" then
        stopBinderAnimation()
        SetPlayerControl(PlayerId(), 1, 0)
    elseif name == "tcg-packopening" then
        stopPackOpeningAnimation()
        SetPlayerControl(PlayerId(), 1, 0)
    end
end)

local hasPermission = false

function checkJobPermission(characterId)
    Citizen.Wait(5000)
    hasPermission = exports['np-business']:IsEmployedAt('nopixelcards') and RPC.execute("np-business:hasPermission", 'nopixelcards', 'craft_access', characterId)
end

function checkJobPermissionAlt()
    checkJobPermission(exports['isPed']:isPed('cid'))
end

RegisterNetEvent('np-spawn:characterSpawned')
AddEventHandler('np-spawn:characterSpawned', checkJobPermission)
RegisterNetEvent('np-business:employmentStatus')
AddEventHandler('np-business:employmentStatus', checkJobPermissionAlt)
AddEventHandler('np-tcg:hotreload', checkJobPermissionAlt)

Citizen.CreateThread(function()
    exports["np-interact"]:AddPeekEntryByModel({ GetHashKey('boxville7') }, {
        {
            id = "tcg_truckstock",
            label = "Stock",
            icon = "truck-loading",
            event = "np-tcg:truck-stock",
            parameters = {}
        },
    }, {
        distance = { radius = 5.0 },
        isEnabled = function(pEntity, pContext)
            if not hasPermission then return false end
            local lockStatus = GetVehicleDoorLockStatus(pEntity)
            return isCloseToBoot(pEntity, PlayerPedId(), 3.0, pContext.model) and (lockStatus == 1 or lockStatus == 0 or lockStatus == 4)
        end
    })
end)

AddEventHandler("np-tcg:truck-tailgate", function(pParams, pEntity)
    local vin = exports['np-vehicles']:GetVehicleIdentifier(pEntity)
    TriggerEvent("server-inventory-open", "1", "tcg_truck_tailgate_" .. vin)
end)

Citizen.CreateThread(function()
    exports["np-interact"]:AddPeekEntryByModel({ GetHashKey('boxville7') }, {
        {
            id = "tcg_trucktailgate",
            label = "Tailgate",
            icon = "box",
            event = "np-tcg:truck-tailgate",
            parameters = {}
        },
    }, {
        distance = { radius = 5.0 },
        isEnabled = function(pEntity, pContext)
            return isCloseToBoot(pEntity, PlayerPedId(), 3.0, pContext.model)
        end
    })
end)

-- np-interact helpers
function getTrunkOffset(pEntity)
  local minDim, maxDim = GetModelDimensions(GetEntityModel(pEntity))
  return GetOffsetFromEntityInWorldCoords(pEntity, 0.0, minDim.y - 0.5, 0.0)
end

function getFrontOffset(pEntity)
    local minDim, maxDim = GetModelDimensions(GetEntityModel(pEntity))
    return GetOffsetFromEntityInWorldCoords(pEntity, 0.0, maxDim.y + 0.5, 0.0)
end

local ModelData = {}

function GetModelData(pEntity, pModel)
    if ModelData[pModel] then return ModelData[pModel] end

    local modelInfo = {}

    local coords = getTrunkOffset(pEntity)
    local boneCoords, engineCoords = GetWorldPositionOfEntityBone(pEntity, GetEntityBoneIndexByName(pEntity, 'engine'))

    if #(boneCoords - coords) <= 2.0 then
        engineCoords = coords
        modelInfo = { engine = { position = 'trunk', door = 4 }, trunk = { position = 'front', door = 5 } }
    else
        engineCoords = getFrontOffset(pEntity)
        modelInfo = { engine = { position = 'front', door = 4 }, trunk = { position = 'trunk', door = 5 } }
    end

    local hasBonnet = DoesVehicleHaveDoor(pEntity, 4)
    local hasTrunk = DoesVehicleHaveDoor(pEntity, 5)

    if hasBonnet then
        local bonnetCoords = GetWorldPositionOfEntityBone(pEntity, GetEntityBoneIndexByName(pEntity, 'bonnet'))

        if #(engineCoords - bonnetCoords) <= 2.0 then
            modelInfo.engine.door = 4
            modelInfo.trunk.door = hasTrunk and 5 or 3
        elseif hasTrunk then
            modelInfo.engine.door = 5
            modelInfo.trunk.door = 4
        end
    elseif hasTrunk then
        local bootCoords = GetWorldPositionOfEntityBone(pEntity, GetEntityBoneIndexByName(pEntity, 'boot'))

        if #(engineCoords - bootCoords) <= 2.0 then
            modelInfo.engine.door = 5
        end
    end

    ModelData[pModel] = modelInfo

    return modelInfo
end

function isCloseToBoot(pEntity, pPlayerPed, pDistance, pModel)
    local model = pModel or GetEntityModel(pEntity)
    local modelData = GetModelData(pEntity, model)

    local playerCoords = GetEntityCoords(pPlayerPed)

    local engineCoords = modelData.trunk.position == 'front' and getFrontOffset(pEntity) or getTrunkOffset(pEntity)

    return #(engineCoords - playerCoords) <= pDistance
end
