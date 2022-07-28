local BlipHandlers = {}

Citizen.CreateThread(function()
	while true do
		if NetworkIsSessionStarted() then
			DecorRegister("EmergencyType", 3)
			DecorSetInt(PlayerPedId(), "EmergencyType", 0)
			return
		end
	end
end)

--[[
	Emergency Type Decor:
		1 = police
		2 = ems
]]

function IsDOC(pCallSign)
	if pCallSign and type(pCallSign) ~= "table" then
		local sign = string.sub(pCallSign, 1, 1)
		return sign == '7'
	else
		return false
	end
end

function getPDBlipColors (pDepartment)
	if not pDepartment then return 3 end
	local departments = {
		["lspd"] = 3,
		["bcso"] = 5,
		["sdso"] = 31,
		["rangers"] = 2,
		["troopers"] = 12,
		["dispatch"] = 8,
		["scu"] = 40,
		["hvtu"] = 76,
		["k9"] = 27,
		["sru"] = 0,
	}
	if departments[pDepartment] then
		return departments[pDepartment]
	end
	return 3
end

function GetBlipSettings(pJobId, pCallSign, pDepartment, pSprite)
	local settings = {}

	settings.short = true
	settings.category = 7
	
	if pSprite then
		settings.sprite = pSprite
	end

	if pJobId == 'police' then
		settings.color = getPDBlipColors(pDepartment)
		settings.heading =  true
		settings.text = ('Officer | %s'):format(pCallSign)
	elseif pJobId == 'doc' then
		settings.color = 2
		settings.heading =  true
		settings.text = ('DOC | %s'):format(pCallSign)
	elseif pJobId == 'ems' then
		settings.color = 23
		settings.heading =  true
		settings.text = ('Paramedic | %s'):format(pCallSign)
	elseif pJobId == 'custom' then
		local textName = pCallSign.text
		local color = pCallSign.color
		local callsign = pCallSign.callsign
		settings.color = color
		settings.heading =  true
		settings.text = ('%s | %s'):format(textName, callsign)
	end

	return settings
end

function CreateBlipHandler(pServerId, pJob, pCallSign, pDepartment, pSprite)
	local serverId = pServerId
	local callsign = pCallSign
	local job = pJob

	if job == 'police' and IsDOC(callsign) then
		job = 'doc'
	end

	local settings = GetBlipSettings(job, callsign, pDepartment, pSprite)

	local handler = EntityBlip:new('player', serverId, settings)

	handler:enable(true)

	BlipHandlers[serverId] = handler
end

function DeleteBlipHandler(pServerId)
	BlipHandlers[pServerId]:disable()
	BlipHandlers[pServerId] = nil
end

RegisterNetEvent('e-blips:setHandlers')
AddEventHandler('e-blips:setHandlers', function(pHandlers)
	local serverId = GetPlayerServerId(PlayerId())
	local myjob = exports["isPed"]:isPed("myjob")
	for _, pData in pairs(pHandlers) do
		if pData and pData.netId ~= serverId and pData.jobs[myjob] then
			CreateBlipHandler(pData.netId, pData.job, pData.callsign, pData.department, pData.sprite)
		end
	end
end)

RegisterNetEvent('e-blips:deleteHandlers')
AddEventHandler('e-blips:deleteHandlers', function()
	for serverId, pData in pairs(BlipHandlers) do
		if pData then
			DeleteBlipHandler(serverId)
		end
	end

	BlipHandlers = {}
end)

RegisterNetEvent('e-blips:addHandler')
AddEventHandler('e-blips:addHandler', function(pData)
	if pData then
		CreateBlipHandler(pData.netId, pData.job, pData.callsign, pData.department, pData.sprite)
	end
end)

RegisterNetEvent('e-blips:client:updateBlipHandlerSprite')
AddEventHandler('e-blips:client:updateBlipHandlerSprite', function(pServerId, pSprite, pDept, pJob, pCallSign)
	if BlipHandlers[pServerId] == nil then return end

	DeleteBlipHandler(pServerId)

	Wait(500)

	CreateBlipHandler(pServerId, pJob, pCallSign, pDept, pSprite)
end)

RegisterNetEvent('e-blips:removeHandler')
AddEventHandler('e-blips:removeHandler', function(pServerId)
	if BlipHandlers[pServerId] then
		DeleteBlipHandler(pServerId)
	end
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
	if job == "police" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 1)
	elseif job == "ems" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 2)
	elseif job == "doc" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 3)
	else
		DecorSetInt(PlayerPedId(), "EmergencyType", 0)
	end

	TriggerServerEvent('e-blips:updateBlips', job, name)
end)

RegisterNetEvent("e-blips:updateAfterPedChange")
AddEventHandler("e-blips:updateAfterPedChange", function(job)
	if job == "police" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 1)
	elseif job == "ems" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 2)
	elseif job == "doc" then
		DecorSetInt(PlayerPedId(), "EmergencyType", 3)
	else
		DecorSetInt(PlayerPedId(), "EmergencyType", 0)
	end

	TriggerServerEvent('e-blips:updateBlips', job)
end)

RegisterNetEvent('np:infinity:player:coords')
AddEventHandler('np:infinity:player:coords', function (pCoords)
	for serverId, handler in pairs(BlipHandlers) do
		if handler and handler.mode == 'coords' and pCoords[serverId] then
			handler:onUpdateCoords(pCoords[serverId])

			if handler:entityExistLocally() then
				handler:onModeChange('entity')
			end
		end
	end
end)

RegisterNetEvent('onPlayerJoining')
AddEventHandler('onPlayerJoining', function(player)
	if BlipHandlers[player] then
		BlipHandlers[player]['inScope'] = true
		Citizen.Wait(1000)
		if BlipHandlers[player]['inScope'] then
			BlipHandlers[player]:onModeChange('entity')
		end
	end
end)

RegisterNetEvent('onPlayerDropped')
AddEventHandler('onPlayerDropped', function(player)
	if BlipHandlers[player] then
		BlipHandlers[player]['inScope'] = false
		BlipHandlers[player]:onModeChange('coords')
	end
end)

AddEventHandler('baseevents:enteredVehicle', function (pVehicle, pSeat, pName, pClass, pModel)
	if pClass ~= 15 or pSeat ~= -1 and pSeat ~= 0 then return end

	local serverId = GetPlayerServerId(PlayerId())
	TriggerServerEvent('e-blips:updateBlipHandlerSprite', serverId, 43)
end)

AddEventHandler('baseevents:leftVehicle', function (pVehicle, pSeat, pName, pClass, pModel)
	if pClass ~= 15 or pSeat ~= -1 and pSeat ~= 0 then return end

	local serverId = GetPlayerServerId(PlayerId())
	TriggerServerEvent('e-blips:updateBlipHandlerSprite', serverId, 1)
end)

local function setDecor()
	local type = 0

	TriggerEvent("nowIsCop", function(_isCop)
		TriggerEvent("nowIsEMS", function(_isMedic)
			type = _isCop and 1 or 0
			type = (type == 0 and _isMedic) and 2 or type
			DecorSetInt(PlayerPedId(), "EmergencyType", type)
		end)
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if not DecorExistOn(PlayerPedId(), "EmergencyType") then setDecor() end -- Decors don't stick with players when their ped changes, currently only works with police.
	end
end)
