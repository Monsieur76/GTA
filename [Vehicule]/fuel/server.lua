ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = ESX.Math.Round(price)

    if price > 0 then
        xPlayer.removeMoney(amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        local mairie = ESX.Math.Round(amount * 0.2)
        local plsCost = amount - mairie
        TriggerEvent('society:getObject', "pls", function(weightSociety,store, money, inventory)
            store.addMoney(plsCost)
        end)
        TriggerEvent('society:getObject', "mairie", function(weightSociety,store, money, inventory)
            store.addMoney(mairie)
        end)
    end
end)

ESX.RegisterServerCallback('fuelpayement', function(source, cb, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= money then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('fuel:storage', function(source, cb, name)
    MySQL.Async.fetchAll('SELECT * FROM station_service WHERE `name` = @name', {
        ["@name"] = name
    }, function(result)
        cb(result[1].litre)
    end)
end)

RegisterServerEvent('fuel:pls')
AddEventHandler('fuel:pls', function(currentFuel, name)
    MySQL.Async.fetchAll('SELECT * FROM station_service WHERE `name` = @name', {
        ["@name"] = name
    }, function(result)
        if result == nil then
        else
            local number = result[1].litre - currentFuel
            MySQL.Async.execute('UPDATE station_service SET `litre` = @litre WHERE `name` = @name', {
                ['@name'] = name,
                ["@litre"] = math.ceil(tonumber(number))
            })
        end
    end)
end)
