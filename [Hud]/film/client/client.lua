ESX = nil

local hasCinematic = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
			if hasCinematic == true then
				SendNUIMessage({openCinema = true})
			else
				SendNUIMessage({openCinema = false})
			end
	end
end)

RegisterNetEvent('filmHudnoir')
AddEventHandler('filmHudnoir', function()  
    if not hasCinematic then
        hasCinematic = true
		SendNUIMessage({openCinema = true})
    else
        hasCinematic = false
		SendNUIMessage({openCinema = false})
    end
end)
