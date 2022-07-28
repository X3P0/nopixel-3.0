local jobs = {
  ["police"] = true,
  ["doctor"] = true,
  ["doc"] = true,
  ["district attorney"] = true,
  ["judge"] = true,
  ["defender"] = true,
  ["mayor"] = true,
  ["county_clerk"] = true
}
function hasMdwAccess()
  local cj = exports["police"]:getCurrentJob()
  return jobs[cj] == true
end

local apartmentData = CacheableMap(function (ctx, cid)
  local result = RPC.execute("apartment:search", cid)
  return true, result
end, { timeToLive = 5 * 60 * 1000 })

local housingData = CacheableMap(function (ctx, cid)
  local result = RPC.execute("housing:search", cid)
  return true, result
end, { timeToLive = 5 * 60 * 1000 })

function LoadAnimationDic(dict)
  if not HasAnimDictLoaded(dict) then
      RequestAnimDict(dict)

      while not HasAnimDictLoaded(dict) do
          Citizen.Wait(0)
      end
  end
end

local function playAnimation()
  LoadAnimationDic("amb@code_human_in_bus_passenger_idles@female@tablet@base")
  TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
  TriggerEvent("attachItemPhone", "tablet01")
end

RegisterUICallback("np-ui:mdtAction", function(data, cb)
  local result = RPC.execute("np-ui:mdtApiRequest", data)
  cb({ data = result.message, meta = { ok = result.success, message = result.message } })
end)

RegisterUICallback("np-mdt:getVehiclesByCharacterId", function(data, cb)
  local data = RPC.execute("np:vehicles:getPlayerVehicles", data.character.id, true)
  cb({ data = data, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-mdt:getPlayerOnlineStatus", function(data, cb)
  local data = RPC.execute("np-mdt:isPlayerOnline", data.character.id, true)
  cb({ data = data, meta = { ok = true, message = 'done' } })
end)

AddEventHandler("np-ui:openMDW", function(data)
  if not hasMdwAccess() and not data.fromCmd and not data.publicApp then return end
  playAnimation()
  exports["np-ui"]:openApplication("mdt", { publicApp = data.publicApp or false })
end)

AddEventHandler("np-ui:application-closed", function(name)
  if name ~= "mdt" then return end
  StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 1.0)
  TriggerEvent("destroyPropPhone")
  SetPlayerControl(PlayerId(), 1, 0)
end)

RegisterUICallback("np-ui:getHousingInformation", function(data, cb)
  local result = housingData.get(data.profile.id)
  cb({ data = result or {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:getApartmentInformation", function (data, cb)
  local result = apartmentData.get(data.profile.id)
  cb({ data = result or {}, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-mdt:getUnitInformation", function (data, cb)
  local result = RPC.execute("np-dispatch:getDispatchUnits")
  cb({ data = result, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:getHousingData", function (data, cb)
  local houses = exports["np-housing"]:retrieveHousingTableMapped()
  cb({ data = houses, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-ui:getPropertyOwner", function (data, cb)
  local owner = RPC.execute("property:getOwnerRaw", data.property_id)
  cb({ data = owner, meta = { ok = true, message = 'done' } })
end)

RegisterUICallback("np-mdt:setPropertyGps", function (data, cb)
  SetNewWaypoint(data.x, data.y)
  TriggerEvent("DoLongHudText", "GPS updated.")
  cb({ data = "ok", meta = { ok = true, message = 'done' } })
end)

-- Citizen.CreateThread(function()
--   TriggerEvent("np-props:attachProp", "cg_chain", 10706, -0.01, 0.01, -0.06, 184.0, -197.0, 4.0, true)
--   Wait(5000)
--   TriggerEvent("np-props:removeProp")


--   -- for i = 1, 360 do
--   --   Wait(500)
--   --   TriggerEvent("np-props:attachProp", "cg_chain", 10706, 0.0, 0.04, -0.07, 180.0, 204.0, 0.0, true)
--   --   Wait(500)
--   --   TriggerEvent("np-props:removeProp")
--   -- end
-- end)

-- local lectric = {
--   vector3(524.9405, -948.0657, 18.6399),
--   vector3(515.0673, -937.8958, 17.83497),
--   vector3(514.353, -905.6516, 15.50349),
--   vector3(535.4138, -753.0974, 14.51308),
--   vector3(-137.7583, -556.1981, 39.54307),
--   vector3(-172.1306, -562.2589, 39.54307),
--   vector3(-123.2088, -639.6454, 35.12309),
--   vector3(-78.90955, -657.1072, 35.11141),
--   vector3(-79.44371, -658.5748, 35.11141),
--   vector3(-90.70449, -689.5135, 33.94975),
--   vector3(41.71194, -668.6475, 30.62794),
--   vector3(43.21358, -669.194, 30.62794),
--   vector3(114.1129, -631.9166, 261.9098),
--   vector3(115.2234, -624.9423, 257.21),
--   vector3(147.7588, -649.2902, 249.2099),
--   vector3(-360.8019, -802.5704, 30.60377),
--   vector3(-360.8019, -800.9844, 30.60377),
--   vector3(323.6537, -1088.57, 60.04426),
--   vector3(320.2783, -1106.793, 38.43858),
--   vector3(-209.613, -868.2226, 28.53597),
--   vector3(-73.32379, -810.9537, 320.3517),
--   vector3(-78.79871, -823.1952, 320.3265),
--   vector3(-135.9006, -1127.951, 23.91702),
--   vector3(-245.4065, -705.6628, 32.62333),
--   vector3(-334.1697, -646.3376, 31.36291),
--   vector3(-71.5967, -619.5812, 35.20375),
--   vector3(-35.54195, -721.6581, 31.98465),
--   vector3(-33.72903, -722.337, 31.98465),
--   vector3(492.1007, -761.9399, 23.92799),
--   vector3(401.8336, -670.595, 28.17114),
--   vector3(392.6104, -998.5456, 28.30785),
--   vector3(420.1104, -1125.136, 28.32102),
--   vector3(360.3031, -1034.583, 28.30785),
--   vector3(494.0838, -937.6074, 25.86209),
--   vector3(83.24735, 82.66689, 77.71425),
--   vector3(108.6604, 66.3387, 72.41602),
--   vector3(109.2149, 33.16456, 72.54869),
--   vector3(228.8993, -111.9779, 68.83791),
--   vector3(192.1033, -222.5725, 53.01334),
--   vector3(69.24081, -208.713, 52.4723),
--   vector3(103.3589, -159.4847, 53.77262),
--   vector3(161.4824, -140.0869, 56.27011),
--   vector3(34.797, -59.6622, 62.71234),
--   vector3(-5.126099, -98.53345, 56.49165),
--   vector3(-40.9892, -136.3239, 56.36938),
--   vector3(178.4037, -202.1725, 53.5376),
--   vector3(301.9469, -51.83564, 70.00639),
--   vector3(439.2056, -65.20992, 72.76921),
--   vector3(448.3371, -126.915, 62.87174),
--   vector3(309.8436, -240.5913, 53.20332),
--   vector3(484.2688, -277.1034, 46.28467),
--   vector3(213.6024, -336.5604, 42.99303),
--   vector3(210.9003, -361.1882, 43.00615),
--   vector3(286.4787, -443.7938, 42.65997),
--   vector3(-35.68524, -416.1487, 38.59534),
--   vector3(49.66235, -302.4087, 46.41202),
--   vector3(133.147, -439.6916, 40.02711),
--   vector3(44.04251, -15.43634, 68.39767),
--   vector3(-57.53046, 16.50841, 71.1258),
--   vector3(-11.20807, 100.9183, 78.58337),
--   vector3(408.8114, 224.5704, 102.1506),
--   vector3(262.0213, 309.2622, 104.4837),
--   vector3(219.9493, 298.2055, 104.5901),
--   vector3(204.2726, 237.5462, 104.5816),
--   vector3(481.0489, 262.2046, 102.0851),
--   vector3(227.4514, 345.3747, 104.5289),
--   vector3(408.0374, 133.8128, 100.6371),
--   vector3(534.6703, 65.26382, 95.1566),
--   vector3(757.9227, -2528.507, 18.74163),
--   vector3(675.502, -2476.831, 18.93028),
--   vector3(880.5746, -2445.906, 27.57397),
--   vector3(753.2841, -1762.5, 28.31946),
--   vector3(847.8398, -1424.11, 27.18689),
--   vector3(979.3859, -1453.96, 30.5802),
--   vector3(807.479, -1717.594, 28.2998),
--   vector3(824.4061, -1892.425, 28.24254),
--   vector3(934.3079, -1774.136, 30.12304),
--   vector3(1190.865, -1719.537, 34.32092),
--   vector3(1075.287, -2118.523, 31.6134),
--   vector3(1022.675, -2427.437, 27.74506),
--   vector3(901.1174, -1263.07, 24.80707),
--   vector3(947.8237, -1240.557, 24.9053),
--   vector3(948.9352, -1242.145, 24.9053),
--   vector3(959.6852, -1259.817, 37.86929),
--   vector3(958.0977, -1260.929, 37.86929),
--   vector3(870.9024, -1262.566, 25.81952),
--   vector3(868.7805, -1258.889, 25.80062),
--   vector3(869.8006, -1260.676, 25.80062),
--   vector3(709.2408, -649.9523, 26.21461),
--   vector3(726.4063, -755.1937, 24.52643),
--   vector3(724.1728, -711.8865, 25.60441),
--   vector3(727.2725, -803.5124, 23.95568),
--   vector3(811.2889, -1080.074, 27.58617),
--   vector3(843.1461, -1076.422, 26.95303),
--   vector3(878.9268, -994.9818, 30.81562),
--   vector3(779.5327, -1200.486, 26.17675),
--   vector3(876.4081, -1075.31, 28.43704),
--   vector3(781.987, -1290.634, 25.29919),
--   vector3(810.2219, -1330.289, 25.22485),
--   vector3(810.112, -1372.77, 25.61181),
--   vector3(759.2772, -589.3846, 29.28088),
--   vector3(764.531, -547.0781, 32.14388),
--   vector3(759.0349, -516.7816, 34.18139),
--   vector3(758.4452, -789.4112, 25.47173),
--   vector3(788.0098, -890.2935, 24.11987),
--   vector3(787.9271, -871.9151, 24.22128),
--   vector3(986.4458, -1041.266, 40.36784),
--   vector3(903.7462, -1079.952, 31.27994),
--   vector3(1239.738, -1199.42, 35.57791),
--   vector3(1087.378, -266.0095, 68.34834),
--   vector3(1086.471, -267.4633, 68.34834),
--   vector3(11.13077, -2575.071, 5.059277),
--   vector3(-93.86891, -2562.125, 5.13987),
--   vector3(797.9611, -2972.529, 5.030853),
--   vector3(-353.1107, -2157.31, 9.345592),
--   vector3(-204.944, -2202.792, 9.326275),
--   vector3(454.2884, -1858.542, 26.86235),
--   vector3(471.6678, -1858.504, 26.6757),
--   vector3(562.2113, -1583.776, 27.26527),
--   vector3(-66.27235, -1714.538, 28.51319),
--   vector3(-69.81062, -1802.646, 26.63732),
--   vector3(-144.0666, -1781.529, 28.88113),
--   vector3(-19.19115, -1810.509, 25.59857),
--   vector3(-6.033966, -1837.77, 23.98142),
--   vector3(-32.29701, -1721.795, 28.26362),
--   vector3(-151.3799, -1707.067, 29.45517),
--   vector3(-320.4227, -1612.492, 19.62056),
--   vector3(-59.90556, -1355.019, 28.38462),
--   vector3(-37.83604, -1575.964, 28.34027),
--   vector3(-124.9395, -1503.176, 32.98799),
--   vector3(-96.4649, -1512.4, 32.71771),
--   vector3(-91.94992, -1531.083, 32.63531),
--   vector3(-57.08794, -1608.005, 28.21543),
--   vector3(-57.20486, -1622.819, 28.29774),
--   vector3(66.99422, -1529.536, 28.18197),
--   vector3(137.9446, -1604.594, 28.2846),
--   vector3(349.1656, -1557.79, 28.29158),
--   vector3(523.5858, -1310.271, 29.01161),
--   vector3(353.3286, -1350.699, 31.35377),
--   vector3(404.8825, -1400.931, 28.52113),
--   vector3(513.9843, -1418.352, 28.20576),
--   vector3(529.1992, -1398.423, 28.29156),
--   vector3(414.1779, -1573.287, 28.29652),
--   vector3(451.8463, -1604.493, 28.26502),
--   vector3(81.15456, -1697.078, 28.29065),
--   vector3(119.6281, -1749.972, 27.96024),
--   vector3(287.5279, -1686.968, 28.33159),
--   vector3(341.7781, -1744.374, 28.25233),
--   vector3(315.4013, -1692.857, 28.33406),
--   vector3(272.1906, -1893.694, 25.68135),
--   vector3(216.4913, -1900.604, 23.60658),
--   vector3(312.9127, -1870.123, 25.89445),
--   vector3(320.9668, -1834.624, 26.18329),
--   vector3(99.66227, -1925.002, 19.68919),
--   vector3(76.04298, -1895.861, 20.86105),
--   vector3(90.95602, -1878.449, 22.59111),
--   vector3(122.4293, -1812.5, 26.13049),
--   vector3(447.4158, -1832.209, 26.94838),
--   vector3(484.6132, -1835.022, 26.65999),
--   vector3(540.3502, -1717.093, 28.29104),
--   vector3(569.4902, -1847.752, 23.68042),
--   vector3(528.3516, -1886.218, 24.50407),
--   vector3(604.9923, -1765.091, 20.6873),
--   vector3(475.1816, -1670.779, 28.19138),
--   vector3(400.087, -1781.472, 28.13673),
--   vector3(466.3912, -2039.382, 23.58144),
--   vector3(299.5403, -1988.361, 20.34504),
--   vector3(-346.972, -268.6862, 32.14147),
--   vector3(-188.755, 228.2344, 89.52177),
--   vector3(-188.755, 226.5349, 89.52177),
--   vector3(-145.9381, 215.7007, 93.78464),
--   vector3(-131.5342, 215.7007, 93.78464),
--   vector3(-65.55302, 86.17006, 70.61545),
--   vector3(-703.7408, 315.8156, 82.10658),
--   vector3(-615.2635, 323.9262, 81.26257),
--   vector3(-567.0995, 297.9871, 82.07278),
--   vector3(-572.3262, 311.1165, 83.54437),
--   vector3(-543.2612, 319.2398, 82.02814),
--   vector3(-603.3556, 322.8773, 81.26257),
--   vector3(-622.3666, 322.0442, 81.26257),
--   vector3(-512.9926, 287.2095, 82.32957),
--   vector3(-512.324, 294.851, 82.32957),
--   vector3(-490.6313, 299.1601, 82.80617),
--   vector3(-464.6337, 296.825, 82.41427),
--   vector3(-424.4534, 285.8699, 82.26019),
--   vector3(-449.6082, 287.8608, 82.41785),
--   vector3(-447.0191, 287.5887, 82.3946),
--   vector3(-439.4661, 297.3864, 82.39961),
--   vector3(-463.553, 289.0739, 82.45671),
--   vector3(-464.1216, 282.5741, 82.45554),
--   vector3(-299.9258, 285.6218, 88.88774),
--   vector3(-299.9258, 283.812, 88.88774),
--   vector3(-285.4709, 303.5109, 89.7429),
--   vector3(-281.0116, 303.5109, 89.7429),
--   vector3(-293.644, 303.5109, 89.7429),
--   vector3(-273.6245, 303.5109, 89.7429),
--   vector3(-266.571, 283.8131, 89.50277),
--   vector3(-266.571, 285.6229, 89.50277),
--   vector3(-264.5558, 292.1306, 89.73808),
--   vector3(-264.5558, 286.307, 89.73808),
--   vector3(-187.3828, 287.1943, 92.14452),
--   vector3(-187.3828, 288.9567, 92.14452),
--   vector3(-387.6642, 135.0822, 64.61845),
--   vector3(-533.2856, 25.32318, 43.49678),
--   vector3(-525.584, -15.06162, 43.37486),
--   vector3(-561.2326, 143.8012, 62.00802),
--   vector3(-728.6255, 214.4257, 75.70321),
--   vector3(-679.1675, 117.191, 55.69088),
--   vector3(18.77359, 281.2048, 108.528),
--   vector3(17.1763, 280.2453, 108.528),
--   vector3(-211.5332, 84.05341, 67.49546),
--   vector3(-266.8956, -5.664198, 49.33968),
--   vector3(-289.006, -50.97397, 48.11608),
--   vector3(-283.6739, 116.0264, 67.44217),
--   vector3(-264.6027, 251.0756, 89.65747),
--   vector3(-190.6567, -85.39041, 50.93763),
--   vector3(-298.3605, -154.4686, 40.22432),
--   vector3(-342.2564, -206.7617, 36.99535),
--   vector3(-339.4485, -283.5468, 31.15225),
--   vector3(-254.473, -103.6603, 46.24265),
--   vector3(-364.8601, -293.989, 32.07014),
--   vector3(-281.174, -273.264, 31.05838),
--   vector3(-527.2322, -67.79264, 39.61486),
--   vector3(-432.3617, -223.8416, 35.23677),
--   vector3(-405.7597, -207.958, 35.18587),
--   vector3(-525.1893, -94.39702, 38.52356),
--   vector3(-501.4678, -109.2116, 38.05917),
--   vector3(-469.6319, -151.702, 37.21592),
--   vector3(-445.7262, -191.6695, 36.02238),
--   vector3(-466.3108, -184.5019, 36.68819),
--   vector3(-422.0392, -267.1713, 35.26277),
--   vector3(-755.6334, -2548.818, 12.88754),
--   vector3(-930.3848, -3063.208, 13.00054),
--   vector3(-931.262, -3064.727, 13.00054),
--   vector3(-932.1391, -3066.246, 13.00054),
--   vector3(-825.4758, -2915.146, 13.00054),
--   vector3(-797.5421, -2888.059, 13.00054),
--   vector3(-824.5742, -2913.584, 13.00054),
--   vector3(-1272.12, -2454.113, 72.10794),
--   vector3(-1274.693, -2444.849, 72.06002),
--   vector3(-1277.726, -2450.103, 72.06002),
--   vector3(-1278.574, -2449.613, 57.42395),
--   vector3(-1270.02, -2445.953, 31.60123),
--   vector3(-963.8627, -2618.205, 13.04117),
--   vector3(-863.1286, -2398.321, 13.08264),
--   vector3(-889.886, -2388.28, 13.08234),
--   vector3(-924.3241, -2490.919, 13.60383),
--   vector3(-945.3538, -2524.415, 13.57493),
--   vector3(-905.8119, -2549.06, 13.55834),
--   vector3(-762.1432, -223.2623, 36.29606),
--   vector3(-765.2499, -217.8814, 36.29606),
--   vector3(-783.3033, -177.5196, 36.20939),
--   vector3(-784.7828, -178.3745, 36.20939),
--   vector3(-679.8112, -175.2343, 36.70309),
--   vector3(-678.9955, -176.6471, 36.70309),
--   vector3(-592.4896, -283.6614, 49.33864),
--   vector3(-608.2154, -244.264, 49.24928),
--   vector3(-741.3256, 284.1058, 84.19623),
--   vector3(-613.3748, -942.7608, 20.981),
--   vector3(-591.2917, -888.2327, 24.90358),
--   vector3(-591.2917, -886.6397, 24.90358),
--   vector3(-518.8012, -860.2641, 28.98489),
--   vector3(-536.812, -871.7574, 26.17072),
--   vector3(-550.0748, -872.655, 26.20372),
--   vector3(-564.0581, -872.0089, 25.71159),
--   vector3(-540.0164, -873.3962, 26.17072),
--   vector3(-728.8471, -1113.604, 10.37524),
--   vector3(-542.3519, -1337.75, 23.68631),
--   vector3(-521.4208, -1284.323, 25.00846),
--   vector3(-522.3359, -1286.504, 25.00846),
--   vector3(-674.4308, -1453.034, 9.278343),
--   vector3(-501.0222, -1798.968, 20.98287),
--   vector3(-643.2471, -1662.687, 24.3196),
--   vector3(-584.2477, -1712.812, 22.21338),
--   vector3(-915.5661, -1789.187, 18.75102),
--   vector3(-793.0303, -1626.391, 14.30959),
--   vector3(-829.3319, -1697.349, 17.57988),
--   vector3(-394.0507, -1806.408, 20.74777),
--   vector3(-338.4418, -1844.018, 22.43289),
--   vector3(-315.5595, -1809.835, 23.78756),
--   vector3(-170.5986, -2119.965, 23.8427),
--   vector3(-48.68243, -2055.101, 19.92376),
--   vector3(-111.7175, -1962.636, 20.23175),
--   vector3(-405.9021, -1867.106, 19.10348),
--   vector3(-225.0469, -1833.003, 29.08993),
--   vector3(-399.9381, -2147.263, 9.345573),
--   vector3(-634.9458, -1806.87, 22.9897),
--   vector3(-516.9698, -2140.246, 8.132702),
--   vector3(-459.22, -1876.775, 17.57833),
--   vector3(-620.0228, -1996.761, 5.31752),
--   vector3(-537.8774, -2084.438, 7.086521),
--   vector3(-435.9895, -1764.358, 19.55196),
--   vector3(-1901.252, -314.7227, 48.35423),
--   vector3(-1857.521, -600.2432, 10.66482),
--   vector3(-1838.043, -611.0203, 10.38279),
--   vector3(-1856.298, -632.7759, 10.06116),
--   vector3(-1888.908, -585.8545, 10.85693),
--   vector3(-1870.888, -599.2272, 10.85655),
--   vector3(-1967.16, -518.4894, 10.85655),
--   vector3(-1759.44, -327.8907, 44.53703),
--   vector3(-2062.856, -166.4247, 23.74303),
--   vector3(-2171.743, -282.6595, 11.73226),
--   vector3(-1778.533, -548.9644, 33.48595),
--   vector3(-1949.352, -433.055, 17.66949),
--   vector3(-1917.52, -455.7033, 20.72831),
--   vector3(-1839.226, -612.4291, 10.35493),
--   vector3(-1914.913, -170.1268, 35.14286),
--   vector3(-1873.613, -219.327, 37.46494),
--   vector3(-1810.446, -277.4091, 41.24768),
--   vector3(-1730.902, -359.439, 46.11488),
--   vector3(-1740.953, -568.2612, 36.40997),
--   vector3(-1943.229, -318.9935, 44.26326),
--   vector3(-1737.474, -479.5739, 39.07916),
--   vector3(-1682.551, -383.0118, 47.21002),
--   vector3(-1594.935, -472.3989, 35.53253),
--   vector3(-1484.688, -610.9594, 29.80316),
--   vector3(-1641.551, -606.6685, 32.35333),
--   vector3(-1423.504, -573.7307, 29.50579),
--   vector3(-1415.269, -532.4758, 30.4776),
--   vector3(-1548.994, -512.6153, 34.63739),
--   vector3(-1441.886, -488.9724, 33.06442),
--   vector3(-1572.626, -311.2645, 47.03134),
--   vector3(-1513.361, -286.2226, 48.70404),
--   vector3(-1469.513, -412.1262, 35.31662),
--   vector3(-1437.992, -408.9068, 34.99015),
--   vector3(-1620.418, -325.8596, 49.92547),
--   vector3(-1520.621, -396.9761, 39.84985),
--   vector3(-1314.391, -536.3713, 31.6524),
--   vector3(-1386.194, -777.686, 18.79168),
--   vector3(-1462.693, -897.6531, 9.791409),
--   vector3(-1513.295, -887.9077, 9.214504),
--   vector3(-1486.87, -951.4116, 6.984669),
--   vector3(-1470.906, -915.851, 9.062397),
--   vector3(-1498.68, -894.5293, 9.141613),
--   vector3(-1650.692, -1112.816, 12.53583),
--   vector3(-1255.139, -874.8241, 11.14794),
--   vector3(-1397.74, -892.6383, 10.8868),
--   vector3(-1497.856, -730.6954, 25.25039),
--   vector3(-1329.2, -826.6139, 15.84008),
--   vector3(-1328.704, -1140.524, 3.386002),
--   vector3(-1187.899, -1381.869, 3.743198),
--   vector3(-1181.216, -1402.365, 3.758972),
--   vector3(-1173.327, -1372.273, 4.085579),
--   vector3(-1991.176, -492.928, 10.60962),
--   vector3(-2031.807, -464.1945, 10.429),
--   vector3(-1353.176, -1030.566, 6.721924),
--   vector3(-1160.283, -1091.774, 1.058228),
--   vector3(-1045.837, -1028.556, 1.036133),
--   vector3(-1199.984, -981.7674, 4.448681),
--   vector3(-1068.342, -1506.87, 4.098732),
--   vector3(-1295.663, -1209.472, 3.810417),
--   vector3(-1291.193, -1123.64, 5.351563),
--   vector3(-1215.977, -1214.093, 6.636875),
--   vector3(-1247.577, -1156.903, 6.582664),
--   vector3(-1207.206, -1157.467, 6.679123),
--   vector3(-1231.199, -1345.072, 2.980198),
--   vector3(-1181.933, -1262.714, 5.599209),
--   vector3(-1126.856, -1193.656, 1.162109),
--   vector3(-1149.48, -1381.211, 4.115604),
--   vector3(-1121.794, -1400.292, 4.10862),
--   vector3(-1144.718, -1355.757, 3.938477),
--   vector3(-1174.755, -1363.075, 3.938824),
--   vector3(-1184.814, -1451.2, 3.30748),
--   vector3(-998.8854, -1155.782, 1.149052),
--   vector3(-3011.684, 77.33185, 10.67151),
--   vector3(-1969.183, 470.6583, 102.0146),
--   vector3(-1905.625, 453.286, 115.8841),
--   vector3(-1713.82, 477.0635, 127.2778),
--   vector3(-1768.421, 477.6682, 130.8576),
--   vector3(-3180.234, 919.3376, 13.38707),
--   vector3(-2979.32, 383.8251, 14.01977),
--   vector3(113.8397, 563.6295, 182.026),
--   vector3(179.4226, 500.8123, 141.1006),
--   vector3(104.4118, 489.5435, 146.2985),
--   vector3(-91.76631, 856.7831, 234.7352),
--   vector3(-964.7958, 770.8277, 174.4515),
--   vector3(-698.9987, 521.2276, 109.5096),
--   vector3(-1029.266, 795.9654, 168.0625),
--   vector3(-1309.025, 624.4194, 136.2038),
--   vector3(2447.146, 1606.358, 31.70212),
--   vector3(2449.355, 1606.356, 31.70212),
--   vector3(-241.7715, 6340.599, 31.52609),
--   vector3(-384.2488, 6096.982, 30.49872),
--   vector3(-368.9109, 6099.746, 30.55948),
--   vector3(-251.0486, 6058.887, 30.90051),
--   vector3(-328.7591, 6239.125, 30.50275),
--   vector3(-350.7206, 6249.813, 30.50275),
--   vector3(7.164581, 6250.063, 31.01282),
--   vector3(-60.75993, 6504.074, 30.58136),
--   vector3(-421.2148, 6168.842, 30.51953),
--   vector3(2893.987, 4425.137, 47.52466),
--   vector3(2985.857, 4070.937, 54.98906),
--   vector3(3015.214, 4129.991, 56.79457),
--   vector3(3022.9, 4201.603, 58.00518),
--   vector3(-2152.769, 3287.157, 31.83368),
--   vector3(967.7808, 3625.961, 31.39269),
--   vector3(2454.809, 3862.441, 37.87272),
--   vector3(2656.78, 3920.001, 41.18608),
--   vector3(1717.885, 3450.918, 37.73833),
--   vector3(2023.438, 3038.705, 46.30561),
--   vector3(2665.48, 2769.814, 35.95126),
--   vector3(2637.293, 2936.454, 39.44962),
--   vector3(1399.36, 2126.03, 103.8832),
-- }
-- function isInBb(coords, southWest, northEast)
--   return (coords.x > southWest.x) and (coords.x < northEast.x) and (coords.y > southWest.y) and (coords.y < northEast.y)
-- end
-- Citizen.CreateThread(function()
--   for k, loc in pairs(lectric) do
--     if true or isInBb(loc, vector3(-2964.11,-1189.52,609.0), vector3(2029.89,3159.35,45.17)) then
--       local blip = AddBlipForCoord(loc)
--       SetBlipSprite(blip, 354)
--       SetBlipScale(blip, 0.75)
--       SetBlipColour(blip, 22)
--       SetBlipAsShortRange(blip, true)
--       BeginTextCommandSetBlipName("STRING")
--       AddTextComponentString("Electric Box " .. tostring(k))
--       EndTextCommandSetBlipName(blip)
--     end
--   end
-- end)

-- Citizen.CreateThread(function()
--   -- SetPedCanHeadIk(PlayerPedId(), false)
--   while true do
--     SetPedCanHeadIk(PlayerPedId(), false)
--     Citizen.Wait(0)
--   end
-- end)

-- Citizen.CreateThread(function()
--   local ped = PlayerPedId()
--   local interior = GetInteriorFromEntity(ped)
--   print(interior)
--   local roomHash = GetRoomKeyFromEntity(ped)
--   print(roomHash)
--   ForceRoomForEntity(ped, 139265, 913797866)
--   ForceRoomForGameViewport(139265, 913797866)
-- end)

-- Citizen.CreateThread(function()
--   while true do
--     local ped = PlayerPedId()
--     local interior = GetInteriorFromEntity(ped)
--     print(interior)
--     local roomHash = GetRoomKeyFromEntity(ped)
--     print(roomHash)
--     -- ForceRoomForEntity(ped, 139265, 913797866)
--     -- ForceRoomForGameViewport(139265, 913797866)
--     Citizen.Wait(5000)
--   end
-- end)

-- RegisterCommand("tint", function(_, args)
--   local ped = PlayerPedId()
--   local _, curweap = GetCurrentPedWeapon(ped)

--   SetPedWeaponTintIndex(ped, curweap, tonumber(args[1]))
-- end, false)

-- Citizen.CreateThread(function()
--   TriggerServerEvent("np-doors:request-lock-state")
-- end)

-- <data name="minimap"        	alignX="L"	alignY="B"	posX="-0.0045"		posY="0.002"		sizeX="0.150"		sizeY="0.188888" /> <!-- WARNING! Feed MUST match sizeX -->
-- <data name="minimap_mask"   	alignX="L"	alignY="B"	posX="0.020"		posY="0.032" 	 	sizeX="0.111"		sizeY="0.159" />
-- <data name="minimap_blur"   	alignX="L"	alignY="B"	posX="-0.03"		posY="0.022"		sizeX="0.266"		sizeY="0.237" />
-- Citizen.CreateThread(function()
--   local function setPosLB(type, posX, posY, sizeX, sizeY)
--     SetMinimapComponentPosition(type, "L", "B", posX, posY, sizeX, sizeY)
--   end
--   local offsetX = -0.018
--   local offsetY = 0.025

--   local defaultX = -0.0045
--   local defaultY = 0.002

--   local maskDiffX = 0.020 - defaultX
--   local maskDiffY = 0.032 - defaultY
--   local blurDiffX = -0.03 - defaultX
--   local blurDiffY = 0.022 - defaultY

--   local defaultMaskDiffX = 0.0245
--   local defaultMaskDiffY = 0.03

--   local defaultBlurDiffX = 0.0255
--   local defaultBlurDiffY = 0.02

--   setPosLB("minimap",       -0.0045,  0.006,  0.150, 0.15)
--   setPosLB("minimap_mask",  0.020,    0.022,  0.111, 0.159)
--   setPosLB("minimap_blur",  -0.03,    0.002,  0.266, 0.200)
-- end)

-- local createdDuis = {}
-- Citizen.CreateThread(function()
--   Citizen.Wait(5000)
--   local duiCount = 0
--   while duiCount < 13 do
--     duiCount = duiCount + 1
--     local crDui = CreateDui("https://i.imgur.com/ZVANiUy.png", 1024, 1024)
--     createdDuis[#createdDuis + 1] = crDui
--     while not IsDuiAvailable(crDui) do
--       Wait(100)
--     end
--     Citizen.Wait(1000)
--   end
--   print('finished loading duis')
-- end)
-- exports('getDuiObject', function(id, newObj)
--   if newObj then
--     createdDuis[id] = CreateDui("https://i.imgur.com/ZVANiUy.png", 1024, 1024)
--     while not IsDuiAvailable(createdDuis[id]) do
--       Wait(100)
--     end
--   end
--   return createdDuis[id]
-- end)
-- local dictCreated = {}
-- exports('getTxd', function(id)
--   local txd
--   if not dictCreated[id] then
--     txd = CreateRuntimeTxd(id)
--     dictCreated[id] = txd
--   else
--     txd = dictCreated[id]
--   end
--   return txd
-- end)
-- Citizen.CreateThread(function()
--   SetPlayerParachuteModelOverride(PlayerId(), `p_parachute1_mp_dec`) -- p_parachute1_mp_s
--   print(1)
-- end)

-- Citizen.CreateThread(function()
--   local veh = GetVehiclePedIsIn(PlayerPedId())
--   print(GetVehicleNumberPlateText(veh))
-- end)

-- Citizen.CreateThread(function()
--   while true do
--     SetStaticEmitterEnabled("LOS_SANTOS_AMMUNATION_GUN_RANGE", false)
--     Citizen.Wait(60000)
--   end
-- end)

-- local tvCoords = vector3(-524.97, -180.9, 37.73)
-- local tvReplaced = false
-- Citizen.CreateThread(function()
--   while true do
--     if not tvReplaced and #(tvCoords - GetEntityCoords(PlayerPedId())) < 10.0 then
--       local duiObj = CreateDui('https://dummyimage.com/600x400/000/fff&text=8', 600, 400)
--       local dui = GetDuiHandle(duiObj)
--       local txd = CreateRuntimeTxd('duiTxdTVinCityHall')
--       local tx = CreateRuntimeTextureFromDuiHandle(txd, 'duiTexTVinCityHall', dui)
--       tvReplaced = true
--       AddReplaceTexture('prop_cs_tv_stand', 'script_rt_tvscreen', 'duiTxdTVinCityHall', 'duiTexTVinCityHall')
--     elseif tvReplaced and #(tvCoords - GetEntityCoords(PlayerPedId())) > 10.0 then
--       RemoveReplaceTexture('prop_cs_tv_stand', 'script_rt_tvscreen')
--       tvReplaced = false
--     end
--     Citizen.Wait(1000)
--   end
-- end)

-- local females = {
--   "a_f_m_beach_01",
--   "a_f_m_bevhills_01",
--   "a_f_m_bevhills_01",
--   "a_f_m_bevhills_02",
--   "a_f_m_bevhills_02",
--   "a_f_m_bodybuild_01",
--   "a_f_m_bodybuild_01",
--   "a_f_m_business_02",
--   "a_f_m_business_02",
--   "a_f_m_downtown_01",
--   "a_f_m_downtown_01",
--   "a_f_m_eastsa_01",
--   "a_f_m_eastsa_01s",
--   "a_f_m_eastsa_02",
--   "a_f_m_eastsa_02s",
--   "a_f_m_fatbla_01",
--   "a_f_m_fatbla_01s",
--   "a_f_m_fatcult_01",
--   "a_f_m_fatcult_01",
--   "a_f_m_fatwhite_01",
--   "a_f_m_fatwhite_01",
--   "a_f_m_ktown_01",
--   "a_f_m_ktown_01s",
--   "a_f_m_ktown_02",
--   "a_f_m_ktown_02",
--   "a_f_m_prolhost_01",
--   "a_f_m_prolhost_01",
--   "a_f_m_salton_01",
--   "a_f_m_salton_01s",
--   "a_f_m_skidrow_01",
--   "a_f_m_skidrow_01",
--   "a_f_m_soucent_01",
--   "a_f_m_soucent_01s",
--   "a_f_m_soucent_02",
--   "a_f_m_soucent_02",
--   "a_f_m_soucentmc_01",
--   "a_f_m_soucentmc_01s",
--   "a_f_m_tourist_01",
--   "a_f_m_tourist_01",
--   "a_f_m_tramp_01",
--   "a_f_m_tramp_01",
--   "a_f_m_trampbeac_01",
--   "a_f_m_trampbeac_01",
--   "a_f_o_genstreet_01",
--   "a_f_o_genstreet_01",
--   "a_f_o_indian_01",
--   "a_f_o_indian_01",
--   "a_f_o_ktown_01",
--   "a_f_o_ktown_01",
--   "a_f_o_salton_01",
--   "a_f_o_salton_01",
--   "a_f_o_soucent_01",
--   "a_f_o_soucent_01",
--   "a_f_o_soucent_02",
--   "a_f_o_soucent_02s",
--   "a_f_y_beach_01",
--   "a_f_y_beach_01s",
--   "a_f_y_bevhills_01",
--   "a_f_y_bevhills_01",
--   "a_f_y_bevhills_02",
--   "a_f_y_bevhills_02",
--   "a_f_y_bevhills_03",
--   "a_f_y_bevhills_03",
--   "a_f_y_bevhills_04",
--   "a_f_y_bevhills_04",
--   "a_f_y_business_01",
--   "a_f_y_business_01",
--   "a_f_y_business_02",
--   "a_f_y_business_02",
--   "a_f_y_business_03",
--   "a_f_y_business_03",
--   "a_f_y_business_04",
--   "a_f_y_business_04",
--   "a_f_y_clubcust_01",
--   "a_f_y_clubcust_01s",
--   "a_f_y_clubcust_02",
--   "a_f_y_clubcust_02s",
--   "a_f_y_clubcust_03",
--   "a_f_y_clubcust_03s",
--   "a_f_y_eastsa_01",
--   "a_f_y_eastsa_01s",
--   "a_f_y_eastsa_02",
--   "a_f_y_eastsa_02s",
--   "a_f_y_eastsa_03",
--   "a_f_y_eastsa_03",
--   "a_f_y_epsilon_01",
--   "a_f_y_epsilon_01",
--   "a_f_y_femaleagent",
--   "a_f_y_femaleagent",
--   "a_f_y_fitness_01",
--   "a_f_y_fitness_01",
--   "a_f_y_fitness_02",
--   "a_f_y_fitness_02",
--   "a_f_y_genhot_01",
--   "a_f_y_genhot_01",
--   "a_f_y_golfer_01",
--   "a_f_y_golfer_01s",
--   "a_f_y_hiker_01",
--   "a_f_y_hiker_01",
--   "a_f_y_hippie_01",
--   "a_f_y_hippie_01",
--   "a_f_y_hipster_01",
--   "a_f_y_hipster_01s",
--   "a_f_y_hipster_02",
--   "a_f_y_hipster_02",
--   "a_f_y_hipster_03",
--   "a_f_y_hipster_03",
--   "a_f_y_hipster_04",
--   "a_f_y_hipster_04s",
--   "a_f_y_indian_01",
--   "a_f_y_indian_01",
--   "a_f_y_juggalo_01",
--   "a_f_y_juggalo_01",
--   "a_f_y_runner_01",
--   "a_f_y_runner_01",
--   "a_f_y_rurmeth_01",
--   "a_f_y_rurmeth_01",
--   "a_f_y_scdressy_01",
--   "a_f_y_scdressy_01s",
--   "a_f_y_skater_01",
--   "a_f_y_skater_01s",
--   "a_f_y_soucent_01",
--   "a_f_y_soucent_01",
--   "a_f_y_soucent_02",
--   "a_f_y_soucent_02",
--   "a_f_y_soucent_03",
--   "a_f_y_soucent_03",
--   "a_f_y_tennis_01",
--   "a_f_y_tennis_01s",
--   "a_f_y_topless_01",
--   "a_f_y_topless_01",
--   "a_f_y_tourist_01",
--   "a_f_y_tourist_01s",
--   "a_f_y_tourist_02",
--   "a_f_y_tourist_02",
--   "a_f_y_vinewood_01",
--   "a_f_y_vinewood_01",
--   "a_f_y_vinewood_02",
--   "a_f_y_vinewood_02",
--   "a_f_y_vinewood_03",
--   "a_f_y_vinewood_03s",
--   "a_f_y_vinewood_04",
--   "a_f_y_vinewood_04s",
--   "a_f_y_yoga_01",
--   "a_f_y_yoga_01",
--   "a_f_y_gencaspat_01",
--   "a_f_y_gencaspat_01s",
--   "a_f_y_smartcaspat_01",
--   "a_f_y_smartcaspat_01s",
-- }

-- local male = {
--   "a_m_m_acult_01",
--   "a_m_m_acult_01",
--   "a_m_m_afriamer_01",
--   "a_m_m_afriamer_01s",
--   "a_m_m_beach_01",
--   "a_m_m_beach_01s",
--   "a_m_m_beach_02",
--   "a_m_m_beach_02",
--   "a_m_m_bevhills_01",
--   "a_m_m_bevhills_01s",
--   "a_m_m_bevhills_02",
--   "a_m_m_bevhills_02s",
--   "a_m_m_business_01",
--   "a_m_m_business_01",
--   "a_m_m_eastsa_01",
--   "a_m_m_eastsa_01s",
--   "a_m_m_eastsa_02",
--   "a_m_m_eastsa_02s",
--   "a_m_m_farmer_01",
--   "a_m_m_farmer_01s",
--   "a_m_m_fatlatin_01",
--   "a_m_m_fatlatin_01s",
--   "a_m_m_genfat_01",
--   "a_m_m_genfat_01s",
--   "a_m_m_genfat_02",
--   "a_m_m_genfat_02s",
--   "a_m_m_golfer_01",
--   "a_m_m_golfer_01",
--   "a_m_m_hasjew_01",
--   "a_m_m_hasjew_01s",
--   "a_m_m_hillbilly_01",
--   "a_m_m_hillbilly_01",
--   "a_m_m_hillbilly_02",
--   "a_m_m_hillbilly_02s",
--   "a_m_m_indian_01",
--   "a_m_m_indian_01s",
--   "a_m_m_ktown_01",
--   "a_m_m_ktown_01s",
--   "a_m_m_malibu_01",
--   "a_m_m_malibu_01s",
--   "a_m_m_mexcntry_01",
--   "a_m_m_mexcntry_01s",
--   "a_m_m_mexlabor_01",
--   "a_m_m_mexlabor_01",
--   "a_m_m_og_boss_01",
--   "a_m_m_og_boss_01s",
--   "a_m_m_paparazzi_01",
--   "a_m_m_paparazzi_01",
--   "a_m_m_polynesian_01",
--   "a_m_m_polynesian_01s",
--   "a_m_m_prolhost_01",
--   "a_m_m_prolhost_01",
--   "a_m_m_rurmeth_01",
--   "a_m_m_rurmeth_01",
--   "a_m_m_salton_01",
--   "a_m_m_salton_01",
--   "a_m_m_salton_02",
--   "a_m_m_salton_02s",
--   "a_m_m_salton_03",
--   "a_m_m_salton_03s",
--   "a_m_m_salton_04",
--   "a_m_m_salton_04s",
--   "a_m_m_skater_01",
--   "a_m_m_skater_01s",
--   "a_m_m_skidrow_01",
--   "a_m_m_skidrow_01s",
--   "a_m_m_socenlat_01",
--   "a_m_m_socenlat_01s",
--   "a_m_m_soucent_01",
--   "a_m_m_soucent_01s",
--   "a_m_m_soucent_02",
--   "a_m_m_soucent_02s",
--   "a_m_m_soucent_03",
--   "a_m_m_soucent_03s",
--   "a_m_m_soucent_04",
--   "a_m_m_soucent_04s",
--   "a_m_m_stlat_02",
--   "a_m_m_stlat_02s",
--   "a_m_m_tennis_01",
--   "a_m_m_tennis_01s",
--   "a_m_m_tourist_01",
--   "a_m_m_tourist_01s",
--   "a_m_m_tramp_01",
--   "a_m_m_tramp_01",
--   "a_m_m_trampbeac_01",
--   "a_m_m_trampbeac_01",
--   "a_m_m_tranvest_01",
--   "a_m_m_tranvest_01",
--   "a_m_m_tranvest_02",
--   "a_m_m_tranvest_02",
--   "a_m_o_acult_01",
--   "a_m_o_acult_01s",
--   "a_m_o_acult_02",
--   "a_m_o_acult_02s",
--   "a_m_o_beach_01",
--   "a_m_o_beach_01s",
--   "a_m_o_genstreet_01",
--   "a_m_o_genstreet_01s",
--   "a_m_o_ktown_01",
--   "a_m_o_ktown_01s",
--   "a_m_o_salton_01",
--   "a_m_o_salton_01s",
--   "a_m_o_soucent_01",
--   "a_m_o_soucent_01s",
--   "a_m_o_soucent_02",
--   "a_m_o_soucent_02s",
--   "a_m_o_soucent_03",
--   "a_m_o_soucent_03s",
--   "a_m_o_tramp_01",
--   "a_m_o_tramp_01",
--   "a_m_y_acult_01",
--   "a_m_y_acult_01",
--   "a_m_y_acult_02",
--   "a_m_y_acult_02",
--   "a_m_y_beach_01",
--   "a_m_y_beach_01s",
--   "a_m_y_beach_02",
--   "a_m_y_beach_02s",
--   "a_m_y_beach_03",
--   "a_m_y_beach_03s",
--   "a_m_y_beachvesp_01",
--   "a_m_y_beachvesp_01s",
--   "a_m_y_beachvesp_02",
--   "a_m_y_beachvesp_02s",
--   "a_m_y_bevhills_01",
--   "a_m_y_bevhills_01s",
--   "a_m_y_bevhills_02",
--   "a_m_y_bevhills_02s",
--   "a_m_y_breakdance_01",
--   "a_m_y_breakdance_01s",
--   "a_m_y_busicas_01",
--   "a_m_y_busicas_01",
--   "a_m_y_business_01",
--   "a_m_y_business_01",
--   "a_m_y_business_02",
--   "a_m_y_business_02",
--   "a_m_y_business_03",
--   "a_m_y_business_03",
--   "a_m_y_clubcust_01",
--   "a_m_y_clubcust_01s",
--   "a_m_y_clubcust_02",
--   "a_m_y_clubcust_02s",
--   "a_m_y_clubcust_03",
--   "a_m_y_clubcust_03s",
--   "a_m_y_cyclist_01",
--   "a_m_y_cyclist_01s",
--   "a_m_y_dhill_01",
--   "a_m_y_dhill_01s",
--   "a_m_y_downtown_01",
--   "a_m_y_downtown_01s",
--   "a_m_y_eastsa_01",
--   "a_m_y_eastsa_01s",
--   "a_m_y_eastsa_02",
--   "a_m_y_eastsa_02s",
--   "a_m_y_epsilon_01",
--   "a_m_y_epsilon_01",
--   "a_m_y_epsilon_02",
--   "a_m_y_epsilon_02",
--   "a_m_y_gay_01",
--   "a_m_y_gay_01s",
--   "a_m_y_gay_02",
--   "a_m_y_gay_02s",
--   "a_m_y_genstreet_01",
--   "a_m_y_genstreet_01s",
--   "a_m_y_genstreet_02",
--   "a_m_y_genstreet_02s",
--   "a_m_y_golfer_01",
--   "a_m_y_golfer_01s",
--   "a_m_y_hasjew_01",
--   "a_m_y_hasjew_01s",
--   "a_m_y_hiker_01",
--   "a_m_y_hiker_01s",
--   "a_m_y_hippy_01",
--   "a_m_y_hippy_01s",
--   "a_m_y_hipster_01",
--   "a_m_y_hipster_01s",
--   "a_m_y_hipster_02",
--   "a_m_y_hipster_02s",
--   "a_m_y_hipster_03",
--   "a_m_y_hipster_03s",
--   "a_m_y_indian_01",
--   "a_m_y_indian_01",
--   "a_m_y_jetski_01",
--   "a_m_y_jetski_01",
--   "a_m_y_juggalo_01",
--   "a_m_y_juggalo_01s",
--   "a_m_y_ktown_01",
--   "a_m_y_ktown_01s",
--   "a_m_y_ktown_02",
--   "a_m_y_ktown_02s",
--   "a_m_y_latino_01",
--   "a_m_y_latino_01s",
--   "a_m_y_methhead_01",
--   "a_m_y_methhead_01",
--   "a_m_y_mexthug_01",
--   "a_m_y_mexthug_01s",
--   "a_m_y_motox_01",
--   "a_m_y_motox_01s",
--   "a_m_y_motox_02",
--   "a_m_y_motox_02s",
--   "a_m_y_musclbeac_01",
--   "a_m_y_musclbeac_01s",
--   "a_m_y_musclbeac_02",
--   "a_m_y_musclbeac_02s",
--   "a_m_y_polynesian_01",
--   "a_m_y_polynesian_01s",
--   "a_m_y_roadcyc_01",
--   "a_m_y_roadcyc_01s",
--   "a_m_y_runner_01",
--   "a_m_y_runner_01s",
--   "a_m_y_runner_02",
--   "a_m_y_runner_02",
--   "a_m_y_salton_01",
--   "a_m_y_salton_01s",
--   "a_m_y_skater_01",
--   "a_m_y_skater_01s",
--   "a_m_y_skater_02",
--   "a_m_y_skater_02s",
--   "a_m_y_soucent_01",
--   "a_m_y_soucent_01s",
--   "a_m_y_soucent_02",
--   "a_m_y_soucent_02s",
--   "a_m_y_soucent_03",
--   "a_m_y_soucent_03s",
--   "a_m_y_soucent_04",
--   "a_m_y_soucent_04s",
--   "a_m_y_stbla_01",
--   "a_m_y_stbla_01",
--   "a_m_y_stbla_02",
--   "a_m_y_stbla_02s",
--   "a_m_y_stlat_01",
--   "a_m_y_stlat_01s",
--   "a_m_y_stwhi_01",
--   "a_m_y_stwhi_01s",
--   "a_m_y_stwhi_02",
--   "a_m_y_stwhi_02",
--   "a_m_y_sunbathe_01",
--   "a_m_y_sunbathe_01s",
--   "a_m_y_surfer_01",
--   "a_m_y_surfer_01",
--   "a_m_y_vindouche_01",
--   "a_m_y_vindouche_01",
--   "a_m_y_vinewood_01",
--   "a_m_y_vinewood_01s",
--   "a_m_y_vinewood_02",
--   "a_m_y_vinewood_02",
--   "a_m_y_vinewood_03",
--   "a_m_y_vinewood_03s",
--   "a_m_y_vinewood_04",
--   "a_m_y_vinewood_04s",
--   "a_m_y_yoga_01",
--   "a_m_y_yoga_01s",
--   "a_m_m_mlcrisis_01",
--   "a_m_m_mlcrisis_01s",
--   "a_m_y_gencaspat_01",
--   "a_m_y_gencaspat_01s",
--   "a_m_y_smartcaspat_01",
--   "a_m_y_smartcaspat_01s",
-- }

-- function doStuff(v)
--   print(v)
--   RequestModel(v)
--   while not HasModelLoaded(v) do
--     Wait(0)
--   end
--   local ped = CreatePed(5, GetHashKey(v), GetEntityCoords(PlayerPedId()), 0.0, 0, 0);
--   while not DoesEntityExist(ped) do
--     Wait(0)
--   end
--   local lc = 0
--   while lc < 1000 do
--     SetPedRandomComponentVariation(ped, true)
--     lc = lc + 1
--     Wait(0)
--   end
-- end
-- Citizen.CreateThread(function()
--   for _, v in pairs(females) do
--     doStuff(v)
--   end
-- end)

-- Citizen.CreateThread(function()
--   while true do
--     local pos = GetEntityCoords(PlayerPedId(),  true)
--     TriggerServerEvent("dispatch:svNotify", {
--       dispatchCode = "10-13B",
--       firstStreet = "W/E",
--       callSign = "111",
--       cid = exports["isPed"]:isPed("cid"),
--       origin = {
--         x = pos.x,
--         y = pos.y,
--         z = pos.z
--       }
--     })
--     Wait(250)
--   end
-- end)

-- Citizen.CreateThread(function()
--   RequestModel(`ch_prop_gold_trolly_empty`)
--   while not HasModelLoaded(`ch_prop_gold_trolly_empty`) do
--     print('wait')
--     Wait(0)
--   end
--   CreateObject(`ch_prop_gold_trolly_empty`, GetEntityCoords(PlayerPedId()), 1, 1, 1)
-- end)
-- Citizen.CreateThread(function()
--   while true do
--     print(IsFlashLightOn(PlayerPedId()))
--     Wait(1000)
--   end
  
-- end)

-- Citizen.CreateThread(function (arg1, arg2, arg3)
--   RequestIpl('vw_dlc_casino_door')
  
--   local interiorID = GetInteriorAtCoords(1100.000, 220.000, -50.000)
  
--   if IsValidInterior(interiorID) then
--       RefreshInterior(interiorID)
--   end
-- end)

-- experimenting with shooting back of vehicle
-- AddEventHandler("gameEventTriggered", function(name, ...)
--   print(name, json.encode(...))
-- end)

-- Citizen.CreateThread(function()
--   while true do
--     local entity = exports["np-target"]:GetEntityPlayerIsLookingAt(80, 5, 12)
--     print(entity)
--     local damage = GetWeaponDamage(`WEAPON_VINTAGEPISTOL`)
--     print(damage)
--     Wait(250)
--   end
-- end)
-- function RayCast(origin, target, options, ignoreEntity, radius)
--   local handle = StartShapeTestSweptSphere(origin.x, origin.y, origin.z, target.x, target.y, target.z, radius, options, ignoreEntity, 0)
--   return GetShapeTestResult(handle)
-- end
-- function GetForwardVector(rotation)
--   local rot = (math.pi / 180.0) * rotation
--   return vector3(-math.sin(rot.z) * math.abs(math.cos(rot.x)), math.cos(rot.z) * math.abs(math.cos(rot.x)), math.sin(rot.x))
-- end
-- Citizen.CreateThread(function()
--   while true do
--     local shooting = IsPedShooting(PlayerPedId())
--     if shooting then
--       PlayerPed = PlayerPedId()
--       PlayerCoords = GetPedBoneCoords(PlayerPed, 31086)
--       ForwardVectors = GetForwardVector(GetGameplayCamRot(2))
--       ForwardCoords = PlayerCoords + (ForwardVectors * 50.0)

--       local _, hit, targetCoords, _, targetEntity = RayCast(PlayerCoords, ForwardCoords, 286, PlayerPed, 0.2)

--       if hit and GetEntityType(targetEntity) == 2 then
--         -- local _, hit1, targetCoords, _, targetEntity1 = RayCast(PlayerCoords, ForwardCoords, 12, PlayerPed, 0.2)

--         local seats = GetVehicleModelNumberOfSeats(GetEntityModel(targetEntity))
        
--         -- local boneID = GetEntityBoneIndexByName(targetEntity, "boot")
--         -- local boneCoords = GetWorldPositionOfEntityBone(targetEntity, boneID)
--         -- print(boneID, boneCoords, PlayerCoords)
--         local radi = math.abs(GetEntityHeading(targetEntity) - GetEntityHeading(PlayerPedId()))
--         local m = math.fmod(radi, 360.0)
--         local angle = m > 180.0 and 360.0 - m or m

--         if angle < 28.0 then

--           local loop = -1
--           while loop < seats - 1 do
--             local ped = GetPedInVehicleSeat(targetEntity, loop)
--             local damage = GetWeaponDamage(GetSelectedPedWeapon(PlayerPedId()))
--             local damageMod = math.ceil(damage * 0.5)
--             print(damage, damageMod)
--             if ped ~= 0 then
--               -- ApplyDamageToPed(ped, 1000, true)
--               TriggerServerEvent(
--                 "np-sync:executeSyncNative",
--                 "0x697157CED63F18D4",
--                 NetworkGetNetworkIdFromEntity(ped),
--                 { entity = { 1 } },
--                 { NetworkGetNetworkIdFromEntity(ped), damageMod, true }
--               )
--             end
--             loop = loop + 1
--           end
  
--         end
--       end
--     end
--     Wait(0)
--   end
-- end)

-- Citizen.CreateThread(function()
--   local i = 1
--   while i < 8 do
--     print(i, GetSelectedPedWeapon(PlayerPedId()))
--     SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), i)
--     i = i + 1
--     Citizen.Wait(1000)
--   end
-- end)

-- function angleBetween(p1, p2)
--   local p = {}
--   p.x = p2.x-p1.x
--   p.y = p2.y-p1.y

--   local r = math.atan2(p.y,p.x)*180/math.pi
--   return r
-- end

-- RegisterCommand("fly", function()
--   local start = vector3(620.22, -738.04, 12.05)
--   local destination = vector3(597.83, -835.69, 42.53)
--   local difference = #(start - destination)
--   print('difference', difference)
--   print('starting in 3...')
--   local m = PlayerPedId()
--   SetEntityCoords(m, start)
--   FreezeEntityPosition(PlayerPedId(), false)
--   local ger = GetEntityRotation(PlayerPedId(), 2)
--   print('rotate', json.encode(ger))

--   -- while true do
--   --   DrawLine(start.x, start.y, start.z, destination.x, destination.y, destination.z, 100, 100, 100, 1.0)
--   --   Wait(0)
--   -- end

--   print('angle', angleBetween(start, destination))

--   -- local x = 0.0
--   -- while x < 360 do
--   --   x = x + 1.0
--   --   SetEntityRotation(PlayerPedId(), x, 0.0, 0.0, 2, true)
--   --   print(x)
--   --   Wait(500)
--   -- end
--   RequestModel("adder")

--   Wait(1000)
--   print('2...')
--   Wait(1000)
--   print('1...')
--   Wait(1000)

--   local diffX = (start.x - destination.x) / 60
--   local dirX = 'plus'
--   if start.x > 0 and destination.x < start.x then
--     dirX = 'minus'
--   end

--   local diffY = (destination.y - start.y) / 60
--   local dirY = 'plus'
--   if start.y < 0 and destination.y < start.y then
--     dirX = 'minus'
--   end

--   local diffZ = (destination.z - start.z) / 60
--   local dirZ = 'plus'
--   if start.z < 0 and destination.z < start.z then
--     dirX = 'minus'
--   end

--   local mapped = {}
--   local count = 0

--   while count < 60 do
--     count = count + 1
--     local x, y, z = 0
--     if dirX == 'plus' then
--       x = start.x + (count * diffX)
--     else
--       x = start.x - (count * diffX)
--     end
--     if dirY == 'plus' then
--       y = start.y + (count * diffY)
--     else
--       y = start.y - (count * diffY)
--     end
--     if dirZ == 'plus' then
--       z = start.z + (count * diffZ)
--     else
--       z = start.z - (count * diffZ)
--     end
--     mapped[count] = vector3(x, y, z)
--   end
  

--   SetEntityInvincible(PlayerPedId(), true)
--   -- FreezeEntityPosition(PlayerPedId(), true)
--   RopeLoadTextures()

--   while not RopeAreTexturesLoaded() do
--     Wait(0)
--   end
--   local ped = GetPlayerPed(PlayerId())
--   local pedPos = GetEntityCoords(ped, false)
  

-- --   float angleX = Vector3.Angle(new Vector3(camera_position.x, 0, 0), new Vector3(enemy_position.x, 0, 0));
-- -- float angleY = Vector3.Angle(new Vector3(0, camera_position.y, 0), new Vector3(0, enemy_position.y, 0));
-- -- -- float angleZ = Vector3.Angle(new Vector3(0, 0, camera_position.z), new Vector3(0, 0, enemy_position.z));

-- --   local ropeX = angleBetween(vector3(pedPos.x, 0.0, 0.0), vector3(destination.x, 0.0, 0.0))
-- --   local ropeY = angleBetween(vector3(0.0, pedPos.y, 0.0), vector3(0.0, destination.y, 0.0))
-- --   local ropeZ = angleBetween(vector3(0.0, 0.0, pedPos.z), vector3(0.0, 0.0, destination.z))

 
--   local veh = CreateVehicle(`adder`, destination, 0.0, 1, 1)
--   FreezeEntityPosition(veh, true)
--   SetEntityInvincible(veh, true)
--   SetEntityVisible(veh, 0, 0)
--   SetEntityCollision(veh, false, false)

--   local rope = AddRope(
--     start,
--     0.0,
--     0.0,
--     0.0,
--     difference,
--     4, -- type
--     difference, -- maxlen
--     1.0, -- minlen
--     0, -- winding speed
--     0, -- p11
--     0, -- p12
--     0, -- rigid
--     0, -- p14
--     0 -- breakwhenshot
--     )
--     AttachEntitiesToRope(rope, ped, veh, start, destination, difference, 0, 0, 0, 0)

--   for _, coords in pairs(mapped) do
--     SetEntityCoords(PlayerPedId(), coords)
--     SetEntityRotation(PlayerPedId(), math.abs(angleBetween(start, destination)), 0.0, 0.0, 2, true)
--     Wait(0)
--   end

--   SetEntityInvincible(PlayerPedId(), false)
--   FreezeEntityPosition(PlayerPedId(), false)

--   Wait(1000)
--   DeleteChildRope(rope)
--   DeleteRope(rope)
--   DeleteEntity(veh)
-- end)
