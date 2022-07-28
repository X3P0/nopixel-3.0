local chips = {}
local chipRequestCount = 0
local currentChipRequest = {}

RegisterNetEvent('casino:pokerChips')
AddEventHandler('casino:pokerChips',function(args)
    local newargs = {}
    for i = 2, #args do
        newargs[i-1] = args[i]
    end
    args = newargs

    local action = args[1]
    local casinoPlayer = tostring(GetPlayerServerId(PlayerId()))
    local target = args[2]
    local amount = args[3]

    if action == 'buy' or action == 'cash' then
        if not IsNearPlayer(tonumber(target)) then
            TriggerEvent('chatMessage', "", 1, "^1You are not near this player! (isNearPlayer)", "feed", false, { i18n = { "You are not near this player" } })
            return
        end

        local playing = IsPlayerPlaying(GetPlayerFromServerId(tonumber(target)))
        if chips[target] == nil then chips[target] = 0 end
        local chipBalance = chips[target] or 0 
        if action == 'cash' and amount == 'all' then amount = chipBalance end
        if action == 'cash' and chipBalance < tonumber(amount) then 
            TriggerEvent('DoLongHudText',"You do not have enough chips. Your balance with that player is " .. chipBalance, 101)
            return 
        end
        if (playing ~= false) then
            TriggerServerEvent('casino:exchangeChipsRequest',casinoPlayer, target, action, amount)
        else
            TriggerEvent('chatMessage', "", 1, "^1This player is not online!", "feed", false, { i18n = { "This player is not online" } });
        end
            
    elseif action == 'accept' then
        TriggerEvent('casino:acceptChipsRequest')
    else 
        if args[1] == nil then 
            local hasChips = false
            for i, player in pairs(chips) do
                if player ~= 0 then
                    hasChips = true
                    TriggerEvent('DoLongHudText',"P" .. i .. " Chips: " .. math.floor(player),i)
                end
            end
            if not hasChips then
                TriggerEvent('DoShortHudText',"You have no chips.",101)
            end
        else
            local player = tostring(args[1])
            if chips[player] and math.abs(chips[player]) > 0 then
                TriggerEvent('DoLongHudText',"P" .. player .. " Chips: " .. math.floor(chips[player]),player)
            else
                TriggerEvent('DoShortHudText',"You have no chip balance with player " .. player .. ".",101)
            end
        end
    end

end)

RegisterNetEvent('casino:exchangeChips')
AddEventHandler('casino:exchangeChips',function(casinoPlayer,action,amount)
    if chips[casinoPlayer] == nil then
        chips[casinoPlayer] = 0
    end
    if chipRequestCount > 0 then
        TriggerEvent("DoShortHudText","Somebody sent you a poker chip request but you already have one in process!",102)
        return
    end
    currentChipRequest = {
        amount = amount,
        action = action,
        player = casinoPlayer 
    }
    local tempText = ''
    if action == 'buy' then tempText = 'BUY' end
    if action == 'cash' then tempText = 'CASH IN' end
      
    chipRequestCount = 7
    TriggerEvent("DoLongHudText", "Player " .. casinoPlayer .. " is requesting to !" .. tempText .. "! " .. amount .. " poker chips. '/pokerchips accept' to accept",105)
    while chipRequestCount > 0 and currentChipRequest ~= nil do
        Citizen.Wait(2000)
        chipRequestCount = chipRequestCount - 1
    end
    chipRequestCount = 0
    currentChipRequest = nil
end)

RegisterNetEvent('casino:acceptChipsRequest')
AddEventHandler('casino:acceptChipsRequest',function()
    if currentChipRequest ~= nil then
        local pitboss = tostring(GetPlayerServerId(PlayerId()))
        local amount = currentChipRequest["amount"]
        local action = currentChipRequest["action"]
        local casinoPlayer = currentChipRequest["player"]
        -- local tempText = 'chips'
        -- local tempText2 = 'cash'
        -- if action == 'cash' then 
        --     tempText = 'cash'
        --     tempText2 = 'chips'
        -- end
        TriggerEvent("DoLongHudText", "Accepted request",105)
        -- TriggerEvent("DoLongHudText", "Accepted: Sent " .. math.floor(tonumber(amount)) .. " " .. tempText .. " to player " .. casinoPlayer .. " for " .. math.floor(tonumber(amount)) .. " " .. tempText2,105)
        TriggerServerEvent('casino:chipsRequestAccepted',pitboss,casinoPlayer,action,amount)
        currentChipRequest = nil
    end
end)

RegisterNetEvent('casino:receiveChips')
AddEventHandler('casino:receiveChips',function(player,amount)
    TriggerEvent("DoLongHudText", "Received " .. math.floor(tonumber(amount)) .. " chips from player " .. player,100+player)
    chips[player] = chips[player] + amount

end)

RegisterNetEvent('casino:sendChips')
AddEventHandler('casino:sendChips',function(player,amount)
    TriggerEvent("DoLongHudText", "Sent " .. math.floor(tonumber(amount)) .. " chips to player " .. player,100+player)
    chips[player] = chips[player] - amount
end)

-- Check if player is near another player
function IsNearPlayer(player)
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
    local ply2Coords = GetEntityCoords(ply2, 0)
    local distance = Vdist2(plyCoords, ply2Coords)
    if(distance <= 25) then
        return true
    end
end

function getChipBalance(player)
    if player == nil then
        return chips
    else
        return chips[player]
    end
end
