-- local function usePanel(laptopId)
--     Citizen.CreateThread(function()
--         local ply = PlayerPedId()
--         local plyCoords = GetEntityCoords(ply)
--         local canUsePanel, loc = RPC.execute("heists:fleecaUsePanel", plyCoords, laptopId)
--         if not canUsePanel then
--             TriggerEvent("DoLongHudText", loc, 2)
--             return
--         end
        
--         local canRob = CheckRequiredItems(loc.code)
--         if not canRob then return end

--         local success = Citizen.Await(UseBankPanel(loc.panelCoords, loc.panelHeading, "fleeca"))

--         if not success then
--             RPC.execute("np-heists:fleecaPanelFail")
--             return
--         end

--         RemoveRequiredItems(loc.code)

--         TriggerServerEvent("dispatch:svNotify", {
--             dispatchCode = "10-90B",
--             origin = loc.panelCoords,
--         })

--         TriggerEvent("inventory:removeItemByMetaKV", "heistlaptop3", 1, "id", laptopId)

--         local shouldSpawnGold = RPC.execute("heists:fleecaStart", loc)
--         SpawnTrolley(loc.cashCoords, "cash", loc.cashHeading)
--         if shouldSpawnGold then
--             SpawnTrolley(loc.goldCoords, "gold", loc.goldHeading)
--         end
--     end)
-- end

-- function FleecaUsePanel(...)
--     usePanel(...)
-- end

-- AddEventHandler("heists:fleecaTrolleyGrab", function(loc, type)
--     local canGrab = RPC.execute("np-heists:fleecaCanGrabTrolley", loc, type)
--     if canGrab then
--         Loot(type)
--         TriggerEvent("DoLongHudText", "You discarded the counterfeit items", 1)
--         RPC.execute("np-heists:payoutTrolleyGrab", "fleeca", type)
--     else
--         TriggerEvent("DoLongHudText", "You can't do that yet...", 2)
--     end
-- end)

-- Citizen.CreateThread(function()
--   SpawnTrolley(vector3(147.16,-1049.69,29.35), "cash", 311.58)
-- end)
-- AddEventHandler("np-inventory:itemUsed", function(pItem)
--     if pItem ~= "securityblack" then return end

--     local fleecas = RPC.execute("heists:fleecaGetLocations")
--     local playerCoords = GetEntityCoords(PlayerPedId())

--     local currentFleeca = nil

--     for id, bank in ipairs(fleecas) do
-- 			if #(playerCoords - bank.panelCoords) <= 1 then
-- 					currentFleeca = bank
-- 			end
-- 		end

-- 		if currentFleeca == nil then return end

-- 		local success = RPC.execute("np-heists:fleeca:openBank", currentFleeca.doorConf, currentFleeca.name)
		
-- 		if success then
-- 			TriggerEvent("inventory:removeItem", "securityblack", 1)
-- 		end
-- end)
