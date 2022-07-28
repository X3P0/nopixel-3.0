-- stupid bobipl shit lmao this is temp...
local Throttles = {}

function Throttled(name, time)
    if not Throttles[name] then
        Throttles[name] = true
        Citizen.SetTimeout(time or 500, function()
            Throttles[name] = false
        end)
        return false
    end

    return true
end

-- Enable or disable the specified props in an interior
function SetIplPropState(interiorId, props, state, refresh)
    if refresh == nil then
        refresh = false
    end
    if IsTable(interiorId) then
        for key, value in pairs(interiorId) do
            SetIplPropState(value, props, state, refresh)
        end
    else
        if IsTable(props) then
            for key, value in pairs(props) do
                SetIplPropState(interiorId, value, state, refresh)
            end
        else
            if state then
                if not IsInteriorPropEnabled(interiorId, props) then
                    EnableInteriorProp(interiorId, props)
                end
            else
                if IsInteriorPropEnabled(interiorId, props) then
                    DisableInteriorProp(interiorId, props)
                end
            end
        end
        if refresh == true then
            RefreshInterior(interiorId)
        end
    end
end

-- BOB IPL shit

-- Check if a variable is a table
function IsTable(T)
    return type(T) == 'table'
end

-- Return the number of elements of the table
function Tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function EnableIpl(ipl, activate)
    if IsTable(ipl) then
        for key, value in pairs(ipl) do
            EnableIpl(value, activate)
        end
    else
        if activate then
            if not IsIplActive(ipl) then
                RequestIpl(ipl)
            end
        else
            if IsIplActive(ipl) then
                RemoveIpl(ipl)
            end
        end
    end
end

local SCENARIO_GROUPS = {
    "grapeseed_planes",
    "ng_planes",
    "nikez_planes_b_gone"
}

-- Another round of testing, it seems to work for some stuff, saw another repo use this in a loop
CreateThread(function()
    while true do
        for k, v in pairs(SCENARIO_GROUPS) do
            SetScenarioGroupEnabled(v, false)
        end
        Wait(60000)
    end
end)