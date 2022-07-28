function LoadGagModule()
  RegisterModuleContext("gag", 1)
  
  UpdateContextVolume("gag", -1.0)

  if Config.enableSubmixes and Config.enableFilters.gag then
    RegisterContextSubmix("gag")

    local filters = {
      { name = "freq_low", value = 10.0 },
      { name = "freq_hi", value = 275.0 },
      { name = "rm_mod_freq", value = 300.0 },
      { name = "rm_mix", value = 0.1 },
      { name = "fudge", value = 0.5 },
      { name = "o_freq_lo", value = 10.0 },
      { name = "o_freq_hi", value = 275.0 },
    }

    SetFilterParameters("gag", filters)
  end
  Debug("[Gag] Module Loaded")
end