ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'weazel', 'weazel', 'society_journaliste', 'society_journaliste', 'society_journaliste', {type = 'public'})
TriggerEvent('esx_phone:registerNumber', 'weazel', 'alerte weazel', true, true)



RegisterServerEvent('Open:Adss')
AddEventHandler('Open:Adss', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Weazel-News', '~b~Annonce', 'Le Weazel-News est désormais ~g~Ouvert~s~ !', 'CHAR_LIFEINVADER', 8)
	end
end)

RegisterServerEvent('Close:Adss')
AddEventHandler('Close:Adss', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Weazel-News', '~b~Annonce', 'Le Weazel-News est désormais ~r~Fermé~s~ !', 'CHAR_LIFEINVADER', 8)
	end
end)

RegisterServerEvent('Recrutement:Ads')
AddEventHandler('Recrutement:Ads', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Weazel-News', '~b~Recrutement', 'Le Weazel-News recrute ! Présentez-vous à l\'accueil du bâtiment', 'CHAR_LIFEINVADER', 8)
	end
end)

RegisterCommand('wea', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "weazel" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Weazel-News', '~b~Annonce', ''..msg..'', 'CHAR_LIFEINVADER', 0)
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~r~Erreur' , '~y~Tu n\'est pas journaliste moto pour faire cette commande', 'CHAR_CARSITE', 0)
    end
else
    TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~r~Erreur' , '~y~Tu n\'est pas journaliste moto pour faire cette commande', 'CHAR_CARSITE', 0)
end
end, false)
