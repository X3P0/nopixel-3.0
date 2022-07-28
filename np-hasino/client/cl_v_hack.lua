local hackAnimDict = "anim@heists@ornate_bank@hack"

RegisterNetEvent('np-hasino:vaultHack', function(pGameId, pLaptopType)
    local laptopObj = VaultHackAnimation()
    local hackPromise = promise:new()
    if pLaptopType == 'fleeca' then
        VaultHackFleeca(hackPromise, pGameId)
    end
    if pLaptopType == 'thermite' then
        VaultHackThermite(hackPromise, pGameId)
    end
    if pLaptopType == 'var' then
        VaultHackVAR(hackPromise, pGameId)
    end
    if pLaptopType == 'maze' then
        VaultHackMaze(hackPromise, pGameId)
    end
    local result = Citizen.Await(hackPromise)
    TriggerServerEvent('np-hasino:vaultHackResult', pGameId, result)
    Wait(1000)
    TaskPlayAnim(PlayerPedId(), hackAnimDict, "hack_exit", 1.0, 0.0, -1, 0, 0, false, false, false)
    Sync.DeleteEntity(laptopObj)
    Wait(6500)
    ClearPedTasksImmediately(PlayerPedId())
end)

function VaultHackAnimation()
    local player = PlayerPedId()
    local plyCoords = GetEntityCoords(player)

    local laptopHash = GetHashKey("hei_prop_hst_laptop")
    loadAnimDict(hackAnimDict)
    loadModel(laptopHash)

    local closestBox = GetClosestObjectOfType(plyCoords, 3.0, DefaultLockBoxModel, 0, 1, 1)

    if not closestBox then
        print('[HASINO] No Box Found')
        return
    end

    local laptop = CreateObject(laptopHash, GetOffsetFromEntityInWorldCoords(player, 0.2, 0.6, -1.0), 1, 1, 0)
    SetEntityVisible(laptop, false, false)
    SetEntityHeading(laptop, GetEntityHeading(player))
    SetEntityCollision(laptop, false, false)

    TaskTurnPedToFaceEntity(player, closestBox, 1500)
    Wait(1500)
    ClearPedTasksImmediately(player)
    TaskPlayAnim(player, hackAnimDict, "hack_enter", 8.0, -8.0, -1, 0, 0, true, true, true)
    -- PlaceObjectOnGroundProperly(laptop)
    Wait(8300)
    SetEntityVisible(laptop, true, false)
    TaskPlayAnim(player, hackAnimDict, "hack_loop", 8.0, -8.0, -1, 1, 0, true, true, true)
    return laptop
end

local minigameId = 0
local curMinigameId = -1
local curMinigamePromise = nil
RegisterUICallback('np-hasino:minigameFleeca', function(data, cb)
    if curMinigamePromise then
        curMinigamePromise:resolve(data.success)
        curMinigamePromise = nil
    end
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)

RegisterUICallback('np-hasino:minigameThermite', function(data, cb)
    if curMinigamePromise then
        curMinigamePromise:resolve(data.success)
        curMinigamePromise = nil
    end
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)

RegisterUICallback('np-hasino:minigameVAR', function(data, cb)
    if curMinigamePromise then
        curMinigamePromise:resolve(data.success)
        curMinigamePromise = nil
    end
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)

RegisterUICallback('np-hasino:minigameMaze', function(data, cb)
    if curMinigamePromise then
        curMinigamePromise:resolve(data.success)
        curMinigamePromise = nil
    end
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)

RegisterUICallback('np-ui:applicationClosed', function(data, cb)
    if curMinigamePromise then
        curMinigamePromise:resolve(false)
        curMinigamePromise = nil
    end
end)

function VaultHackFleeca(pPromise, pGameId)
    local successes = 0
    for i=1,4 do
        local gameDifficulty = pGameId > 8 and 3 or 1
        local shapes = math.min(3 + i + (gameDifficulty > 1 and 1 or 0), 5 + gameDifficulty)
        if shapes == 7 then
            shapes = 6
        end
        exports["np-ui"]:openApplication("minigame-captcha", {
            gameFinishedEndpoint = 'np-hasino:minigameFleeca',
            gameDuration = 4100 + (i * 500) - (gameDifficulty * 100),
            gameRoundsTotal = 1,
            gameWon = false,
            gameLost = false,
            numberOfShapes = shapes,
        })
        local gameMinigameId = minigameId
        curMinigameId = minigameId
        minigameId = minigameId + 1
        curMinigamePromise = promise:new()
        SetTimeout(60000, function()
            if curMinigameId == gameMinigameId and curMinigamePromise then
                curMinigamePromise:resolve(false)
                curMinigamePromise = nil
            end
        end)
        local result = Citizen.Await(curMinigamePromise)
        if result then
            successes = successes + 1
        end
        Wait(1000)
    end
    if exports['np-inventory']:hasEnoughOfItem("heistlaptop5", 1, false, true) then
        TriggerEvent("inventory:DegenItemType", 51, "heistlaptop5")
    else
        pPromise:resolve(false)
        return
    end
    if successes == 0 then
        pPromise:resolve(false)
        return
    end
    pPromise:resolve(successes)
end

function VaultHackThermite(pPromise, pGameId)
    local successes = 0
    for i=1,4 do
        local gameDifficulty = pGameId > 8 and 3 or 1
        exports["np-ui"]:openApplication("memorygame", {
            coloredSquares = 8 + (i * 2) + gameDifficulty,
            gameTimeoutDuration = 14000 + (i * 2000),
            gridSize = math.min(5 + i, 8),
            gameFinishedEndpoint = "np-hasino:minigameThermite",
        })
        local gameMinigameId = minigameId
        curMinigameId = minigameId
        minigameId = minigameId + 1
        curMinigamePromise = promise:new()
        SetTimeout(60000, function()
            if curMinigameId == gameMinigameId and curMinigamePromise then
                curMinigamePromise:resolve(false)
                curMinigamePromise = nil
            end
        end)
        local result = Citizen.Await(curMinigamePromise)
        if result then
            successes = successes + 1
        end
        Wait(1000)
    end
    if exports['np-inventory']:hasEnoughOfItem("heistlaptop6", 1, false, true) then
        TriggerEvent("inventory:DegenItemType", 51, "heistlaptop6")
    else
        pPromise:resolve(false)
        return
    end
    if successes == 0 then
        pPromise:resolve(false)
        return
    end
    pPromise:resolve(successes)
end

function VaultHackVAR(pPromise, pGameId)
    local successes = 0
    for i=1,4 do
        local gameDifficulty = pGameId > 8 and 3 or 1
        exports["np-ui"]:openApplication("minigame-serverroom", {
            numberTimeout = 12000 + (i * 500),
            squares = 4 + i + gameDifficulty,
            gameFinishedEndpoint = "np-hasino:minigameVAR",
        })
        local gameMinigameId = minigameId
        curMinigameId = minigameId
        minigameId = minigameId + 1
        curMinigamePromise = promise:new()
        SetTimeout(60000, function()
            if curMinigameId == gameMinigameId and curMinigamePromise then
                curMinigamePromise:resolve(false)
                curMinigamePromise = nil
            end
        end)
        local result = Citizen.Await(curMinigamePromise)
        if result then
            successes = successes + 1
        end
        Wait(1000)
    end
    if exports['np-inventory']:hasEnoughOfItem("heistlaptop7", 1, false, true) then
        TriggerEvent("inventory:DegenItemType", 51, "heistlaptop7")
    else
        pPromise:resolve(false)
        return
    end
    if successes == 0 then
        pPromise:resolve(false)
        return
    end
    pPromise:resolve(successes)
end

function VaultHackMaze(pPromise, pGameId)
    local successes = 0
    for i=1,4 do
        local gameDifficulty = pGameId > 8 and 3 or 1
        exports["np-ui"]:openApplication("minigame-maze", {
            show = true,
            gridSize = math.min(3 + (i * 2), 10),
            useChessPieces = pGameId > 8,
            gameTimeoutDuration = 7000 + (i * 5000 * gameDifficulty),
            numberHideDuration = 3000 + (i * 3000 * gameDifficulty),
            gameFinishedEndpoint = "np-hasino:minigameMaze",
        })
        local gameMinigameId = minigameId
        curMinigameId = minigameId
        minigameId = minigameId + 1
        curMinigamePromise = promise:new()
        SetTimeout(60000, function()
            if curMinigameId == gameMinigameId and curMinigamePromise then
                curMinigamePromise:resolve(false)
                curMinigamePromise = nil
            end
        end)
        local result = Citizen.Await(curMinigamePromise)
        if result then
            successes = successes + 1
        end
        Wait(1000)
    end
    if exports['np-inventory']:hasEnoughOfItem("heistlaptop8", 1, false, true) then
        TriggerEvent("inventory:DegenItemType", 51, "heistlaptop8")
    else
        pPromise:resolve(false)
        return
    end
    if successes == 0 then
        pPromise:resolve(false)
        return
    end
    pPromise:resolve(successes)
end
