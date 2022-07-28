local EmployedAt, UpdatedAt = {}, 0
local PermissionCache, RoleCache = {}, {}

function RefreshEmploymentList()
    local characterId = exports['isPed']:isPed('cid')

    local _, employment = RPC.execute("GetEmploymentInformation", { character = { id = characterId } })

    EmployedAt, UpdatedAt = {}, GetGameTimer()

    for _, business in ipairs(employment) do
        if business.code then
            EmployedAt[business.code] = true
        end
    end
end

exports('RefreshEmploymentList', RefreshEmploymentList)

function IsEmployedAt(pBusiness)
    if (GetGameTimer() - UpdatedAt) > 15 * 60000 then RefreshEmploymentList() end

    return EmployedAt[pBusiness] == true
end

exports('IsEmployedAt', IsEmployedAt)

function HasPermission(pBusiness, pPermission)
    if not PermissionCache[pBusiness] then
        PermissionCache[pBusiness] = {}
    end
    if not PermissionCache[pBusiness][pPermission] or (GetGameTimer() - PermissionCache[pBusiness][pPermission].UpdatedAt) > 15 * 60000 then
        local cid = exports["isPed"]:isPed("cid")
        local success = RPC.execute("np-business:hasPermission", pBusiness, pPermission, cid)
        PermissionCache[pBusiness][pPermission] = {
            UpdatedAt = GetGameTimer(),
            hasPermission = success
        }
    end
    return PermissionCache[pBusiness][pPermission].hasPermission
end

exports('HasPermission', HasPermission)

function HasRole(pBusiness, pRole)
    if not RoleCache[pBusiness] then
        RoleCache[pBusiness] = {}
    end

    if not RoleCache[pBusiness][pRole] or (GetGameTimer() - RoleCache[pBusiness][pRole].UpdatedAt) > 15 * 60000 then
        local cid = exports["isPed"]:isPed("cid")
        local success = RPC.execute("np-business:hasRole", pBusiness, pRole, cid)
        RoleCache[pBusiness][pRole] = {
            UpdatedAt = GetGameTimer(),
            hasRole = success
        }
    end

    return RoleCache[pBusiness][pRole].hasRole
end

exports('HasRole', HasRole)

RegisterNetEvent('np-spawn:characterSpawned')
AddEventHandler('np-spawn:characterSpawned', RefreshEmploymentList)

RegisterNetEvent('np-business:employmentStatus')
AddEventHandler('np-business:employmentStatus', function(pBusiness, pEmployed)
    EmployedAt[pBusiness] = pEmployed
end)
