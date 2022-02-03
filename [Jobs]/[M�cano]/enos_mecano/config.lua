Config                            = {}
Config.Locale                     = 'fr'

Config.DrawDistance               = 20.0 -- How close you need to be in order for the markers to be drawn (in GTA units).
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true -- Enable society managing.
Config.EnableSocietyOwnedVehicles = false
Config.AntiCombatLog              = true -- Enable anti-combat logging? (Removes Items when a player logs back after intentionally logging out while dead.)

Config.NPCSpawnDistance           = 500.0
Config.NPCNextToDistance          = 25.0
Config.NPCJobEarnings             = { min = 15, max = 40 }

Config.Vehicles = {
	'adder',
	'asea',
	'asterope',
	'banshee',
	'buffalo',
	'sultan',
	'baller3'
}

Config.Zones = {

	VehicleDelivery = {
		Pos   = { x = -382.925, y = -133.748, z = 37.685 },
		Size  = { x = 20.0, y = 20.0, z = 3.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
}

Config.Towables = {
	vector3(-2480.9, -212.0, 17.4),
}

for k,v in ipairs(Config.Towables) do
	Config.Zones['Towable' .. k] = {
		Pos   = v,
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 25, g = 95, b = 255 },
		Type  = 1
} 
end

Config.garagevoiture = {
	{nom = "Transporteur remorque", modele = "flatbed"},
}

Config.pos = {
	garagevoiture = {
		position = {x = -182.37, y = -1334.87, z = 31.3}
	}
}

Config.spawn = {
	spawnvoiture = {
		position = {x = -182.37, y = -1334.87, z = 31.3, h = 0.2758}
	}
}