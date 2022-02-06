Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 25, g = 95, b = 255 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableLicenses             = true -- enable if you're using esx_license
Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.pos = {
	bar = {
		position = {x = -1388.0, y = -613.0, z = 30.32}
	}
}

--les items au bar
Config.baritem = {
    {nom = "Eau", prix = 5, item = "eau"},
    {nom = "Pain", prix = 5, item = "pain"},   
    {nom = "Bière", prix = 10, item = "biere"},   
    {nom = "Whisky", prix = 10, item = "whisky"},   
    {nom = "Vodka", prix = 10, item = "vodka"},   
    {nom = "Rhum", prix = 10, item = "rhum"},  
}