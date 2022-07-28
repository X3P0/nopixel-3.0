--[[
cl_bennys.lua
Functionality that handles the player for Benny's.
Handles applying mods, etc.
]]

--#[Global Variables]#--
isPlyInBennys = false
bennysAccess = nil
local businesses = {}

isAtEmployedBennys = false
isAtRepairsOnlyBennys = false
isAtPreviewBennys = false
isVinScratched = false
VehicleClass = "C"
local originalParts = {}
boughtParts = {}

--#[Local Variables]#--
local plyFirstJoin = false
devmode = false

local currentBennys = nil

local bennysLocations = {
    ["bennys"] = {
        pos = vector3(-211.55, -1324.55, 30.90),
        heading = 320.0
    },
    ["bennystuner"] = {
        pos = vector3(145.01, -3030.59, 7.04),
        employed = true,
        heading = 180.0,
    },
    ["bennystunercatalog"] = {
        pos = vector3(135.88, -3030.43, 7.04),
        employed = true,
        heading = 0,
    },
    ["bennystunercatalog_2"] = {
        pos = vector3(124.54, -3047.26, 7.04),
        heading = 90.0,
        access = 'tuner',
        preview = true,
    },
    ["bennysimport"] = {
        pos = vector3(-772.92,-234.92,37.08),
        heading = 204.0,
        access = 'fastlane'
    },
    ["bennysbridge"] = {
        pos = vector3(727.74, -1088.95, 22.17),
        heading = 270.0
    },
    ["bennysmrpd"] = {
        pos = vector3(451.84, -975.96, 25.51),
        heading = 90.0,
        access = 'police'
    },
    ["bennysvbpd"] = {
      pos = vector3(-1117.81, -826.58, 3.75),
      heading = 36.0,
      access = 'police'
    },
    ["bennysprpd"] = {
      pos = vector3(372.83, 787.11, 186.73),
      heading = 348.88,
      access = 'police'
    },
    ["bennyspaletopd"] = {
      pos = vector3(-458.6, 5980.71, 31.33),
      heading = 313.0,
      access = 'police'
    },
    ["bennyspillbox"] = {
        pos = vector3(340.39, -570.6, 28.8),
        heading = 160.0,
        access = 'police'
    },
    ["bennyspaleto"] = {
        pos = vector3(110.8, 6626.46, 32.0),
        heading = 44.0,
        repairOnly = true
    },
    ["bennysboats"] = {
        pos = vector3(-809.83, -1507.21, 14.4),
        heading = 130.63,
    },
    ["bennysplanes"] = {
        pos = vector3(-1652.52, -3143.0, 13.99),
        heading = 240,
    },
    ["bennysrex"] = {
        pos = vector3(2522.64, 2621.78, 37.96),
        heading = 267.62,
    },
    ["bennyshubrepairs"] = {
        pos = vector3(-32.93, -1054.76, 27.72),
        heading = 25.0,
        repairOnly = true
    },
    ["bennysflightschool"] = {
        pos = vector3(-1816.93,2966.99,32.82),
        heading = 57.17,
    },
    ["bennyssandypd"] = {
        pos = vector3(1812.71, 3687.85, 33.98),
        heading = 299.14,
        access = 'police'
    },
    ["bennyspdm"] = {
        pos = vector3(841.73, -813.35, 26.32),
        heading = 0.0,
        access = 'pdm',
        preview = true,
    },
    ["bennysbogbikes"] = {
        pos = vector3(-1114.66, -1686.83, 4.37),
        heading = 304.37,
        access = 'bogg_bikes',
    },
    ["bennysdavispd"] = {
        pos = vector3(380.23, -1625.57, 29.3),
        heading = 319.19,
        access = 'police',
    },
    ["bennyslamesapd"] = {
        pos = vector3(870.2, -1349.93, 26.31),
        heading = 85.73,
        access = 'police',
    },
    ["bennysdriftschool"] = {
        pos = vector3(-169.97, -2463.45, 6.31),
        heading = 313.36,
        repairOnly = true
    },
    ["bennysvinewood"] = {
        pos = vector3(140.06, 317.68, 112.14),
        heading = 116.9,
        repairOnly = true
    },
    ["bennyselburro"] = {
        pos = vector3(1212.6, -1511.62, 34.7),
        heading = 270.5,
        access = 'police'
    },
}

local specialMotorcycles = {
    [`npolmm`] = `npolmm`
}

local originalCategory = nil
local originalMod = nil
local originalPrimaryColour = nil
local originalSecondaryColour = nil
local originalPearlescentColour = nil
local originalWheelColour = nil
local originalDashColour = nil
local originalInterColour = nil
local originalWindowTint = nil
local originalWheelCategory = nil
local originalWheel = nil
local originalWheelType = nil
local originalCustomWheels = nil
local originalNeonLightState = nil
local originalNeonLightSide = nil
local originalNeonColourR = nil
local originalNeonColourG = nil
local originalNeonColourB = nil
local originalXenonColour = nil
local originalOldLivery = nil
local originalPlateIndex = nil
local originalXenonState = nil
local originalTurboState = nil

local attemptingPurchase = false
local isPurchaseSuccessful = false

function fixNeonColor(veh, values)
    local colors = {}

    for index, value in ipairs({GetVehicleNeonLightsColour(veh)}) do
        colors[index] = value

        if (values[index] ~= -2) then
            colors[index] = values[index]
        end
    end

    return colors
end

function fixNeonLights(veh, values)
    local lights = {}

    for i = 0, 3, 1 do
        lights[i] = IsVehicleNeonLightEnabled(veh, i)

        if values[i] ~= -2 then
            lights[i] = values[i]
        end
    end

    return lights
end

--#[Local Functions]#--
local function saveVehicle()
    local plyPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(plyPed, false)
    local vehicleMods = getVehicleMods(veh)

    if isAtEmployedBennys and not isAtPreviewBennys then
        local changedStuff = difference(vehicleMods, originalParts)

        if (changedStuff == nil) then
            return
        end

        if changedStuff.lights then
            changedStuff.lights = fixNeonColor(veh, changedStuff.lights)
        end

        if changedStuff.neon then
           changedStuff.neon = fixNeonLights(veh, changedStuff.neon)
        end

        -- TriggerEvent("player:receiveItem", "bennysorder", 1, false, changedStuff)
        TriggerEvent("np-jobs:bennys:order", veh, changedStuff)
        print(json.encode(changedStuff))
        return
    end
    TriggerServerEvent("updateVehicle", vehicleMods, GetVehicleNumberPlateText(veh))
end

function getVehicleMods(veh)
    local vehicleMods = {
        neon = {},
        colors = {},
        extracolors = {},
        dashColour = -1,
        interColour = -1,
        lights = {},
        tint = GetVehicleWindowTint(veh),
        wheeltype = GetVehicleWheelType(veh),
        platestyle = GetVehicleNumberPlateTextIndex(veh),
        mods = {},
        smokecolor = {},
        xenonColor = -1,
        oldLiveries = 24,
        extras = {},
        plateIndex = 0
    }

    vehicleMods.xenonColor = GetCurrentXenonColour(veh)
    vehicleMods.lights[1], vehicleMods.lights[2], vehicleMods.lights[3] = GetVehicleNeonLightsColour(veh)
    vehicleMods.colors[1], vehicleMods.colors[2] = GetVehicleColours(veh)
    vehicleMods.extracolors[1], vehicleMods.extracolors[2] = GetVehicleExtraColours(veh)
    vehicleMods.smokecolor[1], vehicleMods.smokecolor[2], vehicleMods.smokecolor[3] = GetVehicleTyreSmokeColor(veh)
    vehicleMods.dashColour = GetVehicleInteriorColour(veh)
    vehicleMods.interColour = GetVehicleDashboardColour(veh)
    vehicleMods.oldLiveries = GetVehicleLivery(veh)
    vehicleMods.plateIndex = GetVehicleNumberPlateTextIndex(veh)

    for i = 0, 3 do
        vehicleMods.neon[i] = IsVehicleNeonLightEnabled(veh, i)
    end

    for i = 0, 16 do
        vehicleMods.mods[i] = GetVehicleMod(veh, i)
    end

    for i = 17, 22 do
        vehicleMods.mods[i] = IsToggleModOn(veh, i)
    end

    for i = 23, 48 do
        vehicleMods.mods[i] = GetVehicleMod(veh, i)
    end

    for i = 1, 12 do
        local ison = IsVehicleExtraTurnedOn(veh, i)
        if 1 == tonumber(ison) then
            vehicleMods.extras[i] = 1
        else
            vehicleMods.extras[i] = 0
        end
    end
    return vehicleMods
end

--https://stackoverflow.com/questions/24621346/differences-between-two-tables-in-lua
function difference(t1, t2)
    local diff = {}
    local bool = false
    for i, v in pairs (t1) do
        if t2 and type (v) == "table" then
            local deep_diff = difference (t1[i], t2[i])
            if deep_diff then
                diff[i] = deep_diff
                bool = true
            end
        elseif t2 then
            if not (t1[i] == t2[i]) then
                diff[i] = t1[i]
                bool = true
            else
                diff[i] = -2
            end
        else
            diff[i] = t1[i]
            bool = true
        end
    end

    if bool then
        return diff
    end
end

-- #[Global Functions]#--
function IsSpecialMotorcycle()
    local plyPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(plyPed, false)
    local model = GetEntityModel(veh)

    if specialMotorcycles[model] ~= nil then
        return true
    else
        return false
    end
end

function AttemptPurchase(purchaseType, upgradeLevel)
    if isAtEmployedBennys and not (purchaseType == "repair") then
        local plyPed = PlayerPedId()
        local veh = GetVehiclePedIsIn(plyPed, false)
        local vehicleMods = getVehicleMods(veh)
        local changedStuff = difference(vehicleMods, originalParts)
        boughtParts = {}
        if changedStuff == nil then
            SendNUIMessage({updateBoughtParts = boughtParts})
            return true
        end
        for partKey, changedPart in pairs(changedStuff) do
            if partKey == "platestyle" or partKey == "wheeltype" then
                goto continue
            end
            if changedPart == -2 then goto continue end
            if type(changedPart) == "table" then
                local appliedNeons = false
                for modKey, modValue in pairs(changedPart) do
                    if modValue == -2 then goto modContinue end
                    if partKey == "mods" then
                        local price = 0
                        local modLabel = GetLabelText(GetModTextLabel(veh, modKey, modValue))
                        if modLabel == "NULL" then
                            for _, cust in ipairs(vehicleCustomisation) do
                                if tonumber(cust.id) == modKey then
                                    modLabel = cust.category
                                    break
                                end
                            end
                        end
                        if modKey == 18 then
                            price = GetPartPrice("mods", Mods[modKey + 1], modValue + 2, VehicleClass)
                        elseif modKey == 11 or modKey == 12 or modKey == 13 or modKey == 15 or modKey == 16 then
                            price = GetPartPrice("mods", Mods[modKey + 1], modValue + 2, VehicleClass)
                        elseif modKey == 22 then
                            modLabel = "Xenons"
                            price = GetPartPrice("mods", "XenonHeadlights", modValue + 2, VehicleClass)
                        else
                            price = GetPartPrice("mods", Mods[modKey + 1], modValue + 2, VehicleClass)
                        end
                        boughtParts[#boughtParts + 1] = {name = modLabel, price = price}
                    end
                    if partKey == "colors" or partKey == "extracolors" then
                        boughtParts[#boughtParts + 1] = {name = "Respraying", price = GetPartPrice("colors", "primary", 2, VehicleClass)}
                    end
                    if partKey == "neon" then
                        boughtParts[#boughtParts + 1] = {name = "Neons", price = GetPartPrice("additionals", "neon", 2, VehicleClass)}
                    end
                    if partKey == "lights" then
                        if appliedNeons then goto modContinue end
                        appliedNeons = true
                        boughtParts[#boughtParts + 1] = {name = "Neon Colors", price = GetPartPrice("colors", "neon", 2, VehicleClass)}
                    end
                    ::modContinue::
                end
            else
                local partToPrice = {
                    ["wheels"] = GetPartPrice("mods", "FrontWheels", changedPart + 2, VehicleClass),
                    ["customwheels"] = 0,
                    ["wheelsmoke"] = 0,
                    ["tint"] = GetPartPrice("additionals", "tint", changedPart + 2, VehicleClass),
                    ["dashColour"] = GetPartPrice("colors", "dashboard", changedPart + 2, VehicleClass),
                    ["interColour"] = GetPartPrice("colors", "interior", changedPart + 2, VehicleClass),
                    ["xenonColor"] = GetPartPrice("colors", "xenon", changedPart + 2, VehicleClass),
                    ["oldlivery"] = 100,
                    ["plateIndex"] = GetPartPrice("additionals", "plateIndex", changedPart + 2, VehicleClass),
                }
                boughtParts[#boughtParts + 1] = {name = partKey, price = partToPrice[partKey]}
            end
            ::continue::
        end
        SendNUIMessage({updateBoughtParts = boughtParts})
        return true
    end

    if currentBennys:find('^devbennys') then
        return true
    end

    local bennys = bennysLocations[currentBennys]
    if bennys.access and (bennys.access == "police" or bennys.access == "ems") and purchaseType == "repair" then
        return RPC.execute("np-bennys:jobRepair")
    end

    local cheap, pd = false, false

    if currentBennys == "bennystuner" or currentBennys == "bennysimport" then
        cheap = true
    end

    if upgradeLevel ~= nil then
        upgradeLevel = upgradeLevel + 2
    end

    if (bennys.access == "police" or bennys.access == "ems") then
        local free = exports['np-config']:GetMiscConfig('bennys.pd.free')

        pd = free
    end
    TriggerServerEvent("np-bennys:attemptPurchase", cheap, purchaseType, upgradeLevel, pd)

    attemptingPurchase = true

    while attemptingPurchase do
        Citizen.Wait(1)
    end

    if not isPurchaseSuccessful then
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    return isPurchaseSuccessful
end

function RepairVehicle()
    Citizen.CreateThread(function ()
        local plyPed = PlayerPedId()
        local plyVeh = GetVehiclePedIsIn(plyPed, false)

        local vehBodyHealth = GetVehicleBodyHealth(plyVeh)
        local vehEngineHealth = GetVehicleEngineHealth(plyVeh)

        local missingBodyHealth = 1000.0 - vehBodyHealth
        local missingEngineHealth = 1000.0 - vehEngineHealth

        SetVehicleHandbrake(plyVeh, true)

        if (missingEngineHealth > 50) then
            local finished = exports["np-taskbar"]:taskBar(5000 + (missingEngineHealth / 50), "Repairing engine...", true, nil, nil, nil, nil, 6.0)

            if finished == 100 then
                SetVehicleEngineHealth(plyVeh, 1000.0)

                SetVehiclePetrolTankHealth(plyVeh, 4000.0)
            end
        end

        if missingBodyHealth > 50 then
            local finished = exports["np-taskbar"]:taskBar(5000 + (missingBodyHealth / 50), "Repairing body...", true, nil, nil, nil, nil, 6.0)

            if finished == 100 then
                SetVehicleBodyHealth(plyVeh, 1000.0)

                SetVehicleDeformationFixed(plyVeh)
            end
        end

        if (GetVehicleBodyHealth(plyVeh) >= 900 and GetVehicleEngineHealth(plyVeh) >= 900) then
            SetVehicleFixed(plyVeh)

            SetVehicleDirtLevel(plyVeh, 0.0)
        end

        SetVehicleHandbrake(plyVeh, false)
    end)
end

function GetCurrentMod(id)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local mod = GetVehicleMod(plyVeh, id)
    local modName = GetLabelText(GetModTextLabel(plyVeh, id, mod))

    return mod, modName
end

function GetCurrentWheel()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local wheel = GetVehicleMod(plyVeh, 23)
    local wheelName = GetLabelText(GetModTextLabel(plyVeh, 23, wheel))
    local wheelType = GetVehicleWheelType(plyVeh)

    return wheel, wheelName, wheelType
end

function GetCurrentCustomWheelState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local state = GetVehicleModVariation(plyVeh, 23)

    if state then
        return 1
    else
        return 0
    end
end

function GetOriginalWheel()
    return originalWheel
end

function GetOriginalCustomWheel()
    return originalCustomWheels
end

function GetCurrentWindowTint()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    return GetVehicleWindowTint(plyVeh)
end

function GetCurrentVehicleWheelSmokeColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local r, g, b = GetVehicleTyreSmokeColor(plyVeh)

    return r, g, b
end

function GetCurrentNeonState(id)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsVehicleNeonLightEnabled(plyVeh, id)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function GetCurrentNeonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local r, g, b = GetVehicleNeonLightsColour(plyVeh)

    return r, g, b
end

function GetCurrentXenonState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsToggleModOn(plyVeh, 22)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function GetCurrentXenonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    return GetVehicleHeadlightsColour(plyVeh)
end

function GetCurrentTurboState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsToggleModOn(plyVeh, 18)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function GetCurrentExtraState(extra)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    return IsVehicleExtraTurnedOn(plyVeh, extra)
end

function CheckValidMods(category, id, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local tempMod = GetVehicleMod(plyVeh, id)
    local tempWheel = GetVehicleMod(plyVeh, 23)
    local tempWheelType = GetVehicleWheelType(plyVeh)
    local tempWheelCustom = GetVehicleModVariation(plyVeh, 23)
    local validMods = {}
    local amountValidMods = 0
    local hornNames = {}

    if wheelType ~= nil then
        SetVehicleWheelType(plyVeh, wheelType)
    end

    if id == 14 then
        for k, v in pairs(vehicleCustomisation) do
            if vehicleCustomisation[k].category == category then
                hornNames = vehicleCustomisation[k].hornNames

                break
            end
        end
    end

    local modAmount = GetNumVehicleMods(plyVeh, id)
    for i = 1, modAmount do
        local label = GetModTextLabel(plyVeh, id, (i - 1))
        local modName = GetLabelText(label)

        if modName == "NULL" then
            if id == 14 then
                if i <= #hornNames then
                    modName = hornNames[i].name
                else
                    modName = "Horn " .. i
                end
            else
                modName = category .. " " .. i
            end
        end

        validMods[i] =
        {
            id = (i - 1),
            name = modName
        }

        amountValidMods = amountValidMods + 1
    end

    if modAmount > 0 then
        table.insert(validMods, 1, {
            id = -1,
            name = "Stock " .. category
        })
    end

    if wheelType ~= nil then
        SetVehicleWheelType(plyVeh, tempWheelType)
        SetVehicleMod(plyVeh, 23, tempWheel, tempWheelCustom)
    end

    return validMods, amountValidMods
end

function RestoreOriginalMod()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleMod(plyVeh, originalCategory, originalMod)
    SetVehicleDoorsShut(plyVeh, true)

    originalCategory = nil
    originalMod = nil
end

function RestoreOriginalWindowTint()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleWindowTint(plyVeh, originalWindowTint)

    originalWindowTint = nil
end

function RestoreOriginalColours()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleColours(plyVeh, originalPrimaryColour, originalSecondaryColour)
    SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)
    SetVehicleDashboardColour(plyVeh, originalDashColour)
    SetVehicleInteriorColour(plyVeh, originalInterColour)

    originalPrimaryColour = nil
    originalSecondaryColour = nil
    originalPearlescentColour = nil
    originalWheelColour = nil
    originalDashColour = nil
    originalInterColour = nil
end

function RestoreOriginalColourPresets()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleColours(plyVeh, originalPrimaryColour, originalSecondaryColour)
    SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)

    originalPrimaryColour = nil
    originalSecondaryColour = nil
    originalPearlescentColour = nil
    originalWheelColour = nil
end

function RestoreOriginalWheels()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    SetVehicleWheelType(plyVeh, originalWheelType)

    if originalWheelCategory ~= nil then
        SetVehicleMod(plyVeh, originalWheelCategory, originalWheel, originalCustomWheels)

        if GetVehicleClass(plyVeh) == 8 or IsSpecialMotorcycle() then --Motorcycle
            SetVehicleMod(plyVeh, 24, originalWheel, originalCustomWheels)
        end

        originalWheelType = nil
        originalWheelCategory = nil
        originalWheel = nil
        originalCustomWheels = nil
    end
end

function RestoreOriginalNeonStates()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleNeonLightEnabled(plyVeh, originalNeonLightSide, originalNeonLightState)

    originalNeonLightState = nil
    originalNeonLightSide = nil
end

function RestoreOriginalNeonColours()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleNeonLightsColour(plyVeh, originalNeonColourR, originalNeonColourG, originalNeonColourB)

    originalNeonColourR = nil
    originalNeonColourG = nil
    originalNeonColourB = nil
end

function RestoreOriginalXenonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleHeadlightsColour(plyVeh, originalXenonColour)
    SetVehicleLights(plyVeh, 0)

    originalXenonColour = nil
end

function RestoreOldLivery()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleLivery(plyVeh, originalOldLivery)
end

function RestorePlateIndex()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleNumberPlateTextIndex(plyVeh, originalPlateIndex)
end

function RestoreXenonState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    ToggleVehicleMod(plyVeh, 22, originalXenonState)
end

function RestoreTurboState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    ToggleVehicleMod(plyVeh, 18, originalTurboState)
end

function PreviewMod(categoryID, modID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalMod == nil and originalCategory == nil then
        originalCategory = categoryID
        originalMod = GetVehicleMod(plyVeh, categoryID)
    end

    if categoryID == 39 or categoryID == 40 or categoryID == 41 then
        SetVehicleDoorOpen(plyVeh, 4, false, true)
    elseif categoryID == 37 or categoryID == 38 then
        SetVehicleDoorOpen(plyVeh, 5, false, true)
    end

    SetVehicleMod(plyVeh, categoryID, modID)
    if categoryID == 39 or categoryID == 4 then
        exports['np-vehiclesync']:SetEngineSound(plyVeh, true)
        TriggerServerEvent('np-vehicleSync:updateSyncState', NetworkGetNetworkIdFromEntity(plyVeh), 'engineSound')
    end
end

function PreviewWindowTint(windowTintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalWindowTint == nil then
        originalWindowTint = GetVehicleWindowTint(plyVeh)
    end

    SetVehicleWindowTint(plyVeh, windowTintID)
end

function PreviewXenonState(state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalXenonState == nil then
        originalXenonState = IsToggleModOn(plyVeh, 22)
    end

    ToggleVehicleMod(plyVeh, 22, state)
end

function PreviewTurboState(state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalTurboState == nil then
        originalTurboState = IsToggleModOn(plyVeh, 18)
    end

    ToggleVehicleMod(plyVeh, 18, state)
end

function PreviewColour(paintType, paintCategory, paintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleModKit(plyVeh, 0)
    if originalDashColour == nil and originalInterColour == nil and originalPrimaryColour == nil and originalSecondaryColour == nil and originalPearlescentColour == nil and originalWheelColour == nil then
        originalPrimaryColour, originalSecondaryColour = GetVehicleColours(plyVeh)
        originalPearlescentColour, originalWheelColour = GetVehicleExtraColours(plyVeh)
        originalDashColour = GetVehicleDashboardColour(plyVeh)
        originalInterColour = GetVehicleInteriorColour(plyVeh)
    end
    if paintType == 0 then --Primary Colour
        if paintCategory == 1 then --Metallic Paint
            SetVehicleColours(plyVeh, paintID, originalSecondaryColour)
            SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)
        else
            SetVehicleColours(plyVeh, paintID, originalSecondaryColour)
        end
    elseif paintType == 1 then --Secondary Colour
        SetVehicleColours(plyVeh, originalPrimaryColour, paintID)
    elseif paintType == 2 then --Pearlescent Colour
        SetVehicleExtraColours(plyVeh, paintID, originalWheelColour)
    elseif paintType == 3 then --Wheel Colour
        SetVehicleExtraColours(plyVeh, originalPearlescentColour, paintID)
    elseif paintType == 4 then --Dash Colour
        SetVehicleDashboardColour(plyVeh, paintID)
    elseif paintType == 5 then --Interior Colour
        SetVehicleInteriorColour(plyVeh, paintID)
    end
end

function PreviewColourPresets(presetId)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleModKit(plyVeh, 0)

    if originalPrimaryColour == nil and originalSecondaryColour == nil and originalPearlescentColour == nil and originalWheelColour == nil then
        originalPrimaryColour, originalSecondaryColour = GetVehicleColours(plyVeh)
        originalPearlescentColour, originalWheelColour = GetVehicleExtraColours(plyVeh)
    end

    SetVehicleColourCombination(plyVeh, presetId)
end

function PreviewWheel(categoryID, wheelID, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    if originalWheelCategory == nil and originalWheel == nil and originalWheelType == nil and originalCustomWheels == nil then
        originalWheelCategory = categoryID
        originalWheelType = GetVehicleWheelType(plyVeh)
        originalWheel = GetVehicleMod(plyVeh, 23)
        originalCustomWheels = GetVehicleModVariation(plyVeh, 23)
    end

    SetVehicleWheelType(plyVeh, wheelType)
    SetVehicleMod(plyVeh, categoryID, wheelID, doesHaveCustomWheels)

    if GetVehicleClass(plyVeh) == 8 or IsSpecialMotorcycle() then --Motorcycle
        SetVehicleMod(plyVeh, 24, wheelID, doesHaveCustomWheels)
    end
end

function PreviewNeon(side, enabled)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalNeonLightState == nil and originalNeonLightSide == nil then
        if IsVehicleNeonLightEnabled(plyVeh, side) then
            originalNeonLightState = 1
        else
            originalNeonLightState = 0
        end

        originalNeonLightSide = side
    end

    SetVehicleNeonLightEnabled(plyVeh, side, enabled)
end

function PreviewNeonColour(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalNeonColourR == nil and originalNeonColourG == nil and originalNeonColourB == nil then
        originalNeonColourR, originalNeonColourG, originalNeonColourB = GetVehicleNeonLightsColour(plyVeh)
    end

    SetVehicleNeonLightsColour(plyVeh, r, g, b)
end

function PreviewXenonColour(colour)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalXenonColour == nil then
        originalXenonColour = GetVehicleHeadlightsColour(plyVeh)
    end

    SetVehicleLights(plyVeh, 2)
    SetVehicleHeadlightsColour(plyVeh, colour)
end

function PreviewOldLivery(liv)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    if originalOldLivery == nil then
        originalOldLivery = GetVehicleLivery(plyVeh)
    end

    SetVehicleLivery(plyVeh, tonumber(liv))
end

function PreviewPlateIndex(index)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    if originalPlateIndex == nil then
        originalPlateIndex = GetVehicleNumberPlateTextIndex(plyVeh)
    end

    SetVehicleNumberPlateTextIndex(plyVeh, tonumber(index))
end

function ApplyMod(categoryID, modID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if categoryID == 18 then
        ToggleVehicleMod(plyVeh, categoryID, modID)
        originalTurboState = modID
    elseif categoryID == 11 or categoryID == 12 or categoryID== 13 or categoryID == 15 or categoryID == 16 then --Performance Upgrades
        originalCategory = categoryID
        originalMod = modID

        SetVehicleMod(plyVeh, categoryID, modID)
    else
        originalCategory = categoryID
        originalMod = modID

        SetVehicleMod(plyVeh, categoryID, modID)
    end
end

local toggleVehMap = {}
function ApplyExtra(plyVeh, extraID)
    -- local isEnabled = IsVehicleExtraTurnedOn(plyVeh, extraID)
    -- the above native seems to return false every time
    toggleVehMap[plyVeh] = toggleVehMap[plyVeh] == 0 and 1 or 0
    SetVehicleExtra(plyVeh, tonumber(extraID), toggleVehMap[plyVeh])
    SetVehiclePetrolTankHealth(plyVeh,4000.0)
end

RegisterCommand("+toggleVehicleMod", function(src, args)
local plyPed = PlayerPedId()
  local plyVeh = GetVehiclePedIsIn(plyPed, false)
  ApplyExtra(plyVeh, args[1])
end)

function ApplyPreset(presetId)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleColourCombination(plyVeh, presetId)

    originalPrimaryColour, originalSecondaryColour = GetVehicleColours(plyVeh)
    originalPearlescentColour, originalWheelColour = GetVehicleExtraColours(plyVeh)
end

function ApplyWindowTint(windowTintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalWindowTint = windowTintID

    SetVehicleWindowTint(plyVeh, windowTintID)
end

function ApplyColour(paintType, paintCategory, paintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local vehPrimaryColour, vehSecondaryColour = GetVehicleColours(plyVeh)
    local vehPearlescentColour, vehWheelColour = GetVehicleExtraColours(plyVeh)

    if paintType == 0 then --Primary Colour
        if paintCategory == 1 then --Metallic Paint
            SetVehicleColours(plyVeh, paintID, vehSecondaryColour)
            -- SetVehicleExtraColours(plyVeh, paintID, vehWheelColour)
            SetVehicleExtraColours(plyVeh, originalPearlescentColour, vehWheelColour)
            originalPrimaryColour = paintID
            -- originalPearlescentColour = paintID
        else
            SetVehicleColours(plyVeh, paintID, vehSecondaryColour)
            originalPrimaryColour = paintID
        end
    elseif paintType == 1 then --Secondary Colour
        SetVehicleColours(plyVeh, vehPrimaryColour, paintID)
        originalSecondaryColour = paintID
    elseif paintType == 2 then --Pearlescent Colour
        SetVehicleExtraColours(plyVeh, paintID, vehWheelColour)
        originalPearlescentColour = paintID
    elseif paintType == 3 then --Wheel Colour
        SetVehicleExtraColours(plyVeh, vehPearlescentColour, paintID)
        originalWheelColour = paintID
    elseif paintType == 4 then --Dash Colour
        SetVehicleDashboardColour(plyVeh, paintID)
        originalDashColour = paintID
    elseif paintType == 5 then --Interior Colour
        SetVehicleInteriorColour(plyVeh, paintID)
        originalInterColour = paintID
    end
end

function ApplyWheel(categoryID, wheelID, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    originalWheelCategory = categoryID
    originalWheel = wheelID
    originalWheelType = wheelType

    SetVehicleWheelType(plyVeh, wheelType)
    SetVehicleMod(plyVeh, categoryID, wheelID, doesHaveCustomWheels)

    if GetVehicleClass(plyVeh) == 8 or IsSpecialMotorcycle() then --Motorcycle
        SetVehicleMod(plyVeh, 24, wheelID, doesHaveCustomWheels)
    end
end

function ApplyCustomWheel(state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleMod(plyVeh, 23, GetVehicleMod(plyVeh, 23), state)

    if GetVehicleClass(plyVeh) == 8 or IsSpecialMotorcycle() then --Motorcycle
        SetVehicleMod(plyVeh, 24, GetVehicleMod(plyVeh, 24), state)
    end
end

function ApplyNeon(side, enabled)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalNeonLightState = enabled
    originalNeonLightSide = side

    SetVehicleNeonLightEnabled(plyVeh, side, enabled)
end

function ApplyNeonColour(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalNeonColourR = r
    originalNeonColourG = g
    originalNeonColourB = b

    SetVehicleNeonLightsColour(plyVeh, r, g, b)
end

function ApplyXenonLights(category, state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    originalXenonState = state
    ToggleVehicleMod(plyVeh, category, state)
end

function ApplyXenonColour(colour)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalXenonColour = colour

    SetVehicleHeadlightsColour(plyVeh, colour)
end

function ApplyOldLivery(liv)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalOldLivery = liv

    SetVehicleLivery(plyVeh, liv)
end

function ApplyPlateIndex(index)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    originalPlateIndex = index
    SetVehicleNumberPlateTextIndex(plyVeh, index)
end

function ApplyTyreSmoke(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    ToggleVehicleMod(plyVeh, 20, true)
    SetVehicleTyreSmokeColor(plyVeh, r, g, b)
end

function ExitBennys()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    saveVehicle()
    if isAtEmployedBennys and not isAtPreviewBennys then
        for i = 0,48 do
            local modId = originalParts.mods[i]
            if i >= 18 and i <= 22 then
                ToggleVehicleMod(plyVeh, i, modId)
            else
                SetVehicleMod(plyVeh, i, tonumber(modId))
            end
        end

        -- for i = 1, 12 do
        --     SetVehicleExtra(plyVeh, i, originalParts.extras[i] == 0)
        -- end

        originalPrimaryColour = originalParts.colors[1]
        originalSecondaryColour = originalParts.colors[2]
        originalPearlescentColour = originalParts.extracolors[1]
        originalWheelColour = originalParts.extracolors[2]
        originalDashColour = originalParts.dashColour
        originalInterColour = originalParts.interColour
        originalWindowTint = originalParts.tint
        -- originalWheelCategory = originalParts["originalWheelCategory"]
        -- originalWheel = originalParts["originalWheel"]
        -- originalCustomWheels = originalParts["originalCustomWheels"]
        originalWheelType = originalParts.wheeltype
        originalNeonColourR = originalParts.lights[1]
        originalNeonColourG = originalParts.lights[2]
        originalNeonColourB = originalParts.lights[3]
        originalXenonColour = originalParts.xenonColor
        originalOldLivery = originalParts.oldLiveries
        originalPlateIndex = originalParts.plateIndex

        for i = 0, 3 do
            originalNeonLightSide = i
            originalNeonLightState = originalParts.neon[i]
            RestoreOriginalNeonStates()
        end

        RestoreOriginalWheels()
        RestoreOriginalNeonColours()
        RestoreOriginalXenonColour()
        RestoreOriginalColourPresets()
        RestoreOriginalWindowTint()
        RestoreOldLivery()
        RestorePlateIndex()
        exports['np-vehiclesync']:SetEngineSound(plyVeh)
        TriggerServerEvent('np-vehicleSync:updateSyncState', NetworkGetNetworkIdFromEntity(plyVeh), 'engineSound')

        originalParts = {}
    end


    DisplayMenuContainer(false)

    -- FreezeEntityPosition(plyVeh, false)
    -- SetEntityCollision(plyVeh, true, true)

    SetTimeout(100, function()
        DestroyMenus()
    end)

    isPlyInBennys = false

    TriggerEvent("inmenu", isPlyInBennys)
    TriggerServerEvent("np-bennys:removeFromInUse", currentBennys)
    if devmode then
      TriggerEvent("vehicle:leftBennys", nil, nil)
    elseif not isAtPreviewBennys then
      exports["np-ui"]:showInteraction("Bennys")
      TriggerEvent("vehicle:leftBennys", isAtEmployedBennys, isAtRepairsOnlyBennys)
    end
    currentBennys = nil
end

local function freezeVehicle(pVeh, pBennys)
    SetVehicleModKit(pVeh, 0)
    SetEntityCoords(pVeh, pBennys.pos)
    SetEntityHeading(pVeh, pBennys.heading)
    -- FreezeEntityPosition(pVeh, true)
    --SetEntityCollision(pVeh, false, true)
    SetVehicleOnGroundProperly(pVeh)
end

local function finishEnterLocation()
    exports["np-ui"]:hideInteraction()
    isPlyInBennys = true
    TriggerServerEvent("np-bennys:addToInUse", currentBennys)
    disableControls()
    TriggerEvent("inmenu", isPlyInBennys)
end

function enterLocation(pBennys, needsRepair)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local vehclass = GetVehicleClass(plyVeh)
    local isMotorcycle = false

    if (vehclass == 18 and (bennysAccess == "police")) or (needsRepair) then
        freezeVehicle(plyVeh, pBennys)
    elseif not devmode and (vehclass ~= 18 and (bennysAccess ~= "police" or bennysAccess ~= "ems")) or (needsRepair) then
        freezeVehicle(plyVeh, pBennys)
    end

    if isAtEmployedBennys then
        originalParts = getVehicleMods(plyVeh)
        VehicleClass = exports["np-vehicles"]:GetVehicleRatingClass(plyVeh)
    end

    if vehclass == 8 then --Motorcycle
        isMotorcycle = true
    else
        isMotorcycle = false
    end

    isVinScratched = exports['np-vehicles']:IsVinScratched(plyVeh)

    InitiateMenus(isMotorcycle, GetVehicleBodyHealth(plyVeh))

    SetTimeout(100, function()
        if (needsRepair or (isAtRepairsOnlyBennys and not devmode)) and not isAtEmployedBennys then
            DisplayMenu(true, "repairMenu")
            DisplayMenuContainer(true)
        else
            if devmode then
                DisplayMenu(true, "mainMenu")
                DisplayMenuContainer(true)
            elseif isAtPreviewBennys then
                DisplayMenu(true, "mainMenu")
                DisplayMenuContainer(true)
            else
                if vehclass == 18 and (bennysAccess == "police") then
                    DisplayMenu(true, "mainMenu")
                    DisplayMenuContainer(true)
                elseif vehclass ~= 18 and (bennysAccess ~= "police" or bennysAccess ~= "ems") then
                    DisplayMenu(true, "mainMenu")
                    DisplayMenuContainer(true)
                end
            end
        end

        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end)

    if devmode then
        finishEnterLocation()
        return
    else
        if vehclass == 18 and (bennysAccess == "police") or (needsRepair) then
            finishEnterLocation()
            return
        elseif vehclass ~= 18 and (bennysAccess ~= "police" and bennysAccess ~= "ems") or (needsRepair) then
            finishEnterLocation()
            return
        end
    end

    TriggerEvent("DoLongHudText", "You have no need to enter Benny's right now.", 2)
end

function disableControls()
    CreateThread(function()
        while isPlyInBennys do
            SetVehicleHandbrake(GetVehiclePedIsIn(PlayerPedId(), false), true)
            DisableControlAction(1, 38, true) --Key: E
            DisableControlAction(1, 172, true) --Key: Up Arrow
            DisableControlAction(1, 173, true) --Key: Down Arrow
            DisableControlAction(1, 177, true) --Key: Backspace
            DisableControlAction(1, 176, true) --Key: Enter
            -- DisableControlAction(1, 71, true) --Key: W (veh_accelerate)
            DisableControlAction(1, 72, true) --Key: S (veh_brake)
            DisableControlAction(1, 34, true) --Key: A
            DisableControlAction(1, 35, true) --Key: D
            DisableControlAction(1, 75, true) --Key: F (veh_exit)

            if IsDisabledControlJustReleased(1, 172) then --Key: Arrow Up
                MenuScrollFunctionality("up")
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end

            if IsDisabledControlJustReleased(1, 173) then --Key: Arrow Down
                MenuScrollFunctionality("down")
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end

            if IsDisabledControlJustReleased(1, 176) then --Key: Enter
                MenuManager(true)
                PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end

            if IsDisabledControlJustReleased(1, 177) then --Key: Backspace
                MenuManager(false)
                PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end

            Wait(0)
        end
        SetVehicleHandbrake(GetVehiclePedIsIn(PlayerPedId(), false), false)
    end)

end

function checkVehiclePresets(model)
    for tmodel, tpresets in pairs(vehiclePresets) do
        local thash = GetHashKey(tmodel)

        if tostring(thash) == tostring(model) then
            return tpresets
        end
    end
end

function checkVehicleExtras(model)
    for tmodel, tpresets in pairs(vehicleExtras) do
        local thash = GetHashKey(tmodel)

        if tostring(thash) == tostring(model) then
            return tpresets
        end
    end
end

--#[Event Handlers]#--
RegisterNetEvent("np-bennys:purchaseSuccessful")
AddEventHandler("np-bennys:purchaseSuccessful", function()
    isPurchaseSuccessful = true
    attemptingPurchase = false
end)

RegisterNetEvent("np-bennys:purchaseFailed")
AddEventHandler("np-bennys:purchaseFailed", function()
    isPurchaseSuccessful = false
    attemptingPurchase = false
end)

local previewPermission = {}
previewPermission['bennystuner'] = 'hire'
previewPermission['bennyspdm'] = 'craft_access'

local businessesCacheTimer = nil
AddEventHandler("bennys:enter", function()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local vehclass = GetVehicleClass(plyVeh)
    local repair = false

    if GetVehicleBodyHealth(plyVeh) < 1000.0 then
        repair = true
    end

    local bennys = getClosestBennys()

    local isBennysInUse = RPC.execute("np-bennys:checkIfUsed", currentBennys)
    if isBennysInUse ~= nil then
        TriggerEvent("DoLongHudText", "This Benny's is already in use", 2)
        return
    end

    bennysAccess = bennys.access

    local isTestDrive = RPC.execute("showroom:isTestDriveVehicle", NetworkGetNetworkIdFromEntity(plyVeh))

    if bennysAccess then
        local govjob = exports["isPed"]:isPed("myjob")

        if govjob == "doc" or govjob == "ems" then
            govjob = "police"
        end

        if govjob == bennysAccess then
            goto hasAccess
        end

        jobAccess = exports["np-business"]:IsEmployedAt(bennysAccess)

        if (isAtPreviewBennys and previewPermission[currentBennys] and isTestDrive) then
            jobAccess = exports["np-business"]:HasPermission(bennysAccess, previewPermission[currentBennys])
        end

        -- Bogg Bikes access check for his bennys
        -- We only want his bennys to allow bikes
        if jobAccess and bennys.access == "bogg_bikes" then
            local model = GetEntityModel(plyVeh)
            if not (IsThisModelABicycle(model)) then
                return TriggerEvent("DoLongHudText", "Can't service this vehicle at this Benny's", 2)
            end
        end

        if not jobAccess then
            TriggerEvent("DoLongHudText", "You do not have access for this Benny's", 2)
            return
        end
    end

    ::hasAccess::

    if vehclass == 18 and (bennysAccess ~= "police" and bennysAccess ~= "ems") then
        TriggerEvent("DoLongHudText", "This Benny's does not service Emergency Vehicles", 2)
        return
    elseif vehclass ~= 18 and (bennysAccess == "police" or bennysAccess == "ems") then
        TriggerEvent("DoLongHudText", "You cannot service this vehicle in this Benny's", 2)
        return
    elseif isAtPreviewBennys and not isTestDrive then
        isAtPreviewBennys = false
    end

    enterLocation(bennys, repair)
end)

function getClosestBennys()
    local pos = GetEntityCoords(PlayerPedId())
    local dist = -1
    local closestBennys = nil

    for bennys, v in pairs(bennysLocations) do
        local newdist = #(pos - v.pos)

        if dist == -1 or newdist < dist then
            dist = newdist
            closestBennys = bennysLocations[bennys]
            currentBennys = bennys
            isAtEmployedBennys = (closestBennys.employed or closestBennys.preview) or false
            isAtRepairsOnlyBennys = closestBennys.repairOnly or false
            isAtPreviewBennys = closestBennys.preview or false
        end
    end

    return closestBennys
end

BennysCatalog, PriceModifiers = {}, {}

Citizen.CreateThread(function()
    Wait(5000)
    local catalog = RPC.execute('np-jobs:bennys:getPartsCatalog')

    local modifiers = RPC.execute('np-jobs:bennys:getPriceModifiers')

    local taxLevel = RPC.execute("GetTaxLevel", 2)
    SendNUIMessage({setTaxLevel = taxLevel})

    for _, item in ipairs(catalog) do
        local code = ('%s_%s'):format(item.type, item.part)

        BennysCatalog[code] = item
    end

    for _, modifier in ipairs(modifiers) do
        PriceModifiers[modifier.rating] = modifier
    end
    -- print(json.encode(BennysCatalog))
    -- print(json.encode(PriceModifiers))
    -- print(json.encode(Mods))
end)

function GetPartPrice(pType, pPart, pIndex, pRating)
    local code = ('%s_%s'):format(pType, pPart)

    local partData = BennysCatalog[code]
    local modifiers = PriceModifiers[pRating]

    if (not partData) then
        return error('Invalid vehicle part: '.. code)
    elseif (not modifiers) then
        return error('Invalid vehicle rating: '.. pRating)
    end

    local indexData = partData.prices[pIndex]
    if not indexData then
        indexData = partData.prices[#partData.prices]
    end

    local modifier = modifiers['category'][partData.category] or modifiers.default

    return math.floor(indexData.price * modifier)
end

RegisterNetEvent("np-admin:currentDevmode")
AddEventHandler("np-admin:currentDevmode", function(pDevmode)
    devmode = pDevmode
end)

-- PolyZone stuff
AddEventHandler("np-polyzone:enter", function(zone, data)
    if zone ~= "bennys" then return end
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if plyVeh ~= 0 and GetPedInVehicleSeat(plyVeh, -1) == plyPed then
        exports["np-ui"]:showInteraction("Bennys")
    end
end)

AddEventHandler("np-polyzone:exit", function(zone)
    if zone ~= "bennys" then return end
    exports["np-ui"]:hideInteraction()
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and isPlyInBennys then
        ExitBennys()
    end
end)

RegisterNetEvent('np-admin:bennys', function()
    devmode = true
    local bennys = 'devbennys:' .. GetPlayerServerId(PlayerId())
    currentBennys = bennys
    isAtEmployedBennys = false
    isAtRepairsOnlyBennys = false
    enterLocation(bennys, false)
end)
