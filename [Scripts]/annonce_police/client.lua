local open = false
local calcul = 0
RegisterNetEvent('annonce_open_wanted')
AddEventHandler('annonce_open_wanted', function( message )
	open = true
	SendNUIMessage({
		action = "open",
		message  = message,
	})
end)


RegisterNetEvent('WantedOpen')
AddEventHandler('WantedOpen', function(open)
	Citizen.CreateThread(function()
		while open do
			Citizen.Wait(12000)
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end)
end)