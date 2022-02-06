fx_version 'adamant'

game 'gta5'

description 'lsVigne with RageUI by Vladimir/RexTon'


-- RageUI
client_scripts {
    "client/src/client/RMenu.lua",
    "client/src/client/menu/RageUI.lua",
    "client/src/client/menu/Menu.lua",
    "client/src/client/menu/MenuController.lua",

    "client/src/client/components/*.lua",

    "client/src/client/menu/elements/*.lua",

    "client/src/client/menu/items/*.lua",

    "client/src/client/menu/panels/*.lua",

    "client/src/client/menu/windows/*.lua",

}


client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/*',

}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/*'
}

dependencies {
	'es_extended',
	'esx_society',
	'esx_billing'
}
