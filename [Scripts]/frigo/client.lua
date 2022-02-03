ESX = nil

UserProperty = nil
IsVisiting = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    while ESX.PlayerData.job == nil do
        Citizen.Wait(10)
    end

end)
RegisterNetEvent("playerVisitingHouse")
AddEventHandler("playerVisitingHouse", function(isVisiting)
    IsVisiting = isVisiting
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
        for owner in pairs(Config.Positions) do
            local isPoliceFrigo = ESX.PlayerData.job and (ESX.PlayerData.job.name:find("police") ~= nil or owner:find("police") ~= nil) and
                                      ESX.PlayerData.job.name:find("police") == owner:find("police")
            local isBurgerShotFrigo = ESX.PlayerData.job and (ESX.PlayerData.job.name:find("burgershot") ~= nil or owner:find("burgershot") ~=
                                          nil) and ESX.PlayerData.job.name:find("burgershot") ==
                                          owner:find("burgershot")
            if (ESX.PlayerData.job and
                (string.find(ESX.PlayerData.job.name .. "Job", owner) or isPoliceFrigo or isBurgerShotFrigo)) or
                (not owner:find("Job") and not IsVisiting) then

                for _, position in pairs(Config.Positions[owner]) do
                    local plyCoords = GetEntityCoords(PlayerPedId(), false)
                    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position.x, position.y, position.z)
                    if dist < 50 then
                        DrawMarker(1, position.x, position.y, position.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                            0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
                    end
                    if dist <= 1.5 then
                        --if PlayerName ~= nil and InventoryUsed ~= nil and InventoryUsed == owner then
                        --    ESX.ShowHelpNotification("~r~ Frigo utilisé par " .. PlayerName)
                        --else
                            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Ouvrir le frigo")
                            if IsControlJustPressed(1, 51) then
                                    OpenFrigoInventoryMenu(owner, Config.FrigoWeight, position.label)
                            end
                        --end
                    end
                end
            end
        end
    end
end)

--RegisterNetEvent("frigo:someoneInClient")
--AddEventHandler("frigo:someoneInClient", function(inventoryName, playerName)
 --   PlayerName = playerName
 --   InventoryUsed = inventoryName
--end)

function OpenFrigoInventoryMenu(owner, max, label)
    ESX.PlayerData = ESX.GetPlayerData()
    --ESX.TriggerServerCallback('esx:getPlayerData', function(dataPlayer)
        ESX.TriggerServerCallback("esx_frigo:getWeight", function(frigoWheight,store,inventory)
            local weighUsed = 0
            for k, v in pairs(ESX.PlayerData.inventory) do
                if v.count ~= false then
                    if v.count > 0 then
                        weighUsed = weighUsed + (v.weight * v.count)
                    end
                end
            end
            text = _U("frigo_info", label)
            textCapacity = _U("trunk_capacity", frigoWheight, max)
            data = {
                label = label,
                owner = owner,
                textCapacity = textCapacity,
                max = max,
                playerTotalWeight = ESX.PlayerData.maxWeight,
                playerUsedWeight = weighUsed,
                text = text
            }
            TriggerEvent("esx_inventoryhud:openFrigoInventory", data, inventory,store)
        end, owner)
    --end)
end
