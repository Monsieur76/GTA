ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



ESX.RegisterUsableItem('join', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('join', 1)

	TriggerClientEvent('esx_status:add', source, 'drug', 166000)
	TriggerClientEvent('esx_drugeffects:onMarijuana', source)
	TriggerClientEvent('esx:showNotification', source, "Vous fumez un joint")
end)

ESX.RegisterUsableItem('weed_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('weed_pooch', 1)
	xPlayer.addInventoryItem('join', 1)
	TriggerClientEvent('esx:showNotification', source, "Vous roulez un joint")
end)

ESX.RegisterUsableItem('opium_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('opium_pooch', 1)


	TriggerClientEvent('esx_status:add', source, 'drug', 249000)
	TriggerClientEvent('esx_drugeffects:onOpium', source)
	TriggerClientEvent('esx:showNotification', source, "Vous fumez de l'opium")
end)

ESX.RegisterUsableItem('meth_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('meth_pooch', 1)

	TriggerClientEvent('esx_status:add', source, 'drug', 333000)
	TriggerClientEvent('esx_drugeffects:onMeth', source)
	TriggerClientEvent('esx:showNotification', source, "Vous fumez un bang de meth")
end)

ESX.RegisterUsableItem('coke_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('coke_pooch', 1)

	TriggerClientEvent('esx_status:add', source, 'drug', 499000)
	TriggerClientEvent('esx_drugeffects:onCoke', source)
	TriggerClientEvent('esx:showNotification', source, "Vous sniffez de la coke")
end)
