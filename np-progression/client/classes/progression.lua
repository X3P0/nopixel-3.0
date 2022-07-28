Progression = {}

function Progression:new()
    self.__index = self

    return setmetatable({}, self)
end

function Progression:setProgression(pProgression)
    if not type(pProgression) == 'table' then return end

    for key, value in pairs(pProgression) do
        self[key] = value
    end
end

function Progression:updateProgression(pSystem, pExp)
    if not pSystem or not pExp then return end
    self[pSystem] = pExp
end

function Progression:getProgression(pSystem)
    return self[pSystem]
end