ESX = nil
local PlayerData = {}
local PlayerName = nil

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

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    local PlayerData = ESX.GetPlayerData()
    if PlayerData ~= nil then
        PlayerData.job = job
    end
end)

RegisterNetEvent("trunk:someoneInClient")
AddEventHandler("trunk:someoneInClient", function(playerName)
    PlayerName = playerName
end)

function openmenuvehicle()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = ESX.Game.GetClosestVehicle(coords)
    local plate = GetVehicleNumberPlateText(vehicle)
    --if PlayerName == nil then
        if not IsPedInAnyVehicle(playerPed) then
            if vehicle ~= nil then
                myVeh = false
                PlayerData = ESX.GetPlayerData()
                ESX.TriggerServerCallback('ddx_vehiclelock:mykey', function(getVehi)
                    if getVehi or PlayerData.job.name == "policeNorth" or PlayerData.job.name == "police" then
                        local locked = GetVehicleDoorLockStatus(vehicle)
                        local class = GetVehicleClass(vehicle)
                        if locked == 1 then
                            OpenCoffreInventoryMenu(plate, Config.VehicleWeight[class], vehicle)
                            --TriggerServerEvent("trunk:someoneIn")
                        else
                            ESX.ShowNotification(_U("trunk_closed"))
                        end
                    else
                        ESX.ShowNotification(_U("nacho_veh"))
                    end
                end, plate)
            else
                ESX.ShowNotification(_U("no_veh_nearby"))
            end
        end
    ---else
    --    ESX.ShowNotification("~r~ Coffre de voiture utilisé par " .. PlayerName)
    --end
end
local count = 0

-- Key controls
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, Config.OpenKey) then
            openmenuvehicle()
        end
    end
end)

function OpenCoffreInventoryMenu(plate, max, myVeh)
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback("esx_trunk:getWeight", function(weightVehi, store, inventory, weapon)
        local weighUsed = 0
        for k, v in pairs(ESX.PlayerData.inventory) do
            if v.count ~= false then
                if v.count > 0 then
                    weighUsed = weighUsed + (v.weight * v.count)
                end
            end
        end
        text = _U("trunk_info", plate)
        textCapacity = _U("trunk_capacity", weightVehi, max)
        data = {
            plate = plate,
            max = max,
            myVeh = myVeh,
            textCapacity = textCapacity,
            text = text,
            playerTotalWeight = ESX.PlayerData.maxWeight,
            playerUsedWeight = weighUsed
        }
        TriggerEvent("esx_inventoryhud:openTrunkInventory", data, inventory, weapon, store)
    end, plate)
end

