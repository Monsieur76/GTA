ESX = nil
local vehicle = nil
local limiteur = false

local PersonalMenu = {
    DoorState = {
        FrontLeft = false,
        FrontRight = false,
        BackLeft = false,
        BackRight = false,
        Hood = false,
        Trunk = false
    },
    DoorIndex = 1,
    DoorList = {"Avant Gauche",'Avant Droite', 'Arrière Gauche','Arrière Droite'},
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RMenu.Add('gestion', 'main', RageUI.CreateMenu("Gestion véhicule", "Option du véhicule"))
RMenu.Add('gestion', 'limiteur', RageUI.CreateSubMenu(RMenu:Get('gestion', 'main'), "Limiteur", "limiteur"))
RMenu.Add('gestion', 'porte', RageUI.CreateSubMenu(RMenu:Get('gestion', 'main'), "Portes", "Ouvrir/Fermer"))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('gestion', 'main'), true, true, true, function()
			RageUI.Button("Limiteur", nil, {RightLabel = "→→→"},true, function()
			end, RMenu:Get('gestion', 'limiteur'))
			RageUI.Button("Gestion des portes", nil, {RightLabel = "→→→"},true, function()
			end, RMenu:Get('gestion', 'porte'))
			RageUI.Button("Allumer/Eteindre moteur", nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
				if Selected then
					local plyPed = PlayerPedId()
                if not IsPedSittingInAnyVehicle(plyPed) then
                    ESX.ShowNotification('Vous n\'êtes pas dans un véhicule')
                elseif IsPedSittingInAnyVehicle(plyPed) then
                    local plyVeh = GetVehiclePedIsIn(plyPed, false)

                    if GetIsVehicleEngineRunning(plyVeh) then
                        SetVehicleEngineOn(plyVeh, false, false, true)
                        SetVehicleUndriveable(plyVeh, true)
                    elseif not GetIsVehicleEngineRunning(plyVeh) then
                        SetVehicleEngineOn(plyVeh, true, false, true)
                        SetVehicleUndriveable(plyVeh, false)
                    end
                end
				end
			end)
		end, function()
        end, 1)
		RageUI.IsVisible(RMenu:Get('gestion', 'porte'), true, true, true, function()
			RageUI.List('Porte', PersonalMenu.DoorList, PersonalMenu.DoorIndex, nil, {}, true,
            function(Hovered, Active, Selected, Index)
                if (Selected) then
                    local plyPed = PlayerPedId()
                    if not IsPedSittingInAnyVehicle(plyPed) then
                        ESX.ShowNotification('Vous n\'êtes pas dans un véhicule')
                    elseif IsPedSittingInAnyVehicle(plyPed) then
                        local plyVeh = GetVehiclePedIsIn(plyPed, false)

                        if Index == 1 then
                            if not PersonalMenu.DoorState.FrontLeft then
                                PersonalMenu.DoorState.FrontLeft = true
                                SetVehicleDoorOpen(plyVeh, 0, false, false)
                            elseif PersonalMenu.DoorState.FrontLeft then
                                PersonalMenu.DoorState.FrontLeft = false
                                SetVehicleDoorShut(plyVeh, 0, false, false)
                            end
                        elseif Index == 2 then
                            if not PersonalMenu.DoorState.FrontRight then
                                PersonalMenu.DoorState.FrontRight = true
                                SetVehicleDoorOpen(plyVeh, 1, false, false)
                            elseif PersonalMenu.DoorState.FrontRight then
                                PersonalMenu.DoorState.FrontRight = false
                                SetVehicleDoorShut(plyVeh, 1, false, false)
                            end
                        elseif Index == 3 then
                            if not PersonalMenu.DoorState.BackLeft then
                                PersonalMenu.DoorState.BackLeft = true
                                SetVehicleDoorOpen(plyVeh, 2, false, false)
                            elseif PersonalMenu.DoorState.BackLeft then
                                PersonalMenu.DoorState.BackLeft = false
                                SetVehicleDoorShut(plyVeh, 2, false, false)
                            end
                        elseif Index == 4 then
                            if not PersonalMenu.DoorState.BackRight then
                                PersonalMenu.DoorState.BackRight = true
                                SetVehicleDoorOpen(plyVeh, 3, false, false)
                            elseif PersonalMenu.DoorState.BackRight then
                                PersonalMenu.DoorState.BackRight = false
                                SetVehicleDoorShut(plyVeh, 3, false, false)
                            end
                        end
                    end
                end

                PersonalMenu.DoorIndex = Index
            end)

        RageUI.Button('Capot', nil, {}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local plyPed = PlayerPedId()
                if not IsPedSittingInAnyVehicle(plyPed) then
                    ESX.ShowNotification('Vous n\'êtes pas dans un véhicule')
                elseif IsPedSittingInAnyVehicle(plyPed) then
                    local plyVeh = GetVehiclePedIsIn(plyPed, false)

                    if not PersonalMenu.DoorState.Hood then
                        PersonalMenu.DoorState.Hood = true
                        SetVehicleDoorOpen(plyVeh, 4, false, false)
                    elseif PersonalMenu.DoorState.Hood then
                        PersonalMenu.DoorState.Hood = false
                        SetVehicleDoorShut(plyVeh, 4, false, false)
                    end
                end
            end
        end)

        RageUI.Button('Coffre', nil, {}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local plyPed = PlayerPedId()
                if not IsPedSittingInAnyVehicle(plyPed) then
                    ESX.ShowNotification('Vous n\'êtes pas dans un véhicule')
                elseif IsPedSittingInAnyVehicle(plyPed) then
                    local plyVeh = GetVehiclePedIsIn(plyPed, false)

                    if not PersonalMenu.DoorState.Trunk then
                        PersonalMenu.DoorState.Trunk = true
                        SetVehicleDoorOpen(plyVeh, 5, false, false)
                    elseif PersonalMenu.DoorState.Trunk then
                        PersonalMenu.DoorState.Trunk = false
                        SetVehicleDoorShut(plyVeh, 5, false, false)
                    end
                end
            end
        end)

		end, function()
        end, 1)
		RageUI.IsVisible(RMenu:Get('gestion', 'limiteur'), true, true, true, function()
			RageUI.Button("90 km/h",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
					if IsPedInVehicle(PlayerPedId(),vehicle,true) then
						limiteur = 90
					ESX.ShowNotification('Limiteur activé sur 90 Km')
					end
                end
			end)

			RageUI.Button("130 km/h",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
					if IsPedInVehicle(PlayerPedId(),vehicle,true) then
						limiteur = 130
					ESX.ShowNotification('Limiteur activé sur 130 Km')
					end
                end
			end)
			RageUI.Button("160 km/h",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
					if IsPedInVehicle(PlayerPedId(),vehicle,true) then
						limiteur = 160
					ESX.ShowNotification('Limiteur activé sur 160 Km')
					end
                end
			end)
			RageUI.Button("Désactiver limiteur",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
					limiteur = false
					if IsPedInVehicle(PlayerPedId(),vehicle,true) then

					ESX.ShowNotification('Limiteur désactivé')
					end
                end
			end)
        end, function()
        end, 1)
                        Citizen.Wait(0)
                                end
                            end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		 vehicle = GetVehiclePedIsIn(ped)
         model = GetEntityModel(vehicle)
         displaytext = GetDisplayNameFromVehicleModel(model)
		if IsPedInVehicle(PlayerPedId(),vehicle,true) then
			if IsControlJustPressed(1,212) then
				RageUI.Visible(RMenu:Get('gestion', 'main'), not RageUI.Visible(RMenu:Get('gestion', 'main')))
			end
            if IsControlJustPressed(0,75) then
                limiteur = false
            end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		 vehicle = GetVehiclePedIsIn(ped)
         model = GetEntityModel(vehicle)
         displaytext = GetDisplayNameFromVehicleModel(model)
		 if IsPedInVehicle(PlayerPedId(),vehicle,true) then
			SetVehRadioStation(vehicle, 'OFF')
		 end
         if displaytext == "KALAHARI" then 
                SetEntityMaxSpeed(vehicle , 13.7)
         else
		    if limiteur == 90 then
			    SetEntityMaxSpeed(vehicle , 25.0)
		    elseif limiteur == 130 then
			    SetEntityMaxSpeed(vehicle , 36.0)
		    elseif limiteur == 160 then
			    SetEntityMaxSpeed(vehicle , 44.25)
		    elseif limiteur == false then
			    maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
			    SetEntityMaxSpeed(vehicle, maxSpeed)
		end
    end
	end
end)