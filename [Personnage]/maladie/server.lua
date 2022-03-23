ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--RegisterServerEvent('removemaladie')
--AddEventHandler('removemaladie', function(maladie)
--	local xPlayer = ESX.GetPlayerFromId(source)
   -- xPlayer.removeMaladie(maladie)
--end)


RegisterServerEvent('maladie')
AddEventHandler('maladie', function(maladie)
	local xPlayer = ESX.GetPlayerFromId(source)
	if maladie == "grippe" then
		TriggerClientEvent('esx_status:add', source, 'thirst', -200000)
		TriggerClientEvent('esx_status:add', source, 'hunger', -200000)
	elseif maladie == "soleil" then
		TriggerClientEvent('esx_status:add', source, 'thirst', -200000)
	end
    xPlayer.setMaladie(maladie)
end)



RegisterServerEvent('maladienobdd')
AddEventHandler('maladienobdd', function(maladie)
	local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('maladie', xPlayer.source,maladie)
end)

ESX.RegisterUsableItem('medicament', function(source)
	local __source = source
	local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medicament', 1)
        xPlayer.removeMaladie("grippe")
        TriggerClientEvent('resetmaladie',__source, "grippe")
end)

ESX.RegisterUsableItem('pommade', function(source)
	local __source = source
	local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('pommade', 1)
        xPlayer.removeMaladie("herpes")
        TriggerClientEvent('resetmaladie',__source, "herpes")
end)

ESX.RegisterUsableItem('creme_solaire', function(source)
	local __source = source
	local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('creme_solaire', 1)
        xPlayer.removeMaladie("soleil")
        TriggerClientEvent('resetmaladie',__source, "soleil")
end)

ESX.RegisterUsableItem('mouchoir', function(source)
	local __source = source
	local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('mouchoir', 1)
        xPlayer.removeMaladie("rhume")
        TriggerClientEvent('resetmaladie',__source, "rhume")
end)
