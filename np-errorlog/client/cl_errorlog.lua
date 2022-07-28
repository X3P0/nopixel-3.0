local EnableDebug = GetConvar("sv_environment", "prod") == "debug"
local oldError = error
local oldTrace = Citizen.Trace

local errorWords = {"failure", "error", "not", "failed", "not safe", "invalid", "cannot", ".lua", "server", "client", "attempt", "traceback", "stack", "function"}

function error(...)
    local resource = GetCurrentResourceName()
    print("------------------ ERROR IN RESOURCE: " .. resource)
    print(...)
    print("------------------ END OF ERROR")

    TriggerServerEvent("NP:LogClientError", resource, ...)
end

function Citizen.Trace(...)
    oldTrace(...)

    if type(...) == "string" then
        args = string.lower(...)
        
        for _, word in ipairs(errorWords) do
            if string.find(args, word) then
                error(...)
                return
            end
        end
    end
end

RegisterNetEvent("np-admin:currentDevmode")
AddEventHandler("np-admin:currentDevmode", function(isDevModeActive)
    EnableDebug = isDevModeActive
end)

function Debug(msg, ...)
    if not EnableDebug then return end

    local params = {}

    for _, param in ipairs({...}) do
        if type(param) == "table" then
            param = json.encode(param)
        end

        params[#params+1] = param
    end

    print((msg):format(table.unpack(params)))
end
