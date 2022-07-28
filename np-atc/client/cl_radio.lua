local currentAircraft = nil

AddEventHandler('baseevents:enteredVehicle', function (pVehicle, pSeat, pName, pClass, pModel)
    if pClass ~= 15 and pClass ~= 16 then return end

    currentAircraft = pVehicle

    if pSeat ~= -1 and pSeat ~= 0 then return end

    TriggerEvent('np-voice:atc:connect')
end)

AddEventHandler('baseevents:leftVehicle', function (pVehicle, pSeat, pName, pClass, pModel)
    if pClass ~= 15 and pClass ~= 16 or pSeat ~= -1 and pSeat ~= 0 then return end

    currentAircraft = nil

    TriggerEvent('np-voice:atc:disconnect')
end)

AddEventHandler('baseevents:vehicleChangedSeat', function (pVehicle, pCurrent, pPrevious)
    if pVehicle ~= currentAircraft then return end

    if (pCurrent == -1 or pCurrent == 0) and (pPrevious ~= -1 and pPrevious ~= 0) then
        TriggerEvent('np-voice:atc:connect')
    elseif (pCurrent ~= -1 and pCurrent ~= 0) and (pPrevious == -1 or pPrevious == 0) then
        TriggerEvent('np-voice:atc:disconnect')
    end
end)