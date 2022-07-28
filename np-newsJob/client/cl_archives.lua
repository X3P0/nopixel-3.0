AddEventHandler("np-newsjob:openArchives", function(pParameters, pEntity, pContext)
    local hasPerms = RPC.execute("np-business:hasPermission", "lsbn", "craft_access")
    if not hasPerms then return TriggerEvent("DoLongHudText", "You don't have access to these") end
    exports["np-ui"]:openApplication("newsarchive")
end)

AddEventHandler('np-newsjob:ingestFootage', function(pParameters, pEntity, pContext)
    local tapes = exports["np-inventory"]:getItemsOfType("newstape", 10, true, { ingested = 0, copy = 0 })
    local context = {
        {
            title = "Select a tape to ingest",
            i18nTitle = true,
        }
    }
    for index,tape in ipairs(tapes) do
        local info = json.decode(tape.information)

        context[#context+1] = {
            title = ("%s - Duration: %ss"):format(info.id, info.duration),
            description = ("Date: %s"):format(info.dateString),
            action = "np-newsjob:ingestTape",
            key = tape
        }
    end
    exports['np-ui']:showContextMenu(context)
end)

RegisterUICallback('np-newsjob:ingestTape', function (data, cb)
    local cid = exports["isPed"]:isPed("cid")
    local info = json.decode(data.key.information)
    local animDict = 'anim@heists@prison_heiststation@cop_reactions'
    loadAnimDict(animDict)
    TaskPlayAnim(PlayerPedId(), animDict, 'cop_b_idle', 2.0, -2.0, -1, 1, 1.0, false, false, false)
    exports["np-taskbar"]:taskBar(15000, "Ingesting Footage")
    ClearPedTasks(PlayerPedId())
    local success, message = RPC.execute("np-newsjob:ingestFootage", data.key, info)
    if not success then
        TriggerEvent("DoLongHudText", message)
    end
    info.ingested = success and 1 or 0
    TriggerServerEvent("server-update-item", cid, "newstape", data.key.slot, json.encode(info))
    cb({ data = {}, meta = { ok = true, message = '' } })
end)

RegisterUICallback('np-ui:getNewsArchives', function (data, cb)
    local archives = RPC.execute("np-newsjob:getArchives", data)
    cb({ data = archives, meta = { ok = true, message = '' } })
end)

RegisterUICallback('np-ui:newsArchiveAction', function (data, cb)
    if data.action == "export" then
        data.data.copy = 1
        data.data._image_url = "icons/np_news_tape_copy.png"
        data.data.Duplicate = true
        TriggerEvent("player:receiveItem", "newstape", 1, false, {}, json.encode(data.data))
        cb({ data = {}, meta = { ok = true, message = '' } })
        return
    end
    local success = RPC.execute("np-newsjob:updateFootage", data.action, data.data)
    cb({ data = {}, meta = { ok = true, message = '' } })
end)
