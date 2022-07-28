local currentPosition = GetEntityCoords(PlayerPedId())
local isWithinShop = false
local isNearDistillery = false
local distilleryStatus = nil
local distilleryLocation = vector3(0, 0, 0)
local awaitingResponse = false

RegisterNetEvent("distillery:setDistilleryLocation")
AddEventHandler("distillery:setDistilleryLocation", function(pLocation)
    if pLocation ~= nil and distilleryLocation ~= pLocation then
        distilleryLocation = pLocation
    end
end)

RegisterNetEvent("distillery:updateDistilleryProgress")
AddEventHandler("distillery:updateDistilleryProgress", function(pStatus)
    distilleryStatus = pStatus
    awaitingResponse = false
end)

Citizen.CreateThread(function()
    exports["np-polyzone"]:AddBoxZone("np-distillery:tavern", vector3(2463.95, 3446.46, 50.11), 7.0, 2.2, {
        minZ = 44.91,
        maxZ = 51.31,
        heading = 5
    })
end)

local function stageProcess(pActionText, pTaskTime, pTaskText, pServerEvent, pCanExplode)
  DrawText3Ds(distilleryLocation.x, distilleryLocation.y, distilleryLocation.z + 1.2, pActionText)
  if IsControlJustReleased(1, 38) then
      TriggerEvent("animation:PlayAnimation", "layspike")
      local finished = exports["np-taskbar"]:taskBar(pTaskTime, pTaskText, false, false, nil)
      ClearPedSecondaryTask(PlayerPedId())
      if (finished == 100) then
          if pCanExplode then -- and (math.random() > 0.6) then
              AddExplosion(distilleryLocation, 7, 15.0, true, false, true, false)
              local streetName, crossingRoad = GetStreetNameAtCoord(distilleryLocation.x, distilleryLocation.y,
                  distilleryLocation.z)
              TriggerServerEvent('dispatch:svNotify', {
                  dispatchCode = "10-70",
                  firstStreet = GetStreetNameFromHashKey(streetName),
                  secondStreet = GetStreetNameFromHashKey(crossingRoad),
                  origin = {
                      x = distilleryLocation.x,
                      y = distilleryLocation.y,
                      z = distilleryLocation.z
                  }
              })
          end
          awaitingResponse = true
          TriggerServerEvent(pServerEvent)
      end
  end
end

local function RenderDistillery()
  isNearDistillery = true
  TriggerServerEvent('distillery:getDistilleryLocation')
  Citizen.CreateThread(function()
      while isNearDistillery do
          if distilleryStatus then
              DrawText3Ds(distilleryLocation.x, distilleryLocation.y, distilleryLocation.z + 1.0,
                  (distilleryStatus.stage.ruined and 'Ruined' or stages[distilleryStatus.stage.current].name))
              if distilleryStatus.stage.current == 0 then
                  DrawText3Ds(distilleryLocation.x, distilleryLocation.y, distilleryLocation.z + 1.1,
                      "Fruit " .. distilleryStatus.mash.fruit.count .. " | Potato " ..
                          distilleryStatus.mash.potato.count .. " | Grain " .. distilleryStatus.mash.grain.count ..
                          " | Water " .. distilleryStatus.mash.water.count)
                  DrawText3Ds(distilleryLocation.x, distilleryLocation.y, distilleryLocation.z + 0.8,
                      "Press ~r~[E]~w~ to add ingredients")
                  if IsControlJustReleased(1, 38) and #(distilleryLocation - GetEntityCoords(PlayerPedId())) < 1.6 then
                      TriggerEvent("animation:PlayAnimation", "layspike")
                      Wait(1000)
                      for _, mashType in pairs(distilleryStatus.mash) do
                          if mashType.count < batchRequirements[_].count then
                              if batchRequirements[_].validIngredient ~= nil then
                                  if exports["np-inventory"]:hasEnoughOfItem(batchRequirements[_].validIngredient, 1,
                                      false) then
                                      TriggerServerEvent("distillery:addIngredient", _)
                                      TriggerEvent("inventory:removeItem", batchRequirements[_].validIngredient, 1)
                                      Wait(100)
                                      break
                                  end
                              else
                                  if batchRequirements[_].validIngredients ~= nil then
                                      local shouldBreak = false
                                      for __, validIngredient in pairs(batchRequirements[_].validIngredients) do
                                          if exports["np-inventory"]:hasEnoughOfItem(validIngredient, 1, false) then
                                              TriggerServerEvent("distillery:addIngredient", _)
                                              TriggerEvent("inventory:removeItem", validIngredient, 1)
                                              Wait(100)
                                              shouldBreak = true
                                              break
                                          end
                                      end
                                      if shouldBreak then
                                          break
                                      end
                                  end
                              end
                          end
                      end
                  end
              elseif distilleryStatus.stage.current == 1 and not awaitingResponse then
                  if distilleryStatus.stage.ruined then
                      stageProcess("Press ~r~[E]~w~ clean out the ruined mash", 15000, "Cleaning out the ruined mash",
                          "distillery:reset")
                  elseif not distilleryStatus.stage.ruined and distilleryStatus.stage.readyForNextStage then
                      stageProcess("Press ~r~[E]~w~ to start brewing", 3000, "Starting the brewing process",
                          "distillery:nextStage")
                  end
              elseif distilleryStatus.stage.current == 2 and not awaitingResponse then
                  if distilleryStatus.stage.ruined then
                      stageProcess("Press ~r~[E]~w~ to pour out the ruined brew", 15000,
                          "Pouring out the ruined brew", "distillery:reset")
                  elseif not distilleryStatus.stage.ruined and distilleryStatus.stage.readyForNextStage then
                      stageProcess("Press ~r~[E]~w~ to start distilling", 3000, "Starting the distilling process",
                          "distillery:nextStage")
                  end
              elseif distilleryStatus.stage.current == 3 and not awaitingResponse then
                  if distilleryStatus.stage.ruined then
                      stageProcess("Press ~r~[E]~w~ to let out the alcohol vapor", 15000, "Emitting alcohol vapor",
                          "distillery:reset", true)
                  elseif not distilleryStatus.stage.ruined and distilleryStatus.stage.readyForNextStage then
                      stageProcess("Press ~r~[E]~w~ to start bottling", 3000, "Starting the bottling process",
                          "distillery:nextStage")
                  end
              elseif distilleryStatus.stage.current == 4 then
                  if not distilleryStatus.stage.ruined and not awaitingResponse then
                      DrawText3Ds(distilleryLocation.x, distilleryLocation.y, distilleryLocation.z + 1.2,
                          "Press ~r~[E]~w~ to start bottling")
                      if IsControlJustReleased(1, 38) then
                          if exports["np-inventory"]:hasEnoughOfItem("glass", 1, false) then
                              TriggerEvent("animation:PlayAnimation", "layspike")
                              local finished = exports["np-taskbar"]:taskBar(1000, "Bottling moonshine", false, false,
                                  nil)
                              ClearPedSecondaryTask(PlayerPedId())
                              if (finished == 100) then
                                  awaitingResponse = true
                                  TriggerServerEvent("distillery:bottling")
                                  TriggerEvent("inventory:removeItem", "glass", 1)
                                  TriggerEvent("player:receiveItem", "moonshine", 1)
                              end
                          else
                              TriggerEvent('DoLongHudText', "You do not have any glass to bottle it with.", 101)
                          end
                      end
                  elseif not awaitingResponse then
                      stageProcess("Press ~r~[E]~w~ to pour out the ruined alcohol", 15000,
                          "Pouring out the alcohol, shame 🔔", "distillery:reset")
                  end
              end
          end
          Wait(0)
      end
  end)
end

AddEventHandler("np-polyzone:enter", function(name, data)
    if name ~= "np-distillery:tavern" then
        return
    end
    TriggerServerEvent("distillery:requestUpdate")
    RenderDistillery()
end)

AddEventHandler("np-polyzone:exit", function(name, data)
    if name ~= "np-distillery:tavern" then
        return
    end
    isNearDistillery = false
end)

RegisterNetEvent("np-distillery:fruitShop")
AddEventHandler("np-distillery:fruitShop", function()
    TriggerEvent("server-inventory-open", "32", "Shop");
end)



function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end
