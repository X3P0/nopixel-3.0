Config = {
    crates = {
        smallcrate = {
            duration = 7 * 86400, -- 7 days
            model = "gr_prop_gr_rsply_crate03a",
            invPrefix = "small",
            destroyLength = 30000,
            lockLength = 30000,
            openLength = 30000,
            repairLength = 30000,
            distance = 2,
            repairCharges = 1
        },
        mediumcrate = {
            duration = 365 * 86400, -- 365 days
            model = "prop_box_wood07a",
            invPrefix = "medium",
            destroyLength = 60000,
            lockLength = 30000,
            openLength = 30000,
            repairLength = 30000,
            distance = 2,
            repairCharges = 2
        },
        bigcrate = {
            duration = 30 * 86400, -- 30 days
            model = "prop_box_wood04a",
            invPrefix = "big",
            destroyLength = 90000,
            lockLength = 30000,
            openLength = 30000,
            repairLength = 30000,
            distance = 2,
            repairCharges = 3
        },
        canister = {
            duration = 43200, -- 12 hours,
            model = "ng_proc_spraycan01a",
            invPrefix = "canister",
            destroyLength = 10000,
            lockLength = 30000,
            openLength = 30000,
            distance = 2
        },
        smallcontainer = {
            duration = 30 * 86400, -- 30 days
            model = "prop_container_05a",
            invPrefix = "containersmall",
            destroyLength = 120000,
            lockLength = 30000,
            openLength = 30000,
            repairLength = 30000,
            distance = 3,
            repairCharges = 4
        },
        mediumcontainer = {
            duration = 30 * 86400, -- 30 days
            model = "prop_contr_03b_ld",
            invPrefix = "containermedium",
            destroyLength = 120000,
            lockLength = 30000,
            openLength = 30000,
            repairLength = 30000,
            distance = 5,
            repairCharges = 5
        },
        bigcontainer = {
            duration = 30 * 86400, -- 30 days
            model = "prop_container_01mb",
            invPrefix = "containerbig",
            destroyLength = 120000,
            lockLength = 30000,
            openLength = 30000,
            repairLength = 30000,
            distance = 7,
            repairCharges = 6
        },
        bodybagstash = {
            duration = 30 * 86400, -- 30 days
            model = "np_prop_body_bag",
            invPrefix = "bodybag",
            destroyLength = 30000,
            distance = 3
        },
        mobilewatervendor = {
            duration = 30 * 86400, -- 30 days
            model = "prop_vend_soda_01",
            destroyLength = 30000,
            distance = 3,
            vendor = true,
            offset = 1
        },
        mobilefoodvendor = {
            duration = 30 * 86400, -- 30 days
            model = "prop_vend_snak_01",
            destroyLength = 30000,
            distance = 3,
            vendor = true,
            offset = 1
        },
        mobileatm = {
            duration = 30 * 86400, -- 30 days
            model = "prop_atm_01",
            destroyLength = 30000,
            distance = 3,
            vendor = true,
            offset = 0.4
        },
        smalltrapcrate = {
            duration = 30 * 86400, -- 30 days
            model = "gr_prop_gr_rsply_crate03a",
            destroyLength = 30000,
            distance = 3,
            vendor = false,
            trap = true
        },
        trapcrate = {
            duration = 30 * 86400, -- 30 days
            model = "prop_box_wood07a",
            destroyLength = 30000,
            distance = 3,
            vendor = false,
            trap = true
        },
        bigtrapcrate = {
            duration = 30 * 86400, -- 30 days
            model = "prop_box_wood04a",
            destroyLength = 30000,
            distance = 3,
            vendor = false,
            trap = true
        },
        lootcrate = {
            duration = 30 * 60, -- 30 mins
            model = "gr_prop_gr_rsply_crate03a",
            invPrefix = "loot",
            destroyLength = 20000,
            lockLength = 30000,
            openLength = 30000,
            distance = 2
        },
        portablefridge = {
            duration = 30 * 86400, -- 30 days
            model = "v_res_fridgemodsml_np02",
            invPrefix = "fridge",
            destroyLength = 30000,
            distance = 3,
            offset = 0.0
        }
    },
    anims = {
        destroy = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            name = 'machinic_loop_mechandplayer',
        },
        repair = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            name = 'machinic_loop_mechandplayer',
        },
        create = {
            dict = "random@domestic",
            name = "pickup_low"
        },
        lock = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            name = 'machinic_loop_mechandplayer',
        },
        unlock = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            name = 'machinic_loop_mechandplayer',
        }
    },
    houseLimit = 2
}
