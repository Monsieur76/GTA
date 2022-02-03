fx_version 'adamant'
game 'gta5'

shared_script 'config.lua'

server_scripts{
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua',
} 

client_scripts{
	'config.lua',
	'client.lua',
}


exports {
	'GetFuel',
	'SetFuel'
}
