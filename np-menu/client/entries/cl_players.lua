local PedEntries = MenuEntries['peds']

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-heist-invite",
        title = _L("menu-players-invite", "Heist Invite"),
        icon = "#prison-action",
        event = "np-heists:ui:menuInvite",
    },
    isEnabled = function(pEntity, pContext)
        local group = exports['np-heists']:GetGroup()
        return not IsDisabled()
            and pEntity
            and pContext.flags['isPlayer']
            and group
            and #group.members < 6 -- todo: CanInvite export?
    end
}

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-escort",
        title = _L("menu-players-escort", "Escort"),
        icon = "#general-escort",
        event = "np-police:drag:attempt"
    },
    isEnabled = function(pEntity, pContext)
        return not IsDisabled() and not isEscorting and pEntity and pContext.flags['isPlayer']
    end
}

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-cuff",
        title = _L("menu-players-cuff", "Cuff"),
        icon = "#cuffs-cuff",
        event = "np-police:cuffs:attempt"
    },
    isEnabled = function(pEntity, pContext)
        return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and not pContext.flags['isCuffed'] and ((exports["np-inventory"]:hasEnoughOfItem("cuffs",1,false) or (isPolice or isDoc))) and pContext.distance <= 2.0
    end
}

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-ucuff",
        title = _L("menu-players-uncuff", "Uncuff"),
        icon = "#cuffs-uncuff",
        event = "np-police:cuffs:uncuff"
    },
    isEnabled = function(pEntity, pContext)
        return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and pContext.flags['isCuffed'] and ((exports["np-inventory"]:hasEnoughOfItem("cuffs",1,false) or (isPolice or isDoc)))
    end
}

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-unblindfold",
        title = _L("menu-players-remove-bolindfold", "Remove Blindfold"),
        icon = "#blindfold",
        event = "np-captive:captive",
        parameters = { 'isBlindfolded', false }
    },
    isEnabled = function(pEntity, pContext)
        return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and pContext.flags['isBlindfolded']
    end
}

PedEntries[#PedEntries+1] = {
  data = {
      id = "cuffs:gag",
      title = _L("menu-players-remove-gag", "Remove gag"),
      icon = "#gag",
      event = "np-captive:captive",
      parameters = { 'isGagged', false }
  },
  isEnabled = function(pEntity, pContext)
      return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and pContext.flags['isGagged']
  end
}

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-cuffActions",
        title = _L("menu-players-cuff-actions", "Cuff Actions"),
        icon = "#cuffs",
    },
    subMenus = {"cuffs:remmask", "cuffs:beatmode", "cuffs:blindfold", "cuffs:gag" , "cuffs:checkphone"},
    isEnabled = function(pEntity, pContext)
        return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and pContext.flags['isCuffed'] and ((exports["np-inventory"]:hasEnoughOfItem("cuffs",1,false) or (isPolice or isDoc)))
    end
}

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-revive",
        title = _L("menu-players-revive", "Revive"),
        icon = "#medic-revive",
        event = "revive",
    },
    isEnabled = function(pEntity, pContext)
        return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and pContext.flags['isDead'] and (isPolice or isDoc or isMedic or isDoctor)
    end
}

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-revive-var",
        title = _L("menu-players-revive", "Revive"),
        icon = "#medic-revive",
        event = "np-heists:serverroom:revivePlayer",
    },
    isEnabled = function(pEntity, pContext)
        return not IsDisabled()
            and IN_SERVER_FARM
            and pEntity
            and pContext.flags['isPlayer']
            and pContext.flags['isDead']
            and exports["np-inventory"]:hasEnoughOfItem("varmedkit", 1, false, true)
    end
}

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-heal",
        title = _L("menu-players-heal", "Heal"),
        icon = "#medic-heal",
        event = "ems:heal",
    },
    isEnabled = function(pEntity, pContext)
        return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and not pContext.flags['isDead'] and (isMedic or isDoctor or isDoc)
    end
}

PedEntries[#PedEntries+1] = {
    data = {
        id = "peds-medicActions",
        title = _L("menu-players-medical-actions", "Medical Actions"),
        icon = "#medic",
    },
    subMenus = {"medic:checktargetstates", "medic:stomachpump", "medic:bloodtest" },
    isEnabled = function(pEntity, pContext)
        return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and (isMedic or isDoctor)
    end
}

PedEntries[#PedEntries+1] = {
  data = {
    id = "police-action",
    title = _L("menu-players-police-actions", "Police Actions"),
    icon = "#police-action",
  },
  subMenus = {"police:frisk", "police:search", "police:fingerprint", "police:checkBank", "police:gsr", "medic:checktargetstates", "police:seizeItems"},
  isEnabled = function(pEntity, pContext)
    return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and (isPolice or isDoc) and pContext.distance <= 2.0
  end
}

PedEntries[#PedEntries+1] = {
  data = {
    id = "steal",
    title = _L("menu-players-steal", "Steal"),
    icon = "#steal",
    event = "police:rob"
  },
  isEnabled = function(pEntity, pContext)
    return not IsDisabled() and not (isPolice or isDoc) and pEntity and pContext.flags['isPlayer'] and (isPersonBeingHeldUp(pEntity) or pContext.flags['isDead']) and not isOutbreakRunning
  end
}

PedEntries[#PedEntries+1] = {
  data = {
    id = "steal-shoes",
    title = _L("menu-players-steal-shoes", "Steal shoes"),
    icon = "#shoes",
    event = "shoes:steal"
  },
  isEnabled = function(pEntity, pContext)
    return not IsDisabled() and not (isPolice or isDoc) and pEntity and pContext.flags['isPlayer'] and (pContext.flags['isCuffed'] or pContext.flags['isDead'] or isPersonBeingHeldUp(pEntity))
  end
}

PedEntries[#PedEntries+1] = {
    data = {
      id = "prison-action",
      title = _L("menu-players-prison-actions", "Prison Actions"),
      icon = "#prison-action",
    },
    subMenus = {"prison:attachCollar", "prison:currentInfo", "prison:assignTask", "prison:assignGroup", "prison:getCell"},
    isEnabled = function(pEntity, pContext)
      return not IsDisabled() and pEntity and pContext.flags['isPlayer'] and (isPolice or isDoc) and pContext.distance <= 2.0 and polyChecks.prison.isInside
    end
  }

MenuItems['police:frisk'] = {
  data = {
      id = "peds-frisk",
      title = _L("menu-players-frisk", "Frisk"),
      icon = "#police-action-frisk",
      event = "police:checkInventory",
      parameters = { true }
  }
}

MenuItems['police:search'] = {
  data = {
      id = "peds-search",
      title = _L("menu-players-search", "Search"),
      icon = "#cuffs-check-inventory",
      event = "police:checkInventory"
  }
}

MenuItems['cuffs:remmask'] = {
    data = {
        id = "cuffs:remmask",
        title = _L("menu-players-remove-mask", "Remove Mask Hat"),
        icon = "#cuffs-remove-mask",
        event = "police:remmask"
    }
}

MenuItems['police:seizeItems'] = {
    data = {
        id = "police:seizeItems",
        title = _L("menu-players-seize-possessions", "Seize Possessions"),
        icon = "#steal",
        event = "np-police:client:seizeItems"
    },
    isEnabled = function(pEntity, pContext)
      return polyChecks.police.isInside
    end
}

MenuItems['cuffs:checkphone'] = {
    data = {
        id = "cuffs:checkphone",
        title = _L("menu-players-read-phone", "Read Phone"),
        icon = "#cuffs-check-phone",
        event = "police:checkPhone"
    }
}

MenuItems['cuffs:beatmode'] = {
    data = {
        id = "cuffs:beatmode",
        title = _L("menu-players-beatmode", "Beat Mode"),
        icon = "#cuffs-beatmode",
        event = "police:startPutInBeatMode"
    }
}

MenuItems['cuffs:blindfold'] = {
    data = {
        id = "cuffs:blindfold",
        title = _L("menu-players-blindfold", "Blindfold"),
        icon = "#blindfold",
        event = "np-captive:captive",
        parameters = { 'isBlindfolded', true }
    },
    isEnabled = function(pEntity, pContext)
        return not IsDisabled() and pEntity and pContext.flags['isCuffed'] and pContext.flags['isPlayer'] and not pContext.flags['isBlindfolded'] and ((exports["np-inventory"]:hasEnoughOfItem("blindfold",1,false)))
    end
}

MenuItems['cuffs:gag'] = {
  data = {
      id = "cuffs:gag",
      title = _L("menu-players-gag", "Gag"),
      icon = "#gag",
      event = "np-captive:captive",
      parameters = { 'isGagged', true }
  },
  isEnabled = function(pEntity, pContext)
      return not IsDisabled() and pEntity and pContext.flags['isCuffed'] and pContext.flags['isPlayer'] and not pContext.flags['isGagged'] and ((exports["np-inventory"]:hasEnoughOfItem("gag_sock",1,false)))
  end
}

MenuItems['medic:stomachpump'] = {
    data = {
        id = "medic:stomachpump",
        title = _L("menu-players-stomachpump", "Stomach pump"),
        icon = "#medic-stomachpump",
        event = "ems:stomachpump"
    },
    isEnabled = function(pEntity, pContext)
        return isDoctor
    end
}

MenuItems['medic:bloodtest'] = {
  data = {
      id = "medic:bloodtest",
      title = _L("menu-players-bloodtest", "Blood Test"),
      icon = "#general-check-over-target",
      event = "ems:bloodtest"
  },
  isEnabled = function(pEntity, pContext)
      return isDoctor
  end
}

MenuItems['medic:checktargetstates'] = {
    data = {
        id = "medic:checktargetstates",
        title = _L("menu-players-examinetarget", "Examine Target"),
        icon = "#general-check-over-target",
        event = "requestWounds"
    }
}

MenuItems['police:fingerprint'] = {
    data = {
        id = "police:fingerprint",
        icon = "#police-action-fingerprint",
        title = _L("menu-players-check-fingerprint", "Check Fingerprint"),
        event = "np-police:client:fingerPrint"
    },
    isEnabled = function(pEntity, pContext)
        return not isDead and pContext.flags and isPolice or isDoc
    end
}

MenuItems['police:checkBank'] = {
    data = {
        id = "police:checkBank",
        icon = "#police-check-bank",
        title = _L("menu-players-check-bank", "Check Bank"),
        event = "police:checkBank"
    },
    isEnabled = function(pEntity, pContext)
        return not isDead and pContext.flags and isPolice
    end
}

MenuItems['police:gsr'] = {
    data = {
        id = "police:gsr",
        icon = "#police-action-gsr",
        title = _L("menu-players-check-gsr", "Check GSR"),
        event = "police:gsr"
    },
    isEnabled = function(pEntity, pContext)
        return not isDead and pContext.flags and isPolice
    end
}

MenuItems['prison:attachCollar'] = {
    data = {
        id = "prison:attachCollar",
        title = _L("menu-players-attach-gps-collar", "Attach GPS Collar"),
        icon = "#prisoner-collar",
        event = "np-jail:attachCollar"
    }
}

MenuItems['prison:currentInfo'] = {
    data = {
        id = "prison:currentInfo",
        title = _L("menu-players-get-prisoner-info", "Get Prisoner Info"),
        icon = "#prisoner-info",
        event = "np-jail:showPrisonerInfo"
    }
}

MenuItems['prison:assignTask'] = {
    data = {
        id = "prison:assignTask",
        title = _L("menu-players-assign-group-task", "Assign Group Task"),
        icon = "#prisoner-task",
        event = "np-jail:assignTask"
    }
}

MenuItems['prison:assignGroup'] = {
    data = {
        id = "prison:assignGroup",
        title = _L("menu-players-assign-group", "Assign Group"),
        icon = "#prisoner-group",
        event = "np-jail:assignGroup"
    }
}

MenuItems['prison:getCell'] = {
    data = {
        id = "prison:getCell",
        title = _L("menu-players-view-cell", "View Assigned Cell"),
        icon = "#prisoner-info",
        event = "np-jail:getOthersCell"
    }
}
