function SetFlag(pMask, pProperty, pHandle, pEnabled)
    local mask = pMask

    if mask ~= nil and DoesEntityExist(pHandle) then
        local field = DecorGetInt(pHandle, pProperty)

        DecorSetInt(pHandle, pProperty, pEnabled and field | mask or field &~ mask)
    end
end

function HasFlag(pMask, pProperty, pHandle)
    local mask = pMask

    if mask ~= nil and DoesEntityExist(pHandle) then
        local field = DecorGetInt(pHandle, pProperty)

        return (field & mask) > 0
    end
end

function GetFlags(pFlags, pProperty, pHandle)
    local field = type(pProperty) == 'number' and pProperty or DecorGetInt(pHandle, pProperty)

    local flags = {}

    if field then
        for flag, mask in pairs(pFlags) do
            flags[flag] = (field & mask) > 0
        end
    end

    return flags
end