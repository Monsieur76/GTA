Config = {}

Config.Locale = "fr"

-- Default weight for an item:
-- weight == 0 : The item do not affect character inventory weight
-- weight > 0 : The item cost place on inventory
-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 2



Config.ArmurerieWeight = 1000

Config.Positions = {
    ["police"] = {{
        x = 485.23,
        y = -1006.08,
        z = 24.73,
        label = "LSPD Sud"
    }},
    ["brinks"] = {{
        x = 4.51,
        y = -656.45,
        z = 32.45,
        label = "UDST"
    }},
    ["policeNorth"] = {{
        x = -437.38,
        y = 5988.71,
        z = 30.72,
        label = "LSPD Nord"
    }},
    ["fbi"] = {{
        x = 119.65,
        y = -726.62,
        z = 241.15,
        label = "FBI"
    }},
    ["scarlett"] = {{
        x = -1498,36,
        y = 123.01,
        z = 54.67,
        label = "Scarlett"
    }}
}
