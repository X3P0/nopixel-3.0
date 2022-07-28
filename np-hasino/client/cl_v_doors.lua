local bicBoiVaultDoorStates = {}
local doorStates = {}

local vaultOpening = false
local vaultOpened = true

function refreshVaultDoor()
  local interiorid = GetInteriorAtCoords(1004.02, 12.02, -8.54)
  for k, s in pairs(bicBoiVaultDoorStates) do
      DisableInteriorProp(interiorid, k)
  end
  for k, s in pairs(bicBoiVaultDoorStates) do
    if s then
      EnableInteriorProp(interiorid, k)
    end
  end
  RefreshInterior(interiorid)
end

function openVaultDoor()
  local entity = GetClosestObjectOfType(1000.19, 10.54, -7.99, 0.5, GetHashKey('ch_prop_ch_vaultdoor01x'), false, 0, 0)
  if entity and DoesEntityExist(entity) then
    vaultOpening = true
    ChangeDoorHeading(entity, 128.0, 1, 6.5)
    vaultOpened = true
    Wait(6500)
    vaultOpening = false
  end
end

AddEventHandler('np-hasino:loadVaultDoorState', function()
  TriggerEvent('np-casino:elevatorExitCasino')
  vaultOpened = false
  if doorStates['hasino_lower_vault'] then
    while not vaultOpened do
      Wait(100)
      openVaultDoor()
    end
  end
end)

Citizen.CreateThread(function()
  local result = RPC.execute("np-heists:casino:getVaultLowerState")
  bicBoiVaultDoorStates = result.doorState
  doorStates = result.hasinoDoorState
  refreshVaultDoor()
  while true do
      Citizen.Wait(10000)
      if doorStates['hasino_lower_vault'] and not vaultOpening then
        openVaultDoor()
      end
  end
end)

RegisterNetEvent('np-hasino:openVaultDoor', function()
  doorStates['hasino_lower_vault'] = true
  local entity = GetClosestObjectOfType(1000.19, 10.54, -7.99, 0.5, GetHashKey('ch_prop_ch_vaultdoor01x'), false, 0, 0)
  if not entity or not DoesEntityExist(entity) then return end
  vaultOpening = true
  ChangeDoorHeading(entity, 128.0, 1, 6.5)
  if #(GetEntityCoords(PlayerPedId()) - vector3(1000.19, 10.54, -7.99)) < 15.0 then
    PlaySoundFrontend(-1, 'VAULT_DOOR_CLOSE', 0, false)
    PlaySoundFrontend(-1, 'VAULT_DOOR_CLOSE', 0, false)
    PlaySoundFrontend(-1, 'VAULT_DOOR_CLOSE', 0, false)
    SetTimeout(15000, function()
      ReleaseNamedScriptAudioBank('Vault_Door')
    end)
  end
  Wait(6500)
  vaultOpening = false
end)

RegisterNetEvent('np-hasino:setLadderState', function(pState)
    -- activate ladder
    local elevInteriorId = GetInteriorAtCoords(vector3(1012.9, 30.18, 63.39))
    if pState then
      ActivateInteriorEntitySet(elevInteriorId, 'set_casino_ladder')
      disableLasers(true)
    else
      DeactivateInteriorEntitySet(elevInteriorId, 'set_casino_ladder')
    end
    RefreshInterior(elevInteriorId)
end)
