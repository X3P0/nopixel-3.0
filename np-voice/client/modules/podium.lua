function LoadPodiumModule()
  RegisterModuleContext("podium", 1)
  
  UpdateContextVolume("podium", -1.0)

  if Config.enableSubmixes and Config.enableFilters.podium then
    RegisterContextSubmix("podium")

    local filters = {
      { name = "freq_low", value = 50.0 },
      { name = "freq_hi", value = 10000.0 },
      { name = "rm_mod_freq", value = 300.0 },
      { name = "rm_mix", value = 0.05 },
      { name = "fudge", value = 1.0 },
      { name = "o_freq_lo", value = 50.0 },
      { name = "o_freq_hi", value = 6000.0 },
    }
    SetFilterParameters("podium", filters)
  end
  Debug("[Podium] Module Loaded")
end