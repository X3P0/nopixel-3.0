
function RotationToDirection(rotation)

    local z = math.rad(rotation.z);
    local x = math.rad(rotation.x);
    local num = math.abs(math.cos(x));
  
  
  
    local vector3Direction = vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
    return vector3Direction
  end
  

function ScreenRelToWorld(camPos,camRot,coord)

    local distance = 1000.0
    local camForward = RotationToDirection(camRot);
    local rotUp = camRot + vector3(distance, 0, 0);
    local rotDown = camRot + vector3(-distance, 0, 0);
    local rotLeft = camRot + vector3(0, 0, -distance);
    local rotRight = camRot + vector3(0, 0, distance);
    

    local camRight = RotationToDirection(rotRight) - RotationToDirection(rotLeft);
    local camUp = RotationToDirection(rotUp) - RotationToDirection(rotDown);

    local rollRad = -math.rad(camRot.y);

    local camRightRoll = camRight * math.cos(rollRad) - camUp * math.sin(rollRad);
    local camUpRoll = camRight * math.sin(rollRad) + camUp * math.cos(rollRad);

    local point3D = camPos + camForward * distance + camRightRoll + camUpRoll;
    local point2D;
    local b,cx,cy = GetScreenCoordFromWorldCoord(point3D.x,point3D.y,point3D.z)
    local point2D = {X = cx,Y = cy};
    if not point2D or not cx or not cy then 
      return camPos + camForward * distance; 
    end


    local point3DZero = camPos + camForward * distance;
    local b,cx,cy = GetScreenCoordFromWorldCoord(point3DZero.x,point3DZero.y,point3DZero.z)
    local point2DZero = {X = cx,Y = cy};
    if not point2DZero or not cx or not cy then
      return camPos + camForward * distance; 
    end

    local eps = 0.00001;
    if (math.abs(point2D.X - point2DZero.X) < eps or math.abs(point2D.Y - point2DZero.Y) < eps) then 
      return camPos + camForward * distance; 
    end

    local scaleX = (coord.x - point2DZero.X) / (point2D.X - point2DZero.X);
    local scaleY = (coord.y - point2DZero.Y) / (point2D.Y - point2DZero.Y);

    local point3Dret = camPos + camForward * distance + camRightRoll * scaleX + camUpRoll * scaleY;
    return point3Dret;



end


function LocationInWorld(coords,camera,flags)
    local position = GetCamCoord(camera)

    --- Getting Object using raycast
    local ped = PlayerPedId()
    local raycast = StartShapeTestRay(position.x,position.y,position.z, coords.x,coords.y,coords.z, flags, ped, 0)
    local retval, hit, endCoords, surfaceNormal, entity = GetShapeTestResult(raycast)

    currentCoords = endCoords

    return hit, endCoords, entity

end
