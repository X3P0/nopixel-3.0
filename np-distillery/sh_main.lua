distilleryLocations = {
    vector3(2464.53, 3446.9, 49.89),
}

batchRequirements = {
    ["fruit"] = {
        count = 1, -- 50,
        validIngredients = {
            "apple",
            "banana",
            "cherry",
            "coconut",
            "grapes",
            "kiwi",
            "lemon",
            "lime",
            "orange",
            "peach",
            "potato",
            "strawberry",
            "watermelon"
        }
    },
    ["water"] = {
        count = 1, -- 50,
        validIngredient = "water"
    },
    ["potato"] = {
        count = 1, -- 25,
        validIngredient = "potato"
    },
    ["grain"] = {
        count = 1, -- 25,
        validIngredient = "grain"
    }
}

stages = {
    [0] = {name = "Awaiting mash", timeToProcess = 0},
    [1] = {name = "Fermenting", timeToProcess = 1800, maximumOverdue = math.random(300, 900)},
    [2] = {name = "Brewing", timeToProcess = 1200, maximumOverdue = math.random(300, 900)},
    [3] = {name = "Distilling", timeToProcess = 1050, maximumOverdue = math.random(60, 300)},
    [4] = {name = "Bottling", timeToProcess = 200, maximumOverdue = math.random(60, 300)}
}

distilleryProp = `prop_still`

function tablelength(pTable)
    local count = 0
    for _ in pairs(pTable) do count = count + 1 end
    return count
end

