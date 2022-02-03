ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('esx_dmvschool:addLicense')
AddEventHandler('esx_dmvschool:addLicense', function(type)
	local _source = source

	TriggerEvent('esx_license:addLicense', _source, type, function()
		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			TriggerClientEvent('esx_dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterServerEvent('haciadmin:addpermis')
AddEventHandler('haciadmin:addpermis', function(permis)
	local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('INSERT INTO user_licenses (type, owner, point) VALUES (@type, @owner, @point)', {
        ['@type'] = permis,
        ['@owner'] = xPlayer.identifier,
		['@point'] = 15
    })
end)


ESX.RegisterServerCallback('selectPermis', function(source, cb, type)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll(
		'SELECT * FROM user_licenses WHERE type = @type AND owner = @identifier', 
		{
			['@type'] = type,
			['@identifier'] = xPlayer.identifier
		},
		function(result)
			local found = false
			if result[1] ~= nil then	
				if xPlayer.identifier == result[1].owner then 
					found = true
				end
			end
			if found then
				cb(true)
			else
				cb(false)
			end
		end
	)
end)


ESX.RegisterServerCallback('paymentpermis', function(source, cb,payment)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= payment then
		xPlayer.removeMoney(payment)
		cb(true)
	else
		cb(false)
	end
end)