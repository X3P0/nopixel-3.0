HiveConfig = {
    --Script automatically splits this into %'s
    HiveObjects = {
        {hash = `np_beehive`, zOffset = 0.0},
        {hash = `np_beehive02`, zOffset = 0.0},
        {hash = `np_beehive03`, zOffset = 0.0},
    },
    -- Bee Growing time in minutes
    GrowthTime = 180,
    -- Plant total lifetime (minutes) from planted -> destroyed
    LifeTime = 1560,
    -- How much faster does a harvest go with a queen
    QueenFactor = 1.3,
    -- Chance of getting a queen bee
    QueenChance = 0.2,
    -- Should having a queen remove hive on harvest?
    RemoveHiveWhenQueen = true,
    -- Percent at which the plant becomes harvestable
    HarvestPercent = 100.0,
    -- Time between plant harvests (minutes)
    TimeBetweenHarvest = 180,
    -- How often should the server update growth from DB, expensive (ms) Set to -1 to disable
    UpdateTimer = 10 * 60 * 1000, -- 10 minutes
}

-- Map material hash -> material type
MaterialHashes = {
  ["-461750719"] = true,
  ["930824497"] = true,
  ["-700658213"] = true,
  ["581794674"] = true,
  ["-2041329971"] = true,
  ["-309121453"] = true,
  ["-913351839"] = true,
  ["-1885547121"] = true,
  ["-1915425863"] = true,
  ["-1833527165"] = true,
  ["2128369009"] = true,
  ["-124769592"] = true,
  ["-840216541"] = true,
  ["-2073312001"] = true,
  ["627123000"] = true,
  ["1333033863"] = true,
  ["-1942898710"] = true,
  ["-1595148316"] = true,
  ["435688960"] = true,
  ["223086562"] = true,
  ["1109728704"] = true,
  ["-1286696947"] = true,
}

HiveZones = {
    -- x, y, z, radius
    {vector3(-1767.42, 2085.61, 190.0), 323.59},
    {vector3(-2647.73, 346.97, 190.0), 274.71},
    {vector3(-2805.30, 928.79, 190.0), 210.28},
    {vector3(-2384.85, 783.33, 190.0), 213.92},
    {vector3(-2206.06, 1454.55, 190.0), 347.85},
    {vector3(-1150.00, 1825.76, 190.0), 251.40},
    {vector3(-1021.21, 1392.42, 190.0), 188.70},
    {vector3(-1366.67, 1148.48, 190.0), 213.26},
    {vector3(440.91, 640.15, 190.0), 119.79},
    {vector3(1663.64, -403.03, 190.0), 280.02},
    {vector3(2118.18, -250.00, 190.0), 179.33},
    {vector3(2250.00, -1109.09, 190.0), 246.32},
    {vector3(2206.06, -1727.27, 300.0), 356.77},
    {vector3(1948.48, -2254.55, 190.0), 215.32},
}