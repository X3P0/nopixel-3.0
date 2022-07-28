
-- This manages recoil and crouch / prone
local stresslevel = 0
local playerPed = PlayerPedId()
local Triggered3 = false
function RecoilFactor(stress,stance)
    if stance == nil then
        stance = 0
    end
    if stance == 3 then
        stance = 1
    end
    sendFactor = ((math.ceil(stress) / 1000)) - stance


    TriggerEvent("recoil:updateposition",sendFactor)

end

RegisterNetEvent("client:updateStress")
AddEventHandler("client:updateStress",function(newStress)
    stresslevel = newStress
    if dstamina == 0 then
        RevertToStressMultiplier()
    end
end)


local prone = true
local movFwd = true

local ctrlStage = 0
local camon = false
local shitcam = 0


imdead = 0
RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if imdead == 0 then 
        imdead = 1
    else
        beingDragged = false
        dragging = false
        imdead = 0
    end
end)

function crouchMovement()
    RequestAnimSet("move_ped_crouched")
    while not HasAnimSetLoaded("move_ped_crouched") do
        Citizen.Wait(0)
    end

    SetPedMovementClipset(playerPed, "move_ped_crouched",1.0)    
    SetPedWeaponMovementClipset(playerPed, "move_ped_crouched",1.0)
    SetPedStrafeClipset(playerPed, "move_ped_crouched_strafing",1.0)

end

function moveCrouch()
    if (IsPedReloading(playerPed)) then
        return
    end

    if ctrlStage == 3 then
        if Triggered3 then
            crouch(true)     
        end
    elseif not isFlying and not isHolding and not ( IsPedSittingInAnyVehicle( GetPlayerPed( -1 ) ) ) and not (handCuffed or handCuffedWalking or imdead == 1) then
        ctrlStage = 3
        if GetPedStealthMovement(playerPed) then
            SetPedStealthMovement(playerPed,0,0)
        end             
        RecoilFactor(stresslevel,ctrlStage)
        firstPersonActive = false
    end

end

function crouch(isKey)
    if isKey then -- X
        SetPedStealthMovement(playerPed,true,"")
        firstPersonActive = false
        ctrlStage = 0

        TriggerEvent("AnimSet:Set")

        Citizen.Wait(100)  
        ClearPedTasks(playerPed)

        jumpDisabled = false
        
        RecoilFactor(stresslevel,0)
        Citizen.Wait(500)
        SetPedStealthMovement(playerPed,false,"")
        Triggered3 = false

    else
        if GetEntitySpeed(playerPed) > 1.0 and not incrouch then
            incrouch = true
            SetPedWeaponMovementClipset(playerPed, "move_ped_crouched",1.0)
            SetPedStrafeClipset(playerPed, "move_ped_crouched_strafing",1.0)
        elseif incrouch and GetEntitySpeed(playerPed) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then

            incrouch = false
            ResetPedWeaponMovementClipset(playerPed)
            ResetPedStrafeClipset(playerPed)
        end     
    end
end

Citizen.CreateThread(function()
  exports["np-keybinds"]:registerKeyMapping("", "Player", "Crouch", "+moveCrouch", "-moveCrouch", "X")
  RegisterCommand('+moveCrouch', moveCrouch, false)
  RegisterCommand('-moveCrouch', function() end, false)
end)

local fixprone = false
RegisterNetEvent("fixprone")
AddEventHandler("fixprone",function()
    if ctrlStage == 2 then
        fixprone = true
    end
end)


function doCrouchIn()

--  RequestAnimDict("swimming@swim")
--  while not HasAnimDictLoaded("swimming@swim") do
--      Citizen.Wait(0)
--  end

--  TaskPlayAnim(playerPed, "swimming@swim", "recover_down_to_idle", 0.8, 0.8, 1.0, 49, 0, 0, 0, 0)

--  Citizen.Wait(420)
    crouchMovement()
end

myWep = 0
local runningMovement = false
RegisterNetEvent("proneMovement")
AddEventHandler("proneMovement",function()
    if runningMovement then
        return
    end
    runningMovement = true

    if ((IsControlPressed(1,32)) and not movFwd) or (fixprone and (IsControlPressed(1,32))) then -- W
        fixprone = false
        movFwd = true
        SetPedMoveAnimsBlendOut(playerPed)
        local pronepos = GetEntityCoords(playerPed)
        TaskPlayAnimAdvanced(playerPed, "move_crawl", "onfront_fwd", pronepos["x"],pronepos["y"],pronepos["z"]+0.1, 0.0, 0.0, GetEntityHeading(playerPed), 100.0, 0.4, 1.0, 7, 2.0, 1, 1) 
        Citizen.Wait(500)
    elseif ( not (IsControlPressed(1,32)) and movFwd) or (fixprone and not (IsControlPressed(1,32))) then -- W
        fixprone = false
        curWep = GetSelectedPedWeapon(playerPed)
        myWep =  GetSelectedPedWeapon(playerPed)
        local pronepos = GetEntityCoords(playerPed)
        TaskPlayAnimAdvanced(playerPed, "move_crawl", "onfront_fwd", pronepos["x"],pronepos["y"],pronepos["z"]+0.1, 0.0, 0.0, GetEntityHeading(playerPed), 100.0, 0.4, 1.0, 6, 2.0, 1, 1)
        Citizen.Wait(500)
        movFwd = false
    end     
    runningMovement = false

end)


local foreskin = false
local isHolding = false
local isFlying = false
-- 0 = default, 1 = crouch, 2 = prone
incrouch = true

Citizen.CreateThread(function()

    local Triggered1 = false
    local Triggered2 = false
    
    while true do
        playerPed = PlayerPedId()

        if ctrlStage == 3 then
            if IsControlJustPressed(2,23) then -- F
                firstPersonActive = false
                ctrlStage = 0
                TriggerEvent("AnimSet:Set")
                jumpDisabled = false
                SetPedStealthMovement(playerPed,0,0)
                RecoilFactor(stresslevel,0)             
            else
                if not Triggered3 then
                    ClearPedTasks(playerPed)
                    Triggered1 = false  
                    Triggered2 = false
                    Triggered3 = true
                    crouchMovement()

                else
                    crouch(false)       
                end
            end
        end
        if IsControlJustPressed(0, 142) or IsDisabledControlJustPressed(0, 142) then
            if ctrlStage == 2 then
                ctrlStage = 3
            end
        end
        if ctrlStage ~= 0 then
            if IsPedJacking(playerPed) or IsPedInMeleeCombat(playerPed) or IsControlJustReleased(1,22) or IsPedRagdoll(playerPed) or handCuffed or handCuffedWalking or imdead == 1 or ( IsPedSittingInAnyVehicle( GetPlayerPed( -1 ) ) ) then
                
                    ClearPedTasks(playerPed)
                    firstPersonActive = false
                    ctrlStage = 0
                    TriggerEvent("AnimSet:Set")
                    jumpDisabled = false
                    SetPedStealthMovement(playerPed,0,0)
                    RecoilFactor(stresslevel,0)
                    Triggered1 = false  
                    Triggered2 = false
                    Triggered3 = false
            end
        end
        Citizen.Wait(1)
    end
end)
handCuffed = false
handCuffedWalking = false


RegisterNetEvent('np-police:cuffs:state')
AddEventHandler('np-police:cuffs:state', function(handCuffedSent,WalkingSent)
    handCuffed = handCuffedSent
    handCuffedWalking = WalkingSent
end)

RegisterNetEvent('news:HoldingState')
AddEventHandler('news:HoldingState', function(state)
    isHolding = state
end)

RegisterNetEvent("admin:isFlying")
AddEventHandler("admin:isFlying", function(state)
    isFlying = state
end)

AddEventHandler('baseevents:enteredVehicle', function(_, _, _, _, pModel)
    if IsThisModelABike(pModel) then
        return
    end
    VehicleAiming(true)
end)

AddEventHandler('baseevents:leftVehicle', function(_, _, _, _, pModel)
    VehicleAiming(false)
end)

local isInVehicle = false
function VehicleAiming(pIsInVehicle)
    isInVehicle = pIsInVehicle
    if not isInVehicle then
        return
    end
    Citizen.CreateThread( function()
        while isInVehicle do
            if IsPedArmed(playerPed, 6) then
                if IsPedDoingDriveby(playerPed)  then
                    if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
                        local curWeapon = GetSelectedPedWeapon(playerPed)
                        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
                        SetCurrentPedVehicleWeapon(playerPed, `WEAPON_UNARMED`)
                        SetPlayerCanDoDriveBy(PlayerId(),false)
                        SetFollowPedCamViewMode(4)
                        SetFollowVehicleCamViewMode(4)
                        Wait(250)
                        SetCurrentPedWeapon(playerPed, curWeapon, true)
                        SetCurrentPedVehicleWeapon(playerPed, curWeapon)
                        SetPlayerCanDoDriveBy(PlayerId(),true)
                    end
                else
                    DisableControlAction(0,36,true)
                    if GetPedStealthMovement(playerPed) == 1 then
                        SetPedStealthMovement(playerPed,0)
                    end
                end
            end
            Wait(1)
        end
    end)
end