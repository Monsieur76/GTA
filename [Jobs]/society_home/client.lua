ESX = nil

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

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData = ESX.GetPlayerData()
    if ESX.PlayerData ~= nil then
        ESX.PlayerData.job = job
    end
end)
cooldown = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for society in pairs(Config.Positions) do
            for _, position in pairs(Config.Positions[society]) do
                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position.x, position.y, position.z)
                DrawMarker(1, position.x, position.y, position.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25,
                    95, 255, 255, false, 95, 255, 0, nil, nil, 0)
                if dist <= 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Appeler quelqu'un à l'accueil")
                    if IsControlJustPressed(1, 51) and not cooldown then
                        TriggerServerEvent('gcPhone:sendMessage', society, "Quelqu'un est demandé à l'accueil", nil,
                            false)
                        ESX.ShowAdvancedNotification("Téléphone", "", "Votre appel à bien été envoyé",
                            "CHAR_BARRY", 1)
                        cooldown = true
                    end

                end
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if cooldown then
            Citizen.Wait(60000)
            cooldown = false
        end
    end
end)
