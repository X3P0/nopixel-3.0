
-- Scrunchie Related Stuff
local hairTied = false
local currentHairStyle = nil
local supportedModels = {
  [`mp_f_freemode_01`] = 4,
  [`mp_m_freemode_01`] = 2,
}

-- Soap Related Stuff
local itemCooldownExpiresAt = 0
local soapCooldown = 600000 -- 10 Minute Cooldown

AddEventHandler("np-inventory:itemUsed", function(item)
  if item == "bobmulet_scrunchie" then 
    return UseBobMuletScrunchie() 
  end

  if item == "bobmulet_hairspray" then 
    return UseBobMuletHairSpray() 
  end

  if item == "bobmulet_soap" then 
    return UseBobMuletSoap() 
  end

  return
end)

function UseBobMuletScrunchie()
  local hairValue = supportedModels[GetEntityModel(PlayerPedId())]
  if hairValue == nil then return end
  TriggerEvent("animation:PlayAnimation", "hairtie")
  Wait(1000)
  if not hairTied then
    hairTied = true
    local draw = GetPedDrawableVariation(PlayerPedId(), 2)
    local text = GetPedTextureVariation(PlayerPedId(), 2)
    local pal = GetPedPaletteVariation(PlayerPedId(), 2)
    currentHairStyle = { draw, text, pal }
    SetPedComponentVariation(PlayerPedId(), 2, hairValue, text, pal)
  else
    hairTied = false
    SetPedComponentVariation(PlayerPedId(), 2, currentHairStyle[1], currentHairStyle[2], currentHairStyle[3])
  end
end

function UseBobMuletHairSpray()
  local hairValue = supportedModels[GetEntityModel(PlayerPedId())]
  if hairValue == nil then return end

  hairColors = {}
  for i = 0, GetNumHairColors()-1 do
    local outR, outG, outB= GetPedHairRgbColor(i)
    hairColors[i] = {outR, outG, outB}
  end

  local randomHair = hairColors[math.random(1, #hairColors)]

  TriggerEvent("animation:PlayAnimation", "hairtie")
  Wait(1000)
  SetPedHairColor(PlayerPedId(), randomHair[1], randomHair[2])
  TriggerEvent("inventory:DegenLastUsedItem", 10)
end

function UseBobMuletSoap()
  if GetGameTimer() < itemCooldownExpiresAt then
    TriggerEvent("DoLongHudText", "You need to wait before you can do that!", 2)
    return
  end

  TriggerEvent("animation:PlayAnimation", "shakeoff")
  Wait(100)

  local finished = exports["np-taskbar"]:taskBar(4000, "Using Soap")
  if finished ~= 100 then
    ClearPedTasks(PlayerPedId())
    TriggerEvent("DoLongHudText", "Cleaning Cancelled", 2)
    return
  end

  itemCooldownExpiresAt = GetGameTimer() + soapCooldown
  TriggerEvent("Evidence:StateSet", 28, 0) -- Update "Bloody Hands"
  TriggerEvent("Evidence:StateSet", 1, 0) -- Update "Red Hands"
  TriggerEvent("inventory:removeItem", "bobmulet_soap", 1)
end
