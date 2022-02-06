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
local camera = false
local perche = false
local micro = false
IsDead = false
local attente = 0

function OpenBillingMenu()

    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'weazel', amount)
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
    AddTextEntry("WEAZEL_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "WEAZEL_INPUT", '', inputText, '', '', '', maxLength)
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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
RMenu.Add('weazel', 'main', RageUI.CreateMenu("WeazelNews", "Interaction"))
RMenu.Add('weazel', 'inter', RageUI.CreateSubMenu(RMenu:Get('weazel', 'main'), "Weazel", "Interaction"))
RMenu.Add('weazel', 'action', RageUI.CreateSubMenu(RMenu:Get('weazel', 'main'), "Weazel", "Action patron"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('weazel', 'main'), true, true, true, function()

            RageUI.ButtonWithStyle("Annonces", nil, {
                RightLabel = "→→"
            }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('weazel', 'inter'))

            RageUI.ButtonWithStyle("Faire une facture", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    OpenBillingMenu()
                end
            end)

            RageUI.ButtonWithStyle("Sortir/Ranger la caméra", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    if micro then
                        ESX.ShowNotification("Vous avez déjà un micro")
                    elseif perche then
                        ESX.ShowNotification("Vous avez déjà une perche")
                    else
                        if not camera then
                            camera = true
                            ExecuteCommand("cam")
                        else
                            camera = false
                            ExecuteCommand("cam")
                        end
                    end
                end
            end)

            RageUI.ButtonWithStyle("Sortir/Ranger le micro", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    if camera then
                        ESX.ShowNotification("Vous avez déjà une camera")
                    elseif perche then
                        ESX.ShowNotification("Vous avez déjà une perche")
                    else
                        if not micro then
                            micro = true
                            ExecuteCommand("mic")
                        else
                            micro = false
                            ExecuteCommand("mic")
                        end
                    end
                end
            end)

            RageUI.ButtonWithStyle("Sortir/Ranger le micro perche", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    if camera then
                        ESX.ShowNotification("Vous avez déjà une camera")
                    elseif micro then
                        ESX.ShowNotification("Vous avez déjà un micro")
                    else
                        if not perche then
                            perche = true
                            ExecuteCommand("bmic")
                        else
                            perche = false
                            ExecuteCommand("bmic")
                        end
                    end
                end
            end)

            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Action patron", nil, {
                    RightLabel = "→"
                }, true, function()
                end, RMenu:Get('weazel', 'action'))
            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('weazel', 'inter'), true, true, true, function()

            RageUI.ButtonWithStyle("Info", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local info = KeyboardInput("Texte de l'info : ", "", 150)
                    if info ~= nil then
                        TriggerServerEvent('annonce_open', info, "no", "WeazelInfo")

                    end
                    RageUI.CloseAll()
                end
            end)

            RageUI.ButtonWithStyle("Flash", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local flash = KeyboardInput("Texte de la flash : ", "", 150)
                    if flash ~= nil then
                        TriggerServerEvent('annonce_open', flash, "no", "WeazelBreaking")

                    end
                    RageUI.CloseAll()
                end
            end)

            RageUI.ButtonWithStyle("Pub", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local pub = KeyboardInput("Texte de la pub : ", "", 150)
                    if pub ~= nil then
                        TriggerServerEvent('annonce_open', pub, "no", "WeazelPub")

                    end
                    RageUI.CloseAll()
                end
            end)

            RageUI.ButtonWithStyle("Annonce", nil, {
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local annonce = KeyboardInput("Texte de l'annonce : ", "", 150)
                    if annonce ~= nil then
                        TriggerServerEvent('annonce_open', annonce, "no", "WeazelAnonce")

                    end
                    RageUI.CloseAll()
                end
            end)

        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('weazel', 'action'), true, true, true, function()
            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Engager un employer", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local target, distance = ESX.Game.GetClosestPlayer()
                        local target_id = GetPlayerServerId(target)
                        if distance <= 2.0 then
                            TriggerServerEvent('Monsieur_recrute_employ', target_id, "weazel")
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
                            TriggerServerEvent('Monsieur_virer_employ', target_id, "weazel")
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'weazel' and not isDead then
            --    RegisterNetEvent('esx_journalistejob:onDuty')
            if IsControlJustReleased(0, 167) and not RageUI.Visible(RMenu:Get('weazel', 'main')) and
                not RageUI.Visible(RMenu:Get('weazel', 'action')) and not RageUI.Visible(RMenu:Get('weazel', 'inter')) then
                RageUI.Visible(RMenu:Get('weazel', 'main'), not RageUI.Visible(RMenu:Get('weazel', 'main')))
            end
        end
    end
end)

RegisterNetEvent('openf6')
AddEventHandler('openf6', function()
    RageUI.Visible(RMenu:Get('weazel', 'main'), not RageUI.Visible(RMenu:Get('weazel', 'main')))
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
    TriggerEvent('esx_journalistejob:unrestrain')

    if not hasAlreadyJoined then
        TriggerServerEvent('esx_journalistejob:spawned')
    end
    hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeathFalse', function()
    IsDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
    IsDead = true
end)

local blips = {{
    title = "Weazel News",
    colour = 1,
    id = 135,
    x = -545.97,
    y = -908.20,
    z = 23.0
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

---------------------

