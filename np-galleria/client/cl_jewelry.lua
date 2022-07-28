local appliedEffects = {}

local isPrisoner = false
local isEnabled = true

AddEventHandler('np-inventory:closed', function(pName)
    -- Check for updated jewelry
    local suffix = '-Jewelry-jewelry'
    local found = pName:sub(-string.len(suffix)) == suffix
    if found then
        TriggerServerEvent('np-gallery:fetchJewelry')
    end

    -- Check for scrapping jewelry
    suffix = 'Scrapper-jewelry'
    found = pName:sub(-string.len(suffix)) == suffix
    if found then
        TriggerServerEvent('np-gallery:scrapJewelry', pName)
    end
end)

AddEventHandler('np-gallery:jewelryAction', function(pParameters, pEntity, pContext)
    local type = pContext.zones['gallery_jewelry'].id

    local context = {}
    context[#context+1] = {
        title = 'Scrap Jewelry',
        icon = 'hammer',
        action = 'np-gallery:jewelryMenuAction',
        key = { scrap = true }
    }
    context[#context+1] = {
        title = 'Identify Jewelry',
        icon = 'search',
        action = 'np-gallery:jewelryMenuAction',
        key = { identify = true, type = type }
    }
    context[#context+1] = {
        title = 'Repair Jewelry',
        icon = 'tools',
        action = 'np-gallery:jewelryMenuAction',
        key = { repair = true, type = type }
    }
    if type == 'relics' then
        if not IsGalleryEmployee() then
            return
        end

        context[#context+1] = {
            title = 'Create Relic',
            titleRight = '▨ 5',
            icon = 'gem',
            action = 'np-gallery:jewelryMenuAction',
            key = { craft = true, type = 'relic', cost = 5 }
        }
    end

    if type == 'jewelry' then
        if not IsJewelryEmployee() then
            return
        end

        context[#context+1] = {
            title = 'Create Ring',
            titleRight = '▨ 5',
            icon = 'ring',
            action = 'np-gallery:jewelryMenuAction',
            key = { craft = true, type = 'ring', cost = 5 }
        }

        context[#context+1] = {
            title = 'Create Necklace',
            titleRight = '▨ 5',
            icon = 'spinner',
            action = 'np-gallery:jewelryMenuAction',
            key = { craft = true, type = 'necklace', cost = 5 }
        }
    end

    exports['np-ui']:showContextMenu(context)
end)

RegisterUICallback("np-gallery:jewelryMenuAction", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = "done" } })
    local data = data.key
    if data.scrap then
        local cid = exports['isPed']:isPed("cid")
        TriggerEvent("inventory-open-container", 'container-scrap:' .. cid .. '-Jewelry Scrapper-jewelry', 5, 30.0)
    end
    if data.identify then
        Wait(10)
        local type = data.type
        if not type then 
            type = 'relics'
        end
        local items = GetJewelryInventoryItems(type)

        if #items <= 0 then
            TriggerEvent('DoLongHudText', 'No items found', 2)
            return
        end

        local context = {}
        context[#context+1] = {
            title = 'Jewelry Items',
            icon = 'search',
        }

        context[#context+1] = {
            title = 'Identify All',
            icon = 'search-plus',
            action = 'np-gallery:jewelryMenuAction',
            key = { identifyAll = true, items = items }
        }

        for _,item in ipairs(items) do
            local info = json.decode(item.information)
            if info.identified then
                goto continue
            end
            context[#context+1] = {
                title = item.displayName,
                icon = item.displayIcon,
                titleRight = 'Slot ' .. item.slot,
                action = 'np-gallery:jewelryMenuAction',
                key = { identifyItem = true, item = item }
            }

            ::continue::
        end

        exports['np-ui']:showContextMenu(context)
    end

    if data.identifyAll then
        local items = data.items
        local length = math.floor(#items * 1000)
        Citizen.CreateThread(function()
            exports['np-taskbar']:taskBar(length, 'Identifying Jewelry')
        end)
        for _,item in ipairs(items) do
            local info = json.decode(item.information)
            if info.identified then
                goto continue
            end

            NPX.Procedures.execute('np-gallery:identifyJewelry', item)
            Wait(1000)
            ::continue::
        end
    end

    if data.identifyItem then
        Wait(10)
        local item = data.item

        local result = NPX.Procedures.execute('np-gallery:identifyJewelry', item)
        if not result then
            return
        end

        local context = {}
        context[#context+1] = {
            title = 'Result',
            icon = 'search',
        }
        for _,line in ipairs(result) do
            context[#context+1] = {
                title = line.label,
                titleRight = line.level,
            }
        end
        exports['np-ui']:showContextMenu(context)
    end

    if data.repair then
        Wait(10)
        local type = data.type
        if not type then 
            type = 'relics'
        end
        local items = GetJewelryInventoryItems(type)

        if #items <= 0 then
            TriggerEvent('DoLongHudText', 'No items found', 2)
            return
        end

        local context = {}
        context[#context+1] = {
            title = 'Jewelry Items',
            icon = 'search',
        }

        for _,item in ipairs(items) do
            if item.quality >= 95 then
                goto continue
            end

            local cost = 1 + math.floor((100 - item.quality) / 33)

            context[#context+1] = {
                title = item.displayName,
                description = 'Slot ' .. item.slot,
                titleRight = '▨ ' .. cost,
                icon = item.displayIcon,
                action = 'np-gallery:jewelryMenuAction',
                key = { repairItem = true, item = item, cost = cost }
            }

            ::continue::
        end

        exports['np-ui']:showContextMenu(context)
    end

    if data.repairItem then
        local item = data.item
        local cost = data.cost

        local hasParts = exports['np-inventory']:hasEnoughOfItem('jewelry_part', cost, false, true)
        if not hasParts then
            TriggerEvent('DoLongHudText', 'Not enough parts', 2)
            return
        end
        TriggerEvent('inventory:removeItem', 'jewelry_part', cost)
        local cid = exports['isPed']:isPed("cid")
        TriggerServerEvent("inventory:repairItem", item.id, 100, item.item_id, cid)
        TriggerEvent('DoLongHudText', 'Repaired')
    end

    if data.craft then
        local type = data.type
        local cost = data.cost

        local hasParts = exports['np-inventory']:hasEnoughOfItem('jewelry_part', cost, false, true)
        if not hasParts then
            TriggerEvent('DoLongHudText', 'Not enough parts', 2)
            return
        end

        TriggerServerEvent('np-gallery:craftJewelryItem', type, cost)
    end
end)

function GetJewelryInventoryItems(pType)
    local items = {}
    if pType == 'jewelry' then
        local rings = exports['np-inventory']:getItemsOfType('jewelry_ring', 10, false)
        local necklaces = exports['np-inventory']:getItemsOfType('jewelry_necklace', 10, false)
        for _,item in pairs(rings) do
            item.displayName = 'Ring'
            item.displayIcon = 'ring'
            items[#items+1] = item
        end
        for _,item in pairs(necklaces) do
            item.displayName = 'Necklace'
            item.displayIcon = 'spinner'
            items[#items+1] = item
        end
    end
    if pType == 'relics' then
        local relics = exports['np-inventory']:getItemsOfType('jewelry_relic', 10, false)
        for _,item in pairs(relics) do
            item.displayName = 'Relic'
            item.displayIcon = 'gem'
            items[#items+1] = item
        end
    end

    return items
end

AddEventHandler('np-spawn:characterSpawned', function()
    TriggerServerEvent('np-gallery:fetchJewelry')
end)

RegisterNetEvent('np-gallery:applyEffects', function(pEffects)
    appliedEffects = {}
    local appliedLucky = false

    for _,effect in pairs(pEffects) do
        effect.lastTick = GetGameTimer()
        appliedEffects[#appliedEffects+1] = effect

        if effect.id == 'LUCKY_BONUS' then
            appliedLucky = true
            TriggerEvent("np-buffs:applyBuff", "jewelry", { { buff = "jobluck", percent = (effect.level / 100), timeOverride = 12 * 60 * 60 * 1000 } })
        end
    end

    if not appliedLucky then
        TriggerEvent("np-buffs:applyBuff", "jewelry", { { buff = "jobluck", percent = 0.0, timeOverride = 1 } })
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(25000)
        for _,effect in ipairs(appliedEffects) do
            if isEnabled and effect.type and effect.type == 'interval' then
                if GetGameTimer() - effect.lastTick > effect.time then
                    effect.lastTick = GetGameTimer()
                    TriggerEvent(effect.event, effect.level)
                end
            end
        end
    end
end)

function GetEffect(pEffectId)
    for _,effect in ipairs(appliedEffects) do
        if effect.id == pEffectId then
            return effect
        end
    end
    return false
end

exports('GetEffect', GetEffect)

AddEventHandler('np-gallery:jewelry:armorRegen', function(pLevel)
    local armor = GetPedArmour(PlayerPedId())
    pLevel = pLevel / 4
    if math.floor(pLevel) == 0 then
        pLevel = 1
    end

    if math.random() > 0.98 then
        TriggerEvent("changehunger", -1)
    end

    exports['ragdoll']:SetPlayerArmor(math.floor(armor + pLevel))
end)

AddEventHandler('np-gallery:jewelry:healthRegen', function(pLevel)
    local health = GetEntityHealth(PlayerPedId())
    pLevel = pLevel / 4
    if math.floor(pLevel) == 0 then
        pLevel = 1
    end

    if math.random() > 0.98 then
        TriggerEvent("changehunger", -1)
    end

    exports['ragdoll']:SetPlayerHealth(math.floor(health + pLevel), true)
end)

AddEventHandler('np-gallery:jewelry:stressReduce', function(pLevel)
    TriggerEvent("client:newStress", false, pLevel, true)
end)

AddEventHandler('np-gallery:jewelry:jailTimeReduce', function(pLevel)
    if not isPrisoner then return end
    TriggerServerEvent('np-jail:reducePrisonTime', pLevel)
end)

AddEventHandler("np-jail:playerJailed", function(pMonths)
    if pMonths < 120 then
        isPrisoner = true
    end
end)

AddEventHandler("np-jail:playerUnjailed", function()
    isPrisoner = false
end)

exports('toggleEffects', function (toggle)
    isEnabled = toggle
end)
