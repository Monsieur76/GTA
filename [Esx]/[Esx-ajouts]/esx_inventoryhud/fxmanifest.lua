fx_version 'adamant'

game 'gta5'

description 'Inventory HUD'

version '1.2.1'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  "@es_extended/locale.lua",
  "server/main.lua",
  "locales/fr.lua",
  "config.lua"
}

client_scripts {
  "@es_extended/locale.lua",
  "client/main.lua",
  "client/frigo.lua",	
  "client/trunk.lua",
  "client/coffre_appartement.lua",
  "client/coffreFort_appartement.lua",
  "client/police_confiscation.lua",
  "client/armory.lua",
  "client/society_vault.lua",
  "locales/fr.lua",
  "config.lua"
}

ui_page {
	'html/ui.html'
}

files {
  "html/ui.html",
  "html/css/ui.css",
  "html/css/jquery-ui.css",
  "html/js/inventory.js",
  "html/js/config.js",
  -- IMAGES
  "html/img/*.png"
}

dependencies {
	'es_extended'
}
