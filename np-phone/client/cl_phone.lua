
RegisterUICallback("np-ui:activateSelfieMode", function(data, cb)
  exports["np-ui"]:closeApplication("phone")
  DestroyMobilePhone()
  Wait(0)
  CreateMobilePhone(0)
  CellCamActivate(true, true)
  CellCamDisableThisFrame(true)
  Citizen.CreateThread(function()
    local selfieMode = true
    while selfieMode == true do
      if IsControlJustPressed(0, 177) then
        selfieMode = false
        DestroyMobilePhone()
        Wait(0)
        CellCamDisableThisFrame(false)
        CellCamActivate(false, false)
      end
      Wait(0)
    end
  end)
  cb({ data = {}, meta = { ok = true, message = '' } })
end)


RegisterUICallback("np-ui:phone:hasNotificationChanged", function(data, cb)
  TriggerEvent("phone:hasNotificationChanged", data.lastValue, data.value, data.topOfPhone)
  cb({ data = {}, meta = { ok = true, message = '' } })
end)

AddEventHandler("np-ui:application-closed", function (name, data)
  if name ~= "phone" then return end
  StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
  if not IsInActiveCall() then
    TriggerEvent("destroyPropPhone")
  end
end)

local phoneItems = {"mobilephone", "stoleniphone", "stolennokia", "stolenpixel3", "stolens8", "boomerphone"}

RegisterNetEvent('np-inventory:itemCheck')
AddEventHandler('np-inventory:itemCheck', function(itemId, hasItem)
  local foundItem = false
  for _,item in ipairs(phoneItems) do 
    if item == itemId then 
      foundItem = true
    end
  end

  if not foundItem then return end

  local hasPhone = false
  for _,item in ipairs(phoneItems) do 
    hasPhone = exports['np-inventory']:hasEnoughOfItem(item, 1, false, true) or hasPhone
  end

  if not hasPhone then
    endPhoneCall()
  end

  exports["np-ui"]:sendAppEvent("phone", { action = "phone-state-update", hasPhone = hasPhone })
end)
