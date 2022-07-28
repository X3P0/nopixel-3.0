Cache = {}

function Cache:new()
  local this = {}

  this._entries = {}

  self.__index = self

  return setmetatable(this, self)
end

function Cache:has(pKey, pCheckTTL)
  local cached = self._entries[pKey]

  if cached == nil then return false end

  return (not pCheckTTL) and true or (cached.time + cached.ttl > GetGameTimer())
end

function Cache:get(pKey)
  local cached = self._entries[pKey]

  if cached == nil then return end

  return cached.value
end

function Cache:set(pKey, pValue, pTTL)
  self._entries[pKey] = { value = pValue, ttl = pTTL or 1000, time = GetGameTimer() }
end

function Cache:find(cb)
  for key, cached in pairs(self._entries) do
    if cb(cached.value, key) then return cached.value end
  end
end

function Cache:clear(pKey)
  if not pKey then self._entries = {} end

  self._entries[pKey] = nil
end
