
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

dead = false
isanim = false

Citizen.CreateThread(function()
	while true do
		Wait(500)

		if IsEntityDead(PlayerPedId()) then
			Wait(0) -- Time until respawn 15s
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)
			SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
			NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
			SetEntityHealth(ped,101)
			dead = true
			SetEntityInvincible(ped, true)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(0)
		if dead then
			local ped = PlayerPedId()
			if GetEntityHealth(ped) == 102 then
				--Wait(5000)
				SetEntityInvincible(ped, false)
			dead = false
			if isanim then
			isanim = false
			ESX.Streaming.RequestAnimDict("mini@cpr@char_b@cpr_str", function()
				TaskPlayAnim(ped, "mini@cpr@char_b@cpr_str", 'cpr_success', 1.0, 1.0, 30600, 1, 1.0, false, false, false)
	 			RemoveAnimDict("mini@cpr@char_b@cpr_str")
			end)
			end
			else
			local hunger
			local thirst
			SetEntityHealth(ped,101)
			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				hunger = status.getPercent()
			end)
			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				thirst = status.getPercent()
			end)
			if hunger <= 0.2 then
				TriggerEvent('esx_status:set', 'hunger', 1000000)
			end
			if thirst <= 0.2 then
				TriggerEvent('esx_status:set', 'thirst', 1000000)
			end
			isanim = true
			--print(hunger)

			
			ESX.Streaming.RequestAnimDict('mini@cpr@char_b@cpr_def', function()
				TaskPlayAnim(ped, 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 8.0, -8.0, 1, 0, 0, false, false, false)
	 			RemoveAnimDict('mini@cpr@char_b@cpr_def')
			end)
		end
		end
	end
end)