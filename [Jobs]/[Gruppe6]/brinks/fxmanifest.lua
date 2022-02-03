fx_version 'adamant'

game 'gta5'

description 'brinks by Monsieur'





-- RageUI
client_scripts {
  "src/RMenu.lua",
  "src/menu/RageUI.lua",
  "src/menu/Menu.lua",
  "src/menu/MenuController.lua",
  "src/components/*.lua",
  "src/menu/elements/*.lua",
  "src/menu/items/*.lua",
  "src/menu/panels/*.lua",
  "src/menu/panels/*.lua",
  "src/menu/windows/*.lua",

}


dependencies {
  "mysql-async",
  "esx_society",
  "esx_billing",
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'config.lua',
  'client/esx_brinks_cl.lua',
  'client/cl_boss.lua',
  'client/cl_vestiaire.lua',
  'client/cl_mission.lua',
  'client/cl_destructeur.lua',
  'client/warp.lua',
}

server_scripts {
  "@mysql-async/lib/MySQL.lua",
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'config.lua',
  'server/esx_brinks_sv.lua',
}
