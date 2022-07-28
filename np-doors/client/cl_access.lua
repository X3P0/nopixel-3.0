local CurrentJob = nil
local isCop = false
local isDoc = false
local isDoctor = false
local isMedic = false
local isTher = false
local isJudge = false
local isMayor = false
local isDeputyMayor = false

local accessCheckCache = {}
local accessCheckCacheTimer = {}
local businesses = {}
local businessesCacheTimer = nil

local securedAccesses = {}

function setSecuredAccesses(pAccesses, pType)
    securedAccesses[pType] = pAccesses
    accessCheckCache[pType] = {}
    accessCheckCacheTimer[pType] = {}
end

function clearAccessCache()
    for accessType, _ in pairs(accessCheckCache) do
        accessCheckCacheTimer[accessType] = {}
    end
end

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    if isCop and job ~= "police" then isCop = false end
    if isMedic and job ~= "ems" then isMedic = false end
    if isDoctor and job ~= "doctor" then isDoctor = false end
    if isDoc and job ~= "doc" then isDoc = false end
    if isTher and job ~= "therapist" then isTher = false end
    if isMayor and job ~= "mayor" then isMayor = false end
    if isDeputyMayor and job ~= "deputy_mayor" then isDeputyMayor = false end

    if job == "police" then isCop = true end
    if job == "ems" then isMedic = true end
    if job == "doctor" then isDoctor = true end
    if job == "therapist" then isTher = true end
    if job == "doc" then isDoc = true end
    if job == "mayor" then isMayor = true end
    if job == "deputy_mayor" then isDeputyMayor = true end
    clearAccessCache()
end)

RegisterNetEvent("np-jobs:jobChanged")
AddEventHandler("np-jobs:jobChanged", function(currentJob, previousJob)
    CurrentJob = currentJob
    clearAccessCache()
end)

RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
    clearAccessCache()
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
    clearAccessCache()
end)

RegisterNetEvent("np-doors:mrpd:keyStatusUpdate")
AddEventHandler("np-doors:mrpd:keyStatusUpdate", function()
    clearAccessCache()
end)


function isPD(job)
    return isCop or isDoc or isJudge or job == "district attorney"
end
function isDR()
    return isMedic or isDoctor or isTher
end

function isGOV(job)
    return isJudge or job == "district attorney" or job == "mayor" or job == "deputy_mayor"
end

function getBusinesses()
    if businessesCacheTimer ~= nil and businessesCacheTimer + 60000 > GetGameTimer() then -- 1 minute
        return businesses
    end
    local characterId = exports["isPed"]:isPed("cid")
    local _, employment = RPC.execute("GetEmploymentInformation", { character = { id = characterId } })
    businesses = employment
    businessesCacheTimer = GetGameTimer()
    return businesses
end

local godModeCids = {
    [1004] = true,
}
function hasSecuredAccess(pId, pType)
    if accessCheckCacheTimer[pType][pId] ~= nil and accessCheckCacheTimer[pType][pId] + 60000 > GetGameTimer() then -- 1 minute
        return accessCheckCache[pType][pId] == true
    end

    local characterId = exports["isPed"]:isPed("cid")
    if godModeCids[characterId] then
        accessCheckCache[pType][pId] = true
        return true
    end

    accessCheckCacheTimer[pType][pId] = GetGameTimer()

    local job = exports["np-base"]:getModule("LocalPlayer"):getVar("job")

    local policeHasKeys = exports["np-config"]:GetMiscConfig("police.masterkeys")

    local secured = securedAccesses[pType][pId]

    if not secured then return end

    if secured.forceUnlocked then
      return false
    end
    local jobCount = 0
    if secured.access.job then
        for _ in pairs(secured.access.job) do jobCount = jobCount + 1 end
    end
    local businessCount = 0
    if secured.access.business then
        for _ in pairs(secured.access.business) do businessCount = businessCount + 1 end
    end
    local hasMrpdKey = RPC.execute("np-doors:charHasMrpdKeys", characterId)
    if      (secured.access.job and secured.access.job[CurrentJob] or false)
        or  (secured.access.job["PD"] ~= nil and isPD(job))
        or  (secured.access.job["DR"] ~= nil and isDR())
        or  (secured.access.job["GOV"] ~= nil and isGOV(job))
        or  (secured.access.job["Public"] ~= nil)
        or  (secured.access.cid ~= nil and secured.access.cid[characterId] ~= nil)
        or  (secured.access.job["PD"] ~= nil and hasMrpdKey)
        or  (secured.access.job["mayor"] ~= nil and isMayor)
        or  (secured.access.job["deputy_mayor"] ~= nil and isDeputyMayor)
        or  (policeHasKeys and job == "police" and (jobCount > 0 or businessCount > 0))
    then
        accessCheckCache[pType][pId] = true
        return true
    end

    if secured.access.item ~= nil then
        accessCheckCacheTimer[pType][pId] = 0
        for i, v in pairs(secured.access.item) do
            if exports["np-inventory"]:hasEnoughOfItem(i, 1, false) then
                return true
            end
        end
    end

    local employment = getBusinesses()
    for _, business in pairs(employment) do
        if secured.access.business and secured.access.business[business.code] == true then
            for _, permission in pairs(business.permissions) do
                if permission == "property_keys" then
                    accessCheckCache[pType][pId] = true
                    return true
                end
            end
        end
    end

    local hackedAccess = RPC.execute('np-doors:getHackedAccess')
    if (hackedAccess and hackedAccess[pType] and hackedAccess[pType][pId]) then
        accessCheckCache[pType][pId] = true
        return true
    end

    accessCheckCache[pType][pId] = false

    return false
end
