local buffItems = {
  ["blue_rare_steak"] = true,
  ["rare_steak"] = true,
  ["medium_rare_steak"] = true,
  ["medium_steak"] = true,
  ["medium_well_steak"] = true,
  ["well_done_steak"] = true
}

local cookingPeekEntries = {
  {
    event = "np-business:cleanManor:cookSteak",
    id = "cleanmanor_cook_steak_blue_rare",
    icon = "fire",
    label = "Cook Steak (Blue Rare)",
    parameters = {
      doneness = "blue_rare_steak",
      cookTime = 20000
    }
  },
  {
    event = "np-business:cleanManor:cookSteak",
    id = "cleanmanor_cook_steak_rare",
    icon = "fire",
    label = "Cook Steak (Rare)",
    parameters = {
      doneness = "rare_steak",
      cookTime = 40000
    }
  },
  {
    event = "np-business:cleanManor:cookSteak",
    id = "cleanmanor_cook_steak_medium_rare",
    icon = "fire",
    label = "Cook Steak (Medium Rare)",
    parameters = {
      doneness = "medium_rare_steak",
      cookTime = 60000
    }
  },
  {
    event = "np-business:cleanManor:cookSteak",
    id = "cleanmanor_cook_steak_medium",
    icon = "fire",
    label = "Cook Steak (Medium)",
    parameters = {
      doneness = "medium_steak",
      cookTime = 80000
    }
  },
  {
    event = "np-business:cleanManor:cookSteak",
    id = "cleanmanor_cook_steak_medium_well",
    icon = "fire",
    label = "Cook Steak (Medium Well)",
    parameters = {
      doneness = "medium_well_steak",
      cookTime = 120000
    }
  },
  {
    event = "np-business:cleanManor:cookSteak",
    id = "cleanmanor_cook_steak_well_done",
    icon = "fire",
    label = "Cook Steak (Well done)",
    parameters = {
      doneness = "well_done_steak",
      cookTime = 160000
    }
  }
}

function getKeys(tbl)
  local keyset = {}
  local n = 0
  for k,v in pairs(tbl) do
    n = n + 1
    keyset[n] = k
  end
  return keyset
end

-- prop models and the offsets of the steak prop
local cookingPeekModels = {
  [`prop_bbq_1`] = vector3(0.0, 0.0, 0.95),
  [`prop_bbq_2`] = vector3(0.0, 0.0, 0.2),
  [`prop_bbq_3`] = vector3(0.0, 0.0, 0.6),
  [`prop_bbq_4`] = vector3(0.0, 0.0, 0.6),
  [`prop_bbq_5`] = vector3(0.0, 0.0, 0.95),
}

CreateThread(function()

  exports["np-polytarget"]:AddBoxZone(
    "cleanmanor_prepare_steak",
    vector3(-1789.28, 422.62, 128.25), 0.6, 0.8,
    {
      minZ = 127.7,
      maxZ = 128.9
    }
  )

  exports["np-interact"]:AddPeekEntryByPolyTarget(
    "cleanmanor_prepare_steak",
    {{
      event = "np-business:cleanManor:prepareSteak",
      id = "cleanmanor_prepare_steak",
      icon = "utensils",
      label = "Prepare steak"
    }},
    {
      distance = { radius = 2.0 }
    }
  )

  exports["np-polytarget"]:AddBoxZone(
    "cleanmanor_stove",
    vector3(-1791.35, 424.7, 128.25), 1, 1,
    {
      min = 119.65,
      maxZ = 129
    }
  )

  exports["np-interact"]:AddPeekEntryByModel(
    getKeys(cookingPeekModels),
    cookingPeekEntries,
    { distance = { radius = 3.0 } }
  )

  exports["np-interact"]:AddPeekEntryByPolyTarget(
    "cleanmanor_stove",
    cookingPeekEntries,
    { distance = { radius = 3.0 } }

  )

  -- kettle 
  
  exports["np-polytarget"]:AddBoxZone(
    "cleanmanor_make_tea",
    vector3(-1789.02, 426.41, 128.25), 0.4, 0.4,
    {
      minZ = 128.05,
      maxZ = 128.65
    }
  )
  
  exports["np-interact"]:AddPeekEntryByPolyTarget(
    "cleanmanor_make_tea",
    {{
      event = "np-business:kettle",
      id = "cleanmanor_make_tea",
      icon = "mug-hot",
      label = "Put the kettle on",
      parameters = {
        position = vector4(-1789.30, 426.35, 128.21, 270.0)
      }
    }},
    {
      distance = { radius = 2.0 }
    }
  )
 
end)

AddEventHandler("np-business:cleanManor:prepareSteak", function()
  local src = source
  local hasItem = exports["np-inventory"]:hasEnoughOfItem("beef", 1, false, true);
  
  if not hasItem then
    TriggerEvent("DoLongHudText", "You're missing Beef")
    return
  end

  TaskTurnPedToFaceCoord(PlayerPedId(), -1789.28, 422.62, 128.25, 1000)
  Wait(1000)
  TriggerEvent("attachItem", "knife")
  TriggerEvent("doAnim","cokecut")

  local finished = exports["np-taskbar"]:taskBar(30000, "Preparing Steak")

  ClearPedTasks(PlayerPedId())
  TriggerEvent("destroyProp")

  if finished ~= 100 then
    return
  end

  TriggerEvent("inventory:removeItem", "beef", 1)
  TriggerEvent("player:receiveItem", "raw_steak", 1)
end)


AddEventHandler("np-business:cleanManor:cookSteak", function(params, entity)
  local src = source
  local doneness = params.doneness or "medium_steak"
  local cookTime = params.cookTime or 180000
  local hasItem = exports["np-inventory"]:hasEnoughOfItem("raw_steak", 1, false, true);
  local model = GetEntityModel(entity)

  if not hasItem then
    TriggerEvent("DoLongHudText", "You're missing Raw Steak")
    return
  end

  TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
  Wait(1000)
  TriggerEvent("doAnim", "cokecut")

  RequestModel(`prop_cs_steak`)
  while not HasModelLoaded(`prop_cs_steak`) do
    Wait(10)
  end

  local steakOffset = cookingPeekModels[model]

  -- hardcoded position of the clean manor stove
  local steakPosition = vector3(-1791.3, 425.05, 128.26)

  -- for BBQs lets use the entity position with an offset
  if steakOffset ~= nil then
    local position = GetEntityCoords(entity, true)
    steakPosition = position + steakOffset
  end

  local steak = CreateObject(
    `prop_cs_steak`,
    steakPosition.x,
    steakPosition.y,
    steakPosition.z,
    true,
    true,
    false
  )

  local netId = NetworkGetNetworkIdFromEntity(steak)
  SetNetworkIdCanMigrate(netId, false)

  local particleId1 = math.random(1, 99999)
  local particleId2 = math.random(1, 99999)

  TriggerServerEvent("particle:StartParticleAtLocation", steakPosition.x, steakPosition.y, steakPosition.z + 0.1, "grill_fire", particleId1, 0.0, 0.0, 0.0)
  if doneness == "well_done_steak" then
    TriggerServerEvent("particle:StartParticleAtLocation", steakPosition.x, steakPosition.y, steakPosition.z, "grill_fire_intense", particleId2, 0.0, 0.0, 0.0)
  end

  local finished = exports["np-taskbar"]:taskBar(cookTime, "Cooking Steak")

  ClearPedTasks(PlayerPedId())
  TriggerServerEvent("particle:StopParticle", particleId1)
  if doneness == "well_done_steak" then
    TriggerServerEvent("particle:StopParticle", particleId2)
  end

  DeleteEntity(steak)

  if finished ~= 100 then
    return
  end

  TriggerEvent("inventory:removeItem", "raw_steak", 1)
  TriggerEvent("player:receiveItem", doneness, 1)
end)

AddEventHandler("buffs:triggerBuff", function(item)
  if not buffItems[item] then return end
  print("Triggering effect for item " .. item)
end)
