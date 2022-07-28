-- PRE SPAWN
local charSpawned = false

local pedId, plyId = PlayerPedId(), PlayerId()

function GetPed()
    return pedId
end
function GetPlayer()
    return plyId
end

Citizen.CreateThread(function()
    while not charSpawned do
        DisplayRadar(0)
        Citizen.Wait(0)
    end
end)

AddEventHandler('np-config:configReady', function()
    loadPublicData()
end)

function loadPublicData()
    local showWatermark = exports['np-config']:GetMiscConfig('hud.watermark')
    local showroomPurchase = exports['np-config']:GetMiscConfig('showrooms.catalog.purchase')
    local skipMdwProfileCheck = exports['np-config']:GetMiscConfig('mdw.profiles.skip')
    local serverCode = exports["np-config"]:GetServerCode()
    local pos = math.random(1, 2)

    local colorTable = {
        ["pa"] = "invert(22%) sepia(81%) saturate(7048%) hue-rotate(293deg) brightness(60%) contrast(113%)", --purple
        ["pb"] = "invert(75%) sepia(53%) saturate(4719%) hue-rotate(1deg) brightness(105%) contrast(104%)", --orange
        ["pg"] = "invert(50%) sepia(44%) saturate(3603%) hue-rotate(87deg) brightness(132%) contrast(118%)", --green
        ["wl"] = "blur(1px)",
    }
    local color = colorTable[serverCode]
    if not color then color = "blur(1px)" end
    local style = {right = '1vh', top = '3.5vh', filter = color }
    if pos == 2 then
        style = {left = '1vh', top = '3.5vh', filter = color }
    end
    sendAppEvent("game", {
      watermarkPosition = style,
      showWatermark = showWatermark,
      showroomPurchaseBtn = showroomPurchase,
      skipMdwProfileCheck = skipMdwProfileCheck
    })
end

function loadTaxData()
    local _,taxLevels = RPC.execute("GetTaxLevels")
    local taxes = {}
    for _,tax in ipairs(taxLevels) do
        taxes[tax.id] = tax.level
    end
    sendAppEvent("game", {
        taxLevels = taxes
    })
end

-- CHAR SPAWN
function getCharacterInfo()
    local characterId = exports["isPed"]:isPed("cid")
    local firstName = exports["isPed"]:isPed("firstname")
    local lastName = exports["isPed"]:isPed("lastname")
    local phoneNumber = exports["isPed"]:isPed("phone_number")

    return characterId, firstName, lastName, phoneNumber
end

function sendCharacterData()
    Citizen.CreateThread(function()
        local characterId, firstName, lastName, phoneNumber = getCharacterInfo()
        if not characterId then return end
        local hasBankAccount, bankAccountId = RPC.execute("GetDefaultBankAccount", characterId, true)
        local character = {
            id = characterId,
            first_name = firstName,
            job = "",
            last_name = lastName,
            number = tostring(phoneNumber),
            bank_account_id = hasBankAccount and bankAccountId or -1,
            server_id = GetPlayerServerId(PlayerId()) -- in game session id
        }
        SendUIMessage({ source = "np-nui", app = "character", data = character });
        
        local endpointData = exports["np-fiber"]:GetGameDetails()
        SendUIMessage({ source = "np-nui", app = "game", data = endpointData });

        Citizen.Wait(5000)

        TriggerEvent('np-ui:phoneReady')
        TriggerServerEvent('np-ui:phoneReady')
    end)
end

RegisterNetEvent("np-spawn:characterSpawned")
AddEventHandler("np-spawn:characterSpawned", function()
    charSpawned = true
    Citizen.CreateThread(function()
        DisplayRadar(0)
        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(0)
        SetRadarBigmapEnabled(false, false)
        DisplayRadar(0)
        Citizen.Wait(0)
        sendCharacterData()
        local systemSettings = RPC.execute("GetSystemSettings")
        sendAppEvent("system", systemSettings) -- SYSTEM DATA HERE
        sendAppEvent("hud", {
            display = true,
        })
        loadTaxData()
        startHealthArmorUpdates()
    end)
end)

RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(pHour, pMinutes)
    setGameValue("time", ("%s:%s"):format(pHour > 9 and pHour or "0" .. pHour, pMinutes > 9 and pMinutes or "0" .. pMinutes))
end)

RegisterNetEvent("nns_weather:weatherHasChanged")
AddEventHandler("nns_weather:weatherHasChanged", function(pWeather)
    setGameValue("weather", pWeather.weathers[1])
    setGameValue("weatherIcon", getWeatherIcon(pWeather.weathers[1]))
end)

-- Please lua, get yourself a GOD DAMN FUCKING SWITCH CASE FUCKING IDIOT PIECE OF SHIT
function getWeatherIcon(pWeather)
    if pWeather == "EXTRASUNNY" or pWeather == "CLEAR" then
        return "sun"
    elseif pWeather == "THUNDER" then
        return "poo-storm"
    elseif pWeather == "CLEARING" or pWeather == "OVERCAST" then
        return "cloud-sun-rain"
    elseif pWeather == "CLOUD" then
        return "cloud"
    elseif pWeather == "RAIN" then
        return "cloud-rain"
    elseif pWeather == "SMOG" or pWeather == "FOGGY" then
        return "smog"
    end
end

CreateThread(function()
    SetPedMinGroundTimeForStungun(pedId, 5000)
    SetEntityProofs(pedId, false, false, false, false, false, true, false, false)
    SetPlayerHealthRechargeMultiplier(plyId, 0.0)
    SetPlayerHealthRechargeLimit(plyId, 0.0)
    SetPedConfigFlag(pedId, 184, true)
    while true do
        if GetPed() ~= PlayerPedId() then
            pedId = PlayerPedId()
            SetPedMinGroundTimeForStungun(pedId, 5000)
            SetEntityProofs(pedId, false, false, false, false, false, true, false, false)
            SetPedConfigFlag(pedId, 184, true)
            SetPlayerHealthRechargeMultiplier(plyId, 0.0)
            SetPlayerHealthRechargeLimit(plyId, 0.0)
        end
        if GetPlayer() ~= PlayerId() then
            plyId = PlayerId()
            SetPlayerHealthRechargeMultiplier(plyId, 0.0)
            SetPlayerHealthRechargeLimit(plyId, 0.0)
        end
        SetRadarBigmapEnabled(false, false)
        Wait(2000)
    end
end)

-- DISABLE BLIND FIRING
Citizen.CreateThread(function()
    while true do
        if IsPedInCover(GetPed(), 0) and not IsPedAimingFromCover(GetPed()) then
            DisablePlayerFiring(GetPed(), true)
        end
        Citizen.Wait(0)
    end
end)

-- AddEventHandler("np-ui:hud:values", function(values)
--   -- sendAppEvent("hud", {
--   --     food = values["hunger"],
--   --     oxygen = values["oxygen"],
--   --     oxygenShow = values["oxygen"] ~= 25,
--   --     stress = values["stress"],
--   --     water = values["water"],
--   -- })
--   -- SendNUIMessage({
--   --   type = "updateStatusHud",
--   --   hasParachute = currentValues["parachute"],
--   --   varSetHealth = currentValues["health"],
--   --   varSetArmor = lerp(0,100, rangePercent(0,60,currentValues["armor"])),
--   --   varSetHunger = currentValues["hunger"],
--   --   varSetThirst = currentValues["thirst"],
--   --   varSetOxy = currentValues["oxy"],
--   --   varSetStress = currentValues["stress"],
--   --   colorblind = colorblind,
--   --   varSetVoice = currentValues["voice"],
--   --   varDev = currentValues["dev"],
--   --   varDevDebug = currentValues["devdebug"],
--   --   varCrosshair = currentValues["crosshair"],
--   -- })
--   -- currentValues["parachute"] = HasPedGotWeapon(get_ped, `gadget_parachute`, false)
--   -- currentValues["crosshair"] = IsPedArmed(get_ped, 7)

--   -- if currentValues["crosshair"] then
--   --   if GetFollowPedCamViewMode() == 4 and get_ped_veh == 0 then
--   --     currentValues["crosshair"] = false
--   --   end
--   --   if get_ped_veh ~= 0 and ((GetFollowVehicleCamViewMode() ~= 4 and GetFollowPedCamViewMode() ~= 4) or not IsPedDoingDriveby(get_ped)) then
--   --     currentValues["crosshair"] = false
--   --   end
--   -- end
-- end)
