local isDoc = false
local isPolice = false
local isMedic = false
local isJudge = false
local myJob = 'unemployed'

IsDead = false

Citizen.CreateThread(function()
  exports["np-polyzone"]:AddBoxZone("voting_zone", vector3(-560.24, -206.62, 38.22), 6.0, 1.2, { heading=120, minZ=37.17, maxZ=39.77 })
  exports["np-polyzone"]:AddBoxZone("townhall_court_detector", vector3(-534.99, -184.95, 37.74), 4.0, 3.1, { minZ=37.25, maxZ=41.4, heading=30})
  exports["np-polyzone"]:AddBoxZone("townhall_court_detector", vector3(-535.68, -185.41, 42.76), 4.0, 4.2, { minZ=41.8, maxZ=45.9, heading=30})
  exports["np-polyzone"]:AddBoxZone("townhall_court_item_return", vector3(-550.43, -192.51, 38.22), 0.8, 2.0, { minZ=37.25, maxZ=39.4, heading=33 })
  exports["np-polyzone"]:AddBoxZone("townhall_court_detector_second", vector3(-533.09, -183.46, 38.22), 21.4, 1.8, { minZ=37.25, maxZ=41.4, heading=30})
  exports["np-polyzone"]:AddBoxZone("townhall_court_lobby", vector3(-550.96, -193.94, 38.22), 22.2, 22.0, { minZ=37.17, maxZ=50.57, heading=30 })
  exports["np-polyzone"]:AddCircleZone("townhall_court_public_records", vector3(-552.96, -194.14, 38.22), 0.6, { useZ=true })
  exports["np-polyzone"]:AddCircleZone("townhall_court_property_listing", vector3(-551.88, -193.58, 38.22), 0.6, { useZ=true })
  exports["np-polytarget"]:AddBoxZone("townhall:gavel", vector3(-519.18, -175.6, 38.55), 0.2, 0.45, { heading=15, minZ=38.45, maxZ=38.6 })
  exports["np-polyzone"]:AddBoxZone("townhall:primeZone", vector3(-521.2, -177.53, 38.22), 12.8, 22.4, { minZ=37.17, maxZ=45.57, heading=300 })

  exports["np-polytarget"]:AddBoxZone("townhall:pd_actions", vector3(-552.76, -193.26, 38.22), 0.4, 1.6, { heading=30, minZ=38.02, maxZ=38.62 })

  exports['np-interact']:AddPeekEntryByPolyTarget('townhall:pd_actions', {{
        id = "np-gov:townhall:openPdActions",
        event = "np-gov:townhall:openPdActions",
        icon = "crutch",
        label = "PD Actions"
    }},
    {
      distance = { radius = 2.0 },
      isEnabled = function ()
          return isPolice or isJudge
      end
    })
end)

local listening = 0
local function listenForKeypress(listenCounter, pEvent)
    Citizen.CreateThread(function()
        while listening == listenCounter do
            if IsControlJustReleased(0, 38) then
              if pEvent == "voting_zone" then
                exports["np-ui"]:openApplication("ballot")
              elseif pEvent == "townhall_court_item_return" then
                local success = RPC.execute("MetalDetectorItems", false)
                --Update inventory after metal detector
                local cid = exports['isPed']:isPed('cid')
                TriggerServerEvent('server-request-update', cid)
              elseif pEvent == "townhall_court_public_records" then
                TriggerEvent("np-ui:openMDW", { publicApp = true })
              -- elseif pEvent == "townhall_court_property_listing" then
              --   TriggerEvent("houses:PropertyListing")
              end
              exports["np-ui"]:hideInteraction()
            end
            Wait(0)
        end
    end)
end

local function isExempt()
  return isJudge or isMedic or isDoc or isPolice
end

AddEventHandler("np-polyzone:enter", function(zone)
  if zone == 'townhall:primeZone' then
    TriggerEvent('np:voice:proximity:override', 'townhall', 3, 15.0, 3)
  elseif zone == "voting_zone" then
    exports["np-ui"]:showInteraction("[E] Vote")
    listenForKeypress(listening, zone)
  elseif (zone == "townhall_court_detector" or zone == "townhall_court_detector_second") and not isExempt() then
    if zone == "townhall_court_detector" then
      TriggerEvent("chatMessage", "SYSTEM ", 2, "Your items have been stored, you can pick them up at the front desk.", "feed", false, { i18n = { "Your items have been stored, you can pick them up at the front desk" } })
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'metaldetector', 0.05)
    end
    local allowPhone = false
    if myJob == "defender" or myJob == "district attorney" then allowPhone = true end
    local success = RPC.execute("MetalDetectorItems", true, allowPhone)
    exports["np-taskbar"]:taskbarDisableInventory(true)
    TriggerEvent("animation:carry","none")
    if IsPedArmed(PlayerPedId(), 7) then
      SetCurrentPedWeapon(PlayerPedId(), 0xA2719263, true)
      SetCurrentPedVehicleWeapon(PlayerPedId(), 0xA2719263)
    end
    --Update inventory after metal detector
    local cid = exports['isPed']:isPed('cid')
    TriggerServerEvent('server-request-update', cid)
  elseif zone == "townhall_court_item_return" then
    exports["np-ui"]:showInteraction("[E] To get your items back")
    listenForKeypress(listening, zone)
  elseif zone == "townhall_court_lobby" then
    local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if currentVehicle ~= 0 and not IsVehicleModel(currentVehicle, `npwheelchair`) then
      SetEntityAsMissionEntity(currentVehicle, true, true)
      DeleteVehicle(currentVehicle)
    end
  elseif zone == "townhall_court_public_records" then
    exports["np-ui"]:showInteraction("[E] To view public records")
    listenForKeypress(listening, zone)
  -- elseif zone == "townhall_court_property_listing" then
  --   exports["np-ui"]:showInteraction("[E] To view property listings")
  --   listenForKeypress(listening, zone)
  end
end)

AddEventHandler("np-polyzone:exit", function(zone)
  if zone == 'townhall:primeZone' then
    TriggerEvent('np:voice:proximity:override', 'townhall', 3, -1, -1)
  elseif zone == "voting_zone" or zone == "townhall_court_item_return" or zone == "townhall_court_public_records" or zone == "townhall_court_property_listing" then
    exports["np-ui"]:hideInteraction()
    listening = listening + 1
  elseif zone == "townhall_court_detector" or zone == "townhall_court_detector_second" and not isExempt() then
    exports["np-taskbar"]:taskbarDisableInventory(false)
    listening = listening + 1
  end
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    if isMedic and job ~= "ems" then isMedic = false end
    if isPolice and job ~= "police" then isPolice = false end
    if isDoc and job ~= "doc" then isDoc = false end
    if isJudge and job ~= "judge" then isJudge = false end
    if job == "police" then isPolice = true end
    if job == "ems" then isMedic = true end
    if job == "doc" then isDoc = true end
    myJob = job
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
  if not IsDead then
    IsDead = true
  else
    IsDead = false
  end
end)

RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
  isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
  isJudge = false
end)

RegisterNetEvent("np-gov:gavel")
AddEventHandler("np-gov:gavel", function(pArgs, pEntity, pContext)
  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'gavel_3hit_mixdown', 0.4)
end)

AddEventHandler("np-gov:purchaseLicenses", function()
  local context = {
    {
      i18nTitle = true,
      title = "Purchase Weapons License",
      description = "$5,000",
      action = "np-gov:purchaseLicenseHandler",
      key = {type = 2, cost = 5000}
    },
    {
      i18nTitle = true,
      title = "Purchase Hunting License",
      description = "$5,000",
      action = "np-gov:purchaseLicenseHandler",
      key = {type = 7, cost = 5000}
    },
    {
      i18nTitle = true,
      title = "Purchase Fishing License",
      description = "$5,000",
      action = "np-gov:purchaseLicenseHandler",
      key = {type = 8, cost = 5000}
    }
  }
  exports["np-ui"]:showContextMenu(context)
end)

RegisterUICallback("np-gov:purchaseLicenseHandler", function(data, cb)
  local result, message = RPC.execute("np-gov:purchaseLicense", data.key.type, data.key.cost)
  if result then TriggerEvent("DoLongHudText", "Purchased") end
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)

AddEventHandler("np-gov:purchaseBusiness", function()
  local context = {
    {
      title = "Purchase Business License",
      description = "$50,000",
      action = "np-gov:purchaseBusinessHandler",
      key = {cost = 50000}
    }
  }
  exports["np-ui"]:showContextMenu(context)
end)

RegisterUICallback("np-gov:purchaseBusinessHandler", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  Wait(1)
  local elements = {
    { name = "name", label = "Business Name", icon = "pencil-alt" },
    { name = "propsal", label = "Short Proposal", icon = "pencil-alt" },
  }

  local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
      return values.name and values.name:len() > 3
  end)
  if not prompt then return end
  local bData = {
    character = data.character,
    name = prompt.name,
    type_id = 1,
  }

  local result, message = RPC.execute("np-gov:purchaseBusiness", data.key.cost, bData)
  if result then TriggerEvent("DoLongHudText", "Purchased") end
end)

RegisterUICallback("np-ui:getDOJData", function(data, cb)
  local results = RPC.execute("np-gov:getDOJData")
  cb({ data = results, meta = { ok = true, message = "done" } })
end)

RegisterUICallback("np-ui:setDOJStatus", function (data, cb)
  RPC.execute("np-gov:dojApp:setStatus", exports["isPed"]:isPed("myjob"), data.status)
  cb({ data = {}, meta = { ok = true, message = "done" } })
end)

AddEventHandler('np-gov:townhall:openPdActions', function()
  local context = {
    {
      title = 'Raid Actions',
    },
    {
      title = 'Housing/Warehouses',
      description = 'Raid actions for housing',
      icon = 'laptop-house',
      children = {
        {
          title = 'Lockdown by Housing ID',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'ld_housing_id'
        },
        {
          title = 'Lockdown by owner State ID',
          description = 'Will lockdown all properties for State ID',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'ld_housing_cid'
        },
        {
          title = 'Remove lockdown by Housing ID',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'rm_housing_id'
        },
        {
          title = 'Remove lockdown by owner State ID',
          description = 'Remove lockdown for all properties for State ID',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'rm_housing_cid'
        }
      }
    },
    {
      title = 'Apartments',
      description = 'Raid actions for apartments',
      icon = 'building',
      children = {
        {
          title = 'Lockdown by State ID',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'ld_apartments_cid'
        },
        {
          title = 'Lockdown by Room ID',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'ld_apartments_rid'
        },
        {
          title = 'Remove lockdown by State ID',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'rm_apartments_cid'
        },
        {
          title = 'Remove lockdown by Room ID',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'rm_apartments_rid'
        }
      }
    },
    {
      title = 'Garages',
      description = 'View citizens\' active garages',
      icon = 'parking',
      action = 'np-gov:townhall:pdActionHandler',
      key = 'garages'
    },
    {
      title = 'Business',
      description = 'Raid actions for businesses',
      icon = 'business-time',
      children = {
        {
          title = 'Lockdown storage units',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'ld_storage'
        },
        {
          title = 'Remove storage units lockdown',
          action = 'np-gov:townhall:pdActionHandler',
          key = 'rm_storage'
        },
      }
    }
  }
  exports['np-ui']:showContextMenu(context)
end)

RegisterUICallback('np-gov:townhall:pdActionHandler', function(data, cb)
  Wait(1) -- prevent ui cursor getting stuck
  local elements = {
    ['time'] = { name = 'time', label = 'Time (hours) default: 24', icon = 'clock' },
    ['hid'] = { name = 'hid', label = 'House ID', icon = 'house-user' },
    ['cid'] = { name = 'cid', label = 'State ID', icon = 'id-card' },
    ['rid'] = { name = 'rid', label = 'Room ID', icon = 'building' },
    ['bname'] = { name = 'name', label = 'Business Name', icon = 'business-time' },
    ['bowner'] = { name = 'owner', label = 'Business Owner', icon = 'id-badge' },
    ['apartments'] = { _type = 'select', label = 'Building Type', name = 'apartments', options = {
      {
        id = 1,
        name = 'Alta Street'
      },
      {
        id = 2,
        name = 'Prosperity'
      },
      {
        id = 3,
        name = 'Pillbox Swiss St'
      }
    }}
  }

  local actionHandlers = {
    ['ld_housing_id'] = function()
      local elements = {
        elements['hid'],
        elements['time'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.hid and values.hid:len() > 0
      end)
      if not prompt then return end
      local time = prompt.time or 24
      RPC.execute("property:clientLockdown",tonumber(prompt.hid), true, time * 3600)
    end,
    ['ld_housing_cid'] = function()
      local elements = {
        elements['cid'],
        elements['time'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.cid and values.cid:len() > 0
      end)
      if not prompt then return end
      local time = prompt.time or 24
      RPC.execute("property:clientCIDLockdown",tonumber(prompt.cid), true, time * 3600)
    end,
    ['rm_housing_id'] = function()
      local elements = {
        elements['hid'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.hid and values.hid:len() > 0
      end)
      if not prompt then return end
      RPC.execute("property:clientLockdown",tonumber(prompt.hid), false, 1)
    end,
    ['rm_housing_cid'] = function()
      local elements = {
        elements['cid'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.cid and values.cid:len() > 0
      end)
      if not prompt then return end
      RPC.execute("property:clientCIDLockdown",tonumber(prompt.cid), false, 1)
    end,
    ['ld_apartments_cid'] = function()
      local elements = {
        elements['cid'],
        elements['apartments'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.cid and values.cid:len() > 0 and values.apartments
      end)
      if not prompt then return end
      TriggerServerEvent("apartment:serverLockdownCID", tonumber(prompt.cid), prompt.apartments, true)
    end,
    ['ld_apartments_rid'] = function()
      local elements = {
        elements['rid'],
        elements['apartments'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.rid and values.rid:len() > 0 and values.apartments
      end)
      if not prompt then return end
      TriggerServerEvent("apartment:serverLockdown", tonumber(prompt.rid), prompt.apartments, true)
    end,
    ['rm_apartments_cid'] = function()
      local elements = {
        elements['cid'],
        elements['apartments'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.cid and values.cid:len() > 0 and values.apartments
      end)
      if not prompt then return end
      TriggerServerEvent("apartment:serverLockdownCID", tonumber(prompt.cid), prompt.apartments, false)
    end,
    ['rm_apartments_rid'] = function()
      local elements = {
        elements['rid'],
        elements['apartments'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.rid and values.rid:len() > 0 and values.apartments
      end)
      if not prompt then return end
      TriggerServerEvent("apartment:serverLockdown", tonumber(prompt.rid), prompt.apartments, false)
    end,
    ['garages'] = function()
      local elements = {
        elements['cid'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.cid and values.cid:len() > 0
      end)
      if not prompt then return end
      local garages = RPC.execute('np-vehicles:getGaragesForStateId', prompt.cid)
      if not garages then return end
      local context = {
        {
          title = 'Citizen ' .. prompt.cid ..'\'s Garages',
        }
      }
      for _,garage in ipairs(garages) do
        context[#context + 1] = {
          icon = garage.name == 'Housing Garage' and 'map-marked-alt' or 'parking',
          title = garage.name .. ' (' .. garage.id .. ')',
          action = 'np-gov:townhall:setGPSLocation',
          key = { x = garage.x, y = garage.y }
        }
      end
      exports['np-ui']:showContextMenu(context)
    end,
    ['ld_storage'] = function()
      local elements = {
        elements['cid'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.cid and values.cid:len() > 0
      end)
      if not prompt then return end
      local result = RPC.execute('np-gov:townhall:lockdownStorage', tonumber(prompt.cid), true)
      if not result[1] then
        TriggerEvent('DoLongHudText', result[2], 2)
        return
      end
      exports['np-ui']:openApplication('textpopup', { show = true, text = result[1]})
    end,
    ['rm_storage'] = function()
      local elements = {
        elements['cid'],
      }
      local prompt = exports['np-ui']:OpenInputMenu(elements, function(values)
        return values.cid and values.cid:len() > 0
      end)
      if not prompt then return end
      RPC.execute('np-gov:townhall:lockdownStorage', tonumber(prompt.cid), false)
      TriggerEvent('DoLongHudText', 'Storage lockdown removed.')
    end,
  }

  local action = data.key

  if not actionHandlers[action] then
    TriggerEvent('DoLongHudText', 'Invalid action', 2)
    return
  end
  actionHandlers[action]()
  cb({ data = {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback('np-gov:townhall:setGPSLocation', function(data, cb)
  cb({ data = {}, meta = { ok = true, message = 'done' } })
  SetNewWaypoint(data.key.x, data.key.y)
  TriggerEvent('DoLongHudText', 'GPS Updated')
end)
