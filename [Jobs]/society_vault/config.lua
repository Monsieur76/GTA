Config = {}

Config.Locale = "fr"

-- Default weight for an item:
-- weight == 0 : The item do not affect character inventory weight
-- weight > 0 : The item cost place on inventory
-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 1

Config.VaultWeight = 1000

Config.Positions = {
    ["police"] = {{
        x = 470.56,
        y = -1000.58,
        z = 30.69,
        label = "LSPD Sud"
    }},
    ["mechanic"] = {{
        x = -196.02,
        y = -1340.3,
        z = 34.9,
        label = "Benny's"
    }},
    ["taxi"] = {{
        x = 905.01,
        y = -149.37,
        z = 74.17,
        label = "Taxi"
    }},
    ["pls"] = {{
        x = 552.81,
        y = 2784.79,
        z = 42.13,
        label = "Ron"
    }},
    ["ambulance"] = {{
        x = 339.35,
        y = -595.18,
        z = 43.28,
        label = "LSMS"
    }},
    ["weazel"] = {{
        x = -573.63,
        y = -939.3,
        z = 28.82,
        label = "Weazel News"
    }},
    ["brinks"] = {{
        x = -26.8,
        y = -699.75,
        z = 50.46,
        label = "UDST"
    }},
    ["policeNorth"] = {{
        x = -441.99,
        y = 6002.46,
        z = 31.72,
        label = "LSPD Nord"
    }},
    ["vigne"] = {{
        x = -1877.95,
        y = 2055.81,
        z = 140.01,
        label = "Vignerons"
    }},
    ["burgershot"] = {{
        x = -1185.49,
        y = -900.0,
        z = 13.98,
        label = "Burger Shot"
    }},
    ["mairie"] = {{
        x = -534.41,
        y = -192.18,
        z = 47.42,
        label = "Mairie"
    }},
    ["fbi"] = {{
        x = 121.08,
        y = -743.43,
        z = 241.15,
        label = "FBI"
    }}
}
