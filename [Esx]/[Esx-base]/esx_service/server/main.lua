ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Garage Incremantation--

ESX.RegisterServerCallback('Monsieur_dispo_vehicle', function(source, cb, society)
	local data ={}
	MySQL.Async.fetchAll('SELECT * FROM vehicles where category=@society', {
		["@society"] = society,
	}, function(result)
		for k, v in pairs(result) do 
				table.insert(data,{name=result[k].name,model=result[k].model,dispo =result[k].dispo})
		end
		cb(data)
    end)
end)




ESX.RegisterServerCallback('Monsieur_vehicle_society_owner', function(source, cb, society)
	local data ={}
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles where owner=@owner and stored=10', {
		["@owner"] = society,
	}, function(result)
		found = false
		if result[1] ~= nil then	
				found = true
		end
		if found then
			for k, v in pairs(result) do 
					table.insert(data,{plate=result[k].plate,model=result[k].model,vehicle =result[k].vehicle})
			end
			cb(data)
		else
			cb(false)
		end
    end)
end)



-- Employer Job 1-- 

RegisterServerEvent('Monsieur_recrute_employ')
AddEventHandler('Monsieur_recrute_employ', function(targetId,job)
	__source = source
	local xPlayer = ESX.GetPlayerFromId(targetId)
	identifier = xPlayer.getIdentifier()
		if xPlayer.getJob().name == "unemployed" then
			xPlayer.setJob(job, 0)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez été recruté dans la société "..job)
			TriggerClientEvent('esx:showNotification', __source, "Cette personne a rejoint votre société")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous faite déja partie d'une entreprise")
			TriggerClientEvent('esx:showNotification', __source, "Cette personne fait déja partie d'une entreprise")
		end
end)

RegisterServerEvent('Monsieur_virer_employ')
AddEventHandler('Monsieur_virer_employ', function(targetId,job)
	__source = source
	local xPlayer = ESX.GetPlayerFromId(targetId)
	identifier = xPlayer.getIdentifier()
		if xPlayer.getJob().name == job then
			xPlayer.setJob("unemployed", 0)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez été renvoyé de la société "..job)
			TriggerClientEvent('esx:showNotification', __source, "Cette personne a été renvoyé de votre société")
		else
			TriggerClientEvent('esx:showNotification', __source, "La personne ne fait pas partie de votre entreprise")
		end
end)