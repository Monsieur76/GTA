Config                            = {}

Config.DrawDistance               = 20.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

Config.Marker                     = {type = 1, x = 1.0, y = 1.0, z = 0.25, r = 25, g = 95, b = 255, a = 100, rotate = false}

Config.ReviveReward               = 700  -- Revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- Enable anti-combat logging? (Removes Items when a player logs back after intentionally logging out while dead.)
Config.LoadIpl                    = true -- Disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'fr'

Config.EarlyRespawnTimer          = 1000 * 900  -- time til respawn is available
Config.BleedoutTimer              = 1000 * 1800 -- time til the player bleeds out 

Config.EnablePlayerManagement     = false -- Enable society managing (If you are using esx_society).

Config.RemoveWeaponsAfterRPDeath  = false
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = false

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 100

Config.RespawnPoint = { x = 322.78, y = -587.18, z = 44.2, heading = 332.52}


Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(1143.7, -1537.4, 35.9),
			sprite = 10,
			scale  = 0.8,
			color  = 26
		},

	}
}

Config.garagevoiture = {
	{nom = "Ambulance", modele = "ambulance"},
}
Config.garagehelico = {
	{nom = "Hélico", modele = "polmav"},
}

Config.pos = {

	garagevoiture = {
		position = {x = 336.84, y = -581.33, z = 28.8}
	},
    garagehelico = {
        position = {x = 342.27, y = -585.12, z = 74.16}
    },
}

Config.spawn = {

	spawnvoiture = {
		position = {x = 333.72, y = -575.51, z = 28.8, h = 336.56}
	},
    --spawnhelico = {
	--	position = {x = 352.35, y = -588.46, z = 74.16} h = 245.61}
	--},
}
