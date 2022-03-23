ESX = nil
local playerCars = {}
local crochetage = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

local veh
local open = false
local vehicle
local dist

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local PedPosition = GetEntityCoords(playerPed)
        veh = ESX.Game.GetClosestVehicle(PedPosition)
        local cx, cy, cz = table.unpack(GetEntityCoords(veh))
        local x, y, z = table.unpack(GetEntityCoords(playerPed))

        local jobdist = Vdist(x, y, z, cx, cy, cz)

        if IsControlJustPressed(0,23) and jobdist<3  then
                if GetEntityPopulationType(veh) ~= 7 then
                    if IsVehicleSeatFree(veh, -1) then
                        if open and vehicle == veh then
                            SetVehicleDoorsLocked(veh, 1)
                        else
                            crochetage = true
                            TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, false)
                            SetNuiFocus(true, true)
                            SendNUIMessage({
                                show = true,
                                vehicle = veh
                            })
                            SetVehicleDoorsLocked(veh, 2)
                        end
                    else
                        open =true
                        vehicle = veh
                        SetVehicleDoorsLocked(veh, 1)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    end
                end
            end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if crochetage then
            ESX.ShowHelpNotification("~INPUT_REPLAY_ADVANCE~ pour crocheter. Mettre la serrure à 90° pour déverrouiller.")
        else
        end
    end
end)



RegisterNUICallback('miniGame:echec', function()
    ClearPedTasks(PlayerPedId())
    SetNuiFocus(false, false)
    crochetage = false
end)
PlayerPedId()
RegisterNUICallback('miniGame:reussite', function(veh, cb)
    SetNuiFocus(false, false)
    crochetage = false
    open = true
    ClearPedTasks(PlayerPedId())
    vehicle = veh.vehicle
    PlaySoundFrontend(-1, "Highlight_Accept", "DLC_AW_Arena_Office_Planning_Wall_Sounds", true)
    -- veh = GetVehiclePedIsTryingToEnter(PlayerPedId(ped))
end)
-- circle  body
