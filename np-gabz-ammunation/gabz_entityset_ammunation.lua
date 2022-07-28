local interiors = {
    {
        ipl = 'gabz_ammu_big_milo_01',
        coords = { x = 10.90700000, y = -1105.65800000, z = 28.79693000 },
        entitySets = {
            { name = 'shooting_range_targets', enable = true },
        }
    },
    {
        ipl = 'gabz_ammu_big_milo_02',
        coords = { x = 821.14400000, y = -2154.89200000, z = 28.61892000 },
        entitySets = {
            { name = 'shooting_range_targets', enable = true },
        }
    },
}

CreateThread(function()
    for _, interior in ipairs(interiors) do
        if not interior.ipl or not interior.coords or not interior.entitySets then
            print('^5[GABZ]^7 ^1Error while loading interior.^7')
            return
        end
        RequestIpl(interior.ipl)
        local interiorID = GetInteriorAtCoords(interior.coords.x, interior.coords.y, interior.coords.z)
        if IsValidInterior(interiorID) then
            for __, entitySet in ipairs(interior.entitySets) do
                if entitySet.enable then
                    EnableInteriorProp(interiorID, entitySet.name)
                    if entitySet.color then
                        SetInteriorPropColor(interiorID, entitySet.name, entitySet.color)
                    end
                else
                    DisableInteriorProp(interiorID, entitySet.name)
                end
            end
            RefreshInterior(interiorID)
        end
    end
    print("^5[GABZ]^7 Interiors datas loaded.")
end)