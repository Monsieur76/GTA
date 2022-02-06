ESX = nil
local garageWho = nil
local metier = nil
local spawn = nil

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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

h4cigarage = {
    listevoiture = {},
}

-- sortir véhicule
local publicgarage = false
RMenu.Add('garagepublic', 'main', RageUI.CreateMenu("Garage entreprise", "Véhicules entreprise"))
RMenu:Get('garagepublic', 'main').Closed = function()
    publicgarage = false
end
function ouvrirpublicgar()
    if not publicgarage then
        publicgarage = true
        RageUI.Visible(RMenu:Get('garagepublic', 'main'), true)
        while publicgarage do
            RageUI.IsVisible(RMenu:Get('garagepublic', 'main'), true, true, true, function()

                RageUI.Button("Ranger véhicule", nil, {
                    RightLabel = "→"
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        rangervoiture()
                        RageUI.CloseAll()
                        publicgarage = false
                    end
                end)

                for i = 1, #h4cigarage.listevoiture, 1 do
                    local hashvoiture = h4cigarage.listevoiture[i].vehicle.model
                    local modelevoiturespawn = h4cigarage.listevoiture[i].vehicle
                    local nomvoituretexte = h4cigarage.listevoiture[i].model
                    local plaque = h4cigarage.listevoiture[i].plate
                    if -74027062 == h4cigarage.listevoiture[i].vehicle.model then
                        nomvoituretexte = "Van du Weazel"
                    end
                    RageUI.Button(plaque .. " | " .. nomvoituretexte, nil, {
                        RightLabel = "→→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            sortirvoiture(modelevoiturespawn, plaque,nomvoituretexte)
                            RageUI.CloseAll()
                            publicgarage = false
                        end
                    end)

                end
            end, function()
            end)
            Citizen.Wait(0)
        end
    else
        publicgarage = false
    end
end

-- faire spawn voiture
function sortirvoiture(vehicle, plate,nomvoituretexte)
    local x = spawn.x
    local y = spawn.y
    local z = spawn.z
    GetDisplayNameFromVehicleModel(vehicle.model)
    if vehicle.model == -730904777 then
        x = 593.82
        y = 2793.74
    end
    ESX.Game.SpawnVehicle(vehicle.model, {
        x = x,
        y = y,
        z = z
    }, spawn.h, function(callback_vehicle)
        ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
        exports.fuel:SetFuel(callback_vehicle, vehicle.fuelLevel)
        SetVehRadioStation(callback_vehicle, "OFF")
        TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
        if vehicle.bodyHealth < 950 then
            SetVehicleDamage(callback_vehicle, 0.0, 0.0, 0.33, 1000.0, 100.0, true)
        end
        SetVehicleUndriveable(callback_vehicle, false)
        SetVehicleEngineOn(callback_vehicle, true, true)
    end)
    TriggerServerEvent('h4ci_garage:etatvehiculesortieentreprise', vehicle, 1)
    TriggerServerEvent('ddx_vehiclelock:registerkey', vehicle.plate, nomvoituretexte)

end

-- ranger voiture
function rangervoiture()
    local playerPed = PlayerPedId()
    local vehicle, dist4 = ESX.Game.GetClosestVehicle()
    if dist4 < 4 then
        if ESX.Game.IsVehicleEmpty(vehicle) or GetEntityModel(vehicle) == -730904777 then
            local playerPed = PlayerPedId()
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            ESX.TriggerServerCallback('ddx_vehiclelock:mykey', function(valid)
                if valid then
                    exports['progressBar']:startUI(10000, "")
                    Citizen.Wait(10000)
                    local vehicle, dist4 = ESX.Game.GetClosestVehicle()
                    if dist4 < 4 then
                        etatrangervoiture(vehicle, vehicleProps)
                    else
                        ESX.ShowNotification('Pas de véhicule à proximité')
                    end
                else
                    ESX.ShowNotification('Vous ne pouvez pas garer ce véhicule')
                end
            end, vehicleProps.plate)
        else
            ESX.ShowNotification('Veuillez tous descendre du vehicule pour le ranger.')
        end
    else
        ESX.ShowNotification('Pas de véhicule à proximité')
    end
end

function etatrangervoiture(vehicle, vehicleProps)
    NetworkRequestControlOfEntity(vehicle)
    Citizen.Wait(2000)
    ESX.Game.DeleteVehicle(vehicle)
    TriggerServerEvent('h4ci_garage:etatvehiculesortieentreprise', vehicleProps, garageWho)
    TriggerServerEvent('ddx_vehiclelock:deleteKey', vehicleProps.plate)
    ESX.ShowNotification('Votre véhicule est rangé dans le garage.')
end
--

-- ouvrir menu sortir véhicule
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k, v in pairs(garagepublic.zone) do
            local jobToFind = v.metier[1]
            if jobToFind == "policeNorth" then
                jobToFind = "police"
            end
            if ESX.PlayerData.job and ESX.PlayerData.job.name:find(jobToFind) then
                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.sortie.x, v.sortie.y, v.sortie.z)
                DrawMarker(garagepublic.Type, v.sortie.x, v.sortie.y, v.sortie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    garagepublic.Size.x, garagepublic.Size.y, garagepublic.Size.z, garagepublic.Color.r,
                    garagepublic.Color.g, garagepublic.Color.b, 100, false, true, 2, false, false, false, false)
                if dist <= 3.5 and GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) ~= 15 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Garage d'entreprise")

                    if IsControlJustPressed(1, 51) then

                        garageWho = v.name[1]
                        spawn = v.spawn
                        ESX.TriggerServerCallback('h4ci_garage:listevoitureentrepris', function(ownedCars)
                            h4cigarage.listevoiture = ownedCars
                            ouvrirpublicgar()
                        end, garageWho)
                    end
                else
                end
            end
        end
    end
end)
