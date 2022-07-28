AddEventHandler('np-business:tattoo:sitChair', function(pParameters, pEntity, pContext)
    local sitType = pParameters.sitType
    local animDict, animName
    local coords, rotation
    if sitType == "tattooist" then
        animDict = "misstattoo_parlour@shop_ig_4"
        animName = "tattooist_loop"
        coords = vector3(323.75, 182.12, 102.59)
        rotation = vector3(0.0, 0.0, 0.0)
    end
    if sitType == "upright" then
        animDict = "misstattoo_parlour@shop_ig_4"
        animName = "customer_loop"
        coords = vector3(323.37, 181.86, 102.59)
        rotation = vector3(0.0, 0.0, 0.0)
    end
    if sitType == "laying" then
        animDict = "anim@gangops@morgue@table@"
        animName = "body_search"
        coords = vector3(325.73, 180.53, 101.92)
        rotation = vector3(0.0, 0.0, 140.0)
    end
    loadAnimDict(animDict)
    TaskPlayAnimAdvanced(PlayerPedId(), animDict, animName, coords, rotation, 8.0, -8.0, -1, 7689, 0.0, 2, 0)
end)
  
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end
