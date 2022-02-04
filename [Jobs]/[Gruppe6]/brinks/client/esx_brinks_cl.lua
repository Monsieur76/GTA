local Keys = {
    ["F6"] = 167,
    ["E"] = 38,
    ["DELETE"] = 178
}
local isLoading = false

ESX = nil
local playerData = nil
local coords = nil
local inVehicle = false

local zoneList = {} -- { {enable, gps, markerD, blipD, blip, name}, ...}
local alreadyInZone = false
local lastZone = nil

local currentAction = nil
local currentActionMsg = ''
local currentActionData = {}

local isWorking = false
local isRunning = false
local currentRun = {}
local CurrentTest = nil
local BLIP_1 = nil
local x = nil
local y = nil
local z = nil
local onJob = nil
local PriseDeSac = nil
local sacBank = nil
local depo = nil

-- debug msg
function printDebug(msg)
    if Config.debug then
        print(Config.debugPrint .. ' ' .. msg)
    end
end

-- init
Citizen.CreateThread(function()
    local startLoad = GetGameTimer()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    -- load player
    while playerData == nil do
        Citizen.Wait(1)
        playerData = ESX.GetPlayerData()
    end
    while playerData.job == nil do
        Citizen.Wait(1)
        playerData = ESX.GetPlayerData()
    end
    while playerData.job.name == nil do
        Citizen.Wait(1)
        playerData = ESX.GetPlayerData()
    end
    coords = GetEntityCoords(PlayerPedId())
    inVehicle = false

    -- init end
    isLoading = false
    printDebug('Loaded in ' .. tostring(GetGameTimer() - startLoad) .. 'ms')
end)

function OpenBillingMenu()
    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'brinks', amount)
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
    AddTextEntry("BRINKS_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "BRINKS_INPUT", '', inputText, '', '', '', maxLength)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'brinks' then
            if IsControlJustReleased(0, 167) and not RageUI.Visible(RMenu:Get('brinks', 'main')) and
                not RageUI.Visible(RMenu:Get('brinks', 'boss')) then
                RageUI.Visible(RMenu:Get('brinks', 'main'), not RageUI.Visible(RMenu:Get('brinks', 'main')))
            end
        end
    end
end)

RMenu.Add('brinks', 'main', RageUI.CreateMenu("Union Depository", "Interaction"))
RMenu.Add('brinks', 'boss', RageUI.CreateSubMenu(RMenu:Get('brinks', 'main'), "Union Depository", "Interaction"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('brinks', 'main'), true, true, true, function()

            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Action patron", nil, {
                    RightLabel = "→→"
                }, true, function(Hovered, Active, Selected)
                end, RMenu:Get('brinks', 'boss'))
            end
            RageUI.ButtonWithStyle("Donner une facture", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    OpenBillingMenu()
                end
            end)

            RageUI.ButtonWithStyle("Débuté/Arrêter Convoyage", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    if onJob then
                        onJob = false
                        PriseDeSac = false
                    else
                        onJob = true
                    end
                    randomMarket()
                    RageUI.CloseAll()
                end
            end)

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('brinks', 'boss'), true, true, true, function()
            RageUI.ButtonWithStyle("Engager un employer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 then
                        TriggerServerEvent('Monsieur_recrute_employ', target_id, "brinks")
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
                        TriggerServerEvent('Monsieur_virer_employ', target_id, "brinks")
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

Citizen.CreateThread(function()
    local brinks = AddBlipForCoord(-3.14, -687.91, 46.02)
    SetBlipSprite(brinks, 745)
    SetBlipColour(brinks, 25)
    SetBlipScale(brinks, 0.99)
    SetBlipAsShortRange(brinks, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("~g~Union Dépository~s~ | Société")
    EndTextCommandSetBlipName(brinks)
end)

function showMarker(zone)
    DrawMarker(zone.markerD.type, zone.gps.x, zone.gps.y, zone.gps.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, zone.markerD.size.x,
        zone.markerD.size.y, zone.markerD.size.z, zone.markerD.color.r, zone.markerD.color.g, zone.markerD.color.b, 100,
        false, false, 2, false, false, false, false)
end

function randomMarket()
    rand = math.random(1, 17)
    if onJob then
        sacBank = math.random(Config.sacMin, Config.sacMax)
        for k, v in ipairs(Config.market) do
            if v.name == rand then
                x = v.x
                y = v.y
                z = v.z
            end
        end
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

Citizen.CreateThread(function()
    while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'brinks' then
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.depot.x, Config.depot.y, Config.depot.z)
            DrawMarker(1, Config.depot.x, Config.depot.y, Config.depot.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25,
                25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            if dist <= 2.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Déposer les sacs")

                if IsControlJustPressed(1, 51) then
                    ESX.ShowNotification("Dépot des sacs en cours")
                    Citizen.Wait(5000)
                    TriggerServerEvent('poseDeSacCoffre', Config.itemDb_name)
                end
            end
        end
        Citizen.Wait(0)
    end
end)

---------------------
------ Mission ------
---------------------

Citizen.CreateThread(function()
    while true do
        if onJob then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'brinks' then
                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, x, y, z)
                DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255,
                    0, nil, nil, 0)
                if dist <= 2.0 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Prendre les sacs")

                    if IsControlJustPressed(1, 51) then
                        local ped = PlayerPedId()
                        PriseDeSac = true
                        TriggerEvent('sac:marketBrinks', ped)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler('sac:marketBrinks', function()
    TriggerEvent('sac:marketBrinksPrise', ped)

    while PriseDeSac do
        Citizen.Wait(1)
        local plycrdjob = GetEntityCoords(PlayerPedId(), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, x, y, z)
        if jobdist > 2.0 then
            PriseDeSac = false
            ESX.ShowNotification("La prise de sac est annulé")
        end
    end
end)

AddEventHandler('sac:marketBrinksPrise', function()
    local currentSac = 0
    ESX.ShowNotification("Veuillez attendre tous les sac de billets")
    while PriseDeSac do
        Citizen.Wait(2000)

        local sacAdd = math.random(1, 2)
        currentSac = currentSac + sacAdd
        if currentSac >= sacBank then
            currentSac = sacBank
            PriseDeSac = false
            ESX.ShowNotification("~g~Vous avez terminé")
        end
        Citizen.Wait(0)
    end
    TriggerServerEvent("MettreSacDeBankInventaire", currentSac, Config.itemDb_name)
    onJob = false
    resetmission()
end)

function resetmission()
    RemoveBlip(BLIP_1)
    BLIP_1 = nil
    onJob = true
    randomMarket()
end
