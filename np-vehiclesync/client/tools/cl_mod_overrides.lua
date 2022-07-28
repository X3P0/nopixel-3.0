function GetModSoundOverride(pVehicle, pVehicleModel)
    if not pVehicle or not pVehicleModel then return false end
    local config = CosmeticOverrides[pVehicleModel]
    if config then
        for oName, oConfig in pairs(config) do
            local modId = GetVehicleMod(pVehicle, oConfig.modId)
            if modId and oConfig.data[modId] then
                return oConfig.data[modId]
            end
        end
    end
    return nil
end