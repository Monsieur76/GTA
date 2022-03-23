fx_version 'adamant'
game 'gta5'

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

ui_page 'html/form.html'

files {
	'html/form.html',
	'html/img/seal.png',
	'html/img/document.jpg',
	'html/img/signature.png',
	'html/img/cursor.png',
	'html/css.css',
	'html/language_en.js',
	'html/language_gr.js',
	'html/language_br.js',
	'html/language_de.js',
	'html/language_fr.js',
	'html/script.js',
	'html/jquery-3.4.1.min.js',
}

server_scripts {
	'config.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/gr.lua',
	'locales/en.lua',
	'locales/br.lua',
	'locales/de.lua',
	'locales/fr.lua',
	'server.lua',
}

client_scripts {
	'config.lua',
	'@es_extended/locale.lua',
	'locales/gr.lua',
	'locales/en.lua',
	'locales/br.lua',
	'locales/de.lua',
	'locales/fr.lua',
	--'GUI.lua',
	'client/client.lua',
	'client/cl_police_creat.lua',
	'client/cl_police_show.lua',
	'client/cl_ambulance_creat.lua',
	'client/cl_ambulance_show.lua',
}
