-- call this event when receiving call
RegisterCommand("phone:call-receiving", function()
    SendUIMessage({
        source = "np-nui",
        app = "phone",
        data = {
            action = "call-receiving",
            number = 1231231234,
            callId = 1
        }
    });
end, false)

RegisterCommand("phone:call-dialing", function()
    SendUIMessage({
        source = "np-nui",
        app = "phone",
        data = {
            action = "call-dialing",
            number = 1231231234,
            callId = 1
        }
    })
    isDialing = true
end, false)

RegisterCommand("phone:call-in-progress", function()
    SendUIMessage({
        source = "np-nui",
        app = "phone",
        data = {
            action = "call-in-progress",
            number = 1231231234,
            callId = 1
        }
    })
end, false)

RegisterCommand("phone:call-inactive", function()
    SendUIMessage({
        source = "np-nui",
        app = "phone",
        data = {
            action = "call-inactive",
            number = 1231231234
        }
    })
end, false)