fx_version 'adamant'
game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}

dependency 'es_extended'