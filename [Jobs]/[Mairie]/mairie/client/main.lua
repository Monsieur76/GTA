local mairieBlips = AddBlipForCoord(-545.51, -203.73, 37.21)
local tribunalBlips = AddBlipForCoord(243.44, -1073.91, 29.29)
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

isDead = false
local traitement = false
local recolte = false
ESX = nil
local metier

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)
AddEventHandler('esx:onPlayerSpawn', function(spawn)
    isDead = false
end)

function OpenBillingMenu()

    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'mairie', amount)
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
    AddTextEntry("MAIRIE_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "MAIRIE_INPUT", '', inputText, '', '', '', maxLength)
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

-- menu F6--

local mairie_menu = false
RMenu.Add('mairie_menu', 'main', RageUI.CreateMenu("Mairie", "mairie"))
RMenu.Add('mairie_menu', 'action', RageUI.CreateSubMenu(RMenu:Get('mairie_menu', 'main'), "Mairie", "Action patron"))
RMenu:Get('mairie_menu', 'main').Closed = function()
    mairie_menu = false
end

function openMairie()
    if not mairie_menu then
        mairie_menu = true
        RageUI.Visible(RMenu:Get('mairie_menu', 'main'), true)

        Citizen.CreateThread(function()
            while mairie_menu do
                Citizen.Wait(1)
                RageUI.IsVisible(RMenu:Get('mairie_menu', 'main'), true, true, true, function()

                    RageUI.ButtonWithStyle("Factures", "Faire une facture.", {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            OpenBillingMenu()
                            mairie_menu = false
                            RageUI.CloseAll()
                        end
                    end)
                    if ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Action patron", nil, {
                            RightLabel = "→"
                        }, true, function()
                        end, RMenu:Get('mairie_menu', 'action'))
                    end
                end, function()
                end)
                RageUI.IsVisible(RMenu:Get('mairie_menu', 'action'), true, true, true, function()
                    RageUI.ButtonWithStyle("Engager un employé", nil, {
                        RightLabel = nil
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            if distance <= 2.0 then
                                TriggerServerEvent('Monsieur_recrute_employ', target_id, "mairie")
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
                                TriggerServerEvent('Monsieur_virer_employ', target_id, "mairie")
                            else
                                ESX.ShowNotification('Personne autour')
                            end
                        end
                    end)
                end, function()
                end)
            end
        end)
    end
end

-- F6 + vente --

local poscartegrise = {
    x = -549.65,
    y = -190.15,
    z = 38.22
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mairie' and not IsDead then
            local playerPed = PlayerPedId()
            if IsControlJustReleased(0, Keys["F6"]) then
                openMairie()
            end
            local plyCoords = GetEntityCoords(playerPed, false)
            local jobdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, poscartegrise.x, poscartegrise.y,
                poscartegrise.z - 1)
            DrawMarker(1, poscartegrise.x, poscartegrise.y, poscartegrise.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            if jobdist < 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Ventes de véhicules entre particuliers")
                if IsControlJustReleased(0, Keys["E"]) then
                    ventevehicle()
                end
            end
        end
    end
end)
function formatFirstnameName(str)
    local splittedName = split(str, '%s+')
    if #splittedName == 2 then
        return splittedName[1]:gsub("^%l", string.upper) .." ".. splittedName[2]:gsub("^%l", string.upper)
    else
        return " "
    end
end
function split(pString, pPattern)
    local Table = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table, cap)
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end
function ventevehicle()
    local nameSell = KeyboardInput('Prénom et Nom du vendeur (n\'oubliez pas les caractères spéciaux) : ', '', 64)
    if nameSell ~= nil then
        nameSell = formatFirstnameName(nameSell)
        ESX.TriggerServerCallback('mairie:retrivename', function(identifierSell)
            if identifierSell then
                local plate = KeyboardInput('Plaque d\'immatriculation de la voiture à vendre : ', '', 8)
                if plate ~= nil then
                    plate = string.upper(plate)
                    if string.len(plate) == 8 then
                        ESX.TriggerServerCallback('mairie:retriveplate', function(model)
                            if model then
                                local nameBuy = KeyboardInput('Prénom et Nom de l\'acheteur (n\'oubliez pas les caractères spéciaux)',
                                    '', 64)
                                if nameBuy ~= nil then
                                    nameBuy = formatFirstnameName(nameBuy)
                                    ESX.TriggerServerCallback('mairie:retrivename', function(identifierBuy)
                                        if identifierBuy then
                                            if identifierSell ~= identifierBuy then
                                                TriggerServerEvent("mairie:debutvente", identifierSell, plate,
                                                    identifierBuy, nameSell, nameBuy, model)
                                            else
                                                ESX.ShowNotification("L'acheteur et le vendeur doivent être une personne différente")
                                            end
                                        else
                                            ESX.ShowNotification("Nous n'avons pas trouvé cette personne")
                                        end
                                    end, nameBuy)
                                end
                            else
                                ESX.ShowNotification("Nous n'avons pas trouvé cette personne")
                            end
                        end, identifierSell, plate)
                    else
                        ESX.ShowNotification("Plaque invalide")
                    end
                end
            else
                ESX.ShowNotification("Nous n'avons pas trouvé cette personne")
            end
        end, nameSell)
    end
    -- TriggerServerEvent("mairie:debutvente")
end

local calculate
local papier
RegisterNetEvent('mairie:ventevehicleowner')
AddEventHandler('mairie:ventevehicleowner',
    function(identifierSell, plate, identifierBuy, nameSell, nameBuy, model, mairie)
        Citizen.CreateThread(function()
            papier = true
            calculate = 0
            while papier do
                Citizen.Wait(1)
                calculate = calculate + 1
                if papier then
                    if calculate >= 1500 then
                        TriggerServerEvent("mairie:refuseSell", identifierSell, plate, identifierBuy, nameSell, nameBuy,
                            model, mairie)
                        ESX.ShowNotification("Vous n'avez pas signé")
                        papier = false
                    end
                    if IsControlJustPressed(0, 246) then
                        TriggerServerEvent("mairie:acceptSell", identifierSell, plate, identifierBuy, nameSell, nameBuy,
                            model, mairie)
                        ESX.ShowNotification("Papiers signés")
                        papier = false
                    elseif IsControlJustPressed(0, 249) or IsControlJustPressed(0, 306) then
                        TriggerServerEvent("mairie:refuseSell", identifierSell, plate, identifierBuy, nameSell, nameBuy,
                            model, mairie)
                        ESX.ShowNotification("Vous n'avez pas signé")
                        papier = false
                    end
                end
            end
        end)
    end)

local calculate2
local papier2
RegisterNetEvent('mairie:ventevehiclebuyer')
AddEventHandler('mairie:ventevehiclebuyer',
    function(identifierSell, plate, identifierBuy, nameSell, nameBuy, model, mairie)
        Citizen.CreateThread(function()
            papier2 = true
            calculate2 = 0
            while papier2 do
                Citizen.Wait(1)
                calculate2 = calculate2 + 1
                if papier2 then
                    if calculate2 >= 1500 then
                        TriggerServerEvent("mairie:refuseBuy", identifierSell, plate, identifierBuy, nameSell, nameBuy,
                            model, mairie)
                        ESX.ShowNotification("Vous n'avez pas signé")
                        papier2 = false
                    end
                    if IsControlJustPressed(0, 246) then
                        TriggerServerEvent("mairie:acceptBuy", identifierSell, plate, identifierBuy, nameSell, nameBuy,
                            model, mairie)
                        ESX.ShowNotification("Papiers signés")
                        papier2 = false
                    elseif IsControlJustPressed(0, 249) or IsControlJustPressed(0, 306) then
                        TriggerServerEvent("mairie:refuseBuy", identifierSell, plate, identifierBuy, nameSell, nameBuy,
                            model, mairie)
                        ESX.ShowNotification("Vous n'avez pas signé")
                        papier2 = false
                    end
                end
            end
        end)
    end)

----------------------------------blips

SetBlipSprite(mairieBlips, 419)
SetBlipScale(mairieBlips, 0.90)
SetBlipAsShortRange(mairieBlips, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Mairie")
EndTextCommandSetBlipName(mairieBlips)

SetBlipSprite(tribunalBlips, 770)
SetBlipColour(tribunalBlips, 76)
SetBlipScale(tribunalBlips, 0.90)
SetBlipAsShortRange(tribunalBlips, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Tribunal")
EndTextCommandSetBlipName(tribunalBlips)
