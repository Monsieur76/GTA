local open = false
local timer = 0

RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})

end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open or timer == 30000 and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
			timer = 0
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		timer = timer + 1000
	end
end)