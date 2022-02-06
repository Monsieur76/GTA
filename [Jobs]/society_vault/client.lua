ESX = nil

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

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    lastChecked = GetGameTimer()
end)

RegisterNetEvent("Vault:someoneInClient")
AddEventHandler("Vault:someoneInClient", function(playerName)
    PlayerName = playerName
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
        for society in pairs(Config.Positions) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name:find(society) then
                for _, position in pairs(Config.Positions[society]) do
                    local plyCoords = GetEntityCoords(PlayerPedId(), false)
                    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position.x, position.y, position.z)
                    DrawMarker(1, position.x, position.y, position.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25,
                        25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

                    if dist <= 1.5 then
                            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Ouvrir le coffre d'entreprise")
                            if IsControlJustPressed(1, 51) then
                                --if PlayerName == nil then
                                    OpenVaultInventoryMenu(society, Config.VaultWeight, position.label)
                               -- else
                               --     ESX.ShowNotification("~r~ Coffre" ..position.label.. "utilisé par " .. PlayerName)
                                --end
                            end
                    end
                end
            end
        end
    end
end)


function OpenVaultInventoryMenu(society, max, label)
    TriggerServerEvent("vault:someoneIn")
    ESX.PlayerData = ESX.GetPlayerData()
    --ESX.TriggerServerCallback('esx:getPlayerData', function(dataPlayer)
        ESX.TriggerServerCallback("society:getWeight", function(weightSociety,store, money, inventory)
            local weighUsed = 0
            for k, v in pairs(ESX.PlayerData.inventory) do
                if v.count ~= false then
                    if v.count > 0 then
                        weighUsed = weighUsed + (v.weight * v.count)
                    end
                end
            end
            text = _U("vault_info", label)
            textCapacity = _U("vault_capacity", weightSociety, max)
            data = {
                label = label,
                society = society,
                max = max,
                text = text,
                textCapacity = textCapacity,
                playerTotalWeight = ESX.PlayerData.maxWeight,
                playerUsedWeight = weighUsed,
                isPlayerSocietyBoss = ESX.PlayerData.job.name == society and ESX.PlayerData.job.grade_name == "boss"
            }
            TriggerEvent("esx_inventoryhud:openVaultInventory", data, money, inventory)
        end, society)
    --end)
end
