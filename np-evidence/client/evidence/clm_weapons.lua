local excludedWeapons = {
    [`WEAPON_FIREEXTINGUISHER`] = true,
    [`WEAPON_PetrolCan`] = true,
    [-2009644972] = true, -- paintball gun bruv
    [1064738331] = true, -- bricked
    [-828058162] = true, -- shoed
    [571920712] = true, -- money
    [-691061592] = true, -- book
    [1834241177] = true, -- EMP Gun
    [600439132] = true, -- Lime
    [126349499] = true, -- Snowball
    [-2084633992] = true, -- Airsoft
}

local dropBulletCasing = function(pPed, pWeaponHash, pWeaponType, pIdentifier)
    local x, y, z = math.random(20)/10, math.random(20)/10, nil

    if (math.random(2) == 1) then
        y = (0 - y)
    end

    x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(pPed, x, y, -0.7 ))

    if Ped.isInVehicle then z = z + 0.7 end

    local meta = {
        ['evidenceType'] = 'casing',
        ['identifier'] = pIdentifier or 'FADED',
        ['other'] = pWeaponHash,
        ['casingClass'] = pWeaponType
    }

    TriggerEvent('np-evidence:dropEvidence', vector3(x, y, z), meta)
end

local dropImpactFragment = function(pPed, pDist, pWeaponHash, pWeaponType, pIdentifier)
    local startCoords = GetGameplayCamCoord()

    local endCoords = startCoords + (GetCameraForwardVectors() * pDist)

    local result = ShapeTestLosProbe(startCoords, endCoords, -1, pPed, 1)

    if not result.hit and not result.hitPosition then return end

    local meta = {
        ["evidenceType"] = "projectile",
        ["identifier"] = pIdentifier or 'FADED',
        ["other"] = pWeaponHash,
        ["casingClass"] = pWeaponType
    }

    local isAVehicle = result.entityHit ~= 0 and IsEntityAVehicle(result.entityHit)

    if isAVehicle and math.random(4) > 1 then
        local r, g, b = GetVehicleColor(result.entityHit)

        meta['evidenceType'] = 'vehiclefragment'
        meta['identifier'] = { ["r"] = r, ["g"] = g, ["b"] = b }
        meta["other"] = "(r:" .. r .. ", g:" .. g .. ", b:" .. b .. ") Colored Vehicle Fragment"
    end

    TriggerEvent('np-evidence:dropEvidence', result.hitPosition, meta, 'p')
end

Citizen.CreateThread(function ()
    while true do
        local idle = 1000

        if not Ped.isArmed or excludedWeapons[Ped.weaponHash] then
            goto continue
        end

        idle = 0

        Ped.isShooting = IsPedShooting(Ped.handle)

        Ped.isAiming = IsPlayerFreeAiming(Ped.playerId)

        if not Ped.isShooting then goto continue end

        dropBulletCasing(Ped.handle, Ped.weaponHash, Ped.weaponType, Ped.weaponInfo)

        dropImpactFragment(Ped.handle, 150.0, Ped.weaponHash, Ped.weaponType, Ped.weaponInfo)

        idle = 100

        :: continue ::

        Citizen.Wait(idle)
    end
end)