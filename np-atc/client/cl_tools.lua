function TimeOut(time)
    local p = promise:new()

    Citizen.SetTimeout(time, function ()
        p:resolve(true)
    end)

    return p
end

local CachedNames = {}

function GetModelName(pModelHash)
    if not CachedNames[pModelHash] then
        CachedNames[pModelHash] = GetLabelText(GetDisplayNameFromVehicleModel(pModelHash))
    end

    return CachedNames[pModelHash]
end