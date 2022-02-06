ESX = nil
Items = {}
local storeSociety = {}

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM society_vault_inventory", {}, function(result)
        for i = 1, #result, 1 do
            local society = nil
            local money = nil
            local inventory = nil

            if result[i].society ~= nil then
                society = result[i].society
            end
            if result[i].money ~= nil then
                money = result[i].money
            end
            if result[i].inventory ~= nil then
                inventory = json.decode(result[i].inventory)
            end

            Citizen.Wait(500)
            storeSociety[society] = CreateDataStore(society, money, inventory)
        end
    end)
end)

function addStore(society)
    local money = 200000
    local inventory = {}
    MySQL.Async.execute('INSERT INTO society_vault_inventory (society, money, inventory) VALUES (@society,@money,"{}")',
        {
            ['@society'] = society,
            ['@money'] = money
        })
    storeSociety[society] = CreateDataStore(society, money, inventory)
    return storeSociety[society].getInventoryWeight(), storeSociety[society], storeSociety[society].getMoney(),
        storeSociety[society].getInventory()
end

function GetSharedDataStore(society)
    if storeSociety[society] == nil then
        addStore(society)
    end
    return storeSociety[society].getInventoryWeight(), storeSociety[society], storeSociety[society].getMoney(),
        storeSociety[society].getInventory()
end

ESX.RegisterServerCallback('society:getWeight', function(source, cb, society)
    cb(GetSharedDataStore(society))
end)

AddEventHandler("society:getObject", function(society, cb)
    cb(GetSharedDataStore(society))
end)

RegisterServerEvent("vault:getItem")
AddEventHandler("vault:getItem",
    function(society, label, type, item, count, max, labelItem, playerMax, isPlayerSocietyBoss)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        if type == "item_standard" then
            if xPlayer.canCarryItem(item, count) then
                if storeSociety[society].searchItemInventory(item, count) then
                    storeSociety[society].removeItemInventory(item, count)
                    xPlayer.addInventoryItem(item, count)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
                end
            else
                TriggerClientEvent('esx:showNotification', _source, _U("player_inv_no_space"))
            end
        end
        if type == "item_money" and isPlayerSocietyBoss then

            if (storeSociety[society].getMoney() >= count and count > 0) then
                storeSociety[society].removeMoney(count)
                xPlayer.addMoney(count)

            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))
            end
        end
        text = _U("vault_info", label)
        textCapacity = _U("vault_capacity", storeSociety[society].getInventoryWeight(), max)
        data = {
            label = label,
            society = society,
            max = max,
            text = text,
            textCapacity = textCapacity,
            playerTotalWeight = playerMax,
            playerUsedWeight = xPlayer.getWeight(),
            isPlayerSocietyBoss = xPlayer.job.name == society and xPlayer.job.grade_name == "boss"
        }
        TriggerClientEvent("esx_inventoryhud:refreshVaultInventory", _source, data, storeSociety[society].getMoney(),
            storeSociety[society].getInventory())
    end)

RegisterServerEvent("vault:putItem")
AddEventHandler("vault:putItem",
    function(society, label, type, item, count, max, labelItem, playerMax, isPlayerSocietyBoss)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)
        if type == "item_standard" then
            local playerItemCount = xPlayer.getInventoryItem(item).count
            if (playerItemCount >= count and count > 0) then
                if (storeSociety[society].getInventoryWeight() + (ESX.GetItemWeight(item) * count)) > max then
                    TriggerClientEvent('esx:showNotification', _source, _U("insufficient_space"))
                else
                    -- Checks passed, storing the item.
                    storeSociety[society].addItemInventory(item, count, labelItem)
                    xPlayer.removeInventoryItem(item, count)
                    if item == "radio" then
                        TriggerClientEvent('ls-radio:onRadioDrop', _source)
                    end
                end
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
            end
        elseif type == "item_money" and isPlayerSocietyBoss then
            local playerAccountMoney = xPlayer.getMoney()

            if (playerAccountMoney >= count and count > 0) then
                storeSociety[society].addMoney(count)
                xPlayer.removeMoney(count)
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))
            end
        end

        text = _U("vault_info", label)
        textCapacity = _U("vault_capacity", storeSociety[society].getInventoryWeight(), max)
        data = {
            label = label,
            society = society,
            max = max,
            text = text,
            textCapacity = textCapacity,
            playerTotalWeight = playerMax,
            playerUsedWeight = xPlayer.getWeight(),
            isPlayerSocietyBoss = xPlayer.job.name == society and xPlayer.job.grade_name == "boss"
        }
        TriggerClientEvent("esx_inventoryhud:refreshVaultInventory", _source, data, storeSociety[society].getMoney(),
            storeSociety[society].getInventory())
    end)

RegisterServerEvent("Vault:noPeaple")
AddEventHandler("Vault:noPeaple", function()
    TriggerClientEvent("Vault:someoneInClient", -1, nil)
end)

RegisterServerEvent("vault:someoneIn")
AddEventHandler("vault:someoneIn", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("trunk:someoneInClient", -1, xPlayer.getName())
end)

