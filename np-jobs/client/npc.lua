local NPCs = {}

local Created = false

function GetNPCJobData(pId)
    for jobId, data in pairs(NPCs) do
        local id = GetHashKey(jobId)

        if id == pId then
           return {id = jobId}
        end
    end
end

exports('GetNPCJobData', GetNPCJobData)

AddEventHandler('np:jobs:createNPCs', function(pNPCs)
    if not Created then
        Created = true

        for _, npc in ipairs(pNPCs) do
            local vectors = npc.headquarters
            npc.data.id = npc.jobid
            npc.data.position = {
              coords = vector3(vectors.x, vectors.y, vectors.z - 1.0),
              heading = vectors.h or 0.0
            }
            npc.data.position.heading = npc.data.position.heading
            NPCs[npc.jobid] = exports["np-npcs"]:RegisterNPC(npc.data, 'np-jobs')
        end
    end
end)

local NPCsPool = {}

RegisterNetEvent('np-jobs:npc:added')
AddEventHandler('np-jobs:npc:added', function(pSpawn)
    local data = pSpawn

    local vectors = data.position.coords

    data.position.coords = vector3(vectors.x, vectors.y, vectors.z)

    NPCsPool[data.id] = exports["np-npcs"]:RegisterNPC(data, 'np-jobs')
end);

RegisterNetEvent('np-jobs:npc:edited')
AddEventHandler('np-jobs:npc:edited', function(pId, pVectors, pHeading)
    local coords = vector3(pVectors.x, pVectors.y, pVectors.z)
    local heading = pHeading + 0.0

    local position = { coords = coords, heading = heading}

    exports["np-npcs"]:UpdateNPCData(pId, 'position', position)
end);

RegisterNetEvent('np-jobs:npc:removed')
AddEventHandler('np-jobs:npc:removed', function(pId)
    exports["np-npcs"]:RemoveNPC(pId)
end);

Citizen.CreateThread(function()
    Citizen.Wait(2000)

    local npcs = RPC.execute('np-jobs:npc:getNPCs')

    for _, npc in ipairs(npcs) do
        local data = npc

        local vectors = data.position.coords

        data.position.coords = vector3(vectors.x, vectors.y, vectors.z)

        NPCsPool[data.id] = exports["np-npcs"]:RegisterNPC(data, 'np-jobs')
    end
end)