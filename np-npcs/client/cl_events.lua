RegisterNetEvent("np-npcs:set:ped")
AddEventHandler("np-npcs:set:ped", function(pNPCs)
  if type(pNPCs) == "table" then
    for _, ped in ipairs(pNPCs) do
      RegisterNPC(ped, 'np-npcs')
      EnableNPC(ped.id)
    end
  else
    RegisterNPC(ped, 'np-npcs')
    EnableNPC(ped.id)
  end
end)

RegisterNetEvent("np-npcs:set:position")
AddEventHandler("np-npcs:set:position", function(pId, pVectors, pHeading)
  local position = { coords = pVectors, heading = pHeading}
  UpdateNPCData(pId, 'position', position)
end)

RegisterNetEvent("np-npcs:ped:giveStolenItems")
AddEventHandler("np-npcs:ped:giveStolenItems", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  local npcCoords = GetEntityCoords(pEntity)
  local finished = exports["np-taskbar"]:taskBar(15000, "Preparing to receive goods, don't move.")
  if finished == 100 then
    if #(GetEntityCoords(PlayerPedId()) - npcCoords) < 2.0 then
      local serverCode = exports["np-config"]:GetServerCode()
      TriggerEvent("server-inventory-open", "1", "Stolen-Goods-1-" .. serverCode)
    else
      TriggerEvent("DoLongHudText", "You moved too far you idiot.", 105)
    end
  end
end)

RegisterNetEvent("np-npcs:ped:exchangeRecycleMaterial")
AddEventHandler("np-npcs:ped:exchangeRecycleMaterial", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  local npcCoords = GetEntityCoords(pEntity)
  local finished = exports["np-taskbar"]:taskBar(3000, "Preparing to exchange material, don't move.")
  if finished == 100 then
    if #(GetEntityCoords(PlayerPedId()) - npcCoords) < 2.0 then
      TriggerEvent("server-inventory-open", "35", "Craft");
    else
      TriggerEvent("DoLongHudText", "You moved too far you idiot.", 105)
    end
  end
end)

RegisterNetEvent("np-npcs:ped:signInJob")
AddEventHandler("np-npcs:ped:signInJob", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  if #pArgs == 0 then
    local npcId = DecorGetInt(pEntity, 'NPC_ID')
    if npcId == `news_reporter` then
      TriggerServerEvent("jobssystem:jobs", "news")
    elseif npcId == `head_stripper` then
      TriggerServerEvent("jobssystem:jobs", "entertainer")
    end
  else
    TriggerServerEvent("jobssystem:jobs", "unemployed")
  end
end)

RegisterNetEvent("np-npcs:ped:paycheckCollect")
AddEventHandler("np-npcs:ped:paycheckCollect", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  TriggerServerEvent("server:paySlipPickup")
end)

RegisterNetEvent("np-npcs:ped:receiptTradeIn")
AddEventHandler("np-npcs:ped:receiptTradeIn", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  local cid = exports["isPed"]:isPed("cid")
  local accountStatus, accountTarget = RPC.execute("GetDefaultBankAccount", cid)
  if not accountStatus then return end
  RPC.execute("np-inventory:tradeInReceipts", cid, accountTarget)
end)

RegisterNetEvent("np-npcs:ped:receiptTradeInMarket")
AddEventHandler("np-npcs:ped:receiptTradeInMarket", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  local cid = exports["isPed"]:isPed("cid")
  RPC.execute("np-inventory:tradeInReceiptsMarket", cid)
end)

RegisterNetEvent("np-npcs:ped:sellStolenItems")
AddEventHandler("np-npcs:ped:sellStolenItems", function()
  RPC.execute("np-inventory:sellStolenItems", false)
end)

RegisterNetEvent("np-npcs:ped:keeper")
AddEventHandler("np-npcs:ped:keeper", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  TriggerEvent("server-inventory-open", pArgs[1], "Shop")
end)
RegisterNetEvent("np-npcs:ped:keeperLiqour")
AddEventHandler("np-npcs:ped:keeperLiqour", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  TriggerEvent("server-inventory-open", pArgs[1], "Shop");
end)

TriggerServerEvent("np-npcs:location:fetch")

AddEventHandler("np-npcs:ped:weedSales", function(pArgs, pEntity, pEntityFlags, pEntityCoords)
  local result, message = RPC.execute("np-npcs:weedShopOpen")
  if not result then
    TriggerEvent("DoLongHudText", message, 2)
    return
  end
  TriggerEvent("server-inventory-open", "44", "Shop");
end)

AddEventHandler("np-npcs:ped:licenseKeeper", function(pData)
  RPC.execute("np-npcs:purchaseDriversLicense", pData.type)
end)

AddEventHandler('np-island:hideBlips', function(pState)
  for _, data in pairs(Handler.npcs) do
    if data["npc"].blipHandler then
      data["npc"].blipHandler:hide(pState)
    end
  end
end)
