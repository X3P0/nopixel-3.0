-- Settings
-- local color = { r = 220, g = 220, b = 220, alpha = 255 } -- Color of the text 
local font = 0 -- Font of the text
local time = 7000 -- Duration of the display of the text : 1000ms = 1sec
local background = {
    enable = true,
    color = { r = 15, g = 15, b = 15, alpha = 200 },
}
-- Square radius (using Vdist2)
local dispRadius = 7*7
local chatMessage = false
local dropShadow = false
local clearAll = false
local displaying = false

local game = { }

-- Don't touch
local nbrDisplaying = 1


-- Math functions to determine HUD positioning
local sin = math.sin
local cos = math.cos
local deg = math.deg
local rad = math.rad
math.sin = function (x) return sin(rad(x)) end
math.cos = function (x) return cos(rad(x)) end

-- failsafe to clear existing displays if casino game bugs

RegisterNetEvent('casinoPlayer:clearDisplay')
AddEventHandler('casinoPlayer:clearDisplay',function(gameNumber,playerId)
    if playerId == 'all' then
        if game[gameNumber] then
            for i, player in pairs(game[gameNumber]) do
                player['displaying'] = false
                Wait(50)
            end
            game[gameNumber] = nil
        end
    else
        if game[gameNumber] then
            if game[gameNumber][playerId] then
                -- game[gameNumber][playerId]['displaying'] = false
                game[gameNumber][playerId] = nil
                Wait(50)
            end
        end
    end
    
end)

-- Keep track of current displays for games so spectators can view, while allowing text to change and be 
-- removed without clearing all current displays. 
RegisterNetEvent('casinoPlayer:triggerDisplay')
AddEventHandler('casinoPlayer:triggerDisplay', function(config)
    -- required config to send
    local gameNumber = config['gameNumber']
    local text = config['text']
    
    -- optional config, defaulting values. Then set config based on config object
    local netId = GetPlayerServerId(PlayerId())
    local duration = 10
    -- local offset = .3
    -- local entity = PlayerPedId()
    local color = { r = 220, g = 220, b = 220, alpha = 255 }
    
    if config['duration'] then duration = config['duration'] end
    if config['color'] then color = config['color'] end
    if config['netId'] then 
        netId = config['netId'] 
        entity = GetPlayerPed(GetPlayerFromServerId(netId))
        
    end
    
    -- Create game object if doesn't exist
    if not game[gameNumber] or game[gameNumber] == {} then 
        game[gameNumber] = {}
    end
    if not game[gameNumber][netId] then
        game[gameNumber][netId] = {}
        game[gameNumber][netId]['displaying'] = false    
        game[gameNumber][netId]['text'] = ''
    end
    if game[gameNumber][netId]['text'] == '' then 
        game[gameNumber][netId]['text'] = text
        game[gameNumber][netId]['color'] = color
    end
    if config['numCards'] ~= nil then 
        game[gameNumber][netId]['numCards'] = config['numCards']
    else   
        game[gameNumber][netId]['numCards'] = 0
    end
    game[gameNumber][netId]['text'] = text
    game[gameNumber][netId]['color'] = color

    if not game[gameNumber][netId]['displaying'] then
        CasinoPlayerDisplay(entity, text, duration, gameNumber, netId, c)
    end

end)



function CasinoPlayerDisplay(playerPed, t, duration, gn, netId, c)
    -- local anchor
    local text = t
    game[gn][netId]['displaying'] = true
    local time = duration
    Citizen.CreateThread(function()
        
        if time > 0 then
            while game[gn][netId]['displaying'] do
                Wait(time)
                game[gn][netId]['displaying'] = false
                game[gn][netId] = {}
            end
        end
        -- Wait(10)
        -- game[gn][netId]['displaying'] = true 
    end)
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while game[gn][netId]['displaying'] and not clearAll do
            local coordsPlayer = GetEntityCoords(playerPed, false)
            local heading = GetEntityHeading(playerPed)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local px,py,pz = table.unpack(GetGameplayCamCoord())
            local offsetSine = math.sin(heading)
            local offsetCosine = math.cos(heading)
            local offsetNS = offsetCosine * .05
            local offsetEW = offsetSine * .05 * -1
            if math.abs(px - coordsPlayer['x']) < 1 and math.abs(py - coordsPlayer['y']) < 1 then
                offsetNS = offsetCosine * .35
                offsetEW = offsetSine * .35 * -1
                offset = .7
            else 
                offset = .3
            end
            

            
            local dist = Vdist2(coordsPlayer, coords)
            if dist < dispRadius then
                DrawText3D(coordsPlayer['x']+offsetEW, coordsPlayer['y']+offsetNS, coordsPlayer['z']+offset, game[gn][netId]['text'], game[gn][netId]['color'],game[gn][netId]['numCards'])
            end
            Wait(0)
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text, c, numCards)
    local color = { r = 220, g = 220, b = 220, alpha = 255 } -- Color of the text 
    if c ~= nil then 
        color = c 
    end
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))
    if dist < 1 then dist = 2 end

    local scale = ((15/dist)*.75)*(10/GetGameplayCamFov())*1

    if onScreen then

        -- Formalize the text
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextScale(0.0*scale, 0.50*scale)
        SetTextFont(font)
        -- SetTextProportional(1)
        SetTextCentre(true)
        SetTextDropshadow(1, 0, 0, 0, 255)
        if dropShadow then
        end
        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
        
        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        local height = GetTextScaleHeight(1*scale, font)
        local width = EndTextCommandGetWidth(text)
        local length = string.len(text)
        local factor
        if numCards ~= nil and numCards > 0 then
            factor = ((length - (numCards * 3)) * .0066) + .01
        else
            factor = (length * .0075) + .01
        end

        if background.enable then
            DrawRect(_x, _y+scale/45, (factor *scale) + .001, height, background.color.r, background.color.g, background.color.b , background.color.alpha)
        end
    end
end