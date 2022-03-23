ESX = nil
vehicule = {
    id = nil,
    vehicule = nil
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--TriggerEvent('esx_phone:registerNumber', 'concess', 'alerte concess', true, true)

--TriggerEvent('esx_society:registerSociety', 'concess', 'Concessionnaire', 'society_concess', 'society_concess', 'society_concess', {type = 'public'})


ESX.RegisterServerCallback('h4ci_concess:recuperercategorievehicule', function(source, cb)
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

ESX.RegisterServerCallback('h4ci_concess:recupererlistevehicule', function(source, cb, categorievehi)
    local catevehi = categorievehi
    local listevehi = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE category = @category', {
        ['@category'] = catevehi
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(listevehi, {
                name = result[i].name,
                model = result[i].model,
                price = result[i].price,
                dispo = result[i].dispo
            })
        end

        cb(listevehi)
    end)
end)


ESX.RegisterServerCallback('Vente:recupererlistevehicule', function(source, cb)
    local listeVent 
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier and stored in (3,4,5,6,7,8)', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('h4ci_concess:verifierplaquedispo', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)


ESX.RegisterServerCallback('listeDesVehiculeParNom', function(source, cb,name)
    local name = name

    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE name = @name', {
        ['@name'] = name
    }, function(result)
        cb(result[1].dispo)
    end)
end)


ESX.RegisterServerCallback('VehiculeEntreprise', function(source, cb,job)
    if job:find('police') then
        job = 'police'
    end
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE category = @name', {
        ['@name'] = job
    }, function(result)
        cb(result)
    end)
end)


RegisterServerEvent('shop:vehiculeEntreprise')
AddEventHandler('shop:vehiculeEntreprise', function(vehicleProps, prix,modelevoiture,job)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(prix)
    local garage = 9
    if modelevoiture:find("Hélicoptère") then
        if xPlayer.job.name == "police" then
            garage = "police_heli"
        elseif xPlayer.job.name == "policeNorth" then
            garage = "policeNorth_heli"
        elseif xPlayer.job.name == "ambulance" then
            garage = "ambulance_heli"
        elseif xPlayer.job.name == "weazel" then
            garage = "weazel_heli"
        end
    end
    if modelevoiture == "Citerne" then
        MySQL.Async.execute('INSERT INTO vehicle_society (plate) VALUES (@plate)', {
           ['@plate']   = vehicleProps.plate
        })
    end

MySQL.Async.execute('UPDATE vehicles SET dispo = dispo-1 WHERE name = @name', {
    ['@name']   = modelevoiture,
})

    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle,model,price,stored) VALUES (@owner, @plate, @vehicle,@model,@price,@stored)', {
        ['@owner']   = job,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps),
        ['@model'] = modelevoiture,
        ['@price'] = prix,
        ['@stored'] = garage
    })

end)


RegisterServerEvent('shop:vehicule')
AddEventHandler('shop:vehicule', function(vehicleProps, prix,modelevoiture,dispo,plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if vehicleProps ~= false then
        xPlayer.removeMoney(prix)
        dispo = dispo-1
    else
        xPlayer.addMoney(prix)
        dispo = dispo+1
    end

MySQL.Async.execute('UPDATE vehicles SET dispo = @dispo WHERE name = @name', {
    ['@name']   = modelevoiture,
    ['@dispo']   = dispo
})

if vehicleProps ~= false then
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle,model,price,stored) VALUES (@owner, @plate, @vehicle,@model,@price,@stored)', {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps),
        ['@model'] = modelevoiture,
        ['@price'] = prix,
        ['@stored'] = 9
    }, function(rowsChange)
        TriggerClientEvent('esx:showNotification', xPlayer, "Votre voiture ~g~"..json.encode(vehicleProps).."~s~ immatriculé ~g~"..vehicleProps.plate.." pour ~g~" ..prix.. "$. Vous attend au garage public")
    end)
else
    MySQL.Async.execute('DELETE FROM `owned_vehicles` WHERE plate=@plate and owner=@owner', {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = plate,
    }, function(rowsChange)
        TriggerClientEvent('esx:showNotification', xPlayer, "Tu as vendu la voiture ~g~"..modelevoiture .."~s~ immatriculé ~g~"..plate.." pour ~g~" ..prix.. "$")
    end)
end
end)



ESX.RegisterServerCallback('h4ci_concess:verifsousclient', function(source, cb, prixvoiture)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money =xPlayer.getMoney()
        if money >= prixvoiture then
            cb(true)
        else
            cb(false)
        end
    end)


ESX.RegisterServerCallback('voitureRangerGarage', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        if result[1].stored == 3 or result[1].stored == 4 or result[1].stored == 5 or result[1].stored == 6 or result[1].stored == 7 or result[1].stored == 8 then
            cb(true)
        else
            cb(false)
        end
    end)
end)