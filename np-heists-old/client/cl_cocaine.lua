local enabled = true
local blackoutStatus = false
local callStatus = 0
local eventStarted = false
local vehicle = 0
local dinghy = 0
local blip = 0
local dropCoords = {}

RegisterNetEvent("weather:blackout")
AddEventHandler("weather:blackout", function(status)
    blackoutStatus = status
end)

RegisterNetEvent("heists:cocaine_payment")
AddEventHandler("heists:cocaine_payment", function ()
    if not blackoutStatus or not enabled or eventStarted then
        TriggerEvent("DoLongHudText", "The man says - 'Get outta here!' and looks at you up and down.")
        return
    end
    -- make them pay 50k then call this event for 100k of drug drop off, if successful with numbers
    eventStarted = RPC.execute('heists:cocaine_paynow')
    if eventStarted then
        callStatus = 1
        TriggerEvent("DoLongHudText", "The man says 'Thanks' and hands you a list of phone numbers.")
        TriggerEvent("heists:cocaine_payment_accepted")
    else
        TriggerEvent("DoLongHudText", "The man says 'Not enough money' and motions you to move on.")
    end
end)

RegisterNetEvent("heists:cocaine_payment_accepted")
AddEventHandler("heists:cocaine_payment_accepted", function ()
    eventStarted = true
    EventLocation(-1224.001,-322.93,37.575)
end)

RegisterNetEvent("np-heists:cocaine:failure")
AddEventHandler("np-heists:cocaine:failure", function ()
    RemoveBlip(blip)
    TriggerEvent('InteractSound_CL:PlayOnOne','payphoneend', 1.0)
    blackoutStatus = false
    callStatus = 0
    eventStarted = false
    vehicle = 0
    dinghy = 0
    blip = 0
    dropCoords = {}
end)

RegisterNetEvent("np-heists:cocaine:begin_start")
AddEventHandler("np-heists:cocaine:begin_start", function ()
    if not enabled or not eventStarted then
        return
    end
    blackoutStatus = false
    callStatus = 2
    TriggerEvent('InteractSound_CL:PlayOnOne','payphoneend', 1.0)
    EventLocation(-1073.8,-398.2,36.96)   
end)

RegisterNetEvent("np-heists:cocaine:success:2")
AddEventHandler("np-heists:cocaine:success:2", function ()
    if not enabled or not eventStarted then
        return
    end
    blackoutStatus = false
    callStatus = 3
    EventLocation(-523.91,-299.72,35.24)
    TriggerEvent('InteractSound_CL:PlayOnOne','payphoneend', 1.0)
end)

RegisterNetEvent("np-heists:cocaine:success:3")
AddEventHandler("np-heists:cocaine:success:3", function ()
    if not enabled or not eventStarted then
        return
    end
    blackoutStatus = false
    callStatus = 4
    
    EventLocation(-559.2529,-275.29,35.2)
    TriggerEvent('InteractSound_CL:PlayOnOne','payphoneend', 1.0)
end)

RegisterNetEvent("np-heists:cocaine:success:4")
AddEventHandler("np-heists:cocaine:success:4", function ()
    if not enabled or not eventStarted then
        return
    end
    blackoutStatus = false
    callStatus = 0
    TriggerEvent('InteractSound_CL:PlayOnOne','payphoneend', 1.0)  
    StartEvent()
    CreateDropCoords()
    MainEvents(1)
    MainEvents(2)
    MainEvents(3)
    MainEvents(4)
end)

-- these are safe coords for aid drops to ocean
-- 3384,-1860.492,0.0
-- 3384,1500.0,0.0

-- west side now lols
-- -3307.06,1791.842,0.0
-- 4068.00
function CreatePhoneNumber(number,wanted)
    local length = 7
    local phoneNumber = "696-"
    local wantedFlag = false
    while length > 0 do
        Wait(1)
        local nGen = math.random(0,9)
        if not wanted then
            if nGen ~= number then
                if length == 3 then
                    phoneNumber = phoneNumber .. "-"
                end
                phoneNumber = phoneNumber .. nGen
                length = length - 1
            end
        end

        if wanted then
            if nGen == number then
                wantedFlag = true
            end
            if length == 3 then
                phoneNumber = phoneNumber .. "-"
            end
            phoneNumber = phoneNumber .. nGen
            length = length - 1
            if length == 2 and not wantedFlag then
                phoneNumber = phoneNumber .. "" .. number
                length = length - 1
            end
        end
    end
    return phoneNumber
end

-- 3384,-1860.492,0.0
-- 3384,1500.0,0.0

-- west side now lols
-- -3307.06,1791.842,0.0
-- 4068.00
function CreateDropCoords()
    local rand = 0
    for i=1, 4 do
        dropCoords[i] = { ["x"] = -3374.06, ["y"] = math.random(1,2184) + 1.00, ["z"] = -1.0 }
    end
end

function BlipEvent(x,y,z)
    RemoveBlip(blip)
    blip = AddBlipForCoord(x,y,z)
    SetBlipSprite(blip, 306)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Current Task")
    EndTextCommandSetBlipName(blip)
end

function EventLocation(x,y,z)
	BlipEvent(x,y,z)
    local timeout = 1200
    local success = false
    while timeout > 0 do
        timeout = timeout - 1
        Wait(1000)
        if ( GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z) < 350.0 ) then
            success = true
            timeout = 0
        end 
    end
    return success
end

function StartEvent()
    TriggerEvent("DoLongHudText","Check the map!")
    EventLocation(1997.296, 4008.251, 31.3)
    vehicle = RPC.execute("heists:cocaine_start_vehicle")
end

function MainEvents(n)
    local timer = 300000
    TriggerEvent("DoLongHudText","GPS updated.")
    Wait(1000)
    local success = EventLocation(dropCoords[n]["x"],dropCoords[n]["y"],dropCoords[n]["z"])
    if success then
        local vector = vector3(dropCoords[n]["x"],dropCoords[n]["y"],dropCoords[n]["z"])
        TriggerServerEvent("fx:spell:target",vector,"beacon",timer)
        -- create drop point boat
        dinghy = RPC.execute("heists:cocaine_dump_vehicle",dropCoords[n]["x"],dropCoords[n]["y"],dropCoords[n]["z"])
        -- actually just a smoke effect from spells
    end
end
--TriggerServerEvent("fx:spell:target",GetEntityCoords(PlayerPedId()),"beacon",300000)
Citizen.CreateThread(function()
    local function statusCheck(result)
        if eventStarted and callStatus == 1 and result == 1 then
            return true
        elseif result == callStatus then
            return true
        end
        return false
    end
    -- START EVENT
    exports["np-polytarget"]:AddBoxZone(
        "heist_cocaine_phonecall",
        vector3(-1224.001,-322.93,37.575), 1.2, 1.0,
        {
          minZ = 34.15,
          maxZ = 40.15
        }
    );

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_begin_1",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(2,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(1)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_begin_2",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(2,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(1)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall', {{
        event = "np-heists:cocaine:begin_start",
        id = "heist_cocaine_begin_3",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(2,false),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(1)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_begin_4",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(2,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(1)
            return status
        end,
    });


    -- SECOND EVENT

    exports["np-polytarget"]:AddBoxZone(
        "heist_cocaine_phonecall_second",
        vector3(-1073.8,-398.2,36.96), 1.2, 1.0,
        {
          minZ = 32.64,
          maxZ = 40.44
        }
    );

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_second', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_phonecall_second_1",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(8,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(2)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_second', {{
        event = "np-heists:cocaine:success:2",
        id = "heist_cocaine_phonecall_second_2",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(8,false),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(2)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_second', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_phonecall_second_3",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(8,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(2)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_second', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_phonecall_second_4",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(8,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(2)
            return status
        end,
    });



    -- third event


    exports["np-polytarget"]:AddBoxZone(
        "heist_cocaine_phonecall_third",
        vector3(-523.91,-299.72,35.24), 1.2, 1.0,
        {
          minZ = 32.64,
          maxZ = 38.04
        }
    );

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_third', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_phonecall_third_1",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(0,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(3)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_third', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_phonecall_third_2",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(0,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(3)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_third', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_phonecall_third_3",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(0,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(3)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_third', {{
        event = "np-heists:cocaine:success:3",
        id = "heist_cocaine_phonecall_third_4",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(0,false),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(3)
            return status
        end,
    });    




    -- fourth event

    exports["np-polytarget"]:AddBoxZone(
        "heist_cocaine_phonecall_four",
        vector3(-559.2529,-275.29,35.2), 1.2, 1.0,
        {
          minZ = 31.64,
          maxZ = 38.04
        }
    );

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_four', {{
        event = "np-heists:cocaine:success:4",
        id = "heist_cocaine_phonecall_four_1",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(9,false),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(4)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_four', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_phonecall_four_2",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(9,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(4)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_four', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_phonecall_four_3",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(9,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(4)
            return status
        end,
    });

    exports["np-interact"]:AddPeekEntryByPolyTarget('heist_cocaine_phonecall_four', {{
        event = "np-heists:cocaine:failure",
        id = "heist_cocaine_phonecall_four_4",
        icon = "phone",
        i18n = false,
        label = CreatePhoneNumber(9,true),
        parameters = {},
    }}, {
        distance = { radius = 2.0 },
        isEnabled = function()
            local status = statusCheck(4)
            return status
        end,
    });    


end)
