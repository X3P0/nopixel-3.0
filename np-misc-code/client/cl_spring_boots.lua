local springBootsActive = false
local cdTimer = 0
AddEventHandler("np-inventory:itemUsed", function(pItem, pInfo)
  if pItem ~= "cispringboots" then return end
  if springBootsActive then return end
  if not pInfo then return end
  if cdTimer ~= 0 then
    if cdTimer > (GetGameTimer() - 45000) then
      TriggerEvent("DoLongHudText", "Recharging", 2)
      return
    end
  end
  cdTimer = GetGameTimer()
  local cid = exports["isPed"]:isPed("cid")
  local data = json.decode(pInfo)
  if tonumber(cid) ~= tonumber(data.cid) then return end
  springBootsActive = true
  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10.0, 'boing', 0.25)
  local playerPed = PlayerPedId()
  Citizen.CreateThread(function()
    Citizen.Wait(100)
    springBootsActive = false
    Citizen.Wait(100)
    SetPedToRagdoll(playerPed, 5000, 5000, 3, 0, 0, 0)
  end)
  Citizen.CreateThread(function()
    local x = math.random(-200, 200) + 0.0
    local y = math.random(-200, 200) + 0.0
    local z = math.random(1, 200) + 0.0
    while springBootsActive do
      ApplyForceToEntity(playerPed, 1, x, y, z, 0.0, 0.0, -300.0, 0, true, false, false, false, true)
      Citizen.Wait(0)
    end
  end)
end)
