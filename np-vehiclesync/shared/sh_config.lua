Flags = {
    SyncFlags = {
        ['neonLights'] = 1,
        ['engineSound'] = 2,
        ['leftIndicator'] = 4,
        ['rightIndicator'] = 8,
        ['hazardIndicator'] = 16,
        ['wheelFitment'] = 32
    },
    SirenFlags = {
        ['sirenActive'] = 1,
        ['sirenMuted'] = 2,
        ['sirenAirhorn'] = 4,
        ['sirenNormal'] = 8,
        ['sirenAltern'] = 16,
        ['sirenWarning'] = 32,
    }
}

SirenPresets = {
    [1] = { -- STANDARD
        sirenAirhorn = "SIRENS_AIRHORN",
        sirenNormal = "VEHICLES_HORNS_SIREN_1",
        sirenAltern = "VEHICLES_HORNS_SIREN_2",
        sirenWarning = "VEHICLES_HORNS_POLICE_WARNING"
    },
    [2] = { -- EMERGENCY
        sirenAirhorn = "SIRENS_AIRHORN",
        sirenNormal = "VEHICLES_HORNS_SIREN_1",
        sirenAltern = "VEHICLES_HORNS_SIREN_2",
        sirenWarning = "VEHICLES_HORNS_AMBULANCE_WARNING"
    },
    [3] = { -- FIRETRUCK
        sirenAirhorn = "VEHICLES_HORNS_FIRETRUCK_WARNING",
        sirenNormal = "VEHICLES_HORNS_SIREN_1",
        sirenAltern = "VEHICLES_HORNS_SIREN_2",
        sirenWarning = "VEHICLES_HORNS_AMBULANCE_WARNING"
    }
}

ModelPreset = {
    [`FIRETRUK`] = 3,
    [`AMBULANCE`] = 2,
    [`LGUARD`] = 2,
    [`policebul`] = 2,
}

CosmeticOverrides = {
    [`m5e60`] = {
        ['EngineBlocks'] = {
            ['modId'] = 39,
            ['data'] = {
                [-1] = 'f10m5',
                [0] = 'rb26dett',
                [1] = 'rb26dett',
                [2] = 's85b50'
            }
        }
    },
    [`npolchar`] = {
        ['Exhausts'] = {
            ['modId'] = 4,
            ['data'] = {
                [-1] = 'npolchar',
                [0] = 'npolchar2'
            }
        }
    }
}
