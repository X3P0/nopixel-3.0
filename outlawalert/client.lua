--Config
local timer = 0 --in minutes - Set the time during the player is outlaw
local showOutlaw = false --Set if show outlaw act on map
local gunshotAlert = true --Set if show alert when player use gun
local carJackingAlert = true --Set if show when player do carjacking
local meleeAlert = true --Set if show when player fight in melee
local blipGunTime = 60 --in second
local blipMeleeTime = 60 --in second
local blipJackingTime = 60 -- in second
local blipDeathTime = 360 -- in second
local isInService = false
--End config

local origin = false --Don't touche it
local timing = timer * 60000 --Don't touche i


isCop = false
inServerRoom = false

local function shouldSendPing()
    return (not isCop) and (not inServerRoom)
end

RegisterNetEvent('nowCopSpawn')
AddEventHandler('nowCopSpawn', function()
    isCop = true
end)

RegisterNetEvent('nowCopSpawnOff')
AddEventHandler('nowCopSpawnOff', function()
    isCop = false
end)

AddEventHandler("np-menu:var:inServerFarm", function(pBool)
    inServerRoom = pBool
end)

HudStage = 1
RegisterNetEvent("disableHUD")
AddEventHandler("disableHUD", function(passedinfo)
  HudStage = passedinfo
  if HudStage > 2 then
    TriggerEvent("chat:clear")
  end
end)


RegisterNetEvent('outlawNotifyPhone')
AddEventHandler('outlawNotifyPhone', function(player, info)
    if not DoesPlayerExist(player) then return end
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(player)
    if sonid == -1 then
        -- fix non existing users.
        return
    end
    local phoneNumber = string.sub(info.phone_number, 0, 3) .. '-' .. string.sub(info.phone_number, 4, 6) .. '-' .. string.sub(info.phone_number, 7, 10)
    if sonid == monid then
        TriggerEvent('chatMessage', "", {30, 144, 255}, "^5Phone Number: " .. phoneNumber .. "", "feed", false, { i18n = { "Phone Number" }})
    elseif #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 19.999 then
        TriggerEvent('chatMessage', "", {30, 144, 255}, "^5Phone Number: " .. phoneNumber .. "", "feed", false, { i18n = { "Phone Number" }})
    end
end)

RegisterNetEvent('outlawNotifyChat311')
AddEventHandler('outlawNotifyChat311', function(args, caller)
    table.remove(args, 1)
    if isInService then
        TriggerEvent('chatMessage', "^5[311]", 3, " (^1 Caller ID: ^3 | "..caller.."^0 ) " .. table.concat(args, " "))
        PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", "", 0, 1)
    end
end)

RegisterNetEvent('outlawNotifyChat311r')
AddEventHandler('outlawNotifyChat311r', function(args, caller)
    table.remove(args, 1)
    if isInService then
        TriggerEvent('chatMessage', "311 RESPONSE:", 3, "^3 Sent to: " .. source .. ": ^7" .. table.concat(args, " ") .. " ")
    end
end)

RegisterNetEvent('outlawNotifyChat')
AddEventHandler('outlawNotifyChat', function(args, caller)
    table.remove(args, 1)
    if isInService then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        TriggerEvent('chatMessage', "^5[911]", 3, " (^1 Caller ID: ^3 | "..caller.."^0 ) " .. table.concat(args, " "))
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end)

RegisterNetEvent('callsound')
AddEventHandler('callsound', function()
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
end)


RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
	if job == "police" or job == "ems" then
		isInService = true
	else
		isInService = false
	end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end


RegisterNetEvent('judgeAnnouceGetChat')
AddEventHandler('judgeAnnouceGetChat', function()

    local amount = KeyboardInput("Enter Message:","",255)
    if amount == nil or amount == "" then return end
    TriggerServerEvent("judgeAnnounce",amount)
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
  TriggerEvent("hud:insidePrompt",true)
  AddTextEntry('FMMC_KEY_TIP1', TextEntry)
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
  blockinput = true

  while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
    Citizen.Wait(0)
  end

  if UpdateOnscreenKeyboard() ~= 2 then
    local result = GetOnscreenKeyboardResult()
    Citizen.Wait(500)
    blockinput = false
    TriggerEvent("hud:insidePrompt",false)
    return result
  else
    Citizen.Wait(500)
    blockinput = false
    TriggerEvent("hud:insidePrompt",false)
    return nil
  end

end


--Star color
--[[1- White
2- Black
3- Grey
4- Clear grey
5-
6-
7- Clear orange
8-
9-
10-
11-
12- Clear blue
15 - tweet notification
16 - sms notification


]]

local waitKeys = false

--1 basic notification
--2 error msg
--3 System Msg / Admin shit

-- same color notification
--4 Seat Belt
--5 Police vehicle actions
--6 Body Stress
--7 housing related
--8 purchase item
--9 engine toggle
--10 phone noticiations
--11 cruise actived
--12 fish winner
--14 race countdown
--15 Gang Update notification

RegisterNetEvent('DoLongHudText')
AddEventHandler('DoLongHudText', function(text,color,length,opts)
    if HudStage > 2 then return end
    if not color then color = 1 end
    if not length then length = 12000 end
    swappedText = exports["np-i18n"]:GetStringSwap(text, ((opts and opts.i18n) and opts.i18n or false))
    TriggerEvent("tasknotify:guiupdate", color, swappedText, 12000)
    Citizen.CreateThread(function()
        if opts and opts.i18n then
            for _, v in pairs(opts.i18n) do
                TriggerEvent("i18n:translate", v, "DoLongHudText")
                Wait(500)
            end
        else
            TriggerEvent("i18n:translate", text, "DoLongHudText")
        end
    end)
end)

RegisterNetEvent('DoLHudText')
AddEventHandler('DoLHudText', function(color, key, text, ...)
    if HudStage > 2 then return end
    if not color then color = 1 end
    TriggerEvent("tasknotify:guiupdate",color, _L(key, text, ...), 12000)
    TriggerEvent("i18n:translate", text, "DoLHudText")
end)

RegisterNetEvent('DoShortHudText')
AddEventHandler('DoShortHudText', function(text,color,length,opts)
    if not color then color = 1 end
    if not length then length = 10000 end
    if HudStage > 2 then return end
    swappedText = exports["np-i18n"]:GetStringSwap(text, ((opts and opts.i18n) and opts.i18n or false))
    TriggerEvent("tasknotify:guiupdate", color, swappedText, 10000)
    Citizen.CreateThread(function()
        if opts and opts.i18n then
            for _, v in pairs(opts.i18n) do
                TriggerEvent("i18n:translate", v, "DoShortHudText")
                Wait(500)
            end
        else
            TriggerEvent("i18n:translate", text, "DoShortHudText")
        end
    end)
end)





local msgCount2 = 0
local scary2 = 0
local scaryloop2 = false
local dicks2 = 0
local dicks3 = 0
local dicks = 0

RegisterNetEvent('DoHudTextCoords')
AddEventHandler('DoHudTextCoords', function(text,obj)
    if HudStage > 2 then return end
    dicks2 = 600
    msgCount2 = msgCount2 + 0.22
    local mycount2 = msgCount2

    scary2 = 600 - (msgCount2 * 100)
    TriggerEvent("scaryLoop2")
    local power2 = true
    while dicks2 > 0 do

        dicks2 = dicks2 - 1

        local plyCoords2 = GetEntityCoords(obj)

        output = dicks2

        if output > 255 then
            output = 255
        end

        if not isInVehicle and GetFollowPedCamViewMode() == 0 then
            DrawText3DTest(plyCoords2["x"],plyCoords2["y"],plyCoords2["z"]+(mycount2/2) - 0.2, text, output,power2)
        elseif not isInVehicle and GetFollowPedCamViewMode() == 4 then
            DrawText3DTest(plyCoords2["x"],plyCoords2["y"],plyCoords2["z"]+(mycount2/7) - 0.1, text, output,power2)
        elseif GetFollowPedCamViewMode() == 4 then
            DrawText3DTest(plyCoords2["x"],plyCoords2["y"],plyCoords2["z"]+(mycount2/7) - 0.2, text, output,power2)
        else
            DrawText3DTest(plyCoords2["x"],plyCoords2["y"],plyCoords2["z"]+mycount2 - 1.25, text, output,power2)
        end

        Citizen.Wait(1)
    end

end)

RegisterNetEvent('scaryLoop2')
AddEventHandler('scaryLoop2', function()
    if scaryloop2 then return end
    scaryloop2 = true
    while scary2 > 0 do
        if msgCount2 > 2.6 then
           scary2 = 0
        end
        Citizen.Wait(1)
        scary2 = scary2 - 1
    end
    dicks2 = 0
    scaryloop2 = false
    scary2 = 0
    msgCount2 = 0
end)


RegisterNetEvent('outlawNoticeRangeText')
AddEventHandler('outlawNoticeRangeText', function(sonid, item)
    if DoesPlayerExist(sonid) then
        local ply = GetPlayerFromServerId(sonid)
        local monid = PlayerId()

        if #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(ply))) < 8.0 and HasEntityClearLosToEntity( GetPlayerPed(monid), GetPlayerPed(ply), 17 ) then
            TriggerEvent('DoHudTextCoords', item, GetPlayerPed(ply))
        end
    end
end)


function DrawText3DTest(x,y,z, text, dicks,power)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if dicks > 255 then
        dicks = 255
    end
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 155)
        SetTextEdge(1, 0, 0, 0, 250)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
         SetTextColour(255, 255, 255, dicks)

        DrawText(_x,_y)
        local factor = (string.len(text)) / 250
        if dicks < 115 then
             DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, dicks)
        else
             DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, 115)
        end

    end
end


function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

local nextMeleeAction = GetCloudTimeAsInt() -- 1777000000
local nextStabbingAction = GetCloudTimeAsInt()

AddEventHandler('gameEventTriggered', function (name, args)
    local isSelfAttacker = (args[2] == PlayerPedId() and true or false)
    local isMeleeAttack = (args[7] == `WEAPON_UNARMED` and true or false)
    
    -- Fist only attack (Fight in Progress)
    if name == "CEventNetworkEntityDamage" and isMeleeAttack and isSelfAttacker and GetCloudTimeAsInt() > nextMeleeAction then
        local victimIsPlayer = IsPedAPlayer(args[1])
        local alertPolice = victimIsPlayer or math.random(1, 100) < 30

        TriggerEvent("civilian:alertPolice",35.0,"fight",0)
        TriggerEvent("Evidence:StateSet",1,300)
        nextMeleeAction = GetCloudTimeAsInt() + 20000
    end

    -- Melee weapon attack (Deadly Weapon)
    if name == "CEventNetworkEntityDamage" and IsPedArmed(PlayerPedId(), 1) and isSelfAttacker and GetCloudTimeAsInt() > nextStabbingAction then
        TriggerEvent("civilian:alertPolice", 35.0, "deadlyweapon", 0)
        nextStabbingAction = GetCloudTimeAsInt() + 30000
    end
end)

function getRandomNpc(basedistance)
    local basedistance = basedistance
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom

    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if ped ~= PlayerPedId() and distance < basedistance and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
        end
        success, ped = FindNextPed(handle)
    until not success

    EndFindPed(handle)

    return rped
end

local exlusionZones = {
    {1713.1795654297,2586.6862792969,59.880760192871,250}, -- prison
    {-106.63687896729,6467.7294921875,31.626684188843,45}, -- paleto bank
    {251.21984863281,217.45391845703,106.28686523438,20}, -- city bank
    {-622.25042724609,-230.93577575684,38.057060241699,10}, -- jewlery store
    {699.91052246094,132.29960632324,80.743064880371,55}, -- power 1
    {2739.5505371094,1532.9992675781,57.56616973877,235}, -- power 2
    {12.53, -1097.99, 29.8, 10}, -- Adam's Apple / Pillbox Weapon shop
    {-830.46, -796.24, 19.47, 20.0} -- Bullet club range
}

--10-94
local ped = PlayerPedId()
local isInVehicle = IsPedInAnyVehicle(ped, true)
Citizen.CreateThread( function()
    while true do
        Wait(1000)
        ped = PlayerPedId()
        isInVehicle = IsPedInAnyVehicle(ped, true)
    end
end)

local excludedWeapons = {
    [`WEAPON_FIREEXTINGUISHER`] = true,
    [`WEAPON_FLARE`] = true,
    [`WEAPON_PetrolCan`] = true,
    [`WEAPON_STUNGUN`] = true,
    [-2009644972] = true, -- paintball gun bruv
    [1064738331] = true, -- bricked
    [-828058162] = true, -- shoed
    [571920712] = true, -- cash
    [-1569615261] = true, -- cash
    [-691061592] = true, -- book
    [1834241177] = true, -- EMP Gun
    [-37975472] = true, -- Smoke Grenade
    [600439132] = true, -- Lime
    [126349499] = true, -- Snowball
    [-2084633992] = true, -- Airsoft
}

Citizen.CreateThread( function()
    local origin = false
    local curw = GetSelectedPedWeapon(PlayerPedId())
    local armed = false
    local timercheck = 0
    while true do
        Wait(50)
        

        if not armed then
            if IsPedArmed(ped, 7) and not IsPedArmed(ped, 1) then
                curw = GetSelectedPedWeapon(ped)
                armed = true
                timercheck = 15
            end
        end

        if armed then

            if `WEAPON_PetrolCan` == curw then
                TriggerEvent("Evidence:StateSet",9,1200)
            end

            if shouldSendPing() and IsPedShooting(ped) and not excludedWeapons[curw] and not origin then
                local inArea = false
                for i,v in ipairs(exlusionZones) do
                    local playerPos = GetEntityCoords(ped)
                    if #(vector3(v[1],v[2],v[3]) - vector3(playerPos.x,playerPos.y,playerPos.z)) < v[4] then
                        --if `WEAPON_COMBATPDW` == curw then
                            inArea = true
                        --end
                    end
                end
                if not inArea then
                    origin = true
                    if IsPedCurrentWeaponSilenced(ped) then
                        TriggerEvent("civilian:alertPolice",15.0,"gunshot",0,true)
                    elseif isInVehicle then
                        TriggerEvent("civilian:alertPolice",150.0,"gunshotvehicle",0,true)
                    else
                        TriggerEvent("civilian:alertPolice",550.0,"gunshot",0,true)
                    end

                    Wait(60000)
                    origin = false
                end
            end

            if timercheck == 0 then
                armed = false
            else
                timercheck = timercheck - 1
            end

        else


             Citizen.Wait(5000)


        end
    end
end)


Citizen.CreateThread( function()

    local origin2 = false
    while true do
        Wait(1)
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
        local curw = GetSelectedPedWeapon(PlayerPedId())

        local targetCoords = GetEntityCoords(PlayerPedId(), 0)

        if math.random(100) > 77 and shouldSendPing() and not isInVehicle and IsPedArmed(PlayerPedId(), 7) and not IsPedArmed(PlayerPedId(), 1) and not excludedWeapons[curw] and not origin2 then
            origin2 = true

            TriggerEvent("civilian:alertPolice",35.0,"PDOF",0)
            Wait(60000)
            origin2 = false
        else
            if isCop then
                Wait(60000)
            else
                Wait(5000)
            end
        end

    end
end)
