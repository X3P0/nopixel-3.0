Apart.poly = {}
Apart.poly.zones = {[1] = {},[2] = {},[3] = {}}
Apart.poly.DefaultLength = 1.4
Apart.poly.DefaultWidth = 1.4
local listening = false
local typeVector = type(vector3(0.0,0.0,0.0))
local globalLocNumber = nil
local globalNumber = nil

function createZone(apartmentLocNumber,apartmentNumber)

    local options = {heading = 340, minZ = 0.0, maxZ = 0.0, data = {}}
    options.data = {
        LocNumber = apartmentLocNumber,
        apartmentNum = apartmentNumber
    }

    local boxCenter = Apart.Locations[1][1]

    local length = Apart.poly.DefaultLength
    local width = Apart.poly.DefaultWidth
    
    if type(Apart.Locations[apartmentLocNumber]) == typeVector then 
        boxCenter = Apart.Locations[apartmentLocNumber]
        length = 2.5
        width = 2.5
    else
        boxCenter = Apart.Locations[apartmentLocNumber][apartmentNumber]
    end

    options.minZ = boxCenter.z-1.0
    options.maxZ = boxCenter.z+1.0

    local zone = BoxZone:Create(boxCenter, length, width, options)

    zone:onPlayerInOut(function(isPointInside, point,moreData)
        if not isPointInside then
            polyHelperExit(zone.data.LocNumber,zone.data.apartmentNum)
        else
            polyHelperEnter(zone.data.LocNumber,zone.data.apartmentNum)
        end
    end, 500)

    Apart.poly.zones[apartmentLocNumber][apartmentNumber] = zone

end


function polyHelperExit(apartmentLocNumber,apartmentNumber)
    listening = false
    exports["np-ui"]:hideInteraction()
end

function polyHelperEnter(apartmentLocNumber,apartmentNumber)
    if listening then return end
    listening = true
    exports["np-ui"]:showInteraction(getInteractionMessage(apartmentLocNumber,apartmentNumber))
    listen(apartmentLocNumber,apartmentNumber)
end

function listen(apartmentLocNumber,apartmentNumber)
    Citizen.CreateThread(function()
        while listening do
            globalLocNumber = apartmentLocNumber
            globalNumber = apartmentNumber
            Wait(0)
        end

        globalLocNumber = nil
        globalNumber = nil
    end)
end

function getInteractionMessage(apartmentLocNumber,apartmentNumber)

    if apartmentLocNumber == Apart.currentRoomType and apartmentNumber == Apart.currentRoomNumber then
       return _L("apartments-ui-enter-more", "[H] to enter, [G] For More")
    end

    if Apart.currentRoomLocks[apartmentLocNumber] ~= nil and Apart.currentRoomLocks[apartmentLocNumber][apartmentNumber] ~= nil and Apart.currentRoomLocks[apartmentLocNumber][apartmentNumber] == false then
        return _L("apartments-ui-enter", "[H] to enter")
    else
        return _L("apartments-ui-more", "[G] For More")
    end
end

function destroyAllLockedZones()
    for i=1,#Apart.Locations do
        if type(Apart.Locations[i]) ~= typeVector then
            for k,v in pairs(Apart.poly.zones[i]) do
                local pass = true
                if i == Apart.currentRoomType and k == Apart.currentRoomNumber then pass = false end

                if Apart.currentRoomLocks[i][k] and pass then
                    v:destroy()
                    Apart.poly.zones[i][k] = nil
                end
            end
        end
    end
end


function createNewUnlockZones()
    for i=1,#Apart.Locations do
        if type(Apart.Locations[i]) ~= typeVector then
            for k,v in pairs(Apart.currentRoomLocks[i]) do
                if Apart.poly.zones[i][k] == nil then
                    if not Apart.currentRoomLocks[i][k] then
                        createZone(i,k)
                    end
                end
            end
        end
    end
end


local function showApartmentMenu(apartmentLocNumber,apartmentNumber)
    local Text = _L("apartments-ui-unlock", "Unlock")

    if Apart.currentRoomLocks[apartmentLocNumber][apartmentNumber] then    
        Text = _L("apartments-ui-unlock", "Unlock")
    else
        Text = _L("apartments-ui-lock", "Lock")
    end

    local unlockedApartments = {}

    for k,v in pairs(Apart.currentRoomLocks[apartmentLocNumber]) do
        if v == false then
            unlockedApartments[#unlockedApartments + 1] = { title = _L("apartments-ui-apartment", "Apartment") .. " # "..k, action = "np-ui:apartmentsContext", key = {"EnterUnlocked",apartmentLocNumber,k} }
        end 
    end
    
    local data = {}

    if Apart.defaultInfo[1] == apartmentLocNumber and Apart.defaultInfo[2] == apartmentNumber then
        data[#data+1] = {
            title = Text,
            description = _L("apartments-ui-description-lock-unlock", "Lock / Unlock Your apartment."),
            key = {"locks",apartmentLocNumber,apartmentNumber},
            action = "np-ui:apartmentsContext"
        }
    end


    data[#data+1] = {
        title = _L("apartments-ui-apartments", "Apartments"),
        description = _L("apartments-ui-description-enter-view", "View / Enter Unlocked Apartments."),
        key = {nil,apartmentLocNumber,apartmentNumber},
        children = unlockedApartments
    }

    local myjob = exports["isPed"]:isPed("myjob")
    
    if myjob == "police" or myjob == "judge" then

        local allApartments = {}
        local currentApartments = RPC.execute("apartment:allCurrentApartmentsOfRoomType",apartmentLocNumber) 

        for k,v in pairs(currentApartments) do
            local Locktext = _L("apartments-ui-apartment", "Apartment") .. " # "..k
            if Apart.currentRoomLockDown[apartmentLocNumber][v] then
                Locktext = _L("apartments-ui-removeapartment", "Remove Apartment") .. " # "..k
            end

            allApartments[#allApartments + 1] = {
                title = Locktext,
                description = _L("apartments-ui-description-lockdown", "Lockdown a Given Apartment."),
                key = {"lockdown",apartmentLocNumber,k},
                action = "np-ui:apartmentsContext"
            }
        end
        
        data[#data + 1] = {
            title = _L("apartments-ui-lockdown", "Lockdown"),
            description = _L("apartments-ui-description-lockdown", "Lockdown a Given Apartment."),
            key = {nil,apartmentLocNumber,apartmentNumber},
            children = allApartments
        }

        data[#data + 1] = {
            title = _L("apartments-ui-lockdown-cid", "Lockdown-CID"),
            description = _L("apartments-ui-description-lockdown-cid", "Lockdown a Given Apartment using CID."),
            key = {"lockdownCid",apartmentLocNumber,0},
            action = "np-ui:apartmentsContext"
        }
    end

    exports["np-ui"]:showContextMenu(data)
  end
  
  RegisterUICallback("np-ui:apartmentsContext", function(data, cb)
    local keyData = data.key
    local action = keyData[1]
    local loc = keyData[2]
    local room = keyData[3] 

    if action == "locks" then
        Apart.locksMotel(loc,room)
        exports["np-ui"]:showInteraction(getInteractionMessage(globalLocNumber,globalNumber))
    end

    if action == "EnterUnlocked" then
        Apart.enterMotel(room,loc)
    end

    if action == "lockdown" then
        TriggerServerEvent("apartment:serverLockdown",room,loc)
        exports["np-ui"]:showInteraction(getInteractionMessage(globalLocNumber,globalNumber))
    end

    if action == "lockdownCid" then
        
        exports["np-ui"]:hideInteraction()
        Wait(10)
        local elements = {
            { name = "cid", label = "Player CID", icon = "scroll" }
        }
    
        local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
            return type(tonumber(values.cid)) == 'number' and tonumber(values.cid) >= 1000
        end)

        if prompt == nil or prompt.cid == nil then return end 

        TriggerServerEvent("apartment:serverLockdownCID",prompt.cid,loc)

        Wait(100)
        showApartmentMenu(globalLocNumber,globalNumber)
    end

    cb({ data = {}, meta = { ok = true, message = "done" } })
  end)
  
  RegisterNetEvent('np-binds:keyEvent')
AddEventHandler('np-binds:keyEvent', function(name,onDown)
    if onDown then return end
    if not listening then return end

    if name == "housingSecondary" then
        exports["np-ui"]:hideInteraction()
        showApartmentMenu(globalLocNumber,globalNumber)
    end
    
    if name == "housingMain" then
        if Apart.defaultInfo[1] == globalLocNumber then
            listening = false
            exports["np-ui"]:hideInteraction()
            TriggerEvent("apartments:enterMotel",apartmentNumber, apartmentLocNumber)
        end
    end

end)