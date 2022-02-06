ESX = nil
Items = {}
local confiscation = {}

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM police_confiscation_inventory", {}, function(result)
        for i = 1, #result, 1 do
            local society = nil
            local money = nil
            local inventory = nil
            local weapon = nil

            if result[i].society ~= nil then
                society = result[i].society
            end
            if result[i].money ~= nil then
                money = result[i].money
            end
            if result[i].inventory ~= nil then
                inventory = json.decode(result[i].inventory)
            end
            if result[i].weapon ~= nil then
                weapon = json.decode(result[i].weapon)
            end

            Citizen.Wait(500)
            confiscation[society] = CreateDataStore(society, money, inventory, weapon)
        end
    end)
end)

function addStore(society)
    local money = 0
    local weapon = {}
    local inventory = {}
    MySQL.Async.execute(
        'INSERT INTO police_confiscation_inventory (society, money, inventory,weapon) VALUES (@society,@money,"{}","{}")',
        {
            ['@society'] = society,
            ['@money'] = money
        })
    confiscation[society] = CreateDataStore(society, money, inventory, weapon)
    return confiscation[society].getInventoryWeight(), confiscation[society], confiscation[society].getMoney(),
        confiscation[society].getInventory(), confiscation[society].getWeapon()
end

function GetSharedDataStore(society)
    if confiscation[society] == nil then
        addStore(society)
    end
    return confiscation[society].getInventoryWeight(), confiscation[society], confiscation[society].getMoney(),
        confiscation[society].getInventory(), confiscation[society].getWeapon()
end

ESX.RegisterServerCallback('societyConfiscation:getWeight', function(source, cb, society)
    cb(GetSharedDataStore(society))
end)

AddEventHandler("society:getObject", function(society, cb)
    cb(GetSharedDataStore(society))
end)

RegisterServerEvent("confiscation:getItem")
AddEventHandler("confiscation:getItem", function(type, item, label, count, confiscationMax, playerMax, society,ammo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if type == "item_standard" then
        if not xPlayer.canCarryItem(item, count) then
            TriggerClientEvent('esx:showNotification', _source, _U("player_inv_no_space"))
        else
            if confiscation[society].searchItemInventory(item, count) then
                confiscation[society].removeItemInventory(item, count)
                xPlayer.addInventoryItem(item, count)

                textCapacity = _U("trunk_capacity", confiscation[society].getInventoryWeight(), confiscationMax )
                text = _U("confiscation_info", society)
                data = {
                    society = society,
                    max = confiscationMax,
                    playerTotalWeight = playerMax,
                    playerUsedWeight = xPlayer.getWeight(),
                    textCapacity = textCapacity,
                    text = text
                }
                TriggerClientEvent("esx_inventoryhud:refreshConfiscationInventory", _source, data,
                    confiscation[society].getMoney(), confiscation[society].getInventory(),
                    confiscation[society].getWeapon())
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
            end
        end
    elseif type == "item_account" then
        if (confiscation[society].getMoney() >= count and count > 0) then
            confiscation[society].removeMoney(count)
            xPlayer.addAccountMoney(item, count)

            textCapacity = _U("trunk_capacity", confiscation[society].getInventoryWeight(), confiscationMax )
                text = _U("confiscation_info", society)
            data = {
                society = society,
                max = confiscationMax,
                playerTotalWeight = playerMax,
                playerUsedWeight = xPlayer.getWeight(),
                textCapacity = textCapacity,
                text = text
            }
            TriggerClientEvent("esx_inventoryhud:refreshConfiscationInventory", _source, data,
                confiscation[society].getMoney(), confiscation[society].getInventory(),
                confiscation[society].getWeapon())

        else
            TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))
        end
    elseif type == "item_weapon" then
        if xPlayer.hasWeapon(item) then
            TriggerClientEvent('esx:showNotification', _source, _U("already_have_weapon"))
        else

            if confiscation[society].searchItemWeapon(item) then
                xPlayer.addWeapon(item, confiscation[society].getAmmo(item,label))
                confiscation[society].removeItemWeapon(item)

                textCapacity = _U("trunk_capacity", confiscation[society].getInventoryWeight(), confiscationMax )
                text = _U("confiscation_info", society)
                data = {
                    society = society,
                    max = confiscationMax,
                    playerTotalWeight = playerMax,
                    playerUsedWeight = xPlayer.getWeight(),
                    textCapacity = textCapacity,
                    text = text
                }
                TriggerClientEvent("esx_inventoryhud:refreshConfiscationInventory", _source, data,
                    confiscation[society].getMoney(), confiscation[society].getInventory(),
                    confiscation[society].getWeapon())
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
            end
        end
    end
end)

RegisterServerEvent("confiscation:putItem")
AddEventHandler("confiscation:putItem", function(type, item, label, count, confiscationMax, playerMax, society,ammo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if type == "item_standard" then
        local playerItemCount = xPlayer.getInventoryItem(item).count
        if (playerItemCount >= count and count > 0) then
            if (confiscation[society].getInventoryWeight() + (ESX.GetItemWeight(item) * count)) > confiscationMax then
                TriggerClientEvent('esx:showNotification', _source, _U("insufficient_space"))
            else
                -- Checks passed, storing the item.
                confiscation[society].addItemInventory(item, count, label)
                xPlayer.removeInventoryItem(item, count)
                if item == "radio" then
                    TriggerClientEvent('ls-radio:onRadioDrop', _source)
                end

                textCapacity = _U("trunk_capacity", confiscation[society].getInventoryWeight(), confiscationMax )
                text = _U("confiscation_info", society)
                data = {
                    society = society,
                    max = confiscationMax,
                    playerTotalWeight = playerMax,
                    playerUsedWeight = xPlayer.getWeight(),
                    textCapacity = textCapacity,
                    text = text
                }
                TriggerClientEvent("esx_inventoryhud:refreshConfiscationInventory", _source, data,
                    confiscation[society].getMoney(), confiscation[society].getInventory(),
                    confiscation[society].getWeapon())
            end
        else
            TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
        end
    elseif type == "item_account" then
        local playerAccountMoney = xPlayer.getAccount(item).money

        if (playerAccountMoney >= count and count > 0) then
            confiscation[society].addMoney(count)
            xPlayer.removeAccountMoney(item, count)

            textCapacity = _U("trunk_capacity", confiscation[society].getInventoryWeight(), confiscationMax )
                text = _U("confiscation_info", society)
            data = {
                society = society,
                max = confiscationMax,
                playerTotalWeight = playerMax,
                playerUsedWeight = xPlayer.getWeight(),
                textCapacity = textCapacity,
                text = text
            }
            TriggerClientEvent("esx_inventoryhud:refreshConfiscationInventory", _source, data,
                confiscation[society].getMoney(), confiscation[society].getInventory(),
                confiscation[society].getWeapon())
        else
            TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))
        end
    elseif type == "item_weapon" then
        if (confiscation[society].getInventoryWeight() + Config.DefaultWeight) > confiscationMax then
            TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))
        else
            confiscation[society].addItemWeapon(item, ammo, label)
            xPlayer.removeWeapon(item)

            textCapacity = _U("trunk_capacity", confiscation[society].getInventoryWeight(), confiscationMax )
                text = _U("confiscation_info", society)
            data = {
                society = society,
                max = confiscationMax,
                playerTotalWeight = playerMax,
                playerUsedWeight = xPlayer.getWeight(),
                textCapacity = textCapacity,
                text = text
            }
            TriggerClientEvent("esx_inventoryhud:refreshConfiscationInventory", _source, data,
                confiscation[society].getMoney(), confiscation[society].getInventory(),
                confiscation[society].getWeapon())
        end
    end
end)
