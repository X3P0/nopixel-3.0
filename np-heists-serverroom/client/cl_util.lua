function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  local dist = #(vector3(px,py,pz) - vector3(x,y,z))
  local fov = (1/GetGameplayCamFov())*100
  if onScreen then
    SetTextScale(0.2,0.2)
    SetTextFont(0)
    SetTextProportional(1)
    -- SetTextScale(0.0, 0.55)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
  end
end

function getHalfwayPoint(p1, p2)
  return vector3((p1.x + p2.x) / 2, (p1.y + p2.y) / 2, p1.z)
end

function getQuarterWayPoint(p1, p2)
  local halfway = getHalfwayPoint(p1, p2)
  local q = getHalfwayPoint(p1, halfway)
  return q
end
