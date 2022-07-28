local pi, sin, cos, abs = math.pi, math.sin, math.cos, math.abs
local function RotationToDirection(rotation)
  local piDivBy180 = pi / 180
  local adjustedRotation = vector3(
    piDivBy180 * rotation.x,
    piDivBy180 * rotation.y,
    piDivBy180 * rotation.z
  )
  local direction = vector3(
    -sin(adjustedRotation.z) * abs(cos(adjustedRotation.x)),
    cos(adjustedRotation.z) * abs(cos(adjustedRotation.x)),
    sin(adjustedRotation.x)
  )
  return direction
end

local function rgb(r, g, b)
  return { r = r, g = g, b = b, alpha = 255 }
end
local colors = {
  ["red"] = rgb(255, 0, 0),
  ["yellow"] = rgb(255, 255, 0),
  ["green"] = rgb(0, 255, 0),
  ["blue"] = rgb(0, 0, 255),
  ["white"] = rgb(255, 255, 255),
  ["purple"] = rgb(138, 43, 226),
  ["black"] = rgb(0, 0, 0),
}

Citizen.CreateThread(function()
  AddTextEntry("LONGSTRING", "~a~\n~a~\n~a~")
end)

function DrawText3D(x, y, z, distance, text, c, background, font, drawCaret, opacity)
  if not text then
    return
  end

  local onScreen,_x,_y = World3dToScreen2d(x,y,z)
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
  SetTextEntry("LONGSTRING")
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
      DrawSpriteUv('commonmenu', 'card_suit_hearts', 0, totalHeight + (spritesize / 2), spritesize, spritesize, 0, 0.5, 1.0, 1.0, 0, background.r, background.g, background.b, math.ceil(background.alpha * opacity))
    end
  end

  ClearDrawOrigin()
end

function RayCastGamePlayCamera(distance)
  local cameraRotation = GetGameplayCamRot()
  local cameraCoord = GetGameplayCamCoord()
  --local right, direction, up, pos = GetCamMatrix(GetRenderingCam())
  --local cameraCoord = pos
  local direction = RotationToDirection(cameraRotation)
  local destination = vector3(
    cameraCoord.x + direction.x * distance,
    cameraCoord.y + direction.y * distance,
    cameraCoord.z + direction.z * distance
  )
  local ray = StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z,
  destination.x, destination.y, destination.z, 17, -1, 0)
  local rayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)
  return hit, endCoords, entityHit, surfaceNormal
end

-- GetUserInput function inspired by vMenu (https://github.com/TomGrobbe/vMenu/blob/master/vMenu/CommonFunctions.cs)
function GetUserInput(windowTitle, defaultText, maxInputLength)
  blockinput = true
  -- Create the window title string.
  local resourceName = string.upper(GetCurrentResourceName())
  local textEntry = resourceName .. "_WINDOW_TITLE"
  if windowTitle == nil then
    windowTitle = "Enter:"
  end
  AddTextEntry(textEntry, windowTitle)

  -- Display the input box.
  DisplayOnscreenKeyboard(1, textEntry, "", defaultText or "", "", "", "", maxInputLength or 30)
  Wait(0)
  -- Wait for a result.
  while true do
    local keyboardStatus = UpdateOnscreenKeyboard();
    if keyboardStatus == 3 then -- not displaying input field anymore somehow
      blockinput = false
      return nil
    elseif keyboardStatus == 2 then -- cancelled
      blockinput = false
      return nil
    elseif keyboardStatus == 1 then -- finished editing
      blockinput = false
      return GetOnscreenKeyboardResult()
    else
      Wait(0)
    end
  end
end

function randomTargetSelectionInput()
  local randomTargetSelection = GetUserInput("Should the laser randomly select it's next target point? (Y/n)", "", 1)
  if randomTargetSelection == nil then return nil end
  if randomTargetSelection == "" or string.lower(randomTargetSelection) == "y" then return true end
  if string.lower(randomTargetSelection) == "n" then return false end
  return randomTargetSelection
end

function DrawSphere(pos, radius, r, g, b, a)
  DrawMarker(28, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, r, g, b, a, false, false, 2, nil, nil, false)
end

function map_range(s, a1, a2, b1, b2)
  return b1 + (s - a1) * (b2 - b1) / (a2 - a1)
end

function Split(s, delimiter)
  result = {};
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
      table.insert(result, match);
  end
  return result;
end
