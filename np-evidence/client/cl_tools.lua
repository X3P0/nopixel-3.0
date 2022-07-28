function GetCameraForwardVectors()
    local rot = (math.pi / 180.0) * GetGameplayCamRot(2)
    return vector3(-math.sin(rot.z) * math.abs(math.cos(rot.x)), math.cos(rot.z) * math.abs(math.cos(rot.x)), math.sin(rot.x))
end

function ShapeTestLosProbe(pStartCoords, pEndCoords, pFlag, pIgnoreEntity, pColliderMask)
    local rayHandle = StartShapeTestRay(pStartCoords, pEndCoords, pFlag or -1, pIgnoreEntity or 0, pColliderMask or 4)

    local a, b, c, d, e = GetShapeTestResult(rayHandle)

    return { hit = b, hitPosition = c, hitCoords = d, entityHit = e }
end

function WaterTest(pCoords)
    local fV, sV = TestVerticalProbeAgainstAllWater(pCoords.x, pCoords.y, pCoords.z, 0, 1.0)
    return fV
 end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)

    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)
    SetTextOutline(true)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function IsRaining()
    return false
end