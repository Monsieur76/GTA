ESX = nil
local Vehicles

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
end)


RegisterServerEvent('lscustom:achatVehicule')
AddEventHandler('lscustom:achatVehicule', function(vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate AND owner=@owner', {
		['@vehicle']   = json.encode(vehicleProps),
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
	})
end)

RegisterServerEvent("peinturePay")
AddEventHandler("peinturePay", function(price)
	TriggerEvent('society:getObject', "mechanic", function(weightSociety,store, money, inventory)
		store.removeMoney(price)
	end)
end)