-- local portalCoords = {
--   ["pp"] = vector3(2666.09, 1714.15, 24.49),
--   ["vault"] = vector3(251.11, 218.66, 101.68),
-- }
-- local ppPortalActive = false
-- local inPpPortal = false
-- local vaultPortalActive = false
-- local inVaultPortal = false

-- -- Citizen.CreateThread(function()
-- --   Citizen.Wait(1000)
-- --   TriggerEvent("drawPortal", { x = -144.54, y = -593.28, z = 211.78 })
-- --   Citizen.CreateThread(function()
-- --     Citizen.Wait(5000)
-- --     PlaySoundFrontend(-1, "ON", "NOIR_FILTER_SOUNDS", true)
-- --     SetExtraTimecycleModifier("NG_filmnoir_BW01")
-- --     doItPleb = true
-- --     Citizen.CreateThread(function()
-- --         Wait(5000)
-- --         doItPleb = false
-- --         ClearExtraTimecycleModifier()
-- --     end)
-- --     while doItPleb do
-- --       RegisterNoirScreenEffectThisFrame()
-- --       Wait(0)
-- --     end
-- --   end)
-- -- end)

-- Citizen.CreateThread(function()
--   exports["np-polyzone"]:AddBoxZone("katana_portal", vector3(2666.09, 1714.15, 24.49), 5, 5, {
--     heading=0,
--     minZ=23.29,
--     maxZ=26.09,
--     data = {
--       id = "pp",
--     },
--   })
--   exports["np-polyzone"]:AddBoxZone("katana_portal", vector3(251.11, 218.66, 101.68), 5, 5, {
--     heading=340,
--     minZ=100.48,
--     maxZ=103.08,
--     data = {
--       id = "vault",
--     },
--   })
-- end)
-- RegisterNetEvent("drawPortal", function(pCoords, pType)
--   if pType == "pp" then
--     ppPortalActive = true
--   end
--   if pType == "vault" then
--     vaultPortalActive = true
--   end
-- end)
-- AddEventHandler("np-polyzone:enter", function(pZone, pData)
--   if pZone ~= "katana_portal" then return end
--   if pData.id == "pp" and ppPortalActive then
--     if not inPpPortal then
--       inPpPortal = true
--       Citizen.CreateThread(function()
--         PlaySoundFrontend(-1, "ON", "NOIR_FILTER_SOUNDS", true)
--         SetExtraTimecycleModifier("NG_filmnoir_BW01")
--         while inPpPortal do
--           RegisterNoirScreenEffectThisFrame()
--           Wait(0)
--         end
--       end)
--     else
--       inPpPortal = false
--       PlaySoundFrontend(-1, "ON", "NOIR_FILTER_SOUNDS", true)
--       ClearExtraTimecycleModifier()
--     end
--     return
--   end
--   if pData.id == "vault" and vaultPortalActive then
--     if not inVaultPortal then
--       inVaultPortal = true
--       Citizen.CreateThread(function()
--         PlaySoundFrontend(-1, "ON", "NOIR_FILTER_SOUNDS", true)
--         SetExtraTimecycleModifier("NG_filmnoir_BW01")
--         while inVaultPortal do
--           RegisterNoirScreenEffectThisFrame()
--           Wait(0)
--         end
--       end)
--     else
--       inVaultPortal = false
--       PlaySoundFrontend(-1, "ON", "NOIR_FILTER_SOUNDS", true)
--       ClearExtraTimecycleModifier()
--     end
--     return
--   end
-- end)

-- AddEventHandler("np-inventory:itemUsed", function(pItem)
--   if pItem ~= "portalopener" then return end
--   local coords = GetEntityCoords(PlayerPedId())
--   if #(coords - portalCoords.pp) < 30.0 then
--     local c = portalCoords.pp
--     TriggerServerEvent("np-katana:drawPortal", { x = c.x, y = c.y, z = c.z }, "pp")
--     return
--   end
--   if #(coords - portalCoords.vault) < 30.0 then
--     local c = portalCoords.vault
--     TriggerServerEvent("np-katana:drawPortal", { x = c.x, y = c.y, z = c.z }, "vault")
--     return
--   end
-- end)

-- local mrkrestore = json.decode('{"model":1917442495,"drawables":{"1":["masks",1],"2":["hair",0],"3":["torsos",3],"4":["legs",5],"5":["bags",0],"6":["shoes",4],"7":["neck",0],"8":["undershirts",0],"9":["vest",0],"10":["decals",1],"11":["jackets",0],"0":["face",1]},"proptextures":[["hats",0],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]],"headOverlay":[],"props":{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",0]},"hairColor":[-1,-1],"drawtextures":[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",0],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]],"headStructure":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],"fadeStyle":"0"}')
-- RegisterCommand("restoreK", function()
--   exports["raid_clothes"]:LoadPed(mrkrestore, false)
-- end)

-- Citizen.CreateThread(function()
--   local ped = exports["raid_clothes"]:GetCurrentPed()
--   print(json.encode(ped))
-- end)

-- with chain
local mrKPedDrawables = json.decode('{"Face":[2,0],"Mask":[4,0],"Hair":[0,0],"Torso":[9,0],"Leg":[2,1],"Parachute":[2,0],"Shoes":[3,6],"Accessory":[0,1],"Undershirt":[0,0],"Kevlar":[0,0],"Badge":[1,0],"Jacket":[2,0]}')
local mrKPedProps = json.decode('{"Hat":[-1,-1],"Glasses":[-1,-1],"Ears":[-1,-1],"Watch":[-1,-1],"Bracelet":[-1,-1]}')
-- without chain
-- local mrKPed = json.decode('{"drawtextures":[["face",0],["masks",0],["hair",0],["torsos",0],["legs",1],["bags",0],["shoes",6],["neck",1],["undershirts",0],["vest",0],["decals",0],["jackets",0]],"proptextures":[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]],"props":{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]},"drawables":{"1":["masks",4],"2":["hair",0],"3":["torsos",9],"4":["legs",2],"5":["bags",2],"6":["shoes",3],"7":["neck",0],"8":["undershirts",0],"9":["vest",0],"10":["decals",0],"11":["jackets",2],"0":["face",2]},"headStructure":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],"fadeStyle":"0","model":1917442495,"hairColor":[-1,-1],"headOverlay":[]}')
local function loadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Citizen.Wait(0)
  end
end
AddEventHandler("np-katana:cursedKatanaEquipC", function()
  exports["np-clothing"]:ApplyPedClothing(PlayerPedId(), mrKPedDrawables, mrKPedProps, {0, 0}, true)
  Citizen.CreateThread(function()
    Wait(1000)
    while GetSelectedPedWeapon(PlayerPedId()) == 1692590063 do
      Wait(100)
    end
    TriggerEvent('np-clothing:applyCurrentClothing')
    TriggerEvent("np-katana:removeEquippedKatana")
  end)
end)

-- local transforming = false
-- RegisterNetEvent("np-katana:transformK", function()
--   if GetEntityModel(PlayerPedId()) ~= `Mr_kebun` then return end
--   local dict, anim = "random@homelandsecurity", "knees_loop_girl"
--   loadAnim(dict)
--   TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)
--   Citizen.Wait(1000)
--   transforming = true
--   Citizen.CreateThread(function()
--     while transforming do
--       if not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 1) then
--         TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)
--       end
--       Citizen.Wait(1000)
--     end
--   end)
--   Citizen.Wait(15500)
--   transforming = false
--   exports["raid_clothes"]:LoadPed(mrKPed, false)
--   Citizen.Wait(2500)
--   dict = "amb@medic@standing@kneel@exit"
--   anim = "exit"
--   loadAnim(dict)
--   TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, -1, 0, 0.0, 0, 0, 0)
--   Citizen.Wait(10000)
--   TriggerEvent("player:receiveItem", "cursedkatanaweapon", 1)
-- end)

-- RegisterNetEvent("np-katana:powerPlantOut", function()
--   if not inPpPortal then return end
--   TriggerEvent("DoLongHudText", "The power is out!", 2)
-- end)

-- local thermiteLocs = {
--   {
--     coords = vector3(2862.46, 1510.17, 24.57),
--     -- dropAmount, letter, speed, inter
--     settings = {45, 3, 18, 510},
--   },
--   {
--     coords = vector3(2792.2724609375, 1482.2504882813, 23.831345367432),
--     -- dropAmount, letter, speed, inter
--     settings = {50, 2, 18, 510},
--   },
--   {
--     coords = vector3(2800.77, 1514.36, 23.6),
--     -- dropAmount, letter, speed, inter
--     settings = {40, 1, 19, 510},
--   },
--   {
--     coords = vector3(2809.61, 1547.67, 23.6),
--     -- dropAmount, letter, speed, inter
--     settings = {40, 3, 17, 510},
--   },
--   {
--     coords = vector3(2736.14, 1475.7, 44.5),
--     -- dropAmount, letter, speed, inter
--     settings = {60, 2, 19, 510},
--   },
--   {
--     coords = vector3(2752.0974121094, 1464.8940429688, 48.350548553467),
--     -- dropAmount, letter, speed, inter
--     settings = {50, 1, 17, 510},
--   },
-- }
-- AddEventHandler("np-inventory:itemUsed", function(pItem)
--   if pItem ~= "thermite" then return end
--   local settings = nil
--   local thermite = nil
--   local coords = GetEntityCoords(PlayerPedId())
--   for k, v in pairs(thermiteLocs) do
--     if #(v.coords - coords) < 1.5 then
--       settings = v.settings
--       thermite = k
--     end
--   end
--   if not settings then
--     TriggerEvent("DoLongHudText", "That doesn't seem right", 2)
--     return
--   end
--   local result = exports["np-thermite"]:startGame(settings[1], settings[2], math.ceil(settings[3] * 0.9), settings[4])
--   if not result then return end
--   TriggerServerEvent("np-katana:completeThermite", thermite)
--   TriggerEvent("attachItem", "minigameThermite")
--   RequestAnimDict("weapon@w_sp_jerrycan")
--   while not HasAnimDictLoaded("weapon@w_sp_jerrycan") do
--     Wait(0)
--   end
--   Wait(100)
--   TaskPlayAnim(PlayerPedId(),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
--   Wait(5000)
--   TaskPlayAnim(PlayerPedId(),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
--   TriggerEvent("destroyProp")
--   ClearPedTasks(PlayerPedId())
-- end)

-- local hackingCoords = vector3(259.73, 218.0, 101.69)
-- AddEventHandler("np-inventory:itemUsed", function(pItem)
--   if pItem ~= "electronickit" then return end
--   local coords = GetEntityCoords(PlayerPedId())
--   if #(coords - hackingCoords) > 1 then
--     TriggerEvent("DoLongHudText", "That doesn't seem right", 2)
--     return
--   end
--   TriggerEvent("mhacking:show")
--   TriggerEvent("mhacking:start", 6, 12, 1, function(success)
--     Wait(2000)
--     TriggerEvent("mhacking:hide")
--     if not success then return end
--     TriggerEvent("player:receiveItem", "ckatana", 1)
--     Wait(500)
--     TriggerEvent("player:receiveItem", "gemanjipouch", 1)
--   end)
-- end)
