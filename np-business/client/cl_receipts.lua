
local businessZones = {
  ['jeweled_dragon'] = {
    coords = vector3(-706.27, -896.6, 23.67),
    length = 18.2,
    width = 17.6,
    minZ = 8.27,
    maxZ = 26.27,
    heading = 0.0
  },
  ['wuchang'] = {
    coords = vector3(-828.41, -712.58, 28.06),
    length = 37.2,
    width = 35.0,
    minZ = 18.96,
    maxZ = 53.36,
    heading = 0.0
  },
  ['tavern'] = {
    coords = vector3(1163.79, -411.03, 67.48),
    length = 32.4,
    width = 32.6,
    minZ = 63.88,
    maxZ = 76.48,
    heading = 344.0
  }
}

local clockedIn = nil

function ClockIn(pBusiness)
  local success = NPX.Procedures.execute('np-business:receipts:clockIn', pBusiness)
  if success then
    clockedIn = pBusiness
  end
end

function ClockOut(pBusiness)
  local success = NPX.Procedures.execute('np-business:receipts:clockOut', pBusiness)
  if success then
    clockedIn = nil
  end
end

Citizen.CreateThread(function()
  for business, zone in pairs(businessZones) do
    exports['np-polyzone']:AddBoxZone('business_receipts_workzones', zone.coords, zone.length, zone.width, {
      data = { id = 'business_workzone_' .. business, business = business },
      heading = zone.heading,
      minZ = zone.minZ,
      maxZ = zone.maxZ,
    })
  end

  -- Clock in/out controls

  -- Jeweled Dragon
  exports['np-polytarget']:AddBoxZone('business_receipts_clockin_jeweled_dragon', vector3(-705.04, -894.37, 23.81), 1.2, 0.6, {
    heading = 0,
    minZ = 23.56,
    maxZ = 24.16,
    data = {
      id = 'business_receipts_clockin_jeweled_dragon',
    },
  })
  exports['np-interact']:AddPeekEntryByPolyTarget('business_receipts_clockin_jeweled_dragon', {{
      event = 'np-business:receipts:clockIn',
      id = 'receiptsClockIn_jeweled_dragon',
      icon = 'clock',
      label = _L('restaurant-clock-in', 'Clock In'),
      parameters = { business = 'jeweled_dragon' },
  }}, { distance = { radius = 3.5 }, isEnabled = function() return clockedIn == nil end })

  exports['np-interact']:AddPeekEntryByPolyTarget('business_receipts_clockin_jeweled_dragon', {{
    event = 'np-business:receipts:clockOut',
    id = 'receiptsClockOut_jeweled_dragon',
    icon = 'clock',
    label = _L('restaurant-clock-in', 'Clock Out'),
    parameters = { business = 'jeweled_dragon' },
  }}, { distance = { radius = 3.5 }, isEnabled = function() return clockedIn ~= nil end })

  -- Wuchang
  exports['np-polytarget']:AddBoxZone('business_receipts_clockin_wuchang', vector3(-813.27, -702.64, 28.06), 0.6, 1.6, {
    heading = 0,
    minZ = 27.66,
    maxZ = 28.26,
    data = {
      id = 'business_receipts_clockin_wuchang',
    },
  })
  exports['np-interact']:AddPeekEntryByPolyTarget('business_receipts_clockin_wuchang', {{
      event = 'np-business:receipts:clockIn',
      id = 'receiptsClockIn_wuchang',
      icon = 'clock',
      label = _L('restaurant-clock-in', 'Clock In'),
      parameters = { business = 'wuchang' },
  }}, { distance = { radius = 3.5 }, isEnabled = function() return clockedIn == nil end })

  exports['np-interact']:AddPeekEntryByPolyTarget('business_receipts_clockin_wuchang', {{
    event = 'np-business:receipts:clockOut',
    id = 'receiptsClockOut_wuchang',
    icon = 'clock',
    label = _L('restaurant-clock-in', 'Clock Out'),
    parameters = { business = 'wuchang' },
  }}, { distance = { radius = 3.5 }, isEnabled = function() return clockedIn ~= nil end })

  -- Tavern
  exports['np-polytarget']:AddBoxZone('business_receipts_clockin_tavern', vector3(1170.89, -398.7, 67.49), 0.4, 3.0, {
    heading = 345,
    minZ = 67.49,
    maxZ = 68.69,
    data = {
      id = 'business_receipts_clockin_tavern',
    },
  })
  exports['np-interact']:AddPeekEntryByPolyTarget('business_receipts_clockin_tavern', {{
      event = 'np-business:receipts:clockIn',
      id = 'receiptsClockIn_tavern',
      icon = 'clock',
      label = _L('restaurant-clock-in', 'Clock In'),
      parameters = { business = 'tavern' },
  }}, { distance = { radius = 3.5 }, isEnabled = function() return clockedIn == nil end })

  exports['np-interact']:AddPeekEntryByPolyTarget('business_receipts_clockin_tavern', {{
    event = 'np-business:receipts:clockOut',
    id = 'receiptsClockOut_tavern',
    icon = 'clock',
    label = _L('restaurant-clock-in', 'Clock Out'),
    parameters = { business = 'tavern' },
  }}, { distance = { radius = 3.5 }, isEnabled = function() return clockedIn ~= nil end })

end)

AddEventHandler('np-polyzone:exit', function(pZone, pData)
  if pZone ~= 'business_receipts_workzones' then return end
  if not pData.business then return end
  if not clockedIn then return end

  local success = NPX.Procedures.execute('np-business:receipts:clockOut', pData.business)
  if success then
    clockedIn = nil
  end
end)

AddEventHandler('np-business:receipts:clockOut', function(pParameters, pEntity, pContext)
  ClockOut(pParameters.business)
end)

AddEventHandler('np-business:receipts:clockIn', function(pParameters, pEntity, pContext)
  ClockIn(pParameters.business)
end)
