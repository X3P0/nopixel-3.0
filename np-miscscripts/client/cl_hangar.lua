local isInsideHangar = false
local listenCounter = 0

-- SmugglerHangar: -1267.0 -3013.135 -49.5

SmugglerHangar = {
    interiorId = 260353,
    Ipl = {
        Interior = {
            ipl = "sm_smugdlc_interior_placement_interior_0_smugdlc_int_01_milo_",
            Load = function()
                EnableIpl(SmugglerHangar.Ipl.Interior.ipl, true)
            end,
            Remove = function()
                EnableIpl(SmugglerHangar.Ipl.Interior.ipl, false)
            end
        }
    },
    Colors = {
        colorSet1 = 1, -- sable, red, gray
        colorSet2 = 2, -- white, blue, gray
        colorSet3 = 3, -- gray, orange, blue
        colorSet4 = 4, -- gray, blue, orange
        colorSet5 = 5, -- gray, light gray, red
        colorSet6 = 6, -- yellow, gray, light gray
        colorSet7 = 7, -- light Black and white
        colorSet8 = 8, -- dark Black and white
        colorSet9 = 9 -- sable and gray
    },
    Walls = {
        default = "set_tint_shell",
        SetColor = function(color, refresh)
            SetIplPropState(SmugglerHangar.interiorId, SmugglerHangar.Walls.default, true, refresh)
            SetInteriorPropColor(SmugglerHangar.interiorId, SmugglerHangar.Walls.default, color)
        end
    },
    Floor = {
        Style = {
            raw = "set_floor_1",
            plain = "set_floor_2",
            Set = function(floor, refresh)
                SmugglerHangar.Floor.Style.Clear(false)
                SetIplPropState(SmugglerHangar.interiorId, floor, true, refresh)
            end,
            Clear = function(refresh)
                SetIplPropState(SmugglerHangar.interiorId,
                    {SmugglerHangar.Floor.Style.raw, SmugglerHangar.Floor.Style.plain}, false, refresh)
            end
        },
        Decals = {
            decal1 = "set_floor_decal_1",
            decal2 = "set_floor_decal_2",
            decal4 = "set_floor_decal_3",
            decal3 = "set_floor_decal_4",
            decal5 = "set_floor_decal_5",
            decal6 = "set_floor_decal_6",
            decal7 = "set_floor_decal_7",
            decal8 = "set_floor_decal_8",
            decal9 = "set_floor_decal_9",
            Set = function(decal, color, refresh)
                if color == nil then
                    color = 1
                end
                SmugglerHangar.Floor.Decals.Clear(false)
                SetIplPropState(SmugglerHangar.interiorId, decal, true, refresh)
                SetInteriorPropColor(SmugglerHangar.interiorId, decal, color)
            end,
            Clear = function(refresh)
                SetIplPropState(SmugglerHangar.interiorId,
                    {SmugglerHangar.Floor.Decals.decal1, SmugglerHangar.Floor.Decals.decal2,
                     SmugglerHangar.Floor.Decals.decal3, SmugglerHangar.Floor.Decals.decal4,
                     SmugglerHangar.Floor.Decals.decal5, SmugglerHangar.Floor.Decals.decal6,
                     SmugglerHangar.Floor.Decals.decal7, SmugglerHangar.Floor.Decals.decal8,
                     SmugglerHangar.Floor.Decals.decal9}, false, refresh)
            end
        }
    },
    Cranes = {
        on = "set_crane_tint",
        off = "",
        Set = function(crane, color, refresh)
            SmugglerHangar.Cranes.Clear()
            if crane ~= "" then
                SetIplPropState(SmugglerHangar.interiorId, crane, true, refresh)
                SetInteriorPropColor(SmugglerHangar.interiorId, crane, color)
            else
                if (refresh) then
                    RefreshInterior(SmugglerHangar.interiorId)
                end
            end
        end,
        Clear = function(refresh)
            SetIplPropState(SmugglerHangar.interiorId, SmugglerHangar.Cranes.default, false, refresh)
        end
    },
    ModArea = {
        on = "set_modarea",
        off = "",
        Set = function(mod, color, refresh)
            if color == nil then
                color = 1
            end
            SmugglerHangar.ModArea.Clear(false)
            if mod ~= "" then
                SetIplPropState(SmugglerHangar.interiorId, mod, true, refresh)
                SetInteriorPropColor(SmugglerHangar.interiorId, mod, color)
            else
                if (refresh) then
                    RefreshInterior(SmugglerHangar.interiorId)
                end
            end
        end,
        Clear = function(refresh)
            SetIplPropState(SmugglerHangar.interiorId, SmugglerHangar.ModArea.mod, false, refresh)
        end
    },
    Office = {
        basic = "set_office_basic",
        modern = "set_office_modern",
        traditional = "set_office_traditional",
        Set = function(office, refresh)
            SmugglerHangar.Office.Clear(false)
            SetIplPropState(SmugglerHangar.interiorId, office, true, refresh)
        end,
        Clear = function(refresh)
            SetIplPropState(SmugglerHangar.interiorId, {SmugglerHangar.Office.basic, SmugglerHangar.Office.modern,
                                                        SmugglerHangar.Office.traditional}, false, refresh)
        end
    },
    Bedroom = {
        Style = {
            none = "",
            modern = {"set_bedroom_modern", "set_bedroom_tint"},
            traditional = {"set_bedroom_traditional", "set_bedroom_tint"},
            Set = function(bed, color, refresh)
                if color == nil then
                    color = 1
                end
                SmugglerHangar.Bedroom.Style.Clear(false)
                if bed ~= "" then
                    SetIplPropState(SmugglerHangar.interiorId, bed, true, refresh)
                    SetInteriorPropColor(SmugglerHangar.interiorId, "set_bedroom_tint", color)
                else
                    if (refresh) then
                        RefreshInterior(SmugglerHangar.interiorId)
                    end
                end
            end,
            Clear = function(refresh)
                SetIplPropState(SmugglerHangar.interiorId,
                    {SmugglerHangar.Bedroom.Style.modern, SmugglerHangar.Bedroom.Style.traditional}, false, refresh)
            end
        },
        Blinds = {
            none = "",
            opened = "set_bedroom_blinds_open",
            closed = "set_bedroom_blinds_closed",
            Set = function(blinds, refresh)
                SmugglerHangar.Bedroom.Blinds.Clear(false)
                if blinds ~= "" then
                    SetIplPropState(SmugglerHangar.interiorId, blinds, true, refresh)
                else
                    if (refresh) then
                        RefreshInterior(SmugglerHangar.interiorId)
                    end
                end
            end,
            Clear = function(refresh)
                SetIplPropState(SmugglerHangar.interiorId,
                    {SmugglerHangar.Bedroom.Blinds.opened, SmugglerHangar.Bedroom.Blinds.closed}, false, refresh)
            end
        }
    },
    Lighting = {
        FakeLights = {
            none = "",
            yellow = 2,
            blue = 1,
            white = 0,
            Set = function(light, refresh)
                SmugglerHangar.Lighting.FakeLights.Clear(false)
                if light ~= "" then
                    SetIplPropState(SmugglerHangar.interiorId, "set_lighting_tint_props", true, refresh)
                    SetInteriorPropColor(SmugglerHangar.interiorId, "set_lighting_tint_props", light)
                else
                    if (refresh) then
                        RefreshInterior(SmugglerHangar.interiorId)
                    end
                end
            end,
            Clear = function(refresh)
                SetIplPropState(SmugglerHangar.interiorId, "set_lighting_tint_props", false, refresh)
            end
        },
        Ceiling = {
            none = "",
            yellow = "set_lighting_hangar_a",
            blue = "set_lighting_hangar_b",
            white = "set_lighting_hangar_c",
            Set = function(light, refresh)
                SmugglerHangar.Lighting.Ceiling.Clear(false)
                if light ~= "" then
                    SetIplPropState(SmugglerHangar.interiorId, light, true, refresh)
                else
                    if (refresh) then
                        RefreshInterior(SmugglerHangar.interiorId)
                    end
                end
            end,
            Clear = function(refresh)
                SetIplPropState(SmugglerHangar.interiorId, {SmugglerHangar.Lighting.Ceiling.yellow,
                                                            SmugglerHangar.Lighting.Ceiling.blue,
                                                            SmugglerHangar.Lighting.Ceiling.white}, false, refresh)
            end
        },
        Walls = {
            none = "",
            neutral = "set_lighting_wall_neutral",
            blue = "set_lighting_wall_tint01",
            orange = "set_lighting_wall_tint02",
            lightYellow = "set_lighting_wall_tint03",
            lightYellow2 = "set_lighting_wall_tint04",
            dimmed = "set_lighting_wall_tint05",
            strongYellow = "set_lighting_wall_tint06",
            white = "set_lighting_wall_tint07",
            lightGreen = "set_lighting_wall_tint08",
            yellow = "set_lighting_wall_tint09",
            Set = function(light, refresh)
                SmugglerHangar.Lighting.Walls.Clear(false)
                if light ~= "" then
                    SetIplPropState(SmugglerHangar.interiorId, light, true, refresh)
                else
                    if (refresh) then
                        RefreshInterior(SmugglerHangar.interiorId)
                    end
                end
            end,
            Clear = function(refresh)
                SetIplPropState(SmugglerHangar.interiorId,
                    {SmugglerHangar.Lighting.Walls.neutral, SmugglerHangar.Lighting.Walls.blue,
                     SmugglerHangar.Lighting.Walls.orange, SmugglerHangar.Lighting.Walls.lightYellow,
                     SmugglerHangar.Lighting.Walls.lightYellow2, SmugglerHangar.Lighting.Walls.dimmed,
                     SmugglerHangar.Lighting.Walls.strongYellow, SmugglerHangar.Lighting.Walls.white,
                     SmugglerHangar.Lighting.Walls.lightGreen, SmugglerHangar.Lighting.Walls.yellow}, false, refresh)
            end
        }
    },
    Details = {
        bedroomClutter = "set_bedroom_clutter",
        Enable = function(details, state, refresh)
            SetIplPropState(SmugglerHangar.interiorId, details, state, refresh)
        end
    },

    LoadDefault = function()
        SmugglerHangar.Ipl.Interior.Load()

        SmugglerHangar.Walls.SetColor(SmugglerHangar.Colors.colorSet1)
        SmugglerHangar.Cranes.Set(SmugglerHangar.Cranes.on, SmugglerHangar.Colors.colorSet1)
        SmugglerHangar.Floor.Style.Set(SmugglerHangar.Floor.Style.plain)
        SmugglerHangar.Floor.Decals.Set(SmugglerHangar.Floor.Decals.decal1, SmugglerHangar.Colors.colorSet1)

        SmugglerHangar.Lighting.Ceiling.Set(SmugglerHangar.Lighting.Ceiling.yellow)
        SmugglerHangar.Lighting.Walls.Set(SmugglerHangar.Lighting.Walls.neutral)
        SmugglerHangar.Lighting.FakeLights.Set(SmugglerHangar.Lighting.FakeLights.yellow)

        SmugglerHangar.ModArea.Set(SmugglerHangar.ModArea.on, SmugglerHangar.Colors.colorSet1)

        SmugglerHangar.Office.Set(SmugglerHangar.Office.basic)

        SmugglerHangar.Bedroom.Style.Set(SmugglerHangar.Bedroom.Style.modern, SmugglerHangar.Colors.colorSet1)
        SmugglerHangar.Bedroom.Blinds.Set(SmugglerHangar.Bedroom.Blinds.opened)

        SmugglerHangar.Details.Enable(SmugglerHangar.Details.bedroomClutter, false)

        RefreshInterior(SmugglerHangar.interiorId)
    end
}

local function handleKeyPress(pZone, pData)
    if Throttled("SmugglerHangar", 3500) then
        return
    end

    if not exports["np-business"]:IsEmployedAt("ron_corp") then
        return
    end

    local playerID = PlayerPedId()

    RequestCollisionAtCoord(pData.emergeCenter.x, pData.emergeCenter.y, pData.emergeCenter.z)

    local isAllowed = false
    local currentVehicleClass = GetVehicleClass(GetVehiclePedIsIn(playerID, false))

    if pData.type == "car" and IsPedInAnyVehicle(playerID, false) then
        isAllowed = true
    elseif pData.type == "aircraftorcar" and IsPedInAnyVehicle(playerID, false) then
        isAllowed = true
    elseif pData.type == "aircraft" and (currentVehicleClass == 15 or currentVehicleClass == 16) then
        isAllowed = true
    elseif pData.type == "ped" and not IsPedInAnyVehicle(playerID, false) then
        isAllowed = true
    end

    if isAllowed then
        local hasSafeCoord, groundZ = GetGroundZFor_3dCoord(pData.emergeCenter.x, pData.emergeCenter.y,
            pData.emergeCenter.z, 0)

        SetPedCoordsKeepVehicle(PlayerPedId(), pData.emergeCenter.x, pData.emergeCenter.y,
            hasSafeCoord and groundZ or pData.emergeCenter.z)

        FreezeEntityPosition(playerID, true)
        SetPlayerInvincible(playerID, true)
        local collisionTimer = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(playerID) do
            if GetGameTimer() - collisionTimer > 5000 then
                break
            end
            Wait(0)
        end
        FreezeEntityPosition(playerID, false)
        SetPlayerInvincible(playerID, false)
    end
end

function listenForKeypress(pListenCounter, pZone, pData)
    Citizen.CreateThread(function()
        while listenCounter == pListenCounter do
            if IsControlJustReleased(0, 38) then
                handleKeyPress(pZone, pData)
            end
            Wait(0)
        end
    end)
end

AddEventHandler("np-polyzone:enter", function(pZone, pData)
    if pZone ~= "unknown_location" then
        return
    end
    listenForKeypress(listenCounter, pZone, pData)
end)

AddEventHandler("np-polyzone:exit", function(pZone, pData)
    if pZone ~= "unknown_location" then
        return
    end
    listenCounter = listenCounter + 1
end)

CreateThread(function()
    exports["np-polyzone"]:AddBoxZone("unknown_location", vector3(-1143.99, -3396.62, 47.85), 34.4, 21.8, {
        heading = 330,
        minZ = 12.8,
        maxZ = 29.4,
        data = {
            id = "outside_hangar",
            isOutside = true,
            type = "aircraftorcar",
            emergeCenter = vector3(-1266.85, -3012.09, -48.49)
        }
    })

    exports["np-polyzone"]:AddBoxZone("unknown_location", vector3(-1266.85, -3012.09, -48.49), 35.2, 29.0, {
        heading = 0,
        minZ = -49.49,
        maxZ = -35.29,
        data = {
            id = "inside_hangar",
            isOutside = false,
            type = "aircraft",
            emergeCenter = vector3(-1143.99, -3396.62, 47.85)
        }
    })

    exports["np-polyzone"]:AddBoxZone("unknown_location", vector3(-1238.71, -3059.8, -48.49), 19.8, 10, {
        heading = 0,
        minZ = -49.49,
        maxZ = -41.09,
        data = {
            id = "inside_car",
            isOutside = false,
            type = "car",
            emergeCenter = vector3(-1143.99, -3396.62, 47.85)
        }
    })

    exports["np-polyzone"]:AddBoxZone("unknown_location", vector3(-1221.13, -2985.22, -48.49), 5, 5, {
        heading = 0,
        minZ = -49.49,
        maxZ = -45.49,
        data = {
            id = "inside_walk",
            isOutside = false,
            type = "ped",
            emergeCenter = vector3(-1219.85, -3490.28, 13.94)
        }
    })

    exports["np-polyzone"]:AddBoxZone("unknown_location", vector3(-1219.85, -3490.28, 13.94), 2.4, 2.6, {
        heading = 330,
        minZ = 12.94,
        maxZ = 15.34,
        data = {
            id = "outside_walk",
            isOutside = true,
            type = "ped",
            emergeCenter = vector3(-1221.13, -2985.22, -48.49)
        }
    })

    SmugglerHangar.LoadDefault()
end)
