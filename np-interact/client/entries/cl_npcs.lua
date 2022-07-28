local Entries = {}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isRecycleExchange' },
    data = {
        {
            id = "recycle_exchange",
            label = _L("interact-exchange-reyclables", "Exchange recyclables"),
            icon = "circle",
            event = "np-npcs:ped:exchangeRecycleMaterial",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isBankAccountManager' },
    data = {
        {
            id = "bank_paycheck_collect",
            label = _L("interact-collect-paycheck", "Collect paycheck"),
            icon = "circle",
            event = "np-npcs:ped:paycheckCollect",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isBankAccountManager' },
    data = {
        {
            id = "bank_receipt_collect",
            label = _L("interact-trade-receipts", "trade in receipts"),
            icon = "money-bill-wave",
            event = "np-npcs:ped:receiptTradeIn",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function()
            local isEmployedAtBurgerShot = exports["np-business"]:IsEmployedAt("burger_shot")
            local isEmployedAtRoosters = exports["np-business"]:IsEmployedAt("rooster")
            local isEmployedAtMaldinis = exports["np-business"]:IsEmployedAt("maldinis")
            local isEmployedAtUwu = exports["np-business"]:IsEmployedAt("uwu_cafe")
            local isEmployedAtLL = exports["np-business"]:IsEmployedAt("tavern")
            local isEmployedAtJeweledDragon = exports["np-business"]:IsEmployedAt("jeweled_dragon")
            local isEmployedAtWuChang = exports["np-business"]:IsEmployedAt("wuchang")
            local publicTradeIn = exports["np-config"]:GetMiscConfig("jobs.receipts.public")

            return isEmployedAtWuChang or isEmployedAtJeweledDragon or isEmployedAtLL or isEmployedAtUwu or isEmployedAtMaldinis or isEmployedAtBurgerShot or isEmployedAtRoosters or isMechanic() or publicTradeIn
        end
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isBankAccountManager' },
  data = {
      {
          id = "bank_receipt_m_collect",
          label = _L("interact-trade-market-receipts", "Trade in Market Receipts"),
          icon = "money-bill-wave",
          event = "np-npcs:ped:receiptTradeInMarket",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.5 },
      isEnabled = function()
          return exports["np-inventory"]:getQuantity("farmersmarketreceipt", true) > 0
      end
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isBankAccountManager' },
    data = {
        {
            id = "bank_envelope_deposit",
            label = _L("interact-trade-envelope", "deposit cash envelope"),
            icon = "money-bill-wave",
            event = "np-restaurants:tradeInCash",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function()
            local hasAccess = exports['np-inventory']:hasEnoughOfItem('envelope', 1, false, true, {
                cashEnvelope = true
            })
            return hasAccess
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isCommonJobProvider' },
    data = {
        {
            id = "common_job_signIn",
            label = _L("interact-sign-in", "Sign in"),
            icon = "circle",
            event = "np-npcs:ped:signInJob",
            parameters = {}
        },
        {
            id = "common_job_signOut",
            label = _L("interact-sign-out", "Sign out"),
            icon = "circle",
            event = "np-npcs:ped:signInJob",
            parameters = { "unemployed" }
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isJobEmployer' },
    data = {
        {
            id = "jobs_employer_checkIn",
            label = _L("interact-sign-in", "Sign in"),
            icon = "circle",
            event = "jobs:checkIn",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function()
            return CurrentJob == 'unemployed'
        end
    }
}

-- Entries[#Entries + 1] = {
--     type = 'flag',
--     group = { 'isJobEmployer' },
--     data = {
--         {
--             id = "fishing_borrow_boat",
--             label = "Borrow Fishing Boat",
--             icon = "circle",
--             event = "np-fishing:rentBoat",
--             parameters = {}
--         }
--     },
--     options = {
--         distance = { radius = 2.5 },
--         isEnabled = function(pEntity, pContext)
--             return pContext.job.id == CurrentJob and not IsDisabled() and not IsPedInAnyVehicle(PlayerPedId()) and (pEntity and pContext.flags['isBoatRenter']) and (currentlyRentedBoat == nil or not DoesEntityExist(currentlyRentedBoat))
--         end
--     }
-- }

-- Entries[#Entries + 1] = {
--     type = 'flag',
--     group = { 'isJobEmployer' },
--     data = {
--         {
--             id = "fishing_return_boat",
--             label = "Return Fishing Boat",
--             icon = "circle",
--             event = "np-fishing:returnBoat",
--             parameters = {}
--         }
--     },
--     options = {
--         distance = { radius = 2.5 },
--         isEnabled = function(pEntity, pContext)
--             return pContext.job.id == CurrentJob and not IsDisabled() and not IsPedInAnyVehicle(PlayerPedId()) and (pEntity and pContext.flags['isBoatRenter']) and (currentlyRentedBoat ~= nil and DoesEntityExist(currentlyRentedBoat))
--         end
--     }
-- }

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isJobEmployer' },
    data = {
        {
            id = "jobs_employer_paycheck",
            label = _L("interact-get-paycheck", "Get paycheck"),
            icon = "circle",
            event = "jobs:getPaycheck",
            parameters = {}
        },
        {
            id = "jobs_employer_checkOut",
            label = _L("interact-sign-out", "Sign out"),
            icon = "circle",
            event = "jobs:checkOut",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function(pEntity, pContext)
            return pContext.job.id == CurrentJob
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isJobEmployer' },
    data = {
        {
            id = "jobs_employer_paycheck",
            label = "Tournament Status",
            icon = "circle",
            event = "np-fishing:client:getTournamentStatus",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function(pEntity, pContext)
            return exports["np-fishing"]:IsNearFisherGuy()
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isJobEmployer' },
    data = {
        {
            id = "fishing_join_tournament",
            label = "Join Active Tournament",
            icon = "fish",
            event = "np-fishing:client:joinTournament",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function(pEntity, pContext)
            return pContext.job.id == "fishing" and not exports["np-fishing"]:IsPlayerInTournament() and exports["np-fishing"]:IsNearFisherGuy()
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isJobEmployer' },
    data = {
        {
            id = "fishing_leave_tournament",
            label = "Leave Active Tournament",
            icon = "fish",
            event = "np-fishing:client:leaveTournament",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function(pEntity, pContext)
            return pContext.job.id == "fishing" and exports["np-fishing"]:IsPlayerInTournament() and exports["np-fishing"]:IsNearFisherGuy()
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isJobEmployer' },
    data = {
        {
            id = "dodologistics_getpackage",
            label = _L("interact-dodo-getpackage", "Get Packaging"),
            icon = "circle",
            event = "np-business:dodoLogisticsDisplayPackaging",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function(pEntity, pContext)
            local isEmployedAtDodoLogistics = exports["np-business"]:IsEmployedAt("dodologistics")
            local hasCraftAccess = exports["np-business"]:HasPermission("dodologistics", "craft_access")
            local pedCoords = GetEntityCoords(PlayerPedId())
            local guyCoords = vector3(-432.95, -2786.08, 6.01)
            return isEmployedAtDodoLogistics and hasCraftAccess and #(pedCoords - guyCoords) < 3.0
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isShopKeeper' },
    data = {
        {
            id = "shopkeeper",
            label = _L("interact-purchase-goods", "Purchase goods"),
            icon = "circle",
            event = "np-npcs:ped:keeper",
            parameters = { "2" }
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "liqourkeeper",
          label = _L("interact-purchase-alc", "Purchase alcohol"),
          icon = "circle",
          event = "np-npcs:ped:keeperLiqour",
          parameters = { "42076" }
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"liqourkeeper_1", "liqourkeeper_2", "liqourkeeper_3", "liqourkeeper_4", "liqourkeeper_5", "liqourkeeper_6","liqourkeeper_7", "liqourkeeper_8", "liqourkeeper_9", "liqourkeeper_10", "liqourkeeper_11"}
  }
}

-- local vaultDoorCids = {
--     [1004] = true,
--     [3503] = true,
-- }
-- Entries[#Entries + 1] = {
--     type = 'flag',
--     group = { 'isNPC' },
--     data = {
--         {
--             id = "vdpaleto",
--             label = _L("interact-vault-open", "Open door"),
--             icon = "circle",
--             event = "np-heists:doors:vaultDoor",
--             parameters = { action = "open", door = "paleto" },
--         },
--     },
--     options = {
--         distance = { radius = 2.5 },
--         npcIds = {"vd_closer_paleto"},
--         isEnabled = function()
--             local cid = exports["isPed"]:isPed("cid")
--             return vaultDoorCids[cid]
--         end,
--     }
-- }

-- Entries[#Entries + 1] = {
--     type = 'flag',
--     group = { 'isNPC' },
--     data = {
--         {
--             id = "vdpaletoclose",
--             label = _L("interact-vault-close", "Close door"),
--             icon = "circle",
--             event = "np-heists:doors:vaultDoor",
--             parameters = { action = "close", door = "paleto" },
--         },
--     },
--     options = {
--         distance = { radius = 2.5 },
--         npcIds = {"vd_closer_paleto"},
--         isEnabled = function()
--             local cid = exports["isPed"]:isPed("cid")
--             return vaultDoorCids[cid] or myJob == "police"
--         end,
--     }
-- }

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "getpaintballgun",
          label = _L("interact-pickup-paintball-gun", "Pickup Paintball Gun"),
          icon = "circle",
          event = "np-paintball:getPaintballGun",
          parameters = {},
      },
      {
          id = "getpaintballsmoke",
          label = _L("interact-pickup-smoke-grenade", "Pickup Smoke Grenade"),
          icon = "circle",
          event = "np-paintball:getPaintballSmoke",
          parameters = {},
      },
      {
          id = "getpaintballammo",
          label = _L("interact-pickup-paintball-ammo", "Pickup Paintball Ammo"),
          icon = "circle",
          event = "np-paintball:getPaintballAmmo",
          parameters = {},
      },
      {
          id = "getpaintballmegaphone",
          label = _L("interact-pickup-megaphone", "Pickup Megaphone"),
          icon = "circle",
          event = "np-paintball:getMegaphone",
          parameters = {},
      },
      {
          id = "getpaintballcaddy",
          label = _L("interact-pickup-caddy", "Pickup Caddy"),
          icon = "circle",
          event = "np-paintball:getCaddy",
          parameters = {},
      },
      {
          id = "getpaintballcart",
          label = _L("interact-pickup-caddy", "Pickup Go Kart"),
          icon = "circle",
          event = "np-paintball:getGoKart",
          parameters = {},
      },
      {
        id = "getpaintballtruck",
        label = _L("interact-pickup-caddy", "Pickup Monster Truck"),
        icon = "circle",
        event = "np-paintball:getMonster",
        parameters = {},
    },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"paintball_vendor"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
    {
        id = "arenadirt",
        label = _L("interact-enable-wasteland-map", "Enable 'Empty Dirt'"),
        icon = "circle",
        event = "np-paintball:setArenaType",
        parameters = { "emptydirt" },
    },
    {
        id = "arenalights",
        label = _L("interact-enable-wasteland-map", "Enable 'Empty Concrete'"),
        icon = "circle",
        event = "np-paintball:setArenaType",
        parameters = { "arenalights" },
    },
    {
        id = "arenaempty",
        label = _L("interact-enable-wasteland-map", "Enable 'Empty Concrete DARKER'"),
        icon = "circle",
        event = "np-paintball:setArenaType",
        parameters = { "emptyconcrete" },
    },    
    {
        id = "arenawasteland",
        label = _L("interact-enable-wasteland-map", "Enable 'Wasteland'"),
        icon = "circle",
        event = "np-paintball:setArenaType",
        parameters = { "wasteland" },
    },
    {
        id = "arenagokarts",
        label = _L("interact-enable-wasteland-map", "Enable 'Concrete Jungle'"),
        icon = "circle",
        event = "np-paintball:setArenaType",
        parameters = { "gokarts" },
    },
    {
        id = "arenagokarts2",
        label = _L("interact-enable-wasteland-map", "Enable 'Concrete Maze'"),
        icon = "circle",
        event = "np-paintball:setArenaType",
        parameters = { "gokarts2" },
    },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"paintball_arena_map"}
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "arenagotomain",
            label = _L("interact-take-me-to-arena", "Take me to The Arena!"),
            icon = "circle",
            event = "np-paintball:swapLocations",
            parameters = {},
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"paintball_arena_grass_swapper_1", "paintball_arena_grass_swapper_2"}
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "casinoswapinterior",
          label = _L("interact-enable-betting", "Enable Betting Stations"),
          icon = "circle",
          event = "np-casino:betting:interiorSwap",
          parameters = { "bets" },
      },
      {
          id = "casinoswapinteriorpoker",
          label = _L("interact-enable-poker", "Enable Poker Tables"),
          icon = "circle",
          event = "np-casino:betting:interiorSwap",
          parameters = { "poker" },
      },
      {
        id = "casinoswapinteriorroulette",
        label = _L("interact-enable-roulette", "Enable Roulette Tables"),
        icon = "circle",
        event = "np-casino:betting:interiorSwap",
        parameters = { "roulette" },
    },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"casino_interior_swap"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "galleryinteriorcars",
          label = _L("interact-gallery-enable-auction", "Enable Auction Stand"),
          icon = "circle",
          event = "np-gallery:interiorSwap",
          parameters = { "cars" },
      },
      {
          id = "galleryinteriorfights",
          label = _L("interact-gallery-enable-fight-ring", "Enable Fight Ring"),
          icon = "circle",
          event = "np-gallery:interiorSwap",
          parameters = { "fights" },
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"gallery_interior_swap"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "paintballjoineastteam",
          label = _L("interact-paintball-join-east", "Join East Team"),
          icon = "circle",
          event = "np-paintball:game:interact",
          parameters = { "join", "east" },
      },
      {
          id = "paintballjoinwestteam",
          label = _L("interact-paintball-join-west", "Join West Team"),
          icon = "circle",
          event = "np-paintball:game:interact",
          parameters = { "join", "west" },
      },
      {
          id = "paintballjoinleaveteam",
          label = _L("interact-paintball-leave-team", "Leave Team"),
          icon = "circle",
          event = "np-paintball:game:interact",
          parameters = { "leave" },
      },
      {
          id = "paintballjoinstartgame",
          label = _L("interact-paintball-start-game", "Start Game"),
          icon = "circle",
          event = "np-paintball:game:interact",
          parameters = { "start" },
      },
      {
          id = "paintballjoinsendgame",
          label = _L("interact-paintball-end-game", "End Game"),
          icon = "circle",
          event = "np-paintball:game:interact",
          parameters = { "end" },
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"paintball_signup"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
        id = "getminingprobe",
        label = _L("interact-mining-get-probe", "Get Probe"),
        icon = "circle",
        event = "np-mining:client:collectItem",
        parameters = {
            itemId = "miningprobe"
        }
    },
    {
        id = "getminingpickaxe",
        label = _L("interact-mining-get-pickaxe", "Get Pickaxe"),
        icon = "circle",
        event = "np-mining:client:collectItem",
        parameters = {
            itemId = "miningpickaxe"
        }
    }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"mining_vendor"}
  }
}

Entries[#Entries + 1] = {
	type = 'flag',
	group = { 'isNPC' },
	data = {
		{
			id = "hoimports_pickup_sticks_deposit_stick",
			label = _L("interact-hoi-open-storage", "Open Storage"),
			icon = "box-open",
			NPXEvent = "np-hoimports:client:OpenDepositInventory",
			parameters = {
				id = "hoimports_pickup_sticks_deposit_stick"
			}
		},
		{
			id = "hoimports_pickup_sticks_confirm_delivery",
			label = _L("interact-hoi-deliver-sticks", "Deliver Sticks"),
			icon = "check",
			NPXEvent = "np-hoimports:client:DepositSticks",
			parameters = {
				id = "hoimports_pickup_sticks_confirm_delivery"
			}
		},
		{
			id = "hoimports_pickup_sticks_claim_tax",
			label = _L("interact-hoi-claim-profits", "Claim Profits"),
			icon = "horse-head",
			NPXEvent = "np-hoimports:client:ClaimTax",
			parameters = {
				id = "hoimports_pickup_sticks_claim_tax"
			}
		},
	},
	options = {
		distance = { radius = 2.5 },
		npcIds = {"hoimport_vendor"},
		isEnabled = function()
			local isEmployedAtHOImports = exports["np-business"]:IsEmployedAt("hno_imports")
			local hasCraftAccess = exports["np-business"]:HasPermission("hno_imports", "craft_access")
			return isEmployedAtHOImports and hasCraftAccess
		end,
	}
}

Entries[#Entries + 1] = {
	type = 'flag',
	group = { 'isNPC' },
	data = {
		{
			id = "hoimports_pickup_sticks_pickup_goods",
			label = _L("interact-fleeca-pickup-goods-vendor", "Pickup Goods"),
			icon = "hand-spock",
			NPXEvent = "np-hoimports:client:PickupOrder",
			parameters = {
				id = "hoimports_pickup_sticks_pickup_goods"
			}
		},
	},
	options = {
		distance = { radius = 2.5 },
		npcIds = {"hoimport_vendor"},
		isEnabled = function()
			return true
		end,
	}
}

Entries[#Entries + 1] = {
	type = 'flag',
	group = { 'isNPC' },
	data = {
		{
			id = "hoimports_start_drifting",
			label = _L("interact-dw-buy-admin-ticket", "Grab Entrance Ticket"),
			icon = "hand-spock",
			event = "StartDriftPad",
			parameters = {
				id = "hoimports_start_drifting"
			}
		},
	},
	options = {
		distance = { radius = 2.5 },
		npcIds = {"hoimport_drift_vendor"},
		isEnabled = function()
			return true
		end,
	}
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "golfclubseller",
          label = _L("interact-golf-browse", "Browse Goods"),
          icon = "circle",
          event = "np-inventory:openGolfStore",
          parameters = {},
      },
      {
          id = "golfclubcaddyseller",
          label = _L("interact-golf-get-caddy", "Get Caddy"),
          icon = "circle",
          event = "np-golf:spawnCaddy",
          parameters = {},
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"golfclubseller"}
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "casinovendorman",
            label = _L("interact-purchase-tools", "Purchase tools"),
            icon = "circle",
            event = "np-casino:openMegaMallStore",
            parameters = {},
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"casinovendor_1"}
    }
}



Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "licensekeeper_bank",
          label = _L("interact-purchase-license", "Purchase License ($500.00) (Bank)"),
          icon = "id-card-alt",
          event = "np-npcs:ped:licenseKeeper",
          parameters = { type = "bank" },
      },
      {
        id = "licensekeeper_cash",
        label = _L("interact-purchase-license", "Purchase License ($1000.00) (Cash)"),
        icon = "id-card-alt",
        event = "np-npcs:ped:licenseKeeper",
        parameters = { type = "cash" },
    }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"npc_license_keeper_1", "npc_license_keeper_2"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "vendorlicensekeeper",
          label = _L("interact-get-vendor-license", "Get Vendor License"),
          icon = "id-card-alt",
          event = "np-farmersmarket:generateVendorLicense",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"npc_license_keeper_1"},
      isEnabled = function()
        return myJob == "judge" or myJob == "mayor" or myJob == "police" or myJob == "deputy_mayor" or myJob == "county_clerk"
      end,
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "craftitemvendor",
          label = _L("interact-collect-fm-items", "Collect Farmers Market Items"),
          icon = "hand-holding",
          event = "np-farmersmarket:craftItem",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"fm_craft_shopkeeper"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "fmregisterbanner",
          label = _L("interact-register-fm-banner", "Register Farmers Market Banner"),
          icon = "image",
          event = "np-farmersmarket:registerBanner",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"fm_craft_shopkeeper"}
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "factoryshopopen",
            label = _L("interact-open-factory-shop", "Shop"),
            icon = "shopping-cart",
            event = "np-shops:openFactoryShop",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"factory_craft_shop"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "factoryshopbp",
            label = _L("interact-factory-blueprint", "Create Blueprint"),
            icon = "newspaper",
            event = "np-shops:createBlueprint",
        },
        {
            id = "factoryshopuseitem",
            label = _L("interact-factory-blueprint", "Create Useable"),
            icon = "spray-can",
            event = "np-shops:createUseable",
        },
        {
            id = "factoryshoprandomitem",
            label = _L("interact-factory-blueprint", "Create Randomizer"),
            icon = "spray-can",
            event = "np-shops:createRandom",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"factory_craft_worker"},
        isEnabled = function()
            return exports['np-business']:IsEmployedAt('the_factory')
        end,
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "",
            label = _L("interact-open-factory-shop", "Shop"),
            icon = "shopping-cart",
            event = "np-shops:openParsonsShop",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"parsons_food_vendor"}
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwfindloststuff",
          label = _L("interact-dw-find-lost-stuff", "Find Lost Stuff"),
          icon = "search",
          event = "np-deanworld:findLostStuff",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_drop_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwbuyshitfood",
          label = _L("interact-dw-shit-food", "Purchase Food"),
          icon = "hamburger",
          event = "np-deanworld:buyShitFood",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_food_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwbuybumperupgrades",
          label = _L("interact-dw-rl-purchase-upgrades", "Purchase Upgrades"),
          icon = "circle",
          event = "np-deanworld:purchaseRLUpgrades",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_bumper_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwdropoffstuff",
          label = _L("interact-dw-dropoff", "Drop Off"),
          icon = "handshake",
          event = "np-deanworld:dropOffCases",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_drop_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwadminentrance",
          label = _L("interact-dw-buy-admin-ticket", "Buy Entrance Ticket"),
          icon = "times-circle",
          event = "np-deanworld:buyAdministrationTicket",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_admin_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "fmregisteritem",
          label = _L("interact-fm-register-item", "Register Farmers Market Item"),
          icon = "hamburger",
          event = "np-farmersmarket:registerItem",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"fm_craft_shopkeeper"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "pcagrader",
          label = _L("interact-pca-grade", "Grade Items"),
          icon = "circle",
          event = "np-business:pcaGradeItems",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_pca_grader_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "airxvendor",
          label = _L("interact-airx-parachute", "Collect Parachute"),
          icon = "parachute-box",
          event = "np-business:collectAirXParachute",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"airx_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "laptopvendor1",
          label = _L("interact-purchase-equip", "Purchase Equipment"),
          icon = "laptop-code",
          event = "np-heists:laptopPurchase",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"laptop_1"},
      isEnabled = function()
        return myJob ~= "police"
      end,
  }
}

-- Entries[#Entries + 1] = {
--   type = 'flag',
--   group = { 'isNPC' },
--   data = {
--       {
--           id = "laptopvendor2",
--           label = _L("interact-check-avail", "Check Availability"),
--           icon = "clock",
--           event = "np-heists:banks:bankCheck",
--       }
--   },
--   options = {
--       distance = { radius = 2.5 },
--       npcIds = {"laptop_1"},
--       isEnabled = function()
--         return myJob ~= "police"
--       end,
--   }
-- }

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isWeaponShopKeeper' },
    data = {
        {
            id = "weaponshop_keeper",
            label = _L("interact-purchase-weapons", "Purchase weapons"),
            icon = "circle",
            event = "np-npcs:ped:keeper",
            parameters = { "5" }
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isToolShopKeeper' },
    data = {
        {
            id = "toolshop_keeper",
            label = _L("interact-purchase-tools", "Purchase tools"),
            icon = "circle",
            event = "np-npcs:ped:keeper",
            parameters = { "4" }
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isSportShopKeeper' },
    data = {
        {
            id = "sportshop_keeper",
            label = _L("interact-purchase-gear", "Purchase gear"),
            icon = "circle",
            event = "np-npcs:ped:keeper",
            parameters = { "34" }
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isWeedShopKeeper' },
  data = {
      {
          id = "weedshop_keeper",
          label = _L("interact-purchase-weed", "Purchase Weed"),
          icon = "cannabis",
          event = "np-npcs:ped:weedSales",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.5 }
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isJobVehShopKeeper' },
  data = {
      {
          id = "jobveh_keeper",
          label = _L("interact-purchase-job-veh", "Purchase Job Vehicle"),
          icon = "car",
          event = "np-showrooms:buyJobVehicles",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.5 }
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isWineryShopKeeper' },
  data = {
    {
        id = "winery_keeper_harvest",
        label = "Start Harvesting",
        icon = "shopping-basket",
        event = "np-vineyard:npcManager",
        parameters = { id = "start_harvest" },
    },
    {
        id = "winery_keeper_atv",
        label = "Rent ATV",
        icon = "motorcycle",
        event = "np-vineyard:npcManager",
        parameters = { id = "rent_atv" },
    },
  },
  options = {
      distance = { radius = 2.5 },
      isEnabled = function()
        local coords = GetEntityCoords(PlayerPedId())
        return #(vector3(-1928.02, 2060.22, 139.85) - coords) < 5.0
      end
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isWineryShopKeeper' },
    data = {
      {
          id = "winery_keeper_store",
          label = "Buy Equipment",
          icon = "hand-holding-usd",
          event = "np-vineyard:npcManager",
          parameters = { id = "buy_equipment" },
      },
    },
    options = {
        distance = { radius = 2.5 }
    },
}

-- Entries[#Entries + 1] = {
--   type = 'flag',
--   group = { 'isWineryShopKeeper' },
--   data = {
--       {
--           id = "winery_keeper_goods",
--           label = _L("interact-purchase-goods", "Purchase Goods"),
--           icon = "wine-glass-alt",
--           event = "np-business:buyWineryGoods",
--           parameters = {}
--       }
--   },
--   options = {
--       distance = { radius = 2.5 }
--   }
-- }

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isCasinoChipSeller' },
    data = {
      {
          id = "casino_purchase_chips",
          label = _L("interact-purchase-chips", "Purchase Chips"),
          icon = "circle",
          event = "np-casino:purchaseChipsAction",
          parameters = { "purchase" }
      },
      {
          id = "casino_withdraw_cash",
          label = _L("interact-cashout-cash", "Cashout (Cash)"),
          icon = "wallet",
          event = "np-casino:purchaseChipsAction",
          parameters = { "withdraw:cash" }
      },
      {
          id = "casino_withdraw_bank",
          label = _L("interact-cashout-bank", "Cashout (Bank)"),
          icon = "university",
          event = "np-casino:purchaseChipsAction",
          parameters = { "withdraw:bank" }
      },
      {
          id = "casino_transfer_chips",
          label = _L("interact-transfer-chips", "Transfer Chips"),
          icon = "circle",
          event = "np-casino:purchaseChipsAction",
          parameters = { "transfer" }
      },
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
    {
        id = "casino_wheel_spin_npc_toggle",
        label = _L("interact-wheel-enable", "Toggle Wheel Enabled"),
        icon = "circle",
        event = "np-casino:wheel:toggleEnable",
    },
    {
        id = "casino_wheel_spin_npc_spin",
        label = _L("interact-spin-wheel", "Spin Wheel! ($500)"),
        icon = "dollar-sign",
        event = "np-casino:wheel:spinWheel",
    },
    {
        id = "casino_wheel_spin_npc_turbo",
        label = _L("interact-spin-wheel-turbo", "Turbo Spin! ($5,000)"),
        icon = "dollar-sign",
        event = "np-casino:wheel:spinWheelTurbo",
    },
    {
        id = "casino_wheel_spin_npc_omega",
        label = _L("interact-spin-omega", "Omega Spin! ($20,000)"),
        icon = "dollar-sign",
        event = "np-casino:wheel:spinWheelOmega",
    },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"casino_wheel_spin_npc"}
  }
}

local wheelCid = 0
Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "casino_wheel_spin_npc_check",
            label = _L("interact-spin-check-spent", "Check Spent Amount"),
            icon = "dollar-sign",
            event = "np-casino:wheel:checkSpentAmount",
        },
        {
            id = "casino_wheel_spin_pickup_cash",
            label = _L("interact-spin-check-spent", "Pickup Wheel Cash"),
            icon = "dollar-sign",
            event = "np-casino:wheel:pickupWheelCash",
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"casino_wheel_spin_npc"},
        isEnabled = function()
            if wheelCid == 0 then
                wheelCid = exports["np-config"]:GetMiscConfig("casino.wheel.cash.pickup.cid")
            end
            return wheelCid == exports["isPed"]:isPed("cid")
        end,
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
    {
        id = "cgchaincraft",
        label = _L("interact-craft-chainz", "Craft Chainz"),
        icon = "circle",
        event = "np-clothing:openCGChainCrafting",
    },
    {
        id = "cgchaininfuse",
        label = _L("interact-infuse-chain", "Infuse Chain"),
        icon = "gem",
        event = "np-clothing:infuseChainWithGems",
    },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"cgjvendor"}
  }
}


-- Entries[#Entries + 1] = {
--   type = 'flag',
--   group = { 'isCasinoChipSeller' },
--   data = {
--       {
--           id = "casino_purchase_chips_bands",
--           label = "Purchase Chips (Dirty)",
--           icon = "circle",
--           event = "np-casino:purchaseChipsAction",
--           parameters = { "purchase:dirty" }
--       },
--   },
--   options = {
--       distance = { radius = 2.5 },
--       isEnabled = function()
--           return myJob == 'unemployed'
--             and (exports['np-inventory']:hasEnoughOfItem("markedbills", 20, false, true)
--             or exports['np-inventory']:hasEnoughOfItem("rollcash", 5, false, true)
--             or exports['np-inventory']:hasEnoughOfItem("band", 5, false, true))
--       end
--   }
-- }

-- Entries[#Entries + 1] = {
--   type = 'flag',
--   group = { 'isCasinoMembershipGiver' },
--   data = {
--     {
--         id = "casino_membership_giver",
--         label = "Get Membership",
--         icon = "circle",
--         event = "np-casino:purchaseMembership",
--         parameters = {}
--     },
--   },
--   options = {
--       distance = { radius = 2.5 }
--   }
-- }

-- Entries[#Entries + 1] = {
--   type = 'flag',
--   group = { 'isCasinoMembershipGiver' },
--   data = {
--     {
--         id = "casino_vip_membership_giver",
--         label = "Get VIP Membership",
--         icon = "circle",
--         event = "np-casino:purchaseVipMembership",
--         parameters = {}
--     },
--   },
--   options = {
--       distance = { radius = 2.5 }
--   }
-- }

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isCasinoMembershipGiver' },
  data = {
    {
        id = "casino_membership_giver",
        label = _L("interact-casino-purchase-membership", "Purchase Membership ($250)"),
        icon = "circle",
        event = "np-casino:purchaseMembershipCard",
        parameters = {}
    },
    {
        id = "casino_membership_giver_emp",
        label = _L("interact-casino-get-member-card", "Get Membership Card"),
        icon = "circle",
        event = "np-casino:purchaseMembership",
        parameters = {}
    },
    {
        id = "casino_membership_loyalty",
        label = _L("interact-casino-get-loyality-card", "Get Loyalty Card"),
        icon = "circle",
        event = "np-casino:getLoyaltyCard",
        parameters = {}
    },
    {
        id = "casino_membership_hotel_vip",
        label = _L("interact-casino-hotel-vip", "Get Hotel VIP Card"),
        icon = "circle",
        event = "np-casino:getHotelVIPCard",
        parameters = {}
    },
  },
  options = {
      distance = { radius = 2.5 }
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isCasinoDrinkGiver' },
  data = {
    {
        id = "casino_drink_giver",
        label = _L("interact-casino-drinks", "Purchase Drinks"),
        icon = "circle",
        event = "np-casino:purchaseDrinks",
        parameters = {}
    },
  },
  options = {
      distance = { radius = 2.5 }
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isPawnBuyer' },
    data = {
        {
            id = "pawn_give_items",
            label = _L("interact-pawn-give", "Give stolen items"),
            icon = "circle",
            event = "np-npcs:ped:giveStolenItems",
            parameters = {}
        },
        {
            id = "pawn_sell_items",
            label = _L("interact-pawn-sell", "Sell given items"),
            icon = "circle",
            event = "np-npcs:ped:sellStolenItems",
            parameters = {}
        }
    },
    options = {
        distance = {
            radius = 2.5
        }
    }
}

-- Pawnhub Buyer
Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "pawnhub_give_items",
            label = _L("interact-pawn-give", "Hand Goods..."),
            icon = "circle",
            event = "np-business:client:pawnhub:giveStolenItems",
            parameters = {}
        },
        {
            id = "pawnhub_sell_items",
            label = _L("interact-pawn-sell", "Sell given goods..."),
            icon = "circle",
            event = "np-business:client:pawnhub:sellStolenItems",
            parameters = {}
        },
        {
            id = "pawnhub_start_run",
            label = _L("interact-pawn-sell", "Start a run..."),
            icon = "circle",
            event = "np-business:client:pawnhub:startRun",
            parameters = {}
        },
        {
            id = "pawnhub_get_balance",
            label = _L("interact-pawn-sell", "Get current balance..."),
            icon = "circle",
            event = "np-business:client:pawnhub:getBalance",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"pawnhub_buyer"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "vehicleshopkeeper",
            label = _L("interact-npc-shop-vehicle", "Purchase vehicle"),
            icon = "circle",
            event = "np-npcs:ped:vehiclekeeper",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"npc_bike_shop", "npc_boat_shop", "npc_air_shop"}
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "vehiclerentalkeeper",
          label = _L("interact-rent-vehicle", "Rent vehicle"),
          icon = "circle",
          event = "np-npcs:ped:vehiclekeeperrent",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"npc_air_shop"}
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "vehicleshoprenter",
            label = _L("interact-rent-vehicle", "Rent vehicle"),
            icon = "circle",
            event = "np-npcs:ped:vehiclekeeper",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"npc_veh_rental"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "vehicleshoprenter2",
            label = _L("interact-rent-vehicle", "Rent vehicle"),
            icon = "circle",
            event = "np-npcs:ped:vehiclekeeper",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"npc_veh_rental2"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "fish_market",
            label = _L("interact-sell-fish", "Sell fish"),
            icon = "dollar-sign",
            event = "np-npcs:ped:sellFish",
        },
        {
            id = "fish_market_buy_net",
            label = _L("interact-buy-fish-net", "Purchase Gill Net ($300)"),
            icon = "fish",
            event = "np-fishing:client:purchaseNet",
        },
        {
            id = "fish_market_buy_bucket",
            label = _L("interact-buy-fish-bucket", "Purchase Fishing Bucket ($300)"),
            icon = "fish",
            event = "np-fishing:client:purchaseBucket",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"fish_market"}
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "hunting_market",
          label = _L("interact-sell-pelts", "Sell Pelts"),
          icon = "dollar-sign",
          event = "np-hunting:makeSales",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"hunting_market"}
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "digital_den_npc",
            label = _L("interact-digital-den-shop", "Open Shop"),
            icon = "circle",
            event = "np-npcs:ped:openDigitalDenShop",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"digital_den_npc"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "cocaine_start",
            label = _L("interact-cokejob-start", "Pay me $100,000 :)"),
            icon = "circle",
            event = "heists:cocaine_payment",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"cocaine_start"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isMethDude' },
    data = {
        {
            id = "purchasemethkey",
            label = _L("interact-methnpc-buy", "Purchase Information"),
            icon = "key",
            event = "np-meth:purchaseMethInformation",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"purchasemethkey"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isMethDude' },
    data = {
        {
            id = "meth-pickup-items",
            label = _L("interact-methnpc-pickup", "Pickup items"),
            icon = "key",
            event = "np-meth:pickupItems",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"purchasemethkey"},
        isEnabled = function ()
            return exports["np-meth"]:hasUnpickedItems()
        end
    }
}

local validPracCids = {
  [1062] = true, -- claire
  [1107] = true,
  [1363] = true, -- violet
  [1380] = true, -- lexi
  [3503] = true, 
}
Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isMethDude' },
  data = {
      {
          id = "purchasepraclaptop",
          label = _L("interact-purchase-prac-lap", "Purchase Practice Laptop"),
          icon = "laptop",
          event = "np-heists:purchasePracticeLaptop",
          parameters = {}
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"purchasemethkey"},
      isEnabled = function()
        local cid = exports["isPed"]:isPed("cid")
        local pracWhitelist = exports['np-config']:GetMiscConfig("heists.prac.whitelist")
        return (pracWhitelist and validPracCids[cid]) or not pracWhitelist
      end,
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "sellgallerygem",
          label = _L("interact-sell-gems", "Sell Gems"),
          icon = "gem",
          event = "np-gallery:sellGems",
          parameters = {}
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"gemshop_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "nikezrollercoasterspawnride",
          label = _L("interact-summon-rollercoaster", "Summon roller coaster"),
          icon = "child",
          event = "nikez-rollercoaster:canSpawnCoaster",
          parameters = {}
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"nikez_rollercoaster_worker"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "nikezfreefalltowerspawnride",
          label = _L("interact-summon-freefalltower", "Summon ride"),
          icon = "space-shuttle",
          event = "nikez-freefalltower:canSpawnRide",
          parameters = {}
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"nikez_freefalltower_worker"}
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "pubtownhallbuylicense",
            label = _L("interact-purchase-licenses-pub", "purchase licenses"),
            icon = "id-card-alt",
            event = "np-gov:purchaseLicenses",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 3.5 },
        npcIds = {"npc_pub_townhall"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "pubbusinessbuylicense",
            label = _L("interact-purchase-business-license-pub", "purchase business license"),
            icon = "business-time",
            event = "np-gov:purchaseBusiness",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 3.5 },
        npcIds = {"npc_pub_business"}
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "fruitstandvendor",
          label = _L("interact-fruitstandvendor", "Buy fruits & veggies"),
          icon = "lemon",
          event = "np-distillery:fruitShop",
          parameters = {}
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"fruitstand_vendor"}
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "xcoinvendor",
            label = _L("interact-xcoinvendor", "Stacks on Stacks"),
            icon = "circle",
            event = "np-phone:getXCoin",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"xcoinredeem_1"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "purchase_gang_spray",
            label = _L("interact-purchase-spray", "Purchase Gang Spray"),
            icon = "spray-can",
            NPXEvent = "np-gangsystem:purchaseGangSpray",
            parameters = {}
        },
        {
            id = "purchase_normal_spray",
            label = _L("interact-purchase-normal-spray", "Purchase Normal Sprays ($5k)"),
            icon = "spray-can",
            event = "np-graffiti:openSprayMenu",
            parameters = {}
        },
        {
            id = "pruchase_scrubbing_cloth",
            label = _L("interact-purchase-cloth", "Purchase Scrubbing Cloth"),
            icon = "broom",
            NPXEvent = "np-gangsystem:purchaseScrubbingCloth",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"gangspray_1"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "hno_collect_rental",
            label = _L("interact-hno-rental-collect", "Collect Rental Vehicle"),
            icon = "car",
            NPXEvent = "np-hoimports:collectRental",
            parameters = {}
        },
        {
            id = "hno_return_rental",
            label = _L("interact-hno-rental-return", "Return Rental Vehicle"),
            icon = "car",
            event = "np-hoimports:returnRental",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"hno_rental_1"}
    }
}

function getHotelWorkerConfig(npcId, businessId, includeDiscount) 
  local hotelWorkerData = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "hotel_list_tenants_" .. businessId,
            label = _L("interact-list-tenants", "List tenants"),
            icon = "laptop-house",
            event = "np-business:hotel:listTenantsPrompt",
            parameters = {
              biz = businessId
            }
        },
        {
            id = "hotel_add_tenant_" .. businessId,
            label = _L("interact-add-tenant", "Add tenant"),
            icon = "house-user",
            event = "np-business:hotel:addTenantPrompt",
            parameters = {
              biz = businessId
            }
        },
        {
            id = "hotel_remove_tenant_" .. businessId,
            label = _L("interact-remove-tenant", "Remove tenant"),
            icon = "house-damage",
            event = "np-business:hotel:removeTenantPrompt",
            parameters = {
              biz = businessId
            }
        },
        {
            id = "hotel_clear_tenants_" .. businessId,
            label = _L("interact-clear-tenant", "Clear tenants"),
            icon = "home",
            event = "np-business:hotel:clearTenantsPrompt",
            parameters = {
              biz = businessId
            }
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = { npcId }
    }
  }
  if includeDiscount then
    hotelWorkerData["data"][#hotelWorkerData["data"] + 1] = {
        id = "hotel_discount_card" .. businessId,
        label = _L("interact-discount-card", "Get discount card"),
        icon = "circle",
        event = "np-casino:hotel:getDiscountCard",
        parameters = {
          biz = businessId
        }
    }
    hotelWorkerData["data"][#hotelWorkerData["data"] + 1] = {
        id = "hotel_soap" .. businessId,
        label = _L("interact-casino-soap", "Get Lucky Soap"),
        icon = "circle",
        event = "np-casino:getSoap",
        parameters = {
          biz = businessId
        }
    }
    hotelWorkerData["data"][#hotelWorkerData["data"] + 1] = {
        id = "casino_bag" .. businessId,
        label = _L("interact-casino-bag", "Get Casino Bag"),
        icon = "circle",
        event = "np-casino:getCasinoBag",
        parameters = {
          biz = businessId
        }
    }
    hotelWorkerData["data"][#hotelWorkerData["data"] + 1] = {
        id = "casino_coin_" .. businessId,
        label = _L("interact-casino-bag", "Diamond Hotel Krugerrand"),
        icon = "coins",
        event = "np-casino:getCasinoCoin",
        parameters = {
          biz = businessId
        }
    }
  end
  return hotelWorkerData
end

Entries[#Entries + 1] = getHotelWorkerConfig("rr_hotel_worker", "rr_hotel")
Entries[#Entries + 1] = getHotelWorkerConfig("casino_hotel_worker", "casino_hotel", true)
Entries[#Entries + 1] = getHotelWorkerConfig("rtreat_hotel_worker", "roosterretreat")

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "icu_list_patients",
            label = "List Patients",
            icon = "laptop-house",
            event = "np-healthcare:icu:listPatientsPrompt",
            parameters = {}
        },
        {
            id = "icu_add_patient",
            label = "Add Patient",
            icon = "house-user",
            event = "np-healthcare:icu:addPatientPrompt",
            parameters = {}
        },
        {
            id = "icu_remove_patient",
            label = "Remove Patient",
            icon = "house-damage",
            event = "np-healthcare:icu:removePatientPrompt",
            parameters = {}
        },
        {
            id = "icu_clear_patients",
            label = "Clear Patients",
            icon = "home",
            event = "np-healthcare:icu:clearPatientsPrompt",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = { "pillbox_icu_worker" }
    }
}

local validAnimalModels = {
  [`a_c_chop`] = true,
  [`a_c_husky`] = true,
  [`a_c_husky_np`] = true,
  [`a_c_panther`] = true,
  [`a_c_cat_01`] = true,
  [`a_c_poodle`] = true,
  [`a_c_pug`] = true,
  [`a_c_retriever`] = true,
  [`a_c_retriever_np`] = true,
  [`a_c_shepherd`] = true,
  [`a_c_shepherd_np`] = true,
  [`a_c_pit_np`] = true,
  [`a_c_coyote`] = true,
  [`a_c_rottweiler`] = true,
  [`a_c_westy`] = true,
}
Entries[#Entries + 1] = {
  type = 'entity',
  group = { 1 },
  data = {
      {
          id = "petthebaby",
          label = _L("interact-pet-animal", "Pet"),
          icon = "circle",
          event = "np-interact:doPettingAnimal",
          parameters = "petting",
      },
  },
  options = {
      distance = { radius = 2.5 },
      isEnabled = function(pEntity, pContext)
        -- -- Don't show options if this entity is dead 
        if pContext.isDead then
            return
        end

        return validAnimalModels[pContext.model]
      end,
  }
}
local lastStressTime = 0
AddEventHandler("np-interact:doPettingAnimal", function()
  ClearPedTasksImmediately(PlayerPedId())
  TriggerEvent("animation:runtextanim", "petting")
  if lastStressTime == 0 or lastStressTime + (60000 * 15) < GetGameTimer() then
    lastStressTime = GetGameTimer()
    TriggerEvent("client:newStress", false, 250)
  end
end)

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 1 },
  data = {
      {
          id = "bobcatblowc4",
          label = _L("interact-bobcat-blowdoor", "Blow the Door!"),
          icon = "circle",
          event = "np-heists:interactBobcatC4Npc",
          parameters = {},
      },
  },
  options = {
      distance = { radius = 2.5 },
      isEnabled = function(pEntity)
        return DecorGetBool(pEntity, "BobcatC4Ped")
      end,
  }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 1 },
    data = {
        {
            id = "bettalifenpc",
            label = _L("interact-bettalife-npc", "Get Items"),
            icon = "circle",
            event = "np-business:interactBettaLifeNpc",
            parameters = {},
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"betta_life_craft"},
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "comicstore-recycle-give",
            label = _L("interact-comicstore-turn-in", "Give toys and cards to recycle"),
            icon = "box",
            event = "np-business:ped:comicRecycleGive",
            parameters = {}
        },
        {
            id = "comicstore-recycle-recycle",
            label = _L("interact-comicstore-recycle-given", "Recycle given items"),
            icon = "recycle",
            event = "np-business:ped:comicRecycle",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = { "guild-toycrush" }
    }
}

function isCompanionOrPlayerAnimal(pEntity)
  local animalHash = GetEntityModel(pEntity)
  return (DecorGetInt(pEntity, "COMPANION_ID") ~= 0 or IsPedAPlayer(pEntity)) and (
    animalHash == `a_c_cow` or
    animalHash == `a_c_boar` or
    -- animalHash == `a_c_horse` or
    animalHash == `a_c_deer` or
    (GetEntityModel(PlayerPedId()) == `ratboy` and animalHash == `a_c_mtlion`)
  )
end

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 1 },
  data = {
      {
          id = "companion_mount",
          label = _L("interact-companions-mount", "Mount"),
          icon = "circle",
          event = "np-companions:client:mountCompanion",
          parameters = {},
      },
  },
  options = {
      distance = { radius = 2.5 },
      isEnabled = function(pEntity)
        if IsEntityAttachedToEntity(PlayerPedId(), pEntity) then
          return false
        end
        local nearbyPlayers = GetActivePlayers()
        for k, v in pairs(nearbyPlayers) do
          local playerPed = GetPlayerPed(v)
          if IsEntityAttachedToEntity(playerPed, pEntity) then
            return false
          end
        end
        return isCompanionOrPlayerAnimal(pEntity)
      end,
  }
}

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 1 },
  data = {
      {
          id = "companion_unmount",
          label = _L("interact-companions-unmount", "Unmount"),
          icon = "circle",
          event = "np-companions:client:unmountCompanion",
          parameters = {},
      },
  },
  options = {
      distance = { radius = 2.5 },
      isEnabled = function(pEntity)
        return isCompanionOrPlayerAnimal(pEntity) and IsEntityAttachedToEntity(PlayerPedId(), pEntity)
      end,
  }
}

function isMechanic()
    local mechanic = false
    local mechanicShops = { "harmony_repairs", "ottos_auto", "hayes_autos", "tuner", "iron_hog" }

    for _, shop in ipairs(mechanicShops) do
        if exports["np-business"]:IsEmployedAt(shop) then
            mechanic = true
            break
        end
    end

    return mechanic
end


Citizen.CreateThread(function()
    for _, entry in ipairs(Entries) do
        if entry.type == 'flag' then
            AddPeekEntryByFlag(entry.group, entry.data, entry.options)
        elseif entry.type == 'model' then
            AddPeekEntryByModel(entry.group, entry.data, entry.options)
        elseif entry.type == 'entity' then
            AddPeekEntryByEntityType(entry.group, entry.data, entry.options)
        elseif entry.type == 'polytarget' then
            AddPeekEntryByPolyTarget(entry.group, entry.data, entry.options)
        end
    end
end)
