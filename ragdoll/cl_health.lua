MAX_ARMOR = 60
MAX_HEALTH = 200
MIN_HEALTH = 110
MIN_ARMOR = 10
REDUCE_FACTOR = 20

local defaultMaxHealth = MAX_HEALTH
local disableReduceFactor = false
local currentPercent = 100
local deaths = 0

function OnDeath(pMinor)
    if disableReduceFactor then
        return
    end
    local newDeaths = NPX.Procedures.execute('np-ragdoll:addDeath', pMinor)
    SetDeaths(newDeaths)
end

function SetDeaths(pDeaths)
    deaths = pDeaths

    if disableReduceFactor then
        currentPercent = 100
    else
        currentPercent = math.max(10, 100 - (deaths * REDUCE_FACTOR))
    end
    SetMaxArmor()
    SetMaxHealth()
end

AddEventHandler('np-spawn:characterSpawned', function()
    local deaths = NPX.Procedures.execute('np-ragdoll:fetchDeaths')
    SetDeaths(deaths)
end)

RegisterNetEvent('np-ragdoll:refreshDeaths', function(deaths)
    SetDeaths(deaths)
end)

Citizen.CreateThread(function()
    while true do
        Wait(15 * 60 * 1000)
        local deaths = NPX.Procedures.execute('np-ragdoll:fetchDeaths')
        SetDeaths(deaths)
    end
end)

function SetMaxArmor()
    local armor = math.floor(((currentPercent / 100) * MAX_ARMOR) + 0.5)
    SetPlayerMaxArmour(PlayerId(), math.max(MIN_ARMOR, armor))
end

function SetMaxHealth()
    local health = math.floor(((currentPercent / 100) * MAX_HEALTH) + 0.5)
    SetPedMaxHealth(PlayerPedId(), math.max(MIN_HEALTH, health))
end

function SetPlayerHealth(pAmount, pFromHeal)
    local ped = PlayerPedId()
    local prevHealth = GetEntityHealth(ped)
    local maxHealth = GetEntityMaxHealth(ped)
    if pAmount > maxHealth then
        pAmount = maxHealth
    end

    if pFromHeal then
        local hunger = exports['carandplayerhud']:GetHunger()
        if hunger < 40 then
            local hungerFactor = (hunger / 40)
            local diff = math.floor((pAmount - prevHealth) * hungerFactor + 0.5)
            if diff == 1 and math.random(1,100) > 40 * hungerFactor then
                diff = 0
            end
            pAmount = pAmount + diff
        end
    end

    SetEntityHealth(ped, pAmount)
end

function SetPlayerArmor(pAmount)
    local ped = PlayerPedId()
    local maxArmor = GetPlayerMaxArmour(PlayerId())
    if pAmount > maxArmor then
        pAmount = maxArmor
    end
    SetPedArmour(ped, pAmount)
end

function OverrideMaxHealth(pState, pAmount)
    if pState then
        MAX_HEALTH = pAmount
        return
    end
    MAX_HEALTH = defaultMaxHealth
end

function DisableReduceFactor(pState)
    disableReduceFactor = pState
end

exports('SetPlayerHealth', SetPlayerHealth)
exports('SetPlayerArmor', SetPlayerArmor)
exports('SetMaxHealth', SetMaxHealth)
exports('SetMaxArmor', SetMaxArmor)
exports('OverrideMaxHealth', OverrideMaxHealth)
exports('DisableReduceFactor', DisableReduceFactor)
