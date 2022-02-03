ESX = nil
local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowed = false
local prix


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


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)



local lscustommenu = false

RMenu.Add('lscustom', 'main', RageUI.CreateMenu("Menu Lscustom", "Des modifications à faire ?"))

RMenu.Add('lscustom', "moteur", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'),"Moteur" ,"Modification du moteur" ))
RMenu.Add('lscustom', "frein", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'),"Frein" ,"Modification du frein" ))
RMenu.Add('lscustom', "transmission", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'),"Transmission" ,"Modification du transmission" ))
RMenu.Add('lscustom', "suspension", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'),"Suspension " ,"Modification des Suspension " ))
RMenu.Add('lscustom', "amure", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'),"Armure" ,"Modification de l'armure " ))
RMenu.Add('lscustom', "turbo", RageUI.CreateSubMenu(RMenu:Get('lscustom', 'main'),"Turbo" ,"Modification du Turbo " ))

RMenu:Get('lscustom', 'main').Closed = function()
    lscustommenu = false
end


function ouvrirLsCustom()
    if not lscustommenu then
        lscustommenu = true
        RageUI.Visible(RMenu:Get('lscustom', 'main'), true)
    while lscustommenu do
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local myCar = ESX.Game.GetVehicleProperties(vehicle)
		local props = {}

        RageUI.IsVisible(RMenu:Get('lscustom', 'main'), true, true, true, function()
			touche()
				RageUI.Button("Moteur", nil, {RightLabel = "→→→"},true, function()
				end, RMenu:Get('lscustom', "moteur"))
				RageUI.Button("Frein", nil, {RightLabel = "→→→"},true, function()
				end, RMenu:Get('lscustom', "frein"))
				RageUI.Button("Transmission", nil, {RightLabel = "→→→"},true, function()
				end, RMenu:Get('lscustom', "transmission"))
				RageUI.Button("Suspension", nil, {RightLabel = "→→→"},true, function()
				end, RMenu:Get('lscustom', "suspension"))
				RageUI.Button("Armure", nil, {RightLabel = "→→→"},true, function()
				end, RMenu:Get('lscustom', "amure"))
				RageUI.Button("Turbo", nil, {RightLabel = "→→→"},true, function()
				end, RMenu:Get('lscustom', "turbo"))
        end, function()
        end)


		RageUI.IsVisible(RMenu:Get('lscustom', 'turbo'), true, true, true, function()
					if myCar.modTurbo then
						RageUI.Button('Déja installé', nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
								if (Selected) then  
									ESX.ShowNotification("L'amélioration est déjà installé")
								end
						end)
					else
						RageUI.Button('Installé un turbo', nil, {RightLabel = "~g~"..Config.prixturbo.."$"}, true, function(Hovered, Active, Selected)
							if (Selected) then  
								ESX.TriggerServerCallback('verif_sous_lscustom', function(suffisant)
									if suffisant then
										props ={
											modTurbo = true
										}
										upgrade(vehicle, props)
										ToggleVehicleMod(vehicle, 18, true)
										TriggerServerEvent('LSCustomPayment', Config.prixturbo)
									else
										ESX.ShowNotification("L'amélioration n'a pas été installé car vous n'avez pas l'argent requis")
									end
								end,Config.prixturbo)
							end
						end)
					end
			end, function()
		end)

		RageUI.IsVisible(RMenu:Get('lscustom', 'amure'), true, true, true, function()
			label = "Armure niv"
			mod(16 ,Config.prixarmure0,Config.prixarmure1,Config.prixarmure2,Config.prixarmure3,Config.prixarmure4,myCar.modArmor,label,"modArmor")

			end, function()
		end)

		RageUI.IsVisible(RMenu:Get('lscustom', 'suspension'), true, true, true, function()
			label = "Suspension niv"
			mod(15 ,Config.prixsuspension0,Config.prixsuspension1,Config.prixsuspension2,Config.prixsuspension3,Config.prixsuspension4,myCar.modSuspension,label,"modSuspension")
			end, function()
		end)
		RageUI.IsVisible(RMenu:Get('lscustom', 'transmission'), true, true, true, function()
			label = "Transmission niv"
			mod(13 ,Config.prixtransmission0,Config.prixtransmission1,Config.prixtransmission2,Config.prixtransmission3,Config.prixtransmission4,myCar.modTransmission,label,"modTransmission")
			end, function()
		end)

		RageUI.IsVisible(RMenu:Get('lscustom', 'frein'), true, true, true, function()
			label = "Frein niv"
			mod(12 ,Config.prixfrein0,Config.prixfrein1,Config.prixfrein2,Config.prixfrein3,Config.prixfrein4,myCar.modBrakes,label,"modBrakes")
			end, function()
		end)
		RageUI.IsVisible(RMenu:Get('lscustom', 'moteur'), true, true, true, function()
			label = "Moteur niv"
			mod(11 ,Config.prixmoteur0,Config.prixmoteur1,Config.prixmoteur2,Config.prixmoteur3,Config.prixmoteur4,myCar.modEngine,label,"modEngine")
			end, function()
		end)
		
		Citizen.Wait(0)
	end
else
	lscustommenu = false
end
end

function upgrade(vehicle, props)
	ESX.Game.SetVehicleProperties(vehicle, props)
	local carModif = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('lscustom:achatVehicule', carModif)
 end

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
			if IsPedInAnyVehicle(playerPed, false) then
					local plyCoords = GetEntityCoords(PlayerPedId(), false)
						for k,v in pairs(Config.emplacement) do
        				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)
        				DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 0.25, 25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)
							if dist <= 4 then
								ESX.ShowHelpNotification("~INPUT_CONTEXT~ Améliorations véhicule")
								if IsControlJustReleased(0, 38) then
									local vehicle1 = GetVehiclePedIsIn(playerPed, false)
									FreezeEntityPosition(vehicle1, true)
									SetVehicleEngineOn(vehicle1, false, false, true)
									SetVehicleModKit(vehicle1, 0)
									lsMenuIsShowed = true
									prix = 0
									ouvrirLsCustom()
								end
							end
						end
			end
	end
end)

function mod(mod,pri,pri1,pri2,pri3,pri4,modesx,labe,prop)
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local modCount = GetNumVehicleMods(vehicle, mod)
			for j = 0, modCount-1, 1 do
				label = labe.." "..j				
				if j == 0 then
					prix = pri
				elseif j == 1 then
					prix = pri1
				elseif j == 2 then
					prix = pri2
				elseif j == 3 then
					prix = pri3
				elseif j == 4 then
					prix = pri4
				end
				if modesx == j then
					label = "Déja installé"
					prix = 0
					RageUI.Button(label, nil, {RightLabel = "~g~"..prix.."$"}, true, function(Hovered, Active, Selected)
						if (Selected) then
						end
					end)
				else
					RageUI.Button(label, nil, {RightLabel = "~g~"..prix.."$"}, true, function(Hovered, Active, Selected)
								if (Selected) then  
									ESX.TriggerServerCallback('verif_sous_lscustom', function(suffisant)
										if suffisant then
											props ={
												prop = j
											}
											SetVehicleMod(vehicle, mod, j, false)
											upgrade(vehicle, props)
											TriggerServerEvent('LSCustomPayment', prix)
										else
											ESX.ShowNotification("L'amélioration n'a pas été installé car vous n'avez pas l'argent requis")
										end
									end,prix)
								end
					end)
				end
			end
end

-- Prevent Free Tunning Bug

function touche ()
    if IsControlJustPressed(0, 194) then
        lsMenuIsShowed = false
		lscustommenu = false
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        FreezeEntityPosition(vehicle, false)
        SetVehicleEngineOn(vehicle, true, false, true)
    end
    if IsControlJustPressed(0, 177) then
        lsMenuIsShowed = false
        lscustommenu = false
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        FreezeEntityPosition(vehicle, false)
        SetVehicleEngineOn(vehicle, true, false, true)
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if lsMenuIsShowed then
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 168, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			if IsPauseMenuActive() then
                lsMenuIsShowed = false
                lscustommenu = false
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                FreezeEntityPosition(vehicle, false)
                SetVehicleEngineOn(vehicle, true, false, true)
            end
		else
			Citizen.Wait(500)
		end
	end
end)