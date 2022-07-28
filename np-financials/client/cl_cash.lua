RegisterNetEvent("np-financials:cash")
AddEventHandler("np-financials:cash", function(pCash, pChange)
  if not pCash then return false, "No cash" end
  exports["np-ui"]:cashFlash(pCash, pChange)
end)
