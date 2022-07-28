local isDrinking = false

AddEventHandler("np-inventory:itemUsed", function(item, info)
    if item == "honestwinebox" then
        data = json.decode(info)
        TriggerEvent("inventory-open-container", data.inventoryId, data.slots, data.weight)
    end

    if item == "honestwinebottle" then
        TriggerEvent("server-inventory-open", "42070", "Craft");
    end

    if item == "honestwineglass" then
        local animDict = "amb@world_human_drinking@coffee@male@idle_a"
        while (not HasAnimDictLoaded(animDict)) do
            RequestAnimDict(animDict)
            Citizen.Wait(0)
        end

        isDrinking = true
        TriggerEvent("inventory:removeItem", "honestwineglass", 1)
        TriggerEvent("attachItem", "wineglass")

        Citizen.CreateThread(function()
            while isDrinking do
                if not IsEntityPlayingAnim(PlayerPedId(), animDict, "idle_c", 3) then
                    TaskPlayAnim(PlayerPedId(), animDict, "idle_c", 1.0, 0.1, -1, 49, 0, 0, 0, 0)
                    Wait(100)
                end
                if IsControlJustReleased(0, 38) then
                    TaskPlayAnim(PlayerPedId(), animDict, "idle_b", 1.0, 0.1, -1, 50, 0, 0, 0, 0)
                    TriggerEvent("fx:run", "alcohol", 180, 0.2, -1, false)
                    TriggerEvent("addThirst", 5)
                    TriggerEvent("client:newStress", false, 100)
                    Wait(5500)
                end
                Wait(0)
            end
            Wait(1000)
            ClearPedSecondaryTask(PlayerPedId())
            TriggerEvent("destroyProp")
            TriggerEvent("player:receiveItem", "wineglass", 1)
        end)
    end
end)

AddEventHandler("turnoffsitting", function()
    isDrinking = false
end)
