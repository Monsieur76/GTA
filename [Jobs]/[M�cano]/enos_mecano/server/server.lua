ESX                = nil
vehicule = {
    id = nil,
    vehicule = nil
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'mechanic', 'mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'public'})
TriggerEvent('esx_phone:registerNumber', 'mechanic', 'alerte mécano', true, true)


RegisterServerEvent('Updatefourrière')
AddEventHandler('Updatefourrière', function(plate)
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE `plate` = @plate',{['@stored'] = 0, ['@plate'] = plate,})
end)


ESX.RegisterServerCallback('meca_concess:recuperercategorievehicule', function(source, cb)
    local catevehi = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicle_categories', {}, function(result)
        for i = 1, #result, 1 do
            table.insert(catevehi, {
                name = result[i].name,
                label = result[i].label
            })
        end

        cb(catevehi)
    end)
end)


ESX.RegisterServerCallback('meca_concess:recupererlistevehicule', function(source, cb, categorievehi)
    local catevehi = categorievehi
    local listevehi = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicles_mecano WHERE category = @category', {
        ['@category'] = catevehi
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(listevehi, {
                name = result[i].name,
                model = result[i].model,
                price = result[i].price
            })
        end

        cb(listevehi)
    end)
end)

ESX.RegisterServerCallback('meca_concess:verifierplaquedispo', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)


ESX.RegisterServerCallback('plateFourriere', function (source, cb)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles', {},
	 function (result)
        cb(result)
    end)
end)




RegisterServerEvent('Camion:vehicule')
AddEventHandler('Camion:vehicule', function(vehicleProps, prix,modelevoiture,dispo,plate)
local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle,model,price,stored) VALUES (@owner, @plate, @vehicle,@model,@price,@stored)', {
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@model'] = modelevoiture,
		['@price'] = prix,
		['@stored'] = 1
	}, function(rowsChange)
		TriggerClientEvent('esx:showNotification', xPlayer, "Tu as reçu la voiture ~g~"..json.encode(vehicleProps).."~s~ immatriculé ~g~"..vehicleProps.plate)
	end)
end)
