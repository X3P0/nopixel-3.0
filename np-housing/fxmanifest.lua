fx_version 'cerulean'
games { 'gta5' }

client_script "@np-lib/client/cl_ui.lua"
client_script "config.lua"

client_scripts {
    '@np-lib/client/cl_rpc.lua',
    'client/cl_*.lua',
}

shared_script {
  '@np-lib/shared/sh_util.lua',
  'shared/sh_*.*'
}

server_scripts {
    '@np-lib/server/sv_rpc.lua',
    '@np-lib/server/sv_sql.lua',
    '@np-lib/server/sv_asyncExports.lua',
    'server/sv_*.lua',
}

export "retriveHousingTable"
export "isNearProperty"
export "isInRobbery"
export "retrieveHousingTableMapped"
export "retrieveHousingZonesConfig"

export "hasPermissionInProperty"
export "getOwnerOfCurrentProperty"
export "getCurrentPropertyID"
export "isOwnerOfCurrentProperty"
export "isPropertyShop"
export "isInsideProperty"

server_export "getSetOfProperty"
server_export "retrieveHousingTableMapped"
server_export "isCIDOwner"