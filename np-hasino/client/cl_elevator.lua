local elevatorHeading = 330.0

local rappelCoords = {
    ['rappel_1'] = vector3(1014.6, 29.75, 70.21),
    ['rappel_2'] = vector3(1014.6, 29.75, 80.21),
}

AddEventHandler('np-hasino:rappelDownElevator', function(pArgs, pEntity, pContext)
    local hasGrapple = exports['np-inventory']:hasEnoughOfItem('grapplegun', 1, false, true)
        or exports['np-inventory']:hasEnoughOfItem('grapplegunpd', 1, false, true)
    if not hasGrapple then
        TriggerEvent('DoLongHudText', 'No tools for this', 2)
        return
    end
    local rappelSpot = pContext.zones['hasino_elevator_rappel'].id
    if not rappelCoords[rappelSpot] then
        return
    end

    local animation = AnimationTask:new(PlayerPedId(), 'normal', "Attaching Rope", 5000, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1)
    local finished = Citizen.Await(animation:start())
    if finished ~= 100 then
        return
    end
    DoScreenFadeOut(500)
    SetTimeout(1000, function()
        DoScreenFadeIn(500)
    end)
    Wait(500)
    local ropeId = createRope(1, rappelCoords[rappelSpot])
    rappelDownWall(rappelCoords[rappelSpot], elevatorHeading, PlayerPedId(), ropeId)
end)

local ropeIds = {}

function createRope(pId, pCoords)
    RopeLoadTextures()
    local ropeId = AddRope(pCoords, -90.0, 90.0, -90.0, 85.0, 7, 85.0, 85.0, 1.2, false, false, true, 10.0, false, 0)
    N_0xa1ae736541b0fca3(ropeId, true)
    PinRopeVertex(ropeId, (GetRopeVertexCount(ropeId) - 1), pCoords + vector3(0, 0, 1.0))
    RopeSetUpdateOrder(ropeId, 0)
    ropeIds[pId] = ropeId
    return ropeId
end

function removeRope(pId)
    if  ropeIds[pId] and DoesRopeExist(ropeIds[pId]) then
        DeleteRope(ropeIds[pId])
        DeleteChildRope(ropeIds[pId])
        ropeIds[pId] = nil
    end
    for ropeId,rope in pairs(ropeIds) do
        return
    end
    -- unload if no more ropes
    RopeUnloadTextures()
end

function rappelDownWall(pCoords, pHeading, pPed, pRopeId)
    SetEntityCoords(pPed, pCoords - vector3(0, 0, 10.0))
    TaskRappelDownWall(pPed, pCoords, pCoords, -4.0, pRopeId, 'clipset@anim_heist@hs3f@ig1_rappel@male', 1)

    if pPed == PlayerPedId() then
        SetCamViewModeForContext(0, 0)
        local rappelling = true
        local endCoords = vector3(1014.6, 29.75, -4.0)
        while rappelling do
            SetEntityHeading(pPed, pHeading)
            if #(endCoords - GetEntityCoords(pPed)) < 0.5 then
                Wait(1000)
                rappelling = false
            end
            Wait(0)
        end
        removeRope(1)
        ClearPedTasks(pPed)
        if exports['np-inventory']:hasEnoughOfItem('grapplegun', 1, false) then
            TriggerEvent("inventory:DegenItemType",100,"grapplegun")
        elseif exports['np-inventory']:hasEnoughOfItem('grapplegunpd', 1, false) then
            TriggerEvent("inventory:DegenItemType",100,"grapplegunpd")
        end
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end
AddEventHandler("np-hasino:elevatorForceOpen", function(p1, p2, p3)
    local id = p3.zones.hasino_elevator_force_open.id
    local cfg = RPC.execute("np-hasino:getElevatorConfig", id)
    local hasCrowbar = exports['np-inventory']:hasEnoughOfItem('2227010557', 1, false, true)
    if not hasCrowbar then
        TriggerEvent("DoLongHudText", "Missing something to force open with.", 2)
        return
    end
    SetEntityCoords(PlayerPedId(), cfg.coords)
    SetEntityHeading(PlayerPedId(), cfg.heading)
    local animDict = "missheistfbi3b_ig7"
    local animation = "lift_fibagent_loop"
    SetCurrentPedWeapon(PlayerPedId(), 2227010557, true)
    loadAnimDict(animDict)
    local animLength = GetAnimDuration(animDict, animation)
    TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0, animLength, 1, 0, 0, 0, 0)
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        SetCurrentPedWeapon(PlayerPedId(), 2227010557, true)
    end)
    local finished = exports["np-taskbar"]:taskBar(20000, "Forcing Open")
    ClearPedTasks(PlayerPedId())
    if finished ~= 100 then return end
    TriggerServerEvent("np-hasino:elevatorForcedOpen", id)
end)
AddEventHandler("np-hasino:elevatorDownForceOpen", function()
    TriggerServerEvent("np-hasino:serverElevatorDownForceOpen")
end)

-- 8hack challenge
-- RegisterCommand("8hacks", function()
--     exports["np-ui"]:openApplication("minigame-captcha", {
--         gameFinishedEndpoint = "",
--         gameDuration = 8000,
--         gameRoundsTotal = 8,
--         numberOfShapes = 8,
--         answersRequired = 3,
--     })
-- end, false)
