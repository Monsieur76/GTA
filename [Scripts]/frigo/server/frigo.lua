ESX = nil
Items = {}

local DataStores = {}

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM frigo_inventory", {}, function(result)
        for i = 1, #result, 1 do
            local owner = nil
            local inventory = nil

            if result[i].owner ~= nil then
                owner = result[i].owner
            end
            if result[i].inventory ~= nil then
                inventory = json.decode(result[i].inventory)
            end

            Citizen.Wait(500)
            DataStores[owner] = CreateDataStore(owner, inventory)
        end
    end)
end)

function addStore(owner)
    local inventory = {}
    MySQL.Async.execute('INSERT INTO frigo_inventory (owner,inventory) VALUES (@owner,"{}")', {
        ['@owner'] = owner
    })
    DataStores[owner] = CreateDataStore(owner, inventory)
    return DataStores[owner].getInventoryWeight(), DataStores[owner], DataStores[owner].getInventory()
end

function GetSharedDataStore(owner)
    if DataStores[owner] == nil then
        addStore(owner)
    end
    return DataStores[owner].getInventoryWeight(), DataStores[owner], DataStores[owner].getInventory()
end

ESX.RegisterServerCallback('esx_frigo:getWeight', function(source, cb, owner)
    cb(GetSharedDataStore(owner))
end)


RegisterServerEvent("frigo:getItem")
AddEventHandler("frigo:getItem", function(owner, type,label, item, count, frigoMax, playerMax,labelFrigo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if type == "item_standard" then
        if not xPlayer.canCarryItem(item, count) then
            TriggerClientEvent('esx:showNotification', _source, _U("player_inv_no_space"))
        else
            if DataStores[owner].searchItemInventory(item, count) then
                DataStores[owner].removeItemInventory(item, count)
                xPlayer.addInventoryItem(item, count)
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
            end

                text = _U("frigo_info", labelFrigo)
                textCapacity = _U("trunk_capacity", DataStores[owner].getInventoryWeight(), frigoMax)
                data = {
                    label = labelFrigo,
                    owner = owner,
                    max = frigoMax,
                    textCapacity = textCapacity,
                    playerTotalWeight = playerMax,
                    playerUsedWeight = xPlayer.getWeight(),
                    text = text
                }
                TriggerClientEvent("esx_inventoryhud:refreshFrigoInventory", _source,data, DataStores[owner].getInventory())
        end
    end
end)

RegisterServerEvent("frigo:putItem")
AddEventHandler("frigo:putItem", function(owner, type,label, item, count, frigoMax, playerMax,labelFrigo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

    if type == "item_standard" then
        local playerItemCount = xPlayer.getInventoryItem(item).count

        if (playerItemCount >= count and count > 0) then
            if (DataStores[owner].getInventoryWeight()+  (ESX.GetItemWeight(item) * count)) > frigoMax  then
                TriggerClientEvent('esx:showNotification', _source, _U("insufficient_space"))
            else
                -- Checks passed, storing the item.
                DataStores[owner].addItemInventory(item, count, label)
                xPlayer.removeInventoryItem(item, count)
                if item == "radio" then
                    TriggerClientEvent('ls-radio:onRadioDrop', _source)
                end
            end
        else
            TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
        end
    end

        text = _U("frigo_info", labelFrigo)
        textCapacity = _U("trunk_capacity", DataStores[owner].getInventoryWeight(), frigoMax)
        data = {
            label = labelFrigo,
            owner = owner,
            max = frigoMax,
            textCapacity = textCapacity,
            playerTotalWeight = playerMax,
            playerUsedWeight = xPlayer.getWeight(),
            text = text
        }
        TriggerClientEvent("esx_inventoryhud:refreshFrigoInventory", _source, data, DataStores[owner].getInventory())
end)
