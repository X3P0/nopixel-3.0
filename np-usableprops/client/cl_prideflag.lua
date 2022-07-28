local locale = {}

locale['en'] = {
	invalid_command   = '[~r~ERROR~s~] missing argument. Usage: /%s emote_id',
	invalid_command_2 = '[~r~ERROR~s~] %s is not a valid emote.',

	start = 'Interact',
	stop  = 'Stop',
	hide  = 'Hide buttons'
}

locale['br'] = {
	invalid_command   = '[~r~ERRO~s~] argumento faltando. Uso correto: /%s id_do_emote',
	invalid_command_2 = '[~r~ERRO~s~] %s não é um emote válido.',

	start = 'Interagir',
	stop  = 'Parar',
	hide  = 'Esconder botões'
}

local Config = {}
Config.Controls = {}

-- Instructional button labels (default is 'en' for english translation)
-- Legenda dos botões instrucionais (coloque 'br' para exibir o texto em português)
Config.Locale = 'en'

-- You can alter the command prefix here (default: /pride)
-- Você pode alterar o comando aqui (padrão: /pride)
Config.Command = 'pride'

-- Check how to correctly change the keybinds at the README file
-- Veja como alterar os controles corretamente no arquivo README
Config.Controls.Stop   = 177 -- (default: 177 | BACKSPACE)
Config.Controls.Action = 47  -- (default: 47 | G)
Config.Controls.Hide   = 74  -- (default: 74 | H)

----------------------------------------------------------------------------
Config.Objects = {
	-- Flags
	[1] = {model = `ajnapride_flag_01`}, -- lgbtqia+
	[2] = {model = `ajnapride_flag_02`}, -- progress
	[3] = {model = `ajnapride_flag_03`}, -- trans
	[4] = {model = `ajnapride_flag_04`}, -- lesbian
	[5] = {model = `ajnapride_flag_05`}, -- nonbinary
	[6] = {model = `ajnapride_flag_06`}, -- genderfluid
	[7] = {model = `ajnapride_flag_07`}, -- queer
	[8] = {model = `ajnapride_flag_08`}, -- pansexual
	[9] = {model = `ajnapride_flag_09`}, -- bisexual

	-- Glowstick
	[10] = {type = 'glowstick', model = `ajna_glowstick_01`},
	[11] = {type = 'glowstick', multicolor = true, model = `ajna_glowstick_01`},
}

function UsePrideFlag(pInfo)
    local meta = json.decode(pInfo)
    local index = tonumber(meta.object) or math.random(1, 9)
    pride_START_ANIM(Config.Objects[index])
end

AddEventHandler('animation:gotCanceled', function()
    pride_CLEAR_ALL()
end)

function _s(index, ...)
	local lang = locale[Config.Locale]
	if not lang then
		print('^1Locale [^7' .. Config.Locale .. '^1] does not exist, setting to default language.^7')
		Config.Locale = 'en'
		return _s(index)
	end

	if not lang[index] then return '' end
	if not {...} then return lang[index] else return (lang[index]):format(...) end
end

local onAction, lastAction   = false, 0
local scaleform, hideButtons = nil, false
local modelCache = {}

function pride_CLEAR_ALL()
    if scaleform then
        SetScaleformMovieAsNoLongerNeeded(scaleform)
        scaleform = nil
    end

    if onAction then
        local playerPed = PlayerPedId()
        ClearPedTasks(playerPed)
    end

    pride_REMOVE_PROPS()
    onAction = false
end

function pride_PLAY_ANIM(playerPed, dict, anim, flag)
    pride_LoadAnimDict(dict)
    TaskPlayAnim(playerPed, dict, anim, 3.0, -3.0, -1, flag, 0.0, false, false, false)
    RemoveAnimDict(dict)
end

function pride_CREATE_PROP(playerPed, playerPos, modelHash, boneId, offsetPos, offsetRot)
    modelHash = type(modelHash) == 'number' and modelHash or GetHashKey(modelHash)
    offsetPos = offsetPos ~= nil and offsetPos or vector3(0.0, 0.0, 0.0)
    offsetRot = offsetRot ~= nil and offsetRot or vector3(0.0, 0.0, 0.0)

    pride_LoadModel(modelHash)

    local object = CreateObject(modelHash, playerPos, true, true, true)
    SetModelAsNoLongerNeeded(modelHash)

    AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, boneId), offsetPos, offsetRot, true, true, false, true, 1, true)
    modelCache[modelHash] = true
end

function pride_REMOVE_PROPS()
    if #modelCache == 0 then
        for k,v in pairs(Config.Objects) do modelCache[v.model] = true end
    end

    local playerPed  = PlayerPedId()
    local foundProps = {}

    for _, object in ipairs(GetGamePool('CObject')) do
        if DoesEntityExist(object) and pride_IsPropAttachedToPlayer(playerPed, object) then
            if modelCache[GetEntityModel(object)] then
                table.insert(foundProps, NetworkGetNetworkIdFromEntity(object))
            end
        end
    end

    if #foundProps > 0 then
        TriggerServerEvent('ajnapride:removeProps', foundProps)
    end

    modelCache = {}
end

function pride_CHANGE_COLOR(playerPed, colorId)
    for _, object in pairs(GetGamePool('CObject')) do
        if DoesEntityExist(object) and pride_IsPropAttachedToPlayer(playerPed, object) then
            if GetEntityModel(object) == (`ajna_glowstick_01`) then
                SetObjectTextureVariation(object, colorId)
            end
        end
    end
end

function pride_GLOWSTICK(model, multicolor)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    local animData  = {dict = 'anim@mp_player_intupperbanging_tunes', anim = 'idle_a', flag = 51}
    local propData  = {
        [1] = {model = model, bone = 28422, offset = vector3(0.07, 0.14, 0.0), rotation = vector3(-80.0, 20.0, 0.0)},
        [2] = {model = model, bone = 60309, offset = vector3(0.07, 0.09, 0.0), rotation = vector3(-120.0, -20.0, 0.0)}
    }

    local entries = {{Config.Controls.Stop, _s('stop')}, {Config.Controls.Hide, _s('hide')}}
    if not multicolor then
        table.insert(entries, {Config.Controls.Action, _s('start')})
    end

    for k,v in pairs(propData) do
        pride_CREATE_PROP(playerPed, playerPos, v.model, v.bone, v.offset, v.rotation)
    end

    pride_PLAY_ANIM(playerPed, animData.dict, animData.anim, animData.flag)

    onAction  = true
    scaleform = pride_LoadInstructionalButtons(entries)

    Citizen.CreateThread(function()
        local lastColor = 0
        while onAction do
            if not hideButtons then
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
            end

            if IsControlJustPressed(0, Config.Controls.Stop) then
                pride_CLEAR_ALL()
                break
            end

            if not multicolor then
                if IsControlJustPressed(0, Config.Controls.Action) and (GetGameTimer() > lastAction + 2000) then
                    lastAction = GetGameTimer()
                    playerPed  = PlayerPedId()

                    lastColor  = lastColor + 1
                    if lastColor > 7 then lastColor = 0 end

                    pride_PLAY_ANIM(playerPed, animData.dict, animData.anim, animData.flag)
                    pride_CHANGE_COLOR(playerPed, lastColor)
                end
            else
                if (GetGameTimer() > lastAction + 5000) then
                    lastAction = GetGameTimer()
                    playerPed  = PlayerPedId()

                    lastColor  = lastColor + 1
                    if lastColor > 7 then lastColor = 0 end

                    pride_CHANGE_COLOR(playerPed, lastColor)
                end
            end

            if IsControlJustPressed(0, Config.Controls.Hide) then
                hideButtons = not hideButtons
            end

            Wait(1)
        end

        pride_CLEAR_ALL()
    end)
end

function pride_HOLD_FLAG(model)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    local animData  = {dict = 'anim@heists@humane_labs@finale@keycards', anim = 'ped_b_enter_loop', flag = 51}
    local propData  = {model = model, bone = 28422, offset = vector3(-0.08, 0.14, 0.1), rotation = vector3(50.0, 160.0, 15.0)}

    pride_CREATE_PROP(playerPed, playerPos, propData.model, propData.bone, propData.offset, propData.rotation)
    pride_PLAY_ANIM(playerPed, animData.dict, animData.anim, animData.flag)

    onAction = true

    Citizen.CreateThread(function()
        while onAction do
            if IsControlJustPressed(0, Config.Controls.Stop) then
                pride_CLEAR_ALL()
                break
            end

            Wait(3)
        end

        pride_CLEAR_ALL()
    end)
end

function pride_START_ANIM(data)
    if onAction then
        pride_CLEAR_ALL()
        Wait(500)
    end

    if data.type == 'glowstick' then
        pride_GLOWSTICK(data.model, data.multicolor)
    else
        pride_HOLD_FLAG(data.model)
    end
end

RegisterCommand(Config.Command, function(source, args)
    local index = tonumber(args[1])
    if not index then
        if onAction then
            pride_CLEAR_ALL()
        else
            pride_ShowNotification(_s('invalid_command', Config.Command))
        end
        return

    elseif not Config.Objects[index] then 
        pride_ShowNotification(_s('invalid_command_2', index))
        return 
    end

    pride_START_ANIM(Config.Objects[index])
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        pride_CLEAR_ALL()
    end
end)

function pride_IsPropAttachedToPlayer(playerPed, object)
    return GetEntityAttachedTo(object) == playerPed
end

function pride_LoadInstructionalButtons(entries)
    local scaleform = RequestScaleformMovie('instructional_buttons')
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, 'CLEAR_ALL')
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, 'SET_CLEAR_SPACE')
    ScaleformMovieMethodAddParamInt(150)
    EndScaleformMovieMethod()

    for n, btn in next, entries do
        BeginScaleformMovieMethod(scaleform, 'SET_DATA_SLOT')
        ScaleformMovieMethodAddParamInt(n-1)

        local button = GetControlInstructionalButton(2, btn[1], true)
        ScaleformMovieMethodAddParamPlayerNameString(button)
        BeginTextCommandScaleformString('STRING')
        AddTextComponentScaleform(btn[2])
        EndTextCommandScaleformString()

        EndScaleformMovieMethod()
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, 'SET_CLEAR_SPACE')
    ScaleformMovieMethodAddParamInt(150)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, 'SET_BACKGROUND_COLOUR')
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(70)

    EndScaleformMovieMethod()
    return scaleform
end

function pride_LoadAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)

        while not HasAnimDictLoaded(animDict) do
            Wait(10)
        end
    end
end

function pride_LoadModel(modelHash)
    if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
        RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Wait(10)
        end
    end
end

function pride_ShowNotification(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end
