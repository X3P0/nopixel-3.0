tbsListening = false

local keyToCode = {
  ['1'] = 157,
  ['2'] = 158,
  ['3'] = 160,
  ['4'] = 164
}

local prevSkillCheck

function taskBarSkillCheck(difficulty, skillGapSent, cb, reverse, usePrev)
  TriggerEvent("menu:menuexit")

  if tbsListening then
    cb(0)
    return 0
  end

  local duration = difficulty * (math.min(exports["np-buffs"]:getAlertLevelMultiplier(), 1.33))

  local skillTick = usePrev and prevSkillCheck or 0
  local speed = (100.0 / duration)
  local key = tostring(math.random(1,4))
  local moveCursor = true
  local cursorRot = 0

  local originX, originY = 0.5, 0.585
  local screenX, screenY = GetActiveScreenResolution()
  -- local widthScale = math.max(1920, screenX) / 1920
  -- local heightScale = math.max(1080, screenY) / 1080

  local spriteW = 128.0 / 1920.0
  local spriteH = 128.0 / 1080.0

  local bgColor = { r = 37, g = 50, b = 56 }
  local hudColor = { r = 0, g = 150, b = 136 }
  local cursorColor = { r = 220, g = 0, b = 0 }

  local function skillToSprite(skill)
    if skill <= 5 then
      return "skill_5", 7
    end
    if skill <= 7 then
      return "skill_7", 10
    end
    if skill <= 10 then
      return "skill_10", 13
    end
    if skill <= 12 then
      return "skill_12", 15
    end
    if skill <= 15 then
      return "skill_15", 18
    end
    if skill <= 17 then
      return "skill_17", 20
    end
    if skill <= 20 then
      return "skill_20", 25
    end
    if skill > 20 then
      return "skill_25", 30
    end
    if skill >= 30 then
      return "skill_30", 40
    end
  end

  local targetRotation = math.random(120,240) + 0.0
  local _,spriteGap = skillToSprite(skillGapSent)
  local targetBuffer = 6.0
  local targetGap = ((360 / 128) * math.floor((spriteGap / 128) * 100)) + targetRotation + targetBuffer
  local skillHandicapForPepegaStreamers = 2

  local didPass = targetRotation + targetBuffer <= (skillTick < 0 and 360 - skillTick or skillTick)

  local function drawKey(key)
    SetTextColour(255, 255, 255, 255)
    SetTextScale(0.0, 1.25)
    SetTextDropshadow(10, 0, 0, 0, 255)
    SetTextOutline()
    SetTextFont(4)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentSubstringPlayerName(key)
    EndTextCommandDisplayText(originX, originY)
  end

  RequestStreamedTextureDict('np_sprites', true)
  local timeout = GetGameTimer() + 10000
  while not HasStreamedTextureDictLoaded('np_sprites') do
    if GetGameTimer() > timeout then
      cb(100)
      return 100
    end
    Wait(0)
  end

  local timer = GetGameTimer()
  tbsListening = true
  local minigameResult = 0
  exports['np-actionbar']:disableActionBar(true)
  while tbsListening do
    local delta = GetGameTimer() - timer
    timer = GetGameTimer()

    for i=8,32 do
      DisableControlAction(0, i, true)
    end
    for i=140,143 do
      DisableControlAction(0, i, true)
    end

    skillTick = moveCursor and skillTick + (delta * speed * (reverse and -1 or 1)) or skillTick
    cursorRot = skillTick / 100 * 360

    SetScriptGfxDrawOrder(7)
    drawKey(key)
    -- background
    DrawSprite("np_sprites", "circle_128", originX, originY + (spriteH / 3), spriteW, spriteH, 0, bgColor.r, bgColor.g, bgColor.b, 255)

    SetScriptGfxDrawOrder(9)
    -- draw target with skill gap width
    DrawSprite("np_sprites", skillToSprite(skillGapSent), originX, originY + (spriteH / 3.0), spriteW, spriteH, targetRotation, hudColor.r, hudColor.g, hudColor.b, 255)

    SetScriptGfxDrawOrder(8)
    -- cursor
    DrawSprite("np_sprites", "cursor_128", originX, originY + (spriteH / 3), spriteW, spriteH, cursorRot, cursorColor.r, cursorColor.g, cursorColor.b, 255)

    SetScriptGfxDrawOrder(1)

    for num,code in pairs(keyToCode) do
      if moveCursor and IsDisabledControlJustPressed(0, code) then
        local cursorPos = (cursorRot < 0 and 360 + cursorRot or cursorRot)
        if num == key and cursorPos >= (targetRotation + targetBuffer) and cursorPos <= (targetGap + skillHandicapForPepegaStreamers) then
          minigameResult = 100
          hudColor = { r = 0, g = 255, b = 0 }
        else
          minigameResult = 0
          hudColor = { r = 255, g = 0, b = 0 }
        end
        moveCursor = false
        SetTimeout(250, function()
          tbsListening = false
        end)
      end
    end

    if IsDisabledControlJustPressed(0, 200) then
      tbsListening = false
      minigameResult = 0
    end

    if (not reverse and skillTick >= 100 and not didPass) or (reverse and skillTick <= -100 and not didPass) then
      minigameResult = 0
      tbsListening = false
    end

    if skillTick > 100 or skillTick < -100 then
      didPass = false
      skillTick = 0
    end

    if IsPedRagdoll(GetPed()) then
      tbsListening = false
      minigameResult = 0
    end

    Wait(0)
  end
  prevSkillCheck = usePrev and skillTick or nil
  SetTimeout(500, function()
    if not tbsListening then
      exports['np-actionbar']:disableActionBar(false)
      SetStreamedTextureDictAsNoLongerNeeded('np_sprites')
    end
  end)

  if cb then
    cb(minigameResult)
  end

  return minigameResult
end

-- Citizen.CreateThread(function()
--   while true do
--     Wait(0)
--     if IsControlJustPressed(0, 38) then
--       if not tbsListening then
--         for i=1,10 do
--           local result = taskBarSkillCheck(math.random(3000, 4000), math.random(5, 25), function(result) return end, false, false)
--           print('succeeded?', result == 100)
--         end
--       end
--     end
--   end
-- end)
exports("taskBarSkill", taskBarSkillCheck)
exports("clearSkillCheck", function()
  prevSkillCheck = nil
end)
