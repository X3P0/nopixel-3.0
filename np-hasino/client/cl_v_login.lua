IsLVComputerLoggedIn = false

RegisterNetEvent('np-hasino:computerLoggedIn', function(pState)
  IsLVComputerLoggedIn = pState
end)

AddEventHandler('np-hasino:loginLowerComputer', function()
    local hasBluePrints = exports['np-inventory']:hasEnoughOfItem('casinoblueprints', 1, false, true)
    if not hasBluePrints then
        TriggerEvent('DoLongHudText', 'Missing documents!', 2)
        return
    end
    local hint, timeRemaining, attempts = RPC.execute('np-hasino:getLoginAttempts')
    exports['np-ui']:openApplication('hasino-lower-login', {
        attempts = attempts,
        hint = hint,
        timeRemaining = timeRemaining,
    })
end)

RegisterUICallback('np-hasino:attemptLowerLogin', function(data, cb)
    local response, timeRemaining, attempts = RPC.execute('np-hasino:attemptLVComputerLogin', data.password)
    cb({ data = { text = response, timeRemaining = timeRemaining, attempts = attempts}, meta = { ok = true, message = "done" } })
end)
