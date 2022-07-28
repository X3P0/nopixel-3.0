local currentTarget = nil
local currentTargetCoords = nil
local currentTargetModel = nil

local function addStress(count)
  Citizen.CreateThread(function()
    Citizen.Wait(200)
    TriggerEvent("client:newStress", true, 750 * count)
  end)
end

local function loopSkill(count)
    local loopCount = 0
    while loopCount < count do
        Wait(100)
        loopCount = loopCount + 1
        local finished = exports["np-ui"]:taskBarSkill(math.random(1400, 5000), math.random(7, 12))
        if finished ~= 100 then
            addStress(math.max(1, loopCount))
            return false
        end
    end
    addStress(loopCount)
    return true
end

local skilling = false
local function breakInToRegister()
    skilling = true
    local registerId = string.format("%.2f", currentTargetCoords.x) .. "_"
      .. string.format("%.2f", currentTargetCoords.y) .. "_"
      .. string.format("%.2f", currentTargetCoords.z)
    local message = RPC.execute("heists:canRobRegister", registerId)
    if message ~= nil then
        TriggerEvent("DoLongHudText", message, 2)
        skilling = false
        return
    end

    TriggerEvent("civilian:alertPolice", 8.0, "robberyhouseMansion", 0)
    -- TriggerServerEvent("police:camrobbery", storeid)

    TaskTurnPedToFaceEntity(PlayerPedId(), currentTarget, -1)
    Wait(1000)
    ClearPedTasksImmediately(PlayerPedId())
    Wait(0)

    local skillResult = loopSkill(5)
    if not skillResult then
        skilling = false
        return
    end
    skilling = false
    TriggerServerEvent("complete:job", math.random(100, 150), 'h')
end

AddEventHandler("np-heists:breakInToRegister", function(pArgs, pEntity)
  currentTarget = pEntity
  currentTargetCoords = GetEntityCoords(pEntity)
  breakInToRegister()
end)

Citizen.CreateThread(function()
  exports["np-interact"]:AddPeekEntryByModel({ 303280717 }, {{
    event = "np-heists:breakInToRegister",
    id = "np-heists:breakInToRegister",
    icon = "hammer",
    label = "Smash!",
    parameters = {},
  }}, {
    distance = { radius = 1.0 },
    isEnabled = function(pEntity)
      return GetObjectFragmentDamageHealth(pEntity, true) < 1.0 and not skilling
    end,
  })
end)
