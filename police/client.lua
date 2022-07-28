local isInService = false
local existingVeh = nil
local isMedic = false
isCop = false
local isDoctor = false
local isDriver = false
local isNews = false
local currentCallSign = ""
local currentDepartment = "lspd"
local currentUIJob = "unemployed"

exports("getCurrentJob", function()
  return currentUIJob
end)


local rankService = 0
RegisterNetEvent('uiTest:setRank')
AddEventHandler('uiTest:setRank', function(result)
    rankService = result
end)

function vehCruise()
	if GetLastInputMethod(2) then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh then
			TriggerEvent("toggle:cruisecontrol")
		end
	end
end

function plyTackel()
	if GetLastInputMethod(2) then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if not isInVeh and GetEntitySpeed(PlayerPedId()) > 2.5 then
			TriggerEvent("np-police:tackle")
		end
	end
end

Citizen.CreateThread(function()
  exports["np-keybinds"]:registerKeyMapping("", "Vehicle", "Cruise Control", "+vehCruise", "-vehCruise", "X")
  RegisterCommand('+vehCruise', vehCruise, false)
  RegisterCommand('-vehCruise', function() end, false)

  exports["np-keybinds"]:registerKeyMapping("", "Player", "Tackle", "+plyTackel", "-plyTackel")
  RegisterCommand('+plyTackel', plyTackel, false)
  RegisterCommand('-plyTackel', function() end, false)
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
	if isMedic and job ~= "ems" then isMedic = false isInService = false end
	if isCop and job ~= "police" or job ~= "doc" then isCop = false isInService = false end
	if isNews and job ~= "news" then isNews = false isInService = false end
	if job == "police" then isCop = true TriggerServerEvent('police:getRank',"police") isInService = true end
	if job == "doc" then isCop = true TriggerServerEvent('police:getRank',"doc") isInService = true end
	if job == "ems" then isMedic = true TriggerServerEvent('police:getRank',"ems") isInService = true end
	if job == "doctor" then isDoctor = true TriggerServerEvent('police:getRank',"doctor") isInService = true end
	if job == "driving instructor" then isDriver = true TriggerServerEvent('police:getRank',"driving instructor") end
	if job == "news" then isNews = true isInService = false end
  currentUIJob = job
end)

RegisterNetEvent("fire:stopClientFires")
AddEventHandler("fire:stopClientFires", function(x,y,z,rad)
	if #(vector3(x,y,z) - GetEntityCoords(PlayerPedId())) < 100 then
		StopFireInRange(x,y,z,rad)
	end
end)


local inmenus = false

RegisterNetEvent('inmenu')
AddEventHandler('inmenu', function(change)
	inmenus = change
end)


TimerEnabled = false



function policeCuff()
	if not inmenus and isCop and not IsPauseMenuActive() then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh then
			TriggerEvent("platecheck:frontradar")
		else
			if not IsControlPressed(0,19) then
				TriggerEvent("np-police:cuffs:attempt",false)
			end
		end
	end
end

function medicRevive()
	if not inmenus and (isMedic or isDoctor or isDoc) and not IsPauseMenuActive() then
		TriggerEvent("revive")
	end
end

function emsHeal()
	if not inmenus and (isMedic or isDoctor or isDoc) and not IsPauseMenuActive() then
		TriggerEvent("ems:heal")
	end
end

function policeEscort()
	if not inmenus and (isMedic or isDoctor or isCop) and not IsPauseMenuActive() then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh and isCop then
			TriggerEvent("startSpeedo")
		else
			TriggerEvent("np-police:drag:attempt") 
		end
	end
end

function policeSeat()
	if not inmenus and (isMedic or isCop) and not IsPauseMenuActive() then
		TriggerEvent("np-police:vehicle:seat")
	end
end

function policeUnCuff()
	if not inmenus and isCop and not IsPauseMenuActive() then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh then
			TriggerEvent("platecheck:rearradar")
		else
			TriggerEvent("np-police:cuffs:uncuff")
		end
	end
end

function policeSoft()
	if not inmenus and isCop and not IsPauseMenuActive() then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if not isInVeh then
			TriggerEvent("np-police:cuffs:attemptSoft")
		end
	end
end

Citizen.CreateThread( function()
	RegisterCommand('+policeCuff', policeCuff, false)
	RegisterCommand('-policeCuff', function() end, false)
	exports["np-keybinds"]:registerKeyMapping("", "Gov", "Cuff / Radar Front", "+policeCuff", "-policeCuff", "UP")

	RegisterCommand('+medicRevive', medicRevive, false)
	RegisterCommand('-medicRevive', function() end, false)
	exports["np-keybinds"]:registerKeyMapping("", "Gov", "EMS Revive", "+medicRevive", "-medicRevive")

	RegisterCommand('+emsHeal', emsHeal, false)
	RegisterCommand('-emsHeal', function() end, false)
	exports["np-keybinds"]:registerKeyMapping("", "Gov", "EMS Heal", "+emsHeal", "-emsHeal")

	RegisterCommand('+policeEscort', policeEscort, false)
	RegisterCommand('-policeEscort', function() end, false)
	exports["np-keybinds"]:registerKeyMapping("", "Gov", "Escort / Speedo", "+policeEscort", "-policeEscort", "LEFT")

	RegisterCommand('+policeSeat', policeSeat, false)
	RegisterCommand('-policeSeat', function() end, false)
	exports["np-keybinds"]:registerKeyMapping("", "Gov", "Force into Vehicle", "+policeSeat", "-policeSeat", "RIGHT")

	RegisterCommand('+policeUnCuff', policeUnCuff, false)
	RegisterCommand('-policeUnCuff', function() end, false)
	exports["np-keybinds"]:registerKeyMapping("", "Gov", "UnCuff / Radar Rear", "+policeUnCuff", "-policeUnCuff", "DOWN")

	RegisterCommand('+policeSoft', policeSoft, false)
	RegisterCommand('-policeSoft', function() end, false)
	exports["np-keybinds"]:registerKeyMapping("", "Gov", "Soft Cuff", "+policeSoft", "-policeSoft")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if disabledWeapons then
			DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
			DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
		end
	end
end)

local hasBeenOnFire = 0
local ShouldBeOnFire = 0
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(600)
		local player = PlayerPedId()
		local playerPos = GetEntityCoords(player)
		local isInVeh = IsPedInVehicle(player,GetVehiclePedIsIn(player, false),false)
		if not isInVeh then ShouldBeOnFire = 0 end
		if GetNumberOfFiresInRange(playerPos,1.7) > 1 and hasBeenOnFire < 4 then

			local b, closestFire = GetClosestFirePos(playerPos)
			local zDist = math.abs(closestFire.z - playerPos.z)

			if zDist <= 1.0 then
				if isInVeh then
					ShouldBeOnFire = ShouldBeOnFire + 1
					if ShouldBeOnFire >= 7 then
						playerOnFire(player)
					end
				else
					playerOnFire(player)
				end
			end
		elseif hasBeenOnFire >= 4 then
			ShouldBeOnFire = 0
			hasBeenOnFire = 0
			StopEntityFire(player)
		end
	end
end)

function playerOnFire(player)
	ShouldBeOnFire = 0
	hasBeenOnFire = hasBeenOnFire + 1
	StartEntityFire(player)
	local health = (GetEntityHealth(player) - 25)
	exports['ragdoll']:SetPlayerHealth(health)
end

isDoctor = false
RegisterNetEvent("isDoctor")
AddEventHandler("isDoctor", function()
	TriggerServerEvent("jobssystem:jobs", "doctor")
	isDoctor = true
end)

RegisterNetEvent("np-signin:signoff")
AddEventHandler("np-signin:signoff", function()
	isDoctor = false
	isTher = false
end)

isTher = false
RegisterNetEvent("isTherapist")
AddEventHandler("isTherapist", function()
	TriggerServerEvent("jobssystem:jobs", "therapist")
	isTher = true
end)

isJudge = false
RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
	TriggerServerEvent("jobssystem:jobs", "judge")
	TriggerServerEvent('police:getRank',"judge")
	isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)


RegisterNetEvent("nowIsCop")
AddEventHandler("nowIsCop", function(cb)
	cb(isCop)
end)

RegisterNetEvent('police:noLongerCop')
AddEventHandler('police:noLongerCop', function()
	isCop = false
	isInService = false
	currentCallSign = ""

	local playerPed = PlayerPedId()

	TriggerServerEvent("myskin_customization:wearSkin")
  TriggerServerEvent("police:officerOffDuty")
	TriggerServerEvent('tattoos:retrieve')
	TriggerServerEvent('Blemishes:retrieve')
	RemoveAllPedWeapons(playerPed)

	TriggerEvent("attachWeapons")
	if(existingVeh ~= nil) then

		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
		existingVeh = nil
	end
end)



RegisterNetEvent('police:checkPhone')
AddEventHandler('police:checkPhone', function()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		TriggerEvent("phone:readPlayerconversations",GetPlayerServerId(t))
	else
		TriggerEvent("DoLongHudText", "No player near you!",2)
	end
end)

RegisterNetEvent('police:checkLicensePlate')
AddEventHandler('police:checkLicensePlate', function(plate)
	if isCop then
		TriggerServerEvent('np:vehicles:plateCheck', plate)
	else
		TriggerEvent("DoLongHudText", "Please take your service first!",2)
	end
end)

RegisterNetEvent('police:checkBank')
AddEventHandler('police:checkBank', function(pArgs, pEntity)
	TriggerServerEvent("police:targetCheckBank", GetPlayerServerId(NetworkGetPlayerIndexFromPed(pEntity)))
end)

RegisterNetEvent('police:checkInventory')
AddEventHandler('police:checkInventory', function(pArgs, pEntity)
  TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(NetworkGetPlayerIndexFromPed(pEntity)), pArgs[1])
end)


local robbingDisabled = false
AddEventHandler('np-police:disableRobbing', function(pState)
	robbingDisabled = pState
end)

RegisterNetEvent("police:rob")
AddEventHandler("police:rob", function(pArgs, pEntity)
  if robbingDisabled then
	TriggerEvent("DoLongHudText", "Unable to rob",2)
	return
  end

  RequestAnimDict("random@shop_robbery")
  while not HasAnimDictLoaded("random@shop_robbery") do
    Citizen.Wait(0)
  end

  local lPed = PlayerPedId()
  ClearPedTasksImmediately(lPed)

  TaskPlayAnim(lPed, "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
  local finished = exports["np-taskbar"]:taskBar(15000,"Robbing",false,true,nil,false,nil,5,pEntity)

  if finished == 100 then
    ClearPedTasksImmediately(lPed)
    TriggerServerEvent("police:rob", GetPlayerServerId(NetworkGetPlayerIndexFromPed(pEntity)))
    TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(NetworkGetPlayerIndexFromPed(pEntity)), false)
  end
end)

RegisterNetEvent("police:seizeCash")
AddEventHandler("police:seizeCash", function()

		t, distance, closestPed = GetClosestPlayer()

		if distance ~= -1 and distance < 5 then
			TriggerServerEvent("police:SeizeCash", GetPlayerServerId(t))
		else
			TriggerEvent("DoLongHudText", "No player near you!",2)
		end

end)

RegisterNetEvent('police:seizeInventory')
AddEventHandler('police:seizeInventory', function()
		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 5) then
			TriggerServerEvent("police:targetseizeInventory", GetPlayerServerId(t))
		else

			TriggerEvent("DoLongHudText", "No player near you!",2)
		end
end)

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait(0)
	end
end

inanim = false
cancelled = false
RegisterNetEvent( 'KneelHU' )
AddEventHandler( 'KneelHU', function()
	local player = GetPlayerPed( -1 )
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( "random@arrests" )
		loadAnimDict( "random@arrests@busted" )
		TaskPlayAnim( player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		local finished = exports["np-taskbar"]:taskBar(2500,"Surrendering")
	end
end )

function KneelMedic()
	local player = GetPlayerPed( -1 )
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( "amb@medic@standing@tendtodead@enter" )
		loadAnimDict( "amb@medic@standing@timeofdeath@enter" )
		loadAnimDict( "amb@medic@standing@tendtodead@idle_a" )
		loadAnimDict( "random@crash_rescue@help_victim_up" )
		TaskPlayAnim( player, "amb@medic@standing@tendtodead@enter", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		Wait (1000)
		TaskPlayAnim( player, "amb@medic@standing@tendtodead@idle_a", "idle_b", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
		Wait (3000)
		TaskPlayAnim( player, "amb@medic@standing@tendtodead@exit", "exit_flee", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		Wait (1000)
		TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "enter", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
		Wait (500)
		TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "helping_victim_to_feet_player", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
	end
end

RegisterNetEvent('revive')
AddEventHandler('revive', function(t)

	t, distance = GetClosestPlayer()
	if(t and (distance ~= -1 and distance < 10)) then
		TriggerServerEvent("reviveGranted", GetPlayerServerId(t))
		KneelMedic()
		NPX.Procedures.execute("police:handleRevive",  GetPlayerServerId(t))
	else
		TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
	end

end)


function VehicleInFront()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end


RegisterNetEvent('police:woxy')
AddEventHandler('police:woxy', function()
	local vehFront = VehicleInFront()
	if vehFront > 0 then
  		loadAnimDict('anim@narcotics@trash')
		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 3800, 49, 3.0, 0, 0, 0)
		local finished = exports["np-taskbar"]:taskBar(4000,"Grabbing Scuba Gear")
	  	if finished == 100 then
	  		loadAnimDict('anim@narcotics@trash')
    		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1900, 49, 3.0, 0, 0, 0)
			TriggerEvent("UseOxygenTank")
		end
	end
end)

function isOppositeDir(a,b)
	local result = 0
	if a < 90 then
		a = 360 + a
	end
	if b < 90 then
		b = 360 + b
	end
	if a > b then
		result = a - b
	else
		result = b - a
	end
	if result > 110 then
		return true
	else
		return false
	end
end

RegisterNetEvent('police:remmaskAccepted')
AddEventHandler('police:remmaskAccepted', function()
	TriggerEvent('np-clothing:faceWear', "mask", false)
	TriggerEvent('np-clothing:faceWear', "hat", false)
	TriggerEvent('np-clothing:faceWear', "glasses", false)
end)

RegisterNetEvent('police:remmask')
AddEventHandler('police:remmask', function(t)
	t, distance = GetClosestPlayer()
	if (distance ~= -1 and distance < 5) then
		if not IsPedInVehicle(t,GetVehiclePedIsIn(t, false),false) then
			TriggerServerEvent("police:remmaskGranted", GetPlayerServerId(t))
			AnimSet = "mp_missheist_ornatebank"
			AnimationOn = "stand_cash_in_bag_intro"
			AnimationOff = "stand_cash_in_bag_intro"
			loadAnimDict( AnimSet )
			TaskPlayAnim( PlayerPedId(), AnimSet, AnimationOn, 8.0, -8, -1, 49, 0, 0, 0, 0 )
			Citizen.Wait(500)
			ClearPedTasks(PlayerPedId())
		end
	else
		TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
	end
end)

RegisterNetEvent('police:gsr')
AddEventHandler('police:gsr', function(pArgs, pEntity)
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, 1)
	local finished = exports["np-taskbar"]:taskBar(15000, "GSR Testing")
	if finished == 100 then
		TriggerServerEvent("police:gsrGranted", GetPlayerServerId(NetworkGetPlayerIndexFromPed(pEntity)))
	end
end)

RegisterNetEvent('police:payFines')
AddEventHandler('police:payFines', function(amount, fromUnbill)
	local effect = exports['np-galleria']:GetEffect('FINE_REDUCE')
	if not effect then
		effect = {
			level = 0
		}
	end

	if amount > 25000 or fromUnbill then
		effect.level = 0
	end

	local characterEffect = exports['np-character']:GetFactor('FINE_AMOUNT') or 1.0
	amount = (amount - (amount * (effect.level / 100))) * characterEffect
	local success, message = RPC.execute("DoStateForfeiture", amount)

	if not success then
		TriggerEvent('chatMessage', "BILL ", {255, 140, 0}, message)
		return
	end

	TriggerEvent('chatMessage', "BILL ", {255, 140, 0}, "You were billed for ^2" .. tonumber(amount) .. " ^0dollar(s).", "feed", false, { i18n = { "You were billed for", "dollar(s)" }})
end)

RegisterNetEvent('police:undoFines')
AddEventHandler('police:undoFines', function(amount)
	local effect = exports['np-galleria']:GetEffect('FINE_REDUCE')
	if not effect then
		effect = {
			level = 0
		}
	end

	if amount > 25000 then
		effect.level = 0
	end

	local characterEffect = exports['np-character']:GetFactor('FINE_AMOUNT') or 1.0
	amount = amount - (amount * (effect.level / 100)) * characterEffect
	local success, message = RPC.execute("UndoStateForfeiture", amount)

	if not success then
		TriggerEvent('chatMessage', "BILL ", {255, 140, 0}, message)
		return
	end

	TriggerEvent('chatMessage', "BILL ", {255, 140, 0}, "You were reimbursed for ^2" .. tonumber(amount) .. " ^0dollar(s).", "feed", false, { i18n = { "You were reimbursed for", "dollar(s)" }})
end)

local tenthirteenACooldown = 0
local tenthirteenBCooldown = 0
local fifteenMinutes = 60000 * 15
RegisterNetEvent('police:tenThirteenA')
AddEventHandler('police:tenThirteenA', function()
  if tenthirteenACooldown ~= 0 and tenthirteenACooldown + fifteenMinutes > GetGameTimer() then return end
  tenthirteenACooldown = GetGameTimer()
	if(isCop) then
		local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-13A",
			firstStreet = GetStreetAndZone(),
			callSign = currentCallSign,
			cid = exports["isPed"]:isPed("cid"),
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
			  }
		})
	end
end)

RegisterNetEvent('police:tenThirteenB')
AddEventHandler('police:tenThirteenB', function()
  if tenthirteenBCooldown ~= 0 and tenthirteenBCooldown + fifteenMinutes > GetGameTimer() then return end
  tenthirteenBCooldown = GetGameTimer()
	if(isCop) then
		local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-13B",
			firstStreet = GetStreetAndZone(),
			callSign = currentCallSign,
			cid = exports["isPed"]:isPed("cid"),
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
			}
		})
	end
end)

RegisterNetEvent("police:tenForteenA")
AddEventHandler("police:tenForteenA", function()
	local pos = GetEntityCoords(PlayerPedId(),  true)
	TriggerServerEvent("dispatch:svNotify", {
		dispatchCode = "10-14A",
		firstStreet = GetStreetAndZone(),
		callSign = currentCallSign,
		cid = exports["isPed"]:isPed("cid"),
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z
		}
	})
end)

RegisterNetEvent("police:tenForteenB")
AddEventHandler("police:tenForteenB", function()
	local pos = GetEntityCoords(PlayerPedId(),  true)
	TriggerServerEvent("dispatch:svNotify", {
		dispatchCode = "10-14B",
		firstStreet = GetStreetAndZone(),
		callSign = currentCallSign,
		cid = exports["isPed"]:isPed("cid"),
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z
		}
	})
end)

RegisterNetEvent("police:setCallSign")
AddEventHandler("police:setCallSign", function(pCallSign, pDepartment)
	if pCallSign ~= nil then currentCallSign = pCallSign end
	if pDepartment ~= nil then
		currentDepartment = pDepartment
	else
		currentDepartment = "lspd"
	end
end)

function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local playerStreetsLocation = GetLabelText(zone)
    local street = street1 .. ", " .. playerStreetsLocation
    return street
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayers(targetVector,dist)
	local players = GetPlayers()
	local ply = PlayerPedId()
	local plyCoords = targetVector
	local closestplayers = {}
	local closestdistance = {}
	local closestcoords = {}

	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(distance < dist) then
				valueID = GetPlayerServerId(value)
				closestplayers[#closestplayers+1]= valueID
				closestdistance[#closestdistance+1]= distance
				closestcoords[#closestcoords+1]= {targetCoords["x"], targetCoords["y"], targetCoords["z"]}

			end
		end
	end
	return closestplayers, closestdistance, closestcoords
end

function GetClosestPlayerVehicleToo()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) then
					closestPlayer = value
					closestDistance = distance
				end
			end
		end
		return closestPlayer, closestDistance
	else
		TriggerEvent("DoShortHudText","Inside Vehicle.",2)
	end
end

function GetClosestPlayerAny()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)


	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance



end



function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local closestPed = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then

		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
					closestPlayer = value
					closestPed = target
					closestDistance = distance
				end
			end
		end

		return closestPlayer, closestDistance, closestPed

	else
		TriggerEvent("DoShortHudText","Inside Vehicle.",2)
	end

end
function GetClosestPedIgnoreCar()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local closestPlayerId = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = target
				closestPlayerId = value
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance, closestPlayerId
end

function GetClosestPlayerIgnoreCar()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

function getClosestPlayer(coords, pDist)
  local closestPlyPed
  local closestPly
  local dist = -1

  for _, player in ipairs(GetActivePlayers()) do
    if player ~= PlayerId() then
      local ped = GetPlayerPed(player)
      local pedcoords = GetEntityCoords(ped)
      local newdist = #(coords - pedcoords)

      if (newdist <= pDist) then
        if (newdist < dist) or dist == -1 then
          dist = newdist
          closestPlyPed = ped
          closestPly = player
        end
      end
    end
  end

  return closestPlyPed, closestPly, GetPlayerServerId(closestPly)
end


function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end


function isNearTakeService()
	for i = 1, #takingService do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = #(vector3(takingService[i].x, takingService[i].y, takingService[i].z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
		if(distance < 30.0) then
			DrawMarker(27, takingService[i].x, takingService[i].y, takingService[i].z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.5, 0, 0, 255, 155, 0, 0, 2, 0, 0, 0, 0)
		end
		if(distance < 3.0) then
			return true
		end
	end
end

function ShowRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3DTest(x,y,z, text)
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

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

intmenuopen = false

RegisterNetEvent('requestWounds')
AddEventHandler('requestWounds', function(pArgs, pEntity)
	local targetPed = nil
	if not pEntity then
		targetPed = exports['np-target']:GetCurrentEntity()
	else
		targetPed = pEntity
	end 

	if not targetPed and not IsPedAPlayer(targetPed) then
		return
	end

	local plySrvId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))

	TriggerServerEvent("Evidence:GetWounds", plySrvId)
end)

RegisterCommand("+examineTarget", function()
	if isInService and not inmenus and not IsPauseMenuActive() then
		TriggerEvent("requestWounds")
	end
end, false)
RegisterCommand("-examineTarget", function() end, false)
Citizen.CreateThread(function()
  exports["np-keybinds"]:registerKeyMapping("", "Gov", "(EMS) Examine Target", "+examineTarget", "-examineTarget")
end)

RegisterNetEvent("ems:heal")
AddEventHandler("ems:heal", function()
	t, distance = GetClosestPlayerAny()
	if t ~= nil and t ~= -1 then
		if(distance ~= -1 and distance < 5) then

			local myjob = exports["isPed"]:isPed("myjob")
			if myjob ~= "ems" and myjob ~= "doctor" and myjob ~= "doc" then
				local bandages = exports["np-inventory"]:getQuantity("bandage")
				if bandages == 0 then
					return
				else
					TriggerEvent('inventory:removeItem',"bandage", 1)
				end
			end

			TriggerEvent("animation:PlayAnimation","layspike")
			TriggerServerEvent("ems:healplayer", GetPlayerServerId(t))
		end
	end
end)

RegisterNetEvent("ems:stomachpump")
AddEventHandler("ems:stomachpump", function()
	t, distance = GetClosestPlayerAny()
	if t ~= nil and t ~= -1 then
		if(distance ~= -1 and distance < 5) then
			local finished = exports["np-taskbar"]:taskBar(10000,"Inserting stomach pump 🤢", false, true)
			TriggerEvent("animation:PlayAnimation","cpr")
			if finished == 100 then
				TriggerServerEvent("fx:puke", GetPlayerServerId(t))
			end
			TriggerEvent("animation:cancel")
		end
	end
end)

RegisterNetEvent("ems:bloodtest")
AddEventHandler("ems:bloodtest", function()
	t, distance = GetClosestPlayerAny()
	if t ~= nil and t ~= -1 then
		if(distance ~= -1 and distance < 5) then
			local finished = exports["np-taskbar"]:taskBar(10000,"Taking blood test", false, true)
			if finished == 100 then
				TriggerServerEvent("ems:bloodtesttarget", GetPlayerServerId(t))
			end
		end
	end
end)

RegisterNetEvent('binoculars:Activate')
AddEventHandler('binoculars:Activate', function()
	TriggerEvent("binoculars:Activate2")
end)

RegisterNetEvent('camera:Activate')
AddEventHandler('camera:Activate', function()
	TriggerEvent("camera:Activate2")
end)

imdead = 0
RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
	if imdead == 0 then
		imdead = 1
	else
		imdead = 0
	end
    lightbleed = false
    heavybleed = false
    lightestbleed = false
	lasthealth = GetEntityHealth(PlayerPedId())
end)

RegisterNetEvent('checkmyPH')
AddEventHandler('checkmyPH', function()
	TriggerServerEvent("police:showPH")
end)

RegisterNetEvent('clientcheckLicensePlate')
AddEventHandler('clientcheckLicensePlate', function(pDummy, pEntity)
  if isCop then
    local licensePlate = GetVehicleNumberPlateText(pEntity)
    if licensePlate == nil then
      TriggerEvent("DoLongHudText", 'Can not target vehicle', 2)
    else
      TriggerServerEvent('np:vehicles:plateCheck', licensePlate, vehicleClass)
    end
  end
end)

inanimation = false

cruisecontrol = false
RegisterNetEvent('toggle:cruisecontrol')
AddEventHandler('toggle:cruisecontrol', function()
	local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
	if driverPed == PlayerPedId() then
		if cruisecontrol then
			SetEntityMaxSpeed(currentVehicle, 999.0)
			cruisecontrol = false
			TriggerEvent("DoLongHudText","Speed Limiter Inactive",5)
		else
			speed = GetEntitySpeed(currentVehicle)
			if speed > 13.3 then
			SetEntityMaxSpeed(currentVehicle, speed)
			cruisecontrol = true
				TriggerEvent("DoLongHudText","Speed Limiter Active",5)
			else
				TriggerEvent("DoLongHudText","Speed Limiter can only activate over 35mph",2)
			end
		end
	end
end)


RegisterNetEvent('animation:phonecall')
AddEventHandler('animation:phonecall', function()
	inanimation = true
	local handCuffed = exports["isPed"]:isPed("handcuffed")
	if not handCuffed then
		local lPed = PlayerPedId()

		RequestAnimDict("random@arrests")
		while not HasAnimDictLoaded("random@arrests") do
			Citizen.Wait(0)
		end

		if IsEntityPlayingAnim(lPed, "random@arrests", "idle_c", 3) then
			ClearPedSecondaryTask(lPed)

		else
			TaskPlayAnim(lPed, "random@arrests", "idle_c", 8.0, -8, -1, 49, 0, 0, 0, 0)
			seccount = 10
			while seccount > 0 do
				Citizen.Wait(1000)
				seccount = seccount - 1

			end
			ClearPedSecondaryTask(lPed)
		end
	else
		ClearPedSecondaryTask(lPed)
	end
	inanimation = false
end)

function LoadAnimationDictionary(animationD) -- Simple way to load animation dictionaries to save lines.
	while(not HasAnimDictLoaded(animationD)) do
		RequestAnimDict(animationD)
		Citizen.Wait(1)
	end
end

local function flipVehicle(pVehicle, pPitch, pVRoll, pVYaw)
	SetEntityRotation(pVehicle, pPitch, pVRoll, pVYaw, 1, true)
	Wait(10)
	SetVehicleOnGroundProperly(pVehicle)
end

RegisterNetEvent("vehicle:flip")
AddEventHandler("vehicle:flip", function(pVehicle, pPitch, pVRoll, pVYaw)
	flipVehicle(NetToVeh(pVehicle), pPitch, pVRoll, pVYaw)
end)

RegisterNetEvent('FlipVehicle')
AddEventHandler('FlipVehicle', function(pDummy, pEntity)
  TriggerEvent("animation:PlayAnimation", "push")
  local finished = exports["np-taskbar"]:taskBar(30000, "Flipping Vehicle Over", true, true, nil, false, nil, 3.5, pEntity)
  ClearPedTasks(PlayerPedId())
  if finished ~= 100 then return end
	
	local playerped = PlayerPedId()
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
	local pPitch, pRoll, pYaw = GetEntityRotation(playerped)
	local vPitch, vRoll, vYaw = GetEntityRotation(pEntity)
	
	if targetVehicle == 0 then return end

	if not NetworkHasControlOfEntity(pEntity) then
		local vehicleOwnerId = NetworkGetEntityOwner(pEntity)
		TriggerServerEvent("vehicle:flip", GetPlayerServerId(vehicleOwnerId), VehToNet(pEntity), pPitch, vRoll, vYaw)
	else
		flipVehicle(pEntity, pPitch, vRoll, vYaw)
	end
end)

local function hasCarAnyPlayerPassengers(pVehicle)
	for i = -1, (GetVehicleMaxNumberOfPassengers(pVehicle) - 1) do
		local pedInSeat = GetPedInVehicleSeat(pVehicle, i)
		if pedInSeat ~= 0 and IsPedAPlayer(pedInSeat) then return true end
	end
	return false
end

function getVehicleInDirection(coordFrom, coordTo, isTrunking)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		offset = offset - 1
		if vehicle ~= 0 then break end
	end

	local isVehicle = IsEntityAVehicle(vehicle)
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))

	if distance > 25 then
		return 0, "Couldn't find a vehicle"
	else
		local vehDriver = GetPedInVehicleSeat(vehicle, -1)

		if not isTrunking and not IsPedAPlayer(vehDriver) and not hasCarAnyPlayerPassengers(vehicle) then
			return vehicle
		end

		if not isTrunking and isVehicle and (not IsVehicleSeatFree(vehicle, -1) or GetVehicleNumberOfPassengers(vehicle) ~= 0) then
			return 0, "This vehicle is currently occupied, dumbass."
		end

		if not isVehicle then
			return 0, "This isnt a vehicle, dumbass."
		end

		return vehicle
	end
end

RegisterNetEvent('animation:runtextanim')
AddEventHandler('animation:runtextanim', function(anim)
	local handCuffed = exports["isPed"]:isPed("handcuffed")
	if not handCuffed and not IsPedRagdoll(PlayerPedId()) then
		TriggerEvent('animation:runtextanim2', anim)
	end
end)

-- NOTE: Make sure to update the server-side list as well
local emsVehicleListWhite = {
	{"Search and Rescue Boat", "dinghy4"},
}

local emsVehicleList = {
	"ambulance"
}

local copVehicleList = {
	{"Predator Boat", "predator"},
}

local pullout = false

local function serviceVehicle(arg, livery, isEmsWhiteListed, cb)
	if not arg then cb("No argument was given") return end

	if GetInteriorFromEntity(PlayerPedId()) ~= 0 then return cb("Cannot be used here") end

	local function printHelp(list)
		copVehStrList = ""
		for i=1, #list do
			copVehStrList = copVehStrList.."["..i.."] "..list[i][1].."\n"
		end
		TriggerEvent("chatMessage", "SYSTEM ", 2, copVehStrList)
	end
	if arg == "help" then
		if isCop then
			printHelp(copVehicleList)
		elseif isEmsWhiteListed then
			printHelp(emsVehicleListWhite)
		end
		return
	end

	arg = tonumber(arg)
	if not arg then cb("Invalid argument") return end


	if isCop then
		if arg > #copVehicleList or arg <= 0 then
			TriggerEvent("DoLongHudText", "Invalid Service Vehicle", 2)
			return
		end

		selectedSkin = copVehicleList[arg][2]

	else
		if isEmsWhiteListed then
			if arg > #emsVehicleListWhite or arg <= 0 then
				TriggerEvent("DoLongHudText", "Invalid Service Vehicle", 2)
				return
			end
			selectedSkin = emsVehicleListWhite[arg][2]
		else
			if arg > #emsVehicleList or arg <= 0 then
				TriggerEvent("DoLongHudText", "Invalid Service Vehicle", 2)
				return
			end
			selectedSkin = emsVehicleList[arg]
		end
	end


	Citizen.CreateThread(function()
		if not pullout then
			pullout = true
		end

		local hash = GetHashKey(selectedSkin)

		if not IsModelAVehicle(hash) then cb("Model isn't a vehicle") return end
		if not IsModelInCdimage(hash) or not IsModelValid(hash) then cb("Model doesn't exist") return end

		if IsThisModelABoat(hash) then
			local nearDock = false
			local whitelistedDocks = {
				vector3(-800.15, -1495.57, 1.59),
				vector3(-859.13,-1471.69,1.64),
				vector3(-888.63,-1393.24,1.6),
				vector3(-861.68,-1325.08,1.6),
				vector3(-1800.95,-1228.29,1.66)
			}
	
			for k, v in pairs(whitelistedDocks) do
				if #(v-GetEntityCoords(PlayerPedId(), false)) < 20 then
					nearDock = true
					break
				end
			end
	
			if not nearDock then
				local finished = exports["np-taskbar"]:taskBar(45000, "Requesting Vehicle...", true)
				if finished ~= 100 then return end
			end
		end

		TriggerServerEvent("police:spawnServiceVehicle", selectedSkin, livery)
	end)
end

function GroupRank(groupid)
  local rank = 0
  local mypasses = exports["isPed"]:isPed("passes")
  for i=1, #mypasses do
    if mypasses[i]["pass_type"] == groupid then
      rank = mypasses[i]["rank"]
    end
  end
  return rank
end

RegisterNetEvent("police:chatCommand")
AddEventHandler("police:chatCommand", function(args, cmd, isVehicleCmd,isEmsWhiteListed)
	-- remove the cmd itself from the args
	table.remove(args, 1)

	local function errorMsg(msg)
		TriggerEvent("chatMessage", "Error", 1, msg)
	end

	--local _isCop = isCop
	--if not _isCop then errorMsg("You must be a police officer to use this command") return end

	if not args[1] and cmd ~= "fix" and cmd ~= "spikes" then errorMsg("No argument was given") return end

	local vehicle

	if isVehicleCmd then
		vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if vehicle == 0 then errorMsg("No vehicle target was found") return end
		SetVehicleModKit(vehicle, 0)
	end

	if cmd == "livery" then
		SetVehicleLivery(vehicle, tonumber(args[1]))
	end
	if cmd == "sv" then
		serviceVehicle(args[1], args[2], isEmsWhiteListed, errorMsg)
	end

	if cmd == "whitelist" then
		if rankService == 10 then
			local arg = args[1]
			local arg2 = tonumber(args[2])
			if not arg then errorMsg("Invalid argument") return end
			if not arg2 then errorMsg("Invalid Second argument") return end

			TriggerServerEvent("police:whitelist",arg2,arg)
		else
			errorMsg("You do not have the rank to do this action")
		end
	end

	if cmd == "remove" then
		if rankService == 10 then
			local arg = args[1]
			local arg2 = tonumber(args[2])
			if not arg then errorMsg("Invalid argument") return end
			if not arg2 then errorMsg("Invalid Second argument") return end

			TriggerServerEvent("police:remove",arg2,arg)
		else
			errorMsg("You do not have the rank to do this action")
		end
	end
end)

Citizen.CreateThread(function()
  exports["np-polyzone"]:AddBoxZone("wheelchair_store", vector3(-803.48, -1248.7, 7.34), 1.6, 1.0, {
    heading=320,
    minZ=6.14,
    maxZ=8.74,
    data = {
      id = "1",
    },
  })

  exports["np-polyzone"]:AddBoxZone("wheelchair_store", vector3(344.42, -589.63, 43.28), 1.5, 1.5, {
	heading=340,
	minZ=40.48,
	maxZ=44.48,
	data = {
		id = "2"
	}
  })
  

  exports["np-polyzone"]:AddBoxZone("police_station", vector3(461.91, -993.59, 30.69), 55.8, 54.8, {
		heading=0,
		minZ = 23.49,
		maxZ = 32.29,
		data = {
			id = "mrpd"
		}
  })

  exports["np-polyzone"]:AddBoxZone("police_station", vector3(-1084.8, -836.75, 13.52), 25.6, 11.2, {
		heading=309,
		minZ=12.32,
		maxZ=17.72,
		data = {
			id = "vspd"
		}
  })

  exports["np-polyzone"]:AddBoxZone("police_station", vector3(1834.68, 3687.33, 42.97), 28.0, 65.4, {
		heading=30,
		minZ=33.17,
		maxZ=41.37,
		data = {
			id = "sspd"
		}
  })

  exports["np-polyzone"]:AddBoxZone("police_station", vector3(-443.63, 6003.52, 31.49), 26.6, 37.6, {
		heading=316,
		minZ=22.34,
		maxZ=44.34,
		data = {
			id = "ppd"
		}
  })

  exports["np-polyzone"]:AddBoxZone("police_station", vector3(382.87, 796.83, 187.46), 8.0, 11.8, {
		heading=0,
		minZ=186.46,
		maxZ=193.26,
		data = {
			id = "prpd"
		}
  })

	exports["np-polyzone"]:AddBoxZone("police_station", vector3(375.22, -1608.44, 30.04), 38.0, 61.2, {
		heading=320,
		minZ=27.84,
		maxZ=41.24,
		data = {
			id = "davispd"
		}
	})

	exports["np-polyzone"]:AddBoxZone("police_station", vector3(844.08, -1295.15, 38.62), 36.4, 32.2, {
		heading=0,
		minZ=24.82,
		maxZ=34.02,
		data = {
			id = "lamesapd"
		}
	})

  exports["np-polyzone"]:AddBoxZone("possession_pickup", vector3(472.98, -1007.43, 26.27), 1.2, 2.6, {
	heading=0,
	minZ=25.27,
	maxZ=27.47,
	data = {
		id = "mrpdpickup"
	}
  })

  exports["np-polyzone"]:AddBoxZone("possession_pickup", vector3(-1088.5, -811.11, 19.3), 1.2, 2.6, {
	heading=40,
	minZ=18.3,
	maxZ=20.5,
	data = {
		id = "vspdpickup"
	}
  })

  exports["np-polyzone"]:AddBoxZone("possession_pickup", vector3(384.99, 799.86, 187.46), 1.2, 2.6, {
	heading=0,
	minZ=186.46,
	maxZ=188.66,
	data = {
		id = "prpdpickup"
	}
  })

  exports["np-polyzone"]:AddBoxZone("possession_pickup", vector3(1835.42, 3678.33, 34.2), 2, 2, {
	heading=30,
	minZ=32.4,
	maxZ=36.4,
	data = {
		id = "sspdpickup"
	}
  })

  exports["np-polyzone"]:AddBoxZone("possession_pickup", vector3(-446.11, 6013.73, 32.29), 1.6, 1.2, {
		heading=316,
		minZ=31.29,
		maxZ=33.49,
		data = {
			id = "ppdpickup"
		}
  })

  exports["np-polyzone"]:AddBoxZone("possession_pickup", vector3(1840.42, 2579.44, 46.01), 2.2, 2.6, {
	heading=0,
	minZ=45.01,
	maxZ=47.61,
	data = {
		id = "prisonpickup"
	}
  })
  
  PolyZoneInteraction("possession_pickup", "[E] Re-claim Possessions", 38, function (data)
	local cid = exports["isPed"]:isPed("cid")
	TriggerServerEvent("server-jail-items", cid, false, GetPlayerServerId(PlayerId()))
	TriggerEvent("DoLongHudText", "Your possessions were returned.")
	exports["np-ui"]:hideInteraction()
	Citizen.Wait(15000)
  end)
end)

AddEventHandler("np-polyzone:enter", function(zone)
	if zone == "wheelchair_store" then
		local myjob = exports["isPed"]:isPed("myjob")
		if myjob == "doctor" then
			TriggerEvent("server-inventory-open", "43", "Shop")
		else
			showWheelChairMenu()
		end
	end
end)


function showWheelChairMenu()
    local data = {
        {
            title = "Buy Wheelchair ($10,000)",
            description = "Buy a personal Wheelchair.",
            key = true,
            children = {
				{ title = "Confirm Purchase", action = "np-ui:wheelchairPurchase", key = true },
			},
        },
    }

    exports["np-ui"]:showContextMenu(data)
end

RegisterUICallback("np-ui:wheelchairPurchase", function(data, cb)

	local finished = exports["np-taskbar"]:taskBar(10000, "Purchasing...", true)
	if finished ~= 100 then
	  cb({ data = {}, meta = { ok = false, message = 'cancelled' } })
	  return
	end
	
	local success, message = RPC.execute("wheelchair:purchase")
	if not success then
		cb({ data = {}, meta = { ok = success, message = message } })
		TriggerEvent("DoLongHudText", message, 2)
		return
	end

	TriggerEvent("player:receiveItem","wheelchair",1)
	
	cb({ data = {}, meta = { ok = true, message = "done" } })
end)

RegisterUICallback("np-ui:police:flagPlate", function(data, cb)
	cb({ data = {}, meta = { ok = true, message = "done" } })
  exports['np-ui']:closeApplication('textbox')
  RPC.execute("police:flagPlate", data.values.plate, data.values.reason)
end)

local inHotel = false
RegisterNetEvent("inhotel", function(pInside)
	inHotel = pInside
end)

--afk timer
local afkCount = 0
local prevCoords = nil
Citizen.CreateThread(function()
  Citizen.Wait(60 * 60 * 1000)
  local afkAutoKick = exports["np-config"]:GetMiscConfig("afk.kick.auto")
  while true do
    Citizen.Wait(60000)
    local _myJob = exports["isPed"]:isPed("myjob")
    if _myJob == "unemployed" then -- 1hr
	  local curCoords = GetEntityCoords(PlayerPedId())
	  local distance = prevCoords and #(prevCoords - curCoords) or 0
      if not prevCoords or (distance > 2.0 and not inHotel) or distance > 5.0 then
        afkCount = 0
      else
        afkCount = afkCount + 1
      end
      if afkCount == 30 then
		 afkCount = 0
		 if afkAutoKick then
				RPC.execute("police:afk")
		 end
        TriggerServerEvent("np-bugs:playerLogAction", {
          title = "30 minutes inactivity",
          content = "(" .. GetPlayerServerId(PlayerId()) .. ") "
            .. exports["isPed"]:isPed("cid") .. " - "
            .. exports["isPed"]:isPed("firstname") .. " "
            .. exports["isPed"]:isPed("lastname")
        })
      end
      prevCoords = curCoords
    end
  end
end)
