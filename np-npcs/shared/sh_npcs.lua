Generic = {}
Generic.NPCS = {}

Generic.SpawnLocations = {
  -- vector4(620.48, 2752.6, 42.09 - 1.0, 359.94)
  -- vector4(-1605.03,-994.58,7.53 - 1.0,136.79),
  vector4(-278.84,2205.93,129.0,62.05),
}

Generic.ShopKeeperLocations = {
  vector4(-3037.773, 584.8989, 6.97, 30.0),
  vector4(1960.64, 3739.03, 31.50, 321.36),
  vector4(1393.84,3606.8,33.99,172.8),
  vector4(549.01,2672.44,41.16,122.33),
  vector4(2558.39,380.74,107.63,21.54),
  vector4(-1819.57,793.59,137.09,134.3),
  vector4(-1221.26,-907.92,11.3,54.44),
  vector4(-706.12,-914.56,18.22,94.66),
  vector4(24.47,-1348.47,28.5,298.26),
  vector4(-47.36,-1758.68,28.43,50.84),
  vector4(1164.95,-323.7,68.21,101.73),
  vector4(372.19,325.74,102.57,276.17),
  vector4(2678.63,3278.86,54.25,344.4),
  vector4(1727.3,6414.27,34.04,259.1),
  vector4(-160.56,6320.76,30.59,319.99),
  vector4(1165.29,2710.85,37.16,178.47),
  vector4(1697.23,4923.42,41.07,327.94),
  vector4(159.84,6640.89,30.7,242.18),
  vector4(-1486.81,-377.38,39.17,143.01),
  vector4(-3241.1,999.93,11.84,10.23),
  vector4(-2966.38,391.79,14.05,99.55),
  vector4(1134.29,-983.39,45.42,292.7)
}

Generic.LiqourKeeperLocations = {
  vector4(1391.58,3606.06,34.0,201.51),
  vector4(-1820.68,794.97,137.2,125.98),
  vector4(-1222.68,-908.94,11.43,29.89),
  vector4(-705.97,-912.36,18.32,102.93),
  vector4(-45.99,-1757.37,28.53,51.57),
  vector4(1164.72,-322.11,68.3,107.22),
  vector4(-161.89,6322.0,30.69,323.46),
  vector4(1698.77,4922.13,41.15,335.39),
  vector4(-1485.34,-378.72,39.3,144.68),
  vector4(-2966.35,389.86,14.15,91.46),
  vector4(1133.79,-980.99,45.5,281.86),
}

Generic.PaintballVendor = {
  vector4(2382.44,2562.88,58.05,88.29),
  vector4(5509.89,5996.51,589.0,37.98),
}

Generic.GolfVendor = {
  vector4(-1348.45,142.63,55.45,126.68),
}

Generic.ArenaVendor = {
  vector4(5519.99,5996.46,589.02,5.84),
}

Generic.ArenaGrassSwapper = {
  vector4(5507.19,5344.08,603.51,54.56),
  vector4(5515.05,5981.8,589.02,358.09),
}

Generic.CasinoInteriorSwap = {
  vector4(1003.76,73.83,69.08,113.99),
}

Generic.GalleryInteriorSwap = {
  vector4(-490.28,54.97,51.43,222.53),
}

Generic.PaintballSignupNPC = {
  vector4(5517.92,5992.95,589.02,27.97),
}

Generic.MiningVendor = {
  vector4(-599.85,2091.96,130.27,0.64),
}

Generic.HOImportVendor = {
  vector4(1242.46,-3257.42,5.03,299.79),
}

Generic.HOImportDriftVendor = {
  vector4(980.12,-1798.45,17.37,180.0),
}

Generic.CGJewelryVendor = {
  vector4(-703.61,-893.29,18.53,184.82),
}

Generic.SportShopLocations = {
  vector4(-679.46, 5839.32, 16.34, 218.69),
}

Generic.DwDropOffNpc = {
  vector4(-1711.44, -1129.87, 12.2, 138.9),
}

Generic.DwAdminNpc = {
  vector4(-1655.74,-1021.23,12.51,231.32),
}

Generic.DwFoodShitNpc = {
  vector4(-1691.4,-1116.28,12.21,232.65),
}

Generic.DwBumperNpc = {
  vector4(-1634.08,-1083.42,12.4,137.63),
}

Generic.PCAGraders = {
  vector4(-148.51,223.15,94.0,275.46),
}

Generic.CasinoHotelVendor = {
  vector4(902.83,-63.38,19.99,193.34),
}

Generic.XCoinRedeem = {
  vector4(1247.16,-350.01,68.18,349.78),
}

Generic.GangSprayVendor = {
  vector4(-297.91,-1332.56,30.3,291.83),
}

Generic.HNOVendor = {
  vector4(-24.81,-1086.55,25.57,32.39)
}

Generic.CasinoLocations = {
  {
    coords = vector4(966.29,47.52,70.72,145.85), -- coat check
    flags = { "isCasinoMembershipGiver" },
  },
  {
    coords = vector4(1030.35,71.56,68.88,238.32), -- rest room 1
  },
  {
    coords = vector4(1039.24,33.85,68.88,321.23), -- rest room 2
  },
  {
    coords = vector4(963.25,19.07,70.48,276.73), -- jewel store
  },
  {
    coords = vector4(990.79,30.95,70.48,58.76), -- casino chips
    flags = { "isCasinoChipSeller" },
  },
  {
    coords = vector4(988.61,42.97,70.28,201.73), -- wheel of fortune
    npcId = "casino_wheel_spin_npc",
  },
  {
    coords = vector4(978.4,25.39,70.48,43.67), -- drinks bar
    flags = { "isCasinoDrinkGiver" },
  },
}

Generic.WeaponShopLocations = {
  vector4(17.96, -1107.84, 28.8, 157.2),
  vector4(1697.69,3758.14,33.71,137.48),
  vector4(813.52,-2155.55,28.63,355.29),
  vector4(247.1,-51.98,68.95,343.94),
  vector4(840.58,-1029.08,27.2,268.93),
  vector4(-325.93,6081.47,30.46,130.5),
  vector4(-659.01,-939.39,20.83,95.76),
  vector4(-1310.72,-394.55,35.7,343.94),
  vector4(-1112.22,2698.02,17.72,136.31),
  vector4(2564.5,298.57,107.74,273.3),
  vector4(-3167.0,1087.38,19.84,153.13),
}

Generic.ToolShopLocations = {
  vector4(44.838947296143, -1748.5364990234, 28.549386978149, 35.3),
  vector4(2749.2309570313, 3472.3308105469, 54.679393768311, 244.4),
}

Generic.GemShopLocations = {
  vector4(-549.58,-618.83,33.72,178.55),
}

Generic.WeedShopLocations = {
  vector4(1175.49, -437.54, 65.9, 262.06),
}

Generic.FarmersMarketCraftLocations = {
  vector4(-77.55, 6537.4, 30.5, 25.54),
}

Generic.FactoryShopLocations = {
  vector4(-78.55, 6536.4, 30.5, 25.54),
}

Generic.JobVehLocations = {
  vector4(-50.2,-1089.03,25.48,154.36),
}

Generic.WineryBuyLocations = {
  vector4(-1928.02,2060.22,139.85,308.35),
  vector4(-70.6,358.98,111.46,153.51),
}

Generic.LicenseBuyLocations = {
  vector4(-540.57,-191.22,37.23,119.25),
  vector4(-41.81,-206.78,44.79,219.28),
}

Generic.MobilePhoneUsers = {
  vector4(-226.68,-1326.74,30.0,244.83),
  vector4(-225.57,-1331.02,30.0,273.44),
  -- vector4(-1358.93, -759.38, 21.42, 346.47),
  -- vector4(-1360.08, -754.91, 21.42, 221.33),
  -- vector4(-1143.27, -2006.28, 12.3, 86.36),
  -- vector4(-1147.28, -2011.03, 12.3, 23.68),
  -- vector4(-78.66, 369.37, 111.47, 110.52),
  -- vector4(-80.42, 370.55, 111.47, 152.84),
  -- vector4(966.18, -1858.65, 30.1, 63.26),
  -- vector4(966.75, -1855.43, 30.1, 122.86),
}

Generic.LaptopVendors = {
  vector4(-1358.93, -759.38, 21.32, 346.47),
}

Generic.AirXVendors = {
  vector4(-1869.81,2955.22,31.9,324.13),
}

Generic.PantherNPCs = {
  -- vector4(-284.72,6289.79,31.73,132.52),
  vector4(987.42,72.66,115.8,146.86),
}

Generic.PantherKittenNPCs = {
  vector4(-294.45,6289.12,30.5,240.04),
  vector4(-285.76,6291.26,30.5,121.49),
  vector4(-286.17,6278.44,30.5,30.27),
  vector4(-294.12,6276.92,30.5,315.03),
  vector4(-284.72,6289.79,31.73,132.52),
}

Generic.MeowKittenNpcs = {
  vector4(-173.0, 315.09, 93.52, 243.45),
  vector4(-165.81, 294.56, 93.60, 250.12),
  vector4(-163.71, 310.7, 93.65, 18.0),
  vector4(-169.75, 321.6, 87.79, 350.46),
}

Generic.UwuKittenNpcs = {
  vector4(-575.32,-1049.19,22.55,190.37),
  vector4(-567.64, -1051.79, 21.40,133.49),
  vector4(-576.96,-1069.49,22.0,325.93),
  vector4(-574.18,-1057.2,23.2,301.03),
  vector4(-575.31,-1058.29,22.4,309.82),
}

Generic.mrpdK9Npcs = {
  vector4(464.52,-982.92,25.29,273.28),
  vector4(464.52,-982.0,25.29,272.45),
  vector4(464.52,-981.46,25.29,272.62),
  vector4(464.52,-980.77,25.29,280.85),
  vector4(464.55,-980.23,25.29,272.58),
  vector4(464.53,-979.34,25.29,271.2),
  vector4(464.54,-978.61,25.29,272.52),
  vector4(464.54,-977.9,25.29,276.42),
  vector4(464.56,-977.39,25.29,277.6),
}

Generic.vaultDoorClosers = {
  { coords = vector4(-102.51, 6471.83, 30.64, 92.34), id = "paleto" },
}

Generic.PublicLicenseKeepers = {
  {
    id = "pub_townhall",
    model = "a_m_y_bevhills_01",
    location = vector4(-552.97,-192.04,37.22,200.39),
  },
  {
    id = "pub_business",
    model = "a_f_y_hipster_02",
    location = vector4(-551.52,-191.22,37.22,222.99),
  },
}

Generic.VehicleShopKeepersData = {
  {
    id = "bike_shop",
    model = "a_m_y_beach_02",
    location = vector4(-1109.4,-1694.36,3.5,308.3),
  },
  {
    id = "veh_rental",
    model = "a_m_y_business_02",
    location = vector4(110.59,-1090.72,28.31,17.39),
  },
  {
    id = "veh_rental2",
    model = "a_m_y_business_02",
    location = vector4(-248.04,6212.18,30.94,135.09),
  },
  {
    id = "boat_shop",
    model = "s_m_y_grip_01",
    location = vector4(-874.3,-1325.08,0.61,87.95),
  },
  {
    id = "air_shop",
    model = "s_m_y_pilot_01",
    location = vector4(-1620.67,-3151.72,13.0,8.23),
  }
}

Generic.FruitVendorLocations = {
  vector4(1046.134, 695.4771, 157.8547, 57.12),
  vector4(-1379.813, 733.6267, 181.9735, 257.46),
  vector4(2529.108, 2039.341, 18.839, 89.58),
  vector4(1084.706, 6510.557, 20.02, 160.79),
  vector4(-1043.43,5327.29,43.56,38.43),
  vector4(2473.77,4444.67,34.42,184.51),
  vector4(1263.14,3548.11,34.15,199.85),
  vector4(1473.73,2720.56,36.61,179.84),
  vector4(152.6,1669.73,227.67,191.84),
  vector4(-2509.25,3613.74,12.77,126.46),
  vector4(-459.76,2864.08,34.21,212.37),
}

Generic.HeistClubLocations = {
  {
    coords = vector4(-1617.72,-3012.89,-76.2,103.56),
    model = 'mp_m_execpa_01',
    scenario = 'WORLD_HUMAN_GUARD_STAND_FACILITY',
  },
  {
    coords = vector4(-1622.76,-3012.39,-76.2,75.79),
    model = 'mp_f_execpa_02',
    scenario = 'WORLD_HUMAN_STAND_IMPATIENT_CLUBHOUSE',
  },
  {
    coords = vector4(-1610.38,-3018.56,-76.2,255.79),
    model = 's_f_y_movprem_01',
    scenario = 'WORLD_HUMAN_DRINKING',
  },
  {
    coords = vector4(-1634.11,-2996.83,-79.14,248.49),
    model = 'mp_m_weapwork_01',
    scenario = 'WORLD_HUMAN_CLIPBOARD_FACILITY',
  },
  {
    coords = vector4(-1612.22,-3005.6,-76.2,194.42),
    model = 'mp_m_waremech_01',
    scenario = 'WORLD_HUMAN_DRUG_DEALER_HARD',
  },
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "pawnshop",
  name = "Pawn Shop",
  pedType = 4,
  model = "s_m_y_ammucity_01",
  networked = false,
  distance = 200.0,
  position = {
    coords = vector3(0.0, 0.0, 0.0),
    heading = 0.0,
    random = true
  },
  appearance = '{"eyebrow":{"params":[2,0,0.0],"mode":"overlay"},"skinproblem":{"params":[6,0,0.0],"mode":"overlay"},"freckles":{"params":[9,0,0.0],"mode":"overlay"},"badges":{"params":[10,0,0,1],"mode":"component"},"arms":{"params":[3,0,0,1],"mode":"component"},"hat":{"params":[0,-1,-1,1],"mode":"prop"},"beard_color":{"params":[2,0,0,0,0],"mode":"overlaycolor"},"kevlar":{"params":[9,0,0,1],"mode":"component"},"bag":{"params":[5,0,0,1],"mode":"component"},"undershirt":{"params":[8,0,0,1],"mode":"component"},"wrinkles":{"params":[3,0,0.0],"mode":"overlay"},"shoes":{"params":[6,0,0,1],"mode":"component"},"legs":{"params":[4,0,0,1],"mode":"component"},"watch":{"params":[6,-1,-1,1],"mode":"prop"},"haircolor":{"params":[-1,-1],"mode":"haircolor"},"bracelet":{"params":[7,-1,-1,1],"mode":"prop"},"torso":{"params":[11,0,0,1],"mode":"component"},"hair":{"params":[2,0,0,1],"mode":"component"},"glasses":{"params":[1,-1,-1,1],"mode":"prop"},"mask":{"params":[1,0,0,1],"mode":"component"},"beard":{"params":[1,0,0.0],"mode":"overlay"},"accesory":{"params":[7,0,0,1],"mode":"component"},"eyecolor":{"params":[-1],"mode":"eyecolor"},"face":{"params":[0,0,0,1],"mode":"component"},"ears":{"params":[2,-1,-1,1],"mode":"prop"}}',
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true }
  },
  flags = {
      ['isNPC'] = true,
      ['isPawnBuyer'] = true
  }
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "pawnhub_buyer",
  name = "Pawn Shop",
  pedType = 4,
  model = "a_m_m_mlcrisis_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-727.26,-1115.73,9.84),
    heading = 158.07,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true }
  },
  flags = {
      ['isNPC'] = true,
  },
  scenario = "WORLD_HUMAN_SMOKING_CLUBHOUSE"
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "recycle_exchange",
  name = "Recycle Exchange",
  pedType = 4,
  model = "s_m_y_garbage",
  networked = false,
  distance = 150.0,
  position = {
    coords = vector3(-355.76, -1556.04, 24.18),
    heading = 179.96,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true }
  },
  flags = {
      ['isNPC'] = true,
      ['isRecycleExchange'] = true
  }
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "news_reporter",
  name = "News Reporter",
  pedType = 4,
  model = "a_m_m_paparazzi_01",
  networked = false,
  distance = 75.0,
  position = {
    coords = vector3(-593.4407, -928.8674, 22.77718),
    heading = 82.5107192,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true }
  },
  flags = {
      ['isNPC'] = true,
      ['isCommonJobProvider'] = true
  },
  scenario = "WORLD_HUMAN_SMOKING_CLUBHOUSE"
}

-- Generic.NPCS[#Generic.NPCS + 1] = {
--   id = "head_stripper",
--   name = "Head Stripper",
--   pedType = 4,
--   model = "csb_tonya",
--   networked = false,
--   distance = 25.0,
--   position = {
--     coords = vector3(110.98, -1297.22, 28.39),
--     heading = 204.3,
--     random = false
--   },
--   appearance = nil,
--   settings = {
--       { mode = "invincible", active = true },
--       { mode = "ignore", active = true },
--       { mode = "freeze", active = true }
--   },
--   flags = {
--       ['isNPC'] = true,
--       ['isCommonJobProvider'] = true
--   },
--   scenario = "WORLD_HUMAN_SMOKING"
-- }


Generic.NPCS[#Generic.NPCS + 1] = {
  id = "paycheck_banker",
  name = "Bank Account Manager",
  pedType = 4,
  model = "cs_bankman",
  networked = false,
  distance = 25.0,
  position = {
    coords = vector3(269.36,217.15,105.29),
    heading = 71.77,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
      ['isBankAccountManager'] = true
  },
  scenario = "WORLD_HUMAN_CLIPBOARD",
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "paycheck_banker_1",
  name = "Bank Account Manager",
  pedType = 4,
  model = "cs_bankman",
  networked = false,
  distance = 25.0,
  position = {
    coords = vector3(-110.73,6470.04,30.65),
    heading = 221.76,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
      ['isBankAccountManager'] = true
  },
  scenario = "WORLD_HUMAN_CLIPBOARD",
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "fish_market",
  name = "Fish Market",
  pedType = 4,
  model = "ig_chef",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-1507.86,1503.53,114.29),
    heading = 263.28,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "hunting_market",
  name = "Hunting Market",
  pedType = 4,
  model = "ig_chef",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(569.82, 2796.53, 41.04),
    heading = 272.58,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "cocaine_start",
  name = "Cocaine Start",
  pedType = 4,
  model = "s_m_y_garbage",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-1201.2,-266.47,36.95),
    heading = 38.58,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
}



Generic.NPCS[#Generic.NPCS + 1] = {
  id = "digital_den_npc",
  name = "Digital Den",
  pedType = 4,
  model = "a_m_y_stwhi_02",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(1129.42,-476.12,65.5),
    heading = 315.93,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
  scenario = "WORLD_HUMAN_STAND_MOBILE_UPRIGHT"
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "nikez_rollercoaster_worker",
  name = "Mr. Nikez Wild Ride",
  pedType = 4,
  model = "s_m_y_clown_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-1644.95, -1122.45, 17.34),
    heading = 209.71,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
  scenario = "WORLD_HUMAN_SECURITY_SHINE_TORCH"
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "nikez_freefalltower_worker",
  name = "Mr. Nikez Big Tower",
  pedType = 4,
  model = "s_m_m_movspace_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-1649.1, -1113.2, 12.03),
    heading = 237.58,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
  scenario = "WORLD_HUMAN_CAR_PARK_ATTENDANT"
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "rr_hotel_worker",
  name = "Hotel Worker",
  pedType = 4,
  model = "a_f_y_business_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-140.88,306.29,97.48),
    heading = 92.85,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  }
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "rtreat_hotel_worker",
  name = "Hotel Worker",
  pedType = 4,
  model = "u_m_y_hippie_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-1048.22,4919.08,208.37),
    heading = 168.5,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  }
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "casino_hotel_worker",
  name = "Hotel Worker",
  pedType = 4,
  model = "a_f_y_business_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(904.59,-55.32,20.01),
    heading = 313.3,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  }
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "pillbox_icu_worker",
  name = "ICU Worker",
  pedType = 4,
  model = "s_m_m_doctor_01",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(350.95,-584.73,42.29),
    heading = 208.63,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
  scenario = "WORLD_HUMAN_CLIPBOARD"
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "betta_life_craft",
  name = "Betta Life Crafter",
  pedType = 4,
  model = "a_f_m_business_02",
  networked = false,
  distance = 25.0,
  position = {
    coords = vector3(-636.5,295.42,80.65),
    heading = 174.98,
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
  scenario = "WORLD_HUMAN_CLIPBOARD"
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "ron-oil-seller",
  name = "Ron Worker",
  pedType = 4,
  model = "ig_floyd",
  networked = false,
  distance = 25.0,
  position = {
    coords = vector3(1712.99,-1555.77,112.95),
    heading = 252.69,
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
  scenario = "WORLD_HUMAN_CLIPBOARD"
}

Generic.NPCS[#Generic.NPCS + 1] = {
    id = "guild-toycrush",
    name = "Guild Recycler",
    pedType = 4,
    model = "u_m_y_imporage",
    networked = false,
    distance = 25.0,
    position = {
      coords = vector3(-147.13, 218.95, 93.99),
      heading = 269.37,
    },
    appearance = nil,
    settings = {
        { mode = "invincible", active = true },
        { mode = "ignore", active = true },
        { mode = "freeze", active = true },
    },
    flags = {
        ['isNPC'] = true,
    },
    scenario = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"
}

Generic.NPCS[#Generic.NPCS + 1] = {
  id = "parsons_food_vendor",
  name = "Parsons Food Vendor",
  pedType = 4,
  model = "S_F_Y_ClubBar_02",
  networked = false,
  distance = 50.0,
  position = {
    coords = vector3(-1528.88,846.0,180.6),
    heading = 44.41,
    random = false
  },
  appearance = nil,
  settings = {
      { mode = "invincible", active = true },
      { mode = "ignore", active = true },
      { mode = "freeze", active = true },
  },
  flags = {
      ['isNPC'] = true,
  },
}
