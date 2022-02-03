fx_version 'cerulean'
game 'gta5'


client_scripts {
	'player/config.lua',
	'player/client/cl_pvp.lua',
	'player/client/cl_recul.lua',
	'player/client/cl_hud.lua',
	'player/client/server_name.lua',
	'player/client/cl_drift.lua',
	--'player/client/cl_weaponme.lua',
	'player/client/ShowID.lua',
	'pnj/client/cl_aircontrol.lua',
	'pnj/client/cl_calmai.lua',
	--'pnj/client/cl_delarmecar.lua',
	'pnj/client/cl_disabledispatch.lua',
	'pnj/client/cl_pnjxplayer.lua',
	'pnj/client/cl_removecops.lua',
	'player/client/cl_invi.lua',

}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	--'pnj/server/sv_delarmecar.lua',
	--'pnj/server/sv_pnjxplayer.lua',
	"dynamic-npcs/common.lua",
	"dynamic-npcs/config.lua",
	"dynamic-npcs/server.lua"
}

files {
	--'pnj/files/events.meta',
	'pnj/files/relationships.dat',
}

--data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'pnj/files/events.meta'

export 'SetInstructionalButton'

client_scripts {
	'@es_extended/locale.lua',
	'needs/locales/fr.lua',
	'needs/config.lua',
	'needs/client/cl_basicneeds.lua',
	'needs/client/cl_drugeffects.lua',
	'needs/client/cl_optionalneeds.lua',
	"dynamic-npcs/common.lua",
	"dynamic-npcs/client.lua"
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'needs/locales/fr.lua',
	'needs/config.lua',
	'needs/server/sv_basicneeds.lua',
	'needs/server/sv_drugeffects.lua',
	'needs/server/sv_optionalneeds.lua'
}