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

local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false,
    GetGameTimer() - 5 * 60000, false, false
local isDead, isBusy = false, false
local inventory = {}

ESX = nil
IsDead = false

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local CurrentlyTowedVehicle
local towmodel
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

---------------

RMenu.Add('mechanic', 'main', RageUI.CreateMenu("Mécano", "Interaction"))
RMenu.Add('mechanic', 'boss', RageUI.CreateSubMenu(RMenu:Get('mechanic', 'main'), "Mécano", "Interaction"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('mechanic', 'main'), true, true, true, function()

            if ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Action patron", nil, {
                    RightLabel = "→→"
                }, true, function(Hovered, Active, Selected)
                end, RMenu:Get('mechanic', 'boss'))
            end
            RageUI.ButtonWithStyle("Donner une facture", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    OpenBillingMenu()
                end
            end)

            RageUI.ButtonWithStyle("Réparer le véhicule", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local playerPed = PlayerPedId()
                    local vehicle = ESX.Game.GetVehicleInDirection()
                    local cx, cy, cz = table.unpack(GetEntityCoords(vehicle))
                    local x, y, z = table.unpack(GetEntityCoords(playerPed))

                    if IsPedSittingInAnyVehicle(playerPed) then
                        ESX.ShowNotification(_U('inside_vehicle'))
                        return
                    end

                    local model = GetEntityModel(PlayerPedId())

                    local jobdist = Vdist(x, y, z, cx, cy, cz)
                    if jobdist <= 2.0 then
                        if DoesEntityExist(vehicle) then
                            isBusy = true
                            if model == GetHashKey("mp_m_freemode_01") then
                                TaskPedSlideToCoord(playerPed, x, y, z, GetEntityHeading(playerPed) + 180, 1.0)
                                Citizen.Wait(2000)
                                TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_VEHICLE_MECHANIC', 0, true)
                                Citizen.CreateThread(function()
                                    Citizen.Wait(18000)

                                    SetVehicleFixed(vehicle)
                                    SetVehicleDeformationFixed(vehicle)
                                    SetVehicleUndriveable(vehicle, false)
                                    SetVehicleEngineOn(vehicle, true, true)
                                    ClearPedTasksImmediately(playerPed)

                                    ESX.ShowNotification(_U('vehicle_repaired'))
                                    isBusy = false
                                end)
                            else
                                TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
                                Citizen.CreateThread(function()
                                    Citizen.Wait(20000)

                                    SetVehicleFixed(vehicle)
                                    SetVehicleDeformationFixed(vehicle)
                                    SetVehicleUndriveable(vehicle, false)
                                    SetVehicleEngineOn(vehicle, true, true)
                                    ClearPedTasksImmediately(playerPed)

                                    ESX.ShowNotification(_U('vehicle_repaired'))
                                    isBusy = false
                                end)
                            end
                        else
                            ESX.ShowNotification(_U('no_vehicle_nearby'))
                        end
                    else
                        ESX.ShowNotification("Vous ête trop loin d'un véhicule")
                    end
                end
            end)

            RageUI.ButtonWithStyle("Nettoyer le véhicule", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local playerPed = PlayerPedId()
                    local vehicle = ESX.Game.GetVehicleInDirection()
                    local cx, cy, cz = table.unpack(GetEntityCoords(vehicle))
                    local x, y, z = table.unpack(GetEntityCoords(playerPed))

                    if IsPedSittingInAnyVehicle(playerPed) then
                        ESX.ShowNotification(_U('inside_vehicle'))
                        return
                    end
                    local jobdist = Vdist(x, y, z, cx, cy, cz)
                    if jobdist <= 2.0 then
                        if DoesEntityExist(vehicle) then
                            isBusy = true
                            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
                            Citizen.CreateThread(function()
                                Citizen.Wait(10000)

                                SetVehicleDirtLevel(vehicle, 0)
                                ClearPedTasksImmediately(playerPed)

                                ESX.ShowNotification(_U('vehicle_cleaned'))
                                isBusy = false
                            end)
                        else
                            ESX.ShowNotification(_U('no_vehicle_nearby'))
                        end
                    else
                        ESX.ShowNotification("Vous ête trop loin d'un véhicule")
                    end

                end
            end)

            -- RageUI.ButtonWithStyle("Crocheter le véhicule", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            -- if Selected then
            --	local playerPed = PlayerPedId()
            --	local vehicle = ESX.Game.GetVehicleInDirection()
            --	local coords = GetEntityCoords(playerPed)

            --	if IsPedSittingInAnyVehicle(playerPed) then
            --		ESX.ShowNotification(_U('inside_vehicle'))
            --		return
            --	end

            --	if DoesEntityExist(vehicle) then
            --		isBusy = true
            --		TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
            --		Citizen.CreateThread(function()
            --			Citizen.Wait(10000)

            --			SetVehicleDoorsLocked(vehicle, 1)
            --			SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            --			ClearPedTasksImmediately(playerPed)

            --			ESX.ShowNotification(_U('vehicle_unlocked'))
            --			isBusy = false
            --		end)
            --	else
            --		ESX.ShowNotification(_U('no_vehicle_nearby'))
            --	end
            --	end
            -- end)

            RageUI.ButtonWithStyle("Attacher/Détacher Dépanneuse", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    towmodel = GetHashKey('flatbed')
                    local playerPed = PlayerPedId()
                    local PedPosition = GetEntityCoords(playerPed)
                    local targetVehicle = ESX.Game.GetClosestVehicle(PedPosition)
                    local platevehicule = GetVehicleNumberPlateText(targetVehicle)
                    local id = VehToNet(targetVehicle)
                    local vehicle = GetLastDrivenVehicle()
                    local isVehicleTow = IsVehicleModel(vehicle, towmodel)
                    local cx, cy, cz = table.unpack(GetEntityCoords(vehicle))
                    local x, y, z = table.unpack(GetEntityCoords(targetVehicle))

                    local jobdist = Vdist(x, y, z, cx, cy, cz)
                    if jobdist <= 15.0 then
                        if isVehicleTow then
                            if CurrentlyTowedVehicle == nil then
                                if targetVehicle ~= 0 then
                                    if not IsPedInAnyVehicle(playerPed, true) then
                                        if vehicle ~= targetVehicle then
                                            local result = false
                                            NetworkRequestControlOfEntity(targetVehicle)
                                            TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, false)
                                            Citizen.Wait(5000)
                                            ClearPedTasksImmediately(playerPed)
                                            AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
										    CurrentlyTowedVehicle = targetVehicle
                                            ESX.ShowNotification(_U('vehicle_success_attached'))

                                        else
                                            ESX.ShowNotification(_U('cant_attach_own_tt'))
                                        end
                                    end
                                else
                                    ESX.ShowNotification(_U('no_veh_att'))
                                end
                            else
                                --AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0,0.0, false, false, false, false, 20, true)
                                DetachEntity(targetVehicle, true, true)
                                CurrentlyTowedVehicle = nil
                                ESX.ShowNotification(_U('veh_det_succ'))
                            end
                        else
                            ESX.ShowNotification(_U('imp_flatbed'))
                        end
                    else
                        ESX.ShowNotification("Votre dépanneuse est trop loin")
                    end
                end
            end)

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('mechanic', 'boss'), true, true, true, function()
            RageUI.ButtonWithStyle("Engager un employer", nil, {
                RightLabel = nil
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 then
                        TriggerServerEvent('Monsieur_recrute_employ', target_id, "mechanic")
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
                        TriggerServerEvent('Monsieur_virer_employ', target_id, "mechanic")
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and not IsDead then
            --    RegisterNetEvent('esx_mechanicjob:onDuty')
            if IsControlJustReleased(0, 167) and not RageUI.Visible(RMenu:Get('mechanic', 'main')) and
                not RageUI.Visible(RMenu:Get('mechanic', 'boss')) then

                RageUI.Visible(RMenu:Get('mechanic', 'main'), not RageUI.Visible(RMenu:Get('mechanic', 'main')))

            end
        end
    end
end)

function OpenBillingMenu()
    local post, amount = CheckQuantity(KeyboardInput('Montant : ', '', 64))
    if post then
        if amount ~= nil and amount > 0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if player ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'mechanic', amount)
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
    AddTextEntry("MECHANIC_INPUT", textEntry)
    DisplayOnscreenKeyboard(1, "MECHANIC_INPUT", '', inputText, '', '', '', maxLength)
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

-----------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()

    local mecamap = AddBlipForCoord(-205.79, -1307.08, 20.8)

    SetBlipSprite(mecamap, 446)
    SetBlipColour(mecamap, 30)
    SetBlipScale(mecamap, 0.8)
    SetBlipAsShortRange(mecamap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("~b~Benny's~w~ | Société")
    EndTextCommandSetBlipName(mecamap)
end)

-------------------------------------------------------------------------------------------

AddEventHandler('esx_mechanicjob:hasEnteredMarker', function(zone)
    if zone == 'NPCJobTargetTowable' then

    elseif zone == 'VehicleDelivery' then
        NPCTargetDeleterZone = true
    elseif zone == 'MechanicActions' then
        CurrentAction = 'mechanic_actions_menu'
        CurrentActionMsg = _U('open_actions')
        CurrentActionData = {}
    elseif zone == 'Garage' then
        CurrentAction = 'mechanic_harvest_menu'
        CurrentActionMsg = _U('harvest_menu')
        CurrentActionData = {}
    elseif zone == 'Craft' then
        CurrentAction = 'mechanic_craft_menu'
        CurrentActionMsg = _U('craft_menu')
        CurrentActionData = {}
    elseif zone == 'VehicleDeleter' then
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            CurrentAction = 'delete_vehicle'
            CurrentActionMsg = _U('veh_stored')
            CurrentActionData = {
                vehicle = vehicle
            }
        end
    end
end)

AddEventHandler('esx_mechanicjob:hasExitedMarker', function(zone)
    if zone == 'VehicleDelivery' then
        NPCTargetDeleterZone = false
    elseif zone == 'Craft' then
        TriggerServerEvent('esx_mechanicjob:stopCraft')
        TriggerServerEvent('esx_mechanicjob:stopCraft2')
        TriggerServerEvent('esx_mechanicjob:stopCraft3')
    elseif zone == 'Garage' then
        TriggerServerEvent('esx_mechanicjob:stopHarvest')
        TriggerServerEvent('esx_mechanicjob:stopHarvest2')
        TriggerServerEvent('esx_mechanicjob:stopHarvest3')
    end

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx_mechanicjob:hasEnteredEntityZone', function(entity)
    local playerPed = PlayerPedId()

    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and not IsPedInAnyVehicle(playerPed, false) then
        CurrentAction = 'remove_entity'
        CurrentActionMsg = _U('press_remove_obj')
        CurrentActionData = {
            entity = entity
        }
    end
end)

AddEventHandler('esx_mechanicjob:hasExitedEntityZone', function(entity)
    if CurrentAction == 'remove_entity' then
        CurrentAction = nil
    end
end)
