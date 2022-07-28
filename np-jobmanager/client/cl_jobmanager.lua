RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
    LocalPlayer:setVar("job", job)
    if notify ~= false then TriggerEvent("DoLongHudText", job ~= "unemployed" and "New Job: " .. tostring(job) or "You're now unemployed", 1) end
    DecorSetInt(PlayerPedId(), "CurrentJob", NPX.Jobs.ValidJobs[job].decor)
    if job == "entertainer" then
	    TriggerEvent('DoLongHudText',"The more people you entertain, the more you earn!",1)
	end
    if job == "broadcaster" then
        TriggerEvent('DoLongHudText',"(RadioButton + LeftCtrl for radio toggle)",3)
        TriggerEvent('DoLongHudText',"Broadcast from this room and give out the vibes to los santos on 1982.9",1)
    end  
	if job == "unemployed"  then
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
        SetPoliceIgnorePlayer(PlayerPedId(),false)
        TriggerEvent("ResetRadioChannel");
	end
    
    if job == "trucker" then
        TriggerServerEvent("TokoVoip:addPlayerToRadio", 4, GetPlayerServerId(PlayerId()))
    end

    if job == "towtruck" then
        TriggerEvent("DoLongHudText","Use /tow to tow cars to your truck.",1)
        TriggerServerEvent("TokoVoip:addPlayerToRadio", 3, GetPlayerServerId(PlayerId()))
    end

    if job == "news"  then
        TriggerEvent('DoLongHudText',"Signed in. Purchase equipment on the table to the right.",1)
    end
end)

RegisterNetEvent("np-base:characterLoaded")
AddEventHandler("np-base:characterLoaded", function(character)
    local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
    LocalPlayer:setVar("job", "unemployed")
    LocalPlayer:setVar("jobRank", 0)

end)

RegisterNetEvent("np-base:exportsReady")
AddEventHandler("np-base:exportsReady", function()
    exports["np-base"]:addModule("JobManager", NPX.Jobs)
end)

DecorRegister("CurrentJob", 3)

AddEventHandler('np:vehicles:hasStateGarageAccess', function(pGarageId, cb)
    local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")

    if not LocalPlayer then return cb(false) end

    local job = LocalPlayer:getVar('job')

    local jobTable = NPX.Jobs.ValidJobs[job]

    if not jobTable.garages then return cb(false) end

    for _, garageId in ipairs(jobTable.garages) do
        if pGarageId == garageId then
            return cb(true)
        end
    end

    return cb(false)
end)

Citizen.CreateThread(function()
    SendLastAlive()
end)

function SendLastAlive()
    local randomwait = math.random(1, 600000)
    Wait(randomwait) -- THIS WAIT IS HERE TO EVENLY DISTRIBUTE SERVER LOAD
    CreateThread(function()
        while true do
            TriggerServerEvent("np-jobmanager:sendLastAlive")
            Wait(600000)
        end
    end)
end