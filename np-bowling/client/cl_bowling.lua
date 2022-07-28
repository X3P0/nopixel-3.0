local function getDirVecFromHead(h, p)
    h = h - 270
    return vector3(math.cos(math.rad(h))*math.cos(math.rad(p)), math.sin(math.rad(h))*math.cos(math.rad(p)), math.sin(math.rad(p)))
end

local function hue2rgb(p, q, t)
    if t < 0   then t = t + 1 end
    if t > 1   then t = t - 1 end
    if t < 1/6 then return p + (q - p) * 6 * t end
    if t < 1/2 then return q end
    if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
    return p
end

local function hsl2rgb(h, s, l)
    local r, g, b

    local h = h / 360

    if s == 0 then
        r, g, b = l, l, l
    else
        local q = (l < 0.5) and l * (1 + s) or l + s - l * s
        local p = l * 2 - q

        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end

    return {r=math.ceil(r*255), g=math.ceil(g*255), b=math.ceil(b*255)}
end

function percToHsl(p)
    p = p/100
    local hue = (1 - p) * 120
    return hsl2rgb(hue, 1.0, 0.5)
end

function drawBox(x,y,w,h,r,g,b,a)
	DrawRect(x + w/2, y + h/2, w, h, r, g, b, a)
end

local ballObject = nil
local isBowling = false

function startBowling(isDrunk, cb)
    if isBowling then return end 

    removeBowlingBall()

    local staticHeading = GetEntityHeading(PlayerPedId())
    local staticCoords = GetEntityCoords(PlayerPedId())

    RequestModel(Config.BallObject)

    while (not HasModelLoaded(Config.BallObject)) do
        Citizen.Wait(0)
    end

    local ballForce = 0

    ballObject = CreateObject(Config.BallObject, staticCoords, true, false)
    local bone = GetPedBoneIndex(PlayerPedId(), 57005)

    SetEntityAsMissionEntity(ballObject, true, true)
    AttachEntityToEntity(ballObject, PlayerPedId(), bone, 0.21, 0.04, -0.1, -69.0, -71.0, 6.0, false, true, true, true, 0, true)

    isBowling = true

    local maxHeading = staticHeading+Config.MaxAngleMovement
    local minHeading = staticHeading-Config.MaxAngleMovement

    RequestAnimDict(Config.StandAnimDict)

    while (not HasAnimDictLoaded(Config.StandAnimDict)) do 
        Citizen.Wait(0)  
    end

    while (isBowling) do
        Citizen.Wait(0)

        DisableControlAction(0, 142, true)
        DisableControlAction(0, 30,  true)
        DisableControlAction(0, 31,  true)
        DisableControlAction(0, 24,  true)
        DisableControlAction(0, 92,  true)
        DisableControlAction(0, 75,  true)
        DisableControlAction(0, 174,  true)
        DisableControlAction(0, 175,  true)
        DisableControlAction(0, 18,  true)

        ballForce = ballForce + 0.25

        if ballForce > 100 then
            ballForce = 0
        end

        local rgb = percToHsl(math.ceil(ballForce), 0, 120)
        
        SetEntityHeading(ballObject, GetEntityHeading(PlayerPedId()))

        if (Config.DisplayDirectionalLine) then
            local ballCoords = GetEntityCoords(ballObject)
            local forwardCoord = ballCoords+(getDirVecFromHead(GetEntityHeading(ballObject), 0)*5)

            DrawLine(ballCoords.x, ballCoords.y, ballCoords.z, forwardCoord.x, forwardCoord.y, ballCoords.z, rgb.r,rgb.g,rgb.b, 150)
        end

        if (Config.DisplayForceBar) then
            local width = 0.15

            drawBox(0.5 - width/2, 0.8, width, 0.012, 40,40,40,200)
            drawBox(0.5 - width/2, 0.8, width * (ballForce / 100), 0.012,rgb.r,rgb.g,rgb.b,200)
        end

        if (not IsEntityPlayingAnim(PlayerPedId(), Config.StandAnimDict, Config.StandAnim, 3)) then
            TaskPlayAnim(PlayerPedId(), Config.StandAnimDict, Config.StandAnim, 1.0, -8.0, -1, 17, 0, false, false, false)
        end

        currHeading = GetEntityHeading(PlayerPedId())

        if (IsDisabledControlPressed(0, 34)) then
            if (currHeading + Config.DirectionChangeSpeed <= maxHeading) then
                SetEntityHeading(PlayerPedId(), currHeading + Config.DirectionChangeSpeed)
            end
        elseif (IsDisabledControlPressed(0, 35)) then
            if (currHeading - Config.DirectionChangeSpeed >= minHeading) then
                SetEntityHeading(PlayerPedId(), currHeading - Config.DirectionChangeSpeed)
            end
        elseif (IsDisabledControlJustReleased(0, 18)) then
            TaskPlayAnim(PlayerPedId(), Config.StandAnimDict, Config.ThrowAnim, 8.0, 1.0, -1, 0, 0, false, false ,false)

            DetachEntity(ballObject)
            SetEntityNoCollisionEntity(ballObject, PlayerPedId())

            local drunkFactor = GetEntityForwardX(ballObject) + GetEntityForwardY(ballObject) * math.random(1,10)
            local drunkForce = isDrunk and drunkFactor or 0
            local baseForce = Config.BaseBallForce + drunkForce

            SetEntityHeading(ballObject, currHeading)
            SetEntityVelocity(ballObject, GetEntityForwardX(ballObject) * (baseForce + (ballForce/5)), GetEntityForwardY(ballObject) * (baseForce + (ballForce/5)), 0.0)

            isBowling = false
            Citizen.Wait(500)
            ClearPedTasks(PlayerPedId())

            cb(ballObject)
        end
    end

    SetModelAsNoLongerNeeded(Config.BallObject)
end

function createPins(coords, cb)
    RequestModel(Config.PinObject)

    while (not HasModelLoaded(Config.PinObject)) do
        Citizen.Wait(0)
    end

    local rad = math.pi/180 * -30 --
    
    for y = 1, 4 do
      for x = 1, y do
        local size = 0.3
        local coordX = ((x-y*0.5) * size)
        local coordY = (y * size * math.sin(math.pi/3))
        coordX = coordX * math.cos(rad) - coordY * math.sin(rad) --
        coordY = coordY * math.cos(rad) + coordX * math.sin(rad) --
        local pos = vector3(coordX, coordY, 0)
        local coord = vector3(coords.x, coords.y, coords.z) + pos
    
        local pinObj = CreateObject(Config.PinObject, coord, true, true)
        SetEntityHeading(pinObj, 0)
        table.insert(Config.PinList, pinObj)
      end
    end

    SetModelAsNoLongerNeeded(Config.PinObject)

    if cb then
        cb()
    end
end

function getPinsDowned()
    local i = {}

    for _, pin in pairs(Config.PinList) do
        local up = vector3(0,0,1)
        local _, _, upPin = GetEntityMatrix(pin)

        if (dot(up, upPin) < 0.15) then
            table.insert(i, pin)
        end
    end

    return i
end 

function getPinsDownedCount()
    return #getPinsDowned()
end

function removeBowlingBall()
    if (DoesEntityExist(ballObject)) then
        DeleteEntity(ballObject)
        isBowling = false

        if (IsEntityPlayingAnim(PlayerPedId(), Config.StandAnimDict, Config.StandAnim, 3)) then
            ClearPedTasksImmediately(PlayerPedId())
        end
    end
end

function removePins()
    for _, pin in pairs(Config.PinList) do
        if (DoesEntityExist(pin)) then
            DeleteEntity(pin)
        end
    end

    Config.PinList = {}
end

function removeDownedPins()
    for _, pin in pairs(getPinsDowned()) do
        if (DoesEntityExist(pin)) then
            DeleteEntity(pin)
            pin = nil
        end
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    if (DoesEntityExist(ballObject)) then
        DeleteEntity(ballObject)
    end

    for _, pin in pairs(Config.PinList) do
        if (DoesEntityExist(pin)) then
            DeleteEntity(pin)
        end
    end
end)
  
exports('startBowling', startBowling)
exports('createPins', createPins)
exports('getPinsDowned', getPinsDowned)
exports('removeBowlingBall', removeBowlingBall)
exports('removePins', removePins)