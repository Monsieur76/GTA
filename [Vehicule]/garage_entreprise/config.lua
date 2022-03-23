garagepublic = {}

garagepublic.DrawDistance = 100
garagepublic.Size = {
    x = 3.0,
    y = 3.0,
    z = 1.5
}
garagepublic.Color = {
    r = 25,
    g = 95,
    b = 255
} -- vert pour les voiture a sortir
garagepublic.Color2 = {
    r = 25,
    g = 95,
    b = 255
} -- rouge pour les voiture a ranger
garagepublic.Type = 1

-- 9 garage public --
-- 1 sortie du vehicle --
-- 0 fourrière --
garagepublic.zone = {

    police = {
        sortie = {
            x = 460.15,
            y = -984.55,
            z = 24.73
        },
        spawn = {
            x = 447.29,
            y = -979.26,
            z = 24.73,
            h = 173.6211
        },
        name = {"police"},
        metier = {"police"}
    },
    policeHeli = {
        sortie = {
            x = 448.69,
            y = -981.65,
            z = 42.69
        },
        spawn = {
            x = 448.69,
            y = -981.65,
            z = 43.69,
            h = 87.916
        },
        name = {"police_heli"},
        metier = {"police"}
    },
    policeNorth = {
        sortie = {
            x = -454.53,
            y = 6001.87,
            z = 30.34
        },
        spawn = {
            x = -454.53,
            y = 6001.87,
            z = 31.34,
            h = 173.6211
        },
        name = {"policeNorth"},
        metier = {"policeNorth"}
    },
    policeNorthHeli = {
        sortie = {
            x = -475.63,
            y = 5988.15,
            z = 30.34
        },
        spawn = {
            x = -475.63,
            y = 5988.15,
            z = 31.34,
            h = 87.916
        },
        name = {"policeNorth_heli"},
        metier = {"policeNorth"}
    },
    policeBus = {
        sortie = {
            x = 463.22,
            y = -1019.71,
            z = 27.11
        },
        spawn = {
            x = 459.18,
            y = -1019.71,
            z = 27.46,
            h = 90.254165
        },
        name = {"police_Bus"},
        metier = {"police"}
    },
    ambulance = {
        sortie = {
            x = 336.84,
            y = -581.33,
            z = 27.8
        },
        spawn = {
            x = 333.72,
            y = -575.51,
            z = 27.8,
            h = 336.56
        },
        name = {"ambulance"},
        metier = {"ambulance"}
    },
    ambulanceHeli = {
        sortie = {
            x = 351.93,
            y = -588.09,
            z = 73.16
        },
        spawn = {
            x = 351.93,
            y = -588.09,
            z = 73.16,
            h = 21.9277
        },
        name = {"ambulance_heli"},
        metier = {"ambulance"}
    },
    weazel = {
        sortie = {
            x = -533.04,
            y = -881.1,
            z = 24.35
        },
        spawn = {
            x = -533.28,
            y = -880.98,
            z = 25.35,
            h = 181.82
        },
        name = {"weazel"},
        metier = {"weazel"}
    },
    journalisteHeli = {
        sortie = {
            x = -583.51,
            y = -930.65,
            z = 35.83
        },
        spawn = {
            x = -583.51,
            y = -930.65,
            z = 35.83,
            h = 175.32
        },
        name = {"weazel_heli"},
        metier = {"weazel"}
    },
    taxi = {
        sortie = {
            x = 892.1,
            y = -159.95,
            z = 75.9
        },
        spawn = {
            x = 892.1,
            y = -159.95,
            z = 76.9,
            h = 324.23
        },
        name = {"taxi"},
        metier = {"taxi"}
    },
    pls = {
        sortie = {
            x = 603.14,
            y = 2792.18,
            z = 41.18
        },
        spawn = {
            x = 587.65,
            y = 2795.22,
            z = 41.07,
            h = 346.8000
        },
        name = {"pls"},
        metier = {"pls"}
    },
    mechanic = {
        sortie = {
            x = -182.37,
            y = -1334.87,
            z = 30.3
        },
        spawn = {
            x = -182.37,
            y = -1334.87,
            z = 31.3,
            h = 0.2758
        },
        name = {"mechanic"},
        metier = {"mechanic"}
    },
    brinks = {
        sortie = {
            x = -4.23,
            y = -711.04,
            z = 31.34
        },
        spawn = {
            x = 0.57,
            y = -698.27,
            z = 31.34,
            h = 340.4645
        },
        name = {"brinks"},
        metier = {"brinks"}
    },
    vignerons = {
        sortie = {
            x = -1921.2,
            y = 2048.87,
            z = 139.73
        },
        spawn = {
            x = -1921.2,
            y = 2048.87,
            z = 139.73,
            h = 253.2949
        },
        name = {"vigne"},
        metier = {"vigne"}
    },
    burgershot = {
        sortie = {
            x = -1166.17,
            y = -887.77,
            z = 13.12
        },
        spawn = {
            x = -1166.17,
            y = -887.77,
            z = 14.12,
            h = 120.7239
        },
        name = {"burgershot"},
        metier = {"burgershot"}
    },
    mairie = {
        sortie = {
            x = -586.59,
            y = -187.99,
            z = 36.92
        },
        spawn = {
            x = -586.59,
            y = -187.99,
            z = 36.92,
            h = 28.8591
        },
        name = {"mairie"},
        metier = {"mairie"}
    },
    fbi = {
        sortie = {
            x = 92.95,
            y = -729.72,
            z = 32.13
        },
        spawn = {
            x = 96.46,
            y = -728.16,
            z = 32.13,
            h = 333.9375
        },
        name = {"fbi"},
        metier = {"fbi"}
    },
    scarlett = {
        sortie = {
            x = -1527.68,
            y = 82.16,
            z = 55.62
        },
        spawn = {
            x = -1527.68,
            y = 82.16,
            z = 55.62,
            h = 304.32
        },
        name = {"Scarlett"},
        metier = {"scarlett"}
    },

}
