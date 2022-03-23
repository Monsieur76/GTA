-- CONFIG --

-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 900

-- Warn players if 3/4 of the Time Limit ran up
kickWarning = true
local creator = false

-- CODE --


RegisterNetEvent('creatorPersonnage')
AddEventHandler('creatorPersonnage', function(creat)
	creator = creat
end)


Citizen.CreateThread(function()
	while true do
		Wait(1000)

		playerPed = GetPlayerPed(-1)
		if playerPed then
			currentPos = GetEntityCoords(playerPed, true)
			if currentPos == prevPos and not creator then
				if time > 0 then
					if kickWarning and time == math.ceil(secondsUntilKick / 4) then
						time = time - 1
						TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "Vous allez être kick pour cause d'AFK, tapez le mot de passe")
						local mot = hasard()
						local data =  KeyboardInput('Tapez le mot suivant sinon vous serez kick :'..mot..'', '', 16, time)
							if data ~= nil and mot == data then
								time = secondsUntilKick
								--print(time)
							end
					end

					time = time - 1
				else
					TriggerServerEvent("kickForBeingAnAFKDouchebag")
					--print("kick")
				end
			else
				time = secondsUntilKick
			end

			prevPos = currentPos
		end
	end
end)


function KeyboardInput(textEntry, inputText, maxLength, timer)
	AddTextEntry("AFKKICK_TEXT", textEntry)
    DisplayOnscreenKeyboard(1, "AFKKICK_TEXT", '', inputText, '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(1)
		time = time - 0.01
		if time <= 0 then
			TriggerServerEvent("kickForBeingAnAFKDouchebag")
			--print("kick")
		end
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function hasard()
	mot = {"Bus","Pis","Vinaigre","Boxeur","Soumettre","Pauvrete","Bonheur","Ramper","Lire","Sculpteur","Monture","Guitare","Plongeon","Alcool","Sommeil","Inflation"}   --16
    rand = math.random(1, 16)
	return mot[rand]
end