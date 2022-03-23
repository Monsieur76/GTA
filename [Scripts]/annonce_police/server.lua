local ESX = nil
local open = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('annonce_open_wanted')
AddEventHandler('annonce_open_wanted', function(message)
	local show       = false
	local Players = ESX.GetPlayers()
	show = true
	if show then
		open = true
		for i=1, #Players, 1 do
			TriggerClientEvent('annonce_open_wanted', Players[i],message)
			TriggerClientEvent('WantedOpen', Players[i], open)
		end
	end
end)


Citizen.CreateThread(function()
	while open do
		open = false
		Citizen.Wait(12000)
	end
end)