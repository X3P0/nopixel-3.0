local Throttles, InitialConnection = {}, true

function Debug(msg, ...)
    if not Config.enableDebug then return end

    local params = {}

    for _, param in ipairs({ ... }) do
        if type(param) == "table" then
            param = json.encode(param)
        end

        table.insert(params, param)
    end

    print((msg):format(table.unpack(params)))
end

function Throttled(name, time)
    if not Throttles[name] then
        if time then
            Throttles[name] = true
            Citizen.SetTimeout(time, function() Throttles[name] = false end)
        end

        return false
    end

    return true
end

function IsDifferent(current, old)
    if #current ~= #old then
        return true
    else
        for i = 1, #current, 1 do
            if current[i] ~= old[i] then
                return true
            end
        end
    end
end

function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

function table.exist(table, val)
    for key, value in pairs(table) do
        local exist

        if type(val) == "function" then
            exists = val(value, key, table)
        else
            exist = val == value
        end

        if exist then
            return true, key
        end
    end

    return false
end

function _C(condition, trueExpr, falseExpr)
    if condition then
        return trueExpr
    else
        return falseExpr
    end
end

-- Required for floating point precision
function almostEqual(pFloat1, pFloat2, pThreshold)
  return math.abs(pFloat1 - pFloat2) <= pThreshold
end

function MakeObject(data)
	local d = msgpack.pack(data)
	return string.pack('<T', #d) .. d
end

function GetDefaultSettings()
    return {
        ["releaseDelay"] = Config.settings.releaseDelay,
        ["stereoAudio"] = Config.settings.stereoAudio,
        ["localClickOn"] = Config.settings.localClickOn,
        ["localClickOff"] = Config.settings.localClickOff,
        ["remoteClickOn"] = Config.settings.remoteClickOn,
        ["remoteClickOff"] = Config.settings.remoteClickOff,
        ["clickVolume"] = Config.settings.clickVolume,
        ["radioVolume"] = Config.settings.radioVolume,
        ["phoneVolume"] = Config.settings.phoneVolume
    }
end

function TimeOut(time)
    local p = promise:new()

    Citizen.SetTimeout(time, function ()
        p:resolve(true)
    end)

    return p
end

local function GetInfo()
    local info, endpoint = {}, GetCurrentServerEndpoint()

    local customEndpoint = GetConvar('sv_customEndpoint', 'false')

    if customEndpoint ~= 'false' then
        endpoint = customEndpoint
    end

    for match in string.gmatch(endpoint, "[^:]+") do
        info[#info+1] = match
    end

    local customEndpointPort = GetConvar('sv_customEndpointPort', 'false')

    if customEndpointPort ~= 'false' then
        info[2] = customEndpointPort
    end

    return info[1], tonumber(info[2])
end

function RefreshConnection(pIsForced)
    if InitialConnection or pIsForced then
      local a, b = GetInfo()

      MumbleSetServerAddress(a, b)

      NativeAudio = GetConvar('voice_useNativeAudio', 'false') == 'true'
      InitialConnection = pIsForced and InitialConnection or false
    end
end

function CalculateAudioBalance(pBalance)
    local left, right = 1.0, 1.0

    if pBalance > 1.0 then
        left = 2.0 - pBalance
        right = 1.0
    else
        left = 1.0
        right = pBalance
    end
    return left + 0.0, right + 0.0
end

function GetObjectKeys(pObject)
    local keys = {}

    for key, valid in pairs(pObject) do
        if not valid then goto continue end

        keys[#keys+1] = key

        :: continue ::
    end

    return keys
end

RegisterCommand("+mumble", function(_, pArgs)
    local str = [[
        ----------------------------
        Version: %s | Connected: %s | Channel: %s

        Proximity Mode: %s

        Phone Active: %s
            | Transmissions: %s

        Radio Active: %s
            | Transmitting: %s
            | Transmissions: %s
        ----------------------------]]

    local isConnected = MumbleIsConnected() == 1
    local channel = MumbleGetVoiceChannelFromServerId(GetPlayerServerId(PlayerId()))
    local phone = json.encode(GetObjectKeys(Transmissions["contexts"]["phone"]))
    local radio = json.encode(GetObjectKeys(Transmissions["contexts"]["radio"]))

    local proximityInfo = ""

    if Config.enableGrids then
        proximityInfo = [[%s
            | Grid: %s
            | Neighbor Grids: %s
            | Active Grids: %s]]

        local grid = GetGridChannel(PlayerCoords)
        local neighbors = json.encode(GetTargetChannels(PlayerCoords, Config.gridEdge))
        local channels = json.encode(GetObjectKeys(Channels["contexts"]["grid"]))

        proximityInfo = proximityInfo:format("Grids", grid, neighbors, channels)
    elseif Config.enableProximity then
        proximityInfo = [[%s
            | Range: %s units
            | Targets: %s
            | Listeners: %s]]


        local range = CurrentVoiceRange * 4
        local targets = GetObjectKeys(Channels["contexts"]["proximity"])
        local listeners = GetObjectKeys(Listeners["contexts"]["proximity"])

        proximityInfo = proximityInfo:format("Targets", range, json.encode(targets), json.encode(listeners))
    end

    print((str):format(Config.version, isConnected, channel, proximityInfo, IsOnPhoneCall, phone, IsRadioOn, IsTalkingOnRadio, radio))

    if (pArgs[1] == "debug") then
        print('_________________ DEBUG _________________ \n')

        for context, entries in pairs(Transmissions["contexts"]) do
            print(("CTX: %s"):format(GetHashKey(context)))
            print(("[T] Entries: %s"):format(json.encode(GetObjectKeys(entries))))
            print(("[L] Entries: %s"):format(json.encode(GetObjectKeys(Listeners["contexts"][context]))))
            print(("[C] Entries: %s"):format(json.encode(GetObjectKeys(Channels["contexts"][context]))))
        end

        print('_________________________________________ ')
    end

    if (pArgs[1] == "false" or pArgs[1] == "debug") then return end

    RefreshConnection(true)
end)

RegisterCommand("-mumble", function() end)