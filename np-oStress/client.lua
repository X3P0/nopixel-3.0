local stresslevel = 0
local isBlocked = false

RegisterNetEvent("client:updateStress")
AddEventHandler("client:updateStress",function(newStress)
    stresslevel = newStress
end)

RegisterNetEvent("client:blockShake")
AddEventHandler("client:blockShake",function(isBlockedInfo)
    isBlocked = isBlockedInfo
end)


RegisterNetEvent("np-admin:currentDevmode")
AddEventHandler("np-admin:currentDevmode", function(devmode)
    isBlocked = devmode
end)

Citizen.CreateThread(function()
    while true do
        local waitTime = 120000
        if not isBlocked then
            if stresslevel > 7500 then
                waitTime = 10000
            elseif stresslevel > 4500 then
                waitTime = 30000
            elseif stresslevel > 2000 then
                waitTime = 60000
            end
            if stresslevel > 1000 then
              TriggerScreenblurFadeIn(1000.0)
              Wait(1100)
              TriggerScreenblurFadeOut(1000.0)
            end
        end 
        Citizen.Wait(waitTime)
    end
end)


