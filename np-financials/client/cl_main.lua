-- CLOSE APP EVENT
RegisterNetEvent("financial:openUI")
AddEventHandler("financial:openUI", function()
  local isNearATM = isNearATM()
  if isNearATM then
    financialAnimation(isNearATM, true)
    Citizen.Wait(1400)
    exports["np-ui"]:openApplication("atm", {
      isAtm = true
    })
  end
end)
