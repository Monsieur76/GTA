ESX = nil
Items = {}
local storeTrunk = {}

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM trunk_inventory", {}, function(result)
        for i = 1, #result, 1 do
            local plate = nil
            local weapon = nil
            local inventory = nil

            if result[i].plate ~= nil then
                plate = result[i].plate
            end
            if result[i].weapon ~= nil then
                weapon = json.decode(result[i].weapon)
            end
            if result[i].inventory ~= nil then
                inventory = json.decode(result[i].inventory)
            end

            Citizen.Wait(500)

            storeTrunk[plate] = CreateDataStore(plate, weapon, inventory)
        end
    end)
end)

function addStore(plate)
    local weapon = {}
    local inventory = {}
    MySQL.Async.execute('INSERT INTO trunk_inventory (plate,weapon,inventory) VALUES (@plate,"{}","{}")', {
        ['@plate'] = plate
    })
    storeTrunk[plate] = CreateDataStore(plate, weapon, inventory)
    return storeTrunk[plate].getInventoryWeight(), storeTrunk[plate], storeTrunk[plate].getInventory(),
        storeTrunk[plate].getWeapon()
end

function GetSharedDataStore(plate)
    if storeTrunk[plate] == nil then
        addStore(plate)
    end
    return storeTrunk[plate].getInventoryWeight(), storeTrunk[plate], storeTrunk[plate].getInventory(),
        storeTrunk[plate].getWeapon()
end

ESX.RegisterServerCallback('esx_trunk:getWeight', function(source, cb, plate)
    cb(GetSharedDataStore(plate))
end)

ESX.RegisterServerCallback('getOwnedVehicle:getVehicleKey', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM open_car WHERE identifier = @identifier AND value = @plate", {
        ["@identifier"] = xPlayer.identifier,
        ["@plate"] = plate
    }, function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent("esx_trunk:putItem")
AddEventHandler("esx_trunk:putItem", function(plate, type, item, count, max, owned, label, playerMax, etiquette)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if type == "item_standard" then
        local playerItemCount = xPlayer.getInventoryItem(item).count

        if (playerItemCount >= count and count > 0) then

            if (storeTrunk[plate].getInventoryWeight() + (ESX.GetItemWeight(item) * count)) > max then
                TriggerClientEvent('esx:showNotification', _source, _U("insufficient_space"))
            else
                -- Checks passed, storing the item.
                storeTrunk[plate].addItemInventory(item, count, label)
                xPlayer.removeInventoryItem(item, count)
                if item == "radio" then
                    TriggerClientEvent('ls-radio:onRadioDrop', _source)
                end
            end
        else
            TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
        end

    elseif type == "item_weapon" then
        if (storeTrunk[plate].getInventoryWeight() + Config.DefaultWeight) > max then
            TriggerClientEvent('esx:showNotification', _source, _U("invalid_amount"))
        else
            storeTrunk[plate].addItemWeapon(item, count, label, etiquette)
            xPlayer.removeWeapon(item)
        end
    end

    text = _U("trunk_info", plate)
    textCapacity = _U("trunk_capacity", storeTrunk[plate].getInventoryWeight(), max)
    data = {
        plate = plate,
        max = max,
        myVeh = owned,
        text = text,
        textCapacity = textCapacity,
        playerTotalWeight = playerMax,
        playerUsedWeight = xPlayer.getWeight()
    }
    TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, storeTrunk[plate].getInventory(),
        storeTrunk[plate].getWeapon())
end)

RegisterServerEvent("esx_trunk:getItem")
AddEventHandler("esx_trunk:getItem", function(plate, type, item, count, max, owned, label, playerMax, etiquette)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if type == "item_standard" then
        if not xPlayer.canCarryItem(item, count) then
            TriggerClientEvent('esx:showNotification', _source, _U("player_inv_no_space"))
        else
            if storeTrunk[plate].searchItemInventory(item, count) then
                storeTrunk[plate].removeItemInventory(item, count)
                xPlayer.addInventoryItem(item, count)
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
            end

        end
    elseif type == "item_weapon" then
        if xPlayer.hasWeapon(item) then
            TriggerClientEvent('esx:showNotification', _source, _U("already_have_weapon"))
        else

            if storeTrunk[plate].searchItemWeapon(item, etiquette) then
                xPlayer.addWeapon(item, storeTrunk[plate].getAmmo(item, etiquette))
                storeTrunk[plate].removeItemWeapon(item, etiquette)
            else
                TriggerClientEvent('esx:showNotification', _source, _U("invalid_quantity"))
            end
        end
    end

    text = _U("trunk_info", plate)
    textCapacity = _U("trunk_capacity", storeTrunk[plate].getInventoryWeight(), max)
    data = {
        plate = plate,
        max = max,
        myVeh = owned,
        playerTotalWeight = playerMax,
        playerUsedWeight = xPlayer.getWeight(),
        text = text,
        textCapacity = textCapacity
    }
    TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, storeTrunk[plate].getInventory(),
        storeTrunk[plate].getWeapon())
end)

RegisterServerEvent("trunk:someoneIn")
AddEventHandler("trunk:someoneIn", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("trunk:someoneInClient", -1, xPlayer.getName())
end)

RegisterServerEvent("trunk:noPeaple")
AddEventHandler("trunk:noPeaple", function()
    TriggerClientEvent("trunk:someoneInClient", -1, nil)
end)
