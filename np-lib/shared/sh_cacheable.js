function Cacheable(getValueCb, options) {
  const key = '_';
  const map = CacheableMap((ctx, _, ...args) => {
    return getValueCb(ctx, ...args);
  }, options);

  function getCachedValue(...args) {
    return map(key, ...args);
  }

  getCachedValue.reset = function() {
    map.reset(key);
  }

  return getCachedValue;
}

function CacheableMap(getValueCb, options) {
  const ttl = options.timeToLive || 60000;
  const cachedValues = {};

  async function ensureCachedValue(key, ...args) {
    let cachedValue = cachedValues[key];
    if (!cachedValue) {
      cachedValue = { value: null, lastUpdated: 0 };
      cachedValues[key] = cachedValue;
    }

    const now = Date.now();
    if (cachedValue.lastUpdated === 0 || now - cachedValue.lastUpdated > ttl) {
      const [shouldCache, value] = await getValueCb(cachedValue, key, ...args);
      if (shouldCache) {
        cachedValue.lastUpdated = now
        cachedValue.value = value
      }
      return value;
    }

    return cachedValue.value;
  }

  async function getCachedValue(key, ...args) {
    return await ensureCachedValue(key, ...args);
  }

  getCachedValue.reset = function(key) {
    const cachedValue = cachedValues[key];
    if (cachedValue) cachedValue.lastUpdated = 0;
  }

  return getCachedValue;
}
