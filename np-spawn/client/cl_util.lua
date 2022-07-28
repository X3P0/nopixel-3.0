function VecLerp(x1, y1, z1, x2, y2, z2, l, clamp)
    if clamp then
        if l < 0.0 then l = 0.0 end
        if l > 1.0 then l = 1.0 end
    end
    local x = Lerp(x1, x2, l)
    local y = Lerp(y1, y2, l)
    local z = Lerp(z1, z2, l)
    return vector3(x, y, z)
end

function Lerp(a, b, t)
    return a + (b - a) * t
end

function LocationInWorld(coords,camera)

    local position = GetCamCoord(camera)

    --- Getting Object using raycast
    local ped = PlayerPedId()
    local raycast = StartShapeTestRay(position.x,position.y,position.z, coords.x,coords.y,coords.z, 8, ped, 0)
    local retval, hit, endCoords, surfaceNormal, entity = GetShapeTestResult(raycast)
    
    return entity

end

function CleanUpArea()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped) and distance < 90.0 then
            distanceFrom = distance
            DeleteEntity(ped)

        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == PlayerPedId() then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end


function Spawn.obtainApartmentType(spawnInfo)
    local found = false
    for k,v in pairs(Spawn.motel) do
        if v.info == spawnInfo then 
            found = k
        end
    end
    return found 
end

function Spawn.obtainWorldSpawnPos(spawnName)
    local found = false
    for k,v in pairs(Spawn.defaultSpawns) do
        if v.info == spawnName then 
            found = v.pos
        end
    end

    local dev = Spawn.getDevSpawn()
    local rooster = Spawn.getRoosterSpawn()

    if spawnName == "Crash Location" then
        found = Spawn.Crash
        Spawn.Crash = nil
    end

    if dev and dev.info == spawnName then 
        found = dev.pos
    end

    if rooster and rooster.info == spawnName then 
        found = rooster.dev
    end

    if Spawn.hotelRooms[spawnName] ~= nil then
        found = Spawn.hotelRooms[spawnName]
    end

    if Spawn.businessSpawnsInfo[spawnName] ~= nil then
        found = Spawn.businessSpawnsInfo[spawnName].pos
    end

    return found 
end

function Spawn.shallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

-- temp function REMOVE WHEN REMOVING TEMPT FIX FOR HOUSING / OFFICES 
function Spawn.obtainHousingPos(spawnInfo)
    local found = false
    for k,v in pairs(Spawn.tempHousing) do
        if v.info == spawnInfo then 
            found = v.pos
        end
    end
    return found 
end

--[[
    Functions below: 2dTo3dWorld char finder
    Description: takes the outcome of 2dto3dworld and finds the corrisponding ped and generates info for them
]]

function findCharPed(ped,isHover)
    if ped == 0 and Login.Selected and not isHover then
        Login.CurrentPedInfo = nil
        return nil
    end

    if ped == 0 and not Login.Selected and isHover then
        Login.CurrentPedInfo = nil
        return nil
    end

    if ped ~= 0 then
        if ped == Login.CurrentPed and Login.CurrentPedInfo ~= nil then 
            return Login.CurrentPedInfo
        else
            if (not isHover and Login.Selected) or (not Login.Selected) then
                local pedCoords =  GetEntityCoords(ped)
                for i = 1, getCharLimit() do
                    if Login.CreatedPeds[i] ~= nil then
                        local spawnPos = vector3(Login.spawnLoc[i].x, Login.spawnLoc[i].y, Login.spawnLoc[i].z)
                        local dist = #(pedCoords - spawnPos)
                        if dist <= 1.0 then
                            Login.CurrentPed = ped
                            Login.CurrentPedInfo = {
                                charId = Login.CreatedPeds[i].charId,
                                position = i
                            }
                        end
                    end
                end
            end
        end
    end
    return Login.CurrentPedInfo
end

function getCharLimit()
  local charactersLimited = exports["np-config"]:GetMiscConfig("characters.limited")
  if not charactersLimited then
    return exports["np-config"]:GetModuleConfig("main").characterLimit
  end

  local userData = exports["np-base"]:getModule("LocalPlayer")

  if userData and userData:getVar("CustomCharacterSlots") then
    return userData:getVar("CustomCharacterSlots")
  end

  return exports["np-config"]:GetModuleConfig("main").characterLimit
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
