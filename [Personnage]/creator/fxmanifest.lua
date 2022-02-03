fx_version 'adamant'
game 'gta5'

ui_page "html/index.html"

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
}


client_scripts {
    'config.lua',
    'Client/cl_character.lua',
    'Client/cl_pmenu.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'Server/server.lua'
}


files {
	'html/index.html',
    'html/sounds/INTRO2.ogg'
}

