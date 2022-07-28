local score = 0
local screenScore = 0
local tick
local idleTime
local driftTime
local mult = 0.05
local previous = 0
local total = 0
local curAlpha = 0

	
function round(number)
    number = tonumber(number)
    number = math.floor(number)
    
    if number < 0.01 then
        number = 0
    elseif number > 999999999 then
        number = 999999999
    end
    return number
end

function calculateBonus(previous)
    local points = previous
    local points = round(points)
    return points or 0
end

function math.precentage(a,b)
    return (a*100)/b
end

function angle(veh)
    if not veh then return false end
    local vx,vy,vz = table.unpack(GetEntityVelocity(veh))
    local modV = math.sqrt(vx*vx + vy*vy)        
    local rx,ry,rz = table.unpack(GetEntityRotation(veh,0))
    local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))    
    if GetEntitySpeed(veh)* 3.6 < 30 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 30 km/h    
    local cosX = (sn*vx + cs*vy)/modV
    if cosX > 0.966 or cosX < 0 then return 0,modV end
    return math.deg(math.acos(cosX))*0.5, modV
end

function DrawHudText(text,colour,coordsx,coordsy,scalex,scaley)
    SetTextFont(7)
    SetTextProportional(7)
    SetTextScale(scalex, scaley)
    local colourr,colourg,colourb,coloura = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, coloura)
    SetTextDropshadow(0, 0, 0, 0, coloura)
    SetTextEdge(1, 0, 0, 0, coloura)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(coordsx,coordsy)
end

RegisterNetEvent("StartDriftPad")
AddEventHandler("StartDriftPad", function()
    local active = true

	while active do
		Citizen.Wait(1)
		PlayerPed = PlayerPedId()
		tick = GetGameTimer()
		if not IsPedDeadOrDying(PlayerPed, 1) and GetVehiclePedIsUsing(PlayerPed) and GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPed), -1) == PlayerPed and IsVehicleOnAllWheels(GetVehiclePedIsUsing(PlayerPed)) and not IsPedInFlyingVehicle(PlayerPed) then
			PlayerVeh = GetVehiclePedIsIn(PlayerPed,false)
			local angle,velocity = angle(PlayerVeh)
			local tempBool = tick - (idleTime or 0) < 1850
			if not tempBool and score ~= 0 then
				previous = score
				previous = calculateBonus(previous)
				total = total+previous
				score = 0
			end
			if angle ~= 0 then
				if score == 0 then
					drifting = true
					driftTime = tick
				end
				if tempBool then
					score = score + math.floor(angle*velocity)*mult
				else
					score = math.floor(angle*velocity)*mult
				end
				screenScore = calculateBonus(score)
				
				idleTime = tick
			end
		end
		
		if tick - (idleTime or 0) < 3000 then
			if curAlpha < 255 and curAlpha+10 < 255 then
				curAlpha = curAlpha+10
			elseif curAlpha > 255 then
				curAlpha = 255
			elseif curAlpha == 255 then
				curAlpha = 255
			elseif curAlpha == 250 then
				curAlpha = 255
			end
		else
			if curAlpha > 0 and curAlpha-10 > 0 then
				curAlpha = curAlpha-10			elseif curAlpha < 0 then
				curAlpha = 0

			elseif curAlpha == 5 then
				curAlpha = 0
			end
		end

        local dst = GetDistanceBetweenCoords(961.79,-1800.474,20.35,GetEntityCoords(PlayerPed))
        if dst < 5 or dst > 350.0 then
            active = false
        end

		if not screenScore then screenScore = 0 end

		DrawHudText(string.format("\n+%s",tostring(screenScore)), {255,191,0,curAlpha},0.475,0.85,0.7,0.7)

	end
    TriggerEvent("DoLongHudText","Drift Score Disabled")
end)