ESX = nil
local facture = false
local calculate

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5000)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


RMenu.Add('laboratoire', 'labo', RageUI.CreateMenu("Laboratoire", "Laboratoire"))



Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('laboratoire', 'labo'), true, true, true, function()
            RageUI.ButtonWithStyle("Vérifier les faux billets", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then  
					local target, distance = ESX.Game.GetClosestPlayer()
					local target_id = GetPlayerServerId(target)
					local playerPed = PlayerPedId()
					if distance <= 2.0 and target_id ~= 0 and target_id ~= nil then
                        TriggerServerEvent("verifFauxBillet", target_id )
					else
						ESX.ShowNotification('Personne autour')
					end
                end
            end)    


        end, function()
        end, 1)

                 

        Citizen.Wait(0)
    end
end)


local position = {
    {x = 480.55, y = -1012.22, z = 34.23}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') then 
        for k in pairs(position) do
            DrawMarker(1, position[k].x, position[k].y, position[k].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
        
            if dist <= 2.0 then
				ESX.ShowHelpNotification("~INPUT_CONTEXT~ Vérifier les faux billets")
                    if IsControlJustPressed(1,51) then
                        RageUI.Visible(RMenu:Get('laboratoire', 'labo'), not RageUI.Visible(RMenu:Get('laboratoire', 'labo')))
                    end
            end
            end
        end
    end
end)


RegisterNetEvent('prendre_faux_billet')
AddEventHandler('prendre_faux_billet', function(xPlayer,xTarget)
	facture = true
	calculate = 0
	Citizen.CreateThread(function()
		while facture do
			Citizen.Wait(10)
			calculate = calculate + 10
			if calculate >= 15000 then
				facture = false
			else
				if IsControlJustReleased(0 ,246) then
					TriggerServerEvent('Prendre_billet_faux',xPlayer,xTarget)
					facture = false
				end
				if IsControlJustReleased(0 ,249) then
					ESX.ShowNotification("Vous n'avez rien pris")
					TriggerServerEvent('refus_billet_faux',xTarget)
					facture = false
				end
			end
		end
	end)
end)