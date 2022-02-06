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
IsDead = false

local attente = 0

function OpenBillingMenu()

    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'taxi', amount)
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
function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry("TAXI_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "TAXI_INPUT", '', inputText, '', '', '', maxLength)
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

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local PlayerData = {}
local ped = PlayerPedId()

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

AddEventHandler('esx:onPlayerDeathFalse', function()
    IsDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
    IsDead = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local OnJob = false

function DrawSub(msg, time)
    ClearPrints()
    BeginTextCommandPrint('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandPrint(time, 1)
end

function ShowLoadingPromt(msg, time, type)
    Citizen.CreateThread(function()
        Citizen.Wait(0)

        BeginTextCommandBusyspinnerOn('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandBusyspinnerOn(type)
        Citizen.Wait(time)

        BusyspinnerOff()
    end)
end

function GetRandomWalkingNPC()
    local search = {}
    local peds = ESX.Game.GetPeds()

    for i = 1, #peds, 1 do
        if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
            table.insert(search, peds[i])
        end
    end

    if #search > 0 then
        return search[GetRandomIntInRange(1, #search)]
    end

    for i = 1, 250, 1 do
        local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

        if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
            table.insert(search, ped)
        end
    end

    if #search > 0 then
        return search[GetRandomIntInRange(1, #search)]
    end
end

function ClearCurrentMission()
    if DoesBlipExist(CurrentCustomerBlip) then
        RemoveBlip(CurrentCustomerBlip)
    end

    if DoesBlipExist(DestinationBlip) then
        RemoveBlip(DestinationBlip)
    end

    CurrentCustomer = nil
    CurrentCustomerBlip = nil
    DestinationBlip = nil
    IsNearCustomer = false
    CustomerIsEnteringVehicle = false
    CustomerEnteredVehicle = false
    targetCoords = nil
end

function StartTaxiJob()
    ShowLoadingPromt('Prise de service', 5000, 3)
    ClearCurrentMission()

    OnJob = true
end

function StopTaxiJob()
    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

        if CustomerEnteredVehicle then
            TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
        end
    end

    ClearCurrentMission()
    OnJob = false
    DrawSub(_U('mission_complete'), 5000)
end

RMenu.Add('taxi', 'main', RageUI.CreateMenu("Taxi", "Interaction"))
RMenu.Add('taxi', 'inter', RageUI.CreateSubMenu(RMenu:Get('taxi', 'main'), "Taxi", "Interaction"))
RMenu.Add('taxi', "annonce", RageUI.CreateSubMenu(RMenu:Get('taxi', 'main'), "Annonce", "Annonce"))
RMenu.Add('taxi', 'action', RageUI.CreateSubMenu(RMenu:Get('taxi', 'main'), "Taxi", "Action patron"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('taxi', 'main'), true, true, true, function()
            RageUI.ButtonWithStyle("Faire une facture", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    OpenBillingMenu()
                end
            end)

            RageUI.ButtonWithStyle("Start/Stop missions taxi", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    if OnJob then
                        StopTaxiJob()
                    else
                        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'taxi' then
                            local playerPed = PlayerPedId()
                            local vehicle = GetVehiclePedIsIn(playerPed, false)

                            if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                                if tonumber(ESX.PlayerData.job.grade) >= 3 then
                                    StartTaxiJob()
                                else
                                    if IsInAuthorizedVehicle() then
                                        StartTaxiJob()
                                    else
                                        RageUI.Popup({
                                            message = "Tu dois être dans un taxi !"
                                        })
                                    end
                                end
                            else
                                if tonumber(ESX.PlayerData.job.grade) >= 3 then
                                    ESX.ShowNotification(_U('must_in_vehicle'))
                                else
                                    RageUI.Popup({
                                        message = "Tu dois être dans un taxi !"
                                    })
                                end
                            end
                        end
                    end
                end
            end)

            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Action employeur", nil, {
                    RightLabel = "→"
                }, true, function()
                end, RMenu:Get('taxi', 'action'))
            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('taxi', 'action'), true, true, true, function()
            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Engager un employer", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local target, distance = ESX.Game.GetClosestPlayer()
                        local target_id = GetPlayerServerId(target)
                        if distance <= 2.0 then
                            TriggerServerEvent('Monsieur_recrute_employ', target_id, "taxi")
                        else
                            ESX.ShowNotification('Personne autour')
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Renvoyer un employer", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local target, distance = ESX.Game.GetClosestPlayer()
                        local target_id = GetPlayerServerId(target)
                        if distance <= 2.0 then
                            TriggerServerEvent('Monsieur_virer_employ', target_id, "taxi")
                        else
                            ESX.ShowNotification('Personne autour')
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' and not IsDead then
            --    RegisterNetEvent('esx_taxijob:onDuty')
            if IsControlJustReleased(0, 167) and not RageUI.Visible(RMenu:Get('taxi', 'main')) and
                not RageUI.Visible(RMenu:Get('taxi', 'inter')) and not RageUI.Visible(RMenu:Get('taxi', 'annonce')) and
                not RageUI.Visible(RMenu:Get('taxi', 'action')) then
                RageUI.Visible(RMenu:Get('taxi', 'main'), not RageUI.Visible(RMenu:Get('taxi', 'main')))
            end
        end
    end
end)

RegisterNetEvent('openf6')
AddEventHandler('openf6', function()
    RageUI.Visible(RMenu:Get('taxi', 'main'), not RageUI.Visible(RMenu:Get('taxi', 'main')))
end)

function IsInAuthorizedVehicle()
    local playerPed = PlayerPedId()
    local vehModel = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

    for i = 1, #Config.AuthorizedVehicles, 1 do
        if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
            return true
        end
    end

    return false
end

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
    TriggerEvent('esx_taxijob:unrestrain')

    if not hasAlreadyJoined then
        TriggerServerEvent('esx_taxijob:spawned')
    end
    hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

local blips = {{
    title = "~y~Taxi ~w~| Société",
    colour = 5,
    id = 198,
    x = 894.24,
    y = -180.34,
    z = 74.7
}}

Citizen.CreateThread(function()
    Citizen.Wait(0)
    local bool = true
    if bool then
        for _, info in pairs(blips) do
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite(info.blip, info.id)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 0.9)
            SetBlipColour(info.blip, info.colour)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.title)
            EndTextCommandSetBlipName(info.blip)
        end
        bool = false
    end
end)


-------------------

-- Taxi Job
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if OnJob then
            if CurrentCustomer == nil then
                DrawSub(_U('drive_search_pass'), 5000)

                if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
                    local waitUntil = GetGameTimer() + GetRandomIntInRange(15000, 20000)

                    while OnJob and waitUntil > GetGameTimer() do
                        Citizen.Wait(0)
                    end

                    if OnJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
                        CurrentCustomer = GetRandomWalkingNPC()

                        if CurrentCustomer ~= nil then
                            CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

                            SetBlipAsFriendly(CurrentCustomerBlip, true)
                            SetBlipColour(CurrentCustomerBlip, 2)
                            SetBlipCategory(CurrentCustomerBlip, 3)
                            SetBlipRoute(CurrentCustomerBlip, true)

                            SetEntityAsMissionEntity(CurrentCustomer, true, false)
                            ClearPedTasksImmediately(CurrentCustomer)
                            SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

                            local standTime = GetRandomIntInRange(1, 1)
                            TaskStandStill(CurrentCustomer, standTime)

                            ESX.ShowNotification(_U('customer_found'))
                        end
                    end
                end
            else
                if IsPedFatallyInjured(CurrentCustomer) then
                    ESX.ShowNotification(_U('client_unconcious'))

                    if DoesBlipExist(CurrentCustomerBlip) then
                        RemoveBlip(CurrentCustomerBlip)
                    end

                    if DoesBlipExist(DestinationBlip) then
                        RemoveBlip(DestinationBlip)
                    end

                    SetEntityAsMissionEntity(CurrentCustomer, false, true)

                    CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords =
                        nil, nil, nil, false, false, false, nil
                end

                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local playerCoords = GetEntityCoords(playerPed)
                    local customerCoords = GetEntityCoords(CurrentCustomer)
                    local customerDistance = #(playerCoords - customerCoords)

                    if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
                        if CustomerEnteredVehicle then
                            local targetDistance = #(playerCoords - targetCoords)

                            if targetDistance <= 10.0 then
                                TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

                                ESX.ShowNotification(_U('arrive_dest'))

                                TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z,
                                    1.0, -1, 0.0, 0.0)
                                SetEntityAsMissionEntity(CurrentCustomer, false, true)
                                TriggerServerEvent('esx_taxijob:success')
                                RemoveBlip(DestinationBlip)

                                local scope = function(customer)
                                    ESX.SetTimeout(60000, function()
                                        DeletePed(customer)
                                    end)
                                end

                                scope(CurrentCustomer)

                                CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords =
                                    nil, nil, nil, false, false, false, nil
                            end

                            if targetCoords then
                                DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0,
                                    0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
                            end
                        else
                            RemoveBlip(CurrentCustomerBlip)
                            CurrentCustomerBlip = nil
                            targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
                            local distance = #(playerCoords - targetCoords)
                            while distance < Config.MinimumDistance do
                                Citizen.Wait(5)

                                targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
                                distance = #(playerCoords - targetCoords)
                            end

                            local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y,
                                targetCoords.z))
                            local msg = nil

                            if street[2] ~= 0 and street[2] ~= nil then
                                msg = string.format(_U('take_me_to_near', GetStreetNameFromHashKey(street[1]),
                                    GetStreetNameFromHashKey(street[2])))
                            else
                                msg = string.format(_U('take_me_to', GetStreetNameFromHashKey(street[1])))
                            end

                            ESX.ShowNotification(msg)

                            DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

                            BeginTextCommandSetBlipName('STRING')
                            AddTextComponentSubstringPlayerName('Destination')
                            EndTextCommandSetBlipName(blip)
                            SetBlipRoute(DestinationBlip, true)

                            CustomerEnteredVehicle = true
                        end
                    else
                        DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0,
                            0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

                        if not CustomerEnteredVehicle then
                            if customerDistance <= 40.0 then

                                if not IsNearCustomer then
                                    ESX.ShowNotification(_U('close_to_client'))
                                    IsNearCustomer = true
                                end

                            end

                            if customerDistance <= 20.0 then
                                if not CustomerIsEnteringVehicle then
                                    ClearPedTasksImmediately(CurrentCustomer)

                                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                                    for i = maxSeats - 1, 0, -1 do
                                        if IsVehicleSeatFree(vehicle, i) then
                                            freeSeat = i
                                            break
                                        end
                                    end

                                    if freeSeat then
                                        TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
                                        CustomerIsEnteringVehicle = true
                                    end
                                end
                            end
                        end
                    end
                else
                    DrawSub(_U('return_to_veh'), 5000)
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while onJob do
        Citizen.Wait(10000)
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade < 3 then
            if not IsInAuthorizedVehicle() then
                ClearCurrentMission()
                OnJob = false
                ESX.ShowNotification(_U('not_in_taxi'))
            end
        end
    end
end)
