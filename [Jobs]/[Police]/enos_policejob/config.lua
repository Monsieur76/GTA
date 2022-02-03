Config                            = {}

Config.DrawDistance               = 25.0
Config.Type = 1

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.MaxInService               = 1000
Config.Locale                     = 'fr'

Config.WhitelistedCops = {
	'police'
}

Config.armi = {
	{nom = "Pistolet", arme = "weapon_pistol"},
	{nom = "Fusil à pompe", arme = "weapon_pumpshotgun_mk2"},
	{nom = "M4", arme = "weapon_carbinerifle"},
}


Config.pos = {
	garagevoiture = {
		position = {x = 460.15, y = -984.55, z = 24.73}
	},
	garageheli = {
		position = {x = 448.69, y = -981.65, z = 43.69}
	},
	camera = {
		position = {x = 438.68, y = -992.2, z = 29.69} 
	},
	garagebus = {
		position = {x = 463.22, y = -1019.71, z = 28.11} 
	}
}

Config.spawn = {

	spawnvoiture = {
		position = {x = 447.29, y = -979.26, z = 24.73, h = 173.6211}
	},
	spawnheli = {
		position = {x = 448.69, y = -981.65, z = 43.69, h = 87.916}
	},
	spawnbus = {
		position = {x = 459.18, y = -1019.71, z = 28.46, h = 90.254165}
	},
}
