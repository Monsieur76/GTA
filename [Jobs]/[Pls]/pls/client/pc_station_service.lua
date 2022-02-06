ESX = nil
local station

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    Citizen.Wait(5000)
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

        ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

---------------- FONCTIONS ------------------

local pc = false
RMenu.Add('pc_stationservice', 'main', RageUI.CreateMenu("PC", "Station service"))
RMenu:Get('pc_stationservice', 'main').Closed = function()
    pc = false
end

function pcView()
    if not pc then
        pc = true
        RageUI.Visible(RMenu:Get('pc_stationservice', 'main'), true)
        while pc do
            Citizen.Wait(1)
            RageUI.IsVisible(RMenu:Get('pc_stationservice', 'main'), true, true, true, function()
                for k, v in pairs(station) do
                    --print(k,v)
                    if tonumber(v.name) then
                        RageUI.ButtonWithStyle("Numéro de la station "
                        ..v.name
                        , nil, {
                            RightLabel = "Réserve : "
                            ..v.litre.."L"
                        }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end
               end
            end, function()
            end)
        end
    else
        show_citern = false
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' and not IsDead then
            local plycrdjob = GetEntityCoords(PlayerPedId(), false)
            local dist4 = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, 552.76, 2796.49, 42.11-1 )
            DrawMarker(1, 552.76, 2796.49, 42.11-1 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255,
                false, 95, 255, 0, nil, nil, 0)
            if dist4 <= 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Voir les station service de la ville")
                if IsControlJustPressed(0, 51) then
                    ESX.TriggerServerCallback('pls:storageStationVille', function(statio)
                        station = statio
                        pcView()
                    end)
                end
            end
        end
    end
end)
