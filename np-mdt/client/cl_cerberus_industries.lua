Citizen.CreateThread(function()
  exports["np-polytarget"]:AddBoxZone("cerb_indsutries_craft", vector3(221.0, -986.58, -99.0), 1.6, 1, {
    heading=0,
    minZ=-99.4,
    maxZ=-98.6,
  })
  exports["np-polytarget"]:AddBoxZone("cerb_indsutries_craft_arena", vector3(5520.87, 5985.68, 590.0), 1, 1, {
    heading=0,
    minZ=589.8,
    maxZ=590.6,
  })

  exports["np-interact"]:AddPeekEntryByPolyTarget("cerb_indsutries_craft", {{
    id = 'ci_craft_wingsuits',
    label = 'Wingsuits',
    icon = 'circle',
    event = "np-cerb-industries:craftStuff",
    parameters =  { id = "420ci_wingsuits" },
  }}, { distance = { radius = 1.5 } })

  exports["np-interact"]:AddPeekEntryByPolyTarget("cerb_indsutries_craft", {{
    id = 'ci_craft_ramps',
    label = 'Ramps',
    icon = 'circle',
    event = "np-cerb-industries:craftStuff",
    parameters =  { id = "420ci_ramps" },
  }}, { distance = { radius = 1.5 } })

  exports["np-interact"]:AddPeekEntryByPolyTarget("cerb_indsutries_craft", {{
    id = 'ci_craft_misc',
    label = 'Misc',
    icon = 'circle',
    event = "np-cerb-industries:craftStuff",
    parameters =  { id = "420ci_misc", type = "Shop" },
  }}, { distance = { radius = 1.5 } })

  exports["np-interact"]:AddPeekEntryByPolyTarget("cerb_indsutries_craft_arena", {{
    id = 'ci_craft_misc',
    label = 'Misc',
    icon = 'circle',
    event = "np-cerb-industries:craftStuff",
    parameters =  { id = "420ci_misc", type = "Shop" },
  }}, { distance = { radius = 1.5 } })
end)

AddEventHandler("np-cerb-industries:craftStuff", function(p1, p2, p3)
  if not p1 then return end
  if not p1.id then return end
  local characterId = exports["isPed"]:isPed("cid")
  local jobAccess = RPC.execute("IsEmployedAtBusiness", { character = { id = characterId }, business = { id = "cerberus_industries"} })
  if not jobAccess then
    TriggerEvent("DoLongHudText", "You cannot use that", 2)
    return
  end
  TriggerEvent("server-inventory-open", p1.id, p1.type and p1.type or "Craft")
end)

--

local iplStates = {}
local interiorCoords = {
  { -137.66,-610.05,40.43 },
}

local function updateIpls()
  local intIds = {}
  for k, v in pairs(iplStates) do
    local coords = interiorCoords[v.coordIndex]
    local interiorId = v.interiorId or GetInteriorAtCoords(coords[1], coords[2], coords[3])
    intIds[interiorId] = true
    if v.state then
      ActivateInteriorEntitySet(interiorId, k)
    else
      DeactivateInteriorEntitySet(interiorId, k)
    end
  end
  for interiorId, v in pairs(intIds) do
    RefreshInterior(interiorId)
  end
end

RegisterNetEvent("np-cbc:iplStatesUpdate", function(pStates)
  iplStates = pStates
  updateIpls()
end)

Citizen.CreateThread(function()
  TriggerServerEvent("np-cbc:getIplsStates")
end)
