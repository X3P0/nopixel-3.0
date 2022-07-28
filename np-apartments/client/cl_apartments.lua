--[[
    Functions below: Outside markers / logic
    Description: below is the logic that displays markers outside and also determains other factors when close to the apartments
]]

Apart.currentRoomType = 1
Apart.currentRoomNumber = 1
Apart.defaultInfo = {Apart.currentRoomType,Apart.currentRoomNumber}
Apart.currentHotelInformation = nil
Apart.currentGarageNumber = 0

Apart.currentRoomLocks = {[1] = {},[2] = {},[3] = {}}
Apart.currentRoomLockDown = {[1] = {},[2] = {},[3] = {}}
Apart.plyCoords = nil

Apart.ClosestLocksObject = {}
Apart.Marker = false


local typeVector = type(vector3(0.0,0.0,0.0))


Citizen.CreateThread(function()
    --TriggerServerEvent("apartment:serverApartmentSpawn",1,false)
    --DoScreenFadeIn(1)
    -- Wait(3000)
    --TriggerEvent("apartments:spawnIntoRoom",false)
    while true do
        Citizen.Wait(1)
        Apart.plyCoords = GetEntityCoords(PlayerPedId())
        Wait(2000)
    end
end)

function Apart.buildSelfPoly()

    for k,v in pairs(Apart.info) do

        if Apart.defaultInfo[1] == v.apartmentType then
            createZone(v.apartmentType,Apart.defaultInfo[2])
        else
            createZone(v.apartmentType,999999)
        end

    end
    Apart.buildUnlocked()
end

function Apart.buildUnlocked()
    destroyAllLockedZones()
    createNewUnlockZones()
end

function Apart.displayMarkers(isDisplaying)

    if not isDisplaying then Apart.Marker = false return end
    if Apart.Marker then return end
    if isDisplaying then Apart.Marker = true end

    local ownApartmentCoords = Apart.Locations[1][1]

    if type(Apart.Locations[Apart.defaultInfo[1]]) == typeVector then
        ownApartmentCoords = Apart.Locations[Apart.defaultInfo[1]]
    else
        ownApartmentCoords = Apart.Locations[Apart.defaultInfo[1]][Apart.defaultInfo[2]]
    end

    Citizen.CreateThread(function()
        while Apart.Marker do
            Apart.plyCoords = GetEntityCoords(PlayerPedId())
            local dist = #(ownApartmentCoords-Apart.plyCoords)
            if dist <= 20 then
                DrawMarker(20,ownApartmentCoords, 0, 0, 0, 0, 0, 0, 0.701,1.0001,0.3001, 0, 155, 255, 200, 0, 0, 0, 0)
            end

            for i=1,#Apart.currentRoomLocks do
                if type(Apart.Locations[i]) ~= typeVector then
                    for k,v in pairs(Apart.currentRoomLocks[i]) do
                        if v == false and k ~= Apart.currentRoomNumber then
                            if type(Apart.Locations[i][k]) == typeVector then
                                local dist = #(Apart.Locations[i][k]-Apart.plyCoords)
                                if dist <= 20 then
                                    DrawMarker(20,Apart.Locations[i][k], 0, 0, 0, 0, 0, 0, 0.701,1.0001,0.3001, 255, 100, 100, 40, 0, 0, 0, 0)
                                end
                            end
                        end
                    end
                end
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent('np-binds:keyEvent')
AddEventHandler('np-binds:keyEvent', function(name,onDown)
    if name ~= "PlayerList" then return end
    Apart.displayMarkers(onDown)
end)





function Apart.locksMotel()

    if Apart.currentRoomLockDown[Apart.currentRoomType][Apart.currentRoomNumber] then
        TriggerEvent("DoLongHudText", _L("apartments-lock-lockdown", "Apartment on lockdown , you may not change the lock"),2)
        return
    end

    TriggerEvent("dooranim")
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'keydoors', 0.4)
    TriggerServerEvent("apartments:ToggleLocks",Apart.currentRoomType,Apart.currentRoomNumber)
    Citizen.Wait(500)

end
RegisterNetEvent("apartments:locksMotel");
AddEventHandler("apartments:locksMotel", Apart.locksMotel);

--[[
    Functions below: Client update functions
    Description: below is logic for entering / exiting the motel
]]

RegisterNetEvent('apartments:apartmentSpawn')
AddEventHandler('apartments:apartmentSpawn', function(apartmentTable,currentID)
    Apart.currentRoomType = apartmentTable.roomType
    Apart.currentRoomNumber = currentID
    Apart.defaultInfo = {Apart.currentRoomType,Apart.currentRoomNumber}
    Apart.buildSelfPoly()
end)

RegisterNetEvent('apartments:apartmentLocks')
AddEventHandler('apartments:apartmentLocks', function(lockTable)
    Apart.currentRoomLocks = lockTable
    Apart.buildUnlocked()
end)

RegisterNetEvent('apartments:apartmentLockDown')
AddEventHandler('apartments:apartmentLockDown', function(lockdownTable)
    Apart.currentRoomLockDown = lockdownTable
end)


--[[
    Functions below: Spawning Methid
    Description: below is logic for when a player spawns
]]


RegisterNetEvent('apartments:spawnIntoRoom')
AddEventHandler('apartments:spawnIntoRoom', function(isNew,spawnOutSide)
    Apart.enterMotel(nil,nil,true,spawnOutSide)
end)

--[[
    Functions below: Loading / Entry / exit
    Description: below is logic for entering / exiting the motel
]]

function Apart.enterMotel(roomNumber,roomType,isSpawn,spawnOutSide)

    local myjob = exports["isPed"]:isPed("myjob")

    if not isSpawn then
        TriggerEvent("dooranim")
        TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)
    end

    if roomNumber == nil then
        roomNumber = Apart.currentRoomNumber
        roomType = Apart.currentRoomType
    else
        Apart.currentRoomNumber = roomNumber
        Apart.currentRoomType = roomType
    end

    if not spawnOutSide and not Apart.currentRoomLocks[roomType][roomNumber] and Apart.currentRoomLockDown[roomType][roomNumber] then
        if myjob ~= "police" and myjob ~= "judge" then
            TriggerEvent("DoLongHudText",_L("apartments-enter-lockdown", "Apartment on lockdown , only Police or DOJ may enter"),2)
            return
        end
    end

    local info = RPC.execute("GetMotelInformation",Apart.currentRoomType,Apart.currentRoomNumber)
    Apart.currentHotelInformation = info[1]

    Apart.processBuildType(roomNumber,roomType,isSpawn,spawnOutSide)

    if spawnOutSide then
        Apart.leaveApartment()
        return
    end
end
RegisterNetEvent("apartments:enterMotel");
AddEventHandler("apartments:enterMotel", Apart.enterMotel);


function Apart.processBuildType(numMultiplier,roomType,isSpawn,spawnOutSide)
    DoScreenFadeOut(1)

    TriggerEvent("inhotel",true, roomType)

    local name = ""
    name = Apart.FindCurrentRoom(roomType)

    local isBuiltCoords = exports["np-build"]:getModule("func").buildRoom(name,numMultiplier,false)

    if isBuiltCoords then

        --DoScreenFadeIn(100)
        SetEntityInvincible(PlayerPedId(), false)
        FreezeEntityPosition(PlayerPedId(),false)

        if isSpawn then
            local cid = exports["isPed"]:isPed("cid")

            Apart.WakeFromBed()

            TriggerEvent("np-spawn:characterSpawned", cid)
        else
            TriggerEvent('InteractSound_CL:PlayOnOne','DoorClose', 0.7)
        end
        if not spawnOutSide then
            DoScreenFadeIn(500)
        end
    end
end

function Apart.leaveApartment()
    local spawnInApartmentsOnly = (exports["np-config"]:GetMiscConfig("spawn.apartments.only") or false)
	if spawnInApartmentsOnly then
        TriggerEvent("DoLongHudText", "You can't leave yet", 2)
		return
	end
    TriggerEvent("dooranim")
    TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)
    Wait(330)

    if Apart.exitPoint[Apart.currentRoomType] == nil then
        exports["np-build"]:getModule("func").exitCurrentRoom(Apart.Locations[Apart.currentRoomType][Apart.currentRoomNumber])
    else
        if type(Apart.exitPoint[Apart.currentRoomType]) == typeVector then
            exports["np-build"]:getModule("func").exitCurrentRoom(Apart.exitPoint[Apart.currentRoomType])
        else
            local rnd = math.random(1,#Apart.exitPoint[Apart.currentRoomType])
            exports["np-build"]:getModule("func").exitCurrentRoom(Apart.exitPoint[Apart.currentRoomType][rnd])
        end
    end

    if type(Apart.Locations[Apart.currentRoomType]) == typeVector then

    else

    end


    Apart.currentRoomNumber = Apart.defaultInfo[2]
    Apart.currentRoomType = Apart.defaultInfo[1]
    Apart.currentHotelInformation = nil

    Citizen.Wait(100)
    TriggerEvent("dooranim")
    TriggerEvent('InteractSound_CL:PlayOnOne','DoorClose', 0.7)
    TriggerEvent("attachWeapons")


end
RegisterNetEvent("apartments:leave");
AddEventHandler("apartments:leave", Apart.leaveApartment);


--[[
    Functions below: Inside of apartment
    Description: functions that are used inside of the apartments
]]


function Apart.logout()

    Apart.currentRoomNumber = Apart.defaultInfo[2]
    Apart.currentRoomType = Apart.defaultInfo[1]
    Apart.currentHotelInformation = nil
    
    TransitionToBlurred(500)
    DoScreenFadeOut(500)
    Citizen.Wait(1000)
    TriggerServerEvent("jobssystem:jobs", "unemployed")
    exports["np-build"]:getModule("func").CleanUpArea()
    TriggerEvent("inhotel", false)
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("np-jobmanager:onCharSwap", cid)
    Citizen.Wait(1000)
    TriggerEvent("np-base:clearStates")
    exports["np-ui"]:sendAppEvent("hud", { display = false })
    TriggerServerEvent("apartments:cleanUpRoom")
    exports["np-base"]:getModule("SpawnManager"):Initialize()

    Citizen.Wait(1000)
end

RegisterNetEvent("apartments:Logout");
AddEventHandler("apartments:Logout", Apart.logout);


function Apart.openHotelStash()

    local myjob = exports["isPed"]:isPed("myjob")
    if Apart.currentRoomLockDown[Apart.currentRoomType][Apart.currentRoomNumber] and (myjob ~= "police" and myjob ~= "judge") then
        TriggerEvent("DoLongHudText",_L("apartments-stash-lockdown", "Apartment on lockdown , you may not open the stash"),2)
        return
    end

    if Apart.defaultInfo[1] == Apart.currentRoomType and Apart.defaultInfo[2] == Apart.currentRoomNumber then -- owner
        Apart.OpenStash()
    else -- not owner kek


        if Apart.currentRoomLockDown[Apart.currentRoomType][Apart.currentRoomNumber] and (myjob == "police" or  myjob == "judge") then
            Apart.OpenStash()
        end
    end
end
RegisterNetEvent("apartments:stash");
AddEventHandler("apartments:stash", Apart.openHotelStash);

function Apart.OpenStash()

    TriggerEvent('InteractSound_CL:PlayOnOne','StashOpen', 0.6)
    TriggerEvent("server-inventory-open", "1", "motel-"..Apart.currentRoomType.."-"..Apart.currentHotelInformation.cid)
    TriggerEvent("actionbar:setEmptyHanded")
end

function leaveToGarage()

    TriggerEvent("dooranim")
    TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)
    Wait(330)

    exports["np-build"]:getModule("func").CleanUpArea()
    DoScreenFadeOut(1)

    Apart.currentGarageNumber = Apart.currentRoomNumber

    Apart.processBuildType(Apart.currentGarageNumber,111)

end
RegisterNetEvent("apartments:garage");
AddEventHandler("apartments:garage", leaveToGarage);


function garageToHouse()

    exports["np-build"]:getModule("func").CleanUpArea()
    Apart.processBuildType(Apart.currentGarageNumber,3)
    Apart.currentGarageNumber = 0


    TriggerEvent("attachWeapons")

end
RegisterNetEvent("apartments:garageToHouse");
AddEventHandler("apartments:garageToHouse", garageToHouse);

function garageToWorld()

    exports["np-build"]:getModule("func").exitCurrentRoom(vector3(4.67, -724.85, 32.18))
    Apart.currentRoomNumber = Apart.defaultInfo[2]
    Apart.currentRoomType = Apart.defaultInfo[1]
    Apart.currentHotelInformation = nil
    Apart.currentGarageNumber = 0

    TriggerEvent("attachWeapons")
end
RegisterNetEvent("apartments:garageToWorld");
AddEventHandler("apartments:garageToWorld", garageToWorld);

function Apart.WakeFromBed()
    local bedOffset = exports["np-build"]:getModule("func").getCurrentBed()

    if bedOffset ~= false then
        SetEntityCoords(PlayerPedId(),bedOffset.x,bedOffset.y,bedOffset.z-0.9)
        SetEntityHeading(PlayerPedId(),bedOffset.w+90)
        TriggerEvent("animation:PlayAnimation","getup")
    end

end

--[[
    Functions below: Clothing / outfits
    Description: Checks for outfit shit
]]

local outfitPlaces = {
  vector3(-1181.89,-901.35,13.99), -- burger shot
  vector3(-1680.15,-1091.59,13.16), -- burger shot pier
  vector3(995.04,-0.54,71.47), -- casino
  vector3(100.51,3615.85,40.92), -- lost mc
  vector3(108.11, -1305.15, 28.79), -- VU
  vector3(-164.08, 314.89, 98.87), -- Roosters
  vector3(-1427.92, -459.37, 35.90), -- Hayes
  vector3(1002.71,56.2,75.06), -- Casino Office
  vector3(1070.83,-2315.6,22.33), -- Starscream lab
  vector3(2296.24, 4850.33, 33.91), -- Optimus Prime lab
  vector3(371.3661, 3564.562, 25.6122), -- Bumbleebee lab
  vector3(1158.93,-443.83,67.02), --Yoga
  vector3(-1564.32, 774.67, 189.19), --Parsons
  vector3(321.83,185.71,103.59), -- tattoo shop
  vector3(1187.58,2636.2,38.41), --harmony
  vector3(-22.74,-209.22,46.31), --Driving school
  vector3(-1868.69,2955.0,32.82), --Flight school
  vector3(2382.02,2549.7,59.27), -- paintball
  vector3(-590.42, -915.17, 23.78), --news center
  vector3(-600.69,-915.88,28.84), --LSBN
  vector3(1834.69,2572.25,46.02), --Prison DOC office
  vector3(1738.08,2497.26,45.82), --Prison clothes
  vector3(-141.6, 220.1, 95.0), --Comic store
  vector3(-27.63,-1104.03,26.43), -- pdm
  vector3(-469.74,43.13,46.24), -- gallery office
  vector3(-446.6,-45.25,49.37), -- gallery warehouse
  vector3(841.36,-824.51,26.33), -- ottos
  vector3(-1791.03,437.68,128.29), -- clean manor
  vector3(-524.16,-193.5,38.22), -- court house
  vector3(1077.63,-1972.66,31.48), -- sionis
  vector3(314.6,-566.03,43.29), -- pillbox first surgery room
  vector3(1209.92,-3121.66,5.55), -- afterlife tuning
  vector3(5491.13,6002.27,590.56), -- paintball arena
  vector3(1769.89,3323.99,41.44), -- iron hog
  vector3(153.31,-3011.02,7.05), --tuner shop
  vector3(-429.1,271.48,83.02), --split sides (mainly for public)
  vector3(-568.62,291.58,79.18), --teqilala
  vector3(-586.92,-1050.05,22.35), -- uwu
  vector3(-581.1, -898.35, 30.2), -- maldinis
  vector3(-24.1,-1436.37,30.66), -- aunties
  vector3(-717.56,639.5,159.17), -- saco
  vector3(-1980.37,-501.0,20.74), -- saco beach
  vector3(-817.04,267.26,82.8), -- hades
  vector3(986.7,-92.91,74.85), -- Sinister Souls
  vector3(-132.42,-633.08,168.83), -- cbc
  vector3(-446.06,-2819.06,6.01), -- dodo
  vector3(-1234.58,-2981.44,-41.26), -- unknown location
  vector3(-52.96, -2525.25, 7.41), -- overboost
  vector3(1469.93, 6550.95, 14.9), -- gm
  vector3(91.48,-1430.4,29.43), -- kiki's organic clothing
  vector3(-726.1,-1123.75,10.84), -- pawnshop
  vector3(839.16,-3244.82,-98.69), -- bunker
  vector3(1169.78,-401.06,67.48), -- liquidlibrary staff
  vector3(1153.08,-422.75,67.48), -- liquidlibrary curator
  vector3(801.51,-829.00,26.33), -- otto's pdm
  vector3(-520.36,-2201.53,6.44), -- redline
  vector3(-788.23, 338.69, 243.38), -- bash apartment
  vector3(-816.18,-716.32,28.07), -- wuchang cloak room
  vector3(-839.43,-718.12,28.29), -- wuchang stage
  vector3(138.98,111.51,64.98), -- Vendetta garage change room
  vector3(-811.74, 175.21, 76.75), -- Bean Manor
}

AddEventHandler("np-apartments:addOutfitSpot", function(pCoords)
    outfitPlaces[#outfitPlaces + 1] = pCoords
end)
local cidsForAnywhere = { -- some people are invisible, let them swap anywhere
  [1006] = true,
  [1249] = true,
  [3503] = true,
  [7856] = true,
  [7451] = true,
  [25827] = true,
  [25813] = true,
  [25931] = true,
  [26152] = true,
  [27121] = true,
}
function nearClothing()
    local isNear = exports["np-build"]:getModule("func").isNearCurrentInteract(1,5.5)
    if isNear then
        return true
    end

    for _, place in pairs(outfitPlaces) do
      if #(place - GetEntityCoords(PlayerPedId())) < 2.5 then
        return true
      end
    end

    local myjob = exports["isPed"]:isPed("myjob")
    if myjob == "police" or myjob == "ems" or myjob == "doctor" or myjob == "therapist" then
        return true
    end

    local characterId = exports["isPed"]:isPed("cid")
    if cidsForAnywhere[characterId] then
        return true
    end

    return false
end

exports('nearClothing', nearClothing)

--[[
    Functions below: Raid and /commands
    Description: events to handle /commands
]]

RegisterNetEvent('apartment:removeFromBuilding')
AddEventHandler('apartment:removeFromBuilding', function(roomNumber,buildType)
    if Apart.currentRoomType == buildType and Apart.currentRoomNumber == roomNumber then
        if exports["np-build"]:getModule("func").isInBuilding() then
            Apart.leaveApartment()
        end
    end
end)

RegisterNetEvent('apartment:attemptEntry')
AddEventHandler('apartment:attemptEntry', function(roomNumberSent)
    local roomNumber,roomType = Apart.FindApartmentGivenNumber(roomNumberSent)

    if not roomNumber and not roomType then return end

    local isValid = RPC.execute("IsValidRoom",roomType,roomNumber)

    if isValid then
        if Apart.currentRoomLocks[roomType][roomNumber] == false then
            Apart.enterMotel(roomNumber,roomType)
        else
            TriggerEvent("DoLongHudText","Apartment is Locked",2)
        end
    end

end)


RegisterUICallback("np-apartments:handler", function(data, cb)
    local eventData = data.key
    if eventData.forclose then
        Apart.func.getOwner(true)
    end
    cb({ data = {}, meta = { ok = true, message = "done" } })
end)


RegisterNetEvent('apartments:menuAction')
AddEventHandler('apartments:menuAction', function(action)
    if action == "lockdown" then
        TriggerEvent("apartment:lockdown")
    elseif action == "checkOwner" then
        Apart.func.getOwner()
    elseif action == "forfeit" then
        exports["np-ui"]:showContextMenu(MenuData["apartment_check"])
    end

end)

RegisterNetEvent('apartment:lockdown')
AddEventHandler('apartment:lockdown', function(roomNumberSent)
    local roomNumber,roomType = Apart.FindApartmentGivenNumber(roomNumberSent)

    if not roomNumber and not roomType then return end

    TriggerServerEvent("apartment:serverLockdown",roomNumber,roomType)

end)


RegisterNetEvent('apartment:ringBell')
AddEventHandler('apartment:ringBell', function(roomNumberSent)

    local roomNumber,roomType = Apart.FindApartmentGivenNumber(roomNumberSent)

    if not roomNumber and not roomType then return end

    local isValid = RPC.execute("IsValidRoom",roomType,roomNumber)

    if isValid then
        -- ring bell , need to talk with DW

    end

end)

Apart.defaultInfo = {Apart.currentRoomType,Apart.currentRoomNumber}

function Apart.func.currentApartment()

    local result = ""
    if Apart.MaxRooms[Apart.defaultInfo[1]] == false then
        local coords = Apart.Locations[Apart.defaultInfo[1]][Apart.defaultInfo[2]]
        local streetName , crossingRoad = GetStreetNameAtCoord(coords.x,coords.y,coords.z)
        result = ""..GetStreetNameFromHashKey(streetName).." "..GetStreetNameFromHashKey(crossingRoad)
    end

    if Apart.MaxRooms[Apart.defaultInfo[1]] ~= false then
        result = Apart.info[Apart.defaultInfo[1]].apartmentStreet
    end

    local info = {
        roomType = Apart.defaultInfo[1],
        roomNumber = Apart.defaultInfo[2],
        streetName = result
    }

    return info
end


function Apart.func.upgradeApartment(apartmentTargetType)


    if apartmentTargetType <= Apart.defaultInfo[1] then return false, _L("apartments-downgrade-error", "Cannot downgrade") end
    if apartmentTargetType > #Apart.info then return false, _L("apartments-upgrade-invalid", "Not a valid Apartment") end
    local apartmentInfo = RPC.execute("getApartmentInformation")
    if apartmentInfo == nil then return false, _L("apartments-information-error", "Failed to gather info") end

    local hasBankAccount, bankAccountId = RPC.execute("GetDefaultBankAccount", exports["isPed"]:isPed("cid"))

    if hasBankAccount then
        local comment = _L("apartments-upgrade-from", "Upgraded from apartment type") .. " ["..Apart.defaultInfo[1].."] " .. _L("apartments-upgrade-to", "to apartment type") .. " ["..apartmentTargetType.."]"
        local success, message = RPC.execute("DoTransaction", bankAccountId, 1 , apartmentInfo[apartmentTargetType].apartmentPrice, comment, 1, 1)

        if success then

            local isComplete = RPC.execute("upgradeApartment",apartmentTargetType,Apart.defaultInfo[1],Apart.defaultInfo[2])
            local info = Apart.func.currentApartment()

            return isComplete, info
        else
            return false, message
        end
    else
        return false, _L("apartments-bank-error", "Failed to find bank account")
    end

end

function Apart.func.gpsApartment(housingName)



    local result = ""
    local coordsEnd = nil
    local found = false

    for i,_ in pairs(Apart.MaxRooms) do
        if Apart.MaxRooms[i] == false and not found then
            for k,v in pairs(Apart.Locations[i]) do
                local coords = v
                local streetName , crossingRoad = GetStreetNameAtCoord(coords.x,coords.y,coords.z)
                result = ""..GetStreetNameFromHashKey(streetName).." "..GetStreetNameFromHashKey(crossingRoad)
                if housingName == result then

                    coordsEnd = coords
                    found = true
                    break
                end
            end

            if Apart.info[i].apartmentStreet == housingName then
                found = true
                coordsEnd = Apart.Locations[i][1]
            end


        elseif Apart.MaxRooms[i] ~= false then
            result = Apart.info[i].apartmentStreet
            if housingName == result then
                found = true
                coordsEnd = Apart.Locations[i]
            end
        end
        if found then break end
    end

    if coordsEnd ~= nil and found then
        SetNewWaypoint(coordsEnd.x,coordsEnd.y)
    end

end


function Apart.func.getOwner(isForclose)

    local roomNumber,roomType = Apart.FindApartmentGivenNumber(roomNumberSent)

    if not roomNumber and not roomType then return end

    local isValid = RPC.execute("IsValidRoom",roomType,roomNumber)

    if isValid then
        if isForclose then
            RPC.execute("apartment:forclose",roomType,roomNumber)
        else
            RPC.execute("apartment:getOwner",roomType,roomNumber)
        end
    end

end


function Apart.func.getApartment()

    if(Apart.currentHotelInformation == nil) then return nil end

    local returnStatement = {
        roomType = Apart.currentRoomType,
        roomNumber = Apart.currentRoomNumber,
    }

    return returnStatement
end

RegisterNetEvent("np-spawn:characterSpawned", function(cid)
    TriggerServerEvent("np-spawn:characterSpawnedServer", cid)
end)
