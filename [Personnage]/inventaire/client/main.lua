ESX = nil

local weighUsed = 0
local bag = 0
local itemIndex = 1
local name
local count
local usable
local label
local vente
local invCount = {}
Player = {
    isDead = false
}

local Keys = {
    ['ESC'] = 322,
    ['F1'] = 288,
    ['F2'] = 289,
    ['F3'] = 170,
    ['F5'] = 166,
    ['F6'] = 167,
    ['F7'] = 168,
    ['F8'] = 169,
    ['F9'] = 56,
    ['F10'] = 57,
    ['~'] = 243,
    ['1'] = 157,
    ['2'] = 158,
    ['3'] = 160,
    ['4'] = 164,
    ['5'] = 165,
    ['6'] = 159,
    ['7'] = 161,
    ['8'] = 162,
    ['9'] = 163,
    ['-'] = 84,
    ['='] = 83,
    ['BACKSPACE'] = 177,
    ['TAB'] = 37,
    ['Q'] = 44,
    ['W'] = 32,
    ['E'] = 38,
    ['R'] = 45,
    ['T'] = 245,
    ['Y'] = 246,
    ['U'] = 303,
    ['P'] = 199,
    ['['] = 39,
    [']'] = 40,
    ['ENTER'] = 18,
    ['CAPS'] = 137,
    ['A'] = 34,
    ['S'] = 8,
    ['D'] = 9,
    ['F'] = 23,
    ['G'] = 47,
    ['H'] = 74,
    ['K'] = 311,
    ['L'] = 182,
    ['LEFTSHIFT'] = 21,
    ['Z'] = 20,
    ['X'] = 73,
    ['C'] = 26,
    ['V'] = 0,
    ['B'] = 29,
    ['N'] = 249,
    ['M'] = 244,
    [','] = 82,
    ['.'] = 81,
    ['LEFTCTRL'] = 36,
    ['LEFTALT'] = 19,
    ['SPACE'] = 22,
    ['RIGHTCTRL'] = 70,
    ['HOME'] = 213,
    ['PAGEUP'] = 10,
    ['PAGEDOWN'] = 11,
    ['DELETE'] = 178,
    ['LEFT'] = 174,
    ['RIGHT'] = 175,
    ['TOP'] = 27,
    ['DOWN'] = 173,
    ['NENTER'] = 201,
    ['N4'] = 108,
    ['N5'] = 60,
    ['N6'] = 107,
    ['N+'] = 96,
    ['N-'] = 97,
    ['N7'] = 117,
    ['N8'] = 61,
    ['N9'] = 118
}

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

    ESX.PlayerData = ESX.GetPlayerData()
end)

--[[RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    local done = false
    while not done do
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.bags_1 ~= nil and skin.bags_1 ~= -1 and skin.bags_1 ~= 0 then
                bag = Config.WeightWithBag
                TriggerServerEvent("weightextended", Config.WeightWithBag)
            else
                bag = Config.Weight
                TriggerServerEvent("weightextended", Config.Weight)
            end
            done = true
        end)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)]] --

AddEventHandler('esx:onPlayerDeath', function()
    Player.isDead = true
    RageUI.CloseAll()
    ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx:onPlayerDeathFalse', function()
    Player.isDead = false
end)

AddEventHandler('playerSpawned', function()
    Player.isDead = false
end)

function menucreat()
    RMenu.Add('inventaireTales', 'debut',
        RageUI.CreateMenu("Inventaire", "Capacité : " .. weighUsed .. "kg / " .. bag .. "kg"))
    RMenu.Add('inventaireTales', 'itemavoir', RageUI.CreateSubMenu(RMenu:Get('inventaireTales', 'debut'), "Action",
        "Capacité : " .. weighUsed .. "kg / " .. bag .. "kg"))
end

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('inventaireTales', 'debut'), true, true, true, function()
            ESX.PlayerData = ESX.GetPlayerData()
            local money = nil
            local blackmoney = nil
            for i = 1, #ESX.PlayerData.accounts, 1 do
                if ESX.PlayerData.accounts[i].name == 'money' then
                    money = ESX.PlayerData.accounts[i].money
                elseif ESX.PlayerData.accounts[i].name == 'black_money' then
                    blackmoney = ESX.PlayerData.accounts[i].money
                end
            end
            local moneyy = money + blackmoney
            RageUI.ButtonWithStyle(moneyy .. "$", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    local post, quantity = CheckQuantity(KeyboardInput('Saisissez la somme à donner', '', 8))
                    if quantity ~= nil then
                        if post then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestDistance ~= -1 and closestDistance <= 3 then
                                local closestPed = GetPlayerPed(closestPlayer)
                                local plyPed = PlayerPedId()

                                TriggerServerEvent('inventoryprendre', GetPlayerServerId(closestPlayer))
                                ESX.TriggerServerCallback('payement', function(prix, black, money)
                                    if prix == "bon" then
                                        ESX.Streaming.RequestAnimDict("mp_common", function()
                                            TaskPlayAnim(plyPed, "mp_common", "givetake1_a", 8.0, 1.0, -1, 49, 0, false,
                                                false, false)
                                            RemoveAnimDict("mp_common")
                                        end)
                                        Citizen.Wait(1500)
                                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer),
                                            'item_account', 'black_money', quantity)
                                        TriggerServerEvent('Notifymoney', GetPlayerServerId(closestPlayer), quantity)
                                        Citizen.Wait(1500)
                                        ClearPedTasks(plyPed)
                                    elseif prix == "double" then

                                        ESX.Streaming.RequestAnimDict("mp_common", function()
                                            TaskPlayAnim(plyPed, "mp_common", "givetake1_a", 8.0, 1.0, -1, 49, 0, false,
                                                false, false)
                                            RemoveAnimDict("mp_common")
                                        end)
                                        Citizen.Wait(1500)
                                        prix2 = quantity - black
                                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer),
                                            'item_account', 'money', prix2)
                                        prixBlack = quantity - prix2
                                        if black > 0 then
                                            TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer),
                                                'item_account', 'black_money', prixBlack)
                                        end
                                        TriggerServerEvent('Notifymoney', GetPlayerServerId(closestPlayer), quantity)
                                        Citizen.Wait(1500)
                                        ClearPedTasks(plyPed)

                                    else
                                        ESX.ShowNotification("Vous n'avez pas assez d'argent")
                                    end
                                end, quantity)
                            else
                                ESX.ShowNotification("Personne autour")
                            end
                        else
                            ESX.ShowNotification("Montant invalide")
                        end
                    end
                end
            end)

            for i = 1, #ESX.PlayerData.inventory, 1 do
                if ESX.PlayerData.inventory[i].count ~= false then
                    if ESX.PlayerData.inventory[i].count > 0 then
                        invCount = {}
                        for i = 1, ESX.PlayerData.inventory[i].count, 1 do
                            table.insert(invCount, i)
                        end
                        RageUI.ButtonWithStyle(ESX.PlayerData.inventory[i].label .. ' (' ..
                                                   ESX.PlayerData.inventory[i].count .. ')', nil, {
                            RightLabel = "→"
                        }, true, function(Hovered, Active, Selected)
                            if Selected then
                                name = ESX.PlayerData.inventory[i].name
                                count = ESX.PlayerData.inventory[i].count
                                label = ESX.PlayerData.inventory[i].label
                                usable = ESX.PlayerData.inventory[i].usable
                                vente = ESX.PlayerData.inventory[i].vente
                                -- logo = ESX.PlayerData.inventory[i].logo
                            end
                        end, RMenu:Get('inventaireTales', 'itemavoir'))
                    end
                end
            end
        end, function()
        end, 1)
        RageUI.IsVisible(RMenu:Get('inventaireTales', 'itemavoir'), true, true, true, function()
            RageUI.ButtonWithStyle("Utiliser", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    if usable then
                        TriggerServerEvent('esx:useItem', name)
                    else
                        ESX.ShowNotification("Pas utilisable")
                    end
                end
            end)
            if name == "weed_pooch" or name == "opium_pooch" or name == "meth_pooch" or name == "coke_pooch" then
                RageUI.ButtonWithStyle("Vendre", nil, {
                    RightLabel = "→"
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        if vente then
                            TriggerServerEvent('esx:SellItem', name)
                        else
                            ESX.ShowNotification("Pas utilisable")
                        end
                    end
                end)
            end

            RageUI.ButtonWithStyle("Donner", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    local post, quantity = CheckQuantity(KeyboardInput('Saisissez la quantité à donner', '', 8))
                    if quantity ~= nil then
                        if post and quantity > 0 and quantity <= count then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestDistance ~= -1 and closestDistance <= 3 then
                                local plyPed = PlayerPedId()
                                TriggerServerEvent('inventoryprendre', GetPlayerServerId(closestPlayer))
                                ESX.Streaming.RequestAnimDict("mp_common", function()
                                    TaskPlayAnim(plyPed, "mp_common", "givetake1_a", 8.0, 1.0, -1, 49, 0, false, false,
                                        false)
                                    RemoveAnimDict("mp_common")
                                end)
                                Citizen.Wait(3000)
                                TriggerServerEvent('giveiventoryitem', GetPlayerServerId(closestPlayer), name, label,
                                    quantity)
                                ClearPedTasks(plyPed)
                                RageUI.CloseAll()
                            else
                                ESX.ShowNotification("Personne autour")
                            end
                        else
                            ESX.ShowNotification("Montant invalide")
                        end
                    end
                end
            end)
        end, function()
        end, 1)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, Config.Controls.ouvrirMenu.keyboard) and
            not RageUI.Visible(RMenu:Get('inventaireTales', 'debut')) and
            not RageUI.Visible(RMenu:Get('inventaireTales', 'itemavoir')) and not Player.isDead then
            ESX.PlayerData = ESX.GetPlayerData()
            weighUsed = 0
            if bag == 0 then
                bag = nil
            end
            if ESX.PlayerData.maxWeight ~= nil then
                bag = ESX.PlayerData.maxWeight
            else
                bag = bag or 100
            end

            for k, v in pairs(ESX.PlayerData.inventory) do
                if v.count ~= false then
                    if v.count > 0 then
                        weighUsed = weighUsed + (v.weight * v.count)
                    end
                end
            end
            menucreat()
            RageUI.Visible(RMenu:Get('inventaireTales', 'debut'),
                not RageUI.Visible(RMenu:Get('inventaireTales', 'debut')))
        else
            if (RageUI.Visible(RMenu:Get('inventaireTales', 'debut')) or
                RageUI.Visible(RMenu:Get('inventaireTales', 'itemavoir'))) and
                IsControlJustPressed(1, Config.Controls.ouvrirMenu.keyboard) then
                RageUI.CloseAll()
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
    AddTextEntry("INVENTORY_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "INVENTORY_INPUT", '', inputText, '', '', '', maxLength)
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

RegisterNetEvent('animationtarget')
AddEventHandler('animationtarget', function(target)
    local plyPed = PlayerPedId()
    ESX.Streaming.RequestAnimDict("mp_common", function()
        TaskPlayAnim(plyPed, "mp_common", "givetake1_a", 8.0, 1.0, -1, 49, 0, false, false, false)
        RemoveAnimDict("mp_common")
    end)
    Citizen.Wait(3000)
    ClearPedTasks(plyPed)
end)
