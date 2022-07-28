RegisterCommand("prssm:broadcast", function(src, args, raw)
    local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if currentVehicle and currentVehicle ~= 0 and args[1] then
        TriggerServerEvent("np-miscscripts:prssm:setTargetPlane", NetworkGetNetworkIdFromEntity(currentVehicle), args[1])
    end
end, false)

RegisterCommand("prssm:abort", function(src, args, raw)
    TriggerServerEvent("np-miscscripts:prssm:abort")
end, false)

RegisterNetEvent("np-miscscripts:prssm:setTargetPlane")
AddEventHandler("np-miscscripts:prssm:setTargetPlane", function(pPlane, pSound)
    local targetPlaneEntityId = NetworkGetEntityFromNetworkId(pPlane)
    if targetPlaneEntityId ~= nil or not pSound then
        StopStream()
        local timeoutCounter = 0
        while not LoadStream(pSound, "DLC_NIKEZ_MISC") do
            if timeoutCounter > 100000 then
                break
            end
            timeoutCounter = timeoutCounter + 1
            Wait(0)
        end
        PlayStreamFromVehicle(targetPlaneEntityId)
    end
end)

RegisterNetEvent("np-miscscripts:prssm:abort")
AddEventHandler("np-miscscripts:prssm:abort", function(pPlane)
    StopStream()
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        StopStream()
    end
end)