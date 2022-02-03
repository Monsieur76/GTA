Config = {}

Config.Locale = "fr"

-- Default weight for an item:
-- weight == 0 : The item do not affect character inventory weight
-- weight > 0 : The item cost place on inventory
-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 1

Config.ConfiscationWeight = 1000

Config.Positions = {
    ["police"] = {{
        x = 474.42,
        y = -1007.63,
        z = 33.22
    }},
    ["policeNorth"] = {{
        x = -442.29,
        y = 5987.18,
        z = 30.72
    }}
}
