function Cacheable(getValueCb, options)
  local key = 1
  local map = CacheableMap(function (ctx, _, ...)
    return getValueCb(ctx, ...)
  end, options)

  return {
    get = function (...) return map.get(key, ...) end,
    reset = function () map.reset(key) end
  }
end

function CacheableMap(getValueCb, options)
  local self = {}
  local ttl = options.timeToLive or 60000
  local cachedValues = {}

  local function ensureCachedValue(key, ...)
    local cachedValue = cachedValues[key]
    if cachedValue == nil then
      cachedValue = { value = nil, lastUpdated = 0 }
      cachedValues[key] = cachedValue
    end

    local now = GetGameTimer()
    if cachedValue.lastUpdated == 0 or now - cachedValue.lastUpdated > ttl then
      local shouldCache, value = getValueCb(cachedValue, key, ...)
      if shouldCache then
        cachedValue.lastUpdated = now
        cachedValue.value = value
      end
      return value
    end

    return cachedValue.value
  end

  function self.get(key, ...)
    return ensureCachedValue(key, ...)
  end

  function self.reset(key)
    local cachedValue = cachedValues[key]
    if cachedValue ~= nil then cachedValue.lastUpdated = 0 end
  end

  return self
end
