RegisterNetEvent('CarPlayerHud:ToggleGas')
AddEventHandler('CarPlayerHud:ToggleGas', function()
    showGasStations = not showGasStations
   for _, item in pairs(gasStations) do
        if not showGasStations then
            if item.blip ~= nil then
                RemoveBlip(item.blip)
            end
        else
            item.blip = AddBlipForCoord(item[1], item[2], item[3])
            SetBlipSprite(item.blip, 361)
            SetBlipScale(item.blip, 0.7)
            SetBlipAsShortRange(item.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Gas")
            EndTextCommandSetBlipName(item.blip)
        end
    end
end)
