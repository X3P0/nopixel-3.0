local Licenses = CacheableMap(function (ctx, pCharacterId)
    local success, message = RPC.execute("GetLicenses", pCharacterId)
    if not success then return false, nil end

    local licenses = {}
    for _, license in ipairs(message) do
        local id = license.name:gsub(" ", "_"):lower()
        licenses[id] = true
    end

    return true, licenses
end, { timeToLive = 15 * 60 * 1000 })

function HasLicense(pLicense, pCharacterId)
    local characterId = not pCharacterId and exports["isPed"]:isPed("cid") or pCharacterId

    local licenses = Licenses.get(characterId)

    if licenses == nil then return false end

    return licenses[pLicense] == true
end
exports("HasLicense", HasLicense)

function resetLicensesCache(pCharacterId)
    Licenses.reset(pCharacterId)
end
