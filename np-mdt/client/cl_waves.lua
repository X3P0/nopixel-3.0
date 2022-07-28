Citizen.CreateThread(function()
  while true do
    if IsEntityInWater(PlayerPedId()) or
       IsEntityInWater(GetVehiclePedIsIn(PlayerPedId(), false))
    then
      SetDeepOceanScaler(0.25)
    end
    Citizen.Wait(5000)
  end
end)
