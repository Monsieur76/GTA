ESX = nil
Items = {}
local DataStores = {}

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM appartement_inventory", {}, function(result)
        for i = 1, #result, 1 do
            local address = nil
            local weapon = nil
            local inventory = nil

            if result[i].address ~= nil then
                address = result[i].address
            end
            if result[i].weapon ~= nil then
                weapon = json.decode(result[i].weapon)
            end
            if result[i].inventory ~= nil then
                inventory = json.decode(result[i].inventory)
            end

            Citizen.Wait(500)

            DataStores[address] = CreateDataStore(address, weapon, inventory)
        end
    end)
end)

function addStore(address)
    local weapon = {}
    local inventory = {}
    MySQL.Async.execute('INSERT INTO appartement_inventory (address,weapon,inventory) VALUES (@address,"{}","{}")', {
        ['@address'] = address
    })
    DataStores[address] = CreateDataStore(address, weapon, inventory)
    return DataStores[address].getInventoryWeight(), DataStores[address], DataStores[address].getInventory(),
    DataStores[address].getWeapon()
end

function GetSharedDataStore(address)
    if DataStores[address] == nil then
        addStore(address)
    end
    return DataStores[address].getInventoryWeight(), DataStores[address], DataStores[address].getInventory(),
    DataStores[address].getWeapon()
end

ESX.RegisterServerCallback('Coffreappart:getWeight', function(source, cb, address)
    cb(GetSharedDataStore(address))
end)

RegisterServerEvent("coffreAppartement:getItem")
AddEventHandler("coffreAppartement:getItem", function(address, type, item, count, max, label, playerMax, coffreLevel,etiquette,ammo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if type == "item_standard" then
        local targetItem = xPlayer.getInventoryItem(item)
        if not xPlayer.canCarryItem(item, count) then
            TriggerClientEvent('esx:showNotification', _source, _U("player_inv_no_space"))
        else
            if DataStores[address].searchItemInventory(item, count) then
                DataStores[address].removeItemInventory(item, count)
                xPlayer.addInventoryItem(item, count)
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
            end
                text = _U("trunk_info", address, coffreLevel)
                textCapacity = _U("trunk_capacity", DataStores[address].getInventoryWeight(), max)
                data = {
                    address = address,
                    max = max,
                    playerTotalWeight = playerMax,
                    playerUsedWeight =xPlayer.getWeight(),
                    text = text,
                    level = coffreLevel,
                    textCapacity = textCapacity,
                }
                TriggerClientEvent("esx_inventoryhud:refreshCoffreAppartementInventory", _source, data,DataStores[address].getInventory(),
                DataStores[address].getWeapon())
        end

    elseif type == "item_weapon" then
        if xPlayer.hasWeapon(item) then
            TriggerClientEvent('esx:showNotification', _source, _U("already_have_weapon"))
        else
            if DataStores[address].searchItemWeapon(item, etiquette) then
                xPlayer.addWeapon(item, DataStores[address].getAmmo(item, etiquette))
                DataStores[address].removeItemWeapon(item, etiquette)
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
            end
                text = _U("trunk_info", address, coffreLevel)
                textCapacity = _U("trunk_capacity", DataStores[address].getInventoryWeight(), max)
                data = {
                    address = address,
                    max = max,
                    playerTotalWeight = playerMax,
                    playerUsedWeight = xPlayer.getWeight(),
                    level = coffreLevel,
                    text = text,
                    textCapacity = textCapacity,
                }
                TriggerClientEvent("esx_inventoryhud:refreshCoffreAppartementInventory", _source, data,DataStores[address].getInventory(),
                DataStores[address].getWeapon())
            -- end
        end
    end
end)

RegisterServerEvent("coffreAppartement:putItem")
AddEventHandler("coffreAppartement:putItem",
    function(address, type, item, count, max, label, playerMax, coffreLevel,etiquette,ammo)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if type == "item_standard" then
            local playerItemCount = xPlayer.getInventoryItem(item).count

            if (playerItemCount >= count and count > 0) then
                if (DataStores[address].getInventoryWeight() + (ESX.GetItemWeight(item) * count)) > max then
                    TriggerClientEvent('esx:showNotification', _source, _U("insufficient_space"))
                else
                    -- Checks passed, storing the item.
                    DataStores[address].addItemInventory(item, count, label)
                    xPlayer.removeInventoryItem(item, count)
                    if item == "radio" then
                        TriggerClientEvent('ls-radio:onRadioDrop', _source)
                    end
                end
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
            end

        elseif type == "item_weapon" then
            if (DataStores[address].getInventoryWeight() + Config.DefaultWeight) > max then
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))
            else
                DataStores[address].addItemWeapon(item, ammo, label, etiquette)
                xPlayer.removeWeapon(item)
            end
        end


            text = _U("trunk_info", address, coffreLevel)
            textCapacity = _U("trunk_capacity", DataStores[address].getInventoryWeight(), max)
            data = {
                address = address,
                max = max,
                text = text,
                level = coffreLevel,
                textCapacity = textCapacity,
                playerTotalWeight = playerMax,
                playerUsedWeight = xPlayer.getWeight()
            }

            TriggerClientEvent("esx_inventoryhud:refreshCoffreAppartementInventory", _source, data, DataStores[address].getInventory(),
            DataStores[address].getWeapon())
    end)


    
RegisterServerEvent("coffreAppartement:delete")
AddEventHandler("coffreAppartement:delete",function(address)
    DataStores[address].resetApart()
end)