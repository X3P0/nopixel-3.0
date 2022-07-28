function Set (list)
  local self = {}
  local size = 0
  local set = {}

  function self.has(value)
    return set[value] ~= nil
  end

  function self.add(value)
    if set[value] ~= nil then return end
    set[value] = true
    size = size + 1
  end

  function self.delete(value)
    if set[value] == nil then return end
    set[value] = nil
    size = size - 1
  end

  function self.clear()
    set = {}
    size = 0
  end

  function self.values()
    local values = {}
    for k, v in pairs(set) do
      values[#values+1] = k
    end
    return values
  end

  function self.forEach(fn)
    for k, v in pairs(set) do
      fn(k)
    end
  end

  function self.filter(fn)
    local newSetList = {}
    for k, v in pairs(set) do
      if fn(k) then newSetList[#newSetList+1] = k end
    end
    return Set(newSetList)
  end

  for _, l in ipairs(list) do
    self.add(l)
  end
  return self
end
