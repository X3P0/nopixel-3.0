local deviceActive = false
local selection
local isDrawingHousing = false

local DIGI_HASH = GetHashKey('WEAPON_DIGISCANNER')

local activeTools = {}

local function selectionMenu(pSelectedCoords)
  local context = { { title = 'Toolbox' } }
  for _, tool in ipairs(activeTools) do
    if tool.selection then
      context[#context + 1] = {
        title = tool.name,
        description = tool.description,
        action = #tool.children == 0 and tool.callback or nil,
        key = tool.id,
        children = tool.children,
      }
    end
  end
  exports['np-ui']:showContextMenu(context)
end

local function openToolbox()
  -- Fetch tools from server
  if not activeTools or #activeTools == 0 then
    activeTools = RPC.execute('np-business:sc:getToolbox')
    for _, tool in ipairs(activeTools) do
      tool.callback = 'np-business:sc:toolCallback:' .. tool.id
      RegisterUICallback(tool.callback, function(data, cb)
        cb({ data = {}, meta = { ok = true, message = 'done' } })
        Wait(1)
        local success = RPC.execute('np-business:sc:useTool', data.key, selection)
        if not success then
          TriggerEvent('DoLongHudText', 'There was an error using that tool.', 2)
        end
      end)
    end
  end

  local context = { { title = 'Toolbox', description = 'Select a tool to use. Disabled ones require a selection.' } }
  for _, tool in ipairs(activeTools) do
    context[#context + 1] = {
      title = tool.name,
      description = tool.description,
      action = #tool.children == 0 and tool.callback or nil,
      key = tool.id,
      children = tool.children,
      disabled = tool.selection,
    }
  end
  exports['np-ui']:showContextMenu(context)
end

AddEventHandler('np-inventory:itemUsed', function(pItemId, pInfo)
  if pItemId ~= 'surveyortool' then
    return
  end

  local player = PlayerPedId()

  deviceActive = not deviceActive

  if not deviceActive then
    isDrawingHousing = false
    RemoveWeaponFromPed(player, DIGI_HASH)
    return
  end

  GiveWeaponToPed(player, DIGI_HASH, 0, false, true)
  Wait(1000)

  local sf = RequestScaleformMovie('digiscanner')

  while not HasScaleformMovieLoaded(sf) do
    Wait(0)
  end

  if not IsNamedRendertargetRegistered('digiscnaner') then
    RegisterNamedRendertarget('digiscanner', false)
  end
  LinkNamedRendertarget(GetWeapontypeModel(DIGI_HASH));
  local renderTarget
  if IsNamedRendertargetRegistered('digiscanner') then
    renderTarget = GetNamedRendertargetRenderId('digiscanner')
  end

  local distance = 0.0
  local direction = 1
  local aiming = false

  while deviceActive do
    Wait(0)

    -- Disable taking cover (Q)
    DisableControlAction(0, 44, true)

    local num, weaponHash = GetCurrentPedWeapon(player)
    if weaponHash ~= DIGI_HASH then
      deviceActive = false
    end

    -- If INPUT_AIM is pressed
    if IsControlJustPressed(0, 25) then
      exports['np-selector']:startSelecting(-1, player, function(_entity, type, model)
        return false
      end)
      aiming = true
    end

    -- If INPUT_AIM is released, cancel selection
    if IsDisabledControlJustReleased(0, 25) and not selection then
      exports['np-selector']:stopSelecting()
      exports['np-selector']:deselect()
      aiming = false
    end

    -- If INPUT_ATTACK is released confirm selection
    if aiming and IsDisabledControlJustPressed(0, 24) then
      selection = exports['np-selector']:stopSelecting()
      if selection and selection.selectedCoords then
        selection.selectedCoords[3] = selection.selectedCoords[3] + 1.0
        selection.selectedCoords[4] = GetEntityHeading(player)
        selectionMenu(selection.selectedCoords)
      else
        selection = nil
        exports['np-selector']:deselect()
      end
    end

    -- If Q is pressed, open toggle menu
    if IsDisabledControlJustPressed(0, 44) then
      openToolbox()
    end

    -- Digiscanner drawing
    local r, g, b = 0, 0, 255
    BeginScaleformMovieMethod(sf, 'SET_COLOUR')
    ScaleformMovieMethodAddParamInt(r)
    ScaleformMovieMethodAddParamInt(g)
    ScaleformMovieMethodAddParamInt(b)
    ScaleformMovieMethodAddParamInt(r)
    ScaleformMovieMethodAddParamInt(g)
    ScaleformMovieMethodAddParamInt(b)
    ScaleformMovieMethodAddParamInt(r)
    ScaleformMovieMethodAddParamInt(g)
    ScaleformMovieMethodAddParamInt(b)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(sf, 'SET_DISTANCE')
    ScaleformMovieMethodAddParamFloat(distance)
    EndScaleformMovieMethod()

    distance = distance + direction

    if distance > 150.0 then
      direction = -1
    elseif distance < 1.0 then
      direction = 1
    end

    SetTextRenderId(renderTarget)
    DrawScaleformMovie(sf, 0.1, 0.24, 0.21, 0.51, 100, 100, 100, 255, 0)
    SetTextRenderId(GetDefaultScriptRendertargetRenderId())
  end
  isDrawingHousing = false
end)

AddEventHandler('np-ui:application-closed', function(pName, pData)
  if pName == 'contextmenu' and selection then
    selection = nil
    exports['np-selector']:deselect()
    ClearPedTasks(PlayerPedId())
  end
end)

RegisterNetEvent('np-business:sc:openTextbox', function(pId, pData)
  local textBoxOpen = true
  SetTimeout(120000, function()
    if textBoxOpen then
      exports['np-ui']:closeApplication('textbox')
      exports['np-selector']:deselect()
      TriggerEvent('DoLongHudText', 'Timed out!', 2)
    end
  end)
  local response = exports['np-ui']:OpenInputMenu(pData)
  exports['np-ui']:closeApplication('textbox')
  exports['np-selector']:deselect()
  textBoxOpen = false
  TriggerServerEvent('np-business:sc:textboxResponse', pId, response)
end)

RegisterNetEvent('np-business:sc:openTextpopup', function(pData)
  exports['np-ui']:openApplication('textpopup', pData)
end)

RegisterNetEvent('np-business:sc:drawHousing', function()
  isDrawingHousing = not isDrawingHousing
  if not isDrawingHousing then
    return
  end
  local player = PlayerPedId()

  local drawnHouses = {}
  local houses = exports['np-housing']:retrieveHousingTableMapped()
  local zones = exports['np-housing']:retrieveHousingZonesConfig()

  for _, house in ipairs(houses) do
    -- calculate line count
    local modelName = 'Unk'
    for _, buildText in ipairs(BUILDING_TO_TEXT) do
      if buildText.model == house.model then
        modelName = buildText.name
        break
      end
    end

    local zoneName = GetNameOfZone(vector3(house.coords.x,house.coords.y,house.coords.z))
    local hasZone = true
    if zones[zoneName] == nil then hasZone = false end

    local zonePercent = 'Unk'
    if zoneName ~= 'Unk' and zones[zoneName] and zones[zoneName][house.model] then 
      zonePercent = zones[zoneName][house.model] 
    end

    local sZone = '`'..zoneName..'` [x] ['..zonePercent..']'
    if hasZone then
      sZone = '`'..zoneName..'` ['..zonePercent..']'
    end

    local sText = ('[%s] %s     ~r~%s   ~g~%s'):format(house.id, house.street, modelName, sZone)

    local lineCount = 0
    local s1 = string.sub(sText, 0, 99)
    local s2 = string.sub(sText, 100, 199)
    local s3 = string.sub(sText, 200, 255)
    local s4 = string.sub(sText, 256, 300)
    -- Get inital line count from length of string
    if s1:len() > 0 then
      lineCount = lineCount + 1
    end
    if s2:len() > 0 then
      lineCount = lineCount + 1
    end
    if s3:len() > 0 then
      lineCount = lineCount + 1
    end
    if s4:len() > 0 then
      lineCount = lineCount + 1
    end

    -- calculate width
    local swidth = GetTextWidth(s1)

    house.text = { text = sText, string1 = s1, string2 = s2, string3 = s3, lineCount = lineCount, width = swidth }
  end

  Citizen.CreateThread(function()
    while isDrawingHousing do
      Wait(500)
      local pedCoords = GetEntityCoords(player)
      drawnHouses = {}
      for _, house in ipairs(houses) do
        local vec = vector3(house.coords.x, house.coords.y, house.coords.z)
        local dist = #(pedCoords - vec)
        if #drawnHouses >= 15 then
          for idx, dHouse in ipairs(drawnHouses) do
            if dHouse.dist > dist then
              table.remove(drawnHouses, idx)
              drawnHouses[#drawnHouses + 1] = { dist = dist, data = house }
              break
            end
          end
        elseif dist < 150.0 then
          drawnHouses[#drawnHouses + 1] = { dist = dist, data = house }
        end
      end
    end
  end)

  Citizen.CreateThread(function()
    while isDrawingHousing do
      Wait(0)
      for _, house in ipairs(drawnHouses) do
        DrawText3D(house.data.coords.x, house.data.coords.y, house.data.coords.z, house.dist / 10.0, house.data.text, 'black',
                   { r = 255, g = 255, b = 255, alpha = 255 }, 4, true, 1.0)
      end
    end
  end)
end)

local streetModeData = {}
local streetModeEnabled = false
RegisterNetEvent('np-business:sc:openStreetMode', function()
  if streetModeEnabled then
    local success = RPC.execute('np-business:sc:addStreetHouses', streetModeData)
    if not success then
      TriggerEvent('DoLongHudText', 'There was an error submitting values')
    end
    streetModeEnabled = false
    return
  end
  local houseOptions = {}
  for idx, data in ipairs(BUILDING_TO_TEXT) do
    houseOptions[#houseOptions + 1] = { id = idx, name = data.name }
  end
  local items = {
    { icon = 'pencil-alt', label = 'Street Name', name = 'street' },
    { _type = 'select', label = 'Building Type', name = 'type', options = houseOptions },
    { icon = 'sort-numeric-up-alt', label = 'Inital House # (optional)', name = 'housenum' },
  }
  local response = exports['np-ui']:OpenInputMenu(items)
  if not response then
    return
  end
  local street = response.street
  local build = BUILDING_TO_TEXT[response.type]
  local houseNum = tonumber(response.housenum) or 1
  if not street or not build then
    return
  end

  streetModeEnabled = true
  selection = nil
  local selecting = true
  local player = PlayerPedId()
  exports['np-selector']:startSelecting(-1, player, function(_entity, type, model)
    return false
  end)
  streetModeData = {}
  while streetModeEnabled do
    Wait(0)

    -- Disable INPUT_AIM
    DisableControlAction(0, 25, true)

    if not selecting then
      exports['np-selector']:startSelecting(-1, player, function(_entity, type, model)
        return false
      end)
      selecting = true
    end

    if IsDisabledControlJustPressed(0, 24) then
      local streetSelection = exports['np-selector']:stopSelecting()
      if streetSelection and streetSelection.selectedCoords then
        streetSelection.selectedCoords[3] = streetSelection.selectedCoords[3] + 1.0
        streetSelection.selectedCoords[4] = GetEntityHeading(player)
        streetModeData[#streetModeData + 1] = {
          street = street .. ' ' .. houseNum,
          coords = streetSelection.selectedCoords,
          model = build.model,
        }
        houseNum = houseNum + 1
      end
      exports['np-selector']:deselect()
      selecting = false
    end

    if IsDisabledControlJustPressed(0, 25) then
      -- Remove Last entry
      streetModeData[#streetModeData] = nil
      houseNum = houseNum - 1
      if houseNum < 1 then
        houseNum = 1
      end
    end

    local plyCoords = GetEntityCoords(player)
    for _, house in ipairs(streetModeData) do
      if not house.text then
        local txt = ('%s    ~r~%s'):format(house.street, build.name)
        local swidth = GetTextWidth(txt)
        house.text = {
          text = txt,
          string1 = txt,
          string2 = '',
          string3 = '',
          lineCount = 1,
          width = swidth,
        }
      end
      local distance = #(plyCoords - vector3(house.coords[1], house.coords[2], house.coords[3]))
      DrawText3D(house.coords[1], house.coords[2], house.coords[3], distance, house.text, 'black', { r = 255, g = 255, b = 255, alpha = 200 }, 4,
                 true, 1.0)
    end
  end
  exports['np-selector']:deselect()
end)
