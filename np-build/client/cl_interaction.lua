Build.InVisable = false

-- Text Draw
Citizen.CreateThread(function()
	--Build.func.buildRoom("v_int_53",vector3(100.0,100.0,0.0),false)
    while true do
    	if Build.CurrentRoomPlan ~= nil then
    		local plan = Build.CurrentRoomPlan
			DisableOcclusionThisFrame()
    		if plan.interact ~= nil then
    			Build.InVisable = false
    			local pedCoords = GetEntityCoords(PlayerPedId())
    			for k,v in pairs(plan.interact) do
    				-- k = interact ID 
    				-- v = interact table 
    				local distance = #(pedCoords - (Build.CurrentBuildingOrigin+v.offset))
    				if distance <= v.viewDist then
    					Build.InVisable = true
	    				local pos = Build.CurrentBuildingOrigin+v.offset
	    				Draw3DText(pos.x,pos.y,pos.z, Build.func.buildLine(v))
	    			end
    			end

    		end
    		Wait(0)
    	else
    		Wait(5000)
    	end
    end
end)

RegisterNetEvent('np-binds:keyEvent')
AddEventHandler('np-binds:keyEvent', function(name,onDown)
    if not onDown then return end

	if Build.CurrentRoomPlan ~= nil then
		local plan = Build.CurrentRoomPlan
		local interactName = nil

		if plan.interact ~= nil and Build.InVisable then

			if name == "housingSecondary" then
				interactName = "housingSecondary"
			end
			
			if name == "housingMain" then
				interactName = "housingMain"
			end
			
			if name == "general" then
				interactName = "generalUse"
			end

			if interactName ~= nil then
				Build.func.ClosestInteract(plan.interact,interactName)
			end
		end
		Wait(1)
	end
end)

function Build.func.buildLine(interact)

	local line = ""

	if interact then
		if interact.generalUse ~= nil and interact.generalUse[1] ~= "" then
			local key = exports['np-keybinds']:getKeyMapping('+generalUse')
			local str1 = "[" .. key .. "]"
			local str2 = interact.generalUse[1]
			TriggerEvent("i18n:translate", str2, "housing:interactions")
			str2 = exports["np-i18n"]:GetStringSwap(str2)
			line = line .. "~g~" .. str1 .. "~s~ " .. str2 .. " "
    end
		if interact.housingMain ~= nil and interact.housingMain[1] ~= "" then
			local key = exports['np-keybinds']:getKeyMapping('+housingMain')
			local str1 = "[" .. key .. "]"
			local str2 = interact.housingMain[1]
			TriggerEvent("i18n:translate", str2, "housing:interactions")
			str2 = exports["np-i18n"]:GetStringSwap(str2)
			line = line .. "~g~" .. str1 .. "~s~ " .. str2 .. " "
    end
		if interact.housingSecondary ~= nil and interact.housingSecondary[1] ~= "" then
			local key = exports['np-keybinds']:getKeyMapping('+housingSecondary')
			local str1 = "[" .. key .. "]"
			local str2 = interact.housingSecondary[1]
			TriggerEvent("i18n:translate", str2, "housing:interactions")
			str2 = exports["np-i18n"]:GetStringSwap(str2)
			line = line .. "~g~" .. str1 .. "~s~ " .. str2 .. " "
		end
	end

	return line 
end

function Build.func.ClosestInteract(interactTable,key)
	local mainVector = Build.CurrentBuildingOrigin

	local CurrentDist = 999
	local CurrentInteract = nil

	for k,v in pairs(interactTable) do
		local distance = #(GetEntityCoords(PlayerPedId()) - (mainVector+v.offset))
		if distance <= v.useDist and distance < CurrentDist then
			CurrentDist = distance
			CurrentInteract = k
		end
	end

	if CurrentInteract ~= nil and interactTable[CurrentInteract][key][2] ~= "" then
		
		--print("triggering event [ "..interactTable[CurrentInteract][key][2].." ]")
		TriggerEvent(interactTable[CurrentInteract][key][2]) 
	end

end

function Build.func.isNearCurrentInteract(interactNum,dist)
    local plan = Build.CurrentRoomPlan
    local mainVector = Build.CurrentBuildingOrigin
    local name = nil


    if plan ~= nil and plan.interact ~= nil then
        local offset = plan.interact[interactNum].offset

        if #((mainVector+offset) - GetEntityCoords(PlayerPedId())) < dist then
            return true
        else
            return false
        end

    else
        return false
    end

end

function Build.func.isInBuilding()
    local plan = Build.CurrentRoomPlan
    if plan ~= nil then return true else return false end
end


function Build.func.currentBuildingVector()
	local plan = Build.CurrentRoomPlan
	if plan ~= nil then 
        return Build.CurrentBuildingOrigin
    else 
        return false 
    end
end


function Build.func.getCurrentBed()
    local plan = Build.CurrentRoomPlan
    if plan ~= nil then 
        local vec1 = Build.CurrentBuildingOrigin
        local vec2 = vector3(plan.bedOffset.x,plan.bedOffset.y,plan.bedOffset.z)

        local vec3 = vec1 + vec2
        return vector4(vec3.x,vec3.y,vec3.z,plan.bedOffset.w)
    else 
        return false 
    end

end

function Build.func.getAlarm()
    local plan = Build.CurrentRoomPlan
    if plan ~= nil then 
        local vec1 = Build.CurrentBuildingOrigin
        local vec2 = plan.peek.pos

        local vec3 = vec1 + vec2
        return vec3
    else 
        return false 
    end

end


-- do not look to close at this function and move on with life
-- this is a mess just leave it as is :) *shoots self*
function Build.func.addInteractionPoints(model,interactionPoints,overRide)

	if Build.DefaultBuilding ~= nil then
		Build.Plans[model].interact = deepcopy(Build.DefaultBuilding)
		Build.DefaultBuilding = nil
	end

	Build.DefaultBuilding = deepcopy(Build.Plans[model].interact)
	

	if overRide then

		Build.Plans[model].interact = {} 
		for k,v in pairs(interactionPoints) do
			Build.Plans[model].interact[k] = v
		end

	else
		for k,v in pairs(interactionPoints) do
			Build.Plans[model].interact[#Build.Plans[model].interact+1] = v
		end
	end

	local plan = Build.Plans[model]
    Build.CurrentRoomPlan = plan


end


--[[
    Functions below: Utility
    Description: Simple utility functions to make scripts easier
]]

function _deepcopy(o, tables)
 
	if type(o) ~= 'table' then
	  return o
	end
   
	if tables[o] ~= nil then
	  return tables[o]
	end
   
	local new_o = {}
	tables[o] = new_o
   
	for k, v in next, o, nil do
	  local new_k = _deepcopy(k, tables)
	  local new_v = _deepcopy(v, tables)
	  new_o[new_k] = new_v
	end
   
	return new_o
end
   
function deepcopy(o)
	return _deepcopy(o, {})
end


local _i, _f, _v, _r, _ri, _rf, _rl, _s, _rv, _in, _ii, _fi =
Citizen.PointerValueInt(), Citizen.PointerValueFloat(), Citizen.PointerValueVector(),
Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger(), Citizen.ResultAsFloat(), Citizen.ResultAsLong(), Citizen.ResultAsString(), Citizen.ResultAsVector(), Citizen.InvokeNative,
Citizen.PointerValueIntInitialized, Citizen.PointerValueFloatInitialized

local string_len = string.len
local inv_factor = 1.0 / 370.0

function Draw3DText(x,y,z, text)
    local factor = string_len(text) * inv_factor
    local onScreen,_x,_y = _in(0x34E82F05DF2974F5, x, y, z, _f, _f, _r) -- GetScreenCoordFromWorldCoord

    if onScreen then
        _in(0x07C837F9A01C34C9, 0.35, 0.35) -- SetTextScale
        _in(0x66E0276CC5F6B9DA, 4) -- SetTextFont
        _in(0x038C1F517D7FDCF8, 1) -- SetTextProportional
        _in(0xBE6B23FFA53FB442, 255, 255, 255, 215) -- SetTextColour
        _in(0x25FBB336DF1804CB, "STRING") -- SetTextEntry
        _in(0xC02F4DBFB51D988B, 1) -- SetTextCentre
        _in(0x6C188BE134E074AA, text) -- AddTextComponentString, assumes "text" is of type string
        _in(0xCD015E5BB0D96A57, _x, _y) -- DrawText
        _in(0x3A618A217E5154F0, _x,_y+0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68) -- DrawRect
    end
end


-- Peeking Functionality

function Build.func.buildPeeking(plan)
	local peek = plan.peek

	if peek == nil then return end
	local modelFound = false

	for i=1,#Build.CurrentPeekModels do
		if Build.CurrentPeekModels[i] == peek.model then modelFound = true break end
	end
	if modelFound then return end

	exports["np-interact"]:AddPeekEntryByModel({ peek.model }, {{
		event = peek.event,
		id = peek.id,
		icon = peek.icon,
		label = peek.label,
		parameters = {},
	  }}, {
		distance = {radius = 5.0},
		isEnabled = function(pEntity)
		  return exports["np-housing"]:isInRobbery()
		end
	})

	Build.CurrentPeekModels[#Build.CurrentPeekModels+1] = peek.model
end


-- NPC functionality

function Build.func.buildNPC(plan)
	local npc = plan.npc

	if npc == nil then return end
	Build.func.removeNPC()

	for k,v in pairs(npc) do

		local coords = Build.CurrentBuildingOrigin+vector3(v.offset.x,v.offset.y,v.offset.z)
		local data = {
			id = v.id..math.random(10000)..'x'..math.random(10000),
			position = {
				coords = coords,
				heading = v.offset.w,
			},
			pedType = v.pedType,
			model = v.model,
			networked = v.networked,
			distance = v.distance,
			settings = v.settings,
			flags = v.flags,
		}

		local seller = exports["np-npcs"]:RegisterNPC(data, "np-build")
		exports["np-npcs"]:EnableNPC(seller.id)
		Build.CurrentNPC[seller.id] = true


		for o,i in pairs(v.peek) do
			exports["np-interact"]:AddPeekEntryByFlag({ "isNPC" }, {
				{
				id = i.id..o,
				label = i.label,
				icon = i.icon,
				event = i.event,
				parameters = {},
				},
			}, {
				distance = { radius = 2.5 },
				npcIds = { seller.id },
			})
		end
	end
end

function Build.func.removeNPC()

	for k,v in pairs(Build.CurrentNPC) do
		exports["np-npcs"]:DisableNPC(k)
		exports["np-npcs"]:RemoveNPC(k)
	end

	Build.CurrentNPC = {}
end
