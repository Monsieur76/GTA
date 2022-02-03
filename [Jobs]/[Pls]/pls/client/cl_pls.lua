ESX = nil
IsDead = false
local done = false
local plsSociety = AddBlipForCoord(560.96, 2793.97, 42.11)
SetBlipSprite(plsSociety, 739)
SetBlipColour(plsSociety, 47)
SetBlipScale(plsSociety, 0.99)
SetBlipAsShortRange(plsSociety, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("~o~Ron~s~ | Société")
EndTextCommandSetBlipName(plsSociety)
local mstpetrol = AddBlipForCoord(2778.91, 1708.44, 24.58)
SetBlipSprite(mstpetrol, 436)
SetBlipColour(mstpetrol, 47)
SetBlipScale(mstpetrol, 0.99)
SetBlipAsShortRange(mstpetrol, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("~o~Station de pétrole~s~ | Pétrole")
EndTextCommandSetBlipName(mstpetrol)
local essence = AddBlipForCoord(2705.61, 1573.99, 24.52)
SetBlipSprite(essence, 648)
SetBlipColour(essence, 47)
SetBlipScale(essence, 0.99)
SetBlipAsShortRange(essence, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("~o~Traitement du pétrole~s~ | Essence")
EndTextCommandSetBlipName(essence)
local venteblips = AddBlipForCoord(-783.94, -2629.98, 13.94)
SetBlipSprite(venteblips, 500)
SetBlipColour(venteblips, 47)
SetBlipScale(venteblips, 0.90)
SetBlipAsShortRange(venteblips, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Export RON")
EndTextCommandSetBlipName(venteblips)
local bidoncreation = AddBlipForCoord(2042.09, 3165.81, 45.28)
SetBlipSprite(bidoncreation, 415)
SetBlipColour(bidoncreation, 47)
SetBlipScale(bidoncreation, 0.90)
SetBlipAsShortRange(bidoncreation, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString("Bidon RON")
EndTextCommandSetBlipName(bidoncreation)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(5000)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    done = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' then
        SetBlipDisplay(essence, 4)
        SetBlipDisplay(mstpetrol, 4)
        SetBlipDisplay(venteblips, 4)
        SetBlipDisplay(bidoncreation, 4)
    else
        SetBlipDisplay(bidoncreation, 0)
        SetBlipDisplay(essence, 0)
        SetBlipDisplay(mstpetrol, 0)
        SetBlipDisplay(venteblips, 0)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' then
        SetBlipDisplay(essence, 4)
        SetBlipDisplay(mstpetrol, 4)
        SetBlipDisplay(venteblips, 4)
        SetBlipDisplay(bidoncreation, 4)

    else
        SetBlipDisplay(bidoncreation, 0)
        SetBlipDisplay(essence, 0)
        SetBlipDisplay(mstpetrol, 0)
        SetBlipDisplay(venteblips, 0)
    end
end)

AddEventHandler('esx:onPlayerDeathFalse', function()
    IsDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
    IsDead = true
end)

local isFueling = false
local remplissage = false
local petrolShow = false
local essenceSow = false

RMenu.Add('mstremplir', 'petrol', RageUI.CreateMenu("Pétrole", "Pétrole"))
RMenu.Add('mstremplir', 'rempli',
    RageUI.CreateSubMenu(RMenu:Get('mstremplir', 'petrol'), "Pétrole", "Remplir Pétrole"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('mstremplir', 'petrol'), true, true, true, function()

            RageUI.ButtonWithStyle("Remplir de pétrole", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    towmodel = GetHashKey('tanker')
                    local playerPed = PlayerPedId()
                    local PedPosition = GetEntityCoords(playerPed)
                    local vehicle = ESX.Game.GetClosestVehicle(PedPosition)
                    local isVehicleTow = IsVehicleModel(vehicle, towmodel)
                    if isVehicleTow then
                        local plate = GetVehicleNumberPlateText(vehicle)
                        ESX.TriggerServerCallback('Monsieur_litre', function(litreP, litreE)
                            if litreE > 0 then
                                ESX.ShowNotification("Vous ne pouvez pas mélanger les liquides")
                            else
                                RageUI.CloseAll()
                                isFueling = true
                                TriggerEvent('Monsieur_remplissagePetrol', litreP, plate)
                            end
                        end, plate)
                    else
                        ESX.ShowNotification("Seul les citernes sont autorisées")
                    end
                end
            end)

        end, function()
        end, 1)

        Citizen.Wait(0)
    end
end)

local position = {{
    x = 2778.91,
    y = 1708.44,
    z = 24.58
}}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' and not IsDead then
            for k in pairs(position) do
                DrawMarker(1, position[k].x, position[k].y, position[k].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0,
                    0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

                if dist <= 5.0 then
                    if not isFueling then
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ Pétrole")
                    end
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(RMenu:Get('mstremplir', 'petrol'),
                            not RageUI.Visible(RMenu:Get('mstremplir', 'petrol')))
                    end
                else
                    isFueling = false
                end
            end
        end
    end
end)

AddEventHandler('Monsieur_remplissagePetrol', function(litre, plate)
    local litres = litre

    while isFueling do
        Citizen.Wait(500)
        local fuelToAdd = math.random(50, 100)
        litres = litres + fuelToAdd

        if litres > 2000.0 then
            litres = 2000.0
            isFueling = false
            ESX.ShowNotification("La citerne est pleine")
        end
    end
    TriggerServerEvent('Monsieur_remplissage_petrol', plate, litres)
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isFueling then
            ESX.ShowHelpNotification("Remplissage de la citerne en cours...")
        end
    end
end)
local tankerPlateGlobal = nil
local stationGlobal = nil
local litreStationGlobal = 0
local litreStationHeliGlobal = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' and not IsDead then
            local towmodel = GetHashKey('tanker')
            local playerPed = PlayerPedId()
            local PedPosition = GetEntityCoords(playerPed)
            local vehicle = ESX.Game.GetClosestVehicle(PedPosition)
            local isVehicleTow = IsVehicleModel(vehicle, towmodel)
            for k in pairs(Config.Stations) do
                DrawMarker(1, Config.Stations[k].x, Config.Stations[k].y, Config.Stations[k].z, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.0, 3.0, 3.0, 0.25, 25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)
                if isVehicleTow then
                    local plate = GetVehicleNumberPlateText(vehicle)
                    local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
                    local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.Stations[k].x,
                        Config.Stations[k].y, Config.Stations[k].z)
                    if dist3 <= 3 then
                        if not remplissage then
                            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Remplir la station service")
                        end
                        if IsControlJustPressed(1, 51) then
                            ESX.TriggerServerCallback('Monsieur_litre_station_service', function(litreStation)
                                tankerPlateGlobal = plate
                                stationGlobal = Config.Stations[k]
                                litreStationGlobal = litreStation
                                if litreStation > 2000 then
                                    litreStationGlobal = 2000
                                end
                                if Config.Stations[k].name == "police" or Config.Stations[k].name == "weazel" or
                                    Config.Stations[k].name == "ambulance" then
                                    ESX.TriggerServerCallback('Monsieur_litre_station_service',
                                        function(litreStationHeli)
                                            litreStationHeliGlobal = litreStationHeli
                                            if litreStationHeli > 2000 then
                                                litreStationHeliGlobal = 2000
                                            end
                                            RageUI.Visible(RMenu:Get('pls_menu', 'fillStation'),
                                                not RageUI.Visible(RMenu:Get('pls_menu', 'fillStation')))
                                        end, Config.Stations[k].name .. "_heli")
                                else
                                    RageUI.Visible(RMenu:Get('pls_menu', 'fillStation'),
                                        not RageUI.Visible(RMenu:Get('pls_menu', 'fillStation')))
                                end
                            end, Config.Stations[k].name)
                        end
                    end
                end
            end
        end
    end
end)
function HandleFIllingStation(tankerPlate, station)
    ESX.TriggerServerCallback('Monsieur_litre', function(litreP, litreE)
        if litreE > 0 and litreP == 0 then
            ESX.TriggerServerCallback('Monsieur_litre_station_service', function(litreStation)
                if litreStation >= 2000 then
                    ESX.ShowNotification("La station est déja pleine")
                else
                    remplissage = true
                    TriggerEvent('Monsieur_remplissageStation', litreE, tankerPlate, litreStation, station.name,
                        station.x, station.y, station.z)
                end
            end, station.name)
        else
            ESX.ShowNotification("Vérifiez votre cargaison")
        end
    end, tankerPlate)
end
AddEventHandler('Monsieur_remplissageStation',
    function(litre, plate, litreStation, name, markerjobx, markerjoby, markerjobz)
        local manque = 2000 - litreStation
        local litres = litre
        local litreCamion = litre
        local totalessence = 0
        TriggerEvent('Monsieur:remplissageStation', name, markerjobx, markerjoby, markerjobz)
        while remplissage do
            Citizen.Wait(500)
            local fuelToAdd = math.random(20, 30)
            litres = litres + fuelToAdd
            litreCamion = litreCamion - fuelToAdd
            totalessence = totalessence + fuelToAdd

            if litreCamion <= 0 then
                remplissage = false
                ESX.ShowNotification("Le camion est vide")
            end
            if totalessence >= manque then
                remplissage = false
                ESX.ShowNotification("La station est remplie, il reste " .. litreCamion .. "L dans la citerne.")
            end
        end
        TriggerServerEvent('Monsieur_remplissage_essence', plate, litreCamion)
        TriggerServerEvent('Monsieur_remplissage_station', name, totalessence)
    end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if remplissage then
            ESX.ShowHelpNotification("Remplissage de la station en cours...")
        end
    end
end)

AddEventHandler('Monsieur:remplissageStation', function(name, markerjobx, markerjoby, markerjobz)
    while remplissage do
        Citizen.Wait(1)
        local plycrdjob = GetEntityCoords(PlayerPedId(), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, markerjobx, markerjoby, markerjobz)
        if jobdist > 2.5 then
            remplissage = false
            ESX.ShowNotification("Vous êtes trop loin pour remplir")
        end
        if IsControlJustReleased(0, 38) then
            remplissage = false
        end
    end
end)

-- Menu --

RMenu.Add('pls_menu', 'main', RageUI.CreateMenu("Ron", "Interaction"))
RMenu.Add('pls_menu', 'action', RageUI.CreateSubMenu(RMenu:Get('pls_menu', 'main'), "Ron", "Action patron"))

RMenu.Add('pls_menu', 'fillStation', RageUI.CreateMenu("Ron", "Choisissez une station à remplir"))

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' and not IsDead then
            if IsControlJustReleased(0, 167) then
                RageUI.Visible(RMenu:Get('pls_menu', 'main'), not RageUI.Visible(RMenu:Get('pls_menu', 'main')))
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('pls_menu', 'main'), true, true, true, function()

            RageUI.ButtonWithStyle("Donner une facture", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    OpenBillingMenu()
                end
            end)
            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Action patron", nil, {
                    RightLabel = "→"
                }, true, function()
                end, RMenu:Get('pls_menu', 'action'))
            end
        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('pls_menu', 'action'), true, true, true, function()
            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Engager un employé", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local target, distance = ESX.Game.GetClosestPlayer()
                        local target_id = GetPlayerServerId(target)
                        if distance <= 2.0 then
                            TriggerServerEvent('Monsieur_recrute_employ', target_id, "pls")
                        else
                            ESX.ShowNotification('Aucun joueur à proximité')
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
                            TriggerServerEvent('Monsieur_virer_employ', target_id, "pls")
                        else
                            ESX.ShowNotification('Aucun joueur à proximité')
                        end
                    end
                end)
            end
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('pls_menu', 'fillStation'), true, true, true, function()
            if string.find(stationGlobal.name, "police") or string.find(stationGlobal.name, "weazel") or
                string.find(stationGlobal.name, "ambulance") then
                local color1 = "~g~"
                if litreStationHeliGlobal <= 400 then
                    color1 = "~r~"
                end
                RageUI.ButtonWithStyle("Station hélicoptère", color1 .. litreStationHeliGlobal .. "~w~/2000", {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local station = deepcopy(stationGlobal)
                        station.name = station.name .. "_heli"
                        HandleFIllingStation(tankerPlateGlobal, station)
                        RageUI.CloseAll()
                    end
                end)
            end
            local color2 = "~g~"
            if litreStationGlobal <= 400 then
                color2 = "~r~"
            end
            RageUI.ButtonWithStyle("Station véhicules", color2 .. litreStationGlobal .. "~w~/2000", {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    HandleFIllingStation(tankerPlateGlobal, stationGlobal)
                    RageUI.CloseAll()
                end
            end)

        end, function()
        end)
        Citizen.Wait(0)
    end
end)
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
function OpenBillingMenu()

    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'pls', amount)
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
    AddTextEntry("PLS_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "PLS_INPUT", '', inputText, '', '', '', maxLength)
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

---------- Vente Export ----------

ConfPosRON = {{
    x = -783.94,
    y = -2629.98,
    z = 12.94,
    h = 150.08
}}

local taxeEtat = 1.2
local prixEssence = 300

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = Vdist(playerCoords, ConfPosRON[1].x, ConfPosRON[1].y, ConfPosRON[1].z, true)
        -- towmodel = GetHashKey('flatbed')
        local vehicle = GetLastDrivenVehicle()
        -- local isVehicleTow = IsVehicleModel(vehicle, towmodel)
        if distance <= 1.5 and not isDead then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Vendre des produits")
            if IsControlJustPressed(1, 51) then
                if GetEntityModel(vehicle) == -2137348917 then
                    RageUI.Visible(RMenu:Get('export_ron', 'main'), not RageUI.Visible(RMenu:Get('export_ron', 'main')))
                else
                    ESX.ShowNotification(
                        "Vous êtes fou de ne pas venir avec la citerne. Je ne veux pas vous achetez de marchandise.")
                end
            end
        end
        if zoneDistance ~= nil then
            if zoneDistance > 1.5 then
                RageUI.CloseAll()
            end
        end
    end
end)

RMenu.Add('export_ron', 'main', RageUI.CreateMenu("Export RON", "(Taxe Gouvernementale : 20%)"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('export_ron', 'main'), true, true, true, function()
            ESX.PlayerData = ESX.GetPlayerData()

            for i = 1, #ESX.PlayerData.inventory, 1 do
                if ESX.PlayerData.inventory[i].count ~= false and (ESX.PlayerData.inventory[i].name == "petrol_raffin") then
                    if ESX.PlayerData.inventory[i].count > 0 then
                        invCount = {}
                        for i = 1, ESX.PlayerData.inventory[i].count, 1 do
                            table.insert(invCount, i)
                        end
                        if ESX.PlayerData.inventory[i].name == "petrol_raffin" then
                            prixItem = prixEssence
                        end
                        RageUI.ButtonWithStyle(ESX.PlayerData.inventory[i].label .. ' (' ..
                                                   ESX.PlayerData.inventory[i].count .. ')', nil, {
                            RightLabel = "~g~ " .. math.ceil(prixItem * taxeEtat) .. " $"
                        }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local valid, quantity = CheckQuantity(
                                    KeyboardInput("Quantité", "", 10, "PLS_INPUT_MONTANT"))
                                if not valid then
                                    ESX.ShowNotification("Quantité invalide")
                                else
                                    if quantity <= ESX.PlayerData.inventory[i].count then
                                        TriggerServerEvent('pls:vente', ESX.PlayerData.inventory[i].name,
                                            ESX.PlayerData.inventory[i].label, quantity, prixItem)
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
    local hash = GetHashKey("s_m_y_construct_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(2000)
    end
    local ped = CreatePed("PED_TYPE_CIVMALE", "s_m_y_construct_01", ConfPosRON[1].x, ConfPosRON[1].y, ConfPosRON[1].z,
        ConfPosRON[1].h, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

end)

local show_citern = false
RMenu.Add('citerne', 'main_citerne', RageUI.CreateMenu("Citerne", "Marchandise"))
RMenu:Get('citerne', 'main_citerne').Closed = function()
    show_citern = false
end

function showCiterne()
    if not show_citern then
        show_citern = true
        RageUI.Visible(RMenu:Get('citerne', 'main_citerne'), true)
        while show_citern do
            Citizen.Wait(1)
            RageUI.IsVisible(RMenu:Get('citerne', 'main_citerne'), true, true, true, function()

                if not petrolShow then
                    RageUI.ButtonWithStyle("Pétrole : ", nil, {
                        RightLabel = "0L"
                    }, true, function(Hovered, Active, Selected)
                    end)
                else
                    RageUI.ButtonWithStyle("Pétrole : ", nil, {
                        RightLabel = petrolShow .. "L"
                    }, true, function(Hovered, Active, Selected)
                    end)
                end
                if not essenceSow then
                    RageUI.ButtonWithStyle("Essence : ", nil, {
                        RightLabel = "0L"
                    }, true, function()
                    end)
                else
                    RageUI.ButtonWithStyle("Essence : ", nil, {
                        RightLabel = essenceSow .. "L"
                    }, true, function()
                    end)
                end
            end, function()
            end)
        end
    else
        show_citern = false
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' and not IsDead then
            local towmodel = GetHashKey('tanker')
            local playerPed = PlayerPedId()
            local PedPosition = GetEntityCoords(playerPed)
            local vehicle = ESX.Game.GetClosestVehicle(PedPosition)
            local isVehicleTow = IsVehicleModel(vehicle, towmodel)
            if isVehicleTow then
                local plate = GetVehicleNumberPlateText(vehicle)
                local vehicleCoord = GetEntityCoords(vehicle, false)
                local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, vehicleCoord.x, vehicleCoord.y,
                    vehicleCoord.z)
                if dist3 <= 5 then
                    -- ESX.ShowHelpNotification("+ Voir cargaison")
                    if IsControlJustPressed(0, 314) and not show_citern then
                        ESX.TriggerServerCallback('Monsieur_litre', function(petro, essenc)
                            petrolShow = petro
                            essenceSow = essenc
                            showCiterne()
                        end, plate)
                    end
                end
            end
        end
    end
end)

local plate
local bidon = false
local creat_bidon = false
RMenu.Add('creat_Bidon', 'main_bidon', RageUI.CreateMenu("Citerne", "Fabrication/Arrêt"))
RMenu:Get('creat_Bidon', 'main_bidon').Closed = function()
    creat_bidon = false
end

function creatBidon()
    if not creat_bidon then
        creat_bidon = true
        RageUI.Visible(RMenu:Get('creat_Bidon', 'main_bidon'), true)
        while creat_bidon do
            Citizen.Wait(1)
            RageUI.IsVisible(RMenu:Get('creat_Bidon', 'main_bidon'), true, true, true, function()

                RageUI.ButtonWithStyle("Bidon de pétrole", nil, {
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        if not bidon then
                            bidon = true
                            Citizen.Wait(2000)
                            ESX.TriggerServerCallback('Monsieur_litre', function(petro, essenc)
                                petrolShow = petro
                                essenceSow = essenc

                                if not petrolShow then
                                    ESX.ShowNotification('Pas assez de pétrol')
                                elseif petrolShow >= 100 then
                                    TriggerEvent("creat_bidon_petrol", petrolShow, plate)

                                end
                            end, plate)
                        else
                            bidon = false
                            Citizen.Wait(2000)
                            ESX.ShowNotification('Arrêt de la récupération de ~b~bidon~s~')
                        end
                    end
                end)

            end, function()
            end)
        end
    else
        show_citern = false
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' and not IsDead then
            local towmodel = GetHashKey('tanker')
            local playerPed = PlayerPedId()
            local PedPosition = GetEntityCoords(playerPed)
            local vehicle = ESX.Game.GetClosestVehicle(PedPosition)
            local isVehicleTow = IsVehicleModel(vehicle, towmodel)
            plate = GetVehicleNumberPlateText(vehicle)
            local vehicleCoord = GetEntityCoords(vehicle, false)
            local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
            local dist4 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, 2042.09, 3165.81, 45.28 - 1)
            DrawMarker(1, 2042.09, 3165.81, 45.28 - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 0.25, 25, 95, 255, 255,
                false, 95, 255, 0, nil, nil, 0)
            if dist4 <= 5 and isVehicleTow then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Créer des bidons")
                if IsControlJustPressed(0, 51) and not creat_bidon and isVehicleTow then
                    creatBidon()
                end
            end
        end
    end
end)

RegisterNetEvent('stopTraitement')
AddEventHandler('stopTraitement', function()
    bidon = false
    creat_bidon = false
    RageUI.CloseAll()
end)

AddEventHandler('creat_bidon_petrol', function(petrolShow, plate)
    while bidon do
        if not IsDead and petrolShow >= 100 then
            Citizen.Wait(2000)
            petrolShow = petrolShow - 100
            TriggerServerEvent("creat_bidon_petrol", petrolShow, plate)
        else
            ESX.ShowNotification('Fabrication annulée')
            bidon = false
        end
    end
end)
