ESX = nil
Items = {}
local DataStores = {}

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM appartement_black_inventory", {}, function(result)
        for i = 1, #result, 1 do
            local address = nil
            local money = nil

            if result[i].address ~= nil then
                address = result[i].address
            end
            if result[i].money ~= nil then
                money = result[i].money
            end

            Citizen.Wait(500)
            DataStores[address] = CreateDataStore(address, money)
        end
    end)
end)

function addStore(address)
    local money = 0
    MySQL.Async.execute('INSERT INTO appartement_black_inventory (address, money) VALUES (@address,@money)',
        {
            ['@address'] = address,
            ['@money'] = money
        })

    DataStores[address] = CreateDataStore(address, money)
    return  DataStores[address], DataStores[address].getBlackMoney()
end

function GetSharedDataStore(address)
    if DataStores[address] == nil then
        addStore(address)
    end
    return  DataStores[address], DataStores[address].getBlackMoney()
end

ESX.RegisterServerCallback('Coffrefort:getCoffre', function(source, cb, address)
    cb(GetSharedDataStore(address))
end)



RegisterServerEvent("coffreFortAppartement:getItem")
AddEventHandler("coffreFortAppartement:getItem", function(address, type, item, count, max,label, playerMax, coffreLevel)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if type == "item_account" then
            if DataStores[address].getBlackMoney() >= count then

                DataStores[address].removeBlackMoney(count)
                xPlayer.addAccountMoney(item, count)
                
                text = _U("trunk_info", address, coffreLevel)
                textCapacity = _U("trunk_capacity", DataStores[address].getBlackMoney(), max)
                data = {
                    address = address,
                    max = max,
                    text = text,
                    textCapacity = textCapacity,
                    playerTotalWeight = playerMax,
                    playerUsedWeight = xPlayer.getWeight(),
                    level = coffreLevel,
                }
                TriggerClientEvent("esx_inventoryhud:refreshCoffreFortAppartementInventory", _source, data, DataStores[address].getBlackMoney())
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))
            end
    end
end)

RegisterServerEvent("coffreFortAppartement:putItem")
AddEventHandler("coffreFortAppartement:putItem",function(address, type, item, count, max,label, playerMax, coffreLevel)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        if type == "item_account" then
            local playerAccountMoney = xPlayer.getAccount(item).money
            if (playerAccountMoney >= count and count > 0) then
                DataStores[address].addMoney(count)
                xPlayer.removeAccountMoney(item, count)
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))

            end
        end
        text = _U("trunk_info", address, coffreLevel)
        textCapacity = _U("trunk_capacity", DataStores[address].getBlackMoney(), max)
        data = {
            address = address,
            max = max,
            text = text,
            textCapacity = textCapacity,
            playerTotalWeight = playerMax,
            playerUsedWeight = xPlayer.getWeight(),
            level = coffreLevel,
        }
        TriggerClientEvent("esx_inventoryhud:refreshCoffreFortAppartementInventory", _source, data, DataStores[address].getBlackMoney())
end)


RegisterServerEvent("coffreFortAppartement:delete")
AddEventHandler("coffreFortAppartement:delete",function(address)
    DataStores[address].resetApart()
end)