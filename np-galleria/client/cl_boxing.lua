-- local leftGlove = nil
-- local rightGlove = nil

-- local leftGloves = {
--   ["black"] = `np_boxing_bl_l`,
--   ["blue"] = `np_boxing_b_l`,
--   ["red"] = `np_boxing_r_l`,
-- }
-- local rightGloves = {
--   ["black"] = `np_boxing_bl_r`,
--   ["blue"] = `np_boxing_b_r`,
--   ["red"] = `np_boxing_r_r`,
-- }

-- AddEventHandler("np-inventory:itemUsed", function(item)
--   if item ~= "boxinggloves" then return end
--   local ped = PlayerPedId()
--   local boneIndex = GetPedBoneIndex(ped, 0xfa70)
--   print(boneIndex)
--   local bonePos = GetWorldPositionOfEntityBone(ped, boneIndex)
--   print(bonePos)
--   local model = leftGloves.blue
--   print(model)
--   -- RequestModel(model)
--   -- while not HasModelLoaded(model) do
--   --   Citizen.Wait(0)
--   -- end
--   leftGlove = CreateObject(model, bonePos.x, bonePos.y, bonePos.z + 0.01, true, false, true)
--   print(leftGlove)
--   AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 57005), 0.1, 0, -0.025, -90.0, 90.0, 0.0, true, true, false, true, 1, true)
-- end)

-- Citizen.CreateThread(function()
--   Citizen.Wait(1000)
--   TriggerEvent("np-inventory:itemUsed", "boxinggloves")
--   Citizen.Wait(5000)
--   DeleteObject(leftGlove)
-- end)

local isEquipped = false
local boxingGloveVars = {
  { "np_boxing_bl_r", "np_boxing_bl_l" },
  { "np_boxing_b_r", "np_boxing_b_l" },
  { "np_boxing_r_r", "np_boxing_r_l" },
}
AddEventHandler("np-inventory:boxingGlovesEquipped", function(pEquipped)
  if pEquipped and not isEquipped then
    local gloves = boxingGloveVars[math.random(#boxingGloveVars)]
    TriggerEvent("np-props:attachProp", gloves[1], 28422, 0.075, 0.0, -0.025, 180.0, 270.0, 0.0, true)
    TriggerEvent("np-props:attachProp", gloves[2], 60309, 0.075, 0.0, 0.025, 180.0, 270.0, 0.0, true)
  end
  isEquipped = pEquipped
  if not isEquipped then
    SetPedCanRagdoll(PlayerPedId(), true)
    SetPedCanRagdollFromPlayerImpact(PlayerPedId(), true)
    TriggerEvent("np-props:removeProp")
    return
  end
  Citizen.CreateThread(function()
    while isEquipped do
      if (#(GetEntityCoords(PlayerPedId()) - vector3(-475.17, 39.83, 53.07)) < 5) and math.random() < 0.8 then
        SetPedCanRagdoll(PlayerPedId(), false)
        SetPedCanRagdollFromPlayerImpact(PlayerPedId(), false)
      else
        SetPedCanRagdoll(PlayerPedId(), true)
        SetPedCanRagdollFromPlayerImpact(PlayerPedId(), true)
      end
      Citizen.Wait(math.random(2500, 10000))
    end
  end)
end)
