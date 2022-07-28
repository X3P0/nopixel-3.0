local usingMegaphone, hasSet = false, false
RegisterNetEvent("np-usableprops:megaphone", function()
  usingMegaphone = not usingMegaphone
  if not usingMegaphone then
    TriggerEvent("animation:c")
  end
end)

CreateThread(function()
  while true do
    Citizen.Wait(1500)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    if usingMegaphone then
      local animDictionary, animName = "amb@world_human_mobile_film_shocking@female@base", "base"
      loadAnimDict(animDictionary)
      TriggerEvent("animation:c")
      TriggerEvent("attachItem", "megaphone")
      TaskPlayAnim(ped, animDictionary, animName, 1.0, 1.0, GetAnimDuration(animDictionary, animName), 49, 0, 0, 0, 0)
      Wait(100)
      while usingMegaphone and not IsEntityDead(ped) and (GetVehiclePedIsIn(ped) == 0) and IsEntityPlayingAnim(ped, "amb@world_human_mobile_film_shocking@female@base", "base", 3) do
        if not hasSet then
          TriggerEvent('np:voice:proximity:override', "megaphone", 3, 75.0, 2)
          TriggerServerEvent("np:voice:transmission:state", -1, 'megaphone', true, 'megaphone')
          hasSet = true
        end
        Wait(0)
      end
      usingMegaphone = false
      hasSet = false
      StopAnimTask(ped, animDictionary, animName, 3.0)
      TriggerEvent("destroyProp")
      TriggerEvent('np:voice:proximity:override', "megaphone", 3, -1, -1)
      TriggerServerEvent("np:voice:transmission:state", -1, 'megaphone', false, 'megaphone')
    end
  end
end)