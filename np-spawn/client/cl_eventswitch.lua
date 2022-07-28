function Login.playerLoaded() end

function Login.characterLoaded()
  -- Main events leave alone 
  TriggerEvent("np-base:playerSpawned")
  TriggerEvent("playerSpawned")
  TriggerServerEvent('character:loadspawns')
  -- Main events leave alone 

  TriggerEvent("Relog")

  -- Everything that should trigger on character load 
  TriggerServerEvent('checkTypes')
  TriggerServerEvent('isVip')
  TriggerEvent('rehab:changeCharacter')
  TriggerEvent("resetinhouse")
  TriggerEvent("fx:clear")
  TriggerServerEvent('tattoos:retrieve')
  TriggerServerEvent('Blemishes:retrieve')
  TriggerServerEvent("currentconvictions")
  TriggerServerEvent("GarageData")
  TriggerServerEvent("Evidence:checkDna")
  TriggerEvent("banking:viewBalance")
  TriggerServerEvent("police:getLicensesCiv")
  TriggerServerEvent('np-doors:requestlatest')
  TriggerServerEvent("item:UpdateItemWeight")
  TriggerServerEvent("np-weapons:getAmmo")
  TriggerServerEvent("ReturnHouseKeys")
  TriggerServerEvent("requestOffices")
  Wait(500)
  TriggerServerEvent("Police:getMeta")
  -- Anything that might need to wait for the client to get information, do it here.
  Wait(3000)
  TriggerServerEvent("bones:server:requestServer")
  TriggerEvent("apart:GetItems")
  TriggerEvent("np-editor:readyModels")
  Wait(4000)
  TriggerServerEvent('distillery:getDistilleryLocation')
end

function Login.characterSpawned()

  isNear = false
  TriggerServerEvent('np-base:sv:player_control')
  TriggerServerEvent('np-base:sv:player_settings')

  TriggerServerEvent("TokoVoip:clientHasSelecterCharacter")
  TriggerEvent("spawning", false)
  TriggerEvent("inSpawn", false)
  TriggerEvent("attachWeapons")
  TriggerEvent("tokovoip:onPlayerLoggedIn", true)

  exports["np-ui"]:sendAppEvent("hud", { display = true })

  TriggerServerEvent("request-dropped-items")
  TriggerServerEvent("server-request-update", exports["isPed"]:isPed("cid"))
  TriggerServerEvent("stocks:retrieveclientstocks")

  if Spawn.isNew then
      Wait(4000)
      -- commands to make sure player is alive and full food/water/health/no injuries
      local src = GetPlayerServerId(PlayerId())
      TriggerServerEvent("reviveGranted", src)
      TriggerEvent("Hospital:HealInjuries", src, true)
      TriggerServerEvent("ems:healplayer", src)
      TriggerEvent("heal", src)
      TriggerEvent("status:needs:restore", src)

      TriggerServerEvent("np-spawn:newPlayerFullySpawned")
  end
  exports['ragdoll']:SetMaxHealth()
  exports['ragdoll']:SetMaxArmor()
  runGameplay() -- moved from NP-base 
  Spawn.isNew = false
end

RegisterNetEvent("np-spawn:characterSpawned");
AddEventHandler("np-spawn:characterSpawned", Login.characterSpawned)

RegisterNetEvent("np-spawn:getStartingItems");
AddEventHandler("np-spawn:getStartingItems", function(cid, information)
  TriggerServerEvent('server-inventory-give', cid, "idcard", 1, 1, true, information)
	TriggerServerEvent('server-inventory-give', cid, "mobilephone", 2, 1, false, {})
end)

RegisterNetEvent("np-spawn:getNewAccountBox");
AddEventHandler("np-spawn:getNewAccountBox", function(cid)
  TriggerServerEvent('server-inventory-give', cid, "newaccountbox", 3, 1, false, {})
end)

RegisterNetEvent("np-spawn:displayInfo", function()
  SendNUIMessage({
    displayInfo = true,
  })
  TriggerEvent("chatMessage", "SYSTEM", 4, "We should've opened two links in your browser, make sure you read through them both.", "feed", false, { i18n = { "We should've opened two links in your browser, make sure you read through them both" } })
end)
