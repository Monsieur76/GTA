local open = false
local calcul = 0

RegisterNetEvent('annonce_open')
AddEventHandler('annonce_open', function( message,title, type )
	open = true
	SendNUIMessage({
		action = "open",
		message  = message,
		type   = type,
		title = title
	})
end)


RegisterNetEvent('ArticleOpen')
AddEventHandler('ArticleOpen', function(open)
	Citizen.CreateThread(function()
		while open do
			Citizen.Wait(20000)
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end)
end)




