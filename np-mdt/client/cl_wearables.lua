local wearableItems = {
  ["suitvector"] = `vector`,
  ["suitpinkranger"] = `powerrangerpink`,
}

AddEventHandler("np-inventory:itemUsed", function(pItem)
  if not wearableItems[pItem] then return end
  local model = wearableItems[pItem]
  RequestModel(model)
  while (not HasModelLoaded(model)) do
    Citizen.Wait(0)
  end
  SetPlayerModel(PlayerId(), model)
  SetModelAsNoLongerNeeded(model)
end)
