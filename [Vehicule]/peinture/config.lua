Config                   = {}
Config.DrawDistance      = 100.0
Config.Locale            = 'fr'
Config.IsMechanicJobOnly = true
Config.society = "mechanic"


-- Prix fixe ou non --
Config.payementFixecolor1 = false
Config.payementFixecolor2 = false
Config.payementFixepearl = false
Config.payementFixejante = true
Config.payementFixeplaque = true
Config.payementFixestickers = false

--Définir Minimum prix si % est trop bas Néssecite prix fixe en false--
Config.minimumcolor1 = 250
Config.minimumcolor2 = 250
Config.minimumpearl = 250
Config.minimumjante = 250
Config.minimumplaque = 250
Config.minimumFixestickers = 250

--- Si prix fixe ---
Config.fixepayementcolor1 = 250
Config.fixepayementcolor2 = 250
Config.fixepayementpearl = 250
Config.fixepayementjante = 250
Config.fixepayementplaque = 200
Config.fixepayementstickers = 1000

--- Si prix en %---
Config.payementcolor1 = 0.002
Config.payementcolor2 = 0.002
Config.payementpearl = 0.002
Config.payementjante = 0.0001
Config.payementplaque = 0.001
Config.payementstickers = 0.002


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

Config.Colors = {
	{ index = 15, label = _U('darknight')},
	{ index = 16, label = _U('deepblack')},
	{ index = 147, label = _U('carbon')},
	{ index = 122, label = _U('snow')},
	{ index = 134, label = _U('purewhite')},
	{ index = 17, label = _U('asphaltgray')},
	{ index = 18, label = _U('grayconcrete')},
	{ index = 19, label = _U('darksilver')},
	{ index = 20, label = _U('magnesite')},
	{ index = 144, label = _U('grayhunter')},
	{ index = 156, label = _U('grey')},
	{ index = 43, label = _U('red_pulp')},
	{ index = 44, label = _U('bril_red')},
	{ index = 135, label = _U('electricpink')},
	{ index = 136, label = _U('salmon')},
	{ index = 75, label = _U('blue_night')},
	{ index = 77, label = _U('cyan_blue')},
	{ index = 78, label = _U('cobalt')},
	{ index = 79, label = _U('electric_blue')},
	{ index = 80, label = _U('horizon_blue')},
	{ index = 127, label = _U('paradise')},
	{ index = 140, label = _U('bubble_gum')},
	{ index = 157, label = _U('glacier_blue')},
	{ index = 88, label = _U('wheat')},
	{ index = 89, label = _U('raceyellow')},
	{ index = 91, label = _U('paleyellow')},
	{ index = 56, label = _U('forest_green')},
	{ index = 57, label = _U('lawn_green')},
	{ index = 138, label = _U('orangelambo')},
	{ index = 45, label = _U('copper')},
	{ index = 108, label = _U('brown')},
	{ index = 109, label = _U('hazelnut')},
	{ index = 110, label = _U('shell')},
	{ index = 76, label = _U('darkviolet')},
	{ index = 81, label = _U('amethyst')},
	{ index = 117, label = _U('brushedchrome')},
	{ index = 118, label = _U('blackchrome')},
	{ index = 119, label = _U('brushedaluminum')},
	{ index = 150, label = _U('volcano')},
	{ index = 158, label = _U('puregold')},
	{ index = 159, label = _U('brushedgold')},
	{ index = 160, label = _U('lightgold')}
}

Config.Colors.matt = {
	{ index = 12, label = _U('matteblack')},
	{ index = 13, label = _U('graymat')},
	{ index = 14, label = _U('lightgrey')},
	{ index = 21, label = _U('oil')},
	{ index = 22, label = _U('nickel')},
	{ index = 23, label = _U('zinc')},
	{ index = 24, label = _U('dolomite')},
	{ index = 25, label = _U('bluesilver')},
	{ index = 26, label = _U('titanium')},
	{ index = 39, label = _U('matte_red')},
	{ index = 40, label = _U('dark_red')},
	{ index = 41, label = _U('matteorange')},
	{ index = 42, label = _U('yellow')},
	{ index = 46, label = _U('pale_red')},
	{ index = 47, label = _U('lightbrown')},
	{ index = 48, label = _U('darkbrown')},
	{ index = 55, label = _U('lime_green')},
	{ index = 58, label = _U('imperial_green')},
	{ index = 59, label = _U('green_bottle')},
	{ index = 60, label = _U('light_blue')},
	{ index = 82, label = _U('metallic_blue')},
	{ index = 83, label = _U('aquamarine')},
	{ index = 84, label = _U('blue_agathe')},
	{ index = 85, label = _U('zirconium')},
	{ index = 86, label = _U('spinel')},
	{ index = 87, label = _U('tourmaline')},
	{ index = 113, label = _U('beige')},
	{ index = 114, label = _U('mahogany')},
	{ index = 115, label = _U('cauldron')},
	{ index = 116, label = _U('blond')},
	{ index = 121, label = _U('mattewhite')},
	{ index = 123, label = _U('lightorange')},
	{ index = 124, label = _U('peach')},
	{ index = 126, label = _U('lightyellow')},
	{ index = 128, label = _U('khaki')},
	{ index = 129, label = _U('gravel')},
	{ index = 130, label = _U('pumpkin')},
	{ index = 131, label = _U('cotton')},
	{ index = 132, label = _U('alabaster')},
	{ index = 133, label = _U('army_green')},
	{ index = 148, label = _U('matteviolet')},
	{ index = 149, label = _U('mattedeeppurple')},
	{ index = 151, label = _U('dark_green')},
	{ index = 152, label = _U('hunter_green')},
	{ index = 153, label = _U('darkearth')},
	{ index = 154, label = _U('desert')},
	{ index = 155, label = _U('matte_foilage_green')},
}

Config.Colors.Metallic = {
	{ index = 0, label = _U('black')},
	{ index = 1, label = _U('graphite')},
	{ index = 2, label = _U('black_metallic')},
	{ index = 3, label = _U('caststeel')},
	{ index = 4, label = _U('silver')},
	{ index = 5, label = _U('metallicgrey')},
	{ index = 6, label = _U('laminatedsteel')},
	{ index = 7, label = _U('darkgray')},
	{ index = 8, label = _U('rockygray')},
	{ index = 9, label = _U('graynight')},
	{ index = 10, label = _U('aluminum')},
	{ index = 11, label = _U('black_anth')},
	{ index = 27, label = _U('red')},
	{ index = 28, label = _U('torino_red')},
	{ index = 29, label = _U('poppy')},
	{ index = 30, label = _U('copper_red')},
	{ index = 31, label = _U('cardinal')},
	{ index = 32, label = _U('brick')},
	{ index = 33, label = _U('garnet')},
	{ index = 34, label = _U('cabernet')},
	{ index = 35, label = _U('candy')},
	{ index = 36, label = _U('tangerine')},
	{ index = 37, label = _U('gold')},
	{ index = 38, label = _U('orange')},
	{ index = 49, label = _U('met_dark_green')},
	{ index = 50, label = _U('rally_green')},
	{ index = 51, label = _U('pine_green')},
	{ index = 52, label = _U('olive_green')},
	{ index = 53, label = _U('light_green')},
	{ index = 54, label = _U('topaz')},
	{ index = 61, label = _U('galaxy_blue')},
	{ index = 62, label = _U('dark_blue')},
	{ index = 63, label = _U('azure')},
	{ index = 64, label = _U('navy_blue')},
	{ index = 65, label = _U('lapis')},
	{ index = 66, label = _U('steelblue')},
	{ index = 67, label = _U('blue_diamond')},
	{ index = 68, label = _U('surfer')},
	{ index = 69, label = _U('pastel_blue')},
	{ index = 70, label = _U('celeste_blue')},
	{ index = 71, label = _U('indigo')},
	{ index = 72, label = _U('deeppurple')},
	{ index = 73, label = _U('rally_blue')},
	{ index = 74, label = _U('blue_paradise')},
	{ index = 88, label = _U('wheat')},
	{ index = 89, label = _U('raceyellow')},
	{ index = 90, label = _U('bronze')},
	{ index = 91, label = _U('paleyellow')},
	{ index = 92, label = _U('citrus_green')},
	{ index = 93, label = _U('champagne')},
	{ index = 94, label = _U('brownmetallic')},
	{ index = 95, label = 'Expresso'},
	{ index = 96, label = _U('chocolate')},
	{ index = 97, label = _U('terracotta')},
	{ index = 98, label = _U('marble')},
	{ index = 99, label = _U('sand')},
	{ index = 100, label = _U('sepia')},
	{ index = 101, label = _U('bison')},
	{ index = 102, label = _U('palm')},
	{ index = 103, label = _U('caramel')},
	{ index = 104, label = _U('rust')},
	{ index = 105, label = _U('chestnut')},
	{ index = 106, label = _U('vanilla')},
	{ index = 107, label = _U('creme')},
	{ index = 111, label = _U('white')},
	{ index = 112, label = _U('polarwhite')},
	{ index = 120, label = _U('chrome')},
	{ index = 125, label = _U('green_anis')},
	{ index = 137, label = _U('sugarplum')},
	{ index = 141, label = _U('midnight_blue')},
	{ index = 142, label = _U('mysticalviolet')},
	{ index = 143, label = _U('wine_red')},
	{ index = 145, label = _U('purplemetallic')},
	{ index = 146, label = _U('forbidden_blue')},
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
	{index = -1, name="Default"},
	{index = 0, name="Blanc"},
	{index = 1, name="Bleu"},
	{index = 2, name="Bleu electrique"},
	{index = 3, name='Mint_Green '},
	{index = 4, name='Lime_Green'},
	{index = 5, name='Yellow '},
	{index = 6, name='Golden_Shower'},
	{index = 7, name='Orange'},
	{index = 8, name='Red '},
	{index = 9, name='Pony_Pink '},
	{index = 10, name='Hot_Pink '},
	{index = 11, name='Purple '},
	{index = 12, name='Blacklight '},
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




Config.neons = {
		{label = _U('white'),		r = 255, 	g = 255, 	b = 255},
		{label = "Slate Gray",		r = 112, 	g = 128, 	b = 144},
		{label = "Blue",			r = 0, 		g = 0, 		b = 255},
		{label = "Light Blue",		r = 0, 		g = 150, 	b = 255},
		{label = "Navy Blue", 		r = 0, 		g = 0, 		b = 128},
		{label = "Sky Blue", 		r = 135, 	g = 206, 	b = 235},
		{label = "Turquoise", 		r = 0, 		g = 245, 	b = 255},
		{label = "Mint Green", 	r = 50, 	g = 255, 	b = 155},
		{label = "Lime Green", 	r = 0, 		g = 255, 	b = 0},
		{label = "Olive", 			r = 128, 	g = 128, 	b = 0},
		{label = _U('yellow'), 	r = 255, 	g = 255, 	b = 0},
		{label = _U('gold'), 		r = 255, 	g = 215, 	b = 0},
		{label = _U('orange'), 	r = 255, 	g = 165, 	b = 0},
		{label = _U('wheat'), 		r = 245, 	g = 222, 	b = 179},
		{label = _U('red'), 		r = 255, 	g = 0, 		b = 0},
		{label = _U('pink'), 		r = 255, 	g = 161, 	b = 211},
		{label = _U('brightpink'),	r = 255, 	g = 0, 		b = 255},
		{label = _U('purple'), 	r = 153, 	g = 0, 		b = 153},
		{label = "Aucun", 			r = 41, 	g = 36, 	b = 33}
}




