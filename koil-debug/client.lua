
local dickheaddebug = false

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

RegisterNetEvent("hud:enabledebug")
AddEventHandler("hud:enabledebug",function()
	dickheaddebug = not dickheaddebug
    TriggerEvent("np-admin:currentDebug",dickheaddebug)
    if dickheaddebug then
        print("Debug: Enabled")
    else
        print("Debug: Disabled")
    end
end)

local inFreeze = false
local lowGrav = false

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function GetVehicle()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
           -- FreezeEntityPosition(ped, inFreeze)
           local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(ped))
	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Handle: ".. ped .." Name: " .. GetLabelText(vehname) .. " Modeln: " .. vehname .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Handle: ".. ped .." Name: " .. GetLabelText(vehname) .. " Modeln: " .. vehname .. " Model: " .. GetEntityModel(ped) .. " Engine: " .. GetVehicleEngineHealth(ped) .." Body: " .. GetVehicleBodyHealth(ped) .. ""  )
	    	end
            if lowGrav then
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+5.0)
            end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
            --FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " - " .. GetObjectFragmentDamageHealth(ped,true) .. " - " .. GetEntityHealth(ped,true) )
	    	end

            if lowGrav then
            	--ActivatePhysics(ped)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            	FreezeEntityPosition(ped, false)
            end
        end
        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end

-- 1166638144 -- ballas / north central

-- -1033021910 -- grove street - south central

-- 296331235 east side / mexican


function getNPC()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " HP: " .. GetEntityHealth(ped) .. " AP: " .. GetPedArmour(ped) )
	    	end

            FreezeEntityPosition(ped, inFreeze)
            if lowGrav then
            	SetPedToRagdoll(ped, 511, 511, 0, 0, 0, 0)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == PlayerPedId() then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

Citizen.CreateThread( function()
    local accel = 0
    local braking = 0
    local sixty = 0
    local hundred = 0
    local thirty = 0
    local hundredtwenty = 0
    local timestart = 0
    local timestartbraking = 0
    local airtime = 0
    local lastairtime = 0
    local airTimeStart = 0
    local vehicleAir = false
    local vehicleSuspensionStress = false
    local vehicleSuspensionStressRear = false
    local suspensionTimeStart = 0
    local suspensionTimeStartRear = 0
    local susTime = 0
    local susRearTime = 0
    
    while true do 
        
        Citizen.Wait(1)
        
        if dickheaddebug then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped,false)
            local pos = GetEntityCoords(ped)

            local forPos = GetOffsetFromEntityInWorldCoords(ped, 0, 1.0, 0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(ped, 0, -1.0, 0.0)
            local LPos = GetOffsetFromEntityInWorldCoords(ped, 1.0, 0.0, 0.0)
            local RPos = GetOffsetFromEntityInWorldCoords(ped, -1.0, 0.0, 0.0) 

            local forPos2 = GetOffsetFromEntityInWorldCoords(ped, 0, 2.0, 0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(ped, 0, -2.0, 0.0)
            local LPos2 = GetOffsetFromEntityInWorldCoords(ped, 2.0, 0.0, 0.0)
            local RPos2 = GetOffsetFromEntityInWorldCoords(ped, -2.0, 0.0, 0.0)    

            local x, y, z = table.unpack(GetEntityCoords(ped, true))
            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

            local zone = tostring(GetNameOfZone(x, y, z))
            if not zone then
                zone = "UNKNOWN"
            else
                zone = GetLabelText(zone)
            end

            drawTxt(0.8, 0.50, 0.4,0.4,0.30, "Heading: " .. GetEntityHeading(ped), 55, 155, 55, 255)
            drawTxt(0.8, 0.52, 0.4,0.4,0.30, "Coords: " .. pos, 55, 155, 55, 255)
            drawTxt(0.8, 0.54, 0.4,0.4,0.30, "Attached Ent: " .. GetEntityAttachedTo(ped), 55, 155, 55, 255)
            drawTxt(0.8, 0.56, 0.4,0.4,0.30, "Health: " .. GetEntityHealth(ped), 55, 155, 55, 255)
            drawTxt(0.8, 0.58, 0.4,0.4,0.30, "H a G: " .. GetEntityHeightAboveGround(ped), 55, 155, 55, 255)
            drawTxt(0.8, 0.60, 0.4,0.4,0.30, "Model: " .. GetEntityModel(ped), 55, 155, 55, 255)
            drawTxt(0.8, 0.62, 0.4,0.4,0.30, "Speed: " .. GetEntitySpeed(ped), 55, 155, 55, 255)
            drawTxt(0.8, 0.64, 0.4,0.4,0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
            drawTxt(0.8, 0.66, 0.4,0.4,0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)
            drawTxt(0.8, 0.68, 0.4,0.4,0.30, "Hood: " .. zone, 55, 155, 55, 255)



            -- car debugging
            -- s 8
            -- w 32


            if IsDisabledControlPressed(0, 37) then
                accel = 0
                braking = 0
                sixty = 0
                hundred = 0
                thirty = 0
                hundredtwenty = 0
                timestart = 0
                timestartbraking = 0
                airtime = 0
                lastairtime = 0
                airTimeStart = 0
                vehicleAir = false
                vehicleSuspensionStress = false
                vehicleSuspensionStressRear = false
                suspensionTimeStart = 0
                suspensionTimeStartRear = 0
                susTime = 0
                susRearTime = 0
                timestart = GetGameTimer()
            end

            if veh ~= 0 and veh ~= nil then
                local mph = math.ceil(GetEntitySpeed(ped) * 2.236936)

                if (IsControlJustPressed(0, 32) and not IsControlPressed(0, 18)) or IsControlJustReleased(0, 18) then
                    thirty = 0
                    sixty = 0
                    hundred = 0
                    hundredtwenty = 0
                    accel = 0
                    vehicleAir = false
                    timestart = GetGameTimer()
                end

                if IsControlPressed(0, 32) then
                    accel = GetGameTimer() - timestart
                end

                if IsControlJustPressed(0, 8) and GetEntitySpeed(ped) > 0.0 then
                    braking = 0
                    timestartbraking = GetGameTimer()
                end

                if IsControlPressed(0, 8) and GetEntitySpeed(ped) > 5 then
                    braking = GetGameTimer() - timestartbraking
                end     

                if mph == 30 and IsControlPressed(0, 32) and thirty == 0 then
                    thirty = accel / 1000
                end
                if mph == 60 and IsControlPressed(0, 32) and sixty == 0 then
                    sixty = accel / 1000
                end
                if mph == 90 and IsControlPressed(0, 32) and hundred == 0 then
                    hundred = accel / 1000
                end
                if mph == 100 and IsControlPressed(0, 32) and hundredtwenty == 0 then
                    hundredtwenty = accel / 1000
                end

                if IsEntityInAir(veh) and mph > 0 and not vehicleAir then
                    vehicleAir = true
                    airTimeStart = GetGameTimer()
                elseif vehicleAir and not IsEntityInAir(veh) and mph > 0 then
                    airtime = airtime + (GetGameTimer() - airTimeStart)
                    vehicleAir = false
                end

                local frontSusLost = (GetVehicleWheelSuspensionCompression(veh,0) < 0.1 or GetVehicleWheelSuspensionCompression(veh,1) < 0.1)
                local rearSusLost = (GetVehicleWheelSuspensionCompression(veh,2) < 0.1 or GetVehicleWheelSuspensionCompression(veh,3) < 0.1)

                if mph > 0 and not vehicleSuspensionStress and frontSusLost then
                    vehicleSuspensionStress = true
                    suspensionTimeStart = GetGameTimer()
                elseif vehicleSuspensionStress and mph > 0 and not frontSusLost then
                    susTime = susTime + (GetGameTimer() - suspensionTimeStart)
                    vehicleSuspensionStress = false
                end
            --  print(GetVehicleWheelSuspensionCompression(veh,0),GetVehicleWheelSuspensionCompression(veh,1),GetVehicleWheelSuspensionCompression(veh,2),GetVehicleWheelSuspensionCompression(veh,3))

                if mph > 0 and not vehicleSuspensionStressRear and rearSusLost then
                    vehicleSuspensionStressRear = true
                    suspensionTimeStartRear = GetGameTimer()
                elseif vehicleSuspensionStressRear and mph > 0 and not rearSusLost then
                    susRearTime = susRearTime + (GetGameTimer() - suspensionTimeStartRear)
                    vehicleSuspensionStressRear = false
                end
            end

            --airtime
            -- math.floor(GetVehicleWheelSuspensionCompression(veh,0)*100) / 100 .." | ".. math.floor(GetVehicleWheelSuspensionCompression(veh,1)*100) / 100 .." | ".. math.floor(GetVehicleWheelSuspensionCompression(veh,2)*100) / 100 .." | ".. math.floor(GetVehicleWheelSuspensionCompression(veh,3)*100) / 100

            drawTxt(1.0, 0.80, 0.4,0.4,0.80, "Time Accelerating: " .. accel / 1000, 55, 155, 55, 255)
            drawTxt(1.0, 0.82, 0.4,0.4,0.80, "Time Braking: " .. braking / 1000, 155, 55, 55, 255)

            drawTxt(1.0, 0.84, 0.4,0.4,0.80, "30mph: " .. thirty, 155, 155, 155, 255)
            drawTxt(1.0, 0.86, 0.4,0.4,0.80, "60mph: " .. sixty, 155, 155, 155, 255)
            drawTxt(1.0, 0.88, 0.4,0.4,0.80, "90mph: " .. hundred, 155, 155, 155, 255)
            drawTxt(1.0, 0.90, 0.4,0.4,0.80, "120mph: " .. hundredtwenty, 155, 155, 155, 255)

            drawTxt(1.0, 0.92, 0.4,0.4,0.80, "Air Time: " .. airtime/1000, 155, 155, 155, 255)
            drawTxt(1.0, 0.96, 0.4,0.4,0.80, "Suspension F Stress " .. susTime/1000 , 155, 155, 155, 255)
            drawTxt(1.0, 0.98, 0.4,0.4,0.80, "Suspension R Stress " .. susRearTime/1000 , 155, 155, 155, 255)
            

            -- car debugging end


            DrawLine(pos,forPos, 255,0,0,115)
            DrawLine(pos,backPos, 255,0,0,115)

            DrawLine(pos,LPos, 255,255,0,115)
            DrawLine(pos,RPos, 255,255,0,115)           

            DrawLine(forPos,forPos2, 255,0,255,115)
            DrawLine(backPos,backPos2, 255,0,255,115)

            DrawLine(LPos,LPos2, 255,255,255,115)
            DrawLine(RPos,RPos2, 255,255,255,115)     

            local nearped = getNPC()

            local veh = GetVehicle()

            local nearobj = GetObject()

            if IsControlJustReleased(0, 38) then
                if inFreeze then
                    inFreeze = false
                    TriggerEvent("DoShortHudText",'Freeze Disabled',3)          
                else
                    inFreeze = true             
                    TriggerEvent("DoShortHudText",'Freeze Enabled',3)               
                end
            end

            if IsControlJustReleased(0, 47) then
                if lowGrav then
                    lowGrav = false
                    TriggerEvent("DoShortHudText",'Low Grav Disabled',3)            
                else
                    lowGrav = true              
                    TriggerEvent("DoShortHudText",'Low Grav Enabled',3)                 
                end
            end

        else
            Citizen.Wait(5000)
        end
    end
end)