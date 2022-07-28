local function isPropertyOwnerAndShop()
    return exports["np-housing"]:isInsideProperty() and exports["np-housing"]:hasPermissionInProperty() and exports["np-housing"]:isPropertyShop()
end

local function isRestaurant()
    local propertyId = exports["np-housing"]:getCurrentPropertyID()
    return exports['np-shops']:IsPropertyRestaurant(propertyId)
end

NPC_CONFIG = {
    ['store'] = {
        ['id'] = 'housing_store_seller_',
        ['pedType'] = 4,
        ['model'] = "a_m_y_vinewood_01",
        ['networked'] = false,
        ['distance'] = 25.0,
        ['settings'] = {
            { mode = 'invincible', active = true },
            { mode = 'ignore', active = true },
            { mode = 'freeze', active = true },
        },
        ['flags'] = {
            isNPC = true,
        },
        ['peek'] = {
            {
                ['id'] = 'housing:shop:clerk',
                ['label'] = "View inventory",
                ['icon'] = "circle",
                ['event'] = 'np-shops:openHouseShop',
            }
        } 
    }
}

PEEK_CONFIG = {
    ['prop_till_01'] = {
        {
            ['event'] = 'np-restaurants:makePayment',
            ['id'] = 'housing_shop_register_customer',
            ['icon'] = 'wallet',
            ['label']= 'Make Payment',
            ['enabledFunc'] = function(pEntity)
                return exports["np-housing"]:isInsideProperty() and exports["np-housing"]:isPropertyShop()
            end
        },
        {
            ['event'] = 'np-restaurants:chargeCustomer',
            ['id'] = 'housing_shop_register_owner',
            ['icon'] = 'money-bill',
            ['label']= 'Charge Customer',
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop()
            end
        }
    },

    ['p_v_43_safe_s'] = {
        {
            ['event'] = 'np-restaurants:viewSafeCash',
            ['id'] = 'housing_shop_safe_owner_view',
            ['icon'] = 'money-bill',
            ['label']= 'Check Cash Amount',
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop()
            end
        },
        {
            ['event'] = 'np-restaurants:takeSafeCash',
            ['id'] = 'housing_shop_safe_owner_take',
            ['icon'] = 'money-bill',
            ['label']= 'Take Cash Envelope',
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop()
            end
        }
    },


    ['v_ind_cs_tray01'] = {
        {
            ['event'] = 'np-restaurants:shelfPrompt',
            ['id'] = 'housing_shop_shelf_storage',
            ['icon'] = 'box-open',
            ['label']= 'Open',
            ['enabledFunc'] = function(pEntity)
                return exports["np-housing"]:isInsideProperty() and exports["np-housing"]:isPropertyShop()
            end
        },
    },


    ['prop_boxpile_01a'] = {
        {
            ['event'] = 'np-shops:viewStash',
            ['id'] = 'housing_shop_stash',
            ['icon'] = 'box-open',
            ['label']= 'View Stash',
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop()
            end
        },
        {
            ['event'] = 'np-shops:manageSupplies',
            ['id'] = 'housing_shop_supply_manage',
            ['icon'] = 'box',
            ['label']= 'Manage Supplies',
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop()
            end
        },
        {
            ['event'] = 'np-shops:depositSupplies',
            ['id'] = 'housing_shop_supply_deposit',
            ['icon'] = 'truck-loading',
            ['label']= 'Deposit Supplies',
            ['enabledFunc'] = function(pEntity)
                return exports["np-housing"]:isInsideProperty() and exports["np-housing"]:isPropertyShop()
            end
        },
        {
            ['event'] = 'np-shops:viewActiveCrafts',
            ['id'] = 'housing_shop_crafts',
            ['icon'] = 'hammer',
            ['label']= 'View Active Crafts',
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop()
            end
        },
        
        {
            ['event'] = 'np-shops:manageBlueprints',
            ['id'] = 'housing_shop_blueprints',
            ['icon'] = 'newspaper',
            ['label']= 'Manage Blueprints',
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop()
            end
        },
    },


    ['v_res_fa_chopbrd'] = {
        {
            ['event'] = 'np-restaurants:createFoodItem',
            ['id'] = 'housing_shop_r_main',
            ['icon'] = 'utensils',
            ['label'] = 'Prepare Main Dish',
            ['parameters'] = { foodType = "main" },
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop() and isRestaurant()
            end
        },
        {
            ['event'] = 'np-restaurants:createFoodItem',
            ['id'] = 'housing_shop_r_side',
            ['icon'] = 'utensils',
            ['label'] = 'Prepare Side Dish',
            ['parameters'] = { foodType = "side" },
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop() and isRestaurant()
            end
        },
        {
            ['event'] = 'np-restaurants:createFoodItem',
            ['id'] = 'housing_shop_r_dessert',
            ['icon'] = 'utensils',
            ['label'] = 'Prepare Dessert',
            ['parameters'] = { foodType = "dessert" },
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop() and isRestaurant()
            end
        },
        {
            ['event'] = 'np-restaurants:createFoodItem',
            ['id'] = 'housing_shop_r_drink',
            ['icon'] = 'utensils',
            ['label'] = 'Prepare Drink',
            ['parameters'] = { foodType = "drink" },
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop() and isRestaurant()
            end
        },
    },
    ['prop_cash_depot_billbrd'] = {
        {
            ['event'] = 'np-restaurants:manageFoodMenu',
            ['id'] = 'housing_shop_r_food_menu',
            ['icon'] = 'circle',
            ['label'] = 'Manage Food',
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop() and isRestaurant()
            end
        },
        {
            ['event'] = 'np-restaurants:manageDailyMenu',
            ['id'] = 'housing_shop_r_daily_menu',
            ['icon'] = 'circle',
            ['label'] = 'Manage Menu',
            ['enabledFunc'] = function(pEntity)
                return isPropertyOwnerAndShop() and isRestaurant()
            end
        },
    },
}
