local isStageActive = false
local isPerforming = false

Citizen.CreateThread(function()
    exports['np-interact']:AddPeekEntryByPolyTarget('np-roostersrest:tavern_stage', {{
        event = "np-roostersrest:stageSignOn",
        id = "roosters_rest_stage_signon",
        icon = "circle",
        label = _L("rr-start-performing", "Start Performing")
    }}, { distance = { radius = 3.5 }, isEnabled = function(pEntity, pContext) return not isStageActive end })

    exports['np-interact']:AddPeekEntryByPolyTarget('np-roostersrest:tavern_stage', {{
        event = "np-roostersrest:stageSignOff",
        id = "roosters_rest_stage_signoff",
        icon = "circle",
        label = _L("rr-stop-performing", "Stop Performing")
    }}, { distance = { radius = 3.5 }, isEnabled = function(pEntity, pContext) return isPerforming end })
end)

AddEventHandler('np-roostersrest:stageSignOn', function(pParameters, pEntity, pContext)
    if not isStageActive then
        local success = RPC.execute("np-roostersrest:startPerforming")
        if success then
            isPerforming = true
            TriggerEvent("DoLongHudText", _L("rr-performance-started", "Performance started... break a leg!"))
        elseif success ~= nil then
            TriggerEvent("DoLongHudText", _L("rr-performance-active", "A performer is already active."))
        end
    end
end)

RegisterNetEvent('np-roostersrest:stageSignOff', function(pParameters, pEntity, pContext)
    if not isStageActive then
        local success = RPC.execute("np-roostersrest:stopPerforming")

        if success then
            isPerforming = false
            TriggerEvent("DoLongHudText", _L("rr-performance-ended", "Performance ended...Good job!"))
        elseif success == false then
            TriggerEvent("DoLongHudText", _L("rr-performance-inactive", "Not in an active performance."))
        end
    end
end)

RegisterNetEvent('np-roostersrest:startPerformance', function()
    isStageActive = true
end)

RegisterNetEvent('np-roostersrest:stopPerformance', function()
    isStageActive = false
end)

AddEventHandler("np-polyzone:enter", function(zone, data)
    if zone == "np-roostersrest:tavern_near" then
        RPC.execute("np-roostersrest:enterTavern")
    end
    if zone == "np-roostersrest:tavern_stage" then
      TriggerEvent('np:voice:proximity:override', 'roostersrest-stage', 3, 15.0, 3)
    end
end)

AddEventHandler("np-polyzone:exit", function(zone)
    if zone == "np-roostersrest:tavern_near" then
        RPC.execute("np-roostersrest:leaveTavern")
    end

    if zone == "np-roostersrest:tavern_main" and isPerforming then
        TriggerEvent("np-roostersrest:stageSignOff")
    end

    if zone == "np-roostersrest:tavern_stage" then
      TriggerEvent('np:voice:proximity:override', 'roostersrest-stage', 3, -1, -1)
    end
end)
