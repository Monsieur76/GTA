ESX = nil
local garageWho = nil
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

h4cigarage = {
    listevoiture = {},
    listeEntreprise = {}
}

-- blip garage
Citizen.CreateThread(function()
    for k, v in pairs(garagepublic.zone) do
        local blip = AddBlipForCoord(v.sortie.x, v.sortie.y, v.sortie.z)
        SetBlipSprite(blip, 290)
        SetBlipColour(blip, 5)
        SetBlipScale(blip, 0.80)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Garage public")
        EndTextCommandSetBlipName(blip)
    end
end)

-- marker vehicule a sortir
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k, v in pairs(garagepublic.zone) do
            if (garagepublic.Type ~= -1 and GetDistanceBetweenCoords(coords, v.sortie.x, v.sortie.y, v.sortie.z, true) <
                garagepublic.DrawDistance) then
                DrawMarker(garagepublic.Type, v.sortie.x, v.sortie.y, v.sortie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    garagepublic.Size.x, garagepublic.Size.y, garagepublic.Size.z, garagepublic.Color.r,
                    garagepublic.Color.g, garagepublic.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false

            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

-- sortir véhicule
local publicgarage = false
RMenu.Add('garagepublic', 'main', RageUI.CreateMenu("Parking", "Endroit où sont rangés vos véhicules"))
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

                    RageUI.Button(plaque .. " | " .. nomvoituretexte, nil, {
                        RightLabel = "→→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            sortirvoiture(modelevoiturespawn, plaque, nomvoituretexte, true)
                            RageUI.CloseAll()
                            publicgarage = false
                        end
                    end)
                end
                for i = 1, #h4cigarage.listeEntreprise, 1 do
                    local hashvoiture = h4cigarage.listeEntreprise[i].vehicle.model
                    local modelevoiturespawn = h4cigarage.listeEntreprise[i].vehicle
                    local nomvoituretexte = h4cigarage.listeEntreprise[i].model
                    local plaque = h4cigarage.listeEntreprise[i].plate
                    if -74027062 == hashvoiture then
                        nomvoituretexte = "Van du Weazel"
                    end

                    RageUI.Button(plaque .. " | " .. nomvoituretexte, nil, {
                        RightLabel = "→→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            sortirvoiture(modelevoiturespawn, plaque, nomvoituretexte, true)
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
function sortirvoiture(vehicle, plate, model, garage)
    x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))

    ESX.Game.SpawnVehicle(vehicle.model, {
        x = x,
        y = y,
        z = z
    }, 57.6384, function(callback_vehicle)
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
    TriggerServerEvent('h4ci_garage:etatvehiculesortie', vehicle, 1, true)
    TriggerServerEvent('ddx_vehiclelock:registerkey', vehicle.plate, model)
end

-- ranger voiture
function rangervoiture()
    local playerPed = PlayerPedId()
    local vehicle, dist4 = ESX.Game.GetClosestVehicle(playerCoords)
    if dist4 < 2 then
        if ESX.Game.IsVehicleEmpty(vehicle) then
            local playerPed = PlayerPedId()
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            ESX.TriggerServerCallback('h4ci_garage:rangervoiture', function(valid)
                if valid then
                    exports['progressBar']:startUI(10000, "")
                    Citizen.Wait(10000)
                    local vehicle, dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                    if dist4 < 2 then
                        etatrangervoiture(vehicle, vehicleProps)
                    else
                        ESX.ShowNotification('Pas de véhicule à proximité')
                    end
                else
                    ESX.ShowNotification('Vous ne pouvez pas garer ce véhicule')
                end
            end, vehicleProps, garageWho)
        else
            ESX.ShowNotification('Veuillez tous descendre du vehicule pour le ranger')
        end
    else
        ESX.ShowNotification('Pas de véhicule à proximité')
    end
end

function etatrangervoiture(vehicle, vehicleProps)
    NetworkRequestControlOfEntity(vehicle)
    Citizen.Wait(2000)
    ESX.Game.DeleteVehicle(vehicle)
    TriggerServerEvent('h4ci_garage:etatvehiculesortie', vehicleProps, garageWho, false)
    TriggerServerEvent('ddx_vehiclelock:deleteKey', vehicleProps.plate)
    ESX.ShowNotification('Votre véhicule est rangé dans le garage.')
end
--

-- ouvrir menu sortir véhicule
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k, v in pairs(garagepublic.zone) do

            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.sortie.x, v.sortie.y, v.sortie.z)

            if dist <= 4.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Garage public")
                if IsControlJustPressed(1, 51) then
                    garageWho = v.name[1]
                    if ESX.PlayerData.job and ESX.PlayerData.job.name ~= "unemployed" then
                        ESX.TriggerServerCallback('h4ci_garage:listevoitureentreprise', function(ownedCars)
                            h4cigarage.listeEntreprise = ownedCars
                        end, garageWho, ESX.PlayerData.job.name)
                    end
                        ESX.TriggerServerCallback('h4ci_garage:listevoitureperso', function(ownedCars)
                            h4cigarage.listevoiture = ownedCars
                            ouvrirpublicgar()
                        end, garageWho)
                end
            else
            end
        end
    end
end)
