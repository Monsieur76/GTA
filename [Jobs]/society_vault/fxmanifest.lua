fx_version 'adamant'
game 'gta5'

client_scripts {
    '@es_extended/locale.lua',
	'config.lua',
	'client.lua',
    "locales/fr.lua"
}

server_scripts {
    "@async/async.lua",
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
	'server/society_vault.lua',
    'server/classes/c_society_vault.lua',
    "locales/fr.lua",
}