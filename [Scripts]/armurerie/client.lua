ESX = nil
local GUI = {}
PlayerName = nil
InventoryUsed = nil
local lastChecked = 0
GUI.Time = 0
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

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    lastChecked = GetGameTimer()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData = ESX.GetPlayerData()
    if ESX.PlayerData ~= nil then
        ESX.PlayerData.job = job
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for job in pairs(Config.Positions) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name:find(job) then
                for _, position in pairs(Config.Positions[job]) do
                    local plyCoords2 = GetEntityCoords(PlayerPedId(), false)
                    local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, position.x, position.y, position.z)
                    DrawMarker(1, position.x, position.y, position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25,
                        95, 255, 255, false, 95, 255, 0, nil, nil, 0)

                    if dist2 <= 1.5 then
                        --if PlayerName ~= nil and InventoryUsed ~= nil and InventoryUsed == job then
                        --    ESX.ShowHelpNotification("~r~ Armurerie utilisée par " .. PlayerName)
                        --else
                            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Ouvrir l'armurerie")
                            if IsControlJustPressed(1, 51) then
                                OpenArmurerieInventoryMenu(job, Config.ArmurerieWeight, position.label)
                            end
                        --end

                    end
                end
            end
        end
    end
end)

RegisterNetEvent("armurerie:someoneInClient")
AddEventHandler("armurerie:someoneInClient", function(inventoryName, playerName)
    PlayerName = playerName
    InventoryUsed = inventoryName
end)

function OpenArmurerieInventoryMenu(society, max, label)
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback("armurie:getWeight", function(weightArmu, store, weapon)
        local weighUsed = 0
        for k, v in pairs(ESX.PlayerData.inventory) do
            if v.count ~= false then
                if v.count > 0 then
                    weighUsed = weighUsed + (v.weight * v.count)
                end
            end
        end
        text = _U("armurerie_info", label)
        textCapacity = _U("trunk_capacity", weightArmu, max)
        data = {
            label = label,
            society = society,
            textCapacity = textCapacity,
            max = max,
            playerTotalWeight = ESX.PlayerData.maxWeight,
            playerUsedWeight = weighUsed,
            text = text
        }
        TriggerEvent("esx_inventoryhud:openArmurerieInventory", data, weapon)
    end, society)
end
