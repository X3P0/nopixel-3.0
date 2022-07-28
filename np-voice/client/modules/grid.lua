local GridSize, EdgeSize = Config.gridSize, Config.gridEdge

local CurrentGrids, PreviousGrid = {}, 0

local deltas = {
    vector2(-1, -1),
    vector2(-1, 0),
    vector2(-1, 1),
    vector2(0, -1),
    vector2(1, -1),
    vector2(1, 0),
    vector2(1, 1),
    vector2(0, 1),
}

function GridToChannel(vectors)
    return (vectors.x << 8) | vectors.y
end

function GetGridChunk(coords)
    return math.floor((coords + 8192) / GridSize)
end

function GetGridChannel(coords, intact)
    local grid = vector2(GetGridChunk(coords.x), GetGridChunk(coords.y))
    local channel = GridToChannel(grid)

    if not intact and CurrentInstance ~= 0 then
        channel = tonumber(("%s0%s"):format(channel, CurrentInstance))
    end

    return channel
end

function GetTargetChannels(coords, edge)
    local targets = {}

    for _, delta in ipairs(deltas) do
        local vectors = vector2(coords.x + delta.x * edge, coords.y + delta.y * edge)
        local channel = GetGridChannel(vectors)

        if not table.exist(targets, channel) then
            table.insert(targets, channel)
        end
    end

    return targets
end

function SetGridChannels(current, previous)
    local toRemove = {}

    for _, grid in ipairs(previous) do
        if not table.exist(current, grid) then
            toRemove[#toRemove + 1] = grid
        end
    end

    AddChannelGroupToTargetList(current, "grid")

    RemoveChannelGroupFromTargetList(toRemove, "grid")

    CurrentGrids = current
end

function LoadGridModule()
    RegisterModuleContext("grid", 0)
    UpdateContextVolume("grid", -1.0)

    Citizen.CreateThread(function()
        while true do
            local idle = 100

            local currentGrid = GetGridChannel(PlayerCoords)
            local edgeGrids = GetTargetChannels(PlayerCoords, EdgeSize)

            if IsDifferent(edgeGrids, CurrentGrids) then
                SetGridChannels(edgeGrids, CurrentGrids)
                Debug("[Grid] Current Grid: %s | Edge: %s", currentGrid, edgeGrids)
            end

            if currentGrid ~= PreviousGrid then
                SetVoiceChannel(currentGrid)
            end

            PreviousGrid = currentGrid

            Citizen.Wait(idle)
        end
    end)

    TriggerEvent("np:voice:grids:ready")

    Debug("[GRID] Module Loaded")
end