local camera = false
local playerOriginalCoords = false
local cameraHeight = 90
local runningDim = false
local currentPosition = nil
local currentModelDim = nil
local currentPropertyData = {zone = '', id = 0}
local propertyHeight = -20

RegisterNetEvent('np-housing:editOffset')
AddEventHandler('np-housing:editOffset', function(positionVec4)
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    local zone = GetZoneAtCoords(playerCoords)
    local zoneName = GetNameOfZone(playerCoords)


    if Housing.zone[zoneName] == nil then return false,"No zone found",nil end
    local closest = nil
    local closestDist = 9999

    for k,v in pairs(Housing.zone[zoneName].locations) do
        local distance = #(vector3(positionVec4.x,positionVec4.y,positionVec4.z) - v)
        if distance < 20 then
            if distance <= closestDist then
                closestDist = distance
                closest = k
            end
        end
    end
    
    local shell, modelDim = exports["np-build"]:getModule("func").GetShell(Housing.info[closest].model)
    currentPosition = Housing.zone[zoneName].locations[closest]
    currentModelDim = modelDim
    currentPropertyData.zone = zoneName
    currentPropertyData.id = closest

    CreateCameras(Housing.zone[zoneName].locations[closest]+vector3(0.0, 0.0, cameraHeight))
    RunControls()
    RunDim(currentModelDim,currentPosition)
end)


function CreateCameras(position)
    Citizen.CreateThread(function()
        camera = CreateCamera(`DEFAULT_SCRIPTED_CAMERA`, false)
        if DoesCamExist(camera) then
            SetCamCoord(camera, position)
            SetCamRot(camera, -90.0, 0.0,0.0)
            SetCamFov(camera, 70.0)
            SetCamActive(camera, true)
            SetCamFov(camera, 50.0)
            RenderScriptCams(true, true, 1000)
            local player = PlayerPedId()
            playerOriginalCoords = GetEntityCoords(player) - vector3(0.0, 0.0, 1.0)
            FreezeEntityPosition(player, true)
            SetEntityVisible(player, false)
            SetEntityCoords(player, GetGameplayCamCoord())
        end
    end)
end

function DestoryCameras()
    if DoesCamExist(camera) then
        RenderScriptCams(false, true, 1000)
        Citizen.CreateThread(function()
            Wait(250)
            DestroyCam(camera)
        end)
        local player = PlayerPedId()
        if not IsEntityVisible(player) then
            FreezeEntityPosition(player, false)
            SetEntityVisible(player, true)
            SetEntityCoords(player, playerOriginalCoords)
        end
        camera = false
    end
end

function RunControls()
    Citizen.CreateThread(function()
        while camera ~= false do
            if IsControlJustPressed(0, 202) then
                DestoryCameras()
                runningDim = false
            end

            if IsControlPressed(0, 32) then
                currentPosition = currentPosition + vector3(0.0,0.1,0.0)
                SetCamCoord(camera, currentPosition + vector3(0.0,0.0,cameraHeight))
                RunDim(currentModelDim,currentPosition)
            end

            if IsControlPressed(0, 33) then
                currentPosition = currentPosition + vector3(0.0,-0.1,0.0)
                SetCamCoord(camera, currentPosition + vector3(0.0,0.0,cameraHeight))
                RunDim(currentModelDim,currentPosition)
            end

            if IsControlPressed(0, 34) then
                currentPosition = currentPosition + vector3(-0.1,0.0,0.0)
                SetCamCoord(camera, currentPosition + vector3(0.0,0.0,cameraHeight))
                RunDim(currentModelDim,currentPosition)
            end

            if IsControlPressed(0, 35) then
                currentPosition = currentPosition + vector3(0.1,0.0,0.0)
                SetCamCoord(camera, currentPosition + vector3(0.0,0.0,cameraHeight))
                RunDim(currentModelDim,currentPosition)
            end

            if IsControlJustPressed(0, 38) then
                TriggerEvent("DoLongHudText","Saving offset...",2)

                local offset = Housing.zone[currentPropertyData.zone].locations[currentPropertyData.id] - currentPosition
                RPC.execute("housing:changeOrigin",currentPropertyData.id,offset)
            end
            
            Wait(1)
        end
    end)
end

function RunDim(modelDim,position)
    
    currentPoints = {
        [1] = position.xy + vector2(modelDim.min.x, modelDim.min.y),
        [2] = position.xy + vector2(modelDim.max.x, modelDim.min.y),
        [3] = position.xy + vector2(modelDim.max.x, modelDim.max.y),
        [4] = position.xy + vector2(modelDim.min.x, modelDim.max.y),
    }

    if runningDim then return end
    runningDim = true
    Citizen.CreateThread(function()
        while runningDim ~= false do
            draw(0,position.z+20)
            Wait(1)
        end
        currentPosition = nil
        currentModelDim = nil
    end)
end


-- Yoink from Polyzone 
local defaultColorWalls = {0, 255, 0}
local defaultColorOutline = {255, 0, 0}
local defaultColorGrid = {255, 255, 255}

function _drawWall(p1, p2, minZ, maxZ, r, g, b, a)
    local bottomLeft = vector3(p1.x, p1.y, minZ)
    local topLeft = vector3(p1.x, p1.y, maxZ)
    local bottomRight = vector3(p2.x, p2.y, minZ)
    local topRight = vector3(p2.x, p2.y, maxZ)
    
    DrawPoly(bottomLeft,topLeft,bottomRight,r,g,b,a)
    DrawPoly(topLeft,topRight,bottomRight,r,g,b,a)
    DrawPoly(bottomRight,topRight,topLeft,r,g,b,a)
    DrawPoly(bottomRight,topLeft,bottomLeft,r,g,b,a)
  end
  
  function TransformPoint(point)
    return point
  end
  
  function draw(minZ,maxZ)
    local zDrawDist = 45.0
    local oColor =  defaultColorOutline
    local oR, oG, oB = oColor[1], oColor[2], oColor[3]
    local wColor = defaultColorWalls
    local wR, wG, wB = wColor[1], wColor[2], wColor[3]
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)
    local minZ = minZ
    local maxZ = maxZ
    local points = currentPoints
    for i=1, #points do
      local point = TransformPoint(points[i])
      DrawLine(point.x, point.y, minZ, point.x, point.y, maxZ, oR, oG, oB, 164)
  
      if i < #points then
        local p2 = TransformPoint(points[i+1])
        DrawLine(point.x, point.y, maxZ, p2.x, p2.y, maxZ, oR, oG, oB, 184)
        _drawWall(point, p2, minZ, maxZ, wR, wG, wB, 48)
      end
    end
  
    if #points > 2 then
      local firstPoint = TransformPoint(points[1])
      local lastPoint = TransformPoint(points[#points])
      DrawLine(firstPoint.x, firstPoint.y, maxZ, lastPoint.x, lastPoint.y, maxZ, oR, oG, oB, 184)
      _drawWall(firstPoint, lastPoint, minZ, maxZ, wR, wG, wB, 48)
    end
  end



  -- Check buildings for water


function runThroughBuildingWaterCheck()
    Citizen.CreateThread(function()
        local propertyID = 221
        local propertyInWater = {}
        local index = 1
        --for i=1000, 1100 do
        for i=1201, 1252 do
            if Housing.info[i].model ~= 'shop' and Housing.info[i].model ~= 'buisness_high'  then

                print('Attempting ID: ', i)
                local loc = getBuildingPos(i)
                spawnBuilding(i,loc)
                local isInWater = runCheck(i,loc)
                if isInWater then
                    propertyInWater[index] = {
                        ['id'] = i,
                        ['isInWater'] = isInWater
                    }
                    index = index + 1
                end
                Wait(300)
                if isInWater then print("found building in water ", i) end
                exports["np-build"]:getModule("func").exitCurrentRoom(Housing.info[propertyID][1])
            end
        end
        TriggerServerEvent("coordSaver:SaveWaterPropertyInfo",propertyInWater)
    end)
    
end


function getBuildingPos(propertyID)

    local finished,housingInformation = RPC.execute("getCurrentSelected",propertyID)
    local spawnBuildingLocation = nil
    if type(housingInformation) == "table" then
        Housing.currentHousingInteractions = housingInformation
        Housing.currentHousingInteractions.id = propertyID
    end

    if Housing.currentHousingInteractions ~= nil and Housing.currentHousingInteractions.origin_offset ~= vector3(0.0,0.0,0.0) and type(Housing.currentHousingInteractions.origin_offset) == "vector3" then
        local off = Housing.currentHousingInteractions.origin_offset
        if off == nil then
            off = vector3(0.0,0.0,0.0)
        end
        spawnBuildingLocation = vector3(Housing.info[propertyID][1].x-off.x,Housing.info[propertyID][1].y-off.y,Housing.info[propertyID][1].z + propertyHeight)
    else
        spawnBuildingLocation = vector3(Housing.info[propertyID][1].x,Housing.info[propertyID][1].y,Housing.info[propertyID][1].z + propertyHeight)
    end

    return spawnBuildingLocation
end

function spawnBuilding(propertyID,spawnBuildingLocation)

    local model = Housing.info[propertyID].model
    local isBuiltCoords,objects = exports["np-build"]:getModule("func").buildRoom(model,spawnBuildingLocation,false,nil,nil,true)
    
    if isBuiltCoords then
        SetEntityInvincible(PlayerPedId(), false)
        FreezeEntityPosition(PlayerPedId(),false)

        Housing.currentlyInsideBuilding = true
    else
        Housing.currentHousingInteractions = nil
        Housing.currentlyInsideBuilding = false
        Housing.currentAccess = nil
    end
end

local testPoints = nil
local testBox = nil
function runCheck(propertyID,spawnBuildingLocation)

    if(IsPedSwimming(PlayerPedId()) or IsPedSwimmingUnderWater(PlayerPedId()) ) then
        return true
    end


    local shell, modelDim = exports["np-build"]:getModule("func").GetShell(Housing.info[propertyID].model)
    local boxPoints = {
        [1] = spawnBuildingLocation.xy + vector2(modelDim.min.x, modelDim.min.y), -- Bottom Left ? 
        [2] = spawnBuildingLocation.xy + vector2(modelDim.max.x, modelDim.min.y), -- Top Left ?
        [3] = spawnBuildingLocation.xy + vector2(modelDim.max.x, modelDim.max.y), -- Top Right
        [4] = spawnBuildingLocation.xy + vector2(modelDim.min.x, modelDim.max.y), -- Bottom right ?
    }

    testBox = boxPoints
    for i=1, #boxPoints do
        local point = boxPoints[i]

        
        local retvalA, heightA = TestVerticalProbeAgainstAllWater(point.x, point.y, spawnBuildingLocation.z + 20 + modelDim.min.z, 32, -1)
        local retvalB, heightB = TestVerticalProbeAgainstAllWater(point.x, point.y, spawnBuildingLocation.z + 20 +  modelDim.max.z, 32, -1)
        if retvalA == 1 or heightA >= 1 then return true end
        if retvalB == 1 or heightB >= 1 then return true end
    end

    local divisions = 20

    -- let the shit math begin
    local ColA = calcColPoints(boxPoints[2],boxPoints[3],divisions)
    local RowA = calcRowPoints(boxPoints[1],boxPoints[2],divisions)

    local index = 1
    testPoints = {}
    for i=1, divisions do
        for j=1, divisions do
            testPoints[index] = {}
            testPoints[index].x = RowA[i].x
            testPoints[index].y = ColA[j].y

            index = index + 1
        end
    end


    for i=1, #testPoints do
        local point = testPoints[i]
        local retvalA, heightA = TestVerticalProbeAgainstAllWater(point.x, point.y, spawnBuildingLocation.z + 20 + modelDim.min.z, 32, -1)
        local retvalB, heightB = TestVerticalProbeAgainstAllWater(point.x, point.y, spawnBuildingLocation.z + 20 + modelDim.max.z, 32, -1)
        if retvalA == 1 or heightA >= 1 then return true end
        if retvalB == 1 or heightB >= 1 then return true end
    end

    --runDebug(spawnBuildingLocation.z)
    return false
    

end

function calcColPoints(vec1,vec2,sections)
    local Points = {}

    for i=1, sections do
        Points[i] = {}
        Points[i].y = vec1.y * (1 - (i / sections)) + vec2.y * (i / sections);
    end

    return Points
end

function calcRowPoints(vec1,vec2,sections)
    local Points = {}

    for i=1, sections do
        Points[i] = {x = 0.0}
        Points[i].x = vec1.x * (1 - (i / sections)) + vec2.x * (i / sections);
    end

    return Points
end

function runDebug(Zpos)

    Citizen.CreateThread(function()
        while testPoints ~= nil do
            for i=1, #testPoints do
                local point = testPoints[i]
                DrawLine(point.x, point.y, Zpos - 10, point.x, point.y, Zpos + 10, 255, 0, 0, 164)
            end

            for i=1, #testBox do
                local point = testBox[i]
                DrawLine(point.x, point.y, -30.0, point.x, point.y, 160.0, 0, 255, 0, 164)
            end
            Wait(2)
        end
    end)
end

--runThroughBuildingWaterCheck()

-- RegisterCommand('watertest', function()
--     local forward = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
--     local waterTest = TestVerticalProbeAgainstAllWater(forward.x, forward.y, forward.z, 32, -1)
--     print(waterTest)
-- end, false)