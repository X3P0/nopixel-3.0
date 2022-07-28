

Housing.missionTimeout = 3000 -- 50 mins == 3000
Housing.reuseTime = 3600 -- time until the property can be reused for robbery once robbed
Housing.staticObjectsChance = 30
Housing.secondsPerJobCreated = 90 -- every 3 mins a job has the potential to be created
Housing.maxJobsAtAGivenTime = 16

Housing.WaitTimes = {
    ["stolenmusic"] = 9000,
    ["stolencoffee"] = 8000,
    ["stolentv"] = 20000,
    ["stolenmicrowave"] = 15000,
    ["stolencomputer"] = 17000,
    ["stolenart"] = 22000,
}


Housing.robInformation = {
    ["dynamic"] = {
        ["prop_coffee_mac_02"] = "stolencoffee",
    },
    ["safeLocations"] = {
        ["v_int_16_mid"] = vector4(9.79,1.66,0.98,265.39),
        ["v_int_44"] = vector4(-7.53,6.28,5.59,89.14),
        ["v_int_49"] = vector4(0.14,4.17,1.01,354.56),
        ["v_int_24_full"] = vector4(-3.14,-6.25,1.0,179.23),
    },
    ["staticLocations"] = {
        ["v_int_16_mid"] = {
            ["maxLocations"] = 9, -- Max possible locations for a given model
            ["maxGenerationAttempts"] = 18, -- Max attempts to fill out the 6 locations , the greater the difference to locations the more likely to fill the max locations
            ["staticObjects"] = {
                ["prop_tv_flat_01"] = "stolentv",
                ["prop_micro_01"] = "stolenmicrowave",

            },
            ["staticPositions"] = {
                {["pos"] = vector4(-4.65,0.49,0.97,87.88),["itemCat"] = "electronics"},
                {["pos"] = vector4(8.68,-1.76,0.98,180.83),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(9.21,-1.47,0.98,271.55),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(8.42,3.84,0.98,1.97),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(7.46,3.83,0.98,4.94),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(6.48,2.59,0.98,91.51),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(3.26,-4.3,0.98,90.9),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-1.8,-6.1,0.97,180.04),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-3.29,-5.96,0.97,158.92),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(2.46,0.35,0.97,274.49),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(2.55,1.63,0.97,268.47),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(2.47,3.1,0.97,268.86),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(2.46,4.15,0.97,270.78),["itemCat"] = "randomHousehold"},
            }
        },

        ["v_int_44"] = {
            ["maxLocations"] = 13,
            ["maxGenerationAttempts"] = 25,
            ["staticObjects"] = {
                ["prop_mp3_dock"] = "stolenmusic",
                ["prop_speaker_06"] = "stolenmusic",
                ["prop_speaker_01"] = "stolenmusic",
                ["v_club_roc_cab3"] = "stolenmusic",
                ["v_club_roc_cabamp"] = "stolenmusic",
                ["v_club_roc_eq1"] = "stolenmusic",
                ["v_club_roc_eq2"] = "stolenmusic",
                ["prop_amp_01"] = "stolenmusic",
                ["v_res_pctower"] = "stolencomputer",
                ["prop_laptop_01a"] = "stolencomputer", 
                ["prop_console_01"] = "stolencomputer",
                ["prop_micro_02"] = "stolenmicrowave",
                ["prop_tv_flat_03b"] = "stolentv",
                --["v_res_m_spanishbox"] = "jewllootbox",
                --["v_res_jewelbox"] = "jewllootbox",
            },
            ["staticPositions"] = {
                {["pos"] = vector4(-0.71,-5.78,1.68,85.63),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-0.71,-4.05,1.68,86.96),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-0.71,-2.35,1.68,77.51),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(3.23,1.12,1.68,1.8),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(1.93,5.92,1.01,2.45),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-0.75,0.63,5.58,176.36),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-1.55,7.23,5.58,275.78),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-1.54,8.72,5.58,270.13),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-2.9,8.59,5.59,6.21),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-5.66,8.6,5.59,358.11),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-3.82,2.29,5.74,325.38),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(-3.83,1.2,5.59,203.0),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(5.82,-2.42,5.58,349.38),["itemCat"] = "randomClothes"},
            }
        },
        ["v_int_49"] = {
            ["maxLocations"] = 6,
            ["maxGenerationAttempts"] = 14,
            ["staticObjects"] = {
                
            },
            ["staticPositions"] = {
                {["pos"] = vector4(1.86,3.73,1.01,3.76),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-0.42,3.28,1.01,87.71),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(2.05,1.13,1.01,255.46),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(2.52,-1.46,1.01,272.27),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-1.02,-0.51,1.01,78.89),["itemCat"] = "electronics"},
                {["pos"] = vector4(-0.97,1.16,1.01,28.76),["itemCat"] = "electronics"},
            }
        },
        ["v_int_24_full"] = {
            ["maxLocations"] = 12,
            ["maxGenerationAttempts"] = 20,
            ["staticObjects"] = {
                ["prop_laptop_01a"] = "stolencomputer",
                ["prop_tv_flat_01"] = "stolentv",
                ["v_24_bdrm_mesh_arta"] = "stolenart",
                ["v_res_fh_speakerdock"] = "stolenmusic",
                ["v_24_lnb_mesh_artwork"] = "stolenart",
            },
            ["staticPositions"] = {
                {["pos"] = vector4(6.75,6.31,6.41,41.62),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(6.58,-2.19,5.01,218.87),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-0.46,-2.91,5.01,34.73),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-5.39,-2.9,5.01,302.66),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-9.17,4.92,5.38,352.09),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-3.62,6.05,5.72,26.95),["itemCat"] = "electronics"},
                {["pos"] = vector4(-1.46,7.61,5.72,351.32),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(1.24,-0.81,1.0,260.02),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-6.64,-1.66,1.0,82.89),["itemCat"] = "randomHousehold"},
                {["pos"] =  vector4(-6.66,-4.94,1.0,92.25),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(5.39,-1.91,1.0,284.25),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(5.42,-3.99,1.0,268.65),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(-15.92,-2.99,5.01,32.98),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-17.59,-4.39,5.01,38.16),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-19.39,-5.54,5.01,28.45),["itemCat"] = "randomHousehold"},

            }
        },
    }
}


Housing.robCat = {

    ["electronics"] = {
        ["catChance"] = 50, -- chance it will get added to generator if picked
        ["maxItems"] = 4,
        ["items"] = {
 
            {["name"] = "aluminium", ["chance"] = 30},
            {["name"] = "plastic", ["chance"] = 30},
            {["name"] = "copper", ["chance"] = 30},
            {["name"] = "electronics", ["chance"] = 10},
            {["name"] = "rubber", ["chance"] = 30},
            {["name"] = "scrapmetal", ["chance"] = 30},
        }
    },

    ["randomHousehold"] = {
        ["catChance"] = 80,
        ["maxItems"] = 6,
        ["items"] = {
            {["name"] = "aluminiumoxide", ["chance"] = 3},
            {["name"] = "steel", ["chance"] = 10},
            {["name"] = "lockpick", ["chance"] = 4},
            {["name"] = "mobilephone", ["chance"] = 3},
            {["name"] = "muffin", ["chance"] = 15},
            {["name"] = "mugbeer", ["chance"] = 15},
            {["name"] = "rolexwatch", ["chance"] = 15},
            {["name"] = "pistolammo", ["chance"] = 5},
            {["name"] = "joint", ["chance"] = 10},
            {["name"] = "humantooth", ["chance"] = 3},
            {["name"] = "scrapmetal", ["chance"] = 10},
            {["name"] = "stolen2ctchain", ["chance"] = 15},
            {["name"] = "stolens8", ["chance"] = 15},
            {["name"] = "cleaningproduct2", ["chance"] = 70},
            {["name"] = "ammonium_bicarbonate", ["chance"] = 50},
            {["name"] = "towrope", ["chance"] = 30},
            {["name"] = "jewelry_part", ["chance"] = 60},
            {["name"] = "jewelry_relic", ["chance"] = 4},
            {["name"] = "screwdriver", ["chance"] = 25},
        }
    },

    ["randomClothes"] = {
        ["catChance"] = 70,
        ["maxItems"] = 4,
        ["items"] = {
            {["name"] = "stolen10ctchain", ["chance"] = 5},
            {["name"] = "stolen2ctchain", ["chance"] = 30},
            {["name"] = "stolen5ctchain", ["chance"] = 20},
            {["name"] = "stolen8ctchain", ["chance"] = 10},
            {["name"] = "stolencasiowatch", ["chance"] = 30},
            {["name"] = "stolengameboy", ["chance"] = 30},
            {["name"] = "stoleniphone", ["chance"] = 30},
            {["name"] = "stolennokia", ["chance"] = 30},
            {["name"] = "stolenoakleys", ["chance"] = 30},
            {["name"] = "stolenpixel3", ["chance"] = 30},
            {["name"] = "stolenpsp", ["chance"] = 30},
            {["name"] = "stolenraybans", ["chance"] = 30},
            {["name"] = "stolens8", ["chance"] = 30},
            {["name"] = "bandage", ["chance"] = 50},
            {["name"] = "jewelry_ring", ["chance"] = 50},
            {["name"] = "jewelry_necklace", ["chance"] = 30},
        }
    },
    ["randomFood"] = {
        ["catChance"] = 75,
        ["maxItems"] = 6,
        ["items"] = {
            {["name"] = "donut", ["chance"] = 60},
            {["name"] = "foodgoods", ["chance"] = 60},
            {["name"] = "foodingredient", ["chance"] = 60},
            {["name"] = "fries", ["chance"] = 60},
            {["name"] = "greencow", ["chance"] = 60},
            {["name"] = "churro", ["chance"] = 60},
            {["name"] = "bakingsoda", ["chance"] = 20},
            {["name"] = "bleederburger", ["chance"] = 60},
            {["name"] = "water", ["chance"] = 90},
            {["name"] = "hotdog", ["chance"] = 60},
            {["name"] = "icecream", ["chance"] = 60},
            {["name"] = "jailfood", ["chance"] = 60},
            {["name"] = "sandwich", ["chance"] = 60},
            {["name"] = "torpedo", ["chance"] = 60},
            {["name"] = "treat", ["chance"] = 60},
            {["name"] = "hamburger", ["chance"] = 60},
        }
    },
}
