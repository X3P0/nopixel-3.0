RegisterNetEvent("np-gov:resetLicensesCache")
AddEventHandler("np-gov:resetLicensesCache", function (pCharacterId)
  resetLicensesCache(pCharacterId)
end)

RegisterNetEvent("np-gov:changeScreenImage")
AddEventHandler("np-gov:changeScreenImage", function (pUrl)
  if #(GetEntityCoords(PlayerPedId()) - vector3(-523.81,-185.37,38.22)) > 50 then return end
  local conf = {
    tex = "projector_screen",
    txd = "np_town_hall_bigscreen",
    dui = nil,
  }
  conf.dui = exports["np-lib"]:getDui(pUrl, 512, 512)
  AddReplaceTexture(conf.txd, conf.tex, conf.dui.dictionary, conf.dui.texture)
end)
