ESX = nil
local garageWho = nil
local name_garage = false
local sortieH

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(5000)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx_property:sendProperties')
AddEventHandler('esx_property:sendProperties', function()
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('esx_property:getProperties', function(properties)
        Config.Properties = properties
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('esx_property:getProperties', function(properties)
        Config.Properties = properties
    end)
end)

h4cigarage = {
    listevoiture = {},
    listefourriere = {}
}

-- sortir véhicule
local maisongarag = false
RMenu.Add('maisongarage', 'maingarage', RageUI.CreateMenu("Garage", "Votre garage"))
RMenu:Get('maisongarage', 'maingarage').Closed = function()
    maisongarag = false
end

function ouvrirmaisongar(property)
    if not maisongarag then
        maisongarag = true
        RageUI.Visible(RMenu:Get('maisongarage', 'maingarage'), true)
        while maisongarag do
            RageUI.IsVisible(RMenu:Get("maisongarage", "maingarage"), true, true, true, function()
                RageUI.ButtonWithStyle("Ranger véhicule",
                    "Nombre de place(s) disponible(s) : " .. Config.GarageLevels[property.level_garage + 1] -
                        #h4cigarage.listevoiture .. "/" .. Config.GarageLevels[property.level_garage + 1], {
                        RightLabel = "→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            rangervoiture(property)
                            RageUI.CloseAll()
                            maisongarag = false
                        end
                    end)
                for i = 1, #h4cigarage.listevoiture, 1 do
                    local modelevoiturespawn = h4cigarage.listevoiture[i].vehicle
                    local nomvoituretexte = h4cigarage.listevoiture[i].model
                    local plaque = h4cigarage.listevoiture[i].plate

                    RageUI.ButtonWithStyle(plaque .. " | " .. nomvoituretexte,
                        "Nombre de place(s) disponible(s) : " .. Config.GarageLevels[property.level_garage + 1] -
                            #h4cigarage.listevoiture .. "/" .. Config.GarageLevels[property.level_garage + 1], {
                            RightLabel = "→"
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                sortirvoiture(modelevoiturespawn,nomvoituretexte)
                                RageUI.CloseAll()
                                maisongarag = false
                            end
                        end)
                end
            end, function()
            end)
            Citizen.Wait(0)
        end
    else
        maisongarag = false
    end
end

-- faire spawn voiture
function sortirvoiture(vehicle,model)
    x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))

    ESX.Game.SpawnVehicle(vehicle.model, {
        x = x,
        y = y,
        z = z
    }, sortieH, function(callback_vehicle)
        ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
        exports.fuel:SetFuel(callback_vehicle, vehicle.fuelLevel)
        SetVehRadioStation(callback_vehicle, "OFF")
        TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
        if vehicle.bodyHealth < 950 then
            SetVehicleDamage(callback_vehicle, 0.0, 0.0, 0.33, 1000.0, 100.0, true)
        end
        SetVehicleUndriveable(callback_vehicle, false)
        SetVehicleEngineOn(callback_vehicle, true, true)
        SetVehicleFuelLevel(callback_vehicle, vehicle.fuelLevel + 0.0)
    end)
    TriggerServerEvent('h4ci_garage:etatvehiculesortieAppartement', vehicle, 1, true)
    TriggerServerEvent('ddx_vehiclelock:registerkey', vehicle.plate, model)
end

-- ranger voiture
function rangervoiture(property)
    local playerPed = PlayerPedId()
    local vehicle, dist4 = ESX.Game.GetClosestVehicle()
    if dist4 < 2 then
        if #h4cigarage.listevoiture >= Config.GarageLevels[property.level_garage + 1] then
            ESX.ShowNotification('Vous n\'avez plus de place dans votre garage.')
        else
            if ESX.Game.IsVehicleEmpty(vehicle) then
                local playerPed = PlayerPedId()
                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                ESX.TriggerServerCallback('ddx_vehiclelock:MKeyGarageApart', function(valid)
                    if valid then
                        exports['progressBar']:startUI(10000, "")
                        Citizen.Wait(10000)
                        local vehicle, dist4 = ESX.Game.GetClosestVehicle()
                        if dist4 < 2 then
                            etatrangervoiture(vehicle, vehicleProps)
                        else
                            ESX.ShowNotification('Pas de véhicule à proximité')
                        end
                    else
                        ESX.ShowNotification('Vous ne pouvez pas garer ce véhicule')
                    end
                end, vehicleProps.plate)
            else
                ESX.ShowNotification('Veuillez tous descendre du vehicule pour le ranger')
            end
        end
    else
        ESX.ShowNotification('Pas de véhicule à proximité')
    end

end

function etatrangervoiture(vehicle, vehicleProps)
    local attempt = 0

    while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
        Citizen.Wait(100)
        NetworkRequestControlOfEntity(vehicle)
        attempt = attempt + 1
    end

    if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
    ESX.Game.DeleteVehicle(vehicle)
    end
    TriggerServerEvent('h4ci_garage:etatvehiculesortieAppartement', vehicleProps, garageWho, false)
    TriggerServerEvent('ddx_vehiclelock:deleteKey', vehicleProps.plate)
    ESX.ShowNotification('Votre véhicule est rangé dans le garage.')
end

-- ouvrir menu sortir véhicule
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for i = 1, #Config.Properties, 1 do
            local propertys = Config.Properties[i]
            if propertys.coloc_name ~= nil and #propertys.coloc_name > 0 then
                for i = 1, 5, 1 do
                    if propertys.coloc_name[i] ~= nil and propertys.coloc_name[i].identifier ==
                        ESX.PlayerData.identifier then
                        for k, v in pairs(garage.zone) do
                            if propertys.garage == v.name then
                                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.sortie.x, v.sortie.y,
                                   v.sortie.z - 1)

                                DrawMarker(1, v.sortie.x, v.sortie.y, v.sortie.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0,
                                    1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
                                if dist <= 2.0 then
                                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Garage logement")
                                    if IsControlJustPressed(1, 51) and not maisongarag then
                                        sortieH = v.sortie.h
                                        garageWho = propertys.garage
                                        ESX.TriggerServerCallback('h4ci_garage:listevoitureAppartement',
                                            function(ownedCars)
                                                h4cigarage.listevoiture = ownedCars
                                                ESX.TriggerServerCallback("esx_property:getUserProperty", function(property)
                                                    ouvrirmaisongar(property)
                                                end)
                                            end, garageWho)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if propertys.owner_identifier == ESX.PlayerData.identifier then
                for k, v in pairs(garage.zone) do
                    if propertys.garage == v.name then
                        local plyCoords = GetEntityCoords(PlayerPedId(), false)
                        local dist =
                            Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.sortie.x, v.sortie.y, v.sortie.z - 1)

                        DrawMarker(1, v.sortie.x, v.sortie.y, v.sortie.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                            0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
                        if dist <= 2.0 then
                            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Garage logement")
                            if IsControlJustPressed(1, 51) and not maisongarag then
                                sortieH = v.sortie.h
                                garageWho = propertys.garage
                                ESX.TriggerServerCallback('h4ci_garage:listevoitureAppartement', function(ownedCars)
                                    h4cigarage.listevoiture = ownedCars
                                    ESX.TriggerServerCallback("esx_property:getUserProperty", function(property)
                                        ouvrirmaisongar(property)
                                    end)
                                end, garageWho)
                            end
                        end
                    end
                end
            end
        end
    end
end)

