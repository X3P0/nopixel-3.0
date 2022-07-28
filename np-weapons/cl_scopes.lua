local ScopedWeapons = {
  [-1719357158] = false,
  [-90637530] = false
}

local isScoped = false

Citizen.CreateThread(function()
  while true do
    for weaponHash, v in pairs(ScopedWeapons) do
      if GetSelectedPedWeapon(PlayerPedId()) == weaponHash and IsPlayerFreeAiming(PlayerId()) then
        if not isScoped then
          isScoped = true
          exports["np-ui"]:sendAppEvent("sniper-scope", { show = true })
        end
      elseif isScoped and not IsPlayerFreeAiming(PlayerId()) then
        isScoped = false
        exports["np-ui"]:sendAppEvent("sniper-scope", { show = false })
      end
    end
    Citizen.Wait(100)
  end
end)
