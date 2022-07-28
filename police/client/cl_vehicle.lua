RegisterNetEvent("police:impoundVehicle")
AddEventHandler("police:impoundVehicle", function(pArgs, pEntity, pContext)
  TriggerServerEvent("police:impoundVehicle", VehToNet(pEntity))
end)