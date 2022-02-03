Config                   = {}
Config.DrawDistance      = 100.0
Config.Locale            = 'fr'
Config.IsMechanicJobOnly = true

Config.toit = 500
Config.rouearriere = 500
Config.spoiler = 700
Config.parechocsavant = 500
Config.parechocsarriere = 500
Config.jupe = 400
Config.pot = 200
Config.cadre = 200
Config.calandre = 500
Config.hotte = 500
Config.gardeboue = 500
Config.Aile = 500
Config.ornementarriere = 500
Config.Plaqueavant = 500
Config.interieur = 500
Config.Ornement = 500
Config.Tableaudebord = 500
Config.Compteur = 500
Config.Enceinteportiere = 500
Config.Siege = 500
Config.Volant = 500
Config.Levier = 500
Config.Plagearriere = 500
Config.Enceinte = 500
Config.Coffre = 500
Config.Hydrolique = 500
Config.Blocmoteur = 500
Config.Filtre = 500
Config.Entretoises = 500
Config.Couverture = 500
Config.Antennes = 500
Config.Interieurb = 500
Config.Bouchon = 500
Config.Fenetre = 500
Config.Couverture = 500
Config.klaxon = 100
Config.neon = 600
Config.Fenetrecouleur = 300
Config.jante = 350
Config.phare = 900




Config.Zones = {

	ls1 = {
		Pos   = { x = -236.67, y = -1337.83, z = 30.73},
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Name  = _U('blip_name'),
		Hint  = _U('press_custom')
	},
	ls2 = {
		Pos   = { x = -234.16, y = -1316.26, z = 30.73},
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Name  = _U('blip_name'),
		Hint  = _U('press_custom')
	},
}


Config.WindowTints = 
{  
	{index = 0, name="Pure Black"},
	{index = 1, name="Darksmoke"},
	{index = 2, name="Lightsmoke"},
	{index = 3, name="Aucun"},
	{index = 4, name="Stock"},
}

Config.headlights = 
{  
	{index = -1, name="Bleu electrique"},
	{index = 0, name="Bleu ciel"},
	{index = 1, name="Vert menthe"},
	{index = 2, name="Jaune citron"},
	{index = 3, name='Jaune'},
	{index = 4, name='Or'},
	{index = 5, name='Orange'},
	{index = 6, name='Rouge'},
	{index = 7, name='Rose pale'},
	{index = 8, name='Rose bonbon'},
	{index = 9, name='Violet'},
	{index = 10, name='Lumière noir'},
	{index = 11, name='Default'},
	{index = 12, name='Blanc'},
}

Config.PlateColor = {
			{ index = 1, label = _U('yellow_on_black')},
			{ index = 2, label = _U('yellow_blue')},
			{ index = 0, label = _U('blue_on_white_1')},
			{ index = 3, label = _U('blue_on_white_2')},
			{ index = 4, label = _U('blue_on_white_3')}
}

Config.horn = 
{  
	{index = 0, name="Truck Horn"},
	{index = 1, name="Cop Horn"},
	{index = 2, name="Clown Horn"},
	{index = 3, name="Musical Horn 1"},
	{index = 4, name="Musical Horn 2"},
	{index = 5, name="Musical Horn 3"},
	{index = 6, name="Musical Horn 4"},
	{index = 7, name="Musical Horn 5"},
	{index = 8, name="Sad Trombone"},
	{index = 9, name="Classical Horn 1"},
	{index = 10, name="Classical Horn 2"},
	{index = 11, name="Classical Horn 3"},
	{index = 12, name="Classical Horn 4"},
	{index = 13, name="Classical Horn 5"},
	{index = 14, name="Classical Horn 6"},
	{index = 15, name="Classical Horn 7"},
	{index = 16, name="Scale - Do"},
	{index = 17, name="Scale - Re"},
	{index = 18, name="Scale - Mi"},
	{index = 19, name="Scale - Fa"},
	{index = 20, name="Scale - Sol"},
	{index = 21, name="Scale - La"},
	{index = 22, name="Scale - Ti"},
	{index = 23, name="Scale - Do"},
	{index = 24, name="Jazz Horn 1"},
	{index = 25, name="Jazz Horn 2"},
	{index = 26, name="Jazz Horn 3"},
	{index = 27, name="Jazz Horn Loop"},
	{index = 28, name="Star Spangled Banner 1"},
	{index = 29, name="Star Spangled Banner 2"},
	{index = 30, name="Star Spangled Banner 3"},
	{index = 31, name="Star Spangled Banner 4"},
	{index = 32, name="Classical Horn 8 Loop"},
	{index = 33, name="Classical Horn 9 Loop"},
	{index = 34, name="Classical Horn 10 Loop"},
	{index = 35, name="Classical Horn 8"},
	{index = 36, name="Classical Horn 9"},
	{index = 37, name="Classical Horn 10"},
	{index = 38, name="Funeral Loop"},
	{index = 39, name="Funeral"},
	{index = 40, name="Spooky Loop"},
	{index = 41, name="Spooky"},
	{index = 42, name="San Andreas Loop"},
	{index = 43, name="San Andreas"},
	{index = 44, name="Liberty City Loop"},
	{index = 45, name="Liberty City"},
	{index = 46, name="Festive 1 Loop"},
	{index = 47, name="Festive 1"},
	{index = 48, name="Festive 2 Loop"},
	{index = 49, name="Festive 2"},
	{index = 50, name="Festive 3 Loop"},
	{index = 51, name="Festive 3"},
}

Config.wheelType ={
	{ index = 0, label =  "Sport"},
	{ index = 1, label ="Muscle"},
	{index = 2, label = "Lowrider" },
	{index = 3, label =  "SUV"},
	{index = 4, label =  "Offroad" },
	{index = 5, label =  "Tuner" },
	{index = 6, label =  "Bike Wheels" },
	{index = 7, label =  "High End"},
	{index = 8, label =  "Benny's Wheels"},
	{index = 9, label =  "Bespoke Wheels"},
}


Config.neons = {
		{label = "Blanc",		r = 255, 	g = 255, 	b = 255},
		{label = "Rouge",		r = 255, 	g = 0, 	b = 0},
		{label = "Rose",			r = 255, 		g = 0, 		b = 150},
		{label = "Rose pale",		r = 255, 		g = 100, 	b = 190},
		{label = "Violet", 		r = 200, 		g = 0, 		b = 255},
		{label = "Violet nuit", 		r = 100, 	g = 0, 	b = 255},		
		{label = "Bleu", 		r = 0, 		g = 0, 	b = 255},
		{label = "Bleu electrique", 	r = 0, 	g = 120, 	b = 255},
		{label = "Bleu ciel", 	r = 0, 		g = 200, 	b = 255},
		{label = "Turquoise", 			r = 0, 	g = 255, 	b = 255},
		{label = "Vert menthe", 	r = 0, 	g = 255, 	b = 160},
		{label = "Vert lime", 		r = 0, 	g = 255, 	b = 100}, 		
		{label = "Vert", 	r = 0, 	g = 255, 	b = 0},				
		{label = "Citron", 		r = 140, 	g = 255, 	b = 0},		
		{label = "Jaune", 		r = 255, 	g = 255, 		b = 0},
		{label = "Or", 		r = 255, 	g = 200, 	b = 0},
		{label = "Orange",	r = 255, 	g = 150, 		b = 0},
		{label = "Lave", 	r = 255, 	g = 90, 		b = 0},			
		{label = "Violet pale", 		r = 208, 	g = 146, 		b = 255},
		{label = "Bleu pale", 		r = 146, 	g = 184, 	b = 255},
		{label = "Vert pale",	r = 146, 	g = 255, 		b = 146},
		{label = "Jaune pale", 	r = 255, 	g = 255, 		b = 146},
}
