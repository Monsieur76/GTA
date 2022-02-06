fx_version 'adamant'

game 'gta5'

description 'Pls by Monsieur'


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


client_scripts {
	'@es_extended/locale.lua',
	'client/cl_pls.lua',
    --'client/cl_vestiaire_pls.lua',
    'client/cl_boss.lua',
    'client/cl_traitement.lua',
    'client/pc_station_service.lua',
    'config.lua',
}


server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/sv_pls.lua'
}

dependencies {
	'es_extended',
	'esx_society',
	'esx_billing'
}
