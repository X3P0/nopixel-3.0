Citizen.CreateThread(function()

    RequestIpl("int_henhouse")
    local interiorID = GetInteriorAtCoords(3649.381, 4945.031, 17.03796)
    if IsValidInterior(interiorID) then
        EnableInteriorProp(interiorID, "scene_01")
        EnableInteriorProp(interiorID, "poker_room")
        EnableInteriorProp(interiorID, "bar_01")
        EnableInteriorProp(interiorID, "saloon_room")
        EnableInteriorProp(interiorID, "stock_back")
        EnableInteriorProp(interiorID, "cloakroom_back")
        EnableInteriorProp(interiorID, "poker_detail")
        EnableInteriorProp(interiorID, "toilet_detail")
        EnableInteriorProp(interiorID, "poker_detail2")
        EnableInteriorProp(interiorID, "poker_detail3")
        RefreshInterior(interiorID)
    end
end)
