function Login.changeChar(isLeft)
    local position = 0

    if Login.CurrentPedInfo ~= nil then position = Login.CurrentPedInfo.position end
    
    pedData = findCharPed(pedCaught,false)

    local maxPedAmount = 0
    for k,v in pairs(Login.CreatedPeds) do
        maxPedAmount = maxPedAmount + 1
    end
    
    if position == nil then position = 1 end

    if isLeft then
        position = position-1 

        if position <= 0 then position = maxPedAmount end
    else
        position = position+1 

        if position > maxPedAmount then position = 1 end
    end

    if Login.CreatedPeds[position] ~= nil then
        Login.CurrentPedInfo = {
            charId = Login.CreatedPeds[position].charId,
            position = position
        }
    end
    
    if Login.CurrentPedInfo ~= nil then
        SendNUIMessage({
            update = true,
            currentSelect = Login.CurrentPedInfo,
            fadeHover = false,
            forceHover = true
        })
    end
end

--[[
	Functions below: character handlers 
	Description: dealing with finding information about characters 
]]

function Login.SelectedChar(data)

	Login.ClearSpawnedPeds()
	TriggerEvent("character:PlayerSelectedCharacter")
	local events = exports["np-base"]:getModule("Events")
	events:Trigger("np-base:selectCharacter", data.actionData, function(returnData)
       
        if not returnData.loggedin or not returnData.chardata then sendMessage({err = {err = true, msg = "There was a problem logging in as that character, if the problem persists, contact an administrator <br/> Cid: " .. tostring(data.selectcharacter)}}) return end

        local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
        LocalPlayer:setCurrentCharacter(returnData.chardata)
        local clothingData = NPX.Procedures.execute('np-clothing:fetchClothingData', { data.actionData })
        local hasClothing = false
        for _,entry in ipairs(clothingData) do
            if entry.characterId == data.actionData and entry.clothing.model ~= 0 then
                hasClothing = true
                break
            end
        end
        if not hasClothing then
        	Login.setClothingForChar()
        else
            deleteTrain()
            
	        SetPlayerInvincible(PlayerPedId(), true)
	        TriggerEvent("np-base:firstSpawn")
	    end
    end)
end


--[[
	Functions below: Clothing handlers
	Description: this deals with new chars or chars without clothes being selected and giveing the clothes
]]


function Login.setClothingForChar()
    Login.actionsBlocked = true

    SendNUIMessage({
      close = true
    })

    SetEntityVisible(PlayerPedId(), true)

    SetEntityCoords(PlayerPedId(),-3963.54,2013.95, 499.92)
    SetEntityHeading(PlayerPedId(),64.71)

    RenderScriptCams(false, true, 1, true, true)

    -- SetGameplayCamRelativeHeading(180.0)
    -- SetGameplayCamRelativePitch(1.0, 1.0)

    -- Wait(800)

    -- for i=1,25 do
    --   local posoffset = GetCamCoord(LoginSafe.Cam)
    --   local setpos = VecLerp(posoffset.x,posoffset.y,posoffset.z, -3965.88,2014.55, 501.6, i/30, true)
    --   SetCamCoord(LoginSafe.Cam, setpos)
    --   Wait(15)
    -- end

    Login.Open = false
    local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
    local gender = LocalPlayer:getCurrentCharacter().gender

    local genderModel = gender ~= 0 and `mp_f_freemode_01` or `mp_m_freemode_01`
    exports['np-clothing']:SetModel(genderModel)

    TriggerEvent('np-clothing:openClothing', true, true)

    SetEntityHeading(PlayerPedId(),70.0)

    SetGameplayCamRelativeHeading(180.0)

    SetGameplayCamRelativePitch(1.0, 1.0)
end

RegisterNetEvent("np-spawn:finishedClothing")
AddEventHandler("np-spawn:finishedClothing", function(endType)
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local pos = vector3(-3965.88,2014.55, 501.6)
    local distance = #(playerCoords - pos)

    if distance <= 10 then
        SetEntityVisible(PlayerPedId(), false)
    	if endType == "Finished" then
            DoScreenFadeOut(2)
    		spawnChar()
    	else
    		backToMenu()
    	end
    end	
end)


function backToMenu()
    Login.actionsBlocked = false
	SetCamActive(LoginSafe.Cam, true)
	RenderScriptCams(true, false, 0, true, true)
	Login.nativeStart(true)
end

function spawnChar()
    Login.actionsBlocked = false
    deleteTrain()

    SetPlayerInvincible(PlayerPedId(), true)
    TriggerEvent("np-base:firstSpawn")

    SendNUIMessage({
        default = true
    })

    Login.Selected = false
    Login.CurrentPedInfo = nil
    Login.CurrentPed = nil
    Login.CreatedPeds = {}
end


RegisterNetEvent("character:finishedLoadingChar")
AddEventHandler("character:finishedLoadingChar", function()
    Login.characterLoaded()
end)