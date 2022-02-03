ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('h4ci_garage:listevoitureperso', function(source, cb,name)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@stored'] = name
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate, model = v.model})
			end
			cb(ownedCars)
		end)
end)

ESX.RegisterServerCallback('h4ci_garage:listeToutevoitureperso', function(source, cb, name)
    local ownedCars = {}
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `stored` = @stored', { -- job = NULL
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

ESX.RegisterServerCallback('h4ci_garage:rangervoitureentreprise', function(source, cb, vehicleProps, job)
    local vehiclemodel = vehicleProps.model
    local xPlayer = ESX.GetPlayerFromId(source)
    if job:find("police") then
        job = "police"
    end
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate AND owner LIKE @owner', {
        ['@owner'] = job,
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

ESX.RegisterServerCallback('h4ci_garage:listevoitureentreprise', function(source, cb, name, job)
    local ownedCars = {}
    if job:find("police") then
        job = "police"
    end
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner LIKE @owner AND `stored` = @stored', { -- job = NULL
        ['@owner'] = job,
        ['@stored'] = name
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