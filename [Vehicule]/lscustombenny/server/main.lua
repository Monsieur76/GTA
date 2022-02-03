ESX = nil
local Vehicles

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('LSCustomBennysPayment')
AddEventHandler('LSCustomBennysPayment', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getAccount("money").money >= price then
		xPlayer.removeAccountMoney("money", price)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "L'amélioration a été installé")
		local moneymairie = price * Config.percentgouv
		local moneybennys = price - moneymairie 
		TriggerEvent('society:getObject', "mairie", function(weightSociety,store, money, inventory)
			store.addMoney(moneymairie)
		end)
		TriggerEvent('society:getObject', "mechanic", function(weightSociety,store, money, inventory)
			store.addMoney(moneybennys/5)
		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez pas assez d'argent")
	end
end)


ESX.RegisterServerCallback('verif_sous_lscustom', function(source, cb,price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getAccount("money").money >= price then
		cb(true)
	else
		cb(false)
	end
end)


ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
	if not Vehicles then
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
	else
		cb(Vehicles)
	end
end)
