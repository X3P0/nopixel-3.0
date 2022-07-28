CurrentPeekCamera = nil
CurrentlyUsingCamera = false

CamModel = "prop_v_cam_01"
CamAnimDict = "missfinale_c2mcs_1"
CamAnimName = "fin_c2_mcs_1_camman"

local FOV_MAX = 70.0
local FOV_MIN = 5.0
local CAM_FOV = (FOV_MAX + FOV_MIN) * 0.5
local zoomspeed = 10.0

local CurrentCameraObject = nil

function createCamera()
    RequestModel(GetHashKey(CamModel))
    while not HasModelLoaded(GetHashKey(CamModel)) do
        Citizen.Wait(100)
    end
    local player = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.0, -5.0)
    local camObject = CreateObject(GetHashKey(CamModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
    CurrentCameraObject = camObject
    AttachEntityToEntity(camObject, player, GetPedBoneIndex(player, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
end

function removeCamera()
    ClearPedSecondaryTask(PlayerPedId())
    if CurrentCameraObject and DoesEntityExist(CurrentCameraObject) then
        DetachEntity(CurrentCameraObject, 1, 1)
        DeleteEntity(CurrentCameraObject)
        CurrentCameraObject = nil
    end
end

function activateHeldCamera()
    CurrentlyUsingCamera = true
    SetTimecycleModifier("default")
    SetTimecycleModifierStrength(0.3)
    local scaleform = RequestScaleformMovie("security_camera")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(10)
    end
    local scaleform2 = RequestScaleformMovie("breaking_news")
    while not HasScaleformMovieLoaded(scaleform2) do
        Citizen.Wait(10)
    end

    local player = PlayerPedId()
    local createdCam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

    AttachCamToEntity(createdCam, player, 0.0, 0.6, 0.75, true)
    SetCamRot(createdCam, 0.0, 0.0, GetEntityHeading(player))
    SetCamFov(createdCam, CAM_FOV)
    RenderScriptCams(true, false, 0, 1, 0)

    PushScaleformMovieFunction(scaleform, "security_camera")
    PopScaleformMovieFunctionVoid()

    if not IsEmployed and CurrentOverlay then
        PushScaleformMovieFunction(scaleform2, "breaking_news")
        PopScaleformMovieFunctionVoid()
    end
    if IsEmployed and CurrentOverlay then
        exports["np-ui"]:sendAppEvent("newscam", { show = true })
        exports["np-ui"]:sendAppEvent("hud", { display = false })
    end

    while CurrentlyUsingCamera and not IsEntityDead(player) do
        if IsDisabledControlJustReleased(0, 24) then
            SetCursorLocation(0.5, 0.5)
            local context = {}
            if IsRecording then
                context[#context+1] = { 
                    title = "Stop Taping",
                    description = "Get the footage",
                    action = "np-newsjob:stopRecording"
                }
                context[#context+1] = { 
                    title = "Cancel Current Tape",
                    description = "Does not save",
                    action = "np-newsjob:cancelRecording"
                }
            else
                context[#context+1] = { 
                        title = "Begin Taping",
                        description = "Notes current location and time",
                        action = "np-newsjob:startRecording",
                        key = { id = CurrentCamera.id, increment = CurrentCamera.increment}
                }
            end
            context[#context+1] = {
                title = "Toggle Overlay",
                description = "Enabled: " .. tostring(CurrentOverlay),
                action = "np-newsjob:toggleOverlay"
            }
            context[#context+1] = {
                title = "Set Overlay Text",
                description = "Current Text: " .. CurrentOverlayText,
                action = "np-newsjob:setOverlayText"
            }
            exports['np-ui']:showContextMenu(context)
        end

        SetEntityRotation(player, 0, 0, new_z, 2, true)

        local zoomvalue = (1.0 / (FOV_MAX - FOV_MIN)) * (CAM_FOV - FOV_MIN)
        CheckInputRotation(createdCam, zoomvalue)

        HandleZoom(createdCam)

        local camHeading = GetGameplayCamRelativeHeading()
        local camPitch = GetGameplayCamRelativePitch()
        if camPitch < -70.0 then
            camPitch = -70.0
        elseif camPitch > 42.0 then
            camPitch = 42.0
        end
        camPitch = (camPitch + 70.0) / 112.0

        if camHeading < -180.0 then
            camHeading = -180.0
        elseif camHeading > 180.0 then
            camHeading = 180.0
        end
        camHeading = (camHeading + 180.0) / 360.0

        Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
        Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)
        if not IsEmployed and CurrentOverlay then
            DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)
            if CurrentOverlayText then
                SetTextColour(255, 255, 255, 255)
                SetTextFont(8)
                SetTextScale(1.2, 1.2)
                SetTextWrap(0.0, 1.0)
                SetTextCentre(false)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 205)
                SetTextEntry("STRING")
                AddTextComponentString(CurrentOverlayText)
                DrawText(0.2, 0.85)
            end
        end

        Citizen.Wait(0)
    end

    ClearTimecycleModifier()
    CAM_FOV = (FOV_MAX + FOV_MIN) * 0.5
    RenderScriptCams(false, false, 0, 1, 0)
    SetScaleformMovieAsNoLongerNeeded(scaleform)
    SetScaleformMovieAsNoLongerNeeded(scaleform2)
    DestroyCam(createdCam, false)
    SetNightvision(false)
    SetSeethrough(false)
end

function activatePeekCamera()
    SetTimecycleModifier("default")
    SetTimecycleModifierStrength(0.3)

    local player = PlayerPedId()
    local createdCam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

    AttachCamToEntity(createdCam, CurrentPeekCamera, 0.0, -0.8, 0.5, true)
    SetCamRot(createdCam, 0.0, 0.0, GetEntityHeading(CurrentPeekCamera) + 180.0)
    SetCamFov(createdCam, CAM_FOV)
    RenderScriptCams(true, false, 0, 1, 0)
    --AttachEntityToEntity(player, CurrentPeekCamera, -1, 0, 1.0, 0, 0.0, 0.0, 180.0, false, false, false, false, 0, true)

    local animDict = "mp_prison_break"
    local animation = "hack_loop"
    loadAnimDict(animDict)
    TaskPlayAnim(player, animDict, animation, 8.0, -8.0, -1, 2, 0, false, false, false)

    while CurrentPeekCamera and not IsEntityDead(player) do
        local zoomvalue = (1.0 / (FOV_MAX - FOV_MIN)) * (CAM_FOV - FOV_MIN)
        CheckInputRotation(createdCam, zoomvalue)

        HandleZoom(createdCam)
        local camRot = GetCamRot(createdCam, 2)
        SetEntityHeading(CurrentPeekCamera, camRot[3] + 180)
        SetEntityLocallyInvisible(PlayerPedId())

        if IsDisabledControlJustReleased(0, 200) or IsControlJustReleased(0, 25) then
            CurrentPeekCamera = nil
        end

        Citizen.Wait(0)
    end
    ClearTimecycleModifier()
    CAM_FOV = (FOV_MAX + FOV_MIN) * 0.5
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(createdCam, false)
    DetachEntity(player, false, false)
    ClearPedTasks(player)
    SetNightvision(false)
    SetSeethrough(false)
end

function HandleZoom(cam)
    local player = PlayerPedId()
    if not IsPedSittingInAnyVehicle(player) then
        if IsControlJustPressed(0, 241) then
            CAM_FOV = math.max(CAM_FOV - zoomspeed, FOV_MIN)
        end
        if IsControlJustPressed(0, 242) then
            CAM_FOV = math.min(CAM_FOV + zoomspeed, FOV_MAX)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(CAM_FOV - current_fov) < 0.1 then
            CAM_FOV = current_fov
        end
        SetCamFov(cam, current_fov + (CAM_FOV - current_fov) * 0.05)
    else
        if IsControlJustPressed(0, 17) then
            CAM_FOV = math.max(CAM_FOV - zoomspeed, FOV_MIN)
        end
        if IsControlJustPressed(0, 16) then
            CAM_FOV = math.min(CAM_FOV + zoomspeed, FOV_MAX)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(CAM_FOV - current_fov) < 0.1 then
            CAM_FOV = current_fov
        end
        SetCamFov(cam, current_fov + (CAM_FOV - current_fov) * 0.05)
    end
end

function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX * -1.0 * 8.0 * (zoomvalue + 0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * 8.0 * (zoomvalue + 0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end

function Breaking(text)
    SetTextColour(255, 255, 255, 255)
    SetTextFont(8)
    SetTextScale(1.2, 1.2)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.2, 0.85)
end
