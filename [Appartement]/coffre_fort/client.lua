ESX = nil
PlayerName = nil
InventoryUsed = nil
UserProperty = nil
IsVisiting = false
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
end)
RegisterNetEvent("playerVisitingHouse")
AddEventHandler("playerVisitingHouse", function(isVisiting)
    IsVisiting = isVisiting
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for address in pairs(Config.Positions) do
            for _, position in pairs(Config.Positions[address]) do
                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position.x, position.y, position.z)
                if not IsVisiting then
                    if dist < 50 then
                        DrawMarker(1, position.x, position.y, position.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                            0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
                    end
                    if dist <= 1.5 then
                        -- if PlayerName ~= nil and InventoryUsed ~= nil and InventoryUsed == address then
                        --    ESX.ShowHelpNotification("~r~ Coffre fort utilisé par " .. PlayerName)
                        -- else
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ Ouvrir le coffre fort")
                        if IsControlJustPressed(1, 51) then
                            -- if (GetGameTimer() - GUI.Time) > 1000 then
                            OpenCoffreFortAppartementInventoryMenu(address)
                            --    GUI.Time = GetGameTimer()
                            -- end
                        end
                        -- end
                    end
                end
            end
        end
    end
end)
RegisterNetEvent("coffreFortAppartement:someoneInClient")
AddEventHandler("coffreFortAppartement:someoneInClient", function(inventoryName, playerName)
    PlayerName = playerName
    InventoryUsed = inventoryName
end)

function OpenCoffreFortAppartementInventoryMenu(address)
    ESX.PlayerData = ESX.GetPlayerData()
    print(address)
    ESX.TriggerServerCallback("esx_property:getUserProperty", function(property)
        if property ~= nil then
            ESX.TriggerServerCallback("Coffrefort:getCoffre", function(store, money)
                local weighUsed = 0
                for k, v in pairs(ESX.PlayerData.inventory) do
                    if v.count ~= false then
                        if v.count > 0 then
                            weighUsed = weighUsed + (v.weight * v.count)
                        end
                    end
                end
                local levelCapacity = Config.CoffreAppartementWeightLevels[property.level_coffre_fort + 1]
                text = _U("trunk_info", address, property.level_coffre_fort)
                textCapacity = _U("trunk_capacity", money, levelCapacity)
                data = {
                    address = address,
                    max = levelCapacity,
                    textCapacity = textCapacity,
                    playerTotalWeight = ESX.PlayerData.maxWeight,
                    playerUsedWeight = weighUsed,
                    level = property.level_coffre_fort,
                    text = text
                }
                TriggerEvent("esx_inventoryhud:openCoffreFortAppartementInventory", data, money)
            end, address)
        end
    end)
end
