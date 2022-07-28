function NPX.Util.MissionText(self, text, time)
    if not text then return end

    text = tostring(text)
    
    drawTxt(0.97, 1.43, 1.0,1.0,0.4, text, 255, 255, 255, 255)  -- INT: kmh
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,15)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2)
end


function NPX.Util.DrawText(self, text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end

function NPX.Util.DrawText3D(self, x,y,z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


function NPX.Util.RotationToDirection(self,rotation)

  local z = math.rad(rotation.z);
  local x = math.rad(rotation.x);
  local num = math.abs(math.cos(x));



  local vector3Direction = vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
  return vector3Direction
end

function NPX.Util.ScreenRelToWorld(self,camPos,camRot,coord)

      local distance = 1000.0
      local camForward = NPX.Util.RotationToDirection(self,camRot);
      local rotUp = camRot + vector3(distance, 0, 0);
      local rotDown = camRot + vector3(-distance, 0, 0);
      local rotLeft = camRot + vector3(0, 0, -distance);
      local rotRight = camRot + vector3(0, 0, distance);

      local camRight = NPX.Util.RotationToDirection(self,rotRight) - NPX.Util.RotationToDirection(self,rotLeft);
      local camUp = NPX.Util.RotationToDirection(self,rotUp) - NPX.Util.RotationToDirection(self,rotDown);

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

      local eps = 0.001;
      if (math.abs(point2D.X - point2DZero.X) < eps or math.abs(point2D.Y - point2DZero.Y) < eps) then 
        return camPos + camForward * distance; 
      end



      local scaleX = (coord.x - point2DZero.X) / (point2D.X - point2DZero.X);
      local scaleY = (coord.y - point2DZero.Y) / (point2D.Y - point2DZero.Y);
      local point3Dret = camPos + camForward * distance + camRightRoll * scaleX + camUpRoll * scaleY;
      return point3Dret;



end