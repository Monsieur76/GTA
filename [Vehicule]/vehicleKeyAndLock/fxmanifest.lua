fx_version 'adamant'
game 'gta5'

server_script {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/classe/key.lua'
}

client_scripts {
	'client/main.lua',
	'config.lua'
}