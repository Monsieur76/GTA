local saladeblips = AddBlipForCoord(Config.blips.Salade.x, Config.blips.Salade.y, Config.blips.Salade.z)
local tomateblips = AddBlipForCoord(Config.blips.Tomate.x, Config.blips.Tomate.y, Config.blips.Tomate.z)
local oignonblips = AddBlipForCoord(Config.blips.Oignon.x, Config.blips.Oignon.y, Config.blips.Oignon.z)

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

local traitement = false
local recolte = false
local menu = false
local BLIP_1 = nil
local onJob = nil
local RecupDeBurger = nil
local livraison = nil
local burgerLivraison = nil
livraisonEnCours = false

ESX = nil
local metier
IsDead = false

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

AddEventHandler('esx:onPlayerDeathFalse', function()
    IsDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
    IsDead = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'burgershot' then
        SetBlipDisplay(saladeblips, 4)
        SetBlipDisplay(tomateblips, 4)
        SetBlipDisplay(oignonblips, 4)
    else
        SetBlipDisplay(saladeblips, 0)
        SetBlipDisplay(tomateblips, 0)
        SetBlipDisplay(oignonblips, 0)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'burgershot' then
        SetBlipDisplay(saladeblips, 4)
        SetBlipDisplay(tomateblips, 4)
        SetBlipDisplay(oignonblips, 4)
    else
        SetBlipDisplay(saladeblips, 0)
        SetBlipDisplay(tomateblips, 0)
        SetBlipDisplay(oignonblips, 0)
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)
AddEventHandler('esx:onPlayerSpawn', function(spawn)
    isDead = false
end)

-- facture
function OpenBillingMenu()

    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'burgershot', amount)
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
    AddTextEntry("BURGERSHOT_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "BURGERSHOT_INPUT", '', inputText, '', '', '', maxLength)
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

function randomDelivery()
    rand = math.random(1, 30)
    if onJob then
        burgerLivraison = math.random(Config.minRec, Config.maxRec)
        for k, v in ipairs(Config.deliveryBurger) do
            if v.name == rand then
                x = v.x
                y = v.y
                z = v.z-1
                name = v.name
            end
        end
        print(name)
        BLIP_1 = AddBlipForCoord(x, y, z)
        SetBlipSprite(BLIP_1, 38)
        SetBlipColour(BLIP_1, 1)
        SetBlipRoute(BLIP_1, true)
    else
        if BLIP_1 ~= nil then
            RemoveBlip(BLIP_1)
        end
    end
end

function devPointLivraison()
    onJob = true
    if onJob then
        for k, v in ipairs(Config.deliveryBurger) do
            x = v.x
            y = v.y
            z = v.z-1
            name = v.name
            DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            BLIP_1 = AddBlipForCoord(x, y, z)
            SetBlipSprite(BLIP_1, 38)
            SetBlipColour(BLIP_1, 1)
            SetBlipRoute(BLIP_1, true)
            print(name)
        end
    else
        if BLIP_1 ~= nil then
            RemoveBlip(BLIP_1)
        end
    end
end

----------------------------------blips

local burgershot = AddBlipForCoord(Config.blips.Restau.x, Config.blips.Restau.y, Config.blips.Restau.z)

SetBlipSprite(burgershot, 536)
SetBlipColour(burgershot, 1)
SetBlipScale(burgershot, 0.80)
SetBlipAsShortRange(burgershot, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("~r~Burger Shot~w~ | Société")
EndTextCommandSetBlipName(burgershot)
-- salade

SetBlipSprite(saladeblips, 655)
SetBlipColour(saladeblips, 2)
SetBlipScale(saladeblips, 0.90)
SetBlipAsShortRange(saladeblips, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Récolte de Salade")
EndTextCommandSetBlipName(saladeblips)
-- tomate
SetBlipSprite(tomateblips, 655)
SetBlipColour(tomateblips, 1)
SetBlipScale(tomateblips, 0.90)
SetBlipAsShortRange(tomateblips, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Récolte de Tomate")
EndTextCommandSetBlipName(tomateblips)
-- oignon
SetBlipSprite(oignonblips, 655)
SetBlipColour(oignonblips, 5)
SetBlipScale(oignonblips, 0.90)
SetBlipAsShortRange(oignonblips, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Récolte d'Oignon")
EndTextCommandSetBlipName(oignonblips)
-- vente
-- SetBlipSprite(venteblips, 500)
-- SetBlipColour(venteblips, 1)
-- SetBlipScale(venteblips, 0.90)
-- SetBlipAsShortRange(venteblips, true)
-- BeginTextCommandSetBlipName('STRING')
-- AddTextComponentString("Export du Burgershot")
-- EndTextCommandSetBlipName(venteblips)

-- récolte

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'burgershot' and not IsDead then

            local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed, false)
            local jobdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, 2015.31, 4886.9, 42.73)
            if jobdist < 30 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Récolte ou Stopper la récolte de salade")
                if IsControlJustReleased(0, Keys["E"]) and not recolte and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    TaskStartScenarioInPlace(playerPed, "world_human_gardener_plant", 0, false)
                    recolte = true
                    TriggerEvent("startRecolteBurger", recolte, "salade")
                    ESX.ShowNotification('Récupération de ~b~salade~s~...')
                    Citizen.Wait(2000)
                elseif IsControlJustReleased(0, Keys["E"]) and recolte and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    ClearPedTasks(playerPed)
                    recolte = false
                    ESX.ShowNotification('Arrêt de la récupération de ~b~salade~s~')
                    Citizen.Wait(5000)
                end
            end
            local jobdisttomate = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, 1897.35, 4847.73, 46.18)
            if jobdisttomate < 30 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Récolte ou Stopper la récolte de tomate")
                if IsControlJustReleased(0, Keys["E"]) and not recolte and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    TaskStartScenarioInPlace(playerPed, "world_human_gardener_plant", 0, false)
                    recolte = true
                    TriggerEvent("startRecolteBurger", recolte, "tomate")
                    ESX.ShowNotification('Récupération de ~b~tomate~s~...')
                    Citizen.Wait(2000)
                elseif IsControlJustReleased(0, Keys["E"]) and recolte and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    ClearPedTasks(playerPed)
                    recolte = false
                    ESX.ShowNotification('Arrêt de la récupération de ~b~tomate~s~')
                    Citizen.Wait(5000)
                end
            end
            local jobdistoignon = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, 1885.09, 5055.98, 49.97)
            if jobdistoignon < 30 then

                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Récolte ou Stopper la récolte d'oignon")
                if IsControlJustReleased(0, Keys["E"]) and not recolte and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    TaskStartScenarioInPlace(playerPed, "world_human_gardener_plant", 0, false)
                    recolte = true
                    TriggerEvent("startRecolteBurger", recolte, "oignon")
                    ESX.ShowNotification('Récupération de ~b~oignon~s~...')
                    Citizen.Wait(2000)

                elseif IsControlJustReleased(0, Keys["E"]) and recolte and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    ClearPedTasks(playerPed)
                    recolte = false
                    ESX.ShowNotification('Arrêt de la récupération de ~b~oignon~s~')
                    Citizen.Wait(5000)
                end
            end
        end
    end
end)

-- Fabrication de burger --

local burger_fabric = false
RMenu.Add('burger_fabric', 'main', RageUI.CreateMenu("Cuisine", "Fabrication/Arrêt"))
RMenu:Get('burger_fabric', 'main').Closed = function()
    burger_fabric = false
end

function fabricburger()
    if not burger_fabric then
        burger_fabric = true
        RageUI.Visible(RMenu:Get('burger_fabric', 'main'), true)

        Citizen.CreateThread(function()
            while burger_fabric do
                Citizen.Wait(1)
                RageUI.IsVisible(RMenu:Get('burger_fabric', 'main'), true, true, true, function()

                    RageUI.ButtonWithStyle("Couper pain", "1 pain", {
                        RightLabel = ""
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if traitement then
                                traitement = false
                                Citizen.Wait(2000)
                                ESX.ShowNotification('Fabrication annulée')
                            else
                                traitement = true
                                Citizen.Wait(2000)
                                ESX.ShowNotification('Fabrication de ~b~pain de mie~s~...')
                                TriggerEvent('fabrikBurger', traitement, "pain_de_mie")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Burger vegétarien", "2 pain de mie/ 1 oignon/ 1 salade/ 1 tomate", {
                        RightLabel = ""
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if traitement then
                                traitement = false
                                Citizen.Wait(2000)
                                ESX.ShowNotification('Fabrication annulée')
                            else
                                traitement = true
                                Citizen.Wait(2000)
                                ESX.ShowNotification('Fabrication de ~b~Burger vegétarien~s~...')
                                TriggerEvent('fabrikBurger', traitement, "veget_burger")
                            end
                        end
                    end)
                    if ESX.PlayerData.job.grade_name == 'employer' or ESX.PlayerData.job.grade_name == 'confirmed' or
                        ESX.PlayerData.job.grade_name == 'cadre' or ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Burger cannibale", "2 pain de mie/ 1 viande", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if traitement then
                                    traitement = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    traitement = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Burger cannibale~s~...')
                                    TriggerEvent("fabrikBurger", traitement, "cannibale_burger")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Burger fish", "2 pain de mie/ 1 poisson", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if traitement then
                                    traitement = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    traitement = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Burger fish~s~...')
                                    TriggerEvent("fabrikBurger", traitement, "fish_burger")
                                end
                            end
                        end)
                    end
                    if ESX.PlayerData.job.grade_name == 'confirmed' or ESX.PlayerData.job.grade_name == 'cadre' or
                        ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Better Burger", "2 pain de mie/ 1 viande/ 1 salade", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if traitement then
                                    traitement = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    traitement = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Better Burger~s~...')
                                    TriggerEvent("fabrikBurger", traitement, "Better_Burger")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Hamburger Plaza", "2 pain de mie/ 1 poisson/ 1 salade", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if traitement then
                                    traitement = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    traitement = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication d\'~b~Hamburger Plaza~s~...')
                                    TriggerEvent("fabrikBurger", traitement, "Hamburger_Plaza")
                                end
                            end
                        end)
                    end
                    if ESX.PlayerData.job.grade_name == 'cadre' or ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Burger Énervé", "2 pain de mie/ 1 viande/ 1 salade/ 1 tomate", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if traitement then
                                    traitement = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    traitement = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Burger Énervé~s~...')
                                    TriggerEvent("fabrikBurger", traitement, "Burger_Enervé")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Baby Burger", "2 pain de mie/ 1 poisson/ 1 salade/ 1 tomate", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if traitement then
                                    traitement = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    traitement = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Baby Burger~s~...')
                                    TriggerEvent("fabrikBurger", traitement, "Baby_Burger")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Burger terminator", "2 pain de mie/ 1 viande/ 1 salade/ 1 tomate/ 1 oignon", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if traitement then
                                    traitement = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    traitement = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Burger terminator~s~...')
                                    TriggerEvent("fabrikBurger", traitement, "terminator_burger")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Burger explose boyaux",
                            "2 pain de mie/ 1 poisson/ 1 salade/ 1 tomate/ 1 oignon", {
                                RightLabel = ""
                            }, true, function(Hovered, Active, Selected)
                                if (Selected) then
                                    if traitement then
                                        traitement = false
                                        Citizen.Wait(2000)
                                        ESX.ShowNotification('Fabrication annulée')
                                    else
                                        traitement = true
                                        Citizen.Wait(2000)
                                        ESX.ShowNotification('Fabrication de ~b~Burger explose boyaux~s~...')
                                        TriggerEvent("fabrikBurger", traitement, "ex_burger")
                                    end
                                end
                            end)
                    end
                end, function()
                end)
            end
        end)
    end
end

-- Fabrication de menu --

local menu_fabric = false
RMenu.Add('menu_fabric', 'main', RageUI.CreateMenu("Emballer", "Fabrication/Arrêt"))
RMenu:Get('menu_fabric', 'main').Closed = function()
    menu_fabric = false
end

function fabricmenu()
    if not menu_fabric then
        menu_fabric = true
        RageUI.Visible(RMenu:Get('menu_fabric', 'main'), true)

        Citizen.CreateThread(function()
            while menu_fabric do
                Citizen.Wait(1)
                RageUI.IsVisible(RMenu:Get('menu_fabric', 'main'), true, true, true, function()

                    RageUI.ButtonWithStyle("Menu vegétarien", "1 jus de raisin/1 Burger", {
                        RightLabel = ""
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if menu then
                                menu = false
                                Citizen.Wait(2000)
                                ESX.ShowNotification('Fabrication annulée')
                            else
                                menu = true
                                Citizen.Wait(2000)
                                ESX.ShowNotification('Fabrication de ~b~Menu vegétarien~s~...')
                                TriggerEvent("fabrikMenu", menu, "veget_burger", "menu_veget")
                            end
                        end
                    end)
                    if ESX.PlayerData.job.grade_name == 'employer' or ESX.PlayerData.job.grade_name == 'confirmed' or
                        ESX.PlayerData.job.grade_name == 'cadre' or ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Menu cannibale", "1 jus de raisin/1 Burger", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if menu then
                                    menu = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    menu = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Menu cannibale~s~...')
                                    TriggerEvent("fabrikMenu", menu, "cannibale_burger", "menu_cannibale")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Menu fish", "1 jus de raisin/1 Burger", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if menu then
                                    menu = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    menu = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Menu fish~s~...')
                                    TriggerEvent("fabrikMenu", menu, "fish_burger", "menu_fish")
                                end
                            end
                        end)
                    end
                    if ESX.PlayerData.job.grade_name == 'confirmed' or ESX.PlayerData.job.grade_name == 'cadre' or
                        ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Menu Better", "1 jus de raisin/1 Burger", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if menu then
                                    menu = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    menu = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Menu Better~s~...')
                                    TriggerEvent("fabrikMenu", menu, "Better_Burger", "menu_Better")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Menu Plaza", "1 jus de raisin/1 Burger", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if menu then
                                    menu = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    menu = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Menu Plaza~s~...')
                                    TriggerEvent("fabrikMenu", menu, "Hamburger_Plaza", "menu_Plaza")
                                end
                            end
                        end)
                    end
                    if ESX.PlayerData.job.grade_name == 'cadre' or ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Menu Énervé", "1 jus de raisin/1 Burger", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if menu then
                                    menu = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    menu = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Menu Énervé~s~...')
                                    TriggerEvent("fabrikMenu", menu, "Burger_Enervé", "menu_Enervé")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Menu Baby", "1 jus de raisin/1 Burger", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if menu then
                                    menu = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    menu = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Menu Baby~s~...')
                                    TriggerEvent("fabrikMenu", menu, "Baby_Burger", "menu_Baby")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Menu terminator", "1 jus de raisin/1 Burger", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if menu then
                                    menu = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    menu = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Menu terminator~s~...')
                                    TriggerEvent("fabrikMenu", menu, "terminator_burger", "menu_terminator")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Menu explose boyaux", "1 jus de raisin/1 Burger", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if menu then
                                    menu = false
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication annulée')
                                else
                                    menu = true
                                    Citizen.Wait(2000)
                                    ESX.ShowNotification('Fabrication de ~b~Menu explose boyaux~s~...')
                                    TriggerEvent("fabrikMenu", menu, "ex_burger", "menu_ex")
                                end
                            end
                        end)
                    end
                end, function()
                end)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'burgershot' and not IsDead then

            local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed, false)
            local jobdistmenu = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.posBurger.Traitement.x, Config.posBurger.Traitement.y,
                Config.posBurger.Traitement.z - 1)
            DrawMarker(1, Config.posBurger.Traitement.x, Config.posBurger.Traitement.y, Config.posBurger.Traitement.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            if jobdistmenu < 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Cuisiner")
                if IsControlJustReleased(0, 38) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    -- TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BBQ", 0, false)
                    fabricburger()
                end
            end
            if IsControlJustReleased(0, Keys["F6"]) then
                openBurgerMenu()
            end
            local jobdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.posBurger.Menu.x, Config.posBurger.Menu.y, Config.posBurger.Menu.z - 1)
            DrawMarker(1, Config.posBurger.Menu.x, Config.posBurger.Menu.y, Config.posBurger.Menu.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95,
                255, 255, false, 95, 255, 0, nil, nil, 0)
            if jobdist < 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Emballage")
                if IsControlJustReleased(0, 38) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    -- TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BBQ", 0, false)
                    fabricmenu()
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- menu F6--

local burgershot_menu = false
RMenu.Add('burgershot_menu', 'main', RageUI.CreateMenu("BurgerShot", "BurgerShot"))
RMenu.Add('burgershot_menu', 'action',
    RageUI.CreateSubMenu(RMenu:Get('burgershot_menu', 'main'), "BurgerShot", "Action patron"))
RMenu:Get('burgershot_menu', 'main').Closed = function()
    burgershot_menu = false
end

function openBurgerMenu()
    if not burgershot_menu then
        burgershot_menu = true
        RageUI.Visible(RMenu:Get('burgershot_menu', 'main'), true)

        Citizen.CreateThread(function()
            while burgershot_menu do
                ESX.PlayerData = ESX.GetPlayerData()
                Citizen.Wait(1)
                RageUI.IsVisible(RMenu:Get('burgershot_menu', 'main'), true, true, true, function()

                    RageUI.ButtonWithStyle("Factures", "Faire une facture.", {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            OpenBillingMenu()
                            RageUI.CloseAll()
                            burgershot_menu = false
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Débuté/Arrêter Livraison", nil, {
                        RightLabel = "→"
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if onJob then
                                onJob = false
                                RecupDeBurger = false
                                ESX.ShowNotification('Fin de la tournée de livraison.')
                            else
                                for i = 1, #ESX.PlayerData.inventory, 1 do
                                    if (ESX.PlayerData.inventory[i].count ~= false) and (ESX.PlayerData.inventory[i].name == "veget_burger") then
                                        if ESX.PlayerData.inventory[i].count > 0 then
                                            currentBurger = ESX.PlayerData.inventory[i].count
                                            print(currentBurger)
                                            if currentBurger == nil then
                                                currentBurger = 0
                                            end
                                            print(currentBurger)
                                            if currentBurger ~= 0 then
                                                onJob = true
                                                ESX.ShowNotification('Début de la tournée de livraison.')
                                            end
                                        else
                                            onJob = false
                                            RecupDeBurger = false
                                            ESX.ShowNotification('Vous avez aucun Burger sur vous.')
                                        end
                                    end
                                end
                            end
                            randomDelivery()
                            RageUI.CloseAll()
                            burgershot_menu = false
                        end
                    end)
                    -- RageUI.ButtonWithStyle("Point Livraison DEV", nil, {
                    --     RightLabel = "→→"
                    -- }, true, function(Hovered, Active, Selected)
                    --     if (Selected) then
                    --         devPointLivraison()
                    --         RageUI.CloseAll()
                    --         burgershot_menu = false
                    --     end
                    -- end)
                    if ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Action patron", nil, {
                            RightLabel = "→"
                        }, true, function()
                        end, RMenu:Get('burgershot_menu', 'action'))
                    end
                end, function()
                end)
                RageUI.IsVisible(RMenu:Get('burgershot_menu', 'action'), true, true, true, function()
                    RageUI.ButtonWithStyle("Engager un employer", nil, {
                        RightLabel = nil
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            if distance <= 2.0 then
                                TriggerServerEvent('Monsieur_recrute_employ', target_id, "burgershot")
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
                                TriggerServerEvent('Monsieur_virer_employ', target_id, "burgershot")
                            else
                                ESX.ShowNotification('Personne autour')
                            end
                        end
                    end)
                end, function()
                end)
            end
        end)
    else
        burgershot_menu = false
    end
end

RegisterNetEvent('stopRecolteBurger')
AddEventHandler('stopRecolteBurger', function()
    recolte = false
end)

RegisterNetEvent('stopTraitementBurger')
AddEventHandler('stopTraitementBurger', function()
    traitement = false
end)

RegisterNetEvent('stopTraitementMenu')
AddEventHandler('stopTraitementMenu', function()
    menu = false
end)

RegisterNetEvent('showFabrik')
AddEventHandler('showFabrik', function(itemAdd,number)
    ESX.UI.ShowInventoryItemNotification(true, itemAdd, number)
end)

AddEventHandler('startRecolteBurger', function(recolt, item)
    recolte = recolt
    while recolte do
        if not IsDead then
            local Additem = math.random(1, 3)
            Citizen.Wait(2000)
            TriggerServerEvent("recolteaddItem", Additem, item)
        else
            ESX.ShowNotification('Récolte annulée')
            recolte = false
        end
    end
    ClearPedTasks(PlayerPedId())
end)

AddEventHandler('fabrikBurger', function(traitemen, itemAdd)
    traitement = traitemen
    while traitement do
        if not IsDead then
            Citizen.Wait(2000)
            TriggerServerEvent("traitementAddBurger", itemAdd)
        else
            ESX.ShowNotification('Fabrication annulée')
            traitement = false
        end
    end
end)



AddEventHandler('fabrikMenu', function(men, itemRemoove, itemAdd)
    menu = men
    while menu do
        if not IsDead then
            Citizen.Wait(2000)
            TriggerServerEvent("traitementAddMenu", itemRemoove, itemAdd)
        else
            ESX.ShowNotification('Fabrication annulée')
            menu = false
        end
    end
end)






------ Vente Export ----------

-- ConfPosBurgershot = {
--     {
--         x = -16.53,
--         y = 216.4,
--         z = 105.74,
--         h = 89.35
--     }
-- }

-- local taxeEtat = 1.2
-- local prixBurger = 100
-- local prixJusRaisin = 5
-- local prixVine = 12
-- local prixGrandCru = 80


-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
--         local playerCoords = GetEntityCoords(PlayerPedId())
--             local distance = Vdist(playerCoords, ConfPosBurgershot[1].x, ConfPosBurgershot[1].y, ConfPosBurgershot[1].z, true)

--             if distance <= 1.5 and not isDead then
--                 ESX.ShowHelpNotification("~INPUT_CONTEXT~ Vendre des produits")
--                 if IsControlJustPressed(1, 51) then
--                     RageUI.Visible(RMenu:Get('export_burgershot', 'main'), not RageUI.Visible(RMenu:Get('export_burgershot', 'main')))
--                 end
--             end

--             if zoneDistance ~= nil then
--                 if zoneDistance > 1.5 then
--                     RageUI.CloseAll()
--                 end
--             end
--     end
-- end)

-- RMenu.Add('export_burgershot', 'main', RageUI.CreateMenu("Export Burgershot", "(Taxe Gouvernementale : 20%)" ))

-- Citizen.CreateThread(function()
--     while true do  
--         RageUI.IsVisible(RMenu:Get('export_burgershot', 'main'), true, true, true, function()
--             ESX.PlayerData = ESX.GetPlayerData()

--             for i = 1, #ESX.PlayerData.inventory, 1 do
--                 if ESX.PlayerData.inventory[i].count ~= false and (ESX.PlayerData.inventory[i].name == "veget_burger") then
--                     if ESX.PlayerData.inventory[i].count > 0 then
--                         invCount = {}
--                         for i = 1, ESX.PlayerData.inventory[i].count, 1 do
--                             table.insert(invCount, i)
--                         end
--                         if ESX.PlayerData.inventory[i].name == "veget_burger" then
--                             prixItem = prixBurger
--                         end
--                         RageUI.ButtonWithStyle(ESX.PlayerData.inventory[i].label .. ' (' .. ESX.PlayerData.inventory[i].count .. ')', nil, { RightLabel = "~g~ ".. math.ceil(prixItem*taxeEtat) .." $"}, true, function(Hovered, Active, Selected)
--                             if Selected then
--                                 local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10))
--                                 if not valid then
--                                     ESX.ShowNotification("Quantité invalide")
--                                 else
--                                     if quantity <= ESX.PlayerData.inventory[i].count then
--                                         TriggerServerEvent('burger:vente', ESX.PlayerData.inventory[i].name, ESX.PlayerData.inventory[i].label, quantity, prixItem)
--                                     else
--                                         ESX.ShowNotification("Quantité invalide")
--                                     end
--                                 end
--                             end
--                         end)
--                     end
--                 end
--             end

--         end, function()
--         end)
--         Citizen.Wait(0)
--     end
-- end)

-- CreateThread(function()
--     local hash = GetHashKey("s_m_y_chef_01")
--     while not HasModelLoaded(hash) do
--         RequestModel(hash)
--         Wait(2000)
--     end
--     local ped = CreatePed("PED_TYPE_CIVMALE", "s_m_y_chef_01", ConfPosBurgershot[1].x, ConfPosBurgershot[1].y, ConfPosBurgershot[1].z, ConfPosBurgershot[1].h, false, true)
--     SetBlockingOfNonTemporaryEvents(ped, true)
--     FreezeEntityPosition(ped, true)
--     SetEntityInvincible(ped, true)

-- end)



---------------
--- Mission ---
---------------

Citizen.CreateThread(function()
    while true do
        if onJob then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'burgershot' then
                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, x, y, z)
                DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255,
                    0, nil, nil, 0)
                inVehicle = IsPedInAnyVehicle(PlayerPedId(), false) 
                if not inVehicle then
                    if dist <= 2.0 then
                        if livraisonEnCours == false then
                            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Livrer des burgers")

                            if IsControlJustPressed(1, 51) then
                                local ped = PlayerPedId()
                                RecupDeBurger = true
                                livraisonEnCours = true
                                TriggerEvent('burger:delivery', ped)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler('burger:delivery', function()
    TriggerEvent('burger:deliveryRetrait', ped)
end)

AddEventHandler('burger:deliveryRetrait', function()
    ESX.ShowNotification("Veuillez attendre la fin de la livraison")
    -- local currentBurger = TriggerServerEvent('getBurgerAmount', Config.itemDb_name)
    -- ESX.TriggerServerCallback('getItemAmount', function(quantity)
    --     if quantity then
    --         currentBurger = quantity            
    --     end
    -- end, Config.itemDb_name)
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.Streaming.RequestStreamedTextureDict('DIA_CLIFFORD')

    ESX.PlayAnim = function(dict, anim, speed, time, flag)
        ESX.Streaming.RequestAnimDict(dict, function()
            TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, time, flag, 1, false, false, false)
        end)
    end

    obj = CreateObject(GetHashKey('prop_cs_burger_01'), 0, 0, 0, true)
    AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
    ESX.PlayAnim('mp_common', 'givetake1_a', 8.0, -1, 0)
    Wait(1000)
    DeleteEntity(obj)
    obj2 = CreateObject(GetHashKey('hei_prop_heist_cash_pile'), 0, 0, 0, true)
    AttachEntityToEntity(obj2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
    Wait(1000)
    DeleteEntity(obj2)

    for i = 1, #ESX.PlayerData.inventory, 1 do
        if (ESX.PlayerData.inventory[i].count ~= false) and (ESX.PlayerData.inventory[i].name == "veget_burger") and (ESX.PlayerData.inventory[i].count > 0) then
            currentBurger = ESX.PlayerData.inventory[i].count
        end
    end
    
    while RecupDeBurger do
        Citizen.Wait(2000)
        if currentBurger == nil then
            currentBurger = 0
            endmission()
        end
        if currentBurger > burgerLivraison then
            RecupDeBurger = false
            ESX.ShowNotification("~g~Vous avez terminé votre livraison")
            resetmission()
        else
            burgerLivraison = currentBurger
            endmission()
        end
        Citizen.Wait(0)
    end
    TriggerServerEvent("RetirerBurgerInventaire", burgerLivraison, Config.itemDb_name, Config.itemPrix, Config.itemName) 
    livraisonEnCours = false
end)

function resetmission()
    RemoveBlip(BLIP_1)
    BLIP_1 = nil
    onJob = true
    randomDelivery()
end

function endmission()
    RemoveBlip(BLIP_1)
    BLIP_1 = nil
    onJob = false
    RecupDeBurger = false
    ESX.ShowNotification('Fin de la tournée de livraison.')
end