-- add or remove possible table coordinates here, and include in first lines of "blackjack" command to check distance
-- used to determine which table is open and which game a player will join
local tableOne = vector3(103.8, -230.51, 54.44)
local tableTwo = vector3(98.37, -229.56, 54.69)






local playersWaiting = {}
local currentGame = 0
local cardDeck = {}
local dealerHand = {}
local waitingToJoin = true
local players = {}
local gameActive = false
local tbl
local serverId = GetPlayerServerId(PlayerId())
local numDecks = 4
local useChips = true

local Color = {
    white = {r = 220, g = 220, b = 220, alpha = 255},
    yellow = {r = 222; g = 220, b = 0, alpha = 255}
}

local displayingHelp = false

RegisterNetEvent('bj:blackjackstart')
AddEventHandler('bj:blackjackstart', function(source,args)

    local newargs = {}
    for i = 2, #args do
        newargs[i-1] = args[i]
    end
    args = newargs
    -- Determine which table to display as open
    if Vdist(GetEntityCoords(PlayerPedId()), tableOne) < 5 then
        tbl = tableOne
    elseif Vdist(GetEntityCoords(PlayerPedId()), tableTwo) < 5 then
        tbl = tableTwo
    else
        tbl = nil
    end

    -- Allow players to leave all open games for pepega commands
    if args[1] == 'leave' then
        --TriggerEvent('blackjack:leaveAll')
    end


    -- Need to add new rank/role to exports if wanting to restrict. Or whatever whitelist system is.
    -- local rank = exports["isPed"]:GroupRank("casino_pitboss")
    local rank = 5

    if args[1] == 'help' then
        if displayingHelp then
            SendNUIMessage({
                type = 'CLOSE_INSTRUCTIONS',
            })
            displayingHelp = false
        else
            SendNUIMessage({
                type = 'DISPLAY_INSTRUCTIONS',
            })
            displayingHelp = true
        end
    end
    
    if tbl ~= nil and rank > 3 then

    
        -- Build initial deck
        if next(cardDeck) == nil then
            cardDeck = buildDeck(numDecks)
        end
        if args[1] == nil then
            if not gameActive then
                gameActive = true

                -- Check if player DCs or leaves table area to end the game and remove cards from players HUDs
                Citizen.CreateThread(function()
                    while gameActive do
                        local playing = IsPlayerPlaying(GetPlayerFromServerId(serverId))
                        if not playing or Vdist(GetEntityCoords(PlayerPedId()), tbl) > 15 then
                            endGameActions()
                        end
                        Citizen.Wait(2500)
                    end
                end)

                checkShuffle()
                playersWaiting = {}
                TriggerServerEvent('casino:blackjack', serverId, tbl,useChips)
                TriggerServerEvent('casino:shareDisplay', ' [+] Increase Bet | [-] Decrease Bet     ', tbl, -1, serverId, Color.white)
            end
        end
        if args[1] == 'shuffle' then
            if gameActive then
                SendNUIMessage({
                    type = 'PITBOSS_MESSAGE',
                    message = 'Must end game before shuffling'
                })
            else
                cardDeck = buildDeck(numDecks)
                TriggerServerEvent('casino:shareDisplay', 'Shuffling...', tbl, 3000, serverId,Color.white)
                SendNUIMessage({
                    type = 'PITBOSS_MESSAGE',
                    message = 'Shuffling Deck'
                })
            end
        end
        if args[1] == 'decksize' then
            numDecks = tonumber(args[2])
            cardDeck = buildDeck(numDecks)
            SendNUIMessage({
                type = 'PITBOSS_MESSAGE',
                message = 'Deck size set to ' .. numDecks .. ' decks'
            })
        end
        if args[1] == 'maxbet' then
            if args[2] ~= nil then
                TriggerServerEvent('blackjack:maxBet',-1,serverId,args[2])
            end
        end
        if args[1] == 'chips' then
            if args[2] == '0' then
                useChips = false
                SendNUIMessage({
                    type = 'PITBOSS_MESSAGE',
                    message = 'Currency set to cash. Manual Pay.'
                })
            elseif args[2] == '1' then
                useChips = true
                SendNUIMessage({
                    type = 'PITBOSS_MESSAGE',
                    message = 'Currency set to chips. Auto pay.'
                })
            end
        end


        if gameActive then
            if args[1] == 'refresh' then
                TriggerServerEvent('blackjack:refreshDisplay',serverId)
            end
            if args[1] == 'deal' then
                TriggerServerEvent('blackjack:betsIn', serverId, tbl)
            end
            if args[1] == 'hit' then
                TriggerServerEvent('blackjack:HitPlayer',serverId, args[2], cardDeck)
            end
            if args[1] == 'double' then
                local chipsRemaining = exports["pitboss"]:getChipBalance(args[2])
                if chipsRemaining ~= nil then
                    chipsRemaining = math.floor(math.abs(chipsRemaining))
                end
                TriggerServerEvent('blackjack:HitPlayer',serverId, args[2], cardDeck, true, chipsRemaining)
            end
            if args[1] == 'kick' then
                TriggerServerEvent('blackjack:kickPlayer',serverId, args[2])
            end
            if args[1] == 'end' then
                gameActive = false
                TriggerServerEvent('blackjack:endGame', serverId,useChips)
                Wait(100)
                checkShuffle()
                SendNUIMessage({
                    type = 'PITBOSS_CARDS',
                    close = true
                })
                currentGame = 0
                tbl = nil
            end
            -- if args[1] == 'rules' then
            --     if args[2] == '0' then
            --         TriggerServerEvent('blackjack:toggleStandardRules',serverId,0)
            --         SendNUIMessage({
            --             type = 'PITBOSS_MESSAGE',
            --             message = 'Standard "blackjack" rules off'
            --         })
            --     end
            --     if args[2] == '1' then
            --         TriggerServerEvent('blackjack:toggleStandardRules',serverId,1)
            --         SendNUIMessage({
            --             type = 'PITBOSS_MESSAGE',
            --             message = 'Standard "blackjack" rules enabled'
            --         })
            --     end
            -- end
            if args[2] ~= nil then 
                if args[1] .. ' ' .. args[2] == 'show dealer' then
                    TriggerServerEvent('blackjack:ShowDealer',serverId)
                end
            end
        end
    end

end, false)

RegisterNetEvent('blackjackDealer:PlayerJoined')
AddEventHandler('blackjackDealer:PlayerJoined',function(player)
    playersWaiting[#playersWaiting+1]={id = player['id'], bet = player['bet'], color = player['color']}
end)

-- Hand starting. process which players joined to send to server. 
RegisterNetEvent('blackjackDealer:doneWaitingForPlayers')
AddEventHandler('blackjackDealer:doneWaitingForPlayers', function(source)
    -- Wait(2000)
    players = {}
    -- Create players table to send to new game
    for k, v in pairs(playersWaiting) do
        local playerId = v['id']
        players[playerId] = {
            id = v['id'],
            bet = v['bet'],
            color = v['color'],
            total = 0,
            hud = 'P' .. v['id'] .. ': ',
            cards = {},
            winOrLose = '',
            blackjack = false,
        }
    end

    -- dealer object
    local dealer = {
        id = serverId, 
        cards = {}, 
        total = 0, 
        hud = 'Dealer: ', 
    }
    TriggerServerEvent('blackjackDealer:StartGame',serverId, dealer, players, cardDeck, tbl)
end)

RegisterNetEvent('blackjackDealer:SyncDeck')
AddEventHandler('blackjackDealer:SyncDeck',function(deck)
    -- receive which cards have been dealt
    cardDeck = deck
    updateCardsLeft()
end)


-- Creating deck: deletes current deck and rebuilds with number of decks
function buildDeck(numDecks) 
    local deck = {}
    for i=1, numDecks do
        local newDeck = casino().newDeck
        for i, card in ipairs(newDeck) do
            deck[#deck+1]=card
        end
    end
    return deck
end

function checkShuffle()
    local deckSize = numDecks * 52
    local cardsRemaining = deckSize

    for i, card in pairs(cardDeck) do
        if not card['active'] then
            cardsRemaining = cardsRemaining - 1
        end
    end

    if (cardsRemaining / deckSize) < 0.33 then 
        cardDeck = buildDeck(numDecks)
        TriggerServerEvent('casino:shareDisplay', 'Shuffling...', tbl, 3000, serverId,Color.white)
        if gameActive then 
            SendNUIMessage({
                type = 'PITBOSS_CARDS',
                message = 'Cards Remaining: 100% (' .. deckSize .. '/' .. deckSize .. ')',
                background = 'green'
            })
        end
        return true
    end
    updateCardsLeft()

end

function updateCardsLeft() 
    local deckSize = numDecks * 52
    local cardsRemaining = deckSize
    for i, card in pairs(cardDeck) do
        if not card['active'] then
            cardsRemaining = cardsRemaining - 1
        end
    end
    local background = 'green'
    if (cardsRemaining / deckSize) < .5 then
        background = 'yellow'
    end
    if (cardsRemaining / deckSize) < .45 then
        background = 'orange' 
    end
    if (cardsRemaining / deckSize) < .35 then 
        background = 'red'
    end
    SendNUIMessage({
        type = 'PITBOSS_CARDS',
        message = 'Cards Remaining: ' .. math.floor(cardsRemaining / deckSize * 100) .. '% (' .. cardsRemaining .. '/' .. deckSize .. ')',
        background = background
    })
end

function endGameActions() 
    gameActive = false
    TriggerServerEvent('blackjack:endGame', serverId,useChips)
    Wait(100)
    checkShuffle()
    currentGame = 0
    tbl = nil
    SendNUIMessage({
        type = 'PITBOSS_CARDS',
        close = true
    })
end

-- Access cassino global exports
function casino()
    return exports['casino']:get_namespace()
end
