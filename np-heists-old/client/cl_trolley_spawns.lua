function SpawnTrolley(coords, type, heading)
    Citizen.CreateThread(function()
        local trolleys = { `np_prop_ch_cash_trolly_01c`, `np_prop_gold_trolly_01c`, `np_prop_gold_trolly_01c_empty` }
        for _, hash in pairs(trolleys) do
            local clean = true
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
            while clean do
                local trolleyAlreadyExists = GetClosestObjectOfType(coords, 1.0, hash, 0, 0, 0)
                if trolleyAlreadyExists == 0 then
                    clean = false
                else
                    SetEntityAsMissionEntity(trolleyAlreadyExists, 1, 1)
                    Citizen.Wait(0)
                    Sync.DeleteEntity(trolleyAlreadyExists)
                end
            end
        end
        Citizen.Wait(0)
        local spawnHash = `np_prop_ch_cash_trolly_01c`
        if type == "gold" then
            spawnHash = `np_prop_gold_trolly_01c`
        end
        RequestModel(spawnHash)
        while not HasModelLoaded(spawnHash) do
            Citizen.Wait(0)
        end
        local trolley = CreateObject(spawnHash, coords, true, false, false)
        Citizen.Wait(0)
        SetEntityHeading(trolley, heading)
        PlaceObjectOnGroundProperly(trolley)
    end)
end

-- Citizen.CreateThread(function()
--     Citizen.Wait(10000)
--     local trolleys = { `np_prop_ch_cash_trolly_01c`, `np_prop_gold_trolly_01c`, `ch_prop_gold_trolly_empty`, `np_prop_gold_bar_01a` }
--     for _, t in pairs(trolleys) do
--         RequestModel(t)
--     end
--     SpawnTrolley(GetEntityCoords(PlayerPedId()), "cash", 0.0)
-- end)

AddEventHandler("np-heists:grabFromTrolley", function(pArgs, pEntity, p3)
  local coords = GetEntityCoords(pEntity)
  local type = pArgs.type
  if trolleyConfig == nil then
    trolleyConfig = RPC.execute("heists:getTrolleySpawnConfig")
  end
  for loc, conf in pairs(trolleyConfig) do
    local cDist = #(coords - (type == "cash" and conf.cashCoords or conf.goldCoords))
    if cDist < 1 then
      TriggerEvent(conf.cashEvent, loc, type)
    end
  end
end)
