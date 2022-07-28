Config = {}

Config.version = "3.1.5"

------- Modules -------
Config.enableDebug = false
Config.enableGrids = false
Config.enableProximity = Config.enableGrids == false
Config.enableRadio = true
Config.enablePhone = true
Config.enableMegaphone = true
Config.enablePodium = true
Config.enableGag = true
Config.enableGaze = true
Config.setProximityEvents = true
Config.enableToko = true
Config.enableSpeaker = true
Config.enableSubmixes = true
Config.environmentalEffects = true
Config.enableFilters = {
    phone = true,
    radio = true,
    megaphone = true,
    podium = true,
    gag = true
}

------- Default Settings -------

Config.settings = {
    ["releaseDelay"] = 200,
    ["stereoAudio"] = false,
    ["localClickOn"] = false,
    ["localClickOff"] = false,
    ["remoteClickOn"] = false,
    ["remoteClickOff"] = false,
    ["clickVolume"] = 0.8,
    ["radioVolume"] = 0.8,
    ["phoneVolume"] = 0.8,
    ["atcVolume"] = 0.8,
    ["dtVolume"] = 0.8,
}

------- Voice Proximity -------

Config.voiceRanges = {
    { name = "whisper", range = 1.5 },
    { name = "normal", range = 3.0 },
    { name = "shout", range = 7.5 }
}

------- Hotkeys Config -------

Config.cycleProximityHotkey = "z"
Config.cycleRadioChannelHotkey = "i"
Config.transmitToRadioHotkey = "capital"
Config.phoneLoudSpeaker = "plus"

------- Modules Config -------

-- Speaker Module
Config.speakerDistance = 2.0
Config.radioSpeaker = true
Config.phoneSpeaker = true

-- Radio Module
Config.enableMultiFrequency = false

-- Radio voiceRanges
Config.radioVehicleMultiplier = 2.0
Config.radioVoiceRanges = {
    radio = {
        filters = {
            { name = "freq_low", value = 100.0 },
            { name = "freq_hi", value = 5000.0 },
            { name = "rm_mod_freq", value = 300.0 },
            { name = "rm_mix", value = 0.1 },
            { name = "fudge", value = 4.0 },
            { name = "o_freq_lo", value = 300.0 },
            { name = "o_freq_hi", value = 5000.0 },
        },
    },
    radio_medium_distance = {
        filters = {
            { name = "freq_low", value = 100.0 },
            { name = "freq_hi", value = 5000.0 },
            { name = "rm_mod_freq", value = 300.0 },
            { name = "rm_mix", value = 0.5 },
            { name = "fudge", value = 10.0 },
            { name = "o_freq_lo", value = 300.0 },
            { name = "o_freq_hi", value = 5000.0 },
        },
        ranges = {
          min = 900,
          max = 1300.0
        }
    },
    radio_far_distance = {
        filters = {
            { name = "freq_low", value = 100.0 },
            { name = "freq_hi", value = 5000.0 },
            { name = "rm_mod_freq", value = 300.0 },
            { name = "rm_mix", value = 0.8 },
            { name = "fudge", value = 16.0 },
            { name = "o_freq_lo", value = 300.0 },
            { name = "o_freq_hi", value = 5000.0 },
        },
        ranges = {
          min = 1300.0,
          max = 1700.0
        }
    }
}

-- Grid Module
Config.gridSize = 384
Config.gridEdge = 192
Config.gridMinX = -4600
Config.gridMaxX = 4600
Config.gridMaxY = 9200
