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

local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy = false
local PlayerData = {}
local IsHandcuffed = false
local blips = {{
    title = "Hôpital ~r~LSMS~s~",
    colour = 1,
    id = 61,
    x = 293.241,
    y = -599.816,
    z = 43.30
}}
IsDead = false
local CopPed
local escorter = false
local courir = false
local sauter = false
local conduire = false
ESX = nil
local PlayerData = {}
local ped = PlayerPedId()
local vehicle = GetVehiclePedIsIn(ped, false)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
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
    data = ESX.PlayerData.maladie
    if data ~= nil then
        for k, v in pairs(data) do
            if v == "courir" then
                courir = true
            end
            if v == "conduire" then
                conduire = true
            end
            if v == "sauter" then
                sauter = true
            end
        end
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    local bool = true
    if bool then
        for _, info in pairs(blips) do
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite(info.blip, info.id)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 1.1)
            SetBlipColour(info.blip, info.colour)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.title)
            EndTextCommandSetBlipName(info.blip)
        end
        bool = false
    end

end)

RMenu.Add('enos', 'main', RageUI.CreateMenu("LSMS", "Interaction"))
RMenu.Add('enos', "incapacite", RageUI.CreateSubMenu(RMenu:Get('enos', 'main'), "Incapacite", "Mettre une Incapacite"))
-- RMenu.Add('enos', "annonce", RageUI.CreateSubMenu(RMenu:Get('enos', 'main'),"Annonce" ,"Annonce" ))
-- RMenu.Add('enos', 'ambulance', RageUI.CreateMenu("Ambulance", "Ambulance Garage"))
RMenu.Add('enos', 'action', RageUI.CreateSubMenu(RMenu:Get('enos', 'main'), "LSMS", "Action patron"))

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
            if IsControlJustReleased(0, 167) and not RageUI.Visible(RMenu:Get('enos', 'main')) and
                not RageUI.Visible(RMenu:Get('enos', "incapacite")) and not RageUI.Visible(RMenu:Get('enos', "annonce")) and
                not RageUI.Visible(RMenu:Get('enos', 'ambulance')) and not RageUI.Visible(RMenu:Get('enos', 'action'))and not IsDead then
                RageUI.Visible(RMenu:Get('enos', 'main'), not RageUI.Visible(RMenu:Get('enos', 'main')))
            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('enos', 'main'), true, true, true, function()

            RageUI.ButtonWithStyle("Donner une facture", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    OpenBillingMenu()
                end
            end)

            RageUI.ButtonWithStyle("Réanimer le patient", nil, {
                RightBadge = RageUI.BadgeStyle.Heart
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    revivePlayer(closestPlayer)
                end
            end)

            RageUI.ButtonWithStyle("Soigner le patient", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    heal()
                end
            end)

            --RageUI.ButtonWithStyle("Mettre/retirer en peignoir", nil, {
            --    RightLabel = nil
            --}, true, function(Hovered, Active, Selected)
            --    if Selected then
            --        heal()
            --    end
            --end)

            RageUI.ButtonWithStyle("Escorter", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    playerheading = GetEntityHeading(PlayerPedId())
                    playerlocation = GetEntityForwardVector(PlayerPedId())
                    playerCoords = GetEntityCoords(PlayerPedId())
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 then
                        TriggerServerEvent('escorte', target_id)
                    else
                        ESX.ShowNotification('Personne autour')
                    end
                end
            end)
            -- if escorter then
            RageUI.ButtonWithStyle("Mettre dans un véhicule", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 then
                        TriggerServerEvent('mettrevehicule', target_id)
                    else
                        ESX.ShowNotification('Personne autour')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Retirer/Mettre les plots ", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
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

            RageUI.ButtonWithStyle("Incapacité", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('enos', 'incapacite'))
            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Action patron", nil, {
                    RightLabel = "→"
                }, true, function()
                end, RMenu:Get('enos', 'action'))
            end
            -- RageUI.ButtonWithStyle("Annonce", nil, {RightLabel = "→"},true, function()
            -- end, RMenu:Get('enos', 'annonce'))

        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('enos', 'incapacite'), true, true, true, function()
            RageUI.ButtonWithStyle("Courir", "Autoriser / Empêcher", {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    local playerPed = PlayerPedId()
                    if distance <= 2.0 then
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent("incapacite", "courir", target_id, courir)
                        ClearPedTasksImmediately(playerPed)
                    else
                        ESX.ShowNotification("Personne autour de vous")
                    end
                end
            end)
            RageUI.ButtonWithStyle("Sauter", "Autoriser / Empêcher", {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    local playerPed = PlayerPedId()
                    if distance <= 2.0 then
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent("incapacite", "sauter", target_id, sauter)
                        ClearPedTasksImmediately(playerPed)
                    else
                        ESX.ShowNotification("Personne autour de vous")
                    end
                end
            end)
            RageUI.ButtonWithStyle("Conduire", "Autoriser / Empêcher", {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    local playerPed = PlayerPedId()
                    if distance <= 2.0 then
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', -1, true)
                        Citizen.Wait(10000)
                        TriggerServerEvent("incapacite", "conduire", target_id, conduire)
                        ClearPedTasksImmediately(playerPed)
                    else
                        ESX.ShowNotification("Personne autour de vous")
                    end
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('enos', 'action'), true, true, true, function()
            RageUI.ButtonWithStyle("Engager un employé", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 then
                        TriggerServerEvent('Monsieur_recrute_employ', target_id, "ambulance")
                    else
                        ESX.ShowNotification('Personne autour')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Renvoyer un employé", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 then
                        TriggerServerEvent('Monsieur_virer_employ', target_id, "ambulance")
                    else
                        ESX.ShowNotification('Personne autour')
                    end
                end
            end)

        end, function()
        end)

        Citizen.Wait(0)
    end
end)

function WarpPedInClosestVehicle(ped)
    local coords = GetEntityCoords(ped)

    local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

    if distance ~= -1 and distance <= 5.0 then
        local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

        for i = maxSeats - 1, 0, -1 do
            if IsVehicleSeatFree(vehicle, i) then
                freeSeat = i
                break
            end
        end

        if freeSeat then
            TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
        end
    else
        ESX.ShowNotification(_U('no_vehicles'))
    end
end

function revivePlayer(closestPlayer)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 3.0 then
        ESX.ShowNotification(_U('no_players'))
    else
        ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
            if qtty > 0 then
                local closestPlayerPed = GetPlayerPed(closestPlayer)
                local health = GetEntityHealth(closestPlayerPed)
                if health == 101 then
                    local playerPed = PlayerPedId()
                    Citizen.CreateThread(function()
                        ESX.ShowNotification(_U('revive_inprogress'))

                        if GetEntityHealth(closestPlayerPed) == 101 then
                            TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                            ESX.Streaming.RequestAnimDict('mini@cpr@char_a@cpr_def', function()
                                TaskPlayAnim(playerPed, 'mini@cpr@char_a@cpr_def', 'cpr_intro', 1.0, 1.0, 15800, 0, 0,
                                    false, false, false)
                                RemoveAnimDict('mini@cpr@char_a@cpr_def')
                            end)
                            Citizen.Wait(15800)
                            TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))

                            ESX.Streaming.RequestAnimDict('mini@cpr@char_a@cpr_str', function()
                                TaskPlayAnim(playerPed, 'mini@cpr@char_a@cpr_str', 'cpr_success', 1.0, 1.0, 33600, 0, 0,
                                    false, false, false)
                                RemoveAnimDict('mini@cpr@char_a@cpr_str')
                            end)
                            ESX.ShowNotification(_U('revive_complete'))
                        else
                            ESX.ShowNotification(_U('isdead'))
                        end
                    end)
                else
                    ESX.ShowNotification(_U('unconscious'))
                end
            else
                ESX.ShowNotification(_U('not_enough_medikit'))
            end
        end, 'medikit')
    end
end

function heal()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 1.0 then
        ESX.ShowNotification(_U('no_players'))
    else
        ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
            if quantity > 0 then
                local closestPlayerPed = GetPlayerPed(closestPlayer)
                local health = GetEntityHealth(closestPlayerPed)
                if health >= 102 then
                    local playerPed = PlayerPedId()
                    -- isBusy = true
                    ESX.ShowNotification(_U('heal_inprogress'))
                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                    Citizen.Wait(10000)
                    ClearPedTasks(playerPed)

                    TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
                    TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
                    -- isBusy = false
                else
                    ESX.ShowNotification(_U('player_not_conscious'))
                end
            else
                ESX.ShowNotification(_U('not_enough_bandage'))
            end
        end, 'bandage')
    end
end

AddEventHandler('esx:onPlayerDeath', function()
    OnPlayerDeath()
end)

-- AddEventHandler('esx:onPlaye', function()
-- local playerPed = PlayerPedId()
-- print(ESX.PlayerData.canne)
-- TriggerServerEvent("incapacite","conduire", playerPed)
-- end)

RegisterNetEvent('incapacitevu')
AddEventHandler('incapacitevu', function(inca)
    local playerPed = PlayerPedId()
    if inca == "courir" then
        if courir then
            courir = false
            ESX.ShowNotification("Vous pouvez à nouveau courir")
        else
            courir = true
            ESX.ShowNotification("Vous ne pouvez plus courir")
        end
    elseif inca == "sauter" then
        if sauter then
            sauter = false
            ESX.ShowNotification("Vous pouvez à nouveau sauter")
        else
            sauter = true
            ESX.ShowNotification("Vous ne pouvez plus sauter")
        end
    elseif inca == "conduire" then
        if conduire then
            conduire = false
            ESX.ShowNotification("Vous pouvez à nouveau conduire")
        else
            conduire = true
            ESX.ShowNotification("Vous ne pouvez plus conduire")
        end
    end
end)

local health = false

RegisterNetEvent('esx_ambulancejob:hea')
AddEventHandler('esx_ambulancejob:hea', function(healType, quiet)
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 200)
    ClearPedBloodDamage(playerPed)
    if not quiet then
        ESX.ShowNotification(_U('healed'))
    end
end)

RegisterNetEvent('mettrevehiculeclient')
AddEventHandler('mettrevehiculeclient', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        escorter = false
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

RegisterNetEvent('escorterr')
AddEventHandler('escorterr', function(cop)
    if escorter then
        escorter = false
    else
        escorter = true
    end
    CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if escorter then
            local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
            local myped = PlayerPedId()
            AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            SetPedCanPlayGestureAnims(playerPed, false)
            FreezeEntityPosition(playerPed, true)
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(2, 37, true)
        else
            DetachEntity(PlayerPedId(), true, false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if courir then
            DisableControlAction(0, 21, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if sauter then
            DisableControlAction(0, 22, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if conduire then
            DisableControlAction(0, 71, true)
            DisableControlAction(0, 72, true)
        end
    end
end)
function OpenBillingMenu()

    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'ambulance', amount)
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
    AddTextEntry("LSMS_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "LSMS_INPUT", '', inputText, '', '', '', maxLength)
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



-- 

RegisterNetEvent('healAdmin')
AddEventHandler('healAdmin', function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 200)
end)

RegisterNetEvent('reviveAdmin')
AddEventHandler('reviveAdmin', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

    Citizen.CreateThread(function()

        ESX.SetPlayerData('lastPosition', {
            x = coords.x,
            y = coords.y,
            z = coords.z
        })

        TriggerServerEvent('esx:updateLastPosition', {
            x = coords.x,
            y = coords.y,
            z = coords.z
        })

        RespawnPed(playerPed, {
            x = coords.x,
            y = coords.y,
            z = coords.z
        }, heading)

    end)
end)