fx_version 'adamant'

game 'gta5'

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'client.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
}

dependencies {
	'es_extended'
}
