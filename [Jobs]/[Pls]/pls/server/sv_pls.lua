ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'pls', 'alerte pls', true, true)

TriggerEvent('esx_society:registerSociety', 'pls', 'Pls', 'society_pls', 'society_pls', 'society_pls', {type = 'privée'})


RegisterServerEvent('Monsieur_vehicle_society')
AddEventHandler('Monsieur_vehicle_society', function(model,society,plate)
    MySQL.Async.execute('INSERT INTO vehicle_society (model,society, plate) VALUES (@model, @society, @plate)', {
        ['@model'] = model,
        ['@society'] = society,
        ['@plate'] = plate,
    })
end)


ESX.RegisterServerCallback('Monsieur_litre', function(source, cb,plate)
    __source = source
	MySQL.Async.fetchAll('SELECT * FROM vehicle_society where plate=@plate', {
		["@plate"] = plate,
	}, function(result)
        local found = false
		if result[1] ~= nil then	
            found = true
        else
            found = false
		end
        if found then
            cb(result[1].litre_petrol,result[1].litre_essence)
        else
            TriggerClientEvent('esx:showNotification', __source, "Ce n'est pas votre citerne")
        end
    end)
end)


RegisterServerEvent('Monsieur_remplissage_petrol')
AddEventHandler('Monsieur_remplissage_petrol', function(plate,litre)
    MySQL.Async.execute('UPDATE vehicle_society SET `litre_petrol` = @litre WHERE `plate` = @plate',{
        ['@plate'] = plate,
        ["@litre"] = litre
    })
end)

RegisterServerEvent('Monsieur_vidage_petrol')
AddEventHandler('Monsieur_vidage_petrol', function(plate,litre)
    MySQL.Async.execute('UPDATE vehicle_society SET `litre_petrol` = @litre WHERE `plate` = @plate',{
        ['@plate'] = plate,
        ["@litre"] = litre
    })
end)

RegisterServerEvent('Monsieur_remplissage_essence')
AddEventHandler('Monsieur_remplissage_essence', function(plate,litre)
    MySQL.Async.execute('UPDATE vehicle_society SET `litre_essence` = @litre WHERE `plate` = @plate',{
        ['@plate'] = plate,
        ["@litre"] = litre
    })
end)

ESX.RegisterServerCallback('Monsieur_litre_station_service', function(source, cb,name)
    MySQL.Async.fetchAll('SELECT * FROM station_service where name=@name', {
		["@name"] = name,
	}, function(result)
        cb(result[1].litre)
    end)
end)

RegisterServerEvent('Monsieur_remplissage_station')
AddEventHandler('Monsieur_remplissage_station', function(name,litre)
    MySQL.Async.fetchAll('SELECT * FROM station_service where name=@name', {
		["@name"] = name,
	}, function(result)
        number = result[1].litre + litre
        MySQL.Async.execute('UPDATE station_service SET `litre` = @litre WHERE `name` = @name',{
            ['@name'] = name,
            ["@litre"] = number
        })
    end)
end)

RegisterServerEvent('Monsieur_delete_citerne')
AddEventHandler('Monsieur_delete_citerne', function(plate)
    MySQL.Async.execute('DELETE FROM vehicle_society WHERE `plate` = @plate',{
        ['@plate'] = plate
    })
end)

ESX.RegisterServerCallback('Monsieur_verif_plate', function(source, cb,plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles where plate=@plate', {
		["@plate"] = plate,
	}, function(result)
        if result[1].owner == "pls" then
            cb(true)
        else
            cb(false)
        end
    end)
end)


-- fabrication

RegisterServerEvent('creat_bidon_petrol')
AddEventHandler('creat_bidon_petrol', function(petrolShow,plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.canCarryItem("petrol_raffin", 1) then
            xPlayer.addInventoryItem("petrol_raffin", 1)
            MySQL.Async.execute('UPDATE vehicle_society SET `litre_petrol` = @litre WHERE `plate` = @plate',{
                ['@plate'] = plate,
                ["@litre"] = petrolShow
            })
            TriggerClientEvent("showNotifFabrik", xPlayer.source,"petrol_raffin",1)
        else
            TriggerClientEvent("stopTraitement", xPlayer.source)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas asser de place')
        end
end)

RegisterServerEvent('pls:vente')
AddEventHandler('pls:vente', function(name, label, count, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(name, count)
    -- xPlayer.addMoney(1 * count)
    pls = count * prix
	mairie = pls * 0.2
	moneys = pls - mairie
    TriggerEvent('society:getObject', "pls", function(weightSociety,store, money, inventory)
        store.addMoney(moneys)
    end)
    TriggerEvent('society:getObject', "mairie", function(weightSociety,store, money, inventory)
        store.addMoney(mairie)
    end)
    if name == "radio" then
        TriggerClientEvent('ls-radio:onRadioDrop', xPlayer.source)
    end

    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez vendu ~r~" .. count .. " " .. label)

end)


ESX.RegisterServerCallback('pls:storageStationVille', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM station_service', {}, function(result)
        cb(result)
    end)
end)