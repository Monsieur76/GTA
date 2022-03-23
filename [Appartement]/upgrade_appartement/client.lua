ESX = nil
local blip = nil
local ped = nil
local OwnedProperty = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    RequestModel(Config.PedHash)
    while not HasModelLoaded(Config.PedHash) do
        Wait(5)
    end
    ped = CreatePed("PED_TYPE_CIVMALE", Config.PedHash, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z,
        41.29, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)

    blip = AddBlipForCoord(Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z)

    SetBlipSprite(blip, 476)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 25)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Dynasty8')
    EndTextCommandSetBlipName(blip)
end)
RegisterNetEvent('esx_property:sendProperties')
AddEventHandler('esx_property:sendProperties', function()
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback("esx_property:getOwnedProperty", function(ownedProperty)
        OwnedProperty = ownedProperty
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback("esx_property:getOwnedProperty", function(ownedProperty)
        OwnedProperty = ownedProperty
    end)
end)
RMenu.Add('upgrade_appartement', 'main', RageUI.CreateMenu("Dynasty8", "Amélioration de votre logement"))
RMenu.Add('upgrade_appartement', 'coffre_fort',
    RageUI.CreateSubMenu(RMenu:Get('upgrade_appartement', 'main'), "Dynasty8", "Amélioration du coffre fort"))
RMenu.Add('upgrade_appartement', 'coffre',
    RageUI.CreateSubMenu(RMenu:Get('upgrade_appartement', 'main'), "Dynasty8", "Amélioration du coffre"))
RMenu.Add('upgrade_appartement', 'garage',
    RageUI.CreateSubMenu(RMenu:Get('upgrade_appartement', 'main'), "Dynasty8", "Amélioration du garage"))
RMenu.Add('upgrade_appartement', 'coloc',
    RageUI.CreateSubMenu(RMenu:Get('upgrade_appartement', 'main'), "Dynasty8", "Colocataires"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('upgrade_appartement', 'main'), true, true, true, function()
            RageUI.Button("Amélioration du coffre fort", (OwnedProperty and OwnedProperty.label or ""), {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('upgrade_appartement', 'coffre_fort'))
            RageUI.Button("Amélioration du coffre", (OwnedProperty and OwnedProperty.label or ""), {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('upgrade_appartement', 'coffre'))
            RageUI.Button("Amélioration du garage", (OwnedProperty and OwnedProperty.label or ""), {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('upgrade_appartement', 'garage'))
            RageUI.Button("Colocataires", (OwnedProperty and OwnedProperty.label or ""), {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('upgrade_appartement', 'coloc'))
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('upgrade_appartement', 'coffre_fort'), true, true, true, function()
            local prixCumulatif = 0
            for _, v in pairs(Config.UpgradesCoffres) do
                if OwnedProperty.level_coffre_fort < v.level then
                    prixCumulatif = prixCumulatif + v.price
                end
                RageUI.Button('Niveau ' .. v.level,
                    "Le prix indiqué est cumulatif. Chaque niveau ajoute 1500 de capacité à votre coffre fort.", {
                        RightLabel = OwnedProperty.level_coffre_fort >= v.level and "" or "~g~" .. prixCumulatif .. "$",
                        RightBadge = OwnedProperty.level_coffre_fort >= v.level and RageUI.BadgeStyle.Tick or nil
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if OwnedProperty.level_coffre_fort >= v.level then
                                ESX.ShowNotification("L'amélioration est déjà achetée")
                            else
                                ESX.TriggerServerCallback("upgradeProperty:applyUpgrade", function(done)
                                    if done then
                                        OwnedProperty.level_coffre_fort = v.level
                                    end
                                end, "level_coffre_fort", v.level, prixCumulatif)
                            end

                        end
                    end)
            end
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('upgrade_appartement', 'coffre'), true, true, true, function()
            local prixCumulatif = 0
            for _, v in pairs(Config.UpgradesCoffres) do
                if OwnedProperty.level_coffre < v.level then
                    prixCumulatif = prixCumulatif + v.price
                end
                RageUI.Button('Niveau ' .. v.level,
                    "Le prix indiqué est cumulatif. Chaque niveau ajoute 100kg de capacité à votre coffre.", {
                        RightLabel = OwnedProperty.level_coffre >= v.level and "" or "~g~" .. prixCumulatif .. "$",
                        RightBadge = OwnedProperty.level_coffre >= v.level and RageUI.BadgeStyle.Tick or nil
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if OwnedProperty.level_coffre >= v.level then
                                ESX.ShowNotification("L'amélioration est déjà achetée")
                            else
                                ESX.TriggerServerCallback("upgradeProperty:applyUpgrade", function(done)
                                    if done then
                                        OwnedProperty.level_coffre = v.level
                                    end
                                end, "level_coffre", v.level, prixCumulatif)
                            end

                        end
                    end)
            end
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('upgrade_appartement', 'garage'), true, true, true, function()
            local prixCumulatif = 0
            for _, v in pairs(Config.UpgradesGarage) do
                if OwnedProperty.level_garage < v.level then
                    prixCumulatif = prixCumulatif + v.price
                end
                RageUI.Button('Niveau ' .. v.level, "Le prix indiqué est cumulatif. Chaque niveau ajoute 1 place à votre garage.", {
                    RightLabel = OwnedProperty.level_garage >= v.level and "" or "~g~" .. prixCumulatif .. "$",
                    RightBadge = OwnedProperty.level_garage >= v.level and RageUI.BadgeStyle.Tick or nil
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if OwnedProperty.level_garage >= v.level then
                            ESX.ShowNotification("L'amélioration est déjà achetée")
                        else
                            ESX.TriggerServerCallback("upgradeProperty:applyUpgrade", function(done)
                                if done then
                                    OwnedProperty.level_garage = v.level
                                end
                            end, "level_garage", v.level, prixCumulatif)
                        end
                    end
                end)
            end
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('upgrade_appartement', 'coloc'), true, true, true, function()
            local prixCumulatif = 0
            for _, v in pairs(Config.UpgradesColoc) do
                if OwnedProperty.number_coloc < v.level then
                    prixCumulatif = prixCumulatif + v.price
                end
                RageUI.Button('Niveau ' .. v.level, "Le prix indiqué est cumulatif. Chaque niveau ajoute 1 place à votre colocation.", {
                    RightLabel = OwnedProperty.number_coloc >= v.level and "" or "~g~" .. prixCumulatif .. "$",
                    RightBadge = OwnedProperty.number_coloc >= v.level and RageUI.BadgeStyle.Tick or nil
                }, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if OwnedProperty.number_coloc >= v.level then
                            ESX.ShowNotification("L'amélioration est déjà achetée")
                        else
                            --print(v.level)
                            ESX.TriggerServerCallback("upgradeProperty:applyUpgrade", function(done)
                               if done then
                                   OwnedProperty.number_coloc = v.level
                                   OwnedProperty.level_coloc = v.level
                                end
                            end, "number_coloc", v.level, prixCumulatif)
                        end
                    end
                end)
            end
        end, function()
        end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.MarkerCoords.x, Config.MarkerCoords.y,
            Config.MarkerCoords.z)
        if dist < 50 then
            DrawMarker(1, Config.MarkerCoords.x, Config.MarkerCoords.y, Config.MarkerCoords.z - 1, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
        end
        if dist <= 1.5 then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Améliorer votre logement")
            if IsControlJustPressed(1, 38) then
                if OwnedProperty == nil then
                    ESX.ShowNotification("Vous n'êtes pas propriétaire d'un logement !")
                else
                    RageUI.Visible(RMenu:Get('upgrade_appartement', 'main'),
                        not RageUI.Visible(RMenu:Get('upgrade_appartement', 'main')))
                end
            end
        end
    end
end)

