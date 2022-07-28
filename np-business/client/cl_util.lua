local function rgb(r, g, b)
  return { r = r, g = g, b = b, alpha = 255 }
end
local colors = {
  ['red'] = rgb(255, 0, 0),
  ['yellow'] = rgb(255, 255, 0),
  ['green'] = rgb(0, 255, 0),
  ['blue'] = rgb(0, 0, 255),
  ['white'] = rgb(255, 255, 255),
  ['purple'] = rgb(138, 43, 226),
  ['black'] = rgb(0, 0, 0),
}

function DrawText3D(x, y, z, distance, text, c, background, font, drawCaret, opacity)
  if not text then
    return
  end

  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  if not onScreen then
    return
  end

  local scale = math.max(map_range(distance, 0, 10.0, 0.5, 0.1), 0.1)
  local width = text.width * scale

  SetDrawOrigin(x, y, z, 0)
  local color = colors[c] or colors.white
  SetTextColour(color.r, color.g, color.b, math.ceil(color.alpha * opacity))
  SetTextScale(0.0, scale)
  -- SetTextDropshadow(1, 0, 0, 0, 255)
  SetTextFont(font and font or 4)
  SetTextCentre(true)
  SetTextEntry('LONGSTRING')
  AddTextComponentSubstringPlayerName(text.string1)
  AddTextComponentSubstringPlayerName(text.string2)
  AddTextComponentSubstringPlayerName(text.string3)
  EndTextCommandDisplayText(0, 0)

  if background then
    local charHeight = GetRenderedCharacterHeight(scale, font and font or 4)
    local totalHeight = (charHeight + (scale / 50)) * text.lineCount
    DrawRect(0, totalHeight / 2, width, totalHeight, background.r, background.g, background.b, math.ceil(background.alpha * opacity))
    if drawCaret then
      local spritesize = 0.04 * scale
      DrawSpriteUv('commonmenu', 'card_suit_hearts', 0, totalHeight + (spritesize / 2), spritesize, spritesize, 0, 0.5, 1.0, 1.0, 0, background.r, background.g,
                   background.b, math.ceil(background.alpha * opacity))
    end
  end

  ClearDrawOrigin()
end

function map_range(s, a1, a2, b1, b2)
  return b1 + (s - a1) * (b2 - b1) / (a2 - a1)
end

function GetTextWidth(s1)
  SetTextScale(0.0, 1.0)
  SetTextFont(4)
  SetTextCentre(true)
  local swidth = 0
  for c in s1:gmatch '.' do
    BeginTextCommandGetWidth('STRING')
    AddTextComponentSubstringPlayerName(c)
    local cwidth = EndTextCommandGetWidth(false)
    swidth = swidth + cwidth
  end
  return swidth
end

function CreateBlip(pText, pCoords, pSprite, pColor, pShort)
  local blip = AddBlipForCoord(pCoords.x, pCoords.y, pCoords.z)

  SetBlipScale(blip, 0.7)

  if pSprite then
      SetBlipSprite(blip, pSprite)
  end

  if pColor then
      SetBlipColour(blip, pColor)
  end

  if pShort then
      SetBlipAsShortRange(blip, pShort)
  end

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(pText)
  EndTextCommandSetBlipName(blip)

  return blip
end
