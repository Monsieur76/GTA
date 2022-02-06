ESX = nil
PlayerName = nil
InventoryUsed = nil
local GUI = {}
GUI.Time = 0
local lastChecked = 0

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
            if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') then
                for _, position in pairs(Config.Positions[job]) do
                    local plyCoords2 = GetEntityCoords(PlayerPedId(), false)
                    local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, position.x, position.y, position.z)
                    DrawMarker(1, position.x, position.y, position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25,
                        95, 255, 255, false, 95, 255, 0, nil, nil, 0)

                    if dist2 <= 1.5 then
                        --if PlayerName ~= nil and InventoryUsed ~= nil and InventoryUsed == job then
                        --    ESX.ShowHelpNotification("~r~ Stockage utilisé par " .. PlayerName)
                        --else
                            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Ouvrir le stockage des saisies")
                            if IsControlJustPressed(1, 51) then
                                --if (GetGameTimer() - GUI.Time) > 1000 then
                                    OpenConfiscationInventoryMenu(job, Config.ConfiscationWeight)
                                    --GUI.Time = GetGameTimer()
                                --end
                            end
                        --end

                    end
                end
            end
        end
    end
end)
RegisterNetEvent("confiscation:someoneInClient")
AddEventHandler("confiscation:someoneInClient", function(playerName, inventoryName)
    PlayerName = playerName
    InventoryUsed = inventoryName
end)

function OpenConfiscationInventoryMenu(job, max)
    ESX.PlayerData = ESX.GetPlayerData()
        ESX.TriggerServerCallback("societyConfiscation:getWeight", function(weightSociety,store, money, inventory,weapon)
            local weighUsed = 0
            for k, v in pairs(ESX.PlayerData.inventory) do
                if v.count ~= false then
                    if v.count > 0 then
                        weighUsed = weighUsed + (v.weight * v.count)
                    end
                end
            end

            text = _U("confiscation_info",job)
            textCapacity = _U("trunk_capacity", weighUsed, max)
            data = {
                society = job,
                textCapacity = textCapacity,
                max = max,
                playerTotalWeight = ESX.PlayerData.maxWeight,
                playerUsedWeight = weighUsed,
                text = text
            }
            TriggerEvent("esx_inventoryhud:openConfiscationInventory", data, money, inventory,weapon)
        end,job)
end
