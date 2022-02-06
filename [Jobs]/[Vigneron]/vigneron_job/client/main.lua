local vignemap = AddBlipForCoord(-1900.32, 2060.89, 20.8)
local recolteblips = AddBlipForCoord(-1827.99, 2172.94, 107.94)
local traitementblips = AddBlipForCoord(2886.12, 4385.26, 50.63)
local venteblips = AddBlipForCoord(-2952.94, 49.8, 11.61)

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
local traitement2 = false
local traitement3 = false
local recolte = false
ESX = nil
local metier
local weighUsed

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
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
        SetBlipDisplay(recolteblips, 4)
        SetBlipDisplay(traitementblips, 4)
        SetBlipDisplay(venteblips, 4)
    else
        SetBlipDisplay(recolteblips, 0)
        SetBlipDisplay(traitementblips, 0)
        SetBlipDisplay(venteblips, 0)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
        SetBlipDisplay(recolteblips, 4)
        SetBlipDisplay(traitementblips, 4)
        SetBlipDisplay(venteblips, 4)
    else
        SetBlipDisplay(recolteblips, 0)
        SetBlipDisplay(traitementblips, 0)
        SetBlipDisplay(venteblips, 0)
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)
AddEventHandler('esx:onPlayerSpawn', function(spawn)
    isDead = false
end)

function OpenBillingMenu()

    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64,"VIGNE_INPUT"))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'vigne', amount)
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
function KeyboardInput(textEntry, inputText, maxLength,index)
    AddTextEntry(index, textEntry)
    DisplayOnscreenKeyboard(1, index, '', inputText, '', '', '', maxLength)
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

local vigne_menu = false
RMenu.Add('vigne_menu', 'main', RageUI.CreateMenu("Vigneron", "Vigne"))
RMenu.Add('vigne_menu', 'action', RageUI.CreateSubMenu(RMenu:Get('vigne_menu', 'main'), "Vigneron", "Action patron"))
RMenu:Get('vigne_menu', 'main').Closed = function()
    vigne_menu = false
end

function openVigne()
    if not vigne_menu then
        vigne_menu = true
        RageUI.Visible(RMenu:Get('vigne_menu', 'main'), true)

            while vigne_menu do
                Citizen.Wait(1)
                RageUI.IsVisible(RMenu:Get('vigne_menu', 'main'), true, true, true, function()

                    RageUI.ButtonWithStyle("Factures", "Faire une facture.", {
                        RightLabel = "→→"
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            OpenBillingMenu()
                            vigne_menu = false
                            RageUI.CloseAll()
                        end
                    end)
                    if ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Action patron", nil, {
                            RightLabel = "→"
                        }, true, function()
                        end, RMenu:Get('vigne_menu', 'action'))
                    end
                end, function()
                end)
                RageUI.IsVisible(RMenu:Get('vigne_menu', 'action'), true, true, true, function()
                    RageUI.ButtonWithStyle("Engager un employer", nil, {
                        RightLabel = nil
                    }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            if distance <= 2.0 then
                                TriggerServerEvent('Monsieur_recrute_employ', target_id, "vigne")
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
                                TriggerServerEvent('Monsieur_virer_employ', target_id, "vigne")
                            else
                                ESX.ShowNotification('Personne autour')
                            end
                        end
                    end)
                end, function()
                end)
            end
    else
        vigne_menu = false
    end
end

-- Traitement de vigne --

local vigne_traitement = false
RMenu.Add('vigne_traitement', 'main', RageUI.CreateMenu("Vigneron", "Fabrication/Arrêt"))
RMenu:Get('vigne_traitement', 'main').Closed = function()
    traitement = false
    vigne_traitement = false
end

function traitementVigne()
    if not vigne_traitement then
        vigne_traitement = true
        RageUI.Visible(RMenu:Get('vigne_traitement', 'main'), true)

            while vigne_traitement do
                Citizen.Wait(1)
                RageUI.IsVisible(RMenu:Get('vigne_traitement', 'main'), true, true, true, function()

                    RageUI.ButtonWithStyle("Jus de raisin", "1 raisin/2 jus", {
                        RightLabel = ""
                    }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if traitement2 or traitement3 then
                                ESX.ShowNotification('Vous ne pouvez pas faire 2 production en même temps')
                            else
                                if traitement then
                                    traitement = false
                                    ESX.ShowNotification('Fabrication annulée')
                                    Citizen.Wait(2000)
                                else
                                    traitement = true
                                    TriggerEvent("traitementraisin", traitement, 6, "raisin", 3, "jus_raisin")
                                    Citizen.Wait(2000)
                                end
                            end
                        end
                    end)
                    if ESX.PlayerData.job.grade_name == 'novice' or ESX.PlayerData.job.grade_name == 'cdisenior' or
                        ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Vin", "1 raisin /1 vin", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if traitement or traitement3 then
                                    ESX.ShowNotification('Vous ne pouvez pas faire 2 production en même temps')
                                else
                                if traitement2 then
                                    traitement2 = false
                                    ESX.ShowNotification('Fabrication annulée')
                                    Citizen.Wait(2000)
                                else
                                    traitement2 = true
                                    TriggerEvent("traitementraisin2", traitement2, 3, "raisin", 3, "vine")
                                    Citizen.Wait(2000)
                                end
                            end
                            end
                        end)
                    end
                    -- cadres patron
                    if ESX.PlayerData.job.grade_name == 'cdisenior' or ESX.PlayerData.job.grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Grand Crue", "5 raisin/ 1 grand crue", {
                            RightLabel = ""
                        }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if traitement2 or traitement then
                                    ESX.ShowNotification('Vous ne pouvez pas faire 2 production en même temps')
                                else
                                if traitement3 then
                                    traitement3 = false
                                    ESX.ShowNotification('Fabrication annulée')
                                    Citizen.Wait(2000)
                                else
                                    traitement3 = true
                                    TriggerEvent("traitementraisin3", traitement3, 3, "raisin", 15, "grand_cru")
                                    Citizen.Wait(2000)
                                end
                            end
                            end
                        end)
                    end
                end, function()
                end)
            end
    else
        vigne_traitement = false
    end
end
-- Key Controls
local posTraitement = {
    x = 2886.12,
    y = 4385.26,
    z = 50.63
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' and not isDead then
            local playerPed = PlayerPedId()
            if IsControlJustReleased(0, Keys["F6"]) and not vigne_menu then
                openVigne()
            end
            local plyCoords = GetEntityCoords(playerPed, false)
            local jobdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, posTraitement.x, posTraitement.y,
                posTraitement.z - 1)
            DrawMarker(1, posTraitement.x, posTraitement.y, posTraitement.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            if jobdist < 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Fabrication")
                if IsControlJustReleased(0, 38) and not IsPedSittingInAnyVehicle(PlayerPedId()) and not vigne_traitement then
                    traitementVigne()
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' and not isDead and traitement then
            local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed, false)
            local jobdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, posTraitement.x, posTraitement.y,
                posTraitement.z - 1)
            DrawMarker(1, posTraitement.x, posTraitement.y, posTraitement.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            if jobdist > 1.5 then
                traitement = false
                traitement2 = false
                traitement3 = false
                vigne_traitement = false
                ESX.ShowNotification('Fabrication annulée')
                RageUI.CloseAll()
            end
        end
    end
end)

-- récolte

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' and not isDead then
            local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed, false)
            local jobdist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -1827.99, 2172.94, 107.94)
            if jobdist < 80 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Récolter ou Stopper la récolte")
                if IsControlJustReleased(0, Keys["E"]) and recolte == false and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    TaskStartScenarioInPlace(playerPed, "world_human_gardener_plant", 0, false)
                    recolte = true
                    TriggerEvent("startRecolteRaisin", recolte)
                    ESX.ShowNotification('Récupération de ~b~raisin~s~...')
                    Citizen.Wait(2000)
                elseif IsControlJustReleased(0, Keys["E"]) and recolte == true and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    ClearPedTasks(playerPed)
                    recolte = false
                    ESX.ShowNotification('Arrêt de la récupération de ~b~raisin~s~')
                    Citizen.Wait(5000)
                end
            else
                recolte = false
            end
        end
    end
end)

----------------------------------blips

SetBlipSprite(vignemap, 85)
SetBlipColour(vignemap, 7)
SetBlipScale(vignemap, 0.90)
SetBlipAsShortRange(vignemap, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("~p~Vignerons~w~ | Société")
EndTextCommandSetBlipName(vignemap)

SetBlipSprite(recolteblips, 655)
SetBlipColour(recolteblips, 7)
SetBlipScale(recolteblips, 0.90)
SetBlipAsShortRange(recolteblips, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Récolte de raisin")
EndTextCommandSetBlipName(recolteblips)

SetBlipSprite(traitementblips, 365)
SetBlipColour(traitementblips, 7)
SetBlipScale(traitementblips, 0.90)
SetBlipAsShortRange(traitementblips, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Traitement du raisin")
EndTextCommandSetBlipName(traitementblips)

SetBlipSprite(venteblips, 500)
SetBlipColour(venteblips, 7)
SetBlipScale(venteblips, 0.90)
SetBlipAsShortRange(venteblips, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Export du Vignoble")
EndTextCommandSetBlipName(venteblips)

RegisterNetEvent('stopRecolte')
AddEventHandler('stopRecolte', function()
    recolte = false
end)

RegisterNetEvent('stopTraitement')
AddEventHandler('stopTraitement', function()
    traitement = false
    vigne_traitement = false
    traitement2 = false
    traitement3 = false
    RageUI.CloseAll()
end)

RegisterNetEvent('showNotifFabrik')
AddEventHandler('showNotifFabrik', function(itemAdd,number)
    ESX.UI.ShowInventoryItemNotification(true, itemAdd, number)
end)


AddEventHandler('startRecolteRaisin', function(recolt)
    recolte = recolt
    while recolte do
        if not IsDead then
            local raisinToAdd = math.random(1, 3)
            Citizen.Wait(2000)
            TriggerServerEvent("recolteadd", raisinToAdd, "raisin")
        else
            ESX.ShowNotification('Arrêt de la récupération de ~b~raisin~s~')
            recolte = false
        end
    end
    ClearPedTasks(PlayerPedId())
end)

AddEventHandler('traitementraisin', function(traitemen, numberAdd, itemRemoove, numberRemoove, itemAdd)
    traitement = traitemen
    while traitement do
        if not IsDead then
            Citizen.Wait(2000)
            TriggerServerEvent("traitementAdd", numberAdd, itemRemoove, numberRemoove, itemAdd)
        else
            ESX.ShowNotification('Fabrication annulée')
            traitement = false
        end
    end
end)


AddEventHandler('traitementraisin2', function(traitemen, numberAdd, itemRemoove, numberRemoove, itemAdd)
    traitement2 = traitemen
    while traitement2 do
        if not IsDead then
            Citizen.Wait(2000)
            TriggerServerEvent("traitementAdd", numberAdd, itemRemoove, numberRemoove, itemAdd)
        else
            ESX.ShowNotification('Fabrication annulée')
            traitement2 = false
        end
    end
end)

AddEventHandler('traitementraisin3', function(traitemen, numberAdd, itemRemoove, numberRemoove, itemAdd)
    traitement3 = traitemen
    while traitement3 do
        if not IsDead then
            Citizen.Wait(2000)
            TriggerServerEvent("traitementAdd", numberAdd, itemRemoove, numberRemoove, itemAdd)
        else
            ESX.ShowNotification('Fabrication annulée')
            traitement3 = false
        end
    end
end)




------ Vente Export ----------

ConfPosVignoble = {
    {
        x = -2952.94,
        y = 49.8,
        z = 10.61,
        h = 357.42
    }
}

local taxeEtat = 1.2
local prixRaisin = 1
local prixJusRaisin = 2
local prixVine = 6
local prixGrandCru = 24


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = Vdist(playerCoords, ConfPosVignoble[1].x, ConfPosVignoble[1].y, ConfPosVignoble[1].z, true)

            if distance <= 1.5 and not isDead then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Vendre des produits")
                if IsControlJustPressed(1, 51) then
                    RageUI.Visible(RMenu:Get('export_vignoble', 'main'), not RageUI.Visible(RMenu:Get('export_vignoble', 'main')))
                end
            end

            if zoneDistance ~= nil then
                if zoneDistance > 1.5 then
                    RageUI.CloseAll()
                end
            end
    end
end)

RMenu.Add('export_vignoble', 'main', RageUI.CreateMenu("Export Vignoble", "Export Vignoble" ))

Citizen.CreateThread(function()
    while true do  
        RageUI.IsVisible(RMenu:Get('export_vignoble', 'main'), true, true, true, function()
            ESX.PlayerData = ESX.GetPlayerData()

            for i = 1, #ESX.PlayerData.inventory, 1 do
                if ESX.PlayerData.inventory[i].count ~= false and (ESX.PlayerData.inventory[i].name == "raisin" or ESX.PlayerData.inventory[i].name == "jus_raisin" or ESX.PlayerData.inventory[i].name == "vine" or ESX.PlayerData.inventory[i].name == "grand_cru") then
                    if ESX.PlayerData.inventory[i].count > 0 then
                        invCount = {}
                        for i = 1, ESX.PlayerData.inventory[i].count, 1 do
                            table.insert(invCount, i)
                        end
                        if ESX.PlayerData.inventory[i].name == "raisin" then
                            prixItem = prixRaisin
                        elseif ESX.PlayerData.inventory[i].name == "jus_raisin" then
                            prixItem = prixJusRaisin
                        elseif ESX.PlayerData.inventory[i].name == "vine" then
                            prixItem = prixVine
                        elseif ESX.PlayerData.inventory[i].name == "grand_cru" then
                            prixItem = prixGrandCru
                        end
                        RageUI.ButtonWithStyle(ESX.PlayerData.inventory[i].label .. ' (' .. ESX.PlayerData.inventory[i].count .. ')', nil, { RightLabel = "~g~ ".. math.ceil(prixItem) .." $"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local valid, quantity = CheckQuantity(KeyboardInput("Quantité", "", 10,"VIGNE_INPUT_MONTANT"))
                                if not valid then
                                    ESX.ShowNotification("Quantité invalide")
                                else
                                    if quantity <= ESX.PlayerData.inventory[i].count then
                                        TriggerServerEvent('vigne:vente', ESX.PlayerData.inventory[i].name, ESX.PlayerData.inventory[i].label, quantity, prixItem)
                                    else
                                        ESX.ShowNotification("Quantité invalide")
                                    end
                                end
                            end
                        end)
                    end
                end
            end

        end, function()
        end)
        Citizen.Wait(0)
    end
end)

CreateThread(function()
    local hash = GetHashKey("u_m_m_bikehire_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(2000)
    end
    local ped = CreatePed("PED_TYPE_CIVMALE", "u_m_m_bikehire_01", ConfPosVignoble[1].x, ConfPosVignoble[1].y, ConfPosVignoble[1].z, ConfPosVignoble[1].h, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

end)