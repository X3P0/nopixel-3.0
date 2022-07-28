-- np-island

local mainlandCoords = vector3(2146.42,-2616.12,9.58)
local islandCoords = vector3(3813.5,-4642.96,2.51)
local isIslandEnabled = false
local isIslandSwappingEnabled = false

-- every second check if we're closer to island or mainland and switch accordingly
Citizen.CreateThread(function()
  while true do
    if isIslandSwappingEnabled then
      local coords = GetEntityCoords(PlayerPedId())
      local distanceToMainland = #(coords - mainlandCoords)
      local distanceToIsland = #(coords - islandCoords)
      if (not isIslandEnabled) and (distanceToIsland < distanceToMainland) then
        isIslandEnabled = true
        TriggerEvent("np-island:enableIsland", true)
      elseif (isIslandEnabled) and (distanceToIsland > distanceToMainland) then
        isIslandEnabled = false
        TriggerEvent("np-island:enableIsland", false)
      end
    end
    Citizen.Wait(1000)
  end
end)

AddEventHandler("np-island:enableIsland", function(pEnabled)
  if pEnabled then
    SetIslandHopperEnabled("HeistIsland", true)
    SetScenarioGroupEnabled("Heist_Island_Peds", true)
    SetAudioFlag('PlayerOnDLCHeist4Island', true)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)
    SetAiGlobalPathNodesType(1)
    LoadGlobalWaterType(1)
    SetWindSpeed(0.0)
    exports['np-weathersync']:FreezeWeather(true, 'Very Sunny')
    SetToggleMinimapHeistIsland(true)
    TriggerEvent('np-island:onIsland', true)
    TriggerEvent('np-island:hideBlips', true)
    Wait(0)
    RemoveIpl("h4_islandx_sea_mines")
    RemoveIpl("h4_aa_guns_lod")
    RemoveIpl("h4_aa_guns")
    return
  end
  SetIslandHopperEnabled("HeistIsland", false)
  SetScenarioGroupEnabled("Heist_Island_Peds", false)
  SetAudioFlag('PlayerOnDLCHeist4Island', false)
  SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', false, true)
  SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', true, true)
  SetAiGlobalPathNodesType(0)
  LoadGlobalWaterType(0)
  SetWindSpeed(1.0)
  SetToggleMinimapHeistIsland(false)
  TriggerEvent('np-island:onIsland', false)
  TriggerEvent('np-island:hideBlips', false)
  exports['np-weathersync']:FreezeWeather(false, 'Very Sunny')
end)

RegisterNetEvent("np-island:enableSwapping", function(pEnabled)
  isIslandSwappingEnabled = pEnabled
end)
Citizen.CreateThread(function()
  Citizen.Wait(5000)
  TriggerServerEvent("np-island:checkIslandSwapping")
end)

exports('hideBlips', function(pState)
  TriggerEvent('np-island:hideBlips', pState)
end)

-- local ipls = {
--   "h4_mph4_terrain_occ_09",
--   "h4_mph4_terrain_occ_06",
--   "h4_mph4_terrain_occ_05",
--   "h4_mph4_terrain_occ_01",
--   "h4_mph4_terrain_occ_00",
--   "h4_mph4_terrain_occ_08",
--   "h4_mph4_terrain_occ_04",
--   "h4_mph4_terrain_occ_07",
--   "h4_mph4_terrain_occ_03",
--   "h4_mph4_terrain_occ_02",
--   "h4_islandx_terrain_04",
--   "h4_islandx_terrain_05_slod",
--   "h4_islandx_terrain_props_05_d_slod",
--   "h4_islandx_terrain_02",
--   "h4_islandx_terrain_props_05_a_lod",
--   "h4_islandx_terrain_props_05_c_lod",
--   "h4_islandx_terrain_01",
--   "h4_mph4_terrain_04",
--   "h4_mph4_terrain_06",
--   "h4_islandx_terrain_04_lod",
--   "h4_islandx_terrain_03_lod",
--   "h4_islandx_terrain_props_06_a",
--   "h4_islandx_terrain_props_06_a_slod",
--   "h4_islandx_terrain_props_05_f_lod",
--   "h4_islandx_terrain_props_06_b",
--   "h4_islandx_terrain_props_05_b_lod",
--   "h4_mph4_terrain_lod",
--   "h4_islandx_terrain_props_05_e_lod",
--   "h4_islandx_terrain_05_lod",
--   "h4_mph4_terrain_02",
--   "h4_islandx_terrain_props_05_a",
--   "h4_mph4_terrain_01_long_0",
--   "h4_islandx_terrain_03",
--   "h4_islandx_terrain_props_06_b_slod",
--   "h4_islandx_terrain_01_slod",
--   "h4_islandx_terrain_04_slod",
--   "h4_islandx_terrain_props_05_d_lod",
--   "h4_islandx_terrain_props_05_f_slod",
--   "h4_islandx_terrain_props_05_c",
--   "h4_islandx_terrain_02_lod",
--   "h4_islandx_terrain_06_slod",
--   "h4_islandx_terrain_props_06_c_slod",
--   "h4_islandx_terrain_props_06_c",
--   "h4_islandx_terrain_01_lod",
--   "h4_mph4_terrain_06_strm_0",
--   "h4_islandx_terrain_05",
--   "h4_islandx_terrain_props_05_e_slod",
--   "h4_islandx_terrain_props_06_c_lod",
--   "h4_mph4_terrain_03",
--   "h4_islandx_terrain_props_05_f",
--   "h4_islandx_terrain_06_lod",
--   "h4_mph4_terrain_01",
--   "h4_islandx_terrain_06",
--   "h4_islandx_terrain_props_06_a_lod",
--   "h4_islandx_terrain_props_06_b_lod",
--   "h4_islandx_terrain_props_05_b",
--   "h4_islandx_terrain_02_slod",
--   "h4_islandx_terrain_props_05_e",
--   "h4_islandx_terrain_props_05_d",
--   "h4_mph4_terrain_05",
--   "h4_mph4_terrain_02_grass_2",
--   "h4_mph4_terrain_01_grass_1",
--   "h4_mph4_terrain_05_grass_0",
--   "h4_mph4_terrain_01_grass_0",
--   "h4_mph4_terrain_02_grass_1",
--   "h4_mph4_terrain_02_grass_0",
--   "h4_mph4_terrain_02_grass_3",
--   "h4_mph4_terrain_04_grass_0",
--   "h4_mph4_terrain_06_grass_0",
--   "h4_mph4_terrain_04_grass_1",
--   "island_distantlights",
--   "island_lodlights",
--   "h4_yacht_strm_0",
--   "h4_yacht",
--   "h4_yacht_long_0",
--   "h4_islandx_yacht_01_lod",
--   "h4_clubposter_palmstraxx",
--   "h4_islandx_yacht_02_int",
--   "h4_islandx_yacht_02",
--   "h4_clubposter_moodymann",
--   "h4_islandx_yacht_01",
--   "h4_clubposter_keinemusik",
--   "h4_islandx_yacht_03",
--   "h4_ch2_mansion_final",
--   "h4_islandx_yacht_03_int",
--   "h4_yacht_critical_0",
--   "h4_islandx_yacht_01_int",
--   "h4_mph4_island_placement",
--   "h4_islandx_mansion_vault",
--   "h4_islandx_checkpoint_props",
--   "h4_mph4_airstrip_interior_0_airstrip_hanger",
--   "h4_islandairstrip_hangar_props_slod",
--   "h4_se_ipl_01_lod",
--   "h4_ne_ipl_00_slod",
--   "h4_se_ipl_06_slod",
--   "h4_ne_ipl_00",
--   "h4_se_ipl_02",
--   "h4_islandx_barrack_props_lod",
--   "h4_se_ipl_09_lod",
--   "h4_ne_ipl_05",
--   "h4_mph4_island_se_placement",
--   "h4_ne_ipl_09",
--   "h4_islandx_mansion_props_slod",
--   "h4_se_ipl_09",
--   "h4_mph4_mansion_b",
--   "h4_islandairstrip_hangar_props_lod",
--   "h4_islandx_mansion_entrance_fence",
--   "h4_nw_ipl_09",
--   "h4_nw_ipl_02_lod",
--   "h4_ne_ipl_09_slod",
--   "h4_sw_ipl_02",
--   "h4_islandx_checkpoint",
--   "h4_islandxdock_water_hatch",
--   "h4_nw_ipl_04_lod",
--   "h4_islandx_maindock_props",
--   "h4_beach",
--   "h4_islandx_mansion_lockup_03_lod",
--   "h4_ne_ipl_04_slod",
--   "h4_mph4_island_nw_placement",
--   "h4_ne_ipl_08_slod",
--   "h4_nw_ipl_09_lod",
--   "h4_se_ipl_08_lod",
--   "h4_islandx_maindock_props_lod",
--   "h4_se_ipl_03",
--   "h4_sw_ipl_02_slod",
--   "h4_nw_ipl_00",
--   "h4_islandx_mansion_b_side_fence",
--   "h4_ne_ipl_01_lod",
--   "h4_se_ipl_06_lod",
--   "h4_ne_ipl_03",
--   "h4_islandx_maindock",
--   "h4_se_ipl_01",
--   "h4_sw_ipl_07",
--   "h4_islandx_maindock_props_2",
--   "h4_islandxtower_veg",
--   "h4_mph4_island_sw_placement",
--   "h4_se_ipl_01_slod",
--   "h4_mph4_wtowers",
--   "h4_se_ipl_02_lod",
--   "h4_islandx_mansion",
--   "h4_nw_ipl_04",
--   "h4_islandx_mansion_lockup_01",
--   "h4_islandx_barrack_props",
--   "h4_nw_ipl_07_lod",
--   "h4_nw_ipl_00_slod",
--   "h4_sw_ipl_08_lod",
--   "h4_islandxdock_props_slod",
--   "h4_islandx_mansion_lockup_02",
--   "h4_islandx_mansion_slod",
--   "h4_sw_ipl_07_lod",
--   "h4_islandairstrip_doorsclosed_lod",
--   "h4_sw_ipl_02_lod",
--   "h4_se_ipl_04_slod",
--   "h4_islandx_checkpoint_props_lod",
--   "h4_se_ipl_04",
--   "h4_se_ipl_07",
--   "h4_mph4_mansion_b_strm_0",
--   "h4_nw_ipl_09_slod",
--   "h4_se_ipl_07_lod",
--   "h4_islandx_maindock_slod",
--   "h4_islandx_mansion_lod",
--   "h4_sw_ipl_05_lod",
--   "h4_nw_ipl_08",
--   "h4_islandairstrip_slod",
--   "h4_nw_ipl_07",
--   "h4_islandairstrip_propsb_lod",
--   "h4_islandx_checkpoint_props_slod",
--   -- "h4_aa_guns_lod",
--   "h4_sw_ipl_06",
--   "h4_islandx_maindock_props_2_slod",
--   "h4_islandx_mansion_office",
--   "h4_islandx_maindock_lod",
--   "h4_mph4_dock",
--   "h4_islandairstrip_propsb",
--   "h4_islandx_mansion_lockup_03",
--   "h4_nw_ipl_01_lod",
--   "h4_se_ipl_05_slod",
--   "h4_sw_ipl_01_lod",
--   "h4_nw_ipl_05",
--   "h4_islandxdock_props_2_lod",
--   "h4_ne_ipl_04_lod",
--   "h4_ne_ipl_01",
--   "h4_beach_party_lod",
--   "h4_islandx_mansion_lights",
--   "h4_sw_ipl_00_lod",
--   "h4_islandx_mansion_guardfence",
--   "h4_beach_props_party",
--   "h4_ne_ipl_03_lod",
--   "h4_islandx_mansion_b",
--   "h4_beach_bar_props",
--   "h4_ne_ipl_04",
--   "h4_sw_ipl_08_slod",
--   "h4_islandxtower",
--   "h4_se_ipl_00_slod",
--   "h4_islandx_barrack_hatch",
--   "h4_ne_ipl_06_slod",
--   "h4_ne_ipl_03_slod",
--   "h4_sw_ipl_09_slod",
--   "h4_ne_ipl_02_slod",
--   "h4_nw_ipl_04_slod",
--   "h4_ne_ipl_05_lod",
--   "h4_nw_ipl_08_slod",
--   "h4_sw_ipl_05_slod",
--   "h4_islandx_mansion_b_lod",
--   "h4_ne_ipl_08",
--   "h4_islandxdock_props",
--   "h4_islandairstrip_doorsopen_lod",
--   "h4_se_ipl_05_lod",
--   "h4_islandxcanal_props_slod",
--   "h4_mansion_gate_closed",
--   "h4_se_ipl_02_slod",
--   "h4_nw_ipl_02",
--   "h4_ne_ipl_08_lod",
--   "h4_sw_ipl_08",
--   "h4_islandairstrip",
--   "h4_islandairstrip_props_lod",
--   "h4_se_ipl_05",
--   "h4_ne_ipl_02_lod",
--   "h4_islandx_maindock_props_2_lod",
--   "h4_sw_ipl_03_slod",
--   "h4_ne_ipl_01_slod",
--   "h4_beach_props_slod",
--   "h4_underwater_gate_closed",
--   "h4_ne_ipl_00_lod",
--   "h4_islandairstrip_doorsopen",
--   "h4_sw_ipl_01_slod",
--   "h4_se_ipl_00",
--   "h4_se_ipl_06",
--   "h4_islandx_mansion_lockup_02_lod",
--   "h4_islandxtower_veg_lod",
--   "h4_sw_ipl_00",
--   "h4_se_ipl_04_lod",
--   "h4_nw_ipl_07_slod",
--   "h4_islandx_mansion_props_lod",
--   "h4_islandairstrip_hangar_props",
--   "h4_nw_ipl_06_lod",
--   "h4_islandxtower_lod",
--   "h4_islandxdock_lod",
--   "h4_islandxdock_props_lod",
--   "h4_beach_party",
--   "h4_nw_ipl_06_slod",
--   "h4_islandairstrip_doorsclosed",
--   "h4_nw_ipl_00_lod",
--   "h4_ne_ipl_02",
--   "h4_islandxdock_slod",
--   "h4_se_ipl_07_slod",
--   "h4_islandxdock",
--   "h4_islandxdock_props_2_slod",
--   "h4_islandairstrip_props",
--   "h4_sw_ipl_09",
--   "h4_ne_ipl_06",
--   "h4_se_ipl_03_lod",
--   "h4_nw_ipl_03",
--   "h4_islandx_mansion_lockup_01_lod",
--   "h4_beach_lod",
--   "h4_ne_ipl_07_lod",
--   "h4_nw_ipl_01",
--   "h4_mph4_island_lod",
--   "h4_islandx_mansion_office_lod",
--   "h4_islandairstrip_lod",
--   "h4_beach_props_lod",
--   "h4_nw_ipl_05_slod",
--   "h4_islandx_checkpoint_lod",
--   "h4_nw_ipl_05_lod",
--   "h4_nw_ipl_03_slod",
--   "h4_nw_ipl_03_lod",
--   "h4_sw_ipl_05",
--   "h4_mph4_mansion",
--   "h4_sw_ipl_03",
--   "h4_se_ipl_08_slod",
--   "h4_mph4_island_ne_placement",
--   -- "h4_aa_guns",
--   "h4_islandairstrip_propsb_slod",
--   "h4_sw_ipl_01",
--   "h4_mansion_remains_cage",
--   "h4_nw_ipl_01_slod",
--   "h4_ne_ipl_06_lod",
--   "h4_se_ipl_08",
--   "h4_sw_ipl_04_slod",
--   "h4_sw_ipl_04_lod",
--   "h4_mph4_beach",
--   "h4_sw_ipl_06_lod",
--   "h4_sw_ipl_06_slod",
--   "h4_se_ipl_00_lod",
--   "h4_ne_ipl_07_slod",
--   "h4_mph4_mansion_strm_0",
--   "h4_nw_ipl_02_slod",
--   "h4_mph4_airstrip",
--   "h4_mansion_gate_broken",
--   "h4_island_padlock_props",
--   "h4_islandairstrip_props_slod",
--   "h4_nw_ipl_06",
--   "h4_sw_ipl_09_lod",
--   "h4_islandxcanal_props_lod",
--   "h4_ne_ipl_05_slod",
--   "h4_se_ipl_09_slod",
--   "h4_islandx_mansion_vault_lod",
--   "h4_se_ipl_03_slod",
--   "h4_nw_ipl_08_lod",
--   "h4_islandx_barrack_props_slod",
--   "h4_islandxtower_veg_slod",
--   "h4_sw_ipl_04",
--   "h4_islandx_mansion_props",
--   "h4_islandxtower_slod",
--   "h4_beach_props",
--   "h4_islandx_mansion_b_slod",
--   "h4_islandx_maindock_props_slod",
--   "h4_sw_ipl_07_slod",
--   "h4_ne_ipl_07",
--   "h4_islandxdock_props_2",
--   "h4_ne_ipl_09_lod",
--   "h4_islandxcanal_props",
--   "h4_beach_slod",
--   "h4_sw_ipl_00_slod",
--   "h4_sw_ipl_03_lod",
--   "h4_islandx_disc_strandedshark",
--   "h4_islandx_disc_strandedshark_lod",
--   "h4_islandx",
--   "h4_islandx_props_lod",
--   "h4_mph4_island_strm_0",
--   "h4_islandx_sea_mines",
--   "h4_mph4_island",
--   "h4_boatblockers",
--   "h4_mph4_island_long_0",
--   "h4_islandx_disc_strandedwhale",
--   "h4_islandx_disc_strandedwhale_lod",
--   "h4_islandx_props",
--   "h4_int_placement_h4_interior_1_dlc_int_02_h4_milo_",
--   "h4_int_placement_h4_interior_0_int_sub_h4_milo_",
--   "h4_int_placement_h4",
-- }
-- RegisterCommand("loadipls", function()
--   for _, ipl in pairs(ipls) do
--     RequestIpl(ipl)
--     print(ipl)
--     Wait(500)
--   end
-- end, false)
-- RegisterCommand("unloadipls", function()
--   for _, ipl in pairs(ipls) do
--     RemoveIpl(ipl)
--     print(ipl)
--     Wait(100)
--   end
-- end, false)


-- alt load method, not sure if any good
  -- Citizen.CreateThread(function()

  --     RequestIpl("h4_mph4_terrain_occ_09")

  --     RequestIpl("h4_mph4_terrain_occ_06")

  --     RequestIpl("h4_mph4_terrain_occ_05")

  --     RequestIpl("h4_mph4_terrain_occ_01")

  --     RequestIpl("h4_mph4_terrain_occ_00")

  --     RequestIpl("h4_mph4_terrain_occ_08")

  --     RequestIpl("h4_mph4_terrain_occ_04")

  --     RequestIpl("h4_mph4_terrain_occ_07")

  --     RequestIpl("h4_mph4_terrain_occ_03")

  --     RequestIpl("h4_mph4_terrain_occ_02")

  --     RequestIpl("h4_islandx_terrain_04")

  --     RequestIpl("h4_islandx_terrain_05_slod")

  --     RequestIpl("h4_islandx_terrain_props_05_d_slod")

  --     RequestIpl("h4_islandx_terrain_02")

  --     RequestIpl("h4_islandx_terrain_props_05_a_lod")

  --     RequestIpl("h4_islandx_terrain_props_05_c_lod")

  --     RequestIpl("h4_islandx_terrain_01")

  --     RequestIpl("h4_mph4_terrain_04")

  --     RequestIpl("h4_mph4_terrain_06")

  --     RequestIpl("h4_islandx_terrain_04_lod")

  --     RequestIpl("h4_islandx_terrain_03_lod")

  --     RequestIpl("h4_islandx_terrain_props_06_a")

  --     RequestIpl("h4_islandx_terrain_props_06_a_slod")

  --     RequestIpl("h4_islandx_terrain_props_05_f_lod")

  --     RequestIpl("h4_islandx_terrain_props_06_b")

  --     RequestIpl("h4_islandx_terrain_props_05_b_lod")

  --     RequestIpl("h4_mph4_terrain_lod")

  --     RequestIpl("h4_islandx_terrain_props_05_e_lod")

  --     RequestIpl("h4_islandx_terrain_05_lod")

  --     RequestIpl("h4_mph4_terrain_02")

  --     RequestIpl("h4_islandx_terrain_props_05_a")

  --     RequestIpl("h4_mph4_terrain_01_long_0")

  --     RequestIpl("h4_islandx_terrain_03")

  --     RequestIpl("h4_islandx_terrain_props_06_b_slod")

  --     RequestIpl("h4_islandx_terrain_01_slod")

  --     RequestIpl("h4_islandx_terrain_04_slod")

  --     RequestIpl("h4_islandx_terrain_props_05_d_lod")

  --     RequestIpl("h4_islandx_terrain_props_05_f_slod")

  --     RequestIpl("h4_islandx_terrain_props_05_c")

  --     RequestIpl("h4_islandx_terrain_02_lod")

  --     RequestIpl("h4_islandx_terrain_06_slod")

  --     RequestIpl("h4_islandx_terrain_props_06_c_slod")

  --     RequestIpl("h4_islandx_terrain_props_06_c")

  --     RequestIpl("h4_islandx_terrain_01_lod")

  --     RequestIpl("h4_mph4_terrain_06_strm_0")

  --     RequestIpl("h4_islandx_terrain_05")

  --     RequestIpl("h4_islandx_terrain_props_05_e_slod")

  --     RequestIpl("h4_islandx_terrain_props_06_c_lod")

  --     RequestIpl("h4_mph4_terrain_03")

  --     RequestIpl("h4_islandx_terrain_props_05_f")

  --     RequestIpl("h4_islandx_terrain_06_lod")

  --     RequestIpl("h4_mph4_terrain_01")

  --     RequestIpl("h4_islandx_terrain_06")

  --     RequestIpl("h4_islandx_terrain_props_06_a_lod")

  --     RequestIpl("h4_islandx_terrain_props_06_b_lod")

  --     RequestIpl("h4_islandx_terrain_props_05_b")

  --     RequestIpl("h4_islandx_terrain_02_slod")

  --     RequestIpl("h4_islandx_terrain_props_05_e")

  --     RequestIpl("h4_islandx_terrain_props_05_d")

  --     RequestIpl("h4_mph4_terrain_05")

  --     RequestIpl("h4_mph4_terrain_02_grass_2")

  --     RequestIpl("h4_mph4_terrain_01_grass_1")

  --     RequestIpl("h4_mph4_terrain_05_grass_0")

  --     RequestIpl("h4_mph4_terrain_01_grass_0")

  --     RequestIpl("h4_mph4_terrain_02_grass_1")

  --     RequestIpl("h4_mph4_terrain_02_grass_0")

  --     RequestIpl("h4_mph4_terrain_02_grass_3")

  --     RequestIpl("h4_mph4_terrain_04_grass_0")

  --     RequestIpl("h4_mph4_terrain_06_grass_0")

  --     RequestIpl("h4_mph4_terrain_04_grass_1")

  --     RequestIpl("island_distantlights")

  --     RequestIpl("island_lodlights")

  --     RequestIpl("h4_yacht_strm_0")

  --     RequestIpl("h4_yacht")

  --     RequestIpl("h4_yacht_long_0")

  --     RequestIpl("h4_islandx_yacht_01_lod")

  --     RequestIpl("h4_clubposter_palmstraxx")

  --     RequestIpl("h4_islandx_yacht_02_int")

  --     RequestIpl("h4_islandx_yacht_02")

  --     RequestIpl("h4_clubposter_moodymann")

  --     RequestIpl("h4_islandx_yacht_01")

  --     RequestIpl("h4_clubposter_keinemusik")

  --     RequestIpl("h4_islandx_yacht_03")

  --     RequestIpl("h4_ch2_mansion_final")

  --     RequestIpl("h4_islandx_yacht_03_int")

  --     RequestIpl("h4_yacht_critical_0")

  --     RequestIpl("h4_islandx_yacht_01_int")

  --     RequestIpl("h4_mph4_island_placement")

  --     RequestIpl("h4_islandx_mansion_vault")

  --     RequestIpl("h4_islandx_checkpoint_props")

  --     RequestIpl("h4_mph4_airstrip_interior_0_airstrip_hanger")

  --     RequestIpl("h4_islandairstrip_hangar_props_slod")

  --     RequestIpl("h4_se_ipl_01_lod")

  --     RequestIpl("h4_ne_ipl_00_slod")

  --     RequestIpl("h4_se_ipl_06_slod")

  --     RequestIpl("h4_ne_ipl_00")

  --     RequestIpl("h4_se_ipl_02")

  --     RequestIpl("h4_islandx_barrack_props_lod")

  --     RequestIpl("h4_se_ipl_09_lod")

  --     RequestIpl("h4_ne_ipl_05")

  --     RequestIpl("h4_mph4_island_se_placement")

  --     RequestIpl("h4_ne_ipl_09")

  --     RequestIpl("h4_islandx_mansion_props_slod")

  --     RequestIpl("h4_se_ipl_09")

  --     RequestIpl("h4_mph4_mansion_b")

  --     RequestIpl("h4_islandairstrip_hangar_props_lod")

  --     RequestIpl("h4_islandx_mansion_entrance_fence")

  --     RequestIpl("h4_nw_ipl_09")

  --     RequestIpl("h4_nw_ipl_02_lod")

  --     RequestIpl("h4_ne_ipl_09_slod")

  --     RequestIpl("h4_sw_ipl_02")

  --     RequestIpl("h4_islandx_checkpoint")

  --     RequestIpl("h4_islandxdock_water_hatch")

  --     RequestIpl("h4_nw_ipl_04_lod")

  --     RequestIpl("h4_islandx_maindock_props")

  --     RequestIpl("h4_beach")

  --     RequestIpl("h4_islandx_mansion_lockup_03_lod")

  --     RequestIpl("h4_ne_ipl_04_slod")

  --     RequestIpl("h4_mph4_island_nw_placement")

  --     RequestIpl("h4_ne_ipl_08_slod")

  --     RequestIpl("h4_nw_ipl_09_lod")

  --     RequestIpl("h4_se_ipl_08_lod")

  --     RequestIpl("h4_islandx_maindock_props_lod")

  --     RequestIpl("h4_se_ipl_03")

  --     RequestIpl("h4_sw_ipl_02_slod")

  --     RequestIpl("h4_nw_ipl_00")

  --     RequestIpl("h4_islandx_mansion_b_side_fence")

  --     RequestIpl("h4_ne_ipl_01_lod")

  --     RequestIpl("h4_se_ipl_06_lod")

  --     RequestIpl("h4_ne_ipl_03")

  --     RequestIpl("h4_islandx_maindock")

  --     RequestIpl("h4_se_ipl_01")

  --     RequestIpl("h4_sw_ipl_07")

  --     RequestIpl("h4_islandx_maindock_props_2")

  --     RequestIpl("h4_islandxtower_veg")

  --     RequestIpl("h4_mph4_island_sw_placement")

  --     RequestIpl("h4_se_ipl_01_slod")

  --     RequestIpl("h4_mph4_wtowers")

  --     RequestIpl("h4_se_ipl_02_lod")

  --     RequestIpl("h4_islandx_mansion")

  --     RequestIpl("h4_nw_ipl_04")

  --     RequestIpl("h4_islandx_mansion_lockup_01")

  --     RequestIpl("h4_islandx_barrack_props")

  --     RequestIpl("h4_nw_ipl_07_lod")

  --     RequestIpl("h4_nw_ipl_00_slod")

  --     RequestIpl("h4_sw_ipl_08_lod")

  --     RequestIpl("h4_islandxdock_props_slod")

  --     RequestIpl("h4_islandx_mansion_lockup_02")

  --     RequestIpl("h4_islandx_mansion_slod")

  --     RequestIpl("h4_sw_ipl_07_lod")

  --     RequestIpl("h4_islandairstrip_doorsclosed_lod")

  --     RequestIpl("h4_sw_ipl_02_lod")

  --     RequestIpl("h4_se_ipl_04_slod")

  --     RequestIpl("h4_islandx_checkpoint_props_lod")

  --     RequestIpl("h4_se_ipl_04")

  --     RequestIpl("h4_se_ipl_07")

  --     RequestIpl("h4_mph4_mansion_b_strm_0")

  --     RequestIpl("h4_nw_ipl_09_slod")

  --     RequestIpl("h4_se_ipl_07_lod")

  --     RequestIpl("h4_islandx_maindock_slod")

  --     RequestIpl("h4_islandx_mansion_lod")

  --     RequestIpl("h4_sw_ipl_05_lod")

  --     RequestIpl("h4_nw_ipl_08")

  --     RequestIpl("h4_islandairstrip_slod")

  --     RequestIpl("h4_nw_ipl_07")

  --     RequestIpl("h4_islandairstrip_propsb_lod")

  --     RequestIpl("h4_islandx_checkpoint_props_slod")

  --     RequestIpl("h4_aa_guns_lod")

  --     RequestIpl("h4_sw_ipl_06")

  --     RequestIpl("h4_islandx_maindock_props_2_slod")

  --     RequestIpl("h4_islandx_mansion_office")

  --     RequestIpl("h4_islandx_maindock_lod")

  --     RequestIpl("h4_mph4_dock")

  --     RequestIpl("h4_islandairstrip_propsb")

  --     RequestIpl("h4_islandx_mansion_lockup_03")

  --     RequestIpl("h4_nw_ipl_01_lod")

  --     RequestIpl("h4_se_ipl_05_slod")

  --     RequestIpl("h4_sw_ipl_01_lod")

  --     RequestIpl("h4_nw_ipl_05")

  --     RequestIpl("h4_islandxdock_props_2_lod")

  --     RequestIpl("h4_ne_ipl_04_lod")

  --     RequestIpl("h4_ne_ipl_01")

  --     RequestIpl("h4_beach_party_lod")

  --     RequestIpl("h4_islandx_mansion_lights")

  --     RequestIpl("h4_sw_ipl_00_lod")

  --     RequestIpl("h4_islandx_mansion_guardfence")

  --     RequestIpl("h4_beach_props_party")

  --     RequestIpl("h4_ne_ipl_03_lod")

  --     RequestIpl("h4_islandx_mansion_b")

  --     RequestIpl("h4_beach_bar_props")

  --     RequestIpl("h4_ne_ipl_04")

  --     RequestIpl("h4_sw_ipl_08_slod")

  --     RequestIpl("h4_islandxtower")

  --     RequestIpl("h4_se_ipl_00_slod")

  --     RequestIpl("h4_islandx_barrack_hatch")

  --     RequestIpl("h4_ne_ipl_06_slod")

  --     RequestIpl("h4_ne_ipl_03_slod")

  --     RequestIpl("h4_sw_ipl_09_slod")

  --     RequestIpl("h4_ne_ipl_02_slod")

  --     RequestIpl("h4_nw_ipl_04_slod")

  --     RequestIpl("h4_ne_ipl_05_lod")

  --     RequestIpl("h4_nw_ipl_08_slod")

  --     RequestIpl("h4_sw_ipl_05_slod")

  --     RequestIpl("h4_islandx_mansion_b_lod")

  --     RequestIpl("h4_ne_ipl_08")

  --     RequestIpl("h4_islandxdock_props")

  --     RequestIpl("h4_islandairstrip_doorsopen_lod")

  --     RequestIpl("h4_se_ipl_05_lod")

  --     RequestIpl("h4_islandxcanal_props_slod")

  --     RequestIpl("h4_mansion_gate_closed")

  --     RequestIpl("h4_se_ipl_02_slod")

  --     RequestIpl("h4_nw_ipl_02")

  --     RequestIpl("h4_ne_ipl_08_lod")

  --     RequestIpl("h4_sw_ipl_08")

  --     RequestIpl("h4_islandairstrip")

  --     RequestIpl("h4_islandairstrip_props_lod")

  --     RequestIpl("h4_se_ipl_05")

  --     RequestIpl("h4_ne_ipl_02_lod")

  --     RequestIpl("h4_islandx_maindock_props_2_lod")

  --     RequestIpl("h4_sw_ipl_03_slod")

  --     RequestIpl("h4_ne_ipl_01_slod")

  --     RequestIpl("h4_beach_props_slod")

  --     RequestIpl("h4_underwater_gate_closed")

  --     RequestIpl("h4_ne_ipl_00_lod")

  --     RequestIpl("h4_islandairstrip_doorsopen")

  --     RequestIpl("h4_sw_ipl_01_slod")

  --     RequestIpl("h4_se_ipl_00")

  --     RequestIpl("h4_se_ipl_06")

  --     RequestIpl("h4_islandx_mansion_lockup_02_lod")

  --     RequestIpl("h4_islandxtower_veg_lod")

  --     RequestIpl("h4_sw_ipl_00")

  --     RequestIpl("h4_se_ipl_04_lod")

  --     RequestIpl("h4_nw_ipl_07_slod")

  --     RequestIpl("h4_islandx_mansion_props_lod")

  --     RequestIpl("h4_islandairstrip_hangar_props")

  --     RequestIpl("h4_nw_ipl_06_lod")

  --     RequestIpl("h4_islandxtower_lod")

  --     RequestIpl("h4_islandxdock_lod")

  --     RequestIpl("h4_islandxdock_props_lod")

  --     RequestIpl("h4_beach_party")

  --     RequestIpl("h4_nw_ipl_06_slod")

  --     RequestIpl("h4_islandairstrip_doorsclosed")

  --     RequestIpl("h4_nw_ipl_00_lod")

  --     RequestIpl("h4_ne_ipl_02")

  --     RequestIpl("h4_islandxdock_slod")

  --     RequestIpl("h4_se_ipl_07_slod")

  --     RequestIpl("h4_islandxdock")

  --     RequestIpl("h4_islandxdock_props_2_slod")

  --     RequestIpl("h4_islandairstrip_props")

  --     RequestIpl("h4_sw_ipl_09")

  --     RequestIpl("h4_ne_ipl_06")

  --     RequestIpl("h4_se_ipl_03_lod")

  --     RequestIpl("h4_nw_ipl_03")

  --     RequestIpl("h4_islandx_mansion_lockup_01_lod")

  --     RequestIpl("h4_beach_lod")

  --     RequestIpl("h4_ne_ipl_07_lod")

  --     RequestIpl("h4_nw_ipl_01")

  --     RequestIpl("h4_mph4_island_lod")

  --     RequestIpl("h4_islandx_mansion_office_lod")

  --     RequestIpl("h4_islandairstrip_lod")

  --     RequestIpl("h4_beach_props_lod")

  --     RequestIpl("h4_nw_ipl_05_slod")

  --     RequestIpl("h4_islandx_checkpoint_lod")

  --     RequestIpl("h4_nw_ipl_05_lod")

  --     RequestIpl("h4_nw_ipl_03_slod")

  --     RequestIpl("h4_nw_ipl_03_lod")

  --     RequestIpl("h4_sw_ipl_05")

  --     RequestIpl("h4_mph4_mansion")

  --     RequestIpl("h4_sw_ipl_03")

  --     RequestIpl("h4_se_ipl_08_slod")

  --     RequestIpl("h4_mph4_island_ne_placement")

  --     RequestIpl("h4_aa_guns")

  --     RequestIpl("h4_islandairstrip_propsb_slod")

  --     RequestIpl("h4_sw_ipl_01")

  --     RequestIpl("h4_mansion_remains_cage")

  --     RequestIpl("h4_nw_ipl_01_slod")

  --     RequestIpl("h4_ne_ipl_06_lod")

  --     RequestIpl("h4_se_ipl_08")

  --     RequestIpl("h4_sw_ipl_04_slod")

  --     RequestIpl("h4_sw_ipl_04_lod")

  --     RequestIpl("h4_mph4_beach")

  --     RequestIpl("h4_sw_ipl_06_lod")

  --     RequestIpl("h4_sw_ipl_06_slod")

  --     RequestIpl("h4_se_ipl_00_lod")

  --     RequestIpl("h4_ne_ipl_07_slod")

  --     RequestIpl("h4_mph4_mansion_strm_0")

  --     RequestIpl("h4_nw_ipl_02_slod")

  --     RequestIpl("h4_mph4_airstrip")

  --     --RequestIpl("h4_mansion_gate_broken")

  --     RequestIpl("h4_island_padlock_props")

  --     RequestIpl("h4_islandairstrip_props_slod")

  --     RequestIpl("h4_nw_ipl_06")

  --     RequestIpl("h4_sw_ipl_09_lod")

  --     RequestIpl("h4_islandxcanal_props_lod")

  --     RequestIpl("h4_ne_ipl_05_slod")

  --     RequestIpl("h4_se_ipl_09_slod")

  --     RequestIpl("h4_islandx_mansion_vault_lod")

  --     RequestIpl("h4_se_ipl_03_slod")

  --     RequestIpl("h4_nw_ipl_08_lod")

  --     RequestIpl("h4_islandx_barrack_props_slod")

  --     RequestIpl("h4_islandxtower_veg_slod")

  --     RequestIpl("h4_sw_ipl_04")

  --     RequestIpl("h4_islandx_mansion_props")

  --     RequestIpl("h4_islandxtower_slod")

  --     RequestIpl("h4_beach_props")

  --     RequestIpl("h4_islandx_mansion_b_slod")

  --     RequestIpl("h4_islandx_maindock_props_slod")

  --     RequestIpl("h4_sw_ipl_07_slod")

  --     RequestIpl("h4_ne_ipl_07")

  --     RequestIpl("h4_islandxdock_props_2")

  --     RequestIpl("h4_ne_ipl_09_lod")

  --     RequestIpl("h4_islandxcanal_props")

  --     RequestIpl("h4_beach_slod")

  --     RequestIpl("h4_sw_ipl_00_slod")

  --     RequestIpl("h4_sw_ipl_03_lod")

  --     RequestIpl("h4_islandx_disc_strandedshark")

  --     RequestIpl("h4_islandx_disc_strandedshark_lod")

  --     RequestIpl("h4_islandx")

  --     RequestIpl("h4_islandx_props_lod")

  --     RequestIpl("h4_mph4_island_strm_0")

  --     RequestIpl("h4_islandx_sea_mines")

  --     RequestIpl("h4_mph4_island")

  --     RequestIpl("h4_boatblockers")

  --     RequestIpl("h4_mph4_island_long_0")

  --     RequestIpl("h4_islandx_disc_strandedwhale")

  --     RequestIpl("h4_islandx_disc_strandedwhale_lod")

  --     RequestIpl("h4_islandx_props")

  --     RequestIpl("h4_int_placement_h4_interior_1_dlc_int_02_h4_milo_")

  --     RequestIpl("h4_int_placement_h4_interior_0_int_sub_h4_milo_")

  --     RequestIpl("h4_int_placement_h4")

  -- end)
