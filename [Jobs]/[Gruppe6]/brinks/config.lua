Config = {}
Config.Locale = 'fr'
Config.debug = false
Config.debugPrint = '[esx_brinks]'

Config.jobName = 'brinks'
Config.companyLabel = 'society_brinks'
Config.companyName = 'Gruppe 6'
Config.platePrefix = 'Gruppe6'

Config.storageMinGrade = 1
Config.armoryMinGrade = 2 -- armory and boss car
Config.manageMinGrade = 3
Config.weeklyMinGrade = 2

-- native run
Config.itemTime = 2500
Config.itemDb_name = 'sac_superette'
Config.itemName = 'Sac superette'
Config.itemAdd = 25
Config.itemRemove = 1
Config.itemPrice = 25
Config.companyRate = 8
Config.gouvRate = 1

-- weekly run
Config.blackTime = 7500
Config.blackStep = 1
Config.blackMax = 0
Config.blackAdd = 100000
Config.blackRemove = 100000
Config.blackPrice = 50000

Config.price = 30
Config.sacMin = 3
Config.sacMax = 5

-- zones
Config.zones = {
    market = {
        enable = true,
        gps = {},
        markerD = {
            type = 1,
            drawDistance = 50.0,
            size = {
                x = 1.5,
                y = 1.5,
                z = 1.5
            },
            color = {
                r = 204,
                g = 204,
                b = 0
            }
        },
        blipD = {
            route = 1
        }
    },
    bank = {
        enable = true,
        gps = {
            x = 254.04,
            y = 225.42,
            z = 101.0
        },
        markerD = {
            type = 1,
            drawDistance = 50.0,
            size = {
                x = 2.0,
                y = 2.0,
                z = 1.5
            },
            color = {
                r = 11,
                g = 203,
                b = 159
            }
        },
        blipD = {
            sprite = 67,
            display = 4,
            scale = 0.9,
            color = 52,
            range = true,
            name = _U('bank_blip')
        }
    },
    northBank = {
        enable = false,
        gps = {
            x = -103.74,
            y = 6477.91,
            z = 30.62
        },
        markerD = {
            type = 1,
            drawDistance = 50.0,
            size = {
                x = 2.0,
                y = 2.0,
                z = 1.5
            },
            color = {
                r = 11,
                g = 203,
                b = 159
            }
        },
        blipD = {
            sprite = 67,
            display = 4,
            scale = 0.9,
            color = 52,
            range = true,
            name = _U('northBank_blip')
        }
    },
    unionDepository = {
        enable = true,
        gps = {
            x = 10.24,
            y = -668.14,
            z = 32.5
        },
        markerD = {
            type = 1,
            drawDistance = 50.0,
            size = {
                x = 2.0,
                y = 2.0,
                z = 1.5
            },
            color = {
                r = 11,
                g = 203,
                b = 159
            }
        },
        blipD = {
            sprite = 67,
            display = 4,
            scale = 0.9,
            color = 52,
            range = true,
            name = _U('unionDepository_blip')
        }
    }
}

Config.market = { -- center
{
    x = -46.13047,
    y = -1758.271,
    z = 28.43,
    name = 1
}, {
    x = 1133.697,
    y = -982.4708,
    z = 45.42,
    name = 2
}, {
    x = 1165.317,
    y = -322.3742,
    z = 68.21,
    name = 3
}, {
    x = 377.73,
    y = 332.71,
    z = 102.58,
    name = 4
}, {
    x = -1485.86,
    y = -377.6055,
    z = 39.17,
    name = 5
}, {
    x = -1221.643,
    y = -908.7925,
    z = 11.33,
    name = 6
}, {
    x = -705.5613,
    y = -913.527,
    z = 18.22,
    name = 7
}, -- east coast
{
    x = -2965.91,
    y = 390.7833,
    z = 14.06,
    name = 8
}, {
    x = -3242.203,
    y = 999.7093,
    z = 11.84,
    name = 9
}, {
    x = -1819.728,
    y = 794.6349,
    z = 137.09,
    name = 10
}, -- west coast
{
    x = 2555.058,
    y = 380.6407,
    z = 107.63,
    name = 11
}, -- sandy shore
{
    x = 2675.866,
    y = 3280.38,
    z = 54.25,
    name = 12
}, {
    x = 549.6006,
    y = 2669.001,
    z = 41.17,
    name = 13
}, {
    x = 1165.902,
    y = 2711.337,
    z = 37.17,
    name = 14
}, {
    x = 1958.744,
    y = 3741.852,
    z = 31.35,
    name = 15
}, {
    x = 1697.708,
    y = 4922.295,
    z = 41.08,
    name = 16
}, -- paleto
{
    x = 1728.768,
    y = 6417.453,
    z = 34.05,
    name = 17
}}

Config.depot = {
    x = -16.39,
    y = -717.51,
    z = 39.73
}

Config.pos = {
    destruc = {
        position = {
            x = -24.08,
            y = -700.73,
            z = 39.73
        }
    }
}
