Ped = {}

AddEventHandler('baseevents:enteredVehicle', function (pVehicle)
    Ped.isInVehicle = true
    Ped.vehicleHandle = pVehicle
end)

AddEventHandler('baseevents:leftVehicle', function (pVehicle)
    Ped.isInVehicle = false
    Ped.vehicleHandle = nil
end)

RegisterNetEvent("evidence:bulletInformation", function(information)
    Ped.weaponInfo = information
end)

AddEventHandler('np-evidence:hotreload', function ()
    Ped.characterId = exports["isPed"]:isPed("cid")
end)

AddEventHandler('np-spawn:characterSpawned', function ()
    Ped.characterId = exports["isPed"]:isPed("cid")
end)

-- Player Ped loop
Citizen.CreateThread(function ()
    while true do
        local idle = 1000

        Ped.handle = PlayerPedId()

        Ped.playerId = PlayerId()

        Ped.coords = GetEntityCoords(Ped.handle)

        Ped.isArmed = IsPedArmed(Ped.handle, 7)

        Ped.weaponHash = Ped.isArmed and GetSelectedPedWeapon(Ped.handle) or nil

        Ped.weaponType = Ped.isArmed and GetWeapontypeGroup(GetSelectedPedWeapon(Ped.handle)) or nil

        Citizen.Wait(idle)
    end
end)

