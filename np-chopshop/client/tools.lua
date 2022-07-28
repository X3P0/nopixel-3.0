local _i, _f, _v, _r, _ri, _rf, _rl, _s, _rv, _in, _ii, _fi =
Citizen.PointerValueInt(), Citizen.PointerValueFloat(), Citizen.PointerValueVector(),
Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger(), Citizen.ResultAsFloat(), Citizen.ResultAsLong(), Citizen.ResultAsString(), Citizen.ResultAsVector(), Citizen.InvokeNative,
Citizen.PointerValueIntInitialized, Citizen.PointerValueFloatInitialized

local string_len = string.len
local inv_factor = 1.0 / 370.0

function Draw3DText(x,y,z, text)
    local factor = string_len(text) * inv_factor
    local onScreen,_x,_y = _in(0x34E82F05DF2974F5, x, y, z, _f, _f, _r) -- GetScreenCoordFromWorldCoord

    if onScreen then
        _in(0x07C837F9A01C34C9, 0.35, 0.35) -- SetTextScale
        _in(0x66E0276CC5F6B9DA, 4) -- SetTextFont
        _in(0x038C1F517D7FDCF8, 1) -- SetTextProportional
        _in(0xBE6B23FFA53FB442, 255, 255, 255, 215) -- SetTextColour
        _in(0x25FBB336DF1804CB, "STRING") -- SetTextEntry
        _in(0xC02F4DBFB51D988B, 1) -- SetTextCentre
        _in(0x6C188BE134E074AA, text) -- AddTextComponentString, assumes "text" is of type string
        _in(0xCD015E5BB0D96A57, _x, _y) -- DrawText
        _in(0x3A618A217E5154F0, _x,_y+0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68) -- DrawRect
    end
end

function GetHeadingFromCoords(targetCoords)
    local playerCoords = GetEntityCoords(PlayerPedId())

    local prX, prY = playerCoords.x * math.pi / 180, playerCoords.y * math.pi / 180
    local trX, trY = targetCoords.x * math.pi / 180, targetCoords.y * math.pi / 180

    local y = math.sin(trX - prX) * math.cos(trY)
    local x = math.cos(prY) * math.sin(trY) - math.sin(prY) * math.cos(trY) * math.cos(trX - prX)

    local bearing = math.atan2(y, x)

    local heading = bearing * 180 / math.pi

    return heading
end

function PedFaceCoord(pPed, pCoords)
    TaskTurnPedToFaceCoord(pPed, pCoords.x, pCoords.y, pCoords.z)

    Citizen.Wait(100)

    while GetScriptTaskStatus(pPed, 0x574bb8f5) == 1 do
        Citizen.Wait(0)
    end
end

function LoadAnimationDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

function conditional(condition, trueExpr, falseExpr)
    if condition then
        return trueExpr
    else
        return falseExpr
    end
end

local Throttles = {}

function Throttled(name, time)
    if not Throttles[name] then
        Throttles[name] = true
        Citizen.SetTimeout(time or 500, function() Throttles[name] = false end)
        return false
    end

    return true
end