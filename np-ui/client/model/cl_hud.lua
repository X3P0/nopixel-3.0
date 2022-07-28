local compassEnabled = true
local compassRoadNamesEnabled = true
local compassWaitTime = 16
local speedometerWaitTime = 64
local showCompassFromWatch = false
local showCompassFromCar = false
local minimapEnabled = true
local wasMinimapEnabled = true
local useDefaultMinimap = false
local appliedTextureChange = false

local inVehicle = false
local engineOn = false
local isDead = false
local area = ""
local street = ""
local street2 = ""
local runningRoadNames = false
local compassRunning = false
local fuel = 0
local altitude = 0
local speed = 0
local onIsland = false
local forceShowMinimap = false

--
local cmdsSet = {}
local vehBypass = {}
RegisterNUICallback("np-ui:hudSetPreferences", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })
    compassEnabled = data["hud.compass.enabled"]
    compassWaitTime = data["hud.compass.fps"]
    compassRoadNamesEnabled = data["hud.compass.roadnames.enabled"]
    speedometerWaitTime = data["hud.vehicle.speedometer.fps"]
    minimapEnabled = data["hud.vehicle.minimap.enabled"]
    useDefaultMinimap = data["hud.vehicle.minimap.default"]

    if data["hud.presets"] then
      local idx = 0
      for _, p in pairs(data["hud.presets"]) do
        idx = idx + 1
        if not cmdsSet[idx] then
          local eventOptions = {
            changeHud = idx,
          }
          local s = tostring(idx)
          exports["np-keybinds"]:registerKeyMapping("", "HUD", "Enable " .. s, "+hud_enable_" .. s, "-hud_enable_" .. s)
          RegisterCommand('+hud_enable_' .. s, function()
            exports["np-ui"]:sendAppEvent("preferences", eventOptions)
          end, false)
          RegisterCommand('-hud_enable_' .. s, function() end, false)
          cmdsSet[idx] = true
        end
      end
    end
    TriggerEvent("np-preferences:setPreferences", data)
end)

local function toggleCompass()
    sendAppEvent("hud.compass", {
        showCompass = showCompassFromWatch or (compassEnabled and showCompassFromCar),
        showRoadNames = compassRoadNamesEnabled and inVehicle,
    })
end

--

AddEventHandler("np-ui:watch", function()
    showCompassFromWatch = not showCompassFromWatch
    if showCompassFromWatch then
        generateCompass()
    end
    toggleCompass()
end)

local watchItems = {
    ["watch"] = true,
    ["civwatch"] = true,
}
RegisterNetEvent('np-inventory:itemCheck')
AddEventHandler('np-inventory:itemCheck', function (item, hasItem, quantity)
    if not watchItems[item] then return end
    if hasItem and quantity > 0 then return end
    showCompassFromWatch = false
    toggleCompass()
end)

AddEventHandler("np:voice:proximity", function(proximity)
    sendAppEvent("hud", {
        voiceRange = proximity,
    })
end)

AddEventHandler("np:voice:transmissionStarted", function(data)
    sendAppEvent("hud", {
        voiceActive = not data.radio,
        voiceActiveRadio = data.radio,
    })
end)

AddEventHandler("np:voice:transmissionFinished", function()
    sendAppEvent("hud", {
        voiceActive = false,
        voiceActiveRadio = false,
    })
end)

AddEventHandler("pd:deathcheck", function()
    isDead = not isDead
    sendAppEvent("game", {
        isAlive = not isDead
    })
end)

RegisterNetEvent("np-admin:currentDevmode")
AddEventHandler("np-admin:currentDevmode", function(devmode)
    setGameValue("modeDev", devmode)
end)

RegisterNetEvent("np-admin:currentDebug")
AddEventHandler("np-admin:currentDebug", function(debugToggle)
    setGameValue("modeDebug", debugToggle)
end)

RegisterNetEvent("carandplayerhud:godCheck", function(toggle)
    setGameValue("modeGod", toggle)
end)

--

local inPursuitVehicle = false
local currentPursuitMode = 0

AddEventHandler('np-vehicles:pursuitMode', function (pEnabled, pMode, pModes)
    inPursuitVehicle = pEnabled

    if pMode == nil or pModes == nil then return end

    currentPursuitMode = math.floor((pMode + 1) * 100 / pModes)
end)

AddEventHandler('np-jail:attachedCollar', function (pAttached)
    setHudValue("collarShow", pAttached)
end)

local boostCompletions = 0
local showBoostCompletions = false

RegisterNetEvent('np-boosting:client:setBoostCompletions')
AddEventHandler('np-boosting:client:setBoostCompletions', function (pAmount)
    boostCompletions = pAmount
    setHudValue("boostCompletions", boostCompletions)
end)

local weaponFireRate = 0
local showWeaponFireRate = false

RegisterNetEvent('np-weapons:client:setWeaponFireRate')
AddEventHandler('np-weapons:client:setWeaponFireRate', function (pAmount)
    weaponFireRate = pAmount
    setHudValue("weaponFireRate", weaponFireRate)
end)

RegisterNetEvent('np-weapons:client:showWeaponFireRate')
AddEventHandler('np-weapons:client:showWeaponFireRate', function (pToggle)
    showWeaponFireRate = pToggle
    setHudValue("showWeaponFireRate", pToggle)
end)

RegisterNetEvent('np-ui:hud:forceShowMinimap', function(pForce)
    forceShowMinimap = pForce
    roundedRadar()

    sendAppEvent("hud", {
        display = true,
        radarShow = minimapEnabled or forceShowMinimap,
    })
end)

local showDriftMode = false
local driftMode = false

AddEventHandler('np-drifting:showDriftMode', function (pToggle)
    showDriftMode = pToggle
    setHudValue("showDriftMode", pToggle)
end)

AddEventHandler('np-drifting:toggleDriftMode', function (pToggle)
    driftMode = pToggle
    setHudValue("driftMode", pToggle)
    setHudValue("showDriftThread", pToggle)
    setHudValue("driftThread", 100)
end)

AddEventHandler("np-drifting:remainingTireThread", function (pThread)
    setHudValue("driftThread", pThread)
end)

function roundedRadar()
    if not minimapEnabled or (not inVehicle and not forceShowMinimap) then
        DisplayRadar(0)
        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(0)
        SetRadarBigmapEnabled(false, false)
        return
    end
    Citizen.CreateThread(function()
        if not appliedTextureChange and not useDefaultMinimap then
          RequestStreamedTextureDict("circlemap", false)
          while not HasStreamedTextureDictLoaded("circlemap") do
              Citizen.Wait(0)
          end
          AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasklg")
          AddReplaceTexture("platform:/textures/graphics", "radarmasklg", "circlemap", "radarmasklg")
          appliedTextureChange = true
        elseif appliedTextureChange and useDefaultMinimap then
          appliedTextureChange = false
          RemoveReplaceTexture("platform:/textures/graphics", "radarmasksm")
          RemoveReplaceTexture("platform:/textures/graphics", "radarmasklg")
        end

        SetBlipAlpha(GetNorthRadarBlip(), 0.0)
        -- SetBlipScale(GetMainPlayerBlipId(), 0.7)
        -- for k,v in pairs(exports["np-base"]:getModule("Blips")) do
        --     SetBlipScale(v["blip"], 0.7)
        -- end

        local screenX, screenY = GetScreenResolution()
        local modifier = screenY / screenX

        local baseXOffset = 0.0046875
        local baseYOffset = 0.74

        local baseSize    = 0.20 -- 20% of screen

        local baseXWidth  = 0.1313 -- baseSize * modifier -- %
        local baseYHeight = baseSize -- %

        local baseXNumber = screenX * baseSize  -- 256
        local baseYNumber = screenY * baseSize  -- 144

        local radiusX     = baseXNumber / 2     -- 128
        local radiusY     = baseYNumber / 2     -- 72

        local innerSquareSideSizeX = math.sqrt(radiusX * radiusX * 2) -- 181.0193
        local innerSquareSideSizeY = math.sqrt(radiusY * radiusY * 2) -- 101.8233

        local innerSizeX = ((innerSquareSideSizeX / screenX) - 0.01) * modifier
        local innerSizeY = innerSquareSideSizeY / screenY

        local innerOffsetX = (baseXWidth - innerSizeX) / 2
        local innerOffsetY = (baseYHeight - innerSizeY) / 2

        local innerMaskOffsetPercentX = (innerSquareSideSizeX / baseXNumber) * modifier

        local function setPos(type, posX, posY, sizeX, sizeY)
            SetMinimapComponentPosition(type, "I", "I", posX, posY, sizeX, sizeY)
        end
        if not useDefaultMinimap then
          setPos("minimap",       baseXOffset - (0.025 * modifier), baseYOffset - 0.025, baseXWidth + (0.05 * modifier), baseYHeight + 0.05)
          setPos("minimap_blur",  baseXOffset, baseYOffset, baseXWidth + 0.001, baseYHeight)
          -- setPos("minimap_mask",  baseXOffset + innerOffsetX, baseYOffset + innerOffsetY, innerSizeX, innerSizeY)
          -- The next one is FUCKING WEIRD.
          -- posX is based off top left 0.0 coords of minimap - 0.00 -> 1.00
          -- posY seems to be based off of the top of the minimap, with 0.75 representing 0% and 1.75 representing 100%
          -- sizeX is based off the size of the minimap - 0.00 -> 0.10
          -- sizeY seems to be height based on minimap size, ranging from -0.25 to 0.25
          setPos("minimap_mask", 0.1, 0.95, 0.09, 0.15)
          -- setPos("minimap_mask", 0.0, 0.75, 1.0, 1.0)
          -- setPos("minimap_mask",  baseXOffset, baseYOffset, baseXWidth, baseYHeight)
        else
          local function setPosLB(type, posX, posY, sizeX, sizeY)
              SetMinimapComponentPosition(type, "L", "B", posX, posY, sizeX, sizeY)
          end
          local offsetX = -0.018
          local offsetY = 0.025

          local defaultX = -0.0045
          local defaultY = 0.002

          local maskDiffX = 0.020 - defaultX
          local maskDiffY = 0.032 - defaultY
          local blurDiffX = -0.03 - defaultX
          local blurDiffY = 0.022 - defaultY

          local defaultMaskDiffX = 0.0245
          local defaultMaskDiffY = 0.03

          local defaultBlurDiffX = 0.0255
          local defaultBlurDiffY = 0.02

          setPosLB("minimap",       -0.0045,  -0.0245,  0.150, 0.18888)
          setPosLB("minimap_mask",  0.020,    0.022,  0.111, 0.159)
          setPosLB("minimap_blur",  -0.03,    0.002,  0.266, 0.237)
        end
        if not useDefaultMinimap then
          SetMinimapClipType(1)
        else
          SetMinimapClipType(0)
        end
        DisplayRadar(0)
        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(0)
        SetRadarBigmapEnabled(false, false)
        DisplayRadar(1)
    end)
end

function generateRoadNames()
    if not compassRoadNamesEnabled or runningRoadNames then return end
    Citizen.CreateThread(function()
        runningRoadNames = true
        while compassRoadNamesEnabled and inVehicle do
            Citizen.Wait(500)

            local playerCoords = GetEntityCoords(GetPed(), true)
            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z, currentStreetHash, intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
            intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
            zone = tostring(GetNameOfZone(playerCoords))
            area = GetLabelText(zone)

            if intersectStreetName ~= nil and intersectStreetName ~= "" then
                street = currentStreetName
                street2 = intersectStreetName
            elseif currentStreetName ~= nil and currentStreetName ~= "" then
                street = currentStreetName
                street2 = ""
            else
                street = ""
                street2 = ""
            end
        end
        runningRoadNames = false
    end)
end

function generateCompass()
    if compassRunning then return end
    compassRunning = true
    Citizen.CreateThread(function()
        local function shouldShowCompass()
            return showCompassFromWatch or (compassEnabled and showCompassFromCar)
        end
        local function shouldShowSpeed()
            return inVehicle and minimapEnabled
        end
        while shouldShowCompass() or shouldShowSpeed() do
            local cWait = shouldShowCompass() and compassWaitTime or 1000
            local sWait = shouldShowSpeed() and speedometerWaitTime or 1000
            Citizen.Wait(math.min(cWait, sWait))
            local s = GetGameTimer()
            local heading = math.floor(-GetFinalRenderedCamRot(0).z % 360)

            sendAppEvent("hud.compass", {
                alt = altitude,
                area = area,
                heading = heading,
                speed = speed,
                street = street,
                street2 = street2,
            })

        end
        compassRunning = false
    end)
end

-- SPEEDOMETER
local beltShow = false
local harnessDurability = 0
AddEventHandler("seatbelt", function(belt)
    beltShow = belt
end)
AddEventHandler("harness", function(belt, dur)
    beltShow = belt
    harnessDurability = dur
end)

local nos = 0
local nosEnabled = false
RegisterNetEvent("noshud")
AddEventHandler("noshud", function(_nos, _nosEnabled)
    if _nos == nil then
        nos = 0
    else
        nos = _nos
    end
    nosEnabled = _nosEnabled
end)

function getFuel()
    fuel = exports["np-vehicles"]:CurrentFuel() or 0
end

local speedoRunning = false
function generateSpeedo()
    makeHudDirty()
    if speedoRunning then return end
    speedoRunning = true
    local veh = GetVehiclePedIsIn(GetPed(), false)
    local flyer = IsPedInAnyPlane(GetPed()) or IsPedInAnyHeli(GetPed())
    altitude = false

    getFuel()

    local engineDamageShow = false
    local gasDamageShow = false
    local partsDamageShow = false

    Citizen.CreateThread(function()
        while engineOn do
            if flyer then
                altitude = math.floor(GetEntityHeightAboveGround(veh) * 3.28084)
            end
            setHudValue("altitudeShow", altitude ~= false)
            setHudValue("beltShow", not beltShow)
            setHudValue("engineDamageShow", engineDamageShow)
            setHudValue("partsDamageShow", partsDamageShow)
            setHudValue("fuel", math.ceil(fuel))
            setHudValue("gasDamageShow", gasDamageShow)
            setHudValue("harnessDurability", harnessDurability)
            setHudValue("nos", nos)
            setHudValue("nosEnabled", nosEnabled)
            setHudValue("nosShow", nos > 0)
            setHudValue("pursuit", currentPursuitMode)
            setHudValue("pursuitShow", inPursuitVehicle)

            if IsWaypointActive() then
              local dist = (#(GetEntityCoords(GetPed()) - GetBlipCoords(GetFirstBlipInfoId(8))) / 1000) * 0.715 -- quick conversion maff
              setHudValue("waypointActive", true)
              setHudValue("waypointDistance", dist)
            else
              setHudValue("waypointActive", false)
            end

            Citizen.Wait(500)
        end
        speedoRunning = false
        altitude = false
    end)

    Citizen.CreateThread(function()
        while engineOn do
            if GetVehicleEngineHealth(veh) < 400.0 then
                engineDamageShow = true
            else
                engineDamageShow = false
            end
            if GetVehiclePetrolTankHealth(veh) < 3002.0 then
                gasDamageShow = true
            else
                gasDamageShow = false
            end

            if GetPedInVehicleSeat(veh, -1) == GetPed() then
                harnessDurability = exports["np-vehicles"]:GetVehicleMetadata(veh, 'harness')
            end

            local degradation = exports["np-vehicles"]:GetVehicleDegradation(veh)
            if not degradation then degradation = {} end
            for _,damage in pairs(degradation) do
                if damage < 75.0 then
                    partsDamageShow = true
                    break
                end
            end

            getFuel()
            Citizen.Wait(10000)
        end
    end)

    Citizen.CreateThread(function()
        while engineOn do
            speed = math.ceil(GetEntitySpeed(veh) * 2.236936)
            Citizen.Wait(speedometerWaitTime)
        end
    end)
end

-- HEALTH/ARMOR
local startedHealthArmorUpdates = false
function startHealthArmorUpdates()
    makeHudDirty()
    if startedHealthArmorUpdates then return end
    local prevHealth = -1
    local prevArmor = -1
    Citizen.CreateThread(function()
        startedHealthArmorUpdates = true
        while true do
            local maxHealth = GetPedMaxHealth(GetPed())
            local maxArmor = GetPlayerMaxArmour(PlayerId())
            local curArmor = GetPedArmour(GetPed())
            local armor = lerp(0, 100, rangePercent(0, maxArmor, curArmor))
            if curArmor < 3 then armor = 0 end
            if armor > 100 then armor = 100 end
            local health = lerp(0, 100, rangePercent(100, maxHealth, GetEntityHealth(GetPed())))
            if health > 100 then health = 100 end
            if health < 0 or isDead then health = 0 end

            setHudValue("armor", armor)
            setHudValue("health", health)
            Citizen.Wait(500)
        end
    end)
end

-- VEHICLE CHECKS
Citizen.CreateThread(function()
    while true do
        local veh = GetVehiclePedIsIn(GetPed(), false)
        if veh ~= 0 and not inVehicle then
            inVehicle = true
            setGameValue("vehicle", { hash = GetEntityModel(veh) })
        elseif veh == 0 and inVehicle then
            inVehicle = false
            setGameValue("vehicle", -1)
            setHudValue("harnessDurability", 0)
            setHudValue("nos", 0)
            setHudValue("nosShow", false)
        end

        local eon = IsVehicleEngineOn(veh)

        if vehBypass[veh] then
            -- do nothing
            goto continue
        end

        if eon and not engineOn then
            engineOn = true
            showCompassFromCar = true

            generateSpeedo()
            generateCompass()
            generateRoadNames()
            toggleCompass()

            roundedRadar()

            sendAppEvent("hud", {
                display = true,
                radarShow = minimapEnabled,
            })

        elseif not eon and engineOn then
            engineOn = false
            showCompassFromCar = false

            toggleCompass()

            if not forceShowMinimap then
                sendAppEvent("hud", {
                    radarShow = false
                })
                Citizen.Wait(32)
                DisplayRadar(0)
            end
        elseif wasMinimapEnabled ~= minimapEnabled then
            wasMinimapEnabled = minimapEnabled
            roundedRadar()
        end

        ::continue::

        Citizen.Wait(250)
    end
end)

AddEventHandler('np-ui:setVehicleBypassed', function(veh, bypass)
    vehBypass[veh] = bypass
end)

-- RADAR / MINIMAP STUFF
local pauseActive = false
Citizen.CreateThread(function()
    while true do
        -- DontTiltMinimapThisFrame()
        local isPMA = IsPauseMenuActive()
        if isPMA and not pauseActive then
            pauseActive = true
            sendAppEvent("hud", { display = false })
            -- SetBlipScale(GetFirstBlipInfoId(8), 1.0) -- WAYPOINT BLIP
        elseif not isPMA and pauseActive then
            pauseActive = false
            -- SetBlipScale(GetFirstBlipInfoId(8), 0.0)
            sendAppEvent("hud", { display = true })
        end
        Citizen.Wait(250)
    end
end)

-- START UP / RUN TIME
-- REMOVE SCROLL WHEEL ITEMS
Citizen.CreateThread(function()
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        --
        -- 1 : WANTED_STARS
        -- 2 : WEAPON_ICON
        -- 3 : CASH
        -- 4 : MP_CASH
        -- 5 : MP_MESSAGE
        -- 6 : VEHICLE_NAME
        -- 7 : AREA_NAME
        -- 8 : VEHICLE_CLASS
        -- 9 : STREET_NAME
        -- 10 : HELP_TEXT
        -- 11 : FLOATING_HELP_TEXT_1
        -- 12 : FLOATING_HELP_TEXT_2
        -- 13 : CASH_CHANGE
        -- 14 : RETICLE
        -- 15 : SUBTITLE_TEXT
        -- 16 : RADIO_STATIONS
        -- 17 : SAVING_GAME
        -- 18 : GAME_STREAM
        -- 19 : WEAPON_WHEEL
        -- 20 : WEAPON_WHEEL_STATS
        -- 21 : HUD_COMPONENTS
        -- 22 : HUD_WEAPONS
        --
        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(2)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        -- HideHudComponentThisFrame(5)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(10)
        HideHudComponentThisFrame(11)
        HideHudComponentThisFrame(12)
        HideHudComponentThisFrame(13)
        HideHudComponentThisFrame(14)
        HideHudComponentThisFrame(15)
        --HideHudComponentThisFrame(16)
        HideHudComponentThisFrame(17)
        HideHudComponentThisFrame(18)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        -- HideHudComponentThisFrame(21)
        -- HideHudComponentThisFrame(22)

        HudWeaponWheelIgnoreSelection()  -- CAN'T SELECT WEAPON FROM SCROLL WHEEL
        DisableControlAction(0, 37, true)

        if not onIsland then
            HideMinimapInteriorMapThisFrame()
        end
        if useDefaultMinimap then
          SetRadarZoom(1000) -- 1200
        else
          SetRadarZoom(1200) -- 1200
        end

        Citizen.Wait(0)
    end
end)

local GazeEntity, GazeDelay = nil, 1500

AddEventHandler('np-ui:setGaze', function (pEntity, pDelay)
    GazeEntity = pEntity
    GazeDelay = pDelay
end)

function GetForwardVector(rotation)
    local rot = (math.pi / 180.0) * rotation
    return vector3(-math.sin(rot.z) * math.abs(math.cos(rot.x)), math.cos(rot.z) * math.abs(math.cos(rot.x)), math.sin(rot.x))
end

Citizen.CreateThread(function ()
    while true do
        local idle = 400

        local ped = PlayerPedId()

        if not GazeEntity and not isDead then
            local heading = math.floor(-(GetEntityHeading(ped) -GetFinalRenderedCamRot(0).z) % 360)

            if heading > 80 and heading < 260 then
                local headCoords = GetPedBoneCoords(ped, 31086)
                local forwardVectors = GetForwardVector(GetEntityRotation(ped, 2))
                local forwardCoords = headCoords + (forwardVectors * 2.0)

                TaskLookAtCoord(ped, forwardCoords.x, forwardCoords.y, headCoords.z, 400, 2048, 3)

                idle = 200
            end
        elseif GazeEntity and not isDead then
            idle = GazeDelay

            TaskLookAtEntity(ped, GazeEntity, GazeDelay, 2048, 3)
        end

        Citizen.Wait(idle)
    end
end)

-- Parachute on?
local hasParachute = false
local toggleParachuteOff = false
Citizen.CreateThread(function()
  while true do
    local pState = GetPedParachuteState(GetPed())
    if toggleParachuteOff and pState == -1 then
      hasParachute = false
      toggleParachuteOff = false
      exports["np-ui"]:sendAppEvent("hud", { hasParachute = false })
    elseif pState ~= -1 and hasParachute then
      toggleParachuteOff = true
    end
    Citizen.Wait(1000)
  end
end)
AddEventHandler("hud:equipParachute", function()
  hasParachute = true
  exports["np-ui"]:sendAppEvent("hud", { hasParachute = true })
end)

AddEventHandler("np-island:onIsland", function(pState)
    onIsland = pState
end)

-- No idle cams
Citizen.CreateThread(function()
    while true do
      InvalidateIdleCam()
      N_0x9e4cfff989258472() -- Disable the vehicle idle camera
      Wait(10000) --The idle camera activates after 30 second so we don't need to call this per frame
    end
end)

-- idk
function lerp(min, max, amt)
    return (1 - amt) * min + amt * max
end
function rangePercent(min, max, amt)
    return (((amt - min) * 100) / (max - min)) / 100
end
