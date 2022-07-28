fx_version 'bodacious'
game 'gta5'
version '1.0.0'

client_script "@np-lib/client/cl_rpc.js"
client_script "@np-locales/client/lib.js"
client_script "build/client.js"

server_script "@np-lib/server/sv_npx.js"
server_script "@np-db/server/lib.js"
server_script "@np-lib/server/sv_rpc.js"
server_script "build/server.js"

dependencies {
  "np-selector"
}
