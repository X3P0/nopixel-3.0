function retriveHousingTable()
	return Housing.info
end

function retrieveHousingTableMapped()
    local mapped = {}
    for id, housing in pairs(Housing.info) do
        if housing.enabled then
            local coords = housing[1]
            table.insert(mapped, {
                id = id,
                coords = {
                    x = housing[1].x,
                    y = housing[1].y,
                    z = housing[1].z
                },
                model = housing.model,
                street = housing.Street
            })
        end
    end
	return mapped
end

function retrieveHousingZonesConfig()
    return Housing.zoningPrices
end

function getHousingCatFromPropertID(propertyID)
    local targetPropertyType = Housing.typeInfo[Housing.info[propertyID].model].cat
    if Housing.info[propertyID] and Housing.info[propertyID].model then 
        
        if Housing.info[propertyID].override then
            targetPropertyType = Housing.info[propertyID].override
        end
    else
        return 'Unk'
    end
    
    return targetPropertyType
end


Housing.zone = {}
Housing.info = {}
Housing.infoSize = 0

function getHousingInfoSize(forced)

    if forced or Housing.infoSize == 0 then
        Housing.infoSize = 0
        for k,v in pairs(Housing.info) do
            Housing.infoSize = Housing.infoSize + 1
        end
        return Housing.infoSize
    else
        if Housing.infoSize <= 0 then
            print("Error: failed to find Housing Info Size")
        else
            return Housing.infoSize
        end
    end
end



-- Any new Static housing can go into here :) , it will get pushed to the DB and given an ID , do not give it an ID since it will be discarded here
-- duplicate street names will not be added
-- removing from this list will not remove them from the game
-- disable them on the DB if they need to be removed
Housing.newStatic = {
    --{vector4(60.41, -1579.4, 29.6, 214.56), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_36', ['Street'] = 'Testing Street', ["enabled"] = true},
    { vector4(-1027.67,-409.52,33.42, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'ghost_stash_houses_01', ['Street'] = 'Marathon Avenue 1', ['enabled'] = true },
    { vector4(-1033.98,-394.77,33.42, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'ghost_stash_houses_01', ['Street'] = 'Marathon Avenue 2', ['enabled'] = true },

    { vector4(-784.57,-885.65,24.95, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 1', ['enabled'] = true },
    { vector4(-775.35,-885.66,24.95, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 2', ['enabled'] = true },
    { vector4(-800.55,-885.68,24.95, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 3', ['enabled'] = true },
    { vector4(-798.4,-875.12,24.95, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 4', ['enabled'] = true },
    { vector4(-793.04,-865.6,24.94, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 5', ['enabled'] = true },
    { vector4(-787.46,-874.89,24.95, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 6', ['enabled'] = true },
    { vector4(-800.59,-885.75,29.41, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 7', ['enabled'] = true },
    { vector4(-784.85,-885.73,29.41, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 8', ['enabled'] = true },
    { vector4(-775.62,-885.6,29.41, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 9', ['enabled'] = true },
    { vector4(-798.62,-875.43,29.41, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 10', ['enabled'] = true },
    { vector4(-787.64,-875.27,29.43, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 11', ['enabled'] = true },
    { vector4(-792.97,-865.74,29.44, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 12', ['enabled'] = true },
    { vector4(-800.51,-885.58,33.93, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 13', ['enabled'] = true },
    { vector4(-798.35,-875.4,33.92, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 14', ['enabled'] = true },
    { vector4(-793.32,-865.92,33.96, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 15', ['enabled'] = true },
    { vector4(-787.49,-875.21,33.95, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 16', ['enabled'] = true },
    { vector4(-784.85,-885.81,33.93, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 17', ['enabled'] = true },
    { vector4(-775.43,-885.71,33.93, 0.0), vector4(0, 0, 0, 0.0),  ['model'] = 'v_int_44_empty', ['Street'] = 'Vescpucci Boulevard Apt 18', ['enabled'] = true },
    
    { vector4(2352.429932, 2523.381836, 47.694416, 154.905457), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 1', ['enabled'] = true },
    { vector4(2359.721924, 2541.626709, 47.701054, 44.631611), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 2', ['enabled'] = true },
    { vector4(2355.842773, 2564.789062, 46.876305, 301.825104), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 3', ['enabled'] = true },
    { vector4(2318.804932, 2553.439453, 47.695518, 113.514565), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 4', ['enabled'] = true },
    { vector4(2321.109619, 2536.211670, 47.273621, 150.219910), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 5', ['enabled'] = true },
    { vector4(2332.918457, 2524.160645, 46.598507, 20.618361), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 6', ['enabled'] = true },
    { vector4(2338.377686, 2570.454102, 47.727375, 169.955444), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 7', ['enabled'] = true },
    { vector4(2334.051514, 2588.956543, 47.488956, 318.072632), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 8', ['enabled'] = true },
    { vector4(2337.727051, 2605.301025, 47.307877, 335.905457), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 9', ['enabled'] = true },
    { vector4(2357.842041, 2609.608643, 47.245907, 34.384319), vector4(0, 0, 0, 0),['model'] = 'nopixel_trailer', ['Street'] = 'Senora Way / Ron Alternates 10', ['enabled'] = true },
    { vector4(305.255859, -1248.001587, 30.023846, 178.677704), vector4(0, 0, 0, 0),['model'] = 'v_int_16_mid_empty', ['Street'] = 'Gulag Street 1', ['enabled'] = true },
    { vector4(309.039124, -1247.987915, 30.033289, 196.080475), vector4(0, 0, 0, 0),['model'] = 'v_int_16_mid_empty', ['Street'] = 'Gulag Street 2', ['enabled'] = true },
    { vector4(314.694641, -1247.968262, 30.050327, 204.535156), vector4(0, 0, 0, 0),['model'] = 'v_int_16_mid_empty', ['Street'] = 'Gulag Street 3', ['enabled'] = true },
    { vector4(318.717804, -1247.960327, 30.176323, 232.384399), vector4(0, 0, 0, 0),['model'] = 'v_int_16_mid_empty', ['Street'] = 'Gulag Street 4', ['enabled'] = true },
    { vector4(322.941467, -1247.626099, 30.374897, 154.115677), vector4(0, 0, 0, 0),['model'] = 'v_int_16_mid_empty', ['Street'] = 'Gulag Street 5', ['enabled'] = true },
    { vector4(327.126495, -1258.640137, 32.110550, 95.126358), vector4(0, 0, 0, 0),['model'] = 'v_int_16_mid_empty', ['Street'] = 'Gulag Street 6', ['enabled'] = true },
    { vector4(327.616730, -1263.536621, 31.651026, 117.391792), vector4(0, 0, 0, 0),['model'] = 'v_int_16_mid_empty', ['Street'] = 'Gulag Street 7', ['enabled'] = true },
    { vector4(327.662567, -1272.121094, 31.651491, 154.727554), vector4(0, 0, 0, 0),['model'] = 'v_int_16_mid_empty', ['Street'] = 'Gulag Street 8', ['enabled'] = true },
    { vector4(322.230988, -1284.515747, 30.567177, 39.122353), vector4(0, 0, 0, 0),['model'] = 'v_int_16_mid_empty', ['Street'] = 'Gulag Street 9', ['enabled'] = true },

    { vector4(3807.93,4478.34,6.37,25.34), vector4(0, 0, 0, 0), ['model'] = 'v_int_16_mid_empty', ['Street'] = 'Backwater Basin 1', ['enabled'] = true, ["cost"] = 750000, ["costOverride"] = 750000 },

    { vector4(-949.5,196.64,67.4,336.22), vector4(0, 0, 0, 0), ['model'] = 'v_int_24', ['Street'] = 'West Eclipse Mansion 101', ['enabled'] = true, ["cost"] = 2000000, ["costOverride"] = 2000000 },

    
    {vector4(-1715.564331, -447.156189, 42.649193, 221.013229), vector4(0, 0, 0, 0),['model'] = 'v_int_16_low', ['Street'] = 'Bay City Incline Apt/ 1', ['enabled'] = true },
    {vector4(-1712.076172, -493.028687, 41.619373, 215.926163), vector4(0, 0, 0, 0),['model'] = 'v_int_16_low', ['Street'] = 'Bay City Incline Apt/ 2', ['enabled'] = true },
    {vector4(-1710.943237, -494.049835, 41.619263, 269.723694), vector4(0, 0, 0, 0),['model'] = 'v_int_16_low', ['Street'] = 'Bay City Incline Apt/ 3', ['enabled'] = true },
    {vector4(-1699.799438, -474.736298, 41.649349, 160.222778), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 4', ['enabled'] = true },
    {vector4(-1704.530029, -480.461334, 41.649448, 187.836639), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 5', ['enabled'] = true },
    {vector4(-1709.746704, -481.021088, 41.649506, 144.248428), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 6', ['enabled'] = true },
    {vector4(-1693.066040, -464.846069, 41.649395, 299.328979), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 7', ['enabled'] = true },
    {vector4(-1698.267334, -460.437195, 41.649296, 5.910684), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 8', ['enabled'] = true },
    {vector4(-1706.890259, -453.591034, 42.649193, 36.340042), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 9', ['enabled'] = true },
    {vector4(-1714.223389, -463.602936, 41.649281, 141.944199), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 10', ['enabled'] = true },
    {vector4(-1713.329956, -470.119751, 41.649357, 166.028442), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 11', ['enabled'] = true },
    {vector4(-1712.684448, -477.305664, 41.649429, 204.047318), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 12', ['enabled'] = true },
    {vector4(-1714.062012, -463.576965, 44.616390, 180.716080), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 13', ['enabled'] = true },
    {vector4(-1713.389648, -470.291931, 44.616390, 177.142792), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 14', ['enabled'] = true },
    {vector4(-1712.643066, -477.188416, 44.616390, 180.485718), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 15', ['enabled'] = true },
    {vector4(-1709.651978, -480.970215, 44.616390, 106.924828), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 16', ['enabled'] = true },
    {vector4(-1704.611084, -480.376862, 44.621719, 286.242706), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 17', ['enabled'] = true },
    {vector4(-1700.097290, -474.632721, 44.632347, 318.573425), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 18', ['enabled'] = true },
    {vector4(-1693.054077, -464.829712, 44.649235, 55.887222), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 19', ['enabled'] = true },
    {vector4(-1687.812744, -469.096924, 44.649235, 253.875870), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 20', ['enabled'] = true },
    {vector4(-1698.212036, -460.651306, 44.649235, 66.807083), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 21', ['enabled'] = true },
    {vector4(-1706.840088, -453.554596, 45.648891, 56.148411), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 22', ['enabled'] = true },
    {vector4(-1710.524414, -451.137421, 45.648891, 48.544216), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 23', ['enabled'] = true },
    {vector4(-1687.637695, -469.092926, 47.652119, 246.912872), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 24', ['enabled'] = true },
    {vector4(-1693.213135, -464.858643, 47.652119, 234.920837), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 25', ['enabled'] = true },
    {vector4(-1698.264282, -460.547821, 47.652119, 61.508930), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 26', ['enabled'] = true },
    {vector4(-1706.889160, -453.463562, 48.652020, 43.778938), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 27', ['enabled'] = true },
    {vector4(-1710.211426, -451.380310, 48.652020, 51.418346), vector4(0, 0, 0, 0),['model'] = 'v_int_49_empty', ['Street'] = 'Bay City Incline Apt/ 28', ['enabled'] = true },

    { vector4(-1038.06, 222.2, 64.38, 293.02), vector4(0, 0, 0, 0), ['model'] = 'v_int_44_empty', ['Street'] = 'Steele Way 1', ['enabled'] = true },
    
    { vector4(-888.26, 42.54, 49.15, 66.09), vector4(0, 0, 0, 0), ['model'] = 'v_int_44_empty', ['Street'] = 'Caesars Place 1', ['enabled'] = true },
}
