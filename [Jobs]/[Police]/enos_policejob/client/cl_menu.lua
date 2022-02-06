local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {},
    {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false,
    false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
blip = nil
local policeDog = false
local PlayerData = {}
closestDistance, closestEntity = -1, nil
local IsHandcuffed, DragStatus = false, {}
DragStatus.IsDragged = false
local attente = 0
local currentTask = {}
local props = {}
local name = 1
IsDead = false
local CopPed

local function LoadAnimDict(dictname)
    if not HasAnimDictLoaded(dictname) then
        RequestAnimDict(dictname)
        while not HasAnimDictLoaded(dictname) do
            Citizen.Wait(1)
        end
    end
end

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)
local PlayerData = {}
local ped = PlayerPedId()
local vehicle = GetVehiclePedIsIn(ped, false)

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

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
        RequestAnimDict(dict)
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

AddEventHandler('esx:onPlayerDeathFalse', function()
    IsDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
    IsDead = true
end)

RMenu.Add('police', 'main', RageUI.CreateMenu("LSPD", "Interaction"))
RMenu.Add('police', 'inter', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "LSPD", "Interaction"))
RMenu.Add('police', 'info', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "LSPD", "Interaction"))
RMenu.Add('police', 'doc', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "LSPD", "Interaction"))
RMenu.Add('police', 'voiture', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "LSPD", "Interaction"))
RMenu.Add('police', 'infosvoiture', RageUI.CreateMenu("LSPD", "Infos véhicule"))
-- RMenu.Add('police', 'chien', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "LSPD", "Interaction"))
RMenu.Add('police', 'amende', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "LSPD", "Amende"))

RMenu.Add('police', 'possession', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'trafic', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'refus', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'delit', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'moto', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'camion', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'superette', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'fleeca', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'pacific', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'otage', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'arme', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'brinks', RageUI.CreateSubMenu(RMenu:Get('police', 'amende'), "LSPD", "Amende"))
RMenu.Add('police', 'action', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "LSPD", "Action patron"))
RMenu.Add('police', 'permis', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "LSPD", "Permis"))
RMenu.Add('police', 'ppa', RageUI.CreateSubMenu(RMenu:Get('police', 'permis'), "LSPD", "Permis de port d'arme"))
RMenu.Add('police', 'chasse', RageUI.CreateSubMenu(RMenu:Get('police', 'permis'), "LSPD", "Permis de chasse"))
RMenu.Add('police', 'peche', RageUI.CreateSubMenu(RMenu:Get('police', 'permis'), "LSPD", "Licence de pêche"))
Citizen.CreateThread(function()
    while true do
        local jobName = "police"
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "policeNorth"  and not IsDead then
            jobName = "policeNorth"
        end
        RageUI.IsVisible(RMenu:Get('police', 'main'), true, true, true, function()
            RageUI.ButtonWithStyle("Factures", "Faire une facture.", {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    OpenBillingMenu()
                    RageUI.CloseAll()
                end
            end)
            RageUI.ButtonWithStyle("Interactions sur personne", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'inter'))

            RageUI.ButtonWithStyle("Interactions sur véhicules", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'voiture'))

            RageUI.ButtonWithStyle("Amendes", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'amende'))

            RageUI.ButtonWithStyle("Retirer/Mettre les herses", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local playerPed = PlayerPedId()
                    local obj, dist2 = ESX.Game.GetClosestObject({"p_ld_stinger_s"})
                    local id = NetworkGetNetworkIdFromEntity(obj)
                    NetworkRequestControlOfNetworkId(id)
                    local x, y, z = table.unpack(GetEntityCoords(dist2))
                    local deploy
                    for k, v in pairs(props) do
                        if props[k].x == x and props[k].y == y then
                            deploy = k
                        end
                    end
                    if dist2 < 1.2 and obj ~= -1 then
                        TriggerServerEvent("retireherse", deploy)
                        ESX.Game.DeleteObject(obj)
                        ESX.ShowNotification("Les objets ont été retiré")
                    else
                        TriggerServerEvent('herseMettre')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Retirer/Mettre les plots ", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local playerPed = PlayerPedId()
                    local obj, dist = ESX.Game.GetClosestObject({'prop_roadcone02a'})
                    local id = NetworkGetNetworkIdFromEntity(obj)
                    NetworkRequestControlOfNetworkId(id)
                    if dist < 1.2 and obj ~= -1 then
                        ESX.Game.DeleteObject(obj)
                        ESX.ShowNotification("Les objets ont été retiré")
                    else
                        TriggerServerEvent('plotMettre')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Retirer/Mettre les barrières", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local playerPed = PlayerPedId()
                    local obj, dist = ESX.Game.GetClosestObject({'prop_barrier_work06a'})
                    local id = NetworkGetNetworkIdFromEntity(obj)
                    NetworkRequestControlOfNetworkId(id)
                    if dist < 1.2 and obj ~= -1 then
                        ESX.Game.DeleteObject(obj)
                        ESX.ShowNotification("Les objets ont été retiré")
                    else
                        TriggerServerEvent('barrierMettre')
                    end
                end
            end)
            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Action employeur", nil, {
                    RightLabel = "→"
                }, true, function()
                end, RMenu:Get('police', 'action'))
            end
            RageUI.ButtonWithStyle("Permis", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'permis'))

            RageUI.ButtonWithStyle("Mettre un Wanted", nil, {
                RightBadge = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local data = KeyboardInput("Prénom et Nom", "", 40)
                    if data ~= nil then
                        local length = string.len(data)
                        if length < 2 or length > 40 then
                            ESX.ShowNotification("Saisie invalide")
                        else
                            TriggerServerEvent('annonce_open_wanted', data)
                        end
                    end
                    RageUI.CloseAll()
                end
            end)
            RageUI.ButtonWithStyle("Gestes de premiers secours", nil, {
                RightBadge = RageUI.BadgeStyle.Heart
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    revivePlayer()
                end
            end)

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'amende'), true, true, true, function()
            RageUI.ButtonWithStyle("Possession de drogue", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'possession'))
            RageUI.ButtonWithStyle("Trafic de drogue ", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'trafic'))
            RageUI.ButtonWithStyle("Refus d'obtempérer", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'refus'))
            RageUI.ButtonWithStyle("Délit de fuite voiture", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'delit'))
            RageUI.ButtonWithStyle("Délit de fuite moto", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'moto'))
            RageUI.ButtonWithStyle("Délit de fuite camion", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'camion'))
            RageUI.ButtonWithStyle("Braquage de supérette", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'superette'))
            RageUI.ButtonWithStyle("Braquage de Fleeca ", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'fleeca'))
            RageUI.ButtonWithStyle("Braquage Pacific", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'pacific'))
            RageUI.ButtonWithStyle("Prise d'otage", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'otage'))
            RageUI.ButtonWithStyle("Possession d'arme illégal", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'arme'))
            RageUI.ButtonWithStyle("Braquage du convoi UDST", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'brinks'))
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'inter'), true, true, true, function()

            RageUI.ButtonWithStyle("Fouiller", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    local playerPed = PlayerPedId()
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then

                        ESX.Streaming.RequestAnimDict('anim@gangops@morgue@table@', function()
                            TaskPlayAnim(playerPed, 'anim@gangops@morgue@table@', 'player_search', 8.0, 0.0, -1, 32,
                                0.0, false, false, false)
                            RemoveAnimDict('anim@gangops@morgue@table@')
                        end)
                        Citizen.Wait(5000)
                        ClearPedTasksImmediately(playerPed)
                        OpenBodySearchMenu(target_id)
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Menotter/démenotter", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    local playerPed = PlayerPedId()
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        TriggerServerEvent('esx_policejob:handcuff', target_id)
                        ESX.Streaming.RequestAnimDict('mp_arresting', function()
                            TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 1.0, 1.0, 33600, 0, 0, false, false,
                                false)
                            RemoveAnimDict('mp_arresting')
                        end)
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Escorter", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        TriggerServerEvent('esx_policejob:drag', target_id)
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Mettre dans un véhicule", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        TriggerServerEvent('esx_policejob:putInVehicle', target_id)
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Sortir du véhicule", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        TriggerServerEvent('esx_policejob:OutVehicle', target_id)
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'voiture'), true, true, true, function()
            local coords = GetEntityCoords(PlayerPedId())
            local vehicle = ESX.Game.GetVehicleInDirection()

            RageUI.ButtonWithStyle("Rechercher une plaque", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    local plate = KeyboardInput("Saisissez la plaque", "", 8)
                    if plate ~= nil then
                        if string.len(plate) == 8 then
                            ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
                                VehicleInfo = retrivedInfo
                                RageUI.Visible(RMenu:Get('police', 'infosvoiture'),
                                    not RageUI.Visible(RMenu:Get('police', 'infosvoiture')))
                            end, plate)
                        else
                            ESX.ShowNotification(_U('search_database_error_invalid'))
                        end
                    end

                end
            end)

            RageUI.ButtonWithStyle("Demande de fourrière", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local playerPed = PlayerPedId()
                    local PedPosition = GetEntityCoords(playerPed)
                    ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
                        if qtty > 0 then
                            ESX.ShowNotification('Votre demande a bien été envoyée au Benny\'s')
                            local msg = "La police a un véhicule à mettre en fourrière : GPS: " .. PedPosition.x ..
                                            ", " .. PedPosition.y
                            TriggerServerEvent('gcPhone:sendMessage', 'mechanic', msg, nil, false)
                        else
                            ESX.ShowNotification("Vous n'avez pas de téléphone !")
                        end
                    end, 'phone')

                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'infosvoiture'), true, true, true, function()
            RageUI.ButtonWithStyle(_U('plate', VehicleInfo.plate), nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                end
            end)
            if not VehicleInfo.owner then
                RageUI.ButtonWithStyle(_U('owner_unknown'), nil, {
                    RightLabel = ""
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                    end
                end)
            else
                RageUI.ButtonWithStyle(_U('owner', VehicleInfo.owner), nil, {
                    RightLabel = ""
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                    end
                end)
            end
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'camion'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 1500$ / (30 min de cellules)", "Retrait du permis", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 1500, true)
                        TriggerServerEvent('retraitpoint', 0, target_id, "truck", true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Normale 1000$ / (30 min de cellules)", "2 point", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 1000, true)
                        TriggerServerEvent('retraitpoint', 2, target_id, "truck", false)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Minoré 500$ / (30 min de cellules)", "1 point", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 500, true)
                        TriggerServerEvent('retraitpoint', 1, target_id, "truck", false)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'moto'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 1500$ / (30 min de cellules)", "Retrait du permis", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 1500, true)
                        TriggerServerEvent('retraitpoint', 0, target_id, "bike", true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Normale 1000$ / (30 min de cellules)", "2 point", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 1000, true)
                        TriggerServerEvent('retraitpoint', 2, target_id, "bike", false)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Minoré 500$ / (30 min de cellules)", "1 point", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 500, true)
                        TriggerServerEvent('retraitpoint', 1, target_id, "bike", false)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'delit'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 1500$ / (30 min de cellules)", "Retrait du permis", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 1500, true)
                        TriggerServerEvent('retraitpoint', 0, target_id, "drive", true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Normale 1000$ / (30 min de cellules)", "2 point", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 1000, true)
                        TriggerServerEvent('retraitpoint', 2, target_id, "drive", false)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Minoré 500$ / (30 min de cellules)", "1 point", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 500, true)
                        TriggerServerEvent('retraitpoint', 1, target_id, "drive", false)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'refus'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 1800$ / (30 min de cellules)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 1800, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Normale 990$", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 990, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'trafic'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 8.000$ / (30 min de cellules)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 8000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Normale 6000$ / (30 min de cellules)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 6000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Minoré 4500$ / (30 min de cellules)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 4500, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'possession'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 3500$ / (30 min de cellules)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 3500, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Normale 2500$ / (30 min de cellules)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 2500, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Minoré 1000$ ", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 1000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'superette'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 4000$ / (30 min de cellules)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 4000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Normale 2000$ / (30 min de cellules)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 2000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Minoré 1000$ ", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 1000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'fleeca'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 20000$ / (30 min de cellules)", "3h de fédéral", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 20000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Normale 15000$ / (30 min de cellules)", "2h de fédéral", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 15000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'pacific'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 70000$ / (30 min de cellules)", "entre 2h et 8h de fédéral", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 70000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'otage'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 30000$ / (2h de fédéral minimum)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 30000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Normale 20000$ / (2h de fédéral minimum)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 20000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Minoré 10000$ / (2h de fédéral minimum)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 10000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'arme'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 18000$ / (30 min de cellules)(arme lourd)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 18000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Minoré 5000$ (arme légère)", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 5000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'brinks'), true, true, true, function()
            RageUI.ButtonWithStyle("Majoré 50000$ / (30 min de cellules)", "4h de fédé voir plus", {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent('esx_billing:sendBill', target_id, jobName, 50000, true)
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.ShowNotification("~r~L'amende a été envoyée")
                        RageUI.CloseAll()
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'action'), true, true, true, function()
            RageUI.ButtonWithStyle("Engager un employer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        TriggerServerEvent('Monsieur_recrute_employ', target_id, jobName)
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Renvoyer un employer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        TriggerServerEvent('Monsieur_virer_employ', target_id, jobName)
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('police', 'permis'), true, true, true, function()
            RageUI.ButtonWithStyle("Permis de port d'arme", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'ppa'))
            RageUI.ButtonWithStyle("Permis de chasse", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'chasse'))
            RageUI.ButtonWithStyle("Licence de pêche", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('police', 'peche'))
        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('police', 'ppa'), true, true, true, function()
            RageUI.ButtonWithStyle("Délivrer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 1.5 and target_id ~= nil and target_id ~= 0 then
                        ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                            if haveLicense then
                                ESX.ShowNotification('Cette personne possède déjà le permis de port d\'arme.')
                            else
                                TriggerServerEvent('esx_license:addLicense', target_id, "PPA")
                                ESX.ShowNotification('Vous avez délivré le permis de port d\'arme.')
                            end
                        end, target_id, "PPA")

                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Retirer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 1.5 and target_id ~= nil and target_id ~= 0 then
                        ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                            if not haveLicense then
                                ESX.ShowNotification('Cette personne ne possède pas le permis de port d\'arme.')
                            else
                                TriggerServerEvent('esx_license:removeLicense', target_id, "PPA")
                                ESX.ShowNotification('Vous avez retiré le permis de port d\'arme.')
                            end
                        end, target_id, "PPA")
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'peche'), true, true, true, function()
            RageUI.ButtonWithStyle("Délivrer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 1.5 and target_id ~= nil and target_id ~= 0 then
                        ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                            if haveLicense then
                                ESX.ShowNotification('Cette personne possède déjà la licence de pêche.')
                            else
                                TriggerServerEvent('esx_license:addLicense', target_id, "fishing")
                                ESX.ShowNotification('Vous avez délivré la licence de pêche.')
                            end
                        end, target_id, "fishing")
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Retirer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 1.5 and target_id ~= nil and target_id ~= 0 then
                        ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                            if not haveLicense then
                                ESX.ShowNotification('Cette personne ne possède pas la licence de pêche.')
                            else
                                TriggerServerEvent('esx_license:removeLicense', target_id, "fishing")
                                ESX.ShowNotification('Vous avez retiré la licence de pêche.')
                            end
                        end, target_id, "fishing")
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('police', 'chasse'), true, true, true, function()
            RageUI.ButtonWithStyle("Délivrer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 1.5 and target_id ~= nil and target_id ~= 0 then
                        ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                            if haveLicense then
                                ESX.ShowNotification('Cette personne possède déjà le permis de chasse.')
                            else
                                TriggerServerEvent('esx_license:addLicense', target_id, "hunting")
                                ESX.ShowNotification('Vous avez délivré le permis de chasse.')
                            end
                        end, target_id, "hunting")
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Retirer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 1.5 and target_id ~= nil and target_id ~= 0 then
                        ESX.TriggerServerCallback('esx_license:checkLicense', function(haveLicense)
                            if not haveLicense then
                                ESX.ShowNotification('Cette personne ne possède pas le permis de chasse.')
                            else
                                TriggerServerEvent('esx_license:removeLicense', target_id, "hunting")
                                ESX.ShowNotification('Vous avez retiré le permis de chasse.')
                            end
                        end, target_id, "hunting")
                    else
                        ESX.ShowNotification('Pas de joueur à proximité.')
                    end
                end
            end)
        end, function()
        end)

        -- RageUI.IsVisible(RMenu:Get('police', 'chien'), true, true, true, function()

        --		RageUI.ButtonWithStyle("Sortir/Rentrer le chien",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        --			if Selected then
        --				if not DoesEntityExist(policeDog) then
        --                    RequestModel(351016938)
        --                     while not HasModelLoaded(351016938) do Wait(0) end
        --                    policeDog = CreatePed(4, 351016938, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -0.98), 0.0, true, false)
        --                    SetEntityAsMissionEntity(policeDog, true, true)
        --                   ESX.ShowNotification('~g~Chien Sorti')
        --               else
        --                    ESX.ShowNotification('~r~Chien Rentré')
        --                    DeleteEntity(policeDog)
        --               end
        --			end
        --		end)

        --		RageUI.ButtonWithStyle("Assis",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        --			if Selected then
        --				if DoesEntityExist(policeDog) then
        --                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog), true) <= 5.0 then
        --                        if IsEntityPlayingAnim(policeDog, "creatures@rottweiler@amb@world_dog_sitting@base", "base", 3) then
        --                            ClearPedTasks(policeDog)
        --                        else
        --                           loadDict('rcmnigel1c')
        --                           TaskPlayAnim(PlayerPedId(), 'rcmnigel1c', 'hailing_whistle_waive_a', 8.0, -8, -1, 120, 0, false, false, false)
        --                           Wait(2000)
        --                           loadDict("creatures@rottweiler@amb@world_dog_sitting@base")
        --                            TaskPlayAnim(policeDog, "creatures@rottweiler@amb@world_dog_sitting@base", "base", 8.0, -8, -1, 1, 0, false, false, false)
        --                        end
        --                    else
        --                        ESX.ShowNotification('dog_too_far')
        --                    end
        --                else
        --                    ESX.ShowNotification('no_dog')
        --                end
        --			end
        --		end)

        -- RageUI.ButtonWithStyle("Cherche de drogue",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        --	if Selected then
        --		if DoesEntityExist(policeDog) then
        --			if not IsPedDeadOrDying(policeDog) then
        --				if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) <= 3.0 then
        --					local player, distance = ESX.Game.GetClosestPlayer()
        --					if distance ~= -1 then
        --						if distance <= 3.0 then
        --							local playerPed = GetPlayerPed(player)
        --							if not IsPedInAnyVehicle(playerPed, true) then
        --								TriggerServerEvent('esx_policedog:hasClosestDrugs', GetPlayerServerId(player))
        --							end
        --						end
        --					end
        --				end
        --			else
        --				ESX.ShowNotification('Votre chien est mort')
        --			end
        --		else
        --			ESX.ShowNotification('Vous n\'avez pas de chien')
        --		end
        --	end
        -- end)

        -- RageUI.ButtonWithStyle("Dire d'attaquer",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        --	if Selected then
        --		if DoesEntityExist(policeDog) then
        --			if not IsPedDeadOrDying(policeDog) then
        --				if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) <= 3.0 then
        --					local player, distance = ESX.Game.GetClosestPlayer()
        --					if distance ~= -1 then
        --						if distance <= 3.0 then
        --							local playerPed = GetPlayerPed(player)
        --							if not IsPedInCombat(policeDog, playerPed) then
        --								if not IsPedInAnyVehicle(playerPed, true) then
        --									TaskCombatPed(policeDog, playerPed, 0, 16)
        --								end
        --							else
        --								ClearPedTasksImmediately(policeDog)
        --							end
        --						end
        --					end
        --				end
        --			else
        --				ESX.ShowNotification('Votre chien est mort')
        --			end
        --		else
        --			ESX.ShowNotification('Vous n\'avez pas de chien')
        --	end
        -- end
        -- end)

        -- end, function()
        -- end)

        Citizen.Wait(0)
    end
end)

function OpenIdentityCardMenu(player)
    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
        local elements = {{
            label = 'name',
            data.name
        }}

        if Config.EnableESXIdentity then
            table.insert(elements, {
                label = 'sex',
                data.sex
            })
            table.insert(elements, {
                label = 'dob',
                data.dob
            })
            table.insert(elements, {
                label = 'height',
                data.height
            })
        end

        if data.drunk then
            table.insert(elements, {
                label = 'bac',
                data.drunk
            })
        end

        if data.licenses then
            table.insert(elements, {
                label = 'license_label'
            })

            for i = 1, #data.licenses, 1 do
                table.insert(elements, {
                    label = data.licenses[i].label
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
            title = 'citizen_interaction',
            align = 'top-left',
            elements = elements
        }, nil, function(data, menu)
            menu.close()
        end)
    end, GetPlayerServerId(player))
end

RegisterNetEvent('openf6')
AddEventHandler('openf6', function()
    RageUI.Visible(RMenu:Get('police', 'main'), not RageUI.Visible(RMenu:Get('police', 'main')))
end)

-------------------------- Intéraction 

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    Citizen.Wait(6000)
    FreezeEntityPosition(playerPed, false)
    IsHandcuffed = not IsHandcuffed;

    Citizen.CreateThread(function()

        if IsHandcuffed then

            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(100)
            end

            TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            -- SetEnableHandcuffs(playerPed, true)
            SetPedCanPlayGestureAnims(playerPed, false)
            DisplayRadar(false)

        else

            ClearPedSecondaryTask(playerPed)
            -- SetEnableHandcuffs(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed, true)
            DisplayRadar(true)

        end

    end)
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(cop)
    IsDragged = not IsDragged
    CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsHandcuffed then
            if IsDragged then
                local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
                local myped = PlayerPedId()
                AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2,true)
            else
                DetachEntity(PlayerPedId(), true, false)
            end
        end
    end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        if DoesEntityExist(vehicle) then
            local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
            local freeSeat = nil
            for i = maxSeats - 1, 0, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    freeSeat = i
                    break
                end
            end
            if freeSeat ~= nil then
                TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
            end
        end
    end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(t)
    local ped = GetPlayerPed(t)
    ClearPedTasksImmediately(ped)
    plyPos = GetEntityCoords(PlayerPedId(), true)
    local xnew = plyPos.x + 2
    local ynew = plyPos.y + 2

    SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsHandcuffed then
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 83, true)
        end
    end
end)

----------------------------------------------- Fouiller

local elements

RMenu.Add('fouille', 'fouil', RageUI.CreateMenu("Fouille", "Fouille"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('fouille', 'fouil'), true, true, true, function()

            for k, v in pairs(elements) do
                if v.item == "money" then
                    RageUI.ButtonWithStyle(v.count .. "$", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)
                end
                if v.item == "item" then
                    if v.label ~= nil or v.label ~= false then
                        RageUI.ButtonWithStyle(v.label .. ' (' .. v.count .. ')', nil, {}, true,
                            function(Hovered, Active, Selected)

                                if Selected then
                                    local post, quantity = CheckQuantity(KeyboardInput('Saisissez la quantité', '', 8))
                                    if post and quantity ~= nil and quantity > 0 and quantity <= v.count then
                                        local target, distance = ESX.Game.GetClosestPlayer()
                                        local target_id = GetPlayerServerId(target)

                                        if distance ~= -1 and distance <= 3 then
                                            local plyPed = PlayerPedId()
                                            TriggerServerEvent('esx_policejob:confiscatePlayerItem', target_id, v.name,
                                                quantity, v.label)
                                            ClearPedTasks(plyPed)
                                        
                                            ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
                                                elements = {}
                                                elements = data
                                            end, target_id)
                                        else
                                            ESX.ShowNotification("Pas de joueur à proximité.")
                                        end
                                    else
                                        ESX.ShowNotification("Montant invalide")
                                    end
                                end
                            end)
                    end
                end

                if v.item == "weapon" then
                    if v.label ~= nil or v.label ~= false then
                        RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local target, distance = ESX.Game.GetClosestPlayer()
                                local target_id = GetPlayerServerId(target)
                                TriggerServerEvent('esx_policejob:confiscatePlayerItemWeapon', target_id, v.label,
                                    v.name, v.count)
                                    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
                                        elements = {}
                                        elements = data
                                    end, target_id)
                            end
                        end)
                    end
                end
            end

        end, function()
        end, 1)

        Citizen.Wait(0)
    end
end)

function OpenBodySearchMenu(player)
    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
        elements = {}
        elements = data
        -- Citizen.Wait(500)
        RageUI.Visible(RMenu:Get('fouille', 'fouil'), not RageUI.Visible(RMenu:Get('fouille', 'fouil')))

    end, player)
end

Citizen.CreateThread(function()
    local policemap = AddBlipForCoord(439.14, -982.3, 30.69)
    SetBlipSprite(policemap, 60)
    SetBlipColour(policemap, 38)
    SetBlipScale(policemap, 0.99)
    SetBlipAsShortRange(policemap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Commissariat ~b~LSPD Sud~s~")
    EndTextCommandSetBlipName(policemap)

    local policeNmap = AddBlipForCoord(-443.33, 6016.38, 31.71)
    SetBlipSprite(policeNmap, 60)
    SetBlipColour(policeNmap, 38)
    SetBlipScale(policeNmap, 0.99)
    SetBlipAsShortRange(policeNmap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Commissariat ~b~LSPD Nord~s~")
    EndTextCommandSetBlipName(policeNmap)
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') then
            if not RageUI.Visible(RMenu:Get('police', 'main')) and not RageUI.Visible(RMenu:Get('police', 'main')) and
                not RageUI.Visible(RMenu:Get('police', 'inter')) and not RageUI.Visible(RMenu:Get('police', 'info')) and
                not RageUI.Visible(RMenu:Get('police', 'doc')) and not RageUI.Visible(RMenu:Get('police', 'voiture')) and
                not RageUI.Visible(RMenu:Get('police', 'infosvoiture')) and
                not RageUI.Visible(RMenu:Get('police', 'chien')) and not RageUI.Visible(RMenu:Get('police', 'amende')) and
                not RageUI.Visible(RMenu:Get('police', 'possession')) and
                not RageUI.Visible(RMenu:Get('police', 'trafic')) and not RageUI.Visible(RMenu:Get('police', 'refus')) and
                not RageUI.Visible(RMenu:Get('police', 'delit')) and not RageUI.Visible(RMenu:Get('police', 'moto')) and
                not RageUI.Visible(RMenu:Get('police', 'camion')) and
                not RageUI.Visible(RMenu:Get('police', 'superette')) and
                not RageUI.Visible(RMenu:Get('police', 'fleeca')) and not RageUI.Visible(RMenu:Get('police', 'pacific')) and
                not RageUI.Visible(RMenu:Get('police', 'otage')) and not RageUI.Visible(RMenu:Get('police', 'arme')) and
                not RageUI.Visible(RMenu:Get('police', 'brinks')) and not RageUI.Visible(RMenu:Get('police', 'action')) and
                not RageUI.Visible(RMenu:Get('police', 'permis')) and not RageUI.Visible(RMenu:Get('police', 'ppa')) and
                not RageUI.Visible(RMenu:Get('police', 'chasse')) and not RageUI.Visible(RMenu:Get('police', 'peche')) and
                IsControlJustReleased(0, Keys["F6"]) then
                RageUI.Visible(RMenu:Get('police', 'main'), not RageUI.Visible(RMenu:Get('police', 'main')))
            end

        end
    end
end)

RegisterNetEvent('barrier')
AddEventHandler('barrier', function()

    local prop_name = 'prop_barrier_work06a'
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, false)
    Citizen.Wait(1000)
    ClearPedTasksImmediately(playerPed)
    ESX.Game.SpawnObject(prop_name, vector3(x, y, z - 1), function(object)
        FreezeEntityPosition(object, true)
        SetEntityHeading(object, GetEntityHeading(playerPed))
        local id = NetworkGetNetworkIdFromEntity(object)
        SetNetworkIdCanMigrate(id, true)
    end)
    ESX.ShowNotification('Vous avez placer une barrière')
end)

RegisterNetEvent('herse')
AddEventHandler('herse', function()
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed))

    local prop_name = 'p_ld_stinger_s'
    TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, false)
    Citizen.Wait(1000)
    ClearPedTasksImmediately(playerPed)
    ESX.Game.SpawnObject(prop_name, vector3(x, y, z - 1), function(object)
        FreezeEntityPosition(object, true)
        SetEntityHeading(object, GetEntityHeading(playerPed) + 88)
        local id = NetworkGetNetworkIdFromEntity(object)
        SetNetworkIdCanMigrate(id, true)
    end)
    TriggerServerEvent("hersedeployer", x, y, z - 1)
    ESX.ShowNotification('Vous avez placer une herse')
end)

RegisterNetEvent('plot')
AddEventHandler('plot', function()

    local prop_name = 'prop_roadcone02a'
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, false)
    Citizen.Wait(1000)
    ClearPedTasksImmediately(playerPed)
    ESX.Game.SpawnObject(prop_name, vector3(x, y, z - 1), function(object)
        FreezeEntityPosition(object, true)
        local id = NetworkGetNetworkIdFromEntity(object)
        SetNetworkIdCanMigrate(id, true)
    end)
    ESX.ShowNotification('Vous avez placer un plot')
end)

RegisterNetEvent('hersedeployere')
AddEventHandler('hersedeployere', function(x, y, z)
    table.insert(props, {
        x = x,
        y = y,
        z = z - 1
    })
end)

RegisterNetEvent('retirehersee')
AddEventHandler('retirehersee', function(deploy)
    table.remove(props, deploy)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        for k, v in pairs(props) do
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
                local dist = Vdist(x, y, z, props[k].x, props[k].y, props[k].z)
                if dist < 2.0 then
                    SetVehicleTyreBurst(vehicle, 1, true, 1000.0)
                    SetVehicleTyreBurst(vehicle, 2, true, 1000.0)
                    SetVehicleTyreBurst(vehicle, 3, true, 1000.0)
                    SetVehicleTyreBurst(vehicle, 4, true, 1000.0)
                    SetVehicleTyreBurst(vehicle, 0, true, 1000.0)
                    SetVehicleTyreBurst(vehicle, 5, true, 1000.0)
                end
            end
        end
    end
end)

function CheckQuantity(number)
    number = tonumber(number)

    if type(number) == 'number' then
        number = ESX.Math.Round(number)

        if number > 0 then
            return true, number
        end
    end

    return false, number
end

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry("LSPD_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "LSPD_INPUT", '', inputText, '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function revivePlayer()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    ESX.TriggerServerCallback('getjobambulance', function(ambulance)
        if ambulance == 0 then
            if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification("Pas de joueur")
            else
                ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                    if qtty > 0 then
                        local closestPlayerPed = GetPlayerPed(closestPlayer)
                        local health = GetEntityHealth(closestPlayerPed)
                        if health == 101 then
                            local playerPed = GetPlayerPed(-1)
                            Citizen.CreateThread(function()
                                ESX.ShowNotification("Réanimation en cour")

                                if GetEntityHealth(closestPlayerPed) == 101 then
                                    TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                                    ESX.Streaming.RequestAnimDict('mini@cpr@char_a@cpr_def', function()
                                        TaskPlayAnim(playerPed, 'mini@cpr@char_a@cpr_def', 'cpr_intro', 1.0, 1.0, 15800,
                                            0, 0, false, false, false)
                                        RemoveAnimDict('mini@cpr@char_a@cpr_def')
                                    end)
                                    Citizen.Wait(15800)
                                    TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))

                                    ESX.Streaming.RequestAnimDict('mini@cpr@char_a@cpr_str', function()
                                        TaskPlayAnim(playerPed, 'mini@cpr@char_a@cpr_str', 'cpr_success', 1.0, 1.0,
                                            33600, 0, 0, false, false, false)
                                        RemoveAnimDict('mini@cpr@char_a@cpr_str')
                                    end)
                                    ESX.ShowNotification("Geste de premier secour réussi")
                                else
                                    ESX.ShowNotification("La personne est en vie")
                                end
                            end)
                        else
                            ESX.ShowNotification("La personne est en vie")
                        end
                    else
                        ESX.ShowNotification("Pas de medikit")
                    end
                end, 'medikit')
            end
        else
            ESX.ShowNotification("Laisser les personnes plus compétente que vous sans occupé")
        end
    end)
end



function OpenBillingMenu()

    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64,"LSPD_INPUT"))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'police', amount)
                Citizen.Wait(100)
                ESX.ShowNotification("Vous avez bien envoyé la facture")
            else
                ESX.ShowNotification("Aucun joueur à proximité")
            end
        else
            ESX.ShowNotification("Montant invalide")
        end
    end
end