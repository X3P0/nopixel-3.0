CURRENT_ZONE = nil

function createZone(boxCenter,length,width,minZ,maxZ,heading)

    if CURRENT_ZONE ~= nil then return end

    local options = {heading = heading, minZ = 0.0, maxZ = 0.0, data = {}}

    options.minZ = boxCenter.z-minZ
    options.maxZ = boxCenter.z+maxZ
    options.debugPoly=true

    local zone = BoxZone:Create(boxCenter, length, width, options)

    CURRENT_ZONE = zone

end

function destroyZone()
    if CURRENT_ZONE == nil then return end
    CURRENT_ZONE:destroy()
    CURRENT_ZONE = nil
end