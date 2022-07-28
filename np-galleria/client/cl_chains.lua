local hasCgChainOn = false
local equippingChain = false
local chainModels = {
    ["cgchain"] = "cg_chain",
    ["gsfchain"] = "gsf_chain",
    ["cerberuschain"] = "cerberus_chain",
    ["mdmchain"] = "mdm_chain",
    ["vagoschain"] = "esv_chain",
    ["koilchain"] = "koil_chain",
    ["nbcchain"] = "nbc_chain",
    ["seasidechain"] = "seaside_chain",
}
local storedpItem = false
local storedpInfo = false

AddEventHandler("np-inventory:itemUsed", function(pItem, pInfo)
  storedpItem = pItem
  storedpInfo = pInfo
  local model = chainModels[pItem]
  if not model then return end
  if equippingChain then return end
  local info = json.decode(pInfo)
  equippingChain = true
  TriggerEvent("animation:PlayAnimation", "veston")
  Wait(2600)
  if not hasCgChainOn then
    hasCgChainOn = true
    -- SetPedComponentVariation(PlayerPedId(), 7, chainValue, 0, 0)
    TriggerEvent("np-props:attachProp", model, 10706, -0.02, 0.02, -0.06, -366.0, 19.0, -163.0, true, true)
    Citizen.CreateThread(function()
      while hasCgChainOn do
        Citizen.Wait(math.random(10000, 120000))
        if info.diamond then
          local gemInfo = exports['np-galleria']:getGemData(info.diamond)
          TriggerServerEvent("np-fx:chain:blingDiamonds", GetEntityCoords(PlayerPedId()), "diamonds", gemInfo.count, 100)
        end
        Citizen.Wait(math.random(10000, 60000))
      end
    end)
    Citizen.CreateThread(function()
      while hasCgChainOn do
        Citizen.Wait(math.random(10000, 120000))
        if info.ruby then
          local gemInfo = exports['np-galleria']:getGemData(info.ruby)
          TriggerServerEvent("np-fx:chain:blingDiamonds", GetEntityCoords(PlayerPedId()), "ruby", gemInfo.count, 100)
        end
      end
    end)
    Citizen.CreateThread(function()
      while hasCgChainOn do
        Citizen.Wait(math.random(10000, 120000))
        if info.tanzanite then
          local gemInfo = exports['np-galleria']:getGemData(info.tanzanite)
          TriggerServerEvent("np-fx:chain:blingDiamonds", GetEntityCoords(PlayerPedId()), "tanzanite", gemInfo.count, 100, 0.25)
        end
      end
    end)
  else
    hasCgChainOn = false
    -- SetPedComponentVariation(PlayerPedId(), 7, -1, 0, 0)
    TriggerEvent("np-props:removeProp")
  end
  equippingChain = false
end)

local hasSquidMaskOn = false
local equippingMask = false
local maskModels = {
  ["squidmask"] = { model = "np_squid_vip", x = 0.017, y =  0.015, z = -0.005 },
  ["varhelmet"] = { model = "np_vr_headset", x = 0.11, y = 0.04, z = 0.0 },
}

local hadattachitem = false

RegisterNetEvent('attachedItems:block')
AddEventHandler('attachedItems:block', function(status)
    if (hasCgChainOn or hasSquidMaskOn) and status then
        hadattachitem = true
        hasCgChainOn = false
        hasSquidMaskOn = false
        -- its possible to stack both chain and hat on, so this is triggered twice.. might be worth rewriting this pile of shit prop system so it can handle multiple items on/off seperately too
        TriggerEvent("np-props:removeProp")
        TriggerEvent("np-props:removeProp")
    elseif (hadattachitem) and not status then
        hadattachitem = false
        TriggerEvent("np-inventory:itemUsed",storedpItem, storedpInfo)
    end
end)



AddEventHandler("np-inventory:itemUsed", function(pItem, pInfo)
  storedpItem = pItem
  storedpInfo = pInfo
  local model = maskModels[pItem]
  if not model then return end
  if equippingMask then return end
  local info = json.decode(pInfo)
  equippingMask = true
  TriggerEvent("animation:PlayAnimation", "veston")
  Wait(2600)
  if not hasSquidMaskOn then
    hasSquidMaskOn = true
    -- SetPedComponentVariation(PlayerPedId(), 7, chainValue, 0, 0)
    TriggerEvent("np-props:attachProp", model.model, 31086, model.x, model.y, model.z, -13.0, -86.0, -165.0, true, true)
  else
    hasSquidMaskOn = false
    TriggerEvent("np-props:removeProp")
  end
  equippingMask = false
end)

RegisterNetEvent("np-inventory:itemCheck", function(item)
  local model = chainModels[item]
  if not model then return end
  local qty = exports["np-inventory"]:hasEnoughOfItem(item, 1)
  if qty then return end
  hasCgChainOn = false
  TriggerEvent("np-props:removeProp")
end)
local function hasChainAccess()
  local hasAccess = exports['np-business']:HasPermission('jeweled_dragon', 'craft_access')
  if not hasAccess then
    TriggerEvent("DoLongHudText", "They do not recognize you", 2)
    return false
  end
  return true
end
AddEventHandler("np-clothing:openCGChainCrafting", function()
  if not hasChainAccess() then return end
  TriggerEvent("server-inventory-open", "42087", "Craft")
end)
AddEventHandler("np-clothing:infuseChainWithGems", function()
  if not hasChainAccess() then return end
  local cid = exports["isPed"]:isPed("cid")
  NPX.Procedures.execute("np-gallery:infuseCGChain", cid)
end)

-- Citizen.CreateThread(function()
--   TriggerEvent("np-props:attachProp", "np_squid_vip", 31086, 0.03, 0.03, 0.0, -13.0, -86.0, -165.0, true, true)
-- end)
