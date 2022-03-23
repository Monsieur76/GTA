ESX = nil
vehicleStore = {}

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

AddEventHandler('esx:getSharedObjectVehicleStore', function(cb)
	cb(vehicleStore)
end)

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles', {}, function(vehicule)

        for i = 1, #vehicule, 1 do
            local owner = nil
            local plate = nil
            local type = nil
            local vehicle = nil
            local model = nil
            local price = nil
            local stored = nil
            local dateranged = nil

            if vehicule[i].owner ~= nil then
                owner = vehicule[i].owner
            end

            if vehicule[i].plate ~= nil then
                plate = vehicule[i].plate
            end

            if vehicule[i].type ~= nil then
                type = vehicule[i].type
            end

            if vehicule[i].vehicle ~= nil then
                vehicle = json.decode(vehicule[i].vehicle)
            end

            if vehicule[i].model ~= nil then
                model = vehicule[i].model
            end

            if vehicule[i].price ~= nil then
                price = vehicule[i].price
            end

            if vehicule[i].stored ~= nil then
                stored = vehicule[i].stored
            end

            if vehicule[i].dateranged ~= nil then
                dateranged = vehicule[i].dateranged
            end

            Citizen.Wait(500)
            vehicleStore[plate]=creatDataStore(owner,plate,type,vehicle,model,price,stored,dateranged)
        end

    end)
end)


AddEventHandler('StoredFirstRegister', function(owner,plate,type,vehicle,model,price,stored,dateranged)
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner,plate,type,vehicle,model,price,stored,dateranged) VALUES (@owner,@plate,@type,@vehicle,@model,@price,@stored,NOW())', {
        ['@owner'] = owner,
        ['@plate'] = plate,
        ['@type'] = type,
        ['@vehicle'] = vehicle,
        ['@model'] = model,
        ['@price'] = price,
        ['@stored'] = stored,
    })
    vehicleStore[plate] = CreateDataStore(owner,plate,type,vehicle,model,price,stored,dateranged)
    return vehicleStore[plate]
end)


ESX.RegisterServerCallback('Monsieur:VehicleObjt', function(source, cb, plate)
    cb(vehicleStore[plate])
end)