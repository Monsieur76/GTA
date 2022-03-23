ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

AddEventHandler('onMySQLReady', function(reason)
    local player = GetPlayerIdentifiers(source)
    local steam = player[1]
    MySQL.Async.execute("DELETE FROM owned_vehicles WHERE owner = @owner AND stored = 1", {
        ["@owner"] = steam
    })

end)

-- liste vehicule en fourriere
ESX.RegisterServerCallback('h4ci_garage:voiturefouriieree', function(source, cb)
    local ownedCars = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `stored` = @stored AND owner = @owner', { -- job = NULL
        ['@owner'] = xPlayer.identifier,
        ['@stored'] = "0"
    }, function(data)
        for _, v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            table.insert(ownedCars, {
                vehicle = vehicle,
                stored = v.stored,
                plate = v.plate,
                model = v.model
            })
        end
        cb(ownedCars)
    end)
end)

-- update fourrière
RegisterServerEvent('h4ci_garage:updatefourriere')
AddEventHandler('h4ci_garage:updatefourriere', function(plate)
    MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE `plate` = @plate', {
        ['@stored'] = "1",
        ['@plate'] = plate
    })
end)

-- liste véhicule
ESX.RegisterServerCallback('h4ci_garage:listevoiture', function(source, cb, name)
    local ownedCars = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = @stored', { -- job = NULL
        ['@owner'] = xPlayer.identifier,
        ['@stored'] = name
    }, function(data)
        for _, v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            table.insert(ownedCars, {
                vehicle = vehicle,
                stored = v.stored,
                plate = v.plate,
                price = v.price,
                model = v.model
            })
        end
        cb(ownedCars)
    end)
end)


-- état sortie véhicule
RegisterServerEvent('h4ci_garage:etatvehiculesortie')
AddEventHandler('h4ci_garage:etatvehiculesortie', function(plate, state, ranger)
    local xPlayer = ESX.GetPlayerFromId(source)
    if ranger then
        MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored, dateranged =NOW() WHERE plate = @plate', {
            ['@stored'] = state,
            ['@plate'] = plate.plate
        }, function(rowsChanged)
            if rowsChanged == 0 then
                print(('esx_advancedgarage: %s exploited the private garage!'):format(xPlayer.identifier))
            end
        end)
    else
        MySQL.Async.execute(
            'UPDATE owned_vehicles SET `stored` = @stored, dateranged =NOW(),vehicle = @vehicle WHERE plate = @plate',
            {
                ['@stored'] = state,
                ['@plate'] = plate.plate,
                ['@vehicle'] = json.encode(plate)
            }, function(rowsChanged)
                if rowsChanged == 0 then
                    print(('esx_advancedgarage: %s exploited the private garage!'):format(xPlayer.identifier))
                end
            end)
    end
end)

-- ranger véhicule
ESX.RegisterServerCallback('h4ci_garage:rangervoiture', function(source, cb, vehicleProps, name)
    local vehiclemodel = vehicleProps.model
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
        ['@owner'] = xPlayer.identifier,
        ['@plate'] = vehicleProps.plate
    }, function(result)
        if result[1] ~= nil then
            local originalvehprops = json.decode(result[1].vehicle)
            if originalvehprops.model == vehiclemodel then
                cb(true)
            else
                print(('h4ci_garage : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
                cb(false)
            end
        else
            print(('h4ci_garage : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback('verifsous', function(source, cb, plate, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local prix
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] ~= nil then
            prix = math.ceil(result[1].price * price)
            if xPlayer.getMoney() >= prix then
                xPlayer.removeMoney(prix)
                TriggerClientEvent('esx:showNotification', source, "Vous avez payé ~r~" .. prix .. "$")
                cb(true)
            else
                cb(false)
            end
        end
    end)
end)

-- verif si joueur a les sous pour fourriere
ESX.RegisterServerCallback('h4ci_garage:verifsous', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= garagepublic.sousfourriere then
        cb(true)
    else
        cb(false)
    end
end)

-- fait payer joueur pour fourriere
RegisterServerEvent('h4ci_garage:payechacal')
AddEventHandler('h4ci_garage:payechacal', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(garagepublic.sousfourriere)
    TriggerClientEvent('esx:showNotification', source, "Vous avez payé ~r~" .. garagepublic.sousfourriere .. "$")
end)

AddEventHandler('playerDropped', function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    print(reason)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @stored = stored', {
        ['@owner'] = xPlayer.identifier,
        ['@stored'] = 1
    }, function(result)
        if result[1] ~= nil then
            if reason ~= "Disconnected" or  reason ~= "Exiting" then
                for _, v in pairs(result) do
                    MySQL.Async.fetchAll('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
                        ['@plate'] = v.plate,
                        ['@stored'] = "destruction"
                    })
                end
            else
                for _, v in pairs(result) do
                    MySQL.Async.fetchAll('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
                        ['@plate'] = v.plate,
                        ['@stored'] = "0"
                    })
                end
            end
        end
    end)
end)
