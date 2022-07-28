Spawn.defaultSpawns = {
	[1] =  { ["pos"] = vector4(272.16, 185.44, 104.67, 320.57), ['info'] = ' Vinewood Blvd Taxi Stand'},
	[2] =  { ["pos"] = vector4(-1833.96, -1223.5, 13.02, 310.63), ['info'] = ' The Boardwalk'},
	[3] =  { ["pos"] = vector4(145.62, 6563.19, 32.0, 42.83), ['info'] = ' Paleto Gas Station'},
	[4] =  { ["pos"] = vector4(-214.24, 6178.87, 31.17, 40.11), ['info'] = ' Paleto Bus Stop'},
	[5] =  { ["pos"] = vector4(1122.11, 2667.24, 38.04, 180.39), ['info'] = ' Harmony Motel'},
	[6] =  { ["pos"] = vector4(453.29, -662.23, 28.01, 5.73), ['info'] = ' LS Bus Station'},
	[7] =  { ["pos"] = vector4(-1266.53, 273.86, 64.66, 28.52), ['info'] = ' The Richman Hotel'},
	[8] =  { ["pos"] = vector4(1642.29, 3581.19, 36.5, 265.37), ['info'] = 'Sandy Shores Motel'}
}

Spawn.motel = {
	[1] = { ["pos"] = vector4(-270.13,-957.28,31.23, 166.11), ['info'] = ' Apartments 1'},
	[2] = { ["pos"] = vector4(-1236.27,-860.84,12.91,213.56), ['info'] = ' Apartments 2'},
	[3] = { ["pos"] = vector4(173.96, -631.29, 47.08, 303.12), ['info'] = ' Apartments 3'}
}

Spawn.Crash = nil
Spawn.hotelRooms = {}
Spawn.businessSpawnsInfo = {}

Spawn.housingCoords = nil
Spawn.isNew = false

Spawn.tempHousing = {}
Spawn.defaultApartmentSpawn = {}

RegisterNetEvent('spawn:clientSpawnData')
AddEventHandler('spawn:clientSpawnData', function(spawnData)

	Login.Selected = false
	Login.CurrentPedInfo = nil
	Login.CurrentPed = nil
	Login.CreatedPeds = {}

	Login.SetTestCam()
	DoScreenFadeIn(1)

	--TriggerServerEvent("kGetWeather")

	if spawnData.hospital.illness == "dead" or spawnData.hospital.illness == "icu" then
		return
	end

	Spawn.defaultApartmentSpawn = spawnData.motelRoom

	if spawnData.overwrites ~= nil then
		if not Spawn.isNew and spawnData.isNew then Spawn.isNew = true end
		if spawnData.overwrites == "jail" or spawnData.overwrites == "maxsec" or spawnData.overwrites == "rehab" then
			Spawn.overwriteSpawn(spawnData.overwrites)
		elseif spawnData.overwrites == "new" then
			Spawn.isNew = true
			Spawn.selectedSpawn(' Apartments 1')
		end
		return
	end

	local spawnInApartmentsOnly = (exports["np-config"]:GetMiscConfig("spawn.apartments.only") or false)
	if spawnInApartmentsOnly then
		Spawn.selectedSpawn(' Apartments 1')
		return
	end

	if spawnData.icuRooms and #spawnData.icuRooms > 0 then
		local roomData = exports['np-healthcare']:getICURoomSpawn(spawnData.icuRooms[1])
		Spawn.overwriteSpawn("icu", roomData)
		return
	end

	SendNUIMessage({
		showSpawnMenu = true,
	})

	if Spawn.housingCoords == nil then
		Spawn.housingCoords = exports["np-housing"]:retriveHousingTable();
	end

	local cid = exports["isPed"]:isPed("cid")
	Spawn.businessSpawns = RPC.execute('np-spawn:getBusinessSpawns', cid)

	local currentSpawns = Spawn.shallowCopy(Spawn.defaultSpawns)
	local currentCheckList = {}

	currentSpawns[#currentSpawns + 1] = Spawn.getCrash(spawnData.crash)
	currentSpawns[#currentSpawns + 1] = Spawn.getDevSpawn()
	currentSpawns[#currentSpawns + 1] = Spawn.getRoosterSpawn()
	currentSpawns[#currentSpawns + 1] = Spawn.motel[spawnData.motelRoom.roomType]
	Spawn.tempHousing = {}

	for k,v in pairs(spawnData.houses) do
		local data = Spawn.createDefaultData(k)
		currentSpawns[#currentSpawns + 1] = data
		Spawn.tempHousing[#Spawn.tempHousing+1] = data
		currentCheckList[k] = true
	end

	for k,v in pairs(spawnData.keys) do
		if not currentCheckList[k] then
			local data = Spawn.createDefaultData(k)
			currentSpawns[#currentSpawns + 1] = data
			Spawn.tempHousing[#Spawn.tempHousing+1] = data
		end
	end

	for k, roomId in pairs(spawnData.hotelRooms) do
    local room = Spawn.getHotelRoom(roomId)
    if room then
      currentSpawns[#currentSpawns + 1] = Spawn.getHotelRoom(roomId)
    end
	end

	for k, spawnInfo in pairs(Spawn.businessSpawns) do
		currentSpawns[#currentSpawns + 1] = spawnInfo
		Spawn.businessSpawnsInfo[spawnInfo.info] = spawnInfo
	end

	-- fuck json , makes me only send the info of the table :( , json does not support vector4 kek
	local infoTable = {}
	for i=1,#currentSpawns do
		local spawn = currentSpawns[i]
		infoTable[i] = {["info"] = spawn.info,["posX"] = spawn.pos.x,["posY"] = spawn.pos.y,["checkS"] = i}
	end


	local fav = exports["storage"]:tryGet("string","npfavorite")
	if fav == nil then fav = "" end

	local found = false
	for k,v in pairs(currentSpawns) do
		if fav == v.info then found = true end
	end

	if not found then fav = "" end

	Wait(200)
	SetNuiFocus(true,true)
	SendNUIMessage({
		updateSpawnMenu = true,
		spawns = infoTable,
		fav = fav
	})

	Spawn.housingCoords = nil
end)

function round(number, decimals)
  local power = 10^decimals
  return math.floor(number * power) / power
end

function Login.SetTestCam()
	--LoginSafe.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	local camCoords = {-3968.85, 2015.93,502.22 }
	SetCamRot(LoginSafe.Cam, -90.0, 0.0, 250.0, 2)
	SetCamCoord(LoginSafe.Cam, camCoords[1], camCoords[2], camCoords[3])
	StopCamShaking(LoginSafe.Cam, true)
	SetCamFov(LoginSafe.Cam, 50.0)
	SetCamActive(LoginSafe.Cam, true)
	RenderScriptCams(true, false, 0, true, true)
end

function Spawn.getCrash(exitData)
	local spawn = nil
	if exitData then
		local vec3 = vector3(exitData.position.x,exitData.position.y,exitData.position.z)
		local newPos = vector4(exitData.position.x,exitData.position.y,exitData.position.z,0.0)
		local canUse = true

		if #(vec3-vector3(0.0,0.0,0.0)) < 10 then canUse = false end
		-- if vec3.z < 0.0 then canUse = false end
		-- if GetInteriorAtCoords(vec3) ~= 0 then canUse = false end

		if canUse then
			spawn = { ["pos"] = newPos, ['info'] = 'Last Location'}
			Spawn.Crash = exitData
		end
	end

	return spawn
end

function Spawn.getHotelRoom(roomId)
  local spawn = exports["np-business"]:getHotelRoomSpawn(roomId)
  if not spawn then
    return nil
  end
  local pos = vector4(spawn.position.x, spawn.position.y, spawn.position.z, spawn.position.h);
  Spawn.hotelRooms[spawn.name] = pos
	return {
    ["pos"] = pos,
    ["info"] = spawn.name
  }
end

function Spawn.getDevSpawn()
	local spawn = nil


	local devspawn = exports["storage"]:tryGet("vector4","devspawn")
	if devspawn then
		spawn = { ["pos"] = devspawn, ['info'] = 'Dev Spawn'}
	end

	return spawn
end

function Spawn.getRoosterSpawn()
	local spawn = nil


	local rooster = exports["isPed"]:GroupRank("rooster_academy")
	if rooster >= 2 then
		spawn = { ["pos"] = vector4(-172.83,331.17,93.76,266.08), ['info'] = ' Rooster Cab'}
	end

	return spawn
end

function Spawn.createDefaultData(housing_id)
	local defaultData = nil

	if Spawn.housingCoords == nil or Spawn.housingCoords[housing_id] == nil then return end
	if Spawn.housingCoords[housing_id].assigned then return end

	local housing = Spawn.housingCoords[housing_id]
	defaultData = {["pos"] = vector4(housing[1]),["info"] = housing.Street}

	return defaultData
end

local function isCasinoSpawn(str)
	return string.find(str, "Casino Room") ~= nil
end
local function isRRSpawn(str)
	return string.find(str, "Roosters Rest Room") ~= nil
end

function Spawn.selectedSpawn(spawnInfo)

	if spawnInfo == nil or spawnInfo == "" or type(spawnInfo) ~= "string" then
		return
	end

	Login.DeleteCamera()
	SetNuiFocus(false, false)
	SetNuiFocus(false, false)
	TriggerEvent("inSpawn", false)
	local apartment = Spawn.obtainApartmentType(spawnInfo)

	local cid = exports["isPed"]:isPed("cid")
	local config = exports["np-config"]:GetModuleConfig("main")

	local persistentLastLocation = config["persistentLastLocation"]

	if spawnInfo == 'Last Location' and (persistentLastLocation or Spawn.Crash) then
		local data = Spawn.Crash
		FreezeEntityPosition(PlayerPedId(), true)
		SetEntityCoordsNoOffset(PlayerPedId(), data.position.x, data.position.y, data.position.z)

		DoScreenFadeOut(2)

		Wait(200)

		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
			Wait(0)
		end
		FreezeEntityPosition(PlayerPedId(), false)

		DoScreenFadeIn(2500)
		Login.characterSpawned()
		local spawnInApart = false
		if data.building then
			local genType = data.building.posGen
			if type(genType) == 'vector3' or type(genType) == 'table' and data.building.houseId then
				-- assume we're in a house
				TriggerEvent("housing:playerSpawned", nil, data.building.houseId)
			else
				spawnInApart = true
			end
		else
			TriggerEvent("np-spawn:characterSpawned", cid)
		end
		TriggerServerEvent("apartment:serverApartmentSpawn", Spawn.defaultApartmentSpawn.roomType, false, nil, spawnInApart)
		Spawn.tempHousing  = {}
		return
	end

	if apartment then
		DoScreenFadeOut(2)
		TriggerServerEvent("apartment:serverApartmentSpawn",apartment,Spawn.isNew,nil,true)
	else
		local pos = Spawn.obtainWorldSpawnPos(spawnInfo)
		if pos then
			SetEntityCoords(PlayerPedId(),pos.x,pos.y,pos.z)
			SetEntityHeading(PlayerPedId(),pos.w)

			if isCasinoSpawn(spawnInfo) then
				doCamera(937.53,-8.14,119.88)
			elseif isRRSpawn(spawnInfo) then
				doCamera(-149.15,290.93,98.59)
			else
				doCamera(pos.x,pos.y,pos.z)
			end
			DoScreenFadeOut(2)

			Login.DeleteCamera()

			Wait(200)

			TriggerServerEvent("apartment:serverApartmentSpawn",Spawn.defaultApartmentSpawn.roomType,Spawn.isNew,nil,false)
			DoScreenFadeIn(2500)
			TriggerEvent("np-spawn:characterSpawned", cid)
		else

			local pos = Spawn.obtainHousingPos(spawnInfo)
			if pos then

				doCamera(pos.x,pos.y,pos.z)
				DoScreenFadeOut(2)

				Login.DeleteCamera()
				SetEntityCoords(PlayerPedId(),pos.x,pos.y,pos.z)
				SetEntityHeading(PlayerPedId(),pos.w)
				Wait(200)

				TriggerServerEvent("apartment:serverApartmentSpawn",Spawn.defaultApartmentSpawn.roomType,Spawn.isNew,nil,false)
				DoScreenFadeIn(2500)
				Login.characterSpawned()
				TriggerEvent("housing:playerSpawned",spawnInfo)

			end
		end
 	end

	isNear = false
 	Spawn.tempHousing  = {}
end


function Spawn.overwriteSpawn(overwrite, data)
	local cid = exports["isPed"]:isPed("cid")

	local pos = vector4(1802.51,2607.19,46.01,93.0) -- default prison

	if overwrite == "maxsec" then
		pos = vector4(1690.75,2593.14,45.61,178.75)
	elseif overwrite == "rehab" then
		pos = vector4(-1475.86,884.47,182.93,93.0)
	end

	if overwrite == "icu" then
		pos = vector4(357.14,-608.66,71.19,359.11)
		SetEntityCoords(PlayerPedId(), data.coords.x, data.coords.y, data.coords.z)
		RPC.execute('np-healthcare:icu:rpc:spawn', cid)
	end

	TriggerServerEvent("apartment:serverApartmentSpawn",Spawn.defaultApartmentSpawn.roomType,Spawn.isNew,nil,false)

	Login.DeleteCamera()
	SetNuiFocus(false,false)
 	doCamera(pos.x,pos.y,pos.z)
 	Wait(300)
	DoScreenFadeOut(2)
	Login.DeleteCamera()

	-- TriggerServerEvent("jail:characterFullySpawend")
	if overwrite == "jail" then
		TriggerEvent("np-jail:beginJail", false)
	end

	if overwrite == "rehab" then
		TriggerEvent('beginJailRehab', true)
	end

	Wait(200)

	DoScreenFadeIn(2500)
	TriggerEvent("np-spawn:characterSpawned", cid)
end

cam = 0
function doCamera(x,y,z)

	DoScreenFadeOut(1)
	if(not DoesCamExist(cam)) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	local camAngle = -90.0
	local startTime = GetGameTimer()
	local timer = GetGameTimer()
	local running = true
	while running do
		Wait(0)
		local curTime = GetGameTimer()
		if curTime - startTime > 7500 then
			running = false
		end

		DoScreenFadeIn(1000)

		local delta = curTime - timer
		local totalTime = curTime - startTime
		timer = curTime
		i = i - ((3.0 * (i / 3200)) * delta)
		if i < 1 then i = 1 end

		SetCamCoord(cam, x, y, z + i)

		if i < 90.0 then
			camAngle = math.min(i * -1, -5.0)
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
	end
	DestroyCam(cam)
end
