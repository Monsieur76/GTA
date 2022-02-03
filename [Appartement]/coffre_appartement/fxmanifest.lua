fx_version 'adamant'

game 'gta5'

description 'Inventory HUD Trunk'

version '1.2.1'


server_scripts {
  "@async/async.lua",
  "@mysql-async/lib/MySQL.lua",
  "@es_extended/locale.lua",
  "locales/fr.lua",
  "config.lua",
  "server/classes/c_coffre_appartement.lua",
  "server/coffre_appartement.lua",
}

client_scripts {
  "@es_extended/locale.lua",
  "locales/fr.lua",
  "config.lua",
  "client.lua"
}

