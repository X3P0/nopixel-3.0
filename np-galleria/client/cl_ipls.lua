local iplStates = {}
local interiorCoords = {
  { -470.07, 42.59, 52.42 },
  { -468.12, 45.67, 46.24},
}

local function updateIpls()
  local intIds = {}
  for k, v in pairs(iplStates) do
    local coords = interiorCoords[v.coordIndex]
    local interiorId = v.interiorId or GetInteriorAtCoords(coords[1], coords[2], coords[3])
    intIds[interiorId] = true
    if v.state then
      ActivateInteriorEntitySet(interiorId, k)
    else
      DeactivateInteriorEntitySet(interiorId, k)
    end
  end
  for interiorId, v in pairs(intIds) do
    RefreshInterior(interiorId)
  end
end

RegisterNetEvent("np-galleria:iplStatesUpdate")
AddEventHandler("np-galleria:iplStatesUpdate", function(pStates)
  iplStates = pStates
  updateIpls()
end)

Citizen.CreateThread(function()
  TriggerServerEvent("np-galleria:getIplsStates")
end)
