local animalModels = {
    "a_c_raccoon_01",
    "a_c_racoon_01",
    "a_c_cat_01",
    "a_c_chop",
    "a_c_husky",
    "a_c_retriever",
    "a_c_rottweiler",
    "a_c_mtlion",
    "a_c_rat",
    "a_c_westy",
    "a_c_pug",
    "a_c_poodle",
    "a_c_cow",
    "a_c_boar",
    "a_c_chickenhawk",
    "a_c_hen",
    "a_c_pig",
    "a_c_shepherd",
    "a_c_shepherd_np",
    "a_c_husky_np",
    "a_c_chop_np",
    "a_c_pit_np",
    "a_c_retriever_np",
    "a_c_panther",
    "a_c_leopard",
    "a_c_coyote",
    "brnbear",
}

local animalModelStringToHash = {}
local animalModelHashToString = {}

for i, modelString in ipairs(animalModels) do
    local modelHash = GetHashKey(modelString)
    animalModelStringToHash[modelString] = modelHash
    animalModelHashToString[modelHash] = modelString
end

function isAnimalModel(modelStringOrHash)
    if type(modelStringOrHash) == "string" then
        return animalModelStringToHash[modelStringOrHash] ~= nil
    else
        return animalModelHashToString[modelStringOrHash] ~= nil
    end
end
exports("isAnimalModel", isAnimalModel)
