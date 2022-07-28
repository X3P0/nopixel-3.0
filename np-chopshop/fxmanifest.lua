fx_version 'cerulean'
games { 'gta5' }

client_script "@np-sync/client/lib.lua"
client_script "@np-lib/client/cl_flags.lua"
client_script "@np-lib/client/cl_vehicles.lua"
client_script "@np-lib/client/cl_rpc.lua"
client_script "@np-locales/client/lib.lua"

client_scripts {
    "client/*.lua",
    "client/modules/*.lua"
}

server_scripts {
    "server/classes/*.lua",
    "server/*.lua",
    "server/controllers/*.lua",
}