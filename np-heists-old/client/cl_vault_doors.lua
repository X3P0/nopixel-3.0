local doorConfig = nil
local doorEntities = {}
local prevHeadings = {}

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    doorConfig = RPC.execute("heists:getVaultDoorConfig")
    for k, v in pairs(doorConfig) do
      prevHeadings[k] = v.open and v.headingOpen or v.headingClosed
    end
    while true do
        Citizen.Wait(2000)
        for name, conf in pairs(doorConfig) do
            doorEntities[name] = GetClosestObjectOfType(conf.coords, 4.0, conf.hash, 0, 0, 0)
            if doorEntities[name] ~= 0 then
                local heading
                if not prevHeadings[name] then
                  heading = RPC.execute("heists:getDoorHeading", name)
                  prevHeadings[name] = heading
                else
                  heading = prevHeadings[name]
                end
                ChangeDoorHeading(doorEntities[name], heading, 1)
                Citizen.Wait(10000)
            else
                doorEntities[name] = nil
            end
        end
    end
end)

RegisterNetEvent("np-heists:updateDoorStatus")
AddEventHandler("np-heists:updateDoorStatus", function(name, heading, frameCount)
    prevHeadings[name] = heading
    if doorEntities[name] == nil then return end
    ChangeDoorHeading(doorEntities[name], heading, frameCount)
end)

AddEventHandler("np-heists:doors:vaultDoor", function(pParams)
  RPC.execute("heists:vault:changeDoorState", pParams.door, pParams.action == "open")
end)
