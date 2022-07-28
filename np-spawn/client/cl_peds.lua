GetCharacterData = nil
GetClothingData = nil

Citizen.CreateThread(function()
    GetCharacterData = NPX.Utils.cache(function ()
        local result = NPX.Procedures.execute('np-character:fetchCharacterData')
    
        if not result then return false, nil end
    
        return true, result
    
    end, { timeToLive = 5 * 60 * 1000 })

    GetClothingData = NPX.Utils.cache(function (ctx, pCharacterIds)
        local result = NPX.Procedures.execute('np-clothing:fetchClothingData', pCharacterIds)
        if not result then return false, nil end
    
        return true, result
    
    end, { timeToLive = 5 * 60 * 1000 })
end)

function Login.getCharacters(pIsReset)
    local events = exports["np-base"]:getModule("Events")
    if not pIsReset then
        TransitionFromBlurred(500)
        events:Trigger("np-base:loginPlayer", nil, function(data)
            if type(data) == "table" and data.err then
                return
            end
        end)
    end

    local characters = GetCharacterData.get()
    local charIds = {}
    for idx,char in ipairs(characters) do
        if idx > 8 then break end
        charIds[#charIds+1] = char.id
    end

    local clothingData = GetClothingData.get(charIds)
    return {
        characters = characters,
        clothing = clothingData
    }
end

function Login.CreatePeds(pIsReset)
    if Login.actionsBlocked and not pIsReset then return end
    Login.actionsBlocked = true
    if not pIsReset then
        Wait(500)
        Login.LoadFinished = false
        Login.ClearSpawnedPeds()
        CleanUpArea()
        Wait(500)
        CleanUpArea()

        while Login.isTrainMoving do
            Wait(10)
        end

        Login.HasTransistionFinished = false
        while Login.HasTransistionFinished do
            Wait(10)
        end
    end

    
    local pedData = Login.getCharacters(pIsReset)

    local selectModelMale = `np_m_character_select`
    local selectModelFemale = `np_f_character_select`
    NPX.Streaming.loadModel(selectModelMale)
    NPX.Streaming.loadModel(selectModelFemale)

    if pIsReset then
        Login.ClearSpawnedPeds()
    end

    local PlusOneEmpty = false
    local noCharacters = #pedData.characters == 0

    local selectedCid
    if GetResourceState("np-queue") == "started" then
        selectedCid = RPC.execute("np-queue:getAllowedCharacters")
    end

    local function isCharacterBlocked(pCharacterID)
        if not selectedCid then return false end
        for _,cid in pairs(selectedCid) do
            if pCharacterID == cid then
                return false
            end
        end
        return true
    end

    local extraCharData = {}
    if #pedData.characters > 8 then
        --They have more than 8 characters, show dropdown
        for idx = 9, math.min(#pedData.characters, getCharLimit()) do
            if not isCharacterBlocked(pedData.characters[idx].id) then
                extraCharData[#extraCharData+1] = pedData.characters[idx]
            end
        end
    end

    for idx = 1, math.min(8, getCharLimit()) do
        local isCustom = false
        local character = nil
        local cid = 0
        local isBlocked = false

        local cModelHash = selectModelMale

        if pedData.characters[idx] then
            character = pedData.characters[idx]
            cid = character.id

            if character.gender == 1 then
                cModelHash = `mp_f_freemode_01`
            else
                cModelHash = `mp_m_freemode_01`
            end

            if pedData.clothing[idx] and pedData.clothing[idx].clothing.model ~= 0 then
                cModelHash = pedData.clothing[idx].clothing.model
            end

            isBlocked = isCharacterBlocked(cid)
        else
            if math.random(2) == 1 then
                cModelHash = selectModelFemale
            end
        end

        if character == nil and not PlusOneEmpty then
            PlusOneEmpty = idx
        end

        local function CreatePedPCall(pHash, pX, pY, pZ)
            local ped = CreatePed(3, pHash, pX, pY, pZ, 0.72, false, false)
            return ped
        end

        if not isBlocked then
            NPX.Streaming.loadModel(cModelHash)
            
            local newPed = nil
            if character ~= nil then
                local success, rData = pcall(CreatePedPCall, cModelHash, Login.spawnLoc[idx].x, Login.spawnLoc[idx].y, Login.spawnLoc[idx].z)
                if success then
                    newPed = rData
                else
                    newPed = CreatePed(3, selectModelMale, Login.spawnLoc[idx].x, Login.spawnLoc[idx].y, Login.spawnLoc[idx].z, 0.72, false, false)
                    print("MODEL FAILED TO LOAD IN SPAWN: " .. cModelHash)
                end
            else
                if PlusOneEmpty == idx then
                    local success, rData = pcall(CreatePedPCall, cModelHash, Login.spawnLoc[idx].x, Login.spawnLoc[idx].y, Login.spawnLoc[idx].z)
                    if success then
                        newPed = rData
                    else
                        newPed = CreatePed(3, selectModelMale, Login.spawnLoc[idx].x, Login.spawnLoc[idx].y, Login.spawnLoc[idx].z, 0.72, false, false)
                        print("MODEL FAILED TO LOAD IN SPAWN: " .. cModelHash)
                    end
                end
            end

            if newPed == nil then
                goto skip_to_next
            end

            SetEntityHeading(newPed, Login.spawnLoc[idx].w)

            -- load char models
            if character ~= nil then
                local clothingData = pedData.clothing[idx].clothing
                local isMpModel = clothingData.model == `mp_m_freemode_01` or clothingData.model == `mp_f_freemode_01`
                if isMpModel then
                    exports['np-clothing']:LoadPedDefaults(newPed)
                end
                exports['np-clothing']:ApplyPedClothing(
                    newPed,
                    clothingData.drawables,
                    clothingData.props,
                    clothingData.hairColor,
                    true
                )
    
                if isMpModel then
                    local headData = pedData.clothing[idx].pedData
                    exports['np-clothing']:ApplyPedData(
                        newPed,
                        headData.headblend,
                        headData.features,
                        headData.overlays,
                        headData.eyeColor
                    )
    
                    local decorations = pedData.clothing[idx].decorations
                    exports['np-clothing']:ApplyDecorations(newPed, decorations)
                end
            end

            if not isCustom then
                if modelHash == selectModelFemale or modelHash == selectModelMale then
                    if character ~= nil then
                        SetEntityAlpha(newPed, 200, false)
                    else
                        SetEntityAlpha(newPed, 150, false)
                    end
                end
            end

            TaskLookAtCoord(newPed, vector3(-3968.05, 2015.41, 502.3 ),-1, 0, 2)
            FreezeEntityPosition(newPed, true)
            SetEntityInvincible(newPed, true)
            SetBlockingOfNonTemporaryEvents(newPed, true)

            Login.currentProtected[newPed] = true

            if character ~= nil then
                Login.CreatedPeds[idx] = {
                    pedObject = newPed,
                    charId = cid,
                    posId = idx
                }
            else
                Login.CreatedPeds[idx] = {
                    pedObject = newPed,
                    charId = 0,
                    posId = idx
                }
            end

            ::skip_to_next::
        end
    end

    Wait(600)
    SetNuiFocus(true, true)
    SendNUIMessage({
        open = true,
        extraCharData = extraCharData,
        chars = pedData.characters
    })
	
	--If no characters, open Creation menu
    if noCharacters then
        SendNUIMessage({ firstOpen = true })
    end

    Login.actionsBlocked = false
end
