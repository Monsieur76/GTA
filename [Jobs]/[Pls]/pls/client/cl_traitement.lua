ESX = nil

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

local isFueling = false

RMenu.Add('plsremplir', 'essence', RageUI.CreateMenu("Pétrol", "Pétrol"))
RMenu.Add('plsremplir', 'rempli', RageUI.CreateSubMenu(RMenu:Get('mstremplir', 'essence'), "Pétrol", "Remplir Pétrol"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('plsremplir', 'essence'), true, true, true, function()

            RageUI.ButtonWithStyle("Remplir d'essence", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    towmodel = GetHashKey('tanker')
                    local playerPed = PlayerPedId()
                    local PedPosition = GetEntityCoords(playerPed)
                    local vehicle = ESX.Game.GetClosestVehicle(PedPosition)
                    local isVehicleTow = IsVehicleModel(vehicle, towmodel)
                    if isVehicleTow then
                        local plate = GetVehicleNumberPlateText(vehicle)
                        ESX.TriggerServerCallback('Monsieur_litre', function(litreP, litreE)
                            if litreP > 0 then
                                RageUI.CloseAll()
                                isFueling = true
                                TriggerEvent('Monsieur_remplissageEssence', litreP, plate)
                            else
                                ESX.ShowNotification("Vous n'avez pas de pétrol")
                            end
                        end, plate)
                    else
                        ESX.ShowNotification("Seul les citernes sont autorisées")
                    end
                end
            end)

        end, function()
        end, 1)

        Citizen.Wait(0)
    end
end)

local position = {{
    x = 2705.61,
    y = 1573.99,
    z = 24.52
}}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' then
            for k in pairs(position) do
                DrawMarker(1, position[k].x, position[k].y, position[k].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0,
                    0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

                if dist <= 5.0 then
                    if not isFueling then
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ Traitement du pétrole")
                    end
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(RMenu:Get('plsremplir', 'essence'),
                            not RageUI.Visible(RMenu:Get('plsremplir', 'essence')))
                    end
                else
                    isFueling = false
                end
            end
        end
    end
end)

AddEventHandler('Monsieur_remplissageEssence', function(litre, plate)
    TriggerServerEvent('Monsieur_vidage_petrol', plate, 0)
    ESX.ShowNotification("Attention si vous partez avant la fin. Nous garderons tout le pétrole")
    local currentessence = 0
    while isFueling do
        Citizen.Wait(500)
        local fuelToAdd = math.random(50, 100)
        currentessence = currentessence + fuelToAdd

        if currentessence > litre then
            currentessence = litre
            isFueling = false
            ESX.ShowNotification("Remplissage terminé. Le camion a été rempli de " .. currentessence ..
                                     " L d'essence")
        end
    end
    TriggerServerEvent('Monsieur_remplissage_essence', plate, currentessence)
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isFueling then
            ESX.ShowHelpNotification("Remplissage de la citerne en cours...")
        end
    end
end)
