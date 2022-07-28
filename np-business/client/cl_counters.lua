local activeCounters = {
    {
        polytarget = {vector3(1088.39, 220.34, -49.2), 2, 4.0, {
            heading = 0, 
            minZ = -52.8, 
            maxZ = -48.8
        }},
        name = "business:counter:casino_1"
    },
    {
        polytarget = {vector3(1110.21, 210.04, -49.44), 2.2, 2, {
            heading = 313, 
            minZ = -49.64, 
            maxZ = -49.04
        }},
        name = "business:counter:casino_2"
    },
    {
        polytarget = {vector3(1111.41, 205.44, -49.44), 2.2, 2, {
            heading = 259, 
            minZ = -49.64, 
            maxZ = -49.04
        }},
        name = "business:counter:casino_3"
    },
    {
        polytarget = {vector3(1114.48, 208.51, -49.44), 2.2, 2, {
            heading = 187, 
            minZ = -49.64, 
            maxZ = -49.04
        }},
        name = "business:counter:casino_4"
    },
    {
        polytarget = {vector3(946.52, 16.77, 116.16), 2.2, 1, {
            heading=329,
            minZ=115.96,
            maxZ=116.56
        }},
        name = "business:counter:casino_5"
    },
    {
        polytarget = {vector3(944.94, 14.35, 116.16), 2.2, 1, {
            heading=329,
            minZ=115.96,
            maxZ=116.56
        }},
        name = "business:counter:casino_6"
    },
    {
        polytarget = {vector3(-140.93, 223.61, 94.99), 1.5, 0.8, {
            heading=0,
            minZ=94.79,
            maxZ=95.39
        }},
        name = "business:counter:comic_store"
    },
    {
        polytarget = {vector3(-1380.41, -630.1, 30.82), 1.2, 1.2, {
            heading=33,
            minZ=30.82,
            maxZ=31.42
        }},
        name = "business:counter:bahamas_1",
    },
    {
        polytarget = {vector3(-1377.61, -628.27, 30.82), 1.2, 1.4, {
            heading=33,
            minZ=30.82,
            maxZ=31.42
        }},
        name = "business:counter:bahamas_2",
    },
    {
        polytarget = {vector3(-1389.92, -608.97, 30.32), 2.2, 1.5, {
            heading=53,
            minZ=30.32,
            maxZ=30.92
        }},
        name = "business:counter:bahamas_3",
    },
    {
        polytarget = {vector3(-1393.37, -603.14, 30.32), 2.2, 1.5, {
            heading=6,
            minZ=30.32,
            maxZ=30.92
        }},
        name = "business:counter:bahamas_4",
    },
    {
        polytarget = {vector3(-560.73, 288.88, 82.18), 2.0, 1.5, {
            heading=355,
            minZ=81.58,
            maxZ=83.18
        }},
        name = "business:counter:teqilala_public_1",
        public = true,
    },
    {
        polytarget = {vector3(-560.83, 286.09, 82.18), 2.0, 1.5, {
            heading=355,
            minZ=81.58,
            maxZ=83.18
        }},
        name = "business:counter:teqilala_public_2",
        public = true,
    },
}

Citizen.CreateThread(function()
    while not exports['np-config']:IsConfigReady() do
        Wait(100)
    end
    local areCountersPublic = exports['np-config']:GetMiscConfig("business.counters.public")
    for _, counter in ipairs(activeCounters) do
        if counter.public and not areCountersPublic then goto continue end
        exports["np-polytarget"]:AddBoxZone(counter.name, counter.polytarget[1], counter.polytarget[2], counter.polytarget[3], counter.polytarget[4])
        exports["np-interact"]:AddPeekEntryByPolyTarget(counter.name,
            {
                {
                    event = "np-business:openInventory",
                    id = counter.name,
                    icon = "box-open",
                    label = "open",
                    parameters = {invName = counter.name}
                }
            },
            {
                distance = {radius = 3.5}
            }
        )
        ::continue::
    end
end)
