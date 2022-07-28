function generateMetaData(data)
  local meta = {}

  if data.type == '3d' then
    local plyPed = PlayerPedId()
    local interiorData = {}
    local interior = GetInteriorFromEntity(plyPed)
    if interior ~= 0 then
      local x,y,z = GetInteriorPosition(interior)
      interiorData.roomHash = GetRoomKeyFromEntity(plyPed)
      interiorData.position = vector3(x,y,z)
      meta[#meta+1] = { label = "Interior", json = json.encode(interiorData)}
    end
  end

  -- if data.type == 'scuff' then

  -- end

  -- if data.type == 'lost' then

  -- end

  -- if data.type == 'exploit' then

  -- end

  -- location
  meta[#meta + 1] = { label = "Location", json = json.encode(GetEntityCoords(PlayerPedId())) }

  local house = exports['np-housing'].getCurrentLocation()
  if house then
    meta[#meta + 1] = { label = "House", json = json.encode(house) }
  end

  --Time
  meta[#meta + 1] = { label = "Client Timestamp", json = json.encode(GetCloudTimeAsInt()) }

  return meta
end

RegisterUICallback("np-ui:bugAction", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
  data.meta = generateMetaData(data)
  TriggerServerEvent("np-ui:bugApiRequest", data)
end)

local crashReportTimeout = 0
RegisterUICallback("np-ui:crashAction", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
  if crashReportTimeout ~= 0 and crashReportTimeout + (60000 * 5) > GetGameTimer() then return end
  crashReportTimeout = GetGameTimer()
  data.meta = generateMetaData(data)
  -- disable until needed
  -- TriggerServerEvent("np-ui:crashReportRequest", data)
end)
