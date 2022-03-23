
Config = {}

Config.Locale = "fr"

Config.OpenKey = 213

-- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Weight = 40
Config.WeightWithBag = 70
-- Default weight for an item:
-- weight == 0 : The item do not affect character inventory weight
-- weight > 0 : The item cost place on inventory
-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 2

Config.store = {}

Config.VehicleWeight = {
    [0] = 50, -- Compact
    [1] = 60, -- Sedan
    [2] = 100, -- SUV
    [3] = 50, -- Coupes
    [4] = 50, -- Muscle
    [5] = 50, -- Sports Classics
    [6] = 50, -- Sports
    [7] = 50, -- Super
    [8] = 25, -- Motorcycles
    [9] = 100, -- Off-road
    [10] = 300, -- Industrial
    [11] = 70, -- Utility
    [12] = 120, -- Vans
    [13] = 0, -- Cycles
    [14] = 5, -- Boats
    [15] = 100, -- Helicopters
    [16] = 0, -- Planes
    [17] = 40, -- Service
    [18] = 40, -- Emergency
    [19] = 0, -- Military
    [20] = 300, -- Commercial
    [21] = 0 -- Trains
}
