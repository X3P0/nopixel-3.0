
MenuData = {
  apartment_check = {
    {
      title = _L("apartments-ui-apartment", "Apartment"),
      description = _L("apartments-judge-foreclose", "Forclose Apartment"),
      key = "judge",
      children = {
          { title = _L("apartments-ui-yes", "Yes"), action = "np-apartments:handler", key = { forclose = true} },
          { title = _L("apartments-ui-no", "No"), action = "np-apartments:handler", key = { forclose = false } },
      }
    }
  }
}
