ESX = nil
local PlayerData = {}

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

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local societyconcessmoney = nil

local h4ci_conc = {
    catevehi = {},
    listecatevehi = {}
}

local listeVoiture
local listeVehicleEntreprise
local derniervoituresorti = {}
local sortirvoitureacheter = {}
-- blips

local markerjob = {{
    x = -36.97,
    y = -1103.1,
    z = 25.5
} -- point vente -36.97, -1103.1,26.37
}

Citizen.CreateThread(function()

    local concessmap = AddBlipForCoord(markerjob[1].x, markerjob[1].y, markerjob[1].z)
    SetBlipSprite(concessmap, 326)
    SetBlipColour(concessmap, 18)
    SetBlipScale(concessmap, 0.90)
    SetBlipAsShortRange(concessmap, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Concessionnaire | Voiture")
    EndTextCommandSetBlipName(concessmap)

end)

-- fin blips

-- point vente
local concesspointvente = false
RMenu.Add('concessvente', 'main', RageUI.CreateMenu("Menu Concess", "Acheter ou vendre des véhicules"))
RMenu.Add('concessvente', 'listevehicule',
    RageUI.CreateSubMenu(RMenu:Get('concessvente', 'main'), "Catalogue", "Parcourir la catégorie"))
RMenu.Add('concessvente', 'achatvehiculeentreprise', RageUI.CreateSubMenu(RMenu:Get('concessvente', 'main'),
    "Véhicules", "Pour acheter un véhicule d'entreprise"))
RMenu.Add('concessvente', 'entreprisevalidachat', RageUI.CreateSubMenu(
    RMenu:Get('concessvente', 'achatvehiculeentreprise'), "Véhicules", "Pour acheter un véhicule"))
RMenu.Add('concessvente', 'vente', RageUI.CreateSubMenu(RMenu:Get('concessvente', 'main'), "Liste de vos véhicules",
    "Pour vendre un véhicule"))
RMenu.Add('concessvente', 'categorievehicule',
    RageUI.CreateSubMenu(RMenu:Get('concessvente', 'listevehicule'), "Véhicules", "Valider pour visualiser"))
RMenu.Add('concessvente', 'achatvehicule', RageUI.CreateSubMenu(RMenu:Get('concessvente', 'categorievehicule'),
    "Véhicules", "Pour acheter un véhicule"))
RMenu.Add('concessvente', 'annonces',
    RageUI.CreateSubMenu(RMenu:Get('concessvente', 'main'), "Annonces", "Annonces de la ville"))
RMenu:Get('concessvente', 'main').Closed = function()
    concesspointvente = false
    supprimervehiculeconcess()
end
RMenu:Get('concessvente', 'achatvehicule').Closed = function()
    supprimervehiculeconcess()
end
RMenu:Get('concessvente', 'entreprisevalidachat').Closed = function()
    supprimervehiculeconcess()
end
RMenu:Get('concessvente', 'achatvehiculeentreprise').Closed = function()
    supprimervehiculeconcess()
end
RMenu:Get('concessvente', 'categorievehicule').Closed = function()
    supprimervehiculeconcess()
end

function ouvrirpointventeconc()
    if not concesspointvente then
        concesspointvente = true
        RageUI.Visible(RMenu:Get('concessvente', 'main'), true)
        while concesspointvente do

            RageUI.IsVisible(RMenu:Get('concessvente', 'main'), true, true, true, function()

                RageUI.ButtonWithStyle("Catalogue véhicules", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('concessvente', 'listevehicule'))
                RageUI.ButtonWithStyle("Vendre un véhicule", nil, {
                    RightLabel = "→→→"
                }, true, function()
                end, RMenu:Get('concessvente', 'vente'))
                if ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
                    RageUI.ButtonWithStyle("Acheter un véhicule d'entreprise", nil, {
                        RightLabel = "→→→"
                    }, true, function()
                    end, RMenu:Get('concessvente', 'achatvehiculeentreprise'))
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('concessvente', 'achatvehiculeentreprise'), true, true, true, function()

                for k, v in pairs(listeVehicleEntreprise) do
                    local exemplaires = "exemplaire."
                    if v.dispo > 1 then
                        exemplaires = "exemplaires."
                    end
                    RageUI.ButtonWithStyle(v.name, "Stock : " .. v.dispo .. " " .. exemplaires, {
                        RightLabel = "~g~" .. v.price .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            nomvoiture = v.name
                            prixvoiture = v.price
                            modelevoiture = v.model
                            dispo = v.dispo
                            job = v.category
                            supprimervehiculeconcess()
                            chargementvoiture(modelevoiture)
                            ESX.Game.SpawnLocalVehicle(modelevoiture, {
                                x = -41.61,
                                y = -1099.05,
                                z = 26.42
                            }, 287.3503, function(vehicle)
                                table.insert(derniervoituresorti, vehicle)
                                FreezeEntityPosition(vehicle, true)
                            end)
                        end
                    end, RMenu:Get('concessvente', 'entreprisevalidachat'))
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('concessvente', 'entreprisevalidachat'), true, true, true, function()

                RageUI.ButtonWithStyle(nomvoiture, "Attention, vous allez acheter ce véhicule.", {
                    RightLabel = "~g~" .. prixvoiture .. "$"
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ESX.TriggerServerCallback('h4ci_concess:verifsousclient', function(suffisantsous)
                            if suffisantsous then
                                if dispo > 0 then
                                    local vehicle = derniervoituresorti[1]
                                    table.insert(sortirvoitureacheter, vehicle)
                                    local plaque = GeneratePlate(job)
                                    local vehicleProps = ESX.Game.GetVehicleProperties(
                                        sortirvoitureacheter[#sortirvoitureacheter])
                                    vehicleProps.plate = plaque
                                    SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)
                                    if modelevoiture == "polmav" then
                                        SetVehicleModKit(vehicle, 0)
                                        if job == "police" then
                                            props = {
                                                modLivery = 0
                                            }
                                            ESX.Game.SetVehicleProperties(vehicle, props)
                                            carModif = ESX.Game.GetVehicleProperties(vehicle)
                                        else
                                            props = {
                                                modLivery = 1
                                            }
                                            ESX.Game.SetVehicleProperties(vehicle, props)
                                            carModif = ESX.Game.GetVehicleProperties(vehicle)
                                        end

                                        TriggerServerEvent('shop:vehiculeEntreprise', carModif, prixvoiture, nomvoiture,
                                            job)
                                        ESX.ShowNotification(
                                            'Acheté : ' .. nomvoiture .. ' avec la plaque ' .. carModif.plate ..
                                                ".\n~y~Votre vehicule est au garage entreprise.")
                                        supprimervehiculeconcess()
                                        RageUI.CloseAll()
                                        concesspointvente = false
                                    elseif job == "ambulance" and modelevoiture == "fbi2" then
                                            props = {
                                                color1=39
                                            }
                                            ESX.Game.SetVehicleProperties(vehicle, props)
                                            carModif = ESX.Game.GetVehicleProperties(vehicle)

                                        TriggerServerEvent('shop:vehiculeEntreprise', carModif, prixvoiture, nomvoiture,
                                            job)
                                        ESX.ShowNotification(
                                            'Acheté : ' .. nomvoiture .. ' avec la plaque ' .. carModif.plate ..
                                                ".\n~y~Votre vehicule est au garage entreprise.")
                                        supprimervehiculeconcess()
                                        RageUI.CloseAll()
                                        concesspointvente = false
                                    elseif modelevoiture == "mule" then
                                        if job == "burgershot" then
                                            props = {
                                                extras={
                                                    ["1"]=false,["7"]=false,["6"]=false,["5"]=false,["4"]=false, ["3"]=false, ["2"]=true
                                                }
                                            }
                                            ESX.Game.SetVehicleProperties(vehicle, props)
                                            carModif = ESX.Game.GetVehicleProperties(vehicle)
                                        elseif job == "vigne" then
                                            props = {
                                                extras={
                                                    ["1"]=false,["7"]=false,["6"]=false,["5"]=false,["4"]=false, ["3"]=true, ["2"]=false
                                                }
                                            }
                                            ESX.Game.SetVehicleProperties(vehicle, props)
                                            carModif = ESX.Game.GetVehicleProperties(vehicle)
                                        else
                                            props = {
                                                extras={
                                                    ["2"]=false,["1"]=true,["7"]=false,["6"]=false,["5"]=false,["4"]=false,["3"]=false
                                                }
                                            }
                                            ESX.Game.SetVehicleProperties(vehicle, props)
                                            carModif = ESX.Game.GetVehicleProperties(vehicle)
                                        end

                                        TriggerServerEvent('shop:vehiculeEntreprise', carModif, prixvoiture, nomvoiture,
                                            job)
                                        ESX.ShowNotification(
                                            'Acheté : ' .. nomvoiture .. ' avec la plaque ' .. carModif.plate ..
                                                ".\n~y~Votre vehicule est au garage public.")
                                        supprimervehiculeconcess()
                                        RageUI.CloseAll()
                                        concesspointvente = false
                                    elseif modelevoiture == "newsheli" then
                                        TriggerServerEvent('shop:vehiculeEntreprise', vehicleProps, prixvoiture, nomvoiture,
                                            job)
                                        ESX.ShowNotification(
                                            'Acheté : ' .. nomvoiture .. ' avec la plaque ' .. vehicleProps.plate ..
                                                ".\n~y~Votre vehicule est au garage entreprise.")
                                        supprimervehiculeconcess()
                                        RageUI.CloseAll()
                                        concesspointvente = false
                                    else
                                        TriggerServerEvent('shop:vehiculeEntreprise', vehicleProps, prixvoiture,
                                            nomvoiture, job)
                                        ESX.ShowNotification(
                                            'Acheté : ' .. nomvoiture .. ' avec la plaque ' ..
                                                vehicleProps.plate ..
                                                ".\nVotre vehicule est au garage public.")
                                        supprimervehiculeconcess()
                                        RageUI.CloseAll()
                                        concesspointvente = false
                                    end
                                else
                                    supprimervehiculeconcess()
                                    ESX.ShowNotification('Ce véhicule est en rupture de stock !')
                                    RageUI.CloseAll()
                                    concesspointvente = false
                                end
                            else
                                supprimervehiculeconcess()
                                ESX.ShowNotification('Vous n\'avez pas assez d\'argent.')
                                RageUI.CloseAll()
                                concesspointvente = false
                            end

                        end, prixvoiture)
                    end
                end)

            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('concessvente', 'vente'), true, true, true, function()
                for i = 1, #listeVoiture, 1 do
                    RageUI.ButtonWithStyle(listeVoiture[i].model, listeVoiture[i].plate, {
                        RightLabel = "~b~" .. math.floor(listeVoiture[i].price / 3) .. "$"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            nomvehicule = listeVoiture[i].model
                            plate = listeVoiture[i].plate
                            price = math.floor(listeVoiture[i].price / 3)
                            ESX.TriggerServerCallback('listeDesVehiculeParNom', function(dispo)
                                        disponibiliter = dispo
                                        TriggerServerEvent('shop:vehicule', false, price, nomvehicule, disponibiliter,
                                            plate)
                                        RageUI.CloseAll()
                                        concesspointvente = false
                            end, nomvehicule)
                        end
                    end)
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('concessvente', 'listevehicule'), true, true, true, function()
                for i = 1, #h4ci_conc.catevehi, 1 do
                    RageUI.ButtonWithStyle(h4ci_conc.catevehi[i].label, nil, {
                        RightLabel = "→→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            nomcategorie = h4ci_conc.catevehi[i].label
                            categorievehi = h4ci_conc.catevehi[i].name
                            ESX.TriggerServerCallback('h4ci_concess:recupererlistevehicule', function(listevehi)
                                h4ci_conc.listecatevehi = listevehi
                            end, categorievehi)
                        end
                    end, RMenu:Get('concessvente', 'categorievehicule'))
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('concessvente', 'categorievehicule'), true, true, true, function()

                for i2 = 1, #h4ci_conc.listecatevehi, 1 do
                    local exemplaires = "exemplaire."
                    if h4ci_conc.listecatevehi[i2].dispo > 1 then
                        exemplaires = "exemplaires."
                    end
                    RageUI.ButtonWithStyle(h4ci_conc.listecatevehi[i2].name,
                        "Stock : " .. h4ci_conc.listecatevehi[i2].dispo .. " " .. exemplaires, {
                            RightLabel = h4ci_conc.listecatevehi[i2].price .. "$"
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                nomvoiture = h4ci_conc.listecatevehi[i2].name
                                prixvoiture = h4ci_conc.listecatevehi[i2].price
                                modelevoiture = h4ci_conc.listecatevehi[i2].model
                                dispo = h4ci_conc.listecatevehi[i2].dispo
                                supprimervehiculeconcess()
                                chargementvoiture(modelevoiture)
                                ESX.Game.SpawnLocalVehicle(modelevoiture, {
                                    x = -41.61,
                                    y = -1099.05,
                                    z = 26.42
                                }, 287.3503, function(vehicle)
                                    table.insert(derniervoituresorti, vehicle)
                                    FreezeEntityPosition(vehicle, true)
                                end)
                            end
                        end, RMenu:Get('concessvente', 'achatvehicule'))

                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('concessvente', 'achatvehicule'), true, true, true, function()

                RageUI.ButtonWithStyle(nomvoiture, "Attention, vous allez acheter ce véhicule.", {
                    RightLabel = "~g~" .. prixvoiture .. "$"
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ESX.TriggerServerCallback('h4ci_concess:verifsousclient', function(suffisantsous)
                            if suffisantsous then
                                if dispo > 0 then
                                    local playerPed = PlayerPedId()
                                    local vehicle = derniervoituresorti[1]
                                    table.insert(sortirvoitureacheter, vehicle)
                                    local plaque = GeneratePlate()
                                    local vehicleProps = ESX.Game.GetVehicleProperties(
                                        sortirvoitureacheter[#sortirvoitureacheter])
                                    vehicleProps.plate = plaque
                                    SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)

                                    TriggerServerEvent('shop:vehicule', vehicleProps, prixvoiture, nomvoiture, dispo,
                                        false)
                                    ESX.ShowNotification('Vous avez acheté ' .. nomvoiture .. ' avec la plaque ' ..
                                                             vehicleProps.plate ..
                                                             ".\nVotre véhicule est au garage public.")
                                    supprimervehiculeconcess()
                                    RageUI.CloseAll()
                                    concesspointvente = false
                                else
                                    supprimervehiculeconcess()
                                    ESX.ShowNotification('Ce véhicule est en rupture de stock !')
                                    RageUI.CloseAll()
                                    concesspointvente = false
                                end
                            else
                                supprimervehiculeconcess()
                                ESX.ShowNotification('Vous n\'avez pas assez d\'argent')
                                RageUI.CloseAll()
                                concesspointvente = false
                            end

                        end, prixvoiture)
                    end
                end)

            end, function()
            end)
            Citizen.Wait(0)
        end
    else
        concesspointvente = false
    end
end
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plycrdjob = GetEntityCoords(PlayerPedId(), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, markerjob[1].x, markerjob[1].y, markerjob[1].z)
        for k in pairs(markerjob) do
            DrawMarker(1, markerjob[k].x, markerjob[k].y, markerjob[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25,
                25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
        end
        if jobdist <= 2.0 then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Concessionnaire")

            if IsControlJustPressed(1, 51) and not concesspointvente then
                if ESX.PlayerData.job.grade_name == 'boss' then
                    ESX.TriggerServerCallback('VehiculeEntreprise', function(vehicle)
                        listeVehicleEntreprise = vehicle
                    end, ESX.PlayerData.job.name)
                end
                ESX.TriggerServerCallback('Vente:recupererlistevehicule', function(list)
                    listeVoiture = list
                    ESX.TriggerServerCallback('h4ci_concess:recuperercategorievehicule', function(catevehi)
                        h4ci_conc.catevehi = catevehi
                        ouvrirpointventeconc()
                    end)
                end)
            end
        else
            supprimervehiculeconcess()
            RageUI.CloseAll()
            concesspointvente = false
        end
    end
end)

function supprimervehiculeconcess()
    while #derniervoituresorti > 0 do
        local vehicle = derniervoituresorti[1]

        ESX.Game.DeleteVehicle(vehicle)
        table.remove(derniervoituresorti, 1)
    end
end

function chargementvoiture(modelHash)
    modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)

        BeginTextCommandBusyString('STRING')
        AddTextComponentSubstringPlayerName('shop_awaiting_model')
        EndTextCommandBusyString(4)

        while not HasModelLoaded(modelHash) do
            Citizen.Wait(1)
            DisableAllControlActions(0)
        end

        RemoveLoadingPrompt()
    end
end

------------
