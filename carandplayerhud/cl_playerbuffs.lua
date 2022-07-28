ActiveBuffsCID = {
    -- Barry Briddle
    [1108] = {
        maxhealth = 140
    },
}

local powerfulAbilities = {
    stamina = 100.0,
    maxhealth = 1000,
    invincible = true,
    sprint = 1.25,
    meleedamage = 10.0,
    weapondamage = 100.0,
}

local strongAbilities = {
    stamina = 100.0,
    maxhealth = 1000,
    invincible = false,
    sprint = 1.25,
    meleedamage = 10.0,
    weapondamage = 100.0,
}

ActiveBuffsModel = {
    --Bovice
    [`s_m_y_bovice`] = {
        stamina = 40.0,
        maxhealth = 600,
        meleedamage = 1.5,
    },
    [`invisible`] = {
        stamina = 100.0,
        maxhealth = 1000,
        invincible = true,
        sprint = 1.4,
    },
    [`Alien`] = powerfulAbilities,
    [`thepredator`] = powerfulAbilities,
    [`ig_myers`] = powerfulAbilities,
    [`ghostface`] = powerfulAbilities,
    [`Jason`] = powerfulAbilities,
    [`t600`] = powerfulAbilities,
    [`chupacabra`] = powerfulAbilities,
    [`Ironman`] = powerfulAbilities,
    [`Hulk1`] = powerfulAbilities,
    [`Hulk2`] = powerfulAbilities,
    [`terminator`] = powerfulAbilities,
    [`spiderman01`] = powerfulAbilities,
    [`spiderman02`] = powerfulAbilities,
    [`spiderman03`] = powerfulAbilities,
    [`spiderman04`] = powerfulAbilities,
    [`optimusL`] = powerfulAbilities,
    [`optimuss`] = powerfulAbilities,
    [`joker`] = powerfulAbilities,
    [`Deadpool`] = powerfulAbilities,
    [`CaptainA01`] = powerfulAbilities,
    [`CaptainA02`] = powerfulAbilities,
    [`CaptainA03`] = powerfulAbilities,
    [`CaptainA04`] = powerfulAbilities,
    [`batman`] = powerfulAbilities,
    [`superman`] = powerfulAbilities,
    [`chucky`] = powerfulAbilities,
    [`blackpanther`] = powerfulAbilities,
    [`flashjl`] = powerfulAbilities,
    [`goku`] = powerfulAbilities,
    [`slenderman`] = powerfulAbilities,
    [`rare_bane`] = strongAbilities,
    [`Bane_Beast`] = strongAbilities,
    [`pennywise`] = strongAbilities,
    [`HarleyQuinn`] = strongAbilities,
    [`Deadshot`] = strongAbilities,
    [`RobocopV2`] = strongAbilities,
    [`WonderWoman`] = strongAbilities,
    [`FlashInjustice`] = strongAbilities,
    [`WillSmith`] = strongAbilities,
    [`Ronald`] = strongAbilities,
    [`Robin_AC`] = strongAbilities,
    [`licker`] = strongAbilities
}

ActiveBuffsModel[`a_c_hen`] = {
    stamina = 100.0,
    maxhealth = 1000,
    invincible = true,
}

ActiveBuffsModel[`ig_nemesis`] = {
    stamina = 100.0,
    maxhealth = 1000,
    invincible = true,
}

ActiveBuffsModel[`ig_leon`] = {
    stamina = 100.0,
    maxhealth = 1000,
    invincible = false,
    meleedamage = 10.0,
}

ActiveBuffsModel[`silverhand`] = {
    stamina = 100.0,
    maxhealth = 1000,
    invincible = false,
    meleedamage = 10.0,
}

ActiveBuffsItem = {
    ['boxinggloves'] = {
        meleedamage = 0.1
    }
}
exports('addMeleeBuff', function (cid, value)
    if ActiveBuffsCID[cid] == nil then
        ActiveBuffsCID[cid] = {}
    end
    ActiveBuffsCID[cid].meleedamage = value
end)

local buffNameToPedFunction = {
    ["maxhealth"] = SetPedMaxHealth,
    ["sweat"] = SetPedSweat,
}

local buffNameToPlayerFunction = {
    ["maxarmor"] = SetPlayerMaxArmour,
    ["meleedamage"] = SetPlayerMeleeWeaponDamageModifier,
    ["meleedefense"] = SetPlayerMeleeWeaponDefenseModifier,
    ["weapondamage"] = SetPlayerWeaponDamageModifier,
    ["weapondefense"] = SetPlayerWeaponDefenseModifier_2,
    ["healthregenlimit"] = SetPlayerHealthRechargeLimit,
    ["healthregenmultiplier"] = SetPlayerHealthRechargeMultiplier,
    ["invincible"] = SetPlayerInvincible,
    ["sprint"] = SetRunSprintMultiplierForPlayer,
    ["swim"] = SetSwimMultiplierForPlayer,
    ["stamina"] = RestorePlayerStamina,
}

local HasBoxingGloves = false

function SetDefaultValues()
    SetPlayerMeleeWeaponDamageModifier(PlayerId(), 1.0)
    SetWeaponDamageModifierThisFrame(`WEAPON_UNARMED`, 1.0)
end

RegisterNetEvent("np-inventory:itemCheck", function(item, hasItem, quantity)
    local buffs = ActiveBuffsItem[item]
    if buffs == nil then return end

    if not hasItem then
        if item == "boxinggloves" then
            HasBoxingGloves = false
            TriggerEvent("np-inventory:boxingGlovesEquipped", false)
        end
        SetDefaultValues()
        return
    end

    local player = PlayerPedId()
    local playerId = PlayerId()

    for buff, value in pairs(buffs) do
        if buffNameToPedFunction[buff] then
            buffNameToPedFunction[buff](player, value)
        end
        if buffNameToPlayerFunction[buff] then
            buffNameToPlayerFunction[buff](playerId, value)
        end
        if buff == "maxhealth" then
            TriggerEvent("police:setFadeState", false)
        end
        if buff == "meleedamage" then
            SetWeaponDamageModifierThisFrame(`WEAPON_UNARMED`, value)
            if item == "boxinggloves" then
                HasBoxingGloves = true
                TriggerEvent("np-inventory:boxingGlovesEquipped", true)
                Citizen.CreateThread(function()
                    while HasBoxingGloves do
                        Wait(0)
                        SetWeaponDamageModifierThisFrame(`WEAPON_UNARMED`, value)
                    end
                    SetWeaponDamageModifierThisFrame(`WEAPON_UNARMED`, 1.0)
                end)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while not exports['np-config']:IsConfigReady() do
        Wait(100)
    end
    local buffsEnabled = exports["np-config"]:GetMiscConfig("buffs.enabled")
    while true and buffsEnabled do
        local characterId = exports["isPed"]:isPed("cid")
        local player = PlayerPedId()
        local playerId = PlayerId()
        local plyModel = GetEntityModel(player)
        local buffs = ActiveBuffsCID[tonumber(characterId)] or ActiveBuffsModel[plyModel]
        if buffs then
            for buff, value in pairs(buffs) do
                if buffNameToPedFunction[buff] then
                    buffNameToPedFunction[buff](player, value)
                end
                if buffNameToPlayerFunction[buff] then
                    buffNameToPlayerFunction[buff](playerId, value)
                end
                if buff == "maxhealth" then
                    TriggerEvent("police:setFadeState", false)
                end
                if buff == "meleedamage" then
                    SetWeaponDamageModifierThisFrame(`WEAPON_UNARMED`, value)
                end
            end
            Citizen.Wait(5000)
        else
            SetDefaultValues()
            Citizen.Wait(5000)
        end
    end
end)
