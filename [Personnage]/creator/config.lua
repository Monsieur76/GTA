config = {}

config.data = {}

config.isMenuEnable = false
config.Camera = {
    face = {x = 402.92, y = -1000.72, z = -98.35, fov = 7.00},
    body = {x = 402.92, y = -1000.72, z = -99.01, fov = 30.00},
    torso = {x = 402.92, y = -1000.72, z = -98.80, fov = 10.00},
    cam = nil,
    cam2 = nil,
    cam3 = nil
}
config.price = 20
config.stored = 9
config.CamPerso = nil
config.PlayerSpawnPos = {x = -1042.635, y =-2745.828, z = 21.359, h = -30.0}

config.Character = {
    sex = {0, 1},
    faceName = {"Largeur du nez","Hauteur du nez","Longueur du nez","Hauteur de l'os du nez","Abaissement de la pointe du nez","Torsion de l'os du nez",
    "Hauteur des sourcils","Profondeur des sourcils","Hauteur des pommettes","Largeur des pommettes","Largeur des joues","Regard","Lèvres","Largeur mâchoire","Longueur de la mâchoire","Hauteur du menton",
    "Longueur du menton","Largeur du menton","Fossette du menton","Épaisseur du cou"},
    item = {"nose_1","nose_2","nose_3","nose_4","nose_5","nose_6","eyebrows_5",'eyebrows_6','cheeks_1','cheeks_2','cheeks_3','eye_squint','lip_thickness','jaw_1','jaw_2','chin_1','chin_2','chin_3',
    'chin_4','neck_thickness'},
    echelle={1,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1,0,-0.1,-0.2,-0.3,-0.4,-0.5,-0.6,-0.7,-0.8,-0.9,-1},
    face = {0,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19},
    hairCut = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23},
    hairColors = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
    eyesColor = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20},
    barbe = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, "sans"},
    couleur_barbe = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
    sourcil = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33},
    sourcil_couleur = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
    acnee = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, "sans"},
    ride = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, "sans"},
    maquillage = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, "sans"},
    maquillage_levre = {0, 1, 2, 3, 4, 5, 6, 7, 8, "sans"},
    couleur_maquillage_levre = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
    poil = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, "sans"},
    couleur_poil = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
    nom = "Sans Nom",
    prenom = "Sans Prenom",
    age = 0,
    nationaliter = "N/A"
}

config.Outfit = {
	{
		label = 'Plage',
		id = {
			male = {
				Tops = {componentId = 11, drawableId = 36, textureId = 0, paletteId = 0},
                Undershirts = {componentId = 8, drawableId = 15, textureId= 0,paletteId = 0},
                Shoes = {componentId = 6, drawableId = 5, textureId = 0, paletteId = 0},
                Accessories = {componentId = 7, drawableId = 0, textureId = 0, paletteId = 0},
                Legs = {componentId = 4, drawableId = 15, textureId = 0,  paletteId = 0},
                Torsos = {componentId = 3, drawableId = 5, textureId = 0, paletteId = 0}
			},
			female = {
                Tops = {componentId = 11, drawableId = 17, textureId = 0, paletteId = 0},
                Undershirts = {componentId = 8, drawableId = 15, textureId= 0,paletteId = 0},
                Shoes = {componentId = 6, drawableId = 5, textureId = 0, paletteId = 0},
                Accessories = {componentId = 7, drawableId = 0, textureId = 0, paletteId = 0},
                Legs = {componentId = 4, drawableId = 25, textureId = 0,  paletteId = 0},
                Torsos = {componentId = 3, drawableId = 0, textureId = 0, paletteId = 0}
			}
		}
	},
	{
		label = 'Tenue maison',
		id = {
			male = {
                Tops = {componentId = 11, drawableId = 80, textureId = 0, paletteId = 0},
                Undershirts = {componentId = 8, drawableId = 15, textureId= 0,paletteId = 0},
                Shoes = {componentId = 6, drawableId = 6, textureId = 0, paletteId = 0},
                Accessories = {componentId = 7, drawableId = 0, textureId = 2, paletteId = 0},
                Legs = {componentId = 4, drawableId = 55, textureId = 0, paletteId = 0},
                Torsos = {componentId = 3, drawableId = 11, textureId = 0,paletteId = 0}
			},
			female = {
                Tops = {componentId = 11, drawableId = 76, textureId = 0, paletteId = 0},
                Undershirts = {componentId = 8, drawableId = 10, textureId= 0,paletteId = 0},
                Shoes = {componentId = 6, drawableId = 16, textureId = 0, paletteId = 0},
                Accessories = {componentId = 7, drawableId = 0, textureId = 0, paletteId = 0},
                Legs = {componentId = 4, drawableId = 58, textureId = 0, paletteId = 0},
                Torsos = {componentId = 3, drawableId = 14, textureId = 0,paletteId = 0}
			}
		}
	},

    {
		label = "Tenue Tape-à-l'oeil",
		id = {
			male = {
                Tops = {componentId = 11, drawableId = 29, textureId = 0, paletteId = 0},
                Undershirts = {componentId = 8, drawableId = 31, textureId= 0,paletteId = 0},
                Shoes = {componentId = 6, drawableId = 10, textureId = 0, paletteId = 0},
                Accessories = {componentId = 7, drawableId = 0, textureId = 0, paletteId = 0},
                Legs = {componentId = 4, drawableId = 24, textureId = 0, paletteId = 0},
                Torsos = {componentId = 3, drawableId = 4, textureId = 0,paletteId = 0}
			},
			female = {
                Tops = {componentId = 11, drawableId = 6, textureId = 0, paletteId = 0},
                Undershirts = {componentId = 8, drawableId = 41, textureId= 0,paletteId = 0},
                Shoes = {componentId = 6, drawableId = 6, textureId = 0, paletteId = 0},
                Accessories = {componentId = 7, drawableId = 0, textureId = 0, paletteId = 0},
                Legs = {componentId = 4, drawableId = 7, textureId = 0, paletteId = 0},
                Torsos = {componentId = 3, drawableId = 5, textureId = 0,paletteId = 0}
			}
		}
	}
}