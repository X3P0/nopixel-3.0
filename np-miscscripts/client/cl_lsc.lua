local cardBeingShown = false

function CreateInsuranceCard(pSlot)
  local isEmployed  = exports['np-business']:IsEmployedAt('los_santos_care') or exports['np-business']:IsEmployedAt('ron_corp')

  if not isEmployed then
    return TriggerEvent('DoLongHudText', 'Hmm idk what to do with this...', 2)
  end

  local elements = {
    { name = 'stateId', label = 'StateId', icon = 'time', _type = 'string' },
    { name = 'firstName', label = 'First Name', icon = 'time', _type = 'string' },
    { name = 'lastName', label = 'Last Name', icon = 'time', _type = 'string' },
    { name = 'expiration', label = 'Expiration (mm/dd/yyyy)', icon = 'time', _type = 'string' },
    { name = 'dob', label = 'DOB (mm/dd/yyyy)', icon = 'time', _type = 'string' },
    { name = 'eyeColor', label = 'Eye Color', icon = 'time', _type = 'string' },
    { name = 'height', label = 'Height', icon = 'time', _type = 'string' },
    { name = 'class', label = 'Insurance Class', icon = 'time', _type = 'select', options = {
      { id = 'Basic', name = 'Basic' },
      { id = 'Basic+', name = 'Basic+' },
      { id = 'Premium', name = 'Premium' },
    }},
    { name = 'sex', label = 'Sex', icon = 'time', _type = 'select', options = {
        { id = 'Male', name = 'Male' },
        { id = 'Female', name = 'Female' },
    }},
  }

  local prompt = exports['np-ui']:OpenInputMenu(elements)

  if not prompt then return end
  
  local metaData = {
    Name = prompt.firstName .. ' ' .. prompt.lastName,
    cardInfo = {
        stateId = prompt.stateId,
        firstName = prompt.firstName,
        lastName = prompt.lastName,
        expiration = prompt.expiration,
        dob = prompt.dob,
        eyeColor = prompt.eyeColor,
        height = prompt.height,
        class = prompt.class,
        sex = prompt.sex,
      },
      _hideKeys = { 'cardInfo' },
    }
    
    TriggerEvent('player:receiveItem', 'lsccard', 1, false, metaData)
    TriggerEvent('inventory:removeItemBySlot', 'lsccard', 1, pSlot)
end

AddEventHandler('np-inventory:itemUsed', function(pItem, pInfo, pInventory, pSlot)
  if pItem ~= 'lsccard' then return end

  local information = json.decode(pInfo)
  if not information or not information.cardInfo then
    return CreateInsuranceCard(pSlot)
  end

  NPX.Streaming.loadAnim('paper_1_rcm_alt1-9')

  TaskPlayAnim(PlayerPedId(), 'paper_1_rcm_alt1-9', 'player_one_dual-9', 3.0, 3.0, -1, 49, 0, 0, 0, 0)

  NPX.Procedures.execute('np-miscscripts:showLSCCard', information.cardInfo)

  Wait(7500)

  StopAnimTask(PlayerPedId(), 'paper_1_rcm_alt1-9', 'player_one_dual-9', 1.0)

end)

RegisterNetEvent('np-miscscripts:showLSCCard')
AddEventHandler('np-miscscripts:showLSCCard', function(pSource, pCardInfo)
  if cardBeingShown then return end

  exports['np-ui']:openApplication('lsc', pCardInfo, false)
  cardBeingShown = true
  
  Citizen.CreateThread(function()
    Citizen.Wait(7500)
    exports['np-ui']:closeApplication('lsc')
    cardBeingShown = false
  end)
end)
