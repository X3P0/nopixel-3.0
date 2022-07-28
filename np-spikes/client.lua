-- spike use function

RegisterNetEvent('c_setSpike')
AddEventHandler('c_setSpike', function()
	TriggerEvent("animation:PlayAnimation","layspike")
	Citizen.Wait(500)
	local h = GetEntityHeading(PlayerPedId())
	local positions = {}
	for i = 1, 3 do
		positions[i] = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, -1.5+(3.5*i), 0.15)
	end
	TriggerServerEvent("police:spikesLocation",positions,h)
	TriggerEvent("DoLongHudText","You have placed down a spike strip.",1)
end)


-- laying out objects

function loadSpikeModel(spike)
    RequestModel(spike)
    while not HasModelLoaded(spike) do
      Citizen.Wait(1)
    end
end

RegisterNetEvent('addSpikes')
AddEventHandler('addSpikes', function(positions,h)
	local spike = `P_ld_stinger_s`
	loadSpikeModel(spike)
	for i = 1, 3 do
		local spikeObj = CreateObject(spike,positions[i].x,positions[i].y,positions[i].z, 0, 1, 1) -- x+1
		TriggerEvent("spikes:watch",positions[i].x,positions[i].y,positions[i].z,spikeObj)
		PlaceObjectOnGroundProperly(spikeObj)
		SetEntityHeading(spikeObj,h)
		FreezeEntityPosition(spikeObj,true)
	end
end)

-- watching each object then deleting after 5s

RegisterNetEvent('spikes:watch')
AddEventHandler('spikes:watch', function(x,y,z,obj)
	local spike = `P_ld_stinger_s`
	local pos = vector3(x,y,z)
	local ped = PlayerPedId()
	local doLoop = true
	Citizen.CreateThread(function()
		Wait(5000)
		doLoop = false
	end)
	while doLoop do
		Wait(0)
		local veh = GetVehiclePedIsIn(ped, false)
		local driverPed = GetPedInVehicleSeat(veh, -1)
		local speed = math.ceil(GetEntitySpeed(veh) * 2.236936)
		if driverPed and speed > 25.0 then
			local d1,d2 = GetModelDimensions(GetEntityModel(veh))
			local leftfront = GetOffsetFromEntityInWorldCoords(veh, d1["x"]-0.25,0.25,0.0)
			local rightfront = GetOffsetFromEntityInWorldCoords(veh, d2["x"]+0.25,0.25,0.0)
			local leftback = GetOffsetFromEntityInWorldCoords(veh, d1["x"]-0.25,-0.85,0.0)
			local rightback = GetOffsetFromEntityInWorldCoords(veh, d2["x"]+0.25,-0.85,0.0)
			local skip = false
			if #(pos - leftfront) < 2.0 and not IsVehicleTyreBurst(veh,0,true) then
				if IsEntityTouchingEntity(veh,GetClosestObjectOfType(x,y,z,5.0,spike,0,0,0)) then
					SetVehicleTyreBurst(veh, 0, true, 1000.0)
				end
			end
			if #(pos - rightfront) < 2.0 and not IsVehicleTyreBurst(veh,1,true) then
				if IsEntityTouchingEntity(veh,GetClosestObjectOfType(x,y,z,5.0,spike,0,0,0)) then
					SetVehicleTyreBurst(veh, 1, true, 1000.0)
				end
			end
			if #(pos - leftback) < 2.0 and not IsVehicleTyreBurst(veh,4,true) then
				if IsEntityTouchingEntity(veh,GetClosestObjectOfType(x,y,z,5.0,spike,0,0,0)) then
					SetVehicleTyreBurst(veh, 2, true, 1000.0)
					SetVehicleTyreBurst(veh, 4, true, 1000.0)	
				end		      		
			end
			if #(pos - rightback) < 2.0 and not IsVehicleTyreBurst(veh,5,true) then
				if IsEntityTouchingEntity(veh,GetClosestObjectOfType(x,y,z,5.0,spike,0,0,0)) then
					SetVehicleTyreBurst(veh, 3, true, 1000.0)
					SetVehicleTyreBurst(veh, 5, true, 1000.0) 
				end 		
			end
		end
	end
	DeleteObject(obj)
	SetEntityAsNoLongerNeeded(obj)	
end)

