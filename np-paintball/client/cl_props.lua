-- TriggerEvent("np-props:attachProp", flagProp, 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)

local attachedProps = {}
local attachPropsByName = {}
function removeAttachedProp()
  for _, v in pairs(attachedProps) do
    DeleteEntity(v)
  end
  attachedProps = {}
end
function removeAttachedPropByName(pName)
  local v = attachPropsByName[pName]
  DeleteEntity(v)
end
function attachProp(attachModelSent, boneNumberSent, x, y, z, xR, yR, zR, keepOtherProps, altVertex, name)
  if not keepOtherProps then
    removeAttachedProp()
  end
  attachModel = GetHashKey(attachModelSent)
  boneNumber = boneNumberSent
  local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
  RequestModel(attachModel)
  while not HasModelLoaded(attachModel) do
    Citizen.Wait(0)
  end
  local attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
  if name then
    attachPropsByName[name] = attachedProp
  else
    attachedProps[#attachedProps + 1] = attachedProp
  end
  AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 1, not altVertex and 2 or 0, 1)
  SetModelAsNoLongerNeeded(attachModel)
end

AddEventHandler("np-props:attachProp", function(attachModelSent, boneNumberSent, x, y, z, xR, yR, zR, keepOtherProps, altVertex, name)
  attachProp(attachModelSent, boneNumberSent, x, y, z, xR, yR, zR, keepOtherProps, altVertex, name)
end)
AddEventHandler("np-props:removeProp", function()
  removeAttachedProp()
end)
AddEventHandler("np-props:removePropByName", function(pName)
  removeAttachedPropByName(pName)
end)
