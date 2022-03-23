ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('CreatVehicle')
AddEventHandler('CreatVehicle', function(plate, vehicle)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute(
        "INSERT INTO `owned_vehicles` SET `owner` = @owner, `plate` = @plate, `vehicle` = @vehicle,`type` = @type,`model` = @model,`price` = @price,`stored` = @stored",
        {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate,
            ['@vehicle'] = json.encode(vehicle),
            ['@type'] = "car",
            ['@model'] = "Kalahari",
            ['@price'] = 20,
            ['@stored'] = "9"
        })
end)


RegisterNetEvent('skincreator:skincreator')
AddEventHandler('skincreator:skincreator', function()
    TriggerClientEvent("skincreator:skincreator",source)
end)

RegisterNetEvent('skincreator:updatesex')
AddEventHandler('skincreator:updatesex', function(sex)
    local __source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute("UPDATE `users` SET `sex` = @sex WHERE identifier = @identifier",
	{
		['@identifier']		= xPlayer.identifier,
		['@sex']			= sex,
	})
end)