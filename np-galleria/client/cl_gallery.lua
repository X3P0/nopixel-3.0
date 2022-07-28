-- local camCoords = vector3(-542.3707, -436.3848, 94.16705)
local gemCoords = vector4(-468.39, 32.69, 46.92, 264.01)
local inAppraisalArea = false
local staticCam
local gem = 0

function IsGalleryEmployee()
  local jobAccess = exports['np-business']:IsEmployedAt('gallery')
  if not jobAccess then
    TriggerEvent("DoLongHudText", "They do not recognize you", 2)
    return false
  end
  return true
end

function IsJewelryEmployee()
  local jobAccess = exports['np-business']:IsEmployedAt('jeweled_dragon')
  if not jobAccess then
    TriggerEvent("DoLongHudText", "They do not recognize you", 2)
    return false
  end
  return true
end

AddEventHandler("np-polyzone:enter", function(name)
  if name ~= "gallery_appraisals" then return end
  inAppraisalArea = true
end)

AddEventHandler("np-polyzone:exit", function(name)
  if name ~= "gallery_appraisals" then return end
  inAppraisalArea = false
end)

AddEventHandler("np-gallery:sellGems", function()
  local anyoneSellGems = exports['np-config']:GetMiscConfig("gallery.anyone.sell.gems")
  if anyoneSellGems then
    TriggerServerEvent("np-gallery:sellGemsFromNPC")
    return
  end
  if not IsGalleryEmployee() then return end
  local craftAccess = RPC.execute("np-business:hasPermission", "gallery", "craft_access", characterId)
  if not craftAccess then
    TriggerEvent("DoLongHudText", "Insufficient permissions", 2)
    return
  end
  TriggerServerEvent("np-gallery:sellGemsFromNPC")
end)

AddEventHandler("np-inventory:itemUsed", function(item, info)
  if item ~= "gallerygem" then return end
  if not inAppraisalArea then
    TriggerEvent("DoLongHudText", "Can't do that here.", 2)
    return
  end
  local info = json.decode(info)
  createGem(info.color, info.purity)
end)

local listening = false
function listenForEscapeKeypress()
  if listening then return end
  listening = true
  Citizen.CreateThread(function()
    exports["np-ui"]:showInteraction("[ESC] Exit")
    while listening do
      if IsControlJustReleased(0, 177) then
          listening = false
          exports["np-ui"]:hideInteraction()
          FreezeEntityPosition(PlayerPedId(), false)
          DoScreenFadeOut(1000)
          Wait(1000)
          deleteGem()
          exports["np-ui"]:sendAppEvent("preferences", {
            ["hud.blackbars.enabled"] = false,
          })
          DoScreenFadeIn(1000)
          return
      end
      local curHeading = GetEntityHeading(gem)
      if curHeading >= 360 then
        curHeading = 0.0
      end
      SetEntityHeading(gem, curHeading + 0.1)
      DisablePlayerFiring(PlayerPedId(), true)
      Wait(0)
    end
  end)
end

function createGem(color, purity)
  RequestModel("npgem")
  while not HasModelLoaded("npgem") do
    Wait(0)
  end
  DeleteEntity(gem)
  local obj = -1
  local loopcount = 0
  while loopcount < 5 do
    obj = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, `npgem`, 0)
    loopcount = loopcount + 1
    DeleteEntity(obj)
  end
  DoScreenFadeOut(1000)
  FreezeEntityPosition(PlayerPedId(), true)
  Wait(1000)
  local dirtLevel = (15 - math.floor(purity / 6.66)) + 0.0
  gem = CreateVehicle(`npgem`, gemCoords, 0, 0)
  FreezeEntityPosition(gem, true)
  SetEntityCollision(gem, false, false)
  SetVehicleDirtLevel(gem, dirtLevel)
  SetVehicleColours(gem, color, 0)
  SetVehicleExtraColours(gem, 0, false)
  staticCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
  SetCamCoord(staticCam, GetOffsetFromEntityInWorldCoords(gem, 0.5, 0.0, 0.1))
  SetCamRot(staticCam, -20.0, 0.0, 352.0)
  SetCamFov(staticCam, 50.0)
  RenderScriptCams(true, false, 0, 1, 0)
  exports["np-ui"]:sendAppEvent("preferences", {
    ["hud.blackbars.enabled"] = true,
  })
  Wait(200)
  DoScreenFadeIn(1000)
  listenForEscapeKeypress()
end

function deleteGem()
  RenderScriptCams(false, false, 0, 1, 0)
  DeleteEntity(gem)
end

AddEventHandler('np-gallery:gemTrade', function(pParameters, pEntity, pContext)
  TriggerEvent('server-inventory-open', '1', 'gallery_gemtrade')
end)

RegisterUICallback("np-ui:galleryGemCraft", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  local gemType = data.key
  local ringCount = 0
  local items = exports["np-inventory"]:GetItemsByItemMetaKV("gallerygem", "type", gemType)
  if #items == 0 then
    TriggerEvent("DoLongHudText", "Not enough gems found.", 2)
    return
  end
  TriggerEvent("inventory:removeItemByMetaKV", "gallerygem", #items, "type", gemType)
  Wait(500)
  TriggerEvent("player:receiveItem", "craftedgem" .. gemType, #items)
end)

AddEventHandler('np-gallery:gemCraft', function(pParameters, pEntity, pContext)
  if not IsGalleryEmployee() then return end
  local data = {
    {
      title = "Jade",
      description = "Nourishment",
      key = "jade",
      action = "np-ui:galleryGemCraft",
    },
    {
      title = "Citrine",
      description = "Rejuvenation",
      key = "citrine",
      action = "np-ui:galleryGemCraft",
    },
    {
      title = "Aquamarine",
      description = "Water",
      key = "aquamarine",
      action = "np-ui:galleryGemCraft",
    },
    {
      title = "Sapphire",
      description = "5g",
      key = "sapphire",
      action = "np-ui:galleryGemCraft",
    },
    {
      disabled = true,
      title = "Ruby",
      description = "Find out soon",
      key = "ruby",
      action = "np-ui:galleryGemCraft",
    },
    {
      disabled = true,
      title = "Diamond",
      description = "Find out soon",
      key = "diamond",
      action = "np-ui:galleryGemCraft",
    },
    {
      disabled = true,
      title = "Tanzanite",
      description = "Find out soon",
      key = "tanzanite",
      action = "np-ui:galleryGemCraft",
    },
    {
      disabled = true,
      title = "Onyx",
      description = "Find out soon (maybe, do some work)",
      key = "onyx",
      action = "np-ui:galleryGemCraft",
    },
  }
  exports["np-ui"]:showContextMenu(data)
end)

local onUseItems = {
  ["craftedgemjade"] = true,
  ["craftedgemcitrine"] = true,
  ["craftedgemaquamarine"] = true,
}
AddEventHandler("np-inventory:itemUsed", function(item)
  if not onUseItems[item] then return end
  TriggerEvent("inventory:removeItem", item, 1)
  TriggerEvent("buffs:triggerBuff", item)
  if item == "craftedgemaquamarine" then
    TriggerEvent("np-buffs:applyBuff", "craftedgemaquamarine", { { buff = "swimming", percent = 0.5 } })
  end
  if item == "craftedgemjade" then
    TriggerEvent("DoLongHudText", "You feel nourished")
  end
end)

RegisterUICallback("np-ui:gallery:pictureReplaceAction", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  exports['np-ui']:closeApplication('textbox')
  local id = data.key.id
  local room = data.key.room
  local url = data.values.url
  TriggerServerEvent("np-gallery:savePictureReplace", room, id, url)
end)

AddEventHandler("np-gallery:pictureReplaceAction", function(pParameters, pEntity, pContext)
  if not IsGalleryEmployee() then return end
  exports['np-ui']:openApplication('textbox', {
    callbackUrl = 'np-ui:gallery:pictureReplaceAction',
    key = pContext.zones["gallery_room_pictures"],
    items = {
      {
        icon = "pencil-alt",
        label = "URL (imgur; 512x512px)",
        name = "url",
      },
    },
    show = true,
  })
end)

--
local inPictureRoom = false
local roomSettings = nil
local roomDuis = {}
function updateRoomSettings(pSettings)
  roomSettings = pSettings
  if not inPictureRoom then return end
  local pad = function(n) return n < 10 and ("0" .. tostring(n)) or tostring(n) end
  for i = 1, 12, 1 do
    local pictureId = "id_" .. tostring(i)
    local url = (roomSettings["room_6"] and roomSettings["room_6"][pictureId]) and roomSettings["room_6"][pictureId] or nil
    if url then
      local txName = "gallery_room" .. tostring(6) .. "_picture_" .. pad(i) .. "_txd"
      if not roomDuis[i] then
        roomDuis[i] = exports["np-lib"]:getDui(url)
        AddReplaceTexture("gallery_pictures_02_txd", txName, roomDuis[i].dictionary, roomDuis[i].texture)
      else
        exports["np-lib"]:changeDuiUrl(roomDuis[i].id, url)
      end
    end
  end
end
RegisterNetEvent("np-gallery:updateReplacedPictures")
AddEventHandler("np-gallery:updateReplacedPictures", updateRoomSettings)

AddEventHandler("np-polyzone:enter", function(zone)
  if zone ~= "gallery_picture_room" then return end
  inPictureRoom = true
  if roomSettings then
    updateRoomSettings(roomSettings)
    return
  end
  TriggerServerEvent("np-gallery:getRoomPaintingSettings")
end)
AddEventHandler("np-polyzone:exit", function(zone)
  if zone ~= "gallery_picture_room" then return end
  inPictureRoom = false
  local pad = function(n) return n < 10 and ("0" .. tostring(n)) or tostring(n) end
  for i = 1, 12, 1 do
    local pictureId = "id_" .. tostring(i)
    local url = (roomSettings["room_6"] and roomSettings["room_6"][pictureId]) and roomSettings["room_6"][pictureId] or nil
    if url then
      local txName = "gallery_room" .. tostring(6) .. "_picture_" .. pad(i) .. "_txd"
      if roomDuis[i] ~= nil then
        exports["np-lib"]:releaseDui(roomDuis[i].id)
        roomDuis[i] = nil
        RemoveReplaceTexture("gallery_pictures_02_txd", txName)
      end
    end
  end
end)

AddEventHandler("np-gallery:interiorSwap", function(pArgs)
  if not IsGalleryEmployee() then return end
  TriggerServerEvent("np-galleria:interiorSwap", pArgs[1])
end)

-- RegisterCommand("dogalleryreplace", function()
--   for i = 1, 12, 1 do
--     TriggerServerEvent("np-gallery:savePictureReplace", 6, i, "https://i.imgur.com/M95SXa2.png")
--   end
-- end, false)

Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-431.23, 32.07, 46.68), 0.4, 1, {
    heading=355,
    minZ=47.28,
    maxZ=48.08,
    data = {
      room = 6,
      id = 1,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-429.75, 31.88, 46.68), 0.4, 1, {
    heading=355,
    minZ=46.93,
    maxZ=47.73,
    data = {
      room = 6,
      id = 2,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-428.91, 31.73, 46.68), 0.4, 0.6, {
    heading=355,
    minZ=47.58,
    maxZ=48.38,
    data = {
      room = 6,
      id = 3,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-428.23, 34.07, 46.68), 0.2, 1.4, {
    heading=265,
    minZ=47.18,
    maxZ=48.38,
    data = {
      room = 6,
      id = 4,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-427.84, 38.39, 46.68), 0.2, 1.4, {
    heading=265,
    minZ=47.18,
    maxZ=48.38,
    data = {
      room = 6,
      id = 5,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-428.87, 40.74, 46.68), 0.2, 0.6, {
    heading=175,
    minZ=47.58,
    maxZ=47.98,
    data = {
      room = 6,
      id = 6,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-429.68, 40.84, 46.68), 0.2, 0.6, {
    heading=175,
    minZ=47.58,
    maxZ=47.98,
    data = {
      room = 6,
      id = 7,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-430.44, 40.89, 46.68), 0.2, 0.6, {
    heading=175,
    minZ=47.58,
    maxZ=47.98,
    data = {
      room = 6,
      id = 8,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-437.94, 41.48, 46.68), 0.2, 1.4, {
    heading=175,
    minZ=47.18,
    maxZ=48.38,
    data = {
      room = 6,
      id = 9,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-440.22, 32.82, 46.68), 0.2, 0.6, {
    heading=175,
    minZ=47.33,
    maxZ=47.93,
    data = {
      room = 6,
      id = 10,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-438.76, 32.72, 46.68), 0.2, 0.6, {
    heading=175,
    minZ=47.33,
    maxZ=47.93,
    data = {
      room = 6,
      id = 11,
    },
  })
  exports["np-polytarget"]:AddBoxZone("gallery_room_pictures", vector3(-437.32, 32.57, 46.68), 0.2, 0.6, {
    heading=175,
    minZ=47.33,
    maxZ=47.93,
    data = {
      room = 6,
      id = 12,
    },
  })
  exports['np-interact']:AddPeekEntryByPolyTarget("gallery_room_pictures", {{
    event = "np-gallery:pictureReplaceAction",
    id = "picture_replace_action",
    icon = "circle",
    label = "Replace Picture",
    parameters = {},
  }}, { distance = { radius = 3.5 } })
  exports["np-polyzone"]:AddBoxZone("gallery_picture_room", vector3(-434.24, 36.74, 46.68), 8.8, 12.4, {
    heading=355,
    minZ=45.48,
    maxZ=49.48,
    data = {
      id = 1,
    },
  })
end)

-- gallery_pictures_txd
-- gallery_room6_picture_05_txd

-- Citizen.CreateThread(function()
--   while true do
--     TriggerServerEvent("np-gallery:generateGem", "heist")
--     Wait(100)
--   end
-- end)

-- RegisterCommand("creategem", createGem, false)

-- Citizen.CreateThread(function()
--   TriggerServerEvent("np-gallery:generateGem")
-- end)

-- local offset = 4.0
-- Citizen.CreateThread(function()
--   for _, keys in pairs(gemVariations) do
--     for _, color in pairs(keys.colors) do
--       RequestModel("asbo")
--       while not HasModelLoaded("asbo") do
--         Wait(0)
--       end
--       local coords = GetEntityCoords(PlayerPedId())
--       coords = vector3(coords.x + offset, coords.y, coords.z)
--       offset = offset + 4.0
--       local veh = CreateVehicle(`asbo`, coords, 0.0, 0, 0)
--       SetVehicleColours(veh, color, 0)
--       SetVehicleDirtLevel(veh, 0.0)
--     end
--   end
-- end)
