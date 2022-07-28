function LoadMegaphoneModule()
  RegisterModuleContext("megaphone", 1)
  
  UpdateContextVolume("megaphone", -1.0)

  if Config.enableSubmixes and Config.enableFilters.megaphone then
    RegisterContextSubmix("megaphone")

    local filters = {
      { name = "freq_low", value = 10.0 },
      { name = "freq_hi", value = 10000.0 },
      { name = "rm_mod_freq", value = 300.0 },
      { name = "rm_mix", value = 0.2 },
      { name = "fudge", value = 0.0 },
      { name = "o_freq_lo", value = 200.0 },
      { name = "o_freq_hi", value = 5000.0 },
    }

    SetFilterParameters("megaphone", filters)
  end
  Debug("[Megaphone] Module Loaded")
end