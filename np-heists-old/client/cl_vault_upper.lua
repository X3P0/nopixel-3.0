local activeKeypad = nil
local keypadCoords = {
    ["first_door"] = {
        coords = vector3(261.43, 223.13, 106.29),
        heading = 259.94,
    },
    ["vault_door"] = {
        coords = vector3(253.64, 228.17, 101.69),
        heading = 62.71,
    },
}
local activeEntranceDoor = nil

function VaultUpperCanUsePanel()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for keypad, conf in pairs(keypadCoords) do
        if #(playerCoords - conf.coords) < 1.0 then
            activeKeypad = keypad
            return true
        end
    end
    activeKeypad = nil
    return false
end
function VaultUpperUsePanel(laptopId)
    local isUpperVaultActive = RPC.execute("np-heists:vault:isUpperActive")
    if activeKeypad == "first_door" then
      if not isUpperVaultActive then
        local canRob = CheckRequiredItems("vault_lower")
        if not canRob then return end
      end
    end
    local canOpen, message = RPC.execute("heists:vaultUpperDoorAttempt", activeKeypad, laptopId)
    if not canOpen then
        TriggerEvent("DoLongHudText", message, 2)
        return
    end

    if activeKeypad == "vault_door" then
        TriggerServerEvent("dispatch:svNotify", {
            dispatchCode = "10-90B",
            origin = keypadCoords[activeKeypad].coords,
        })
    end

    local active = keypadCoords[activeKeypad]
    local success = Citizen.Await(UseBankPanel(active.coords, active.heading, "vault_upper", activeKeypad == "first_door"))

    if not success then
        RPC.execute("np-heists:vaultUpperPanelFail")
        return
    end

    if activeKeypad == "first_door" and not isUpperVaultActive then
      RemoveRequiredItems("vault_lower")
    end
  
    TriggerEvent("inventory:removeItemByMetaKV", "heistlaptop4", 1, "id", laptopId)

    local goldStatus = RPC.execute("heists:vaultUpperDoorOpen", activeKeypad)
    if activeKeypad ~= "vault_door" then return end

    local trolleyConfig1 = GetTrolleyConfig("vault_upper_cash_1")
    local trolleyConfig2 = GetTrolleyConfig("vault_upper_cash_2")
    SpawnTrolley(trolleyConfig1.cashCoords, "cash", trolleyConfig1.cashHeading)
    SpawnTrolley(trolleyConfig2.cashCoords, "cash", trolleyConfig2.cashHeading)
    if goldStatus.gold1 then
        SpawnTrolley(trolleyConfig1.goldCoords, "gold", trolleyConfig1.goldHeading)
    end
    if goldStatus.gold2 then
        SpawnTrolley(trolleyConfig2.goldCoords, "gold", trolleyConfig2.goldHeading)
    end
end

-- AddEventHandler("heists:vaultUpperTrolleyGrab", function(loc, type)
--     local canGrab = RPC.execute("np-heists:vaultUpperCanGrabTrolley", loc, type)
--     if canGrab then
--         Loot(type)
--         TriggerEvent("DoLongHudText", "You discarded the counterfeit items", 1)
--         RPC.execute("np-heists:payoutTrolleyGrab", loc, type)
--     else
--         TriggerEvent("DoLongHudText", "You can't do that yet...", 2)
--     end
-- end)

local vaultUpperDoors = {
  ["vault_upper_first_door"] = true,
  ["vault_upper_inner_door_1"] = true,
  ["vault_upper_inner_door_2"] = true,
}
local bobcatSecurityDoors = {
  ["bobcat_security_entry"] = true,
  ["bobcat_security_inner_1"] = true,
}
local fleecaDoors = {
  ["fleeca_legion_inner_door"] = true,
  ["fleeca_pinkcage_inner_door"] = true,
  ["fleeca_harwick_inner_door"] = true,
  ["fleeca_lifeinvader_inner_door"] = true,
  ["fleeca_greatocean_inner_door"] = true,
  ["fleeca_harmony_inner_door"] = true,
}
local paletoDoors = {
  ["paleto_inner_door"] = true,
}
local varHeistDoors = {
  ["var_heist_door"] = true,
}
local hasinoDoors = {
  ["hasino_box_1"] = true,
  ["hasino_box_2"] = true,
  ["hasino_box_3"] = true,
}
AddEventHandler("np-inventory:itemUsed", function(item)
  if item ~= "thermitecharge" then return end
  if AttemptJewelryStoreThermite() then return end
  if AttemptBayCityThermiteDoor() then return end
  local locations = {
    -- "vault_upper_first_door",
    -- "vault_upper_inner_door_1",
    -- "vault_upper_inner_door_2",
    -- "bobcat_security_entry",
    -- "bobcat_security_inner_1",
    -- "fleeca_legion_inner_door",
    -- "fleeca_pinkcage_inner_door",
    -- "fleeca_harwick_inner_door",
    -- "fleeca_lifeinvader_inner_door",
    -- "fleeca_greatocean_inner_door",
    -- "fleeca_harmony_inner_door",
    -- "paleto_inner_door",
    -- "var_heist_door",
    "hasino_box_1",
    "hasino_box_2",
    "hasino_box_3",
  }
  local playerCoords = GetEntityCoords(PlayerPedId())
  local foundLoc, foundPtfx, foundRotplus = nil, nil, nil
  local foundLocationName = nil
  for _, val in pairs(locations) do
    local loc, ptfx, rotplus = ThermiteLocations(val)
    if #(playerCoords - vector3(loc.x, loc.y, loc.z)) < 1.5 then
      foundLoc = loc
      foundPtfx = ptfx
      foundRotplus = rotplus
      foundLocationName = val
    end
  end
  if not foundLoc then
    -- TriggerEvent("DoLongHudText", "Nothing to burn!", 2)
    return
  end
  -- if foundLocationName == "vault_upper_first_door" then
  --   local canRob = CheckRequiredItems("vault_upper")
  --   if not canRob then return end
  --   local canHitUpperVault = RPC.execute("np-heists:vault:canHitUpperVault")
  --   if not canHitUpperVault then
  --     TriggerEvent("DoLongHudText", "Door was recently hit", 2)
  --     return
  --   end
  -- end
  TriggerEvent("inventory:removeItem", "thermitecharge", 1)
  local gameSettings = nil
  -- if vaultUpperDoors[foundLocationName] then
  --   TriggerServerEvent("dispatch:svNotify", {
  --     dispatchCode = "10-90B",
  --     origin = foundLoc,
  --   })
  --   gameSettings = {
  --     gameTimeoutDuration = 15000,
  --     coloredSquares = 16,
  --     gridSize = 6,
  --   }
  -- end
  -- if bobcatSecurityDoors[foundLocationName] then
  --   TriggerServerEvent("dispatch:svNotify", {
  --     dispatchCode = "10-90F",
  --     origin = foundLoc,
  --   })
  -- end
  -- if varHeistDoors[foundLocationName] then
  --   gameSettings = {
  --     gameTimeoutDuration = 18000,
  --     coloredSquares = 18,
  --     gridSize = 7,
  --   }
  -- end
  if hasinoDoors[foundLocationName] then
    gameSettings = {
      gameTimeoutDuration = 18000,
      coloredSquares = 20,
      gridSize = 8,
    }
  end
  local success = Citizen.Await(ThermiteCharge(foundLoc, foundPtfx, foundRotplus, gameSettings))
  -- if foundLocationName == "vault_upper_first_door" and success then
  --   RemoveRequiredItems("vault_upper")
  -- end
  -- if vaultUpperDoors[foundLocationName] and success then
  --   RPC.execute("heists:vaultUpperDoorOpen", foundLocationName)
  --   TriggerServerEvent("dispatch:svNotify", {
  --     dispatchCode = "10-90B",
  --     origin = foundLoc,
  --   })
  -- end
  -- if bobcatSecurityDoors[foundLocationName] and success then
  --   RPC.execute("heists:bobcatDoorOpen", foundLocationName)
  -- end
  -- if fleecaDoors[foundLocationName] and success then
  --   RPC.execute("heists:fleecaDoorOpen", foundLocationName)
  -- end
  -- if paletoDoors[foundLocationName] and success then
  --   RPC.execute('heists:paletoDoorOpen', foundLocationName)
  -- end
  -- if varHeistDoors[foundLocationName] and success then
  --   RPC.execute('np-heists-serverroom:varDoorOpen', foundLocationName)
  -- end
  if hasinoDoors[foundLocationName] and success then
    TriggerEvent("np-hasino:thermiteSuccess", foundLocationName)
  end
end)

-- interior unloading issue
-- Citizen.CreateThread(function()
--   local wasInVaultRoom = false
--   while true do
--     local idle = 2500
--     local ped = PlayerPedId()
--     local interior = GetInteriorFromEntity(ped)
--     local roomHash = GetRoomKeyFromEntity(ped)
--     if
--       (interior == 139265 and roomHash == 913797866)
--       or (wasInVaultRoom and interior == 0 and roomHash == 0)
--     then
--       -- CAN_GRAPPLE_HERE = false
--       wasInVaultRoom = true
--       idle = 100
--       ForceRoomForEntity(ped, 139265, 913797866)
--       ForceRoomForGameViewport(139265, 913797866)
--     else
--       CAN_GRAPPLE_HERE = true
--       wasInVaultRoom = false
--       idle = 2500
--     end
--     Citizen.Wait(idle)
--   end
-- end)
