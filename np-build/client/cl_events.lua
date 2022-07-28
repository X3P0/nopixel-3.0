local entranceCoords = vector3(0,0,0)
local inside = false

AddEventHandler('build:event:inside', function(pIsInside, pPlanData)
    if pIsInside and not inside then
        inside = true
        entranceCoords = GetEntityCoords(PlayerPedId())
        Citizen.CreateThread(function()
            while inside do
                Citizen.Wait(1000)
                local plyCoords = GetEntityCoords(PlayerPedId())
                if inside and #(plyCoords - entranceCoords) > 75.0 then
                    plyCoords = vector3(plyCoords.x, plyCoords.y, plyCoords.z - 1.0)
                    Build.func.exitCurrentRoom(nil, true)
                    if type(pPlanData.posGen) == 'table' or type(pPlanData.posGen) == 'vector3' then
                        TriggerEvent('np-housing:exitBuilding', plyCoords, true)
                    end
                    inside = false
                end
            end
        end)
    end
    inside = pIsInside
end)
