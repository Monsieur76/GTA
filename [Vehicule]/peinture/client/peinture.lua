ESX = nil
local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowe = false
local myCar = {}
local prix
local devis
local price = {}

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


local lscustommen = false
RMenu.Add('lscustome', 'main', RageUI.CreateMenu("Menu Lscustom", "Des modifications à faire ?"))
RMenu.Add('lscustome', 'peinture', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'main'), "Peinture", "Modification de la peinture"))
RMenu.Add('lscustome', 'facture', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'main'), "Obtenir le devis", "Obtenir le devis"))

RMenu.Add('lscustome', 'primaire', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'peinture'), "Peinture primaire", "Modification de la couleur primaire"))
RMenu.Add('lscustome', 'basique', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'primaire'), "Peinture primaire", "Modification de la couleur primaire"))
RMenu.Add('lscustome', 'matte', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'primaire'), "Peinture primaire", "Modification de la couleur primaire"))
RMenu.Add('lscustome', 'metal', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'primaire'), "Peinture primaire", "Modification de la couleur primaire"))

RMenu.Add('lscustome', 'secondaire', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'peinture'), "Peinture secondaire", "Modification de la couleur secondaire"))
RMenu.Add('lscustome', 'basiqu', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'secondaire'), "Peinture secondaire", "Modification de la couleur secondaire"))
RMenu.Add('lscustome', 'matt', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'secondaire'), "Peinture secondaire", "Modification de la couleur secondaire"))
RMenu.Add('lscustome', 'meta', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'secondaire'), "Peinture secondaire", "Modification de la couleur secondaire"))

RMenu.Add('lscustome', 'nacre', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'peinture'), "Nacrage", "Modification du nacrage"))
RMenu.Add('lscustome', 'basiq', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'nacre'), "Nacrage", "Modification du nacrage"))
RMenu.Add('lscustome', 'mat', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'nacre'), "Nacrage", "Modification du nacrage"))
RMenu.Add('lscustome', 'met', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'nacre'), "Nacrage", "Modification du nacrage"))

RMenu.Add('lscustome', 'plate', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'peinture'), "Couleur de la plaque d'immatriculation", "Modification de la couleur de la plaque"))

RMenu.Add('lscustome', 'jante2', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'peinture'), "Couleur des jantes", "Modification de la couleur des jantes"))

RMenu.Add('lscustome', "stikers", RageUI.CreateSubMenu(RMenu:Get('lscustome', 'peinture'),"Stikers" ,"Modification les stikers" ))

RMenu.Add('lscustome', 'achat', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'facture'), "Valider les modification", "Valider les modification"))
RMenu.Add('lscustome', 'annuler', RageUI.CreateSubMenu(RMenu:Get('lscustome', 'facture'), "Annuler les modification", "Annuler les modification"))
RMenu:Get('lscustome', 'main').Closed = function()
    lscustommen = false
end
RMenu:Get('lscustome', 'main').Closed = function()
end




function ouvrirLsCusto()
    if not lscustommen then
        lscustommen = true
        RageUI.Visible(RMenu:Get('lscustome', 'main'), true)
    while lscustommen do
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local props = {}

		
        RageUI.IsVisible(RMenu:Get('lscustome', 'main'), true, true, true, function()
			touche ()
            RageUI.Button("Peinture", nil, {RightLabel = "→→→"},true, function()
            end, RMenu:Get('lscustome', 'peinture'))
            RageUI.Button("Obtenir le devis", nil, {RightLabel = "→→→"},true, function()
            end, RMenu:Get('lscustome', 'facture'))
        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('lscustome', 'facture'), true, true, true, function()
			RageUI.Button("Valider les modification", nil, {RightLabel = "→→→"},true, function()
			end, RMenu:Get('lscustome', 'achat'))
			RageUI.Button("Annuler les modification", nil, {RightLabel = "→→→"},true, function()
			end, RMenu:Get('lscustome', 'annuler'))
		end, function()
        end)
        RageUI.IsVisible(RMenu:Get('lscustome', 'peinture'), true, true, true, function()
			RageUI.Button("Peinture primaire", nil, {RightLabel = "→→→"},true, function()
			end, RMenu:Get('lscustome', 'primaire'))
			RageUI.Button("Peinture secondaire", nil, {RightLabel = "→→→"},true, function()
			end, RMenu:Get('lscustome', 'secondaire'))
			RageUI.Button("Nacrage", nil, {RightLabel = "→→→"},true, function()
			end, RMenu:Get('lscustome', 'nacre'))
			RageUI.Button("Couleur de la plaque d'immatriculation", nil, {RightLabel = "→→→"},true, function()
			end, RMenu:Get('lscustome', 'plate'))
			RageUI.Button("Couleur des jantes", nil, {RightLabel = "→→→"},true, function()
			end, RMenu:Get('lscustome', 'jante2'))
            --local stikers = GetNumVehicleMods(vehicle,48)
			--	if stikers ~= 0 then
					RageUI.Button("Stikers", nil, {RightLabel = "→→→"},true, function()
					end, RMenu:Get('lscustome', "stikers"))
			--	end
		end, function()
        end)

        RageUI.IsVisible(RMenu:Get('lscustome', 'achat'), true, true, true, function()
            touche ()
            local total = 0
                for k,v in pairs(devis) do
                    if v.value ~= nil then
                    total = total + v.value
                    end
                end
                for k,v in pairs(devis) do
                    RageUI.Button(v.label.."  "," Appuyer pour retirer du devis ", {RightLabel = "~g~"..v.value.."$"}, true, function(Hovered, Active, Selected)
                    if (Selected) then  
                        table.remove(devis,k)
                        total = total - v.value
                    end
                end)
                end
                RageUI.Button("Acheter les améliorations", nil, {RightLabel = "~g~"..total.."$"}, true, function(Hovered, Active, Selected)
                    if (Selected) then  
                                ESX.ShowNotification("Vous avez achetez les améliorations")
                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                upgrade(vehicle,props)
                                local carModif = ESX.Game.GetVehicleProperties(vehicle)
                                TriggerServerEvent('lscustom:achatVehicule', carModif)
                                TriggerServerEvent("peinturePay", total/4)
                                
                                myCar = ESX.Game.GetVehicleProperties(vehicle)
                    end
                    end)
            end, function()
            end)
            RageUI.IsVisible(RMenu:Get('lscustome', 'annuler'), true, true, true, function()
                RageUI.Button("Réinstaller les modifications de base", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then  
                        ESX.ShowNotification("Les modifications ont été remise de base")
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        upgrade(vehicle,myCar)
                    end
                    end)
            end, function()
            end)


------------------------------------Jante--------------------------------------------------------------------


            RageUI.IsVisible(RMenu:Get('lscustome', 'jante2'), true, true, true, function()
                if Config.payementFixejante then
                    price = Config.fixepayementjante
                else
                    price = prix * Config.payementjante
                    price = math.ceil(price)
                    if price < Config.minimumjante then
                        price = Config.minimumjante
                    end
                end
                for i=1, #Config.Colors, 1 do 
                RageUI.Button(Config.Colors[i].label, nil, {RightLabel = "~g~"..price.."$"}, true, function(Hovered, Active, Selected)
                    if (Active) then  
                        if myCar.wheelColor == Config.Colors[i].index then
                        else
                        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
                        SetVehicleExtraColours(vehicle, pearlescentColor, Config.Colors[i].index)

                        if (Selected) then  
                            props ={
                                wheelColor = Config.Colors[i].index
                            }
                            upgrade(vehicle, props)
                            found = false
                            for k,v in pairs(devis) do
                                if v.label == "Peinture jante" then
                                    found = true
                                end
                            end
                            if not found then
                                table.insert(devis, {label = "Peinture jante", value = price})
                            end
                        end
                    end
                    end
                    end)
                end
            end, function()
            end)


------------------------------------Primaire--------------------------------------------------------------------

            RageUI.IsVisible(RMenu:Get('lscustome', 'primaire'), true, true, true, function()
                RageUI.Button("Peinture primaire basique", nil, {RightLabel = "→→→"},true, function()
                end, RMenu:Get('lscustome', 'basique'))
                RageUI.Button("Peinture primaire mate", nil, {RightLabel = "→→→"},true, function()
                end, RMenu:Get('lscustome', 'matte'))
                RageUI.Button("Peinture primaire métallique", nil, {RightLabel = "→→→"},true, function()
                end, RMenu:Get('lscustome', 'metal'))
            end, function()
            end)


            RageUI.IsVisible(RMenu:Get('lscustome', 'basique'), true, true, true, function()
                if Config.payementFixecolor1 then
                    price = Config.fixepayementcolor1
                else
                    price = prix * Config.payementcolor1
                    if price < Config.minimumcolor1 then
                        price = Config.minimumcolor1
                    end
                end
                color1(Config.Colors,math.ceil(price),vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustome', 'matte'), true, true, true, function()
                if Config.payementFixecolor1 then
                    price = Config.fixepayementcolor1
                else
                    price = prix * Config.payementcolor1
                    if price < Config.minimumcolor1 then
                        price = Config.minimumcolor1
                    end
                end
                color1(Config.Colors.matt,math.ceil(price),vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustome', 'metal'), true, true, true, function()
                if Config.payementFixecolor1 then
                    price = Config.fixepayementcolor1
                else
                    price = prix * Config.payementcolor1
                    if price < Config.minimumcolor1 then
                        price = Config.minimumcolor1
                    end
                end
                color1(Config.Colors.Metallic,math.ceil(price),vehicle)
            end, function()
            end)


------------------------------------Secondaire--------------------------------------------------------------------

                        RageUI.IsVisible(RMenu:Get('lscustome', 'secondaire'), true, true, true, function()
                            RageUI.Button("Peinture secondaire basique", nil, {RightLabel = "→→→"},true, function()
                            end, RMenu:Get('lscustome', 'basiqu'))
                            RageUI.Button("Peinture secondaire mate", nil, {RightLabel = "→→→"},true, function()
                            end, RMenu:Get('lscustome', 'matt'))
                            RageUI.Button("Peinture secondaire métallique", nil, {RightLabel = "→→→"},true, function()
                            end, RMenu:Get('lscustome', 'meta'))
                        end, function()
                        end)



            RageUI.IsVisible(RMenu:Get('lscustome', 'basiqu'), true, true, true, function()
                if Config.payementFixecolor2 then
                    price = Config.fixepayementcolor2
                else
                    price = prix * Config.payementcolor2
                    if price < Config.minimumcolor2 then
                        price = Config.minimumcolor2
                    end
                end
                color2(Config.Colors,math.ceil(price),vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustome', 'matt'), true, true, true, function()
                if Config.payementFixecolor2 then
                    price = Config.fixepayementcolor2
                else
                    price = prix * Config.payementcolor2
                    if price < Config.minimumcolor2 then
                        price = Config.minimumcolor2
                    end
                end
                color2(Config.Colors.matt,math.ceil(price),vehicle)
            end, function()
            end)
        
            RageUI.IsVisible(RMenu:Get('lscustome', 'meta'), true, true, true, function()
                if Config.payementFixecolor2 then
                    price = Config.fixepayementcolor2
                else
                    price = prix * Config.payementcolor2
                    if price < Config.minimumcolor2 then
                        price = Config.minimumcolor2
                    end
                end
                color2(Config.Colors.Metallic,math.ceil(price),vehicle)
            end, function()
            end)

------------------------------------Nacrage--------------------------------------------------------------------

RageUI.IsVisible(RMenu:Get('lscustome', 'nacre'), true, true, true, function()
    RageUI.Button("Nacrage basique", nil, {RightLabel = "→→→"},true, function()
    end, RMenu:Get('lscustome', 'basiq'))
    RageUI.Button("Nacrage mate", nil, {RightLabel = "→→→"},true, function()
    end, RMenu:Get('lscustome', 'mat'))
    RageUI.Button("Nacrage métallique", nil, {RightLabel = "→→→"},true, function()
    end, RMenu:Get('lscustome', 'met'))
end, function()
end)

            RageUI.IsVisible(RMenu:Get('lscustome', 'basiq'), true, true, true, function()
                if Config.payementFixepearl then
                    price = Config.fixepayementpearl
                else
                    price = prix * Config.payementpearl
                    if price < Config.minimumpearl then
                        price = Config.minimumpearl
                    end
                end
                pearl(Config.Colors,math.ceil(price),vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustome', 'mat'), true, true, true, function()
                if Config.payementFixepearl then
                    price = Config.fixepayementpearl
                else
                    price = prix * Config.payementpearl
                    if price < Config.minimumpearl then
                        price = Config.minimumpearl
                    end
                end
                pearl(Config.Colors.matt,math.ceil(price),vehicle)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('lscustome', 'met'), true, true, true, function()
                if Config.payementFixepearl then
                    price = Config.fixepayementpearl
                else
                    price = prix * Config.payementpearl
                    if price < Config.minimumpearl then
                        price = Config.minimumpearl
                    end
                end
                pearl(Config.Colors.Metallic,math.ceil(price),vehicle)
            end, function()
            end)

------------------------------------Plaque--------------------------------------------------------------------

            RageUI.IsVisible(RMenu:Get('lscustome', 'plate'), true, true, true, function()
                if Config.payementFixeplaque then
                    price = Config.fixepayementplaque
                else
                    price = prix * Config.payementplaque
                    price = math.ceil(price)
                    if price < Config.minimumplaque then
                        price = Config.minimumplaque
                    end
                end
                for i=1, #Config.PlateColor, 1 do 
                RageUI.Button(Config.PlateColor[i].label, nil, {RightLabel = "~g~"..price.."$"}, true, function(Hovered, Active, Selected)
                    if (Active) then  
                        if myCar.plateIndex == Config.Colors[i].index then
                        else
                        SetVehicleNumberPlateTextIndex(vehicle,Config.PlateColor[i].index)
                        
                    end
                    end
                    if (Selected) then  
                        props ={
                            plateIndex = Config.PlateColor[i].index
                        }
                        upgrade(vehicle, props)
                        found = false
                        for k,v in pairs(devis) do
                            if v.label == "Plaque d'immatriculation" then
                                found = true
                            end
                        end
                        if not found then
                            table.insert(devis, {label = "Plaque d'immatriculation", value = price})
                        end
                    end
                    end)
                end
            end, function()
            end)

------------------------------------Sticker--------------------------------------------------------------------

            RageUI.IsVisible(RMenu:Get('lscustome', 'stikers'), true, true, true, function()
                --local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local modCount = GetVehicleLiveryCount(vehicle)
                if Config.payementFixestickers then
                    price = Config.fixepayementstickers
                else
                    price = prix * Config.payementstickers
                    price = math.ceil(price)
                    if price < Config.minimumFixestickers then
                        price = Config.minimumFixestickers
                    end
                end
                    for j = 0, 15, 1 do
                    --local modName = GetModTextLabel(vehicle, 48, j)
                    local modName = GetLiveryName(vehicle ,j)
                    local label = GetLabelText(modName)
                        if label == "NULL" then
                        label = "Aucun"
                        end
                        RageUI.Button(j, nil, {RightLabel = "~g~"..price.."$"}, true, function(Hovered, Active, Selected)
                            if (Active) then  
                                if myCar.modLivery == j then
                                else
                                    --SetVehicleMod(vehicle, 48, j, false)
                                    SetVehicleLivery(vehicle, j)
                            end
                            end
                            if (Selected) then  
                                props={
                                    modLivery = j
                                }
                                upgrade(vehicle, props)
                                found = false
                                for k,v in pairs(devis) do
                                 if v.label == "Stickers" then
                                        found = true
                                    end
                                end
                                if not found then
                                    table.insert(devis, {label = "Stickers", value = price})
                                end
                            end
                        end)
                    end
                end, function()
            end)

		Citizen.Wait(0)
	end
else
	lscustommen = false
end
end




function upgrade(vehicle, props)
	ESX.Game.SetVehicleProperties(vehicle, props)
 end



local Peinture = {
	{ x = -211.5, y = -1323.68, z = 30.89},
    { x = -187.16, y = -1268.89, z = 31.23},
}



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
			if IsPedInAnyVehicle(playerPed, false) and (PlayerData.job and PlayerData.job.name == 'mechanic')then
				local plyCoords = GetEntityCoords(PlayerPedId(), false)
				for k in pairs(Peinture) do
        			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Peinture[k].x, Peinture[k].y, Peinture[k].z)
        			DrawMarker(1, Peinture[k].x, Peinture[k].y, Peinture[k].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
					if dist <= 4 then
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ Peinture véhicule")
						attente = 1
						if IsControlJustReleased(0, 38) then
							local vehicle1 = GetVehiclePedIsIn(playerPed, false)
							FreezeEntityPosition(vehicle1, true)
							myCar = ESX.Game.GetVehicleProperties(vehicle1)
							devis = {}
							lsMenuIsShowe = true
                            prix = 0
                            SetVehicleEngineOn(vehicle1, false, false, true)
                            model = GetEntityModel(vehicle1)
                            carrz = GetDisplayNameFromVehicleModel(model)
                            SetVehicleModKit(vehicle1, 0)
                            ESX.TriggerServerCallback('esx_lscustom:getVehiclesPrices', function(vehicles)
                                Vehicles = vehicles
                                for k,v in pairs(Vehicles) do
                                    if v.model == string.lower(carrz) then
                                        prix = v.price
                                    end
                                end
                                ouvrirLsCusto()
                            end)
						end
					end
				end
			end
	end
end)

function color1(color,price,vehicle)
    for i=1, #color, 1 do 
        RageUI.Button(color[i].label, nil, {RightLabel = "~g~"..price.."$"}, true, function(Hovered, Active, Selected)
            if (Active) then  
                if myCar.color1 == color[i].index then
                else
                    local color2 = GetVehicleColours(vehicle)
                    SetVehicleColours(vehicle, color[i].index, color2)
                end
            if (Selected) then  
                props ={
                    color1 = color[i].index
                }
                upgrade(vehicle, props)
                found = false
                for k,v in pairs(devis) do
                    if v.label == "Peinture primaire" then
                        found = true
                    end
                end
                if not found then
                    table.insert(devis, {label = "Peinture primaire", value = price})
                end
            end
            end
            end)
        end
end

function color2(color,price,vehicle)
    for i=1, #color, 1 do 
        RageUI.Button(color[i].label, nil, {RightLabel = "~g~"..price.."$"}, true, function(Hovered, Active, Selected)
            if (Active) then  
                if myCar.color2 == color[i].index then
                else
                local color1 = GetVehicleColours(vehicle)																						
                SetVehicleColours(vehicle, color1, color[i].index)
                if (Selected) then  
                    props ={
                        color2 = color[i].index
                    }
                    upgrade(vehicle, props)
                    found = false
                for k,v in pairs(devis) do
                    if v.label == "Peinture secondaire" then
                        found = true
                    end
                end
                if not found then
                        table.insert(devis, {label = "Peinture secondaire", value = price})
                end
                end
                
                end
            end
            end)
        end
end

function pearl(color,price,vehicle)
for i=1, #color, 1 do 
    RageUI.Button(color[i].label, nil, {RightLabel = "~g~"..price.."$"}, true, function(Hovered, Active, Selected)
        if (Active) then  
            if myCar.pearlescentColor == color[i].index then
            else
            local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
            SetVehicleExtraColours(vehicle, color[i].index, wheelColor)
            if (Selected) then  
                props ={
                    pearlescentColor = color[i].index
                }
                upgrade(vehicle, props)
                for k,v in pairs(devis) do
                    if v.label == "Nacrage" then
                        found = true
                    end
                end
                if not found then
                    table.insert(devis, {label = "Nacrage", value = price})
                end
            end
        end
        end
        end)
    end
end

function touche ()
    if IsControlJustPressed(0, 194) then
        lsMenuIsShowe = false
        lscustommen = false
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        FreezeEntityPosition(vehicle, false)
        SetVehicleEngineOn(vehicle, true, false, true)
        ESX.Game.SetVehicleProperties(vehicle, myCar)
    end
    if IsControlJustReleased(0, 38) then
        lsMenuIsShowe = false
        lscustommen = false
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        FreezeEntityPosition(vehicle, false)
        SetVehicleEngineOn(vehicle, true, false, true)
        ESX.Game.SetVehicleProperties(vehicle, myCar)
    end
    if IsControlJustPressed(0, 177) then
        lsMenuIsShowe = false
        lscustommen = false
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        FreezeEntityPosition(vehicle, false)
        SetVehicleEngineOn(vehicle, true, false, true)
        ESX.Game.SetVehicleProperties(vehicle, myCar)
    end
end



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if lsMenuIsShowe then
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 168, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
            if IsPauseMenuActive() then
                lsMenuIsShowe = false
                lscustommen = false
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                FreezeEntityPosition(vehicle, false)
                SetVehicleEngineOn(vehicle, true, false, true)
                ESX.Game.SetVehicleProperties(vehicle, myCar)
			end
		else
			Citizen.Wait(500)
		end
	end
end)