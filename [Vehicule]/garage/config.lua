garagepublic              = {}

garagepublic.DrawDistance = 100
garagepublic.Size         = {x = 3.0, y = 3.0, z = 1.5}
garagepublic.Color        = {r = 25, g = 95, b = 255} --vert pour les voiture a sortir
garagepublic.Color2        = {r = 25, g = 95, b = 255} --rouge pour les voiture a ranger
garagepublic.Type         = 1

garagepublic.sousfourriere = 0.05


garagepublic.sousgarage = 0.001



-- 9 garage public --
-- 1 sortie du vehicle --
-- 0 fourrière --
garagepublic.zone = {

	central = {
		sortie = { x = 223.797, y = -760.415, z = 30.0},
		name = {3}
	},
	vinewood = {
		sortie = { x = -72.72, y = 909.15, z = 234.63},
		name = {4}
	},
	gang = {
		sortie = { x = -59.6, y = -1828.02, z = 25.85},
		name = {5}
	},
	sandyshore = {
		sortie = { x = 1737.59, y = 3710.2, z = 33.14 },
		name = {6}
	},
	paleto = {
		sortie = { x = 117.81, y = 6611.1, z = 30.80 },
		name = {7}
	},
	prisondesert = {
		sortie = { x = 1841.638, y = 2533.722, z = 44.672 },
		name = {8}
	},
	greatOceanHighway = {
		sortie = { x = -847.75, y = 5409.32, z = 33.61 },
		name = {300}
	}
}

garagepublic.fourriere = {
	lossantos = {
		sortie = { x = 401.42 , y = -1634.48, z = 28.29 },
	},
}