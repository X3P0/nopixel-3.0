local EnableDebug = false

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(0)
		end
	end
end

function GetEntityInFrontOfPlayer(distance, ped)
	local coords = GetEntityCoords(ped, 1)
	local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, distance, 0.0)
	local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, offset.x, offset.y, offset.z, -1, ped, 0)
	local a, b, c, d, entity = GetRaycastResult(rayHandle)
	return entity
end

function Debug(msg, ...)
	if not EnableDebug then return end

	local params = {}

	for _, param in ipairs({...}) do
		if type(param) == "table" then
			param = json.encode(param)
		end

		table.insert(params, param)
	end

	print((msg):format(table.unpack(params)))
end