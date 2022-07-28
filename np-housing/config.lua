
MenuData = {
  property_check = {
    {
      title = "Property",
      description = "Forfeit Property",
      key = "judge",
      children = {
          { title = "Yes", action = "np-housing:handler", key = { forfeit = true, type = "forfeit"} },
          { title = "No", action = "np-housing:handler", key = { forfeit = false, type = "forfeit" } },
      }
    }
  },
  crafting_check = {
    {
      title = "Crafting",
      description = "Remove Inventory",
      children = {
          { title = "Yes", action = "np-housing:handler", key = { remove = true, type = "removeInv"} },
          { title = "No", action = "np-housing:handler", key = { remove = false, type = "removeInv" } },
      }
    }
  },
  inventory_check = {
    {
      title = "Inventory",
      description = "Remove Crafting",
      children = {
          { title = "Yes", action = "np-housing:handler", key = { remove = true, type = "removeCraft"} },
          { title = "No", action = "np-housing:handler", key = { remove = false, type = "removeCraft" } },
      }
    }
  }
}
