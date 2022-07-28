function hasRadio()
    return exports["np-inventory"]:hasEnoughOfItem("radio", 1, false, true) or exports["np-inventory"]:hasEnoughOfItem("civradio", 1, false, true)
end

local function formattedChannelNumber(number)
    local power = 10 ^ 1
    return math.floor(number * power) / power
end

function handleConnectionEvent(pChannel)
    local newChannel = formattedChannelNumber(pChannel)

    if type(newChannel) ~= 'number' then return end

    local result = exports['np-voice']:SetRadioFrequency(newChannel)
    return result
end

function LoadAnimationDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end