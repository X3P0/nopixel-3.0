local NPC_DATA = {
  { name = 'Dock Worker', coords = vector4(797.59, -2988.53, 6.03, 92.98), id = 'docks', model = 's_m_m_trucker_01', sprite = 477 },
  { name = 'Dairy Farmer', coords = vector4(1195.84, 1819.34, 78.93, 98.78), id = 'milk', model = 's_m_y_winclean_01', sprite = 479 },
  { name = 'Meat Processor', coords = vector4(961.81, -2189.56, 30.51, 73.62), id = 'meat', model = 's_m_y_factory_01', sprite = 154 },
  { name = 'Vegetable Farmer', coords = vector4(1710.02, 4728.64, 42.15, 105.76), id = 'vegetable', model = 's_f_y_migrant_01',
    sprite = 568 },
  { name = 'Grain Farmer', coords = vector4(2016.6, 4987.49, 42.1, 199.57), id = 'grain', model = 'a_m_m_farmer_01', sprite = 557 },
  { name = 'Chef', coords = vector4(-1455.73, -169.91, 48.83, 98.5), id = 'season', model = 's_m_y_chef_01', sprite = 568 },
  { name = 'Factory Worker', coords = vector4(526.0, -1653.72, 29.32, 128.44), id = 'leaven', model = 's_f_y_factory_01', sprite = 569 },
  { name = 'Fish Extracts', coords = vector4(-1810.62, -1207.84, 14.31, 102.21), id = 'oil', model = 's_m_y_uscg_01', sprite = 410 },
}

local BUSINESS_CODES = { 'burger_shot', 'uwu_cafe', 'roosters', 'maldinis' }

Citizen.CreateThread(function()
  local ids = {}
  for idx, npc in ipairs(NPC_DATA) do
    local data = {
      id = 'npc_ingred_' .. npc.id,
      position = { coords = vector3(npc.coords.x, npc.coords.y, npc.coords.z - 1.0), heading = npc.coords.w },
      pedType = 4,
      model = npc.model,
      networked = false,
      distance = 50.0,
      settings = { { mode = 'invincible', active = true }, { mode = 'ignore', active = true }, { mode = 'freeze', active = true } },
      flags = { isNPC = true },
      blip = { color = idx + 2, sprite = npc.sprite, scale = 0.8, text = npc.name, short = true },
    }
    local _npc = exports['np-npcs']:RegisterNPC(data, 'np-biz:ingr_' .. npc.id)
    exports['np-npcs']:EnableNPC(_npc.id)
    ids[#ids + 1] = _npc.id
  end

  exports['np-interact']:AddPeekEntryByFlag({ 'isNPC' }, {
    { id = 'biz_open_ingredients', label = 'View Stock', icon = 'list-alt', event = 'np-business:ingredients:open' },
  }, { distance = { radius = 2.5 }, npcIds = ids })
end)

AddEventHandler('np-business:ingredients:open', function(pArgs, pEntity, pContext)
  -- local passed = false
  -- for _, biz in ipairs(BUSINESS_CODES) do
  --   if IsEmployedAt(biz) then
  --     passed = true
  --     break
  --   end
  -- end
  -- if not passed then
  --   TriggerEvent('DoLongHudText', 'You cannot access this shop.', 2)
  --   return
  -- end

  local npcType
  for _, npc in ipairs(NPC_DATA) do
    -- this should maybe be replaced with coord distance check
    if GetHashKey(npc.model) == GetEntityModel(pEntity) then
      npcType = npc.id
      break
    end
  end

  local _context = RPC.execute('np-business:ingredients:getShop', npcType)
  exports['np-ui']:showContextMenu(_context)
end)

RegisterUICallback('np-business:ingredients:collectIngredients', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  RPC.execute('np-business:ingredients:collectionHandler', data)
end)

RegisterUICallback('np-business:ingredients:purchaseIngredients', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = '' } })
  RPC.execute('np-business:ingredients:purchaseHandler', data)
end)

-- Citizen.CreateThread(function()
--   local context = {
--     {
--       title = 'Main Dishes',
--       icon = 'utensils',
--     },
--     {
--       title = 'Create New',
--     },
--     {
--       title = 'Food-Title-1',
--       image = 'https://i.imgur.com/q6WCfU2.png',
--       children = {
--         {
--           title = 'Cook Food-Title-1',
--           description = 'Cooking Time: 24s',
--           icon = 'temperature-high',
--         },
--         {
--           title = 'Grain x1',
--           icon = 'bread-slice',
--           disabled = true,
--         },
--         {
--           title = 'Seasoning x1',
--           icon = 'tree',
--           disabled = true,
--         },
--         {
--           title = 'Protein x2',
--           icon = 'drumstick-bite',
--           disabled = true,
--         },
--         {
--           title = 'Vegetables x1',
--           icon = 'carrot',
--           disabled = true,
--         },
--         {
--           title = 'Delete',
--           icon = 'times',
--           disabled = true,
--           children = {
--             {
--               title = 'Yes',
--               icon = 'check',
--             },
--           }
--         }
--       }
--     }
--   }
--   exports['np-ui']:showContextMenu(context)
-- end)
