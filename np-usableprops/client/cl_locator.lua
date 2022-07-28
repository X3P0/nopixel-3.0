function pingCoords(pCoords, pSize, pColor)
  local timer = GetGameTimer()
  local expanding = true
  local blipScale = 0.0

  local blip = AddBlipForCoord(pCoords)
  SetBlipSprite(blip, 10)
  SetBlipColour(blip, pColor)
  SetBlipHiddenOnLegend(blip, true)
  SetBlipHighDetail(blip, true)
  SetBlipScale(blip, blipScale)

  while expanding do
    Wait(0)
    local deltaTime = GetGameTimer() - timer
    timer = GetGameTimer()
    blipScale = blipScale + (deltaTime * 0.0025)
    SetBlipScale(blip, blipScale)
    SetBlipAlpha(blip, math.floor(map_range(blipScale, 0.0, pSize, 255, 0) + 0.5))
    if blipScale > pSize then
      expanding = false
    end
  end
  RemoveBlip(blip)
end

AddEventHandler('np-inventory:itemUsed', function(item, info, inventoryName, slot)
  if item == 'gps_tracker' then
    local meta = json.decode(info)
    local trackerID = checkForTrackerId(item, meta, slot)
    if not trackerID then
      return
    end

  end

  if item == 'gps_locator' then
    local meta = json.decode(info)
    local trackerID = checkForTrackerId(item, meta, slot)
    if not trackerID then
      return
    end

    local locations = RPC.execute('np-usableprops:getLocatorPositions', trackerID)

    for i = 1, 3 do
      PlaySound(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET', false, 0, true)
      Wait(1000)
    end

    PlaySound(-1, 'On_Call_Player_Join', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 0, true)
    local plyCoords = GetEntityCoords(PlayerPedId())
    Citizen.CreateThread(function()
        pingCoords(plyCoords, 4.0, 33)
    end)
    for _, loc in ipairs(locations) do
      local dist = #(plyCoords - loc)
      Wait(dist * 3)
      PlaySound(-1, 'On_Call_Player_Join', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 0, true)
      Citizen.CreateThread(function()
        pingCoords(loc, 2.0, 33)
      end)
    end
  end
end)

function checkForTrackerId(item, meta, slot)
  if meta.TrackingID then
    return meta.TrackingID
  end

  local prompt = exports['np-ui']:OpenInputMenu({ { label = 'Enter ID', name = 'id' } }, function(values)
    return values and values.id
  end)

  if not prompt then
    return false
  end

  local id = prompt.id
  local cid = exports['isPed']:isPed('cid')

  meta.TrackingID = id

  TriggerServerEvent('server-update-item', cid, item, slot, json.encode(meta))
  return id
end
