ESX = nil
local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local vehicle2 = {}
local nocarmodifier = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer

    ESX.TriggerServerCallback('esx_lscustom:getVehiclesPrices', function(vehicles)
        Vehicles = vehicles
    end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local props = {}

local lscustommenu = false
RMenu.Add('lscustom', 'main', RageUI.CreateMenu("Menu Lscustom", "Des modifications à faire ?"))
RMenu.Add('lscustom', 'exterieur',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'), "Extérieur", "Voir les modification extérieur"))
RMenu.Add('lscustom', 'interieur',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'), "Intérieur", "Voir les modification intérieur"))
RMenu.Add('lscustom', "amelioration", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'), "Amélioration moteur",
    "Modification des Amélioration moteur"))
RMenu.Add('lscustom', 'facture',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'), "Obtenir le devis", "Obtenir le devis"))
RMenu.Add('lscustom', 'achat', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'facture'), "Valider les modification",
    "Valider les modification"))
RMenu.Add('lscustom', 'annuler', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'facture'), "Annuler les modification",
    "Annuler les modification"))

RMenu.Add('lscustom', "ornement",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Ornement", "Modification de l'Ornement"))
RMenu.Add('lscustom', "board", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Tableau de bord",
    "Modification du Tableau de bord"))
RMenu.Add('lscustom', "dial", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Compteur de vitesse",
    "Modification du Compteur de vitesse"))
RMenu.Add('lscustom', "trima",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Tableau de bord", "Modification de la TrimA"))
RMenu.Add('lscustom', "siege",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Siège", "Modification des Sièges"))
RMenu.Add('lscustom', "volant",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Volant", "Modification du Volant"))
RMenu.Add('lscustom', "shifter",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Levier de vitesse", "Modification de la Shifter"))
RMenu.Add('lscustom', "plaque1",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Plage arrière", "Modification de la Plaque"))
RMenu.Add('lscustom', "enceinte",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Enceinte", "Modification des Enceintes"))
RMenu.Add('lscustom', "trunk",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Coffre", "Modification de la Tronc"))
RMenu.Add('lscustom', "hydrolic",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Hydrolique", "Modification de l'Hydrolique"))
RMenu.Add('lscustom', "EngineBlock",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Bloc moteur", "Modification de la TrimA"))
RMenu.Add('lscustom', "AirFilter",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Filtre à air", "Modification du Filtre à air"))
RMenu.Add('lscustom', "klaxon",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Klaxon", "Modification le klaxon"))
    RMenu.Add('lscustom', "doorspeaker", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'interieur'), "Enceinte portière",
    "Modification des Enceinte portière"))

RMenu.Add('lscustom', 'jante',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Jante", "Modification des jante"))
RMenu.Add('lscustom', 'roue_arriere',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Roue arrière", "Modification des roues arrière"))
RMenu.Add('lscustom', 'spoiler',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Spoiler", "Modification du spoiler"))
RMenu.Add('lscustom', 'pare-chocs', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Pare-chocs avant",
    "Modification du pare-chocs avant"))
RMenu.Add('lscustom', 'pare-chocs_a', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Pare-chocs arrière",
    "Modification du pare-chocs arrière"))
RMenu.Add('lscustom', 'jupe', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Jupe latérale",
    "Modification de la jupe latérale"))
RMenu.Add('lscustom', 'pot', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Pot d'échappement",
    "Modification du pot d'échappement"))
RMenu.Add('lscustom', 'cadre',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Cadre", "Modification du cadre"))
RMenu.Add('lscustom', 'calandre',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Calandre", "Modification de la calandre"))
RMenu.Add('lscustom', 'hotte',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Aération capot", "Modification de la hotte"))
RMenu.Add('lscustom', 'garde-boue',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Garde-boue", "Modification des garde-boue"))
RMenu.Add('lscustom', 'AileD',
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Aile", "Modification des ailes"))
RMenu.Add('lscustom', 'toit', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Toit", "Modification du toit"))
RMenu.Add('lscustom', "plaque", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Ornement de plaque arrière",
    "Modification de la plaque"))
RMenu.Add('lscustom', "vanity",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Plaque avant", "Modification de la Plaque"))
RMenu.Add('lscustom', "Struts",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Entretoises", "Modification des Entretoises"))
RMenu.Add('lscustom', "ArchCover",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Garde boue", "Modification des Gardes boue"))
RMenu.Add('lscustom', "Aerials",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Antennes", "Modification de l'Antennes'"))
RMenu.Add('lscustom', "TrimB",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Vitre arrière", "Modification de la Vitre arrière"))
RMenu.Add('lscustom', "Tank", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Bouchon de réservoir",
    "Modification du Bouchon de réservoir"))
RMenu.Add('lscustom', "Windows",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Fenêtre", "Modification des Fenêtre"))
RMenu.Add('lscustom', "Windowstin",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Fenêtre2", "Modification des Fenêtre"))
RMenu.Add('lscustom', "phare",
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Phare couleur", "Modification des phares"))
RMenu.Add('lscustom', "neon", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'exterieur'), "Couleur des néons",
    "Modification de la Couleur des néons"))

RMenu.Add('lscustom', Config.wheelType[1].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[1].label, Config.wheelType[1].label))
RMenu.Add('lscustom', Config.wheelType[2].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[2].label, Config.wheelType[2].label))
RMenu.Add('lscustom', Config.wheelType[3].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[3].label, Config.wheelType[3].label))
RMenu.Add('lscustom', Config.wheelType[4].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[4].label, Config.wheelType[4].label))
RMenu.Add('lscustom', Config.wheelType[5].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[5].label, Config.wheelType[5].label))
RMenu.Add('lscustom', Config.wheelType[6].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[6].label, Config.wheelType[6].label))
RMenu.Add('lscustom', Config.wheelType[7].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[7].label, Config.wheelType[7].label))
RMenu.Add('lscustom', Config.wheelType[8].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[8].label, Config.wheelType[8].label))
RMenu.Add('lscustom', Config.wheelType[9].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[9].label, Config.wheelType[9].label))
RMenu.Add('lscustom', Config.wheelType[10].label,
    RageUI.CreateSubMenu(RMenu:Get('lscustom', 'jante'), Config.wheelType[10].label, Config.wheelType[10].label))

-- RMenu.Add('lscustom', 'categorievehicule', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'listevehicule'), "Véhicules", "Pour acheter un véhicule"))klaxon
-- RMenu.Add('lscustom', 'achatvehicule', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'categorievehicule'), "Véhicules", "Pour acheter un véhicule"))
-- RMenu.Add('lscustom', 'annonces', RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'), "Annonces", "Annonces de la ville"))
RMenu:Get('lscustom', 'main').Closed = function()
    lscustommenu = false
end
RMenu:Get('lscustom', 'main').Closed = function()
end

local price = {}

function ouvrirLsCustom()
    if not lscustommenu then
        lscustommenu = true
        RageUI.Visible(RMenu:Get('lscustom', 'main'), true)
        while lscustommenu do
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local props = {}

            RageUI.IsVisible(RMenu:Get('lscustom', 'main'), true, true, true, function()
                touche()
                SetVehicleEngineOn(vehicle1, false, false, true)
                RageUI.Button("Extérieur", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', 'exterieur'))
                RageUI.Button("Intérieur", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', 'interieur'))
                RageUI.Button("Obtenir le devis", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', 'facture'))
            end, function()
            end)
            RageUI.IsVisible(RMenu:Get('lscustom', 'facture'), true, true, true, function()
                RageUI.Button("Valider les modification", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', 'achat'))
                RageUI.Button("Annuler les modification", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', 'annuler'))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'exterieur'), true, true, true, function()
                local jante = GetNumVehicleMods(vehicle, 23)
                RageUI.Button("Jante", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', 'jante'))
                local roue_arriere = GetNumVehicleMods(vehicle, 24)
                if roue_arriere ~= 0 then
                    RageUI.Button("Roue arrière", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'roue_arriere'))
                end
                if not nocarmodifier then
                local spoiler = GetNumVehicleMods(vehicle, 0)
                if spoiler ~= 0 then
                    RageUI.Button("Spoiler", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'spoiler'))
                end
                local pare_chocs = GetNumVehicleMods(vehicle, 1)
                if pare_chocs ~= 0 then
                    RageUI.Button("Pare-chocs avant", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'pare-chocs'))
                end
                local pare_chocs_a = GetNumVehicleMods(vehicle, 2)
                if pare_chocs_a ~= 0 then
                    RageUI.Button("Pare-chocs arrière", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'pare-chocs_a'))
                end
                local jupe = GetNumVehicleMods(vehicle, 3)
                if jupe ~= 0 then
                    RageUI.Button("Jupe latérale", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'jupe'))
                end
                local pot = GetNumVehicleMods(vehicle, 4)
                if pot ~= 0 then
                    RageUI.Button("Pot d'échappement", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'pot'))
                end
                local cadre = GetNumVehicleMods(vehicle, 5)
                if cadre ~= 0 then
                    RageUI.Button("Cadre", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'cadre'))
                end
                local calandre = GetNumVehicleMods(vehicle, 6)
                if calandre ~= 0 then
                    RageUI.Button("Calandre", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'calandre'))
                end
                local hotte = GetNumVehicleMods(vehicle, 7)
                if hotte ~= 0 then
                    RageUI.Button("Aération capot", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'hotte'))
                end
                local garde_boue = GetNumVehicleMods(vehicle, 8)
                if garde_boue ~= 0 then
                    RageUI.Button("Garde-boue", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'garde-boue'))
                end
                local AileD = GetNumVehicleMods(vehicle, 9)
                if AileD ~= 0 then
                    RageUI.Button("Aile", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'AileD'))
                end
                local toit = GetNumVehicleMods(vehicle, 10)
                if toit ~= 0 then
                    RageUI.Button("Toit", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', 'toit'))
                end
                local vanity = GetNumVehicleMods(vehicle, 26)
                if vanity ~= 0 then
                    RageUI.Button("Plaque avant", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "vanity"))
                end
                local trima = GetNumVehicleMods(vehicle, 27)
                if trima ~= 0 then
                    RageUI.Button("Intérieur", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "trima"))
                end
                local board = GetNumVehicleMods(vehicle, 29)
                if board ~= 0 then
                    RageUI.Button("Tableau de bord", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "board"))
                end
                local doorspeaker = GetNumVehicleMods(vehicle, 31)
                if doorspeaker ~= 0 then
                    RageUI.Button("Enceinte portière", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "doorspeaker"))
                end
                local Struts = GetNumVehicleMods(vehicle, 41)
                if Struts ~= 0 then
                    RageUI.Button("Entretoises", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "Struts"))
                end
                local ArchCover = GetNumVehicleMods(vehicle, 42)
                if ArchCover ~= 0 then
                    RageUI.Button("Couverture", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "ArchCover"))
                end
                local Aerials = GetNumVehicleMods(vehicle, 43)
                if Aerials ~= 0 then
                    RageUI.Button("Antennes", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "Aerials"))
                end
                local TrimB = GetNumVehicleMods(vehicle, 44)
                if TrimB ~= 0 then
                    RageUI.Button("Intérieur 2", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "TrimB"))
                end
                local Windows = GetNumVehicleMods(vehicle, 46)
                if Windows ~= 0 then
                    RageUI.Button("Retroviseur", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "Windows"))
                end
                local plaque = GetNumVehicleMods(vehicle, 25)
                if plaque ~= 0 then
                    RageUI.Button("Ornement de plaque arrière", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "plaque"))
                end
                RageUI.Button("Fenêtre", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', "Windowstin"))
                local Tank = GetNumVehicleMods(vehicle, 45)
                if Tank ~= 0 then
                    RageUI.Button("Bouchon de réservoir", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "Tank"))
                end
                end
                RageUI.Button("Phare couleur", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', "phare"))
                RageUI.Button("Couleur des néons", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', "neon"))

                -- RageUI.Button("Nacrage", nil, {RightLabel = "→→→"},true, function()
                -- end, RMenu:Get('lscustom', 'nacre'))klaxonstikers
            end, function()
            end)
            RageUI.IsVisible(RMenu:Get('lscustom', 'interieur'), true, true, true, function()
                if not nocarmodifier then
                local plaque1 = GetNumVehicleMods(vehicle, 35)
                if plaque1 ~= 0 then
                    RageUI.Button("Plage arrière", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "plaque1"))
                end
            end
                local siege = GetNumVehicleMods(vehicle, 32)
                if siege ~= 0 then
                    RageUI.Button("Siège", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "siege"))
                end
                local ornement = GetNumVehicleMods(vehicle, 28)
                if ornement ~= 0 then
                    RageUI.Button("Ornement", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "ornement"))
                end
                local dial = GetNumVehicleMods(vehicle, 30)
                if dial ~= 0 then
                    RageUI.Button("Compteur de vitesse", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "dial"))
                end
                local siege = GetNumVehicleMods(vehicle, 33)
                if siege ~= 0 then
                    RageUI.Button("Volant", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "siege"))
                end
                local shifter = GetNumVehicleMods(vehicle, 34)
                if shifter ~= 0 then
                    RageUI.Button("Levier de vitesse", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "shifter"))
                end
                local enceinte = GetNumVehicleMods(vehicle, 36)
                if enceinte ~= 0 then
                    RageUI.Button("Enceinte", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "enceinte"))
                end
                local trunk = GetNumVehicleMods(vehicle, 37)
                if trunk ~= 0 then
                    RageUI.Button("Coffre", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "trunk"))
                end
                local hydrolic = GetNumVehicleMods(vehicle, 38)
                if hydrolic ~= 0 then
                    RageUI.Button("Hydraulique", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "hydrolic"))
                end
                local EngineBlock = GetNumVehicleMods(vehicle, 39)
                if EngineBlock ~= 0 then
                    RageUI.Button("Bloc moteur", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "EngineBlock"))
                end
                if not nocarmodifier then
                local AirFilter = GetNumVehicleMods(vehicle, 40)
                if AirFilter ~= 0 then
                    RageUI.Button("Filtre à air", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('lscustom', "AirFilter"))
                end
            end
                RageUI.Button("Klaxon", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', "klaxon"))
            end, function()
            end)
            RageUI.IsVisible(RMenu:Get('lscustom', 'jante'), true, true, true, function()
                RageUI.Button(Config.wheelType[1].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[1].label))
                RageUI.Button(Config.wheelType[2].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[2].label))
                RageUI.Button(Config.wheelType[3].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[3].label))
                RageUI.Button(Config.wheelType[4].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[4].label))
                RageUI.Button(Config.wheelType[5].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[5].label))
                RageUI.Button(Config.wheelType[6].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[6].label))
                RageUI.Button(Config.wheelType[7].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[7].label))
                RageUI.Button(Config.wheelType[8].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[8].label))
                RageUI.Button(Config.wheelType[9].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[9].label))
                RageUI.Button(Config.wheelType[10].label, nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('lscustom', Config.wheelType[10].label))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'achat'), true, true, true, function()
                local total = 0
                for k, v in pairs(price) do
                    if price[k].value ~= nil then
                        total = total + price[k].value
                    end
                end
                for k, v in pairs(price) do
                    RageUI.Button(price[k].label .. " ", " Appuyer pour retirer du devis ", {
                        RightLabel = "~g~" .. price[k].value .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            table.remove(price, k)
                            total = total - v.value
                        end
                    end)
                end
                RageUI.Button("Acheter les améliorations", nil, {
                    RightLabel = "~g~" .. total .. "$"
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ESX.ShowNotification("Vous avez achetez les améliorations")
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        upgrade(vehicle, props)
                        local carModif = ESX.Game.GetVehicleProperties(vehicle)
                        TriggerServerEvent('lscustom:achatVehicule', carModif)
                        TriggerServerEvent('esx_lscustom:buyMod', total / 4)

                        myCar = ESX.Game.GetVehicleProperties(vehicle)
                    end
                end)
            end, function()
            end)
            RageUI.IsVisible(RMenu:Get('lscustom', 'annuler'), true, true, true, function()
                RageUI.Button("Réinstaller les modifications de base", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ESX.ShowNotification("Les modifications ont été remise de base")
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        upgrade(vehicle, myCar)
                    end
                end)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'toit'), true, true, true, function()
                mod(10, "Toit", "modRoof", vehicle, Config.toit, myCar.modRoof)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[1].label), true, true, true, function()
                jante(1, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[2].label), true, true, true, function()
                jante(2, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[3].label), true, true, true, function()
                jante(3, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[4].label), true, true, true, function()
                jante(4, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[5].label), true, true, true, function()
                jante(5, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[6].label), true, true, true, function()
                jante(6, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[7].label), true, true, true, function()
                jante(7, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[8].label), true, true, true, function()
                jante(8, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[9].label), true, true, true, function()
                jante(9, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', Config.wheelType[10].label), true, true, true, function()
                jante(10, vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'roue_arriere'), true, true, true, function()
                mod(24, "roue arriere", "modBackWheels", vehicle, Config.rouearriere, myCar.modBackWheels)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'spoiler'), true, true, true, function()
                mod(0, "spoiler", "modSpoilers", vehicle, Config.spoiler, myCar.modSpoilers)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'pare-chocs'), true, true, true, function()
                mod(1, "pare-chocs avant", "modFrontBumper", vehicle, Config.parechocsavant, myCar.modFrontBumper)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'pare-chocs_a'), true, true, true, function()
                mod(2, "pare chocs arrière", "modRearBumper", vehicle, Config.parechocsarriere, myCar.modRearBumper)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'jupe'), true, true, true, function()
                mod(3, "jupe", "modSideSkirt", vehicle, Config.jupe, myCar.modSideSkirt)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'pot'), true, true, true, function()
                mod(4, "pot", "modExhaust", vehicle, Config.pot, myCar.modExhaust)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'cadre'), true, true, true, function()
                mod(5, "cadre", "modFrame", vehicle, Config.cadre, myCar.modFrame)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'calandre'), true, true, true, function()
                mod(6, "calandre", "modGrille", vehicle, Config.calandre, myCar.modGrille)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'hotte'), true, true, true, function()
                mod(7, "hotte", "modHood", vehicle, Config.hotte, myCar.modHood)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'garde-boue'), true, true, true, function()
                mod(8, "garde-boue", "modFender", vehicle, Config.gardeboue, myCar.modFender)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'AileD'), true, true, true, function()
                mod(9, "Aile", "modRightFender", vehicle, Config.Aile, myCar.modRightFender)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'plaque'), true, true, true, function()
                mod(25, "Ornement de plaque arrière", "modPlateHolder", vehicle, Config.ornementarriere,
                    myCar.modPlateHolder)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'vanity'), true, true, true, function()
                mod(26, "Plaque avant", "modVanityPlate", vehicle, Config.Plaqueavant, myCar.modVanityPlate)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'trima'), true, true, true, function()
                mod(27, "Intérieur", "modTrimA", vehicle, Config.interieur, myCar.modTrimA)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'ornement'), true, true, true, function()
                mod(28, "Ornement", "modOrnaments", vehicle, Config.Ornement, myCar.modOrnaments)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'board'), true, true, true, function()
                mod(29, "Tableau de bord", "modDashboard", vehicle, Config.Tableaudebord, myCar.modDashboard)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'dial'), true, true, true, function()
                mod(30, "Compteur de vitesse", "modDial", vehicle, Config.Compteur, myCar.modDial)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'doorspeaker'), true, true, true, function()
                mod(31, "Enceinte portière", "modDoorSpeaker", vehicle, Config.Enceinteportiere, myCar.modDoorSpeaker)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'siege'), true, true, true, function()
                mod(32, "Siège", "modSeats", vehicle, Config.Siege, myCar.modSeats)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'volant'), true, true, true, function()
                mod(33, "Volant", "modSeats", vehicle, Config.Volant, myCar.modSeats)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'shifter'), true, true, true, function()
                mod(34, "Levier de vitesse", "modShifterLeavers", vehicle, Config.Levier, myCar.modShifterLeavers)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'plaque1'), true, true, true, function()
                mod(35, "Plage arrière", "modAPlate", vehicle, Config.Plagearriere, myCar.modAPlate)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'enceinte'), true, true, true, function()
                mod(36, "Enceinte", "modSpeakers", vehicle, Config.Enceinte, myCar.modSpeakers)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'trunk'), true, true, true, function()
                mod(37, "Coffre", "modTrunk", vehicle, Config.Coffre, myCar.modTrunk)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'hydrolic'), true, true, true, function()
                mod(38, "Hydrolique", "modHydrolic", vehicle, Config.Hydrolique, myCar.modHydrolic)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'EngineBlock'), true, true, true, function()
                mod(39, "Bloc moteur", "modEngineBlock", vehicle, Config.Blocmoteur, myCar.modEngineBlock)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'AirFilter'), true, true, true, function()
                mod(40, "Filtre à air", "modAirFilter", vehicle, Config.Filtre, myCar.modAirFilter)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'Struts'), true, true, true, function()
                mod(41, "Entretoises", "modStruts", vehicle, Config.Entretoises, myCar.modStruts)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'ArchCover'), true, true, true, function()
                mod(42, "Couverture", "modArchCover", vehicle, Config.Couverture, myCar.modArchCover)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'Aerials'), true, true, true, function()
                mod(43, "Antennes", "modAerials", vehicle, Config.Antennes, myCar.modAerials)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'TrimB'), true, true, true, function()
                mod(44, "Intérieur 2", "modTrimB", vehicle, Config.Interieurb, myCar.modTrimB)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'Tank'), true, true, true, function()
                mod(45, "Bouchon de réservoir", "modTank", vehicle, Config.Bouchon, myCar.modTank)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'Windows'), true, true, true, function()
                mod(46, "Fenêtre", "modWindows", vehicle, Config.Fenetre, myCar.modWindows)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'Windowstin'), true, true, true, function()
                for i = 1, #Config.WindowTints, 1 do
                    RageUI.Button(Config.WindowTints[i].name, nil, {
                        RightLabel = "~g~" .. Config.Fenetrecouleur .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            if myCar.modWindows == i then
                            else
                                SetVehicleWindowTint(vehicle, i)
                            end
                        end
                        if (Selected) then
                            props = {
                                windowTint = i
                            }
                            upgrade(vehicle, props)
                            for k, v in pairs(price) do
                                if v.label == "Fenêtre couleur" then
                                    found = true
                                end
                            end
                            if not found then
                                table.insert(price, {
                                    label = "Fenêtre couleur",
                                    value = Config.Fenetrecouleur
                                })
                            end
                        end
                    end)
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'phare'), true, true, true, function()
                for i = 1, #Config.headlights, 1 do
                    RageUI.Button(Config.headlights[i].name, nil, {
                        RightLabel = "~g~" .. Config.phare .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            SetVehicleEngineOn(vehicle, true, false, true)
                            ToggleVehicleMod(vehicle, 22, true)
                            SetVehicleXenonLightsColor(vehicle, i)
                        end
                        if (Selected) then
                            props = {
                                modXenon = true,
                                headlights = i
                            }
                            upgrade(vehicle, props)
                            for k, v in pairs(price) do
                                if v.label == "Couleur des phares" then
                                    found = true
                                end
                            end
                            if not found then
                                table.insert(price, {
                                    label = "Couleur des phares",
                                    value = Config.phare
                                })
                            end
                        end
                    end)
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'neon'), true, true, true, function()
                for i = 1, #Config.neons, 1 do
                    RageUI.Button(Config.neons[i].label, nil, {
                        RightLabel = "~g~" .. Config.neon .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            SetVehicleEngineOn(vehicle, true, false, true)
                            SetVehicleNeonLightsColour(vehicle, Config.neons[i].r, Config.neons[i].g, Config.neons[i].b)
                            SetVehicleNeonLightEnabled(vehicle, 0, true)
                            SetVehicleNeonLightEnabled(vehicle, 1, true)
                            SetVehicleNeonLightEnabled(vehicle, 2, true)
                            SetVehicleNeonLightEnabled(vehicle, 3, true)
                        end
                        if (Selected) then
                            props = {
                                neonColor = {Config.neons[i].r, Config.neons[i].g, Config.neons[i].b},
                                neonEnabled = {true, true, true, true}
                            }
                            upgrade(vehicle, props)
                            for k, v in pairs(price) do
                                if v.label == "Couleur des néons" then
                                    found = true
                                end
                            end
                            if not found then
                                table.insert(price, {
                                    label = "Couleur des néons",
                                    value = Config.neon
                                })
                            end
                        end
                    end)
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustom', 'klaxon'), true, true, true, function()
                for i = 1, #Config.horn, 1 do
                    RageUI.Button(Config.horn[i].name, nil, {
                        RightLabel = "~g~" .. Config.klaxon .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Active) then
                            SetVehicleMod(vehicle, 14, i - 1, false)
                        end
                        if (Selected) then
                            props = {
                                modHorns = i
                            }
                            upgrade(vehicle, props)
                            for k, v in pairs(price) do
                                if v.label == "Klaxon" then
                                    found = true
                                end
                            end
                            if not found then
                                table.insert(price, {
                                    label = "Klaxon",
                                    value = Config.klaxon
                                })
                            end
                        end
                    end)
                end
            end, function()
            end)
            Citizen.Wait(0)
        end
    else
        lscustommenu = false
    end
end

function mod(mod, name, modnameesx, vehicle, prix, modesx)
    local modCount = GetNumVehicleMods(vehicle, mod)
    for j = 0, modCount, 1 do
        local modName = GetModTextLabel(vehicle, mod, j)
        local label = GetLabelText(modName)
        if label == "NULL" then
            label = "Aucun"
        end
        RageUI.Button(label, nil, {
            RightLabel = "~g~" .. prix .. "$"
        }, true, function(Hovered, Active, Selected)
            if (Active) then
                if modesx == j then
                else
                    SetVehicleMod(vehicle, mod, j, false)
                    if (Selected) then
                        props = {
                            modnameesx = j
                        }
                        upgrade(vehicle, props)
                        for k, v in pairs(price) do
                            if v.label == name then
                                found = true
                            end
                        end
                        if not found then
                            table.insert(price, {
                                label = name,
                                value = prix
                            })
                        end
                    end
                end
            end
        end)
    end
end

function jante(k, vehicle)
    local modCount = GetNumVehicleMods(vehicle, 23)
    for j = 0, modCount, 1 do
        local modName = GetModTextLabel(vehicle, 23, j)
        local label = GetLabelText(modName)
        if label == "NULL" then
            label = "Aucun"
        end
        RageUI.Button(label, nil, {
            RightLabel = "~g~" .. Config.jante .. "$"
        }, true, function(Hovered, Active, Selected)
            if (Active) then
                if myCar.modFrontWheels == j then
                else
                    SetVehicleWheelType(vehicle, Config.wheelType[k].index)
                    SetVehicleMod(vehicle, 23, j, false)
                end
            end
            if (Selected) then
                props = {
                    wheels = Config.wheelType[k].index,
                    modFrontWheels = j
                }
                upgrade(vehicle, props)
                for k, v in pairs(price) do
                    if v.label == "jante" then
                        found = true
                    end
                end
                if not found then
                    table.insert(price, {
                        label = "jante",
                        value = Config.jante
                    })
                end
            end
        end)
    end
end

function upgrade(vehicle, props)
    ESX.Game.SetVehicleProperties(vehicle, props)
end

Config.emplacement = {{
    x = -236.95,
    y = -1337.61,
    z = 30.9
}}

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) and (PlayerData.job and PlayerData.job.name == 'mechanic') then
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            for k in pairs(Config.emplacement) do
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.emplacement[k].x,
                    Config.emplacement[k].y, Config.emplacement[k].z)
                DrawMarker(1, Config.emplacement[k].x, Config.emplacement[k].y, Config.emplacement[k].z - 1, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 0.25, 25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)
                if dist <= 4 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Style véhicule")
                    attente = 1
                    if IsControlJustReleased(0, 38) then
                        local vehicle1 = GetVehiclePedIsIn(playerPed, false)
                        FreezeEntityPosition(vehicle, true)
                        SetVehicleModKit(vehicle1, 0)
                        SetVehicleEngineOn(vehicle1, false, false, true)
                        myCar = ESX.Game.GetVehicleProperties(vehicle1)
                        price = {}
                        lsMenuIsShowed = true
                        isVehicle = GetMakeNameFromVehicleModel(myCar.model)
                        if isVehicle == "WESTERN" or isVehicle == "BRAVADO" or isVehicle == "DECLASSE" then
                            nocarmodifier = true
                        end
                        ouvrirLsCustom()
                    end
                end
            end
        end
    end
end)

function touche()
    if IsControlJustPressed(0, 194) then
        lsMenuIsShowed = false
        lscustommenu = false
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        FreezeEntityPosition(vehicle, false)
        SetVehicleEngineOn(vehicle, true, false, true)
        ESX.Game.SetVehicleProperties(vehicle, myCar)

    end
    if IsControlJustPressed(0, 177) then
        lsMenuIsShowed = false
        lscustommenu = false
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        FreezeEntityPosition(vehicle, false)
        SetVehicleEngineOn(vehicle, true, false, true)
        ESX.Game.SetVehicleProperties(vehicle, myCar)
    end
end

-- Prevent Free Tunning Bug
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if lsMenuIsShowed then
            DisableControlAction(2, 288, true)
            DisableControlAction(2, 289, true)
            DisableControlAction(2, 170, true)
            DisableControlAction(2, 167, true)
            DisableControlAction(2, 168, true)
            DisableControlAction(2, 23, true)
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
            if IsPauseMenuActive() then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                FreezeEntityPosition(vehicle, false)
                SetVehicleEngineOn(vehicle, true, false, true)
                ESX.Game.SetVehicleProperties(vehicle, myCar)
                lsMenuIsShowed = false
                lscustommenu = false
            end
        else
            Citizen.Wait(500)
        end
    end
end)
