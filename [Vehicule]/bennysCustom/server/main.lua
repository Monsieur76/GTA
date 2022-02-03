ESX = nil
local Vehicles

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('esx_lscustom:buyMod')
AddEventHandler('esx_lscustom:buyMod', function(price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    price = tonumber(price)

    if Config.IsMechanicJobOnly then

        TriggerEvent('society:getObject', "mechanic", function(weightSociety, store, money, inventory)

            if price < store.getMoney() then
                TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
                store.removeMoney(price)
            else
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
            end
        end)
    else
        if price < xPlayer.getMoney() then
            TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
            xPlayer.removeMoney(price)
        else
            TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
        end
    end
end)

RegisterServerEvent('esx_lscustom:refreshOwnedVehicle')
AddEventHandler('esx_lscustom:refreshOwnedVehicle', function(vehicleProps)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = vehicleProps.plate
    }, function(result)
        if result[1] then
            local vehicle = json.decode(result[1].vehicle)

            if vehicleProps.model == vehicle.model then
                MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
                    ['@plate'] = vehicleProps.plate,
                    ['@vehicle'] = json.encode(vehicleProps)
                })
            else
                print(('esx_lscustom: %s attempted to upgrade vehicle with mismatching vehicle model!'):format(
                    xPlayer.identifier))
            end
        end
    end)
end)

ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
    if not Vehicles then
        MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
            local vehicles = {}

            for i = 1, #result, 1 do
                table.insert(vehicles, {
                    model = result[i].model,
                    price = result[i].price
                })
            end

            Vehicles = vehicles
            cb(Vehicles)
        end)
    else
        cb(Vehicles)
    end
end)

RegisterServerEvent('lscustom:achatVehicule')
AddEventHandler('lscustom:achatVehicule', function(vehicleProps)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate AND owner=@owner', {
        ['@vehicle'] = json.encode(vehicleProps),
        ['@owner'] = xPlayer.identifier,
        ['@plate'] = vehicleProps.plate
    })
end)

ESX.RegisterServerCallback('verifsou', function(source, cb, price)
    TriggerEvent('society:getObject', "mechanic", function(weightSociety, store, money, inventory)
        if price < store.getMoney() then
            cb(true)
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback('isInService', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local service = false
    MySQL.Async.fetchAll('SELECT isService FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1].isService == 1 then
            service = true
            cb(service)
        else
            cb(service)
        end
    end)
end)
