
function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end

RegisterNetEvent("SaveCommand")
AddEventHandler("SaveCommand", function(args, isJSON)
	local textString = ""
	for i = 2, #args do
		textString = textString .. " " .. args[i]
	end
	x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	local PlayerName = GetPlayerName(PlayerId())
	Citizen.Trace(""..tD(x)..","..tD(y)..","..tD(z)..","..tD(GetEntityHeading(PlayerPedId())).."")
	TriggerServerEvent( "SaveCoords", PlayerName , tD(x) , tD(y) , tD(z), tD(GetEntityHeading(PlayerPedId())), textString, isJSON )		

end)


RegisterNetEvent("coordOffset")
AddEventHandler("coordOffset", function(args)
	local textString = ""
	for i = 2, #args do
		textString = textString .. " " .. args[i]
	end
	
	local buildingVector = exports["np-build"]:getModule("func").currentBuildingVector()

	if buildingVector ~= false then
		local v = (GetEntityCoords(PlayerPedId()) - buildingVector)
		
		
		local PlayerName = GetPlayerName(PlayerId())

		Citizen.Trace(""..tD(v.x)..","..tD(v.y)..","..tD(v.z)..","..tD(GetEntityHeading(PlayerPedId())).."")

		TriggerServerEvent("SaveCoordsOffset", PlayerName , tD(v.x) , tD(v.y) , tD(v.z), tD(GetEntityHeading(PlayerPedId())), textString )
	else
		TriggerEvent("DoLongHudText","You are not in building , so no offset for you",2)
	end		

end)
