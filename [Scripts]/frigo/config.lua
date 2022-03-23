Config = {}

Config.Locale = "fr"

-- Default weight for an item:
-- weight == 0 : The item do not affect character inventory weight
-- weight > 0 : The item cost place on inventory
-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 1

Config.FrigoWeight = 1000

Config.Positions = {
    ["policeJob"] = {{
        x = 486.08,
        y = -994.13,
        z = 30.69,
        label = "LSPD Sud"
    }},
    ["burgershotJob"] = {{
        x = -1204.49,
        y = -891.56,
        z = 14.00,
        label = "Burger Shot"
    }},
    ["burgershotpassJob"] = {{
        x = -1197.68,
        y = -894.33,
        z = 14.00,
        label = "Burger Shot"
    }},
    ["mechanicJob"] = {{
        x = -213.39,
        y = -1326.27,
        z = 23.14,
        label = "Benny's"
    }},
    ["taxiJob"] = {{
        x = 899.02,
        y = -169.27,
        z = 74.17,
        label = "Taxi"
    }},
    ["plsJob"] = {{
        x = 564.87,
        y = 2785.44,
        z = 42.11,
        label = "Ron"
    }},
    ["ambulanceJob"] = {{
        x = 303.7,
        y = -600.71,
        z = 43.28,
        label = "LSMS"
    }},
    ["weazelJob"] = {{
        x = -602.05,
        y = -914.96,
        z = 28.84,
        label = "Weazel News"
    }, {
        x = -562.92,
        y = -934.18,
        z = 33.34,
        label = "Weazel News"
    }},
    ["vigneJob"] = {{
        x = -1879.26,
        y = 2069.73,
        z = 140.01,
        label = "Vignerons"
    }},
    ["brinksJob"] = {{
        x = -14.8,
        y = -693.35,
        z = 46.02,
        label = "UDST"
    }},
    ["policeNorthJob"] = {{
        x = -449.77,
        y = 6010.16,
        z = 31.72,
        label = "LSPD Nord"
    }},
    ["mairieJob"] = {{
        x = -537.74,
        y = -186.39,
        z = 47.42,
        label = "Mairie"
    }},
    [ '3043-A Nowhere Rd'] = {{x = 2163.71, y = 3383.71,z = 41.54}},
    [ '3043-B Nowhere Rd'] = {{x = 2170.13, y = 3327.39,z = 42.22}},
    [ '3043 Smoke Tree Road Blaine County'] = {{x = 2199.4, y = 3314.08,z = 41.47}},
    [ '3042 Nowhere Rd'] = {{x = 2182.77, y = 3494.39,z = 41.25}},
    [ '3049-A Smoke Tree Road'] = {{x = 2391.5, y = 3314.23,z = 43.87}},
    [ '3049-B Smoke Tree Road'] = {{x = 2386.5, y = 3343.27,z = 41.27}},
    [ '3049-C Smoke Tree Road'] = {{x = 2479.78, y = 3443.69,z = 45.03}},
    [ '3049 East Joshua Road'] = {{x = 2484.0, y = 3718.16,z = 39.37}},
    [ '3045 Panorama Drive'] = {{x = 1981.08, y = 3022.84,z = 42.89}},
    [ '3057-A Seniora Freeway'] = {{x = 2359.16, y = 2613.18,z = 41.82}},
    [ '3057-B Seniora Freeway'] = {{x = 2339.93, y = 2608.03,z = 41.63}},
    [ '3057-C Seniora Freeway'] = {{x = 2332.92, y = 2592.94,z = 42.51}},
    [ '3057-D Seniora Freeway'] = {{x = 2333.8, y = 2570.56,z = 40.53}},
    [ '3057-E Seniora Freeway'] = {{x = 2357.57, y = 2560.85,z = 42.11}},
    [ '3057-F Seniora Freeway'] = {{x = 2356.18, y = 2544.38,z = 42.09}},
    [ '3057-G Seniora Freeway'] = {{x = 2348.41, y = 2521.85,z = 41.5}},
    [ '3057-H Seniora Freeway'] = {{x = 2329.03, y = 2525.17,z = 42.79}},
    [ '3057-I Seniora Freeway'] = {{x = 2316.46, y = 2535.31,z = 41.24}},
    [ '3057-J Seniora Freeway'] = {{x = 2317.21, y = 2557.79,z = 42.21}},
    [ '3034-A Calafia Road'] = {{x = 96.93, y = 3651.07,z = 35.87}},
    [ '3034-B Calafia Road'] = {{x = 98.74, y = 3678.08,z = 35.97}},
    [ '3034-D Calafia Road'] = {{x = 72.28, y = 3755.26,z = 35.51}},
    [ '3033-A Calafia Road'] = {{x = 13.4, y = 3691.08,z = 35.74}},
    [ '3034-E Calafia Road'] = {{x = 72.22, y = 3692.04,z = 35.09}},
    [ '3033-B Calafia Road'] = {{x = 88.8, y = 3717.33,z = 34.79}},
    [ '3033-C Calafia Road'] = {{x = 75.61, y = 3729.78,z = 35.64}},
    [ '4013-A Joshua Road'] = {{x = 364.39, y = 2980.46,z = 36.14}},
    [ '4013-B Joshua Road'] = {{x = 415.97, y = 2963.22,z = 36.73}},
    [ '4013-C Joshua Road'] = {{x = 432.01, y = 2989.05,z = 34.3}},
    [ '4013-D Joshua Road'] = {{x = 525.24, y = 3083.19,z = 34.94}},
    [ '4013-E Joshua Road'] = {{x = 512.1, y = 3096.89,z = 35.46}},
    [ '4022-A Route 68'] = {{x = 865.02, y = 2882.11,z = 52.15}},
    [ '4022-B Route 68'] = {{x = 854.39, y = 2860.99,z = 51.49}},
    [ '4022-C Route 68'] = {{x = 894.35, y = 2852.48,z = 51.64}},
    [ '4024-A Route 68'] = {{x = 1588.77, y = 2910.53,z = 51.47}},
    [ '3037 Panorama Drive'] = {{x = 1760.65, y = 3303.4,z = 35.53}},
    [ '1001 Great Ocean Highway'] = {{x = 1540.75, y = 6317.92,z = 18.58}},
    [ '4019 Route 68'] = {{x = 568.21, y = 2600.07,z = 37.71}},
    [ '4016-A Seniora Road'] = {{x = 407.61, y = 2585.91,z = 38.89}},
    [ '4016-B Seniora Road'] = {{x = 386.25, y = 2578.51,z = 38.59}},
    [ '4016-C Seniora Road'] = {{x = 369.56, y = 2573.69,z = 39.0}},
    [ '4016-D Seniora Road'] = {{x = 351.4, y = 2567.89,z = 38.67}},
    [ '3034-C Calafia Road'] = {{x = 108.42, y = 3732.24,z = 35.58}},
    [ '3303-D Calafia Road'] = {{x = 52.52, y = 3746.56,z = 34.87}},
    [ '3303-E Calafia Road'] = {{x = 34.49, y = 3738.28,z = 35.61}},
    --[ 'Zancudo Trail Beach'] = {{x = , y = ,z = }},
    [ 'Dell Perro Heights, Apt 4'] = {{x = -1473.19, y = -536.38,z = 73.44}},
    [ 'Dell Perro Heights, Apt 7'] = {{x = -1457.87, y = -536.65,z = 55.53}},
    [ 'Eclipse Towers, Apt 3'] = {{x = -769.63, y = 338.26,z = 211.4}},
    [ 'Eclipse Towers, Apt 2'] = {{x = -782.04, y = 328.44,z = 187.31}},
    [ 'Eclipse Towers, Apt 1'] = {{x = -779.01, y = 329.32,z = 196.09}},
    [ '2862 Hillcrest Avenue'] = {{x = -677.97, y = 593.05,z = 145.38}},
    [ '2868 Hillcrest Avenue'] = {{x = -759.35, y = 614.89,z = 144.14}},
    [ '2874 Hillcrest Avenue'] = {{x = -857.26, y = 688.5,z = 152.85}},
    [ '4 Integrity Way, Apt 28'] = {{x = -11.78, y = -586.74,z = 79.43}},
    [ '4 Integrity Way, Apt 30'] = {{x = -31.92, y = -591.09,z = 88.71}},
    [ '8051 Strawberry Avenue'] = {{x = 265.79, y = -997.66,z = -99.01}},
    [ '2133 Mad Wayne Thunder'] = {{x = -1287.33, y = 446.77,z = 97.89}},
    [ '8048 Atlee Street'] = {{x = 344.01, y = -1001.28,z = -99.2}},
    [ '2044 North Conker Avenue'] = {{x = 341.55, y = 433.51,z = 149.38}},
    [ '2045 North Conker Avenue'] = {{x = 375.3, y = 420.24,z = 145.9}},
    [ 'Richard Majestic, Apt 2'] = {{x = -919.77, y = -385.16,z = 113.67}},
    [ 'Tinsel Towers, Apt 42'] = {{x = -618.54, y = 44.34,z = 97.6}},
    [ '2677 Whispymound Drive'] = {{x = 119.89, y = 557.26,z = 184.3}},
    [ '3655 Wild Oats Drive'] = {{x = -170.31, y = 496.09,z = 137.65}},
    [ '7342-A Mirror Park'] = {{x = 1306.83, y = -522.94,z = 71.47}},
    [ '7342-B Mirror Park'] = {{x = 1352.26, y = -542.54,z = 73.89}},
    [ '7342-C Mirror Park'] = {{x = 1389.41, y = -598.27,z = 74.49}},
    [ '7341-A Mirror Park'] = {{x = 1365.36, y = -612.0,z = 74.75}},
    [ '7341-B Mirror Park'] = {{x = 1319.4, y = -587.2,z = 73.25}},
    [ '7341-C Mirror Park'] = {{x = 1297.52, y = -578.89,z = 71.74}},
    [ '7340-A Mirror Park'] = {{x = 1394.74, y = -569.11,z = 74.51}},
    [ '7340-B Mirror Park'] = {{x = 919.1, y = -563.92,z = 58.37}},
    [ '7339 Mirror Drive'] = {{x = 954.23, y = -670.87,z = 58.46}},
    [ '7340 Mirror Drive'] = {{x = 905.83, y = -483.66,z = 59.44}},
    [ '1201 Normandy Drive'] = {{x = -762.17, y = 804.17,z = 215.19}},
    [ '2117 Normandy Drive'] = {{x = -570.23, y = 658.55,z = 145.83}},
    [ 'Eclipse Towers, Apt 4'] = {{x = -769.1, y = 330.43,z = 175.4}},
    [ 'Eclipse Towers, Apt 5'] = {{x = -779.1, y = 329.29,z = 196.09}},
    [ 'Eclipse Towers, Apt 6'] = {{x = -769.28, y = 330.4,z = 221.86}},
    [ 'Tinsel Towers, Apt 44'] = {{x = -609.16, y = 51.76,z = 106.62}},
    [ '4 Integrity Way, Apt 32'] = {{x = -25.12, y = -593.91,z = 98.83}},
    [ '3 Alta St., Apt. 57'] = {{x = -273.0, y = -953.89,z = 75.83}},
    [ '3 Alta St., Apt. 60'] = {{x = -270.27, y = -954.51,z = 91.11}},
    [ 'Weazel Plaza, Apt. 101'] = {{x = -898.46, y = -443.86,z = 125.13}},
    [ 'Weazel Plaza, Apt. 70'] = {{x = -900.28, y = -443.49,z = 94.06}},
    [ 'Richard Majestic, Apt 4'] = {{x = -916.45, y = -382.22,z = 108.04}},
    [ 'Richard Majestic, Apt 6'] = {{x = -913.61, y = -368.85,z = 84.08}},
    [ '7339 Bridge Street'] = {{x = 1106.34, y = -413.75,z = 67.56}},
    [ 'Eclipse Towers, Apt 8'] = {{x = -786.88, y = 326.76,z = 206.22}},
    [ 'Eclipse Towers, Apt 10'] = {{x = -787.31, y = 327.18,z = 158.6}},
}
