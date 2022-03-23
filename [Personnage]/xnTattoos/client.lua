local currentTattoos = {}
local cam = nil
local back = 1
local opacity = 1
local scaleType = nil
local scaleString = ""

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	AddTextEntry("ParaTattoos", "Salon de tatouage")
	for k, v in pairs(Config.Shops) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite(blip, 75)
		SetBlipColour(blip, 1)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("ParaTattoos")
		EndTextCommandSetBlipName(blip)
	end
end)

AddEventHandler('skinchanger:modelLoaded', function()
	ESX.TriggerServerCallback('SmallTattoos:GetPlayerTattoos', function(tattooList)
		if tattooList then
			ClearPedDecorations(PlayerPedId())
			for k, v in pairs(tattooList) do
				if v.Count ~= nil then
					for i = 1, v.Count do
						SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
					end
				else
					SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
				end
			end
			currentTattoos = tattooList
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
		if not IsMenuOpen() then
			ESX.TriggerServerCallback('SmallTattoos:GetPlayerTattoos', function(tattooList)
				if tattooList then
					ClearPedDecorations(PlayerPedId())
					for k, v in pairs(tattooList) do
						if v.Count ~= nil then
							for i = 1, v.Count do
								SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
							end
						else
							SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
						end
					end
					currentTattoos = tattooList
				end
			end)
		end
	end
end)

function DrawTattoo(collection, name)
	ClearPedDecorations(PlayerPedId())
	for k, v in pairs(currentTattoos) do
		if v.Count ~= nil then
			for i = 1, v.Count do
				SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
			end
		else
			SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
		end
	end
	for i = 1, opacity do
		SetPedDecoration(PlayerPedId(), collection, name)
	end
end

function GetNaked()
		local model = GetEntityModel(PlayerPedId())
        local plyPed = PlayerPedId()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)        
		if GetEntityModel(PlayerPedId()) == 1885233650 then     
                        ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                            TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                             RemoveAnimDict('mp_safehouseshower@male@')
                         end)
                         Citizen.Wait(6200)
                          clothesSkin = {
                            ['pants_1'] = 14, ['pants_2'] = 0,
                            ['shoes_1'] = 5, ['shoes_2'] = 0,
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                         ClearPedTasks(plyPed)
                         ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                            TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                             RemoveAnimDict('mp_safehouseshower@male@')
                         end)
                         Citizen.Wait(6200)
                         clothesSkin = {
                           ['bags_1'] = 0, ['bags_2'] = 0,
                            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                            ['torso_1'] = 91, ['torso_2'] = 0,
                            ['arms'] = 15,
                            ['bproof_1'] = 0,
                            ['pants_1'] = 14, ['pants_2'] = 0,
                            ['shoes_1'] = 5, ['shoes_2'] = 0,
                            ['decals_1'] =0, ['decals_2'] = 0
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        TriggerEvent('skinchanger:change', 'mask_1', 121)
                        TriggerEvent('skinchanger:change', 'helmet_1', -1)
                        TriggerEvent('skinchanger:change', 'chain_1', -1)
						TriggerEvent('skinchanger:change', 'glasses_1', 0)
                         ClearPedTasks(plyPed)
		else
			ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
				TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
				 RemoveAnimDict('mp_safehouseshower@female@')
			 end)
			 Citizen.Wait(6200)
			  clothesSkin = {
				['pants_1'] = 16, ['pants_2'] = 0,
				['shoes_1'] = 5, ['shoes_2'] = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			 ClearPedTasks(plyPed)
			 ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
				TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
				 RemoveAnimDict('mp_safehouseshower@male@')
			 end)
			 Citizen.Wait(6200)
			 clothesSkin = {
				['bags_1'] = 0, ['bags_2'] = 0,
				['tshirt_1'] = 34, ['tshirt_2'] = 0,
				['torso_1'] = 101, ['torso_2'] = 1,
				['arms'] = 15,
				['bproof_1'] = 0,
				['pants_1'] = 16, ['pants_2'] = 0,
				['shoes_1'] = 5, ['shoes_2'] = 0,
				['decals_1'] =0, ['decals_2'] = 0
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			TriggerEvent('skinchanger:change', 'mask_1', 121)
			TriggerEvent('skinchanger:change', 'helmet_1', -1)
			TriggerEvent('skinchanger:change', 'chain_1', -1)
			TriggerEvent('skinchanger:change', 'glasses_1',5)
			 ClearPedTasks(plyPed)
		end
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end

function ResetSkin()
	local plyPed = PlayerPedId()
    local model = GetEntityModel(PlayerPedId())
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
    if model == GetHashKey("mp_m_freemode_01") then
                        ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                         TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                            RemoveAnimDict('mp_safehouseshower@male@')
                        end)
                        Citizen.Wait(6200)
                        clothesSkin = {
                            ['pants_1'] = clothe.pants_1, ['pants_2'] = clothe.pants_2,
                             ['shoes_1'] = clothe.shoes_1, ['shoes_2'] = clothe.shoes_2,
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        ClearPedTasks(plyPed)
                        ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                        TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                        RemoveAnimDict('mp_safehouseshower@male@')
                        end)
                        Citizen.Wait(6200)
                        TriggerEvent('skinchanger:loadClothes', skin,clothe)
                        TriggerEvent('skinchanger:change', 'mask_1', -1)
                        TriggerEvent('skinchanger:change', 'decals_1', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', -1)
                        TriggerEvent('skinchanger:change', 'chain_1', -1)
                         ClearPedTasks(plyPed)

                        else
                        ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                        TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                        RemoveAnimDict('mp_safehouseshower@female@')
                        end)
                        Citizen.Wait(6200)
                        clothesSkin = {
                        ['pants_1'] = clothe.pants_1, ['pants_2'] = clothe.pants_2,
                        ['shoes_1'] = clothe.shoes_1, ['shoes_2'] = clothe.shoes_2,
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        ClearPedTasks(plyPed)
                        ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                        TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                         RemoveAnimDict('mp_safehouseshower@male@')
                        end)
                        Citizen.Wait(6200)
                        TriggerEvent('skinchanger:loadClothes', skin,clothe)
                        TriggerEvent('skinchanger:change', 'mask_1', -1)
                        TriggerEvent('skinchanger:change', 'decals_1', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', -1)
                        TriggerEvent('skinchanger:change', 'chain_1', -1)
                        ClearPedTasks(plyPed)
					end
                        end)
	ClearPedDecorations(PlayerPedId())
	for k, v in pairs(currentTattoos) do
		if v.Count ~= nil then
			for i = 1, v.Count do
				SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
			end
		else
			SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
		end
	end
end

function ReqTexts(text, slot)
	RequestAdditionalText(text, slot)
	while not HasAdditionalTextLoaded(slot) do
		Citizen.Wait(0)
	end
end

function OpenTattooShop()
	JayMenu.OpenMenu("tattoo")
	FreezeEntityPosition(PlayerPedId(), true)
	GetNaked()
	ReqTexts("TAT_MNU", 9)
end

function CloseTattooShop()
	ClearAdditionalText(9, 1)
	FreezeEntityPosition(PlayerPedId(), false)
	EnableAllControlActions(0)
	back = 1
	opacity = 1
	ResetSkin()
	return true
end

function ButtonPress()
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function IsMenuOpen()
	return (JayMenu.IsMenuOpened('tattoo') or string.find(tostring(JayMenu.CurrentMenu() or ""), "ZONE_"))	
end

function BuyTattoo(collection, name, label, price)
	ESX.TriggerServerCallback('SmallTattoos:PurchaseTattoo', function(success)
		if success then
			table.insert(currentTattoos, {collection = collection, nameHash = name, Count = opacity})
		end
	end, currentTattoos, price, {collection = collection, nameHash = name, Count = opacity}, GetLabelText(label))
end

function RemoveTattoo(name, label)
	for k, v in pairs(currentTattoos) do
		if v.nameHash == name then
			table.remove(currentTattoos, k)
		end
	end
	TriggerServerEvent("SmallTattoos:RemoveTattoo", currentTattoos)
	ESX.ShowNotification("Vous avez retiré le tatouage ~y~" .. GetLabelText(label) .. "~s~")
end

function CreateScale(sType)
	if scaleString ~= sType and sType == "OpenShop" then
		--scaleType = setupScaleform("instructional_buttons", "", 38)
		scaleString = sType
	elseif scaleString ~= sType and sType == "Control" then
		scaleType = setupScaleform2("instructional_buttons", "Changer la vue", 21, "Change Opacity", {90, 89}, "Acheter/Enlever le tatouage", 191)
		scaleString = sType
	end
end

local listeShop = {
	{x= 1322.6, y=-1651.9, z=51.2}, --fait
	{x=-1153.6,y= -1425.6, z=3.9},--fait
	{x=322.1, y=180.4,z= 102.5},--fait
	{x=-3170.0, y=1075.0, z=19.8},
	{x=1864.6, y=3747.7, z=32.0},
	{x=-293.7, y=6200.0,z= 30.4} --fait
}

Citizen.CreateThread(function()
	while true do 
        Citizen.Wait(0)
		for k,v in ipairs(listeShop) do
		DrawMarker(1, listeShop[k].x, listeShop[k].y, listeShop[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)
		end
	end
end)

Citizen.CreateThread(function()
	JayMenu.CreateMenu("tattoo", "Tattoo Shop", function()
        return CloseTattooShop()
    end)
    JayMenu.SetSubTitle('tattoo', "Categories")
	
	for k, v in ipairs(Config.TattooCats) do
		JayMenu.CreateSubMenu(v[1], "tattoo", v[2])
		JayMenu.SetSubTitle(v[1], v[2])
	end

    while true do 
        Citizen.Wait(0)
		local CanSleep = true
		if not IsMenuOpen() then
			for _,interiorId in ipairs(Config.interiorIds) do
				if GetInteriorFromEntity(PlayerPedId()) == interiorId then
					CanSleep = false
					if not IsPedInAnyVehicle(PlayerPedId(), false) then
						CreateScale("OpenShop")
						DrawScaleformMovieFullscreen(scaleType, 255, 255, 255, 255, 0)

						SetTextComponentFormat('STRING')
						AddTextComponentString("~INPUT_CONTEXT~ Tatoueur")
						DisplayHelpTextFromStringLabel(0, 0, 0, -1)
						if IsControlJustPressed(0, 38) then
							OpenTattooShop()
						end
					end
				end
			end
		end

		if IsMenuOpen() then
			DisableAllControlActions(0)
			CanSleep = false
		end
		
        if JayMenu.IsMenuOpened('tattoo') then
			CanSleep = false
            for k, v in ipairs(Config.TattooCats) do
				JayMenu.MenuButton(v[2], v[1])
			end
			ClearPedDecorations(PlayerPedId())
			for k,v in pairs(currentTattoos) do
				if v.Count ~= nil then
					for i = 1, v.Count do
						SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
					end
				else
					SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
				end
			end
			if DoesCamExist(cam) then
				DetachCam(cam)
				SetCamActive(cam, false)
				RenderScriptCams(false, false, 0, 1, 0)
				DestroyCam(cam, false)
			end
			JayMenu.Display()
        end
		for k, v in ipairs(Config.TattooCats) do
			if JayMenu.IsMenuOpened(v[1]) then
				CanSleep = false
				if not DoesCamExist(cam) then
					cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
					SetCamActive(cam, true)
					RenderScriptCams(true, false, 0, true, true)
					StopCamShaking(cam, true)
				end
				CreateScale("Control")
				DrawScaleformMovieFullscreen(scaleType, 255, 255, 255, 255, 0)
				if IsDisabledControlJustPressed(0, 21) then
					ButtonPress()
					if back == #v[3] then
						back = 1
					else
						back = back + 1
					end
				end
				if IsDisabledControlJustPressed(0, 90) then
					ButtonPress()
					if opacity == 10 then
						opacity = 10
					else
						opacity = opacity + 1
					end
				end
				if IsDisabledControlJustPressed(0, 89) then
					ButtonPress()
					if opacity == 1 then
						opacity = 1
					else
						opacity = opacity - 1
					end
				end
				if GetCamCoord(cam) ~= GetOffsetFromEntityInWorldCoords(PlayerPedId(), v[3][back]) then
					SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), v[3][back]))
					PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), v[4]))
				end
				for _, tattoo in pairs(Config.AllTattooList) do
					if tattoo.Zone == v[1] then
						if GetEntityModel(PlayerPedId()) == "mp_m_freemode_01" then
							if tattoo.HashNameMale ~= '' then
								local found = false
								for k, v in pairs(currentTattoos) do
									if v.nameHash == tattoo.HashNameMale then
										found = true
										break
									end
								end
								if found then
									local clicked, hovered = JayMenu.SpriteButton(GetLabelText(tattoo.Name), "commonmenu", "shop_tattoos_icon_a", "shop_tattoos_icon_b")
									if clicked then
										RemoveTattoo(tattoo.HashNameMale, tattoo.Name)
									end
								else
									local price = math.ceil(tattoo.Price / 20) == 0 and 100 or math.ceil(tattoo.Price / 20)
									local clicked, hovered = JayMenu.Button(GetLabelText(tattoo.Name), "~HUD_COLOUR_GREENDARK~$" .. price)
									if clicked then
										BuyTattoo(tattoo.Collection, tattoo.HashNameMale, tattoo.Name, price)
									elseif hovered then
										DrawTattoo(tattoo.Collection, tattoo.HashNameMale)
									end
								end
							end
						else
							if tattoo.HashNameFemale ~= '' then
								local found = false
								for k, v in pairs(currentTattoos) do
									if v.nameHash == tattoo.HashNameFemale then
										found = true
										break
									end
								end
								if found then
									local clicked, hovered = JayMenu.SpriteButton(GetLabelText(tattoo.Name), "commonmenu", "shop_tattoos_icon_a", "shop_tattoos_icon_b")
									if clicked then
										RemoveTattoo(tattoo.HashNameFemale, tattoo.Name)
									end
								else
									local price = math.ceil(tattoo.Price / 20) == 0 and 100 or math.ceil(tattoo.Price / 20)
									local clicked, hovered = JayMenu.Button(GetLabelText(tattoo.Name), "~HUD_COLOUR_GREENDARK~$" .. price)
									if clicked then
										BuyTattoo(tattoo.Collection, tattoo.HashNameFemale, tattoo.Name, price)
									elseif hovered then
										DrawTattoo(tattoo.Collection, tattoo.HashNameFemale)
									end
								end
							end
						end
					end
				end
				JayMenu.Display()
			end
		end
		if CanSleep then
			Citizen.Wait(3000)
		end
    end
end)

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    PushScaleformMovieMethodParameterButtonName(ControlButton)
end

function setupScaleform2(scaleform, message, button, message2, buttons, message3, button2)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
	
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, buttons[1], true))
    Button(GetControlInstructionalButton(2, buttons[2], true))
    ButtonMessage(message2)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, button, true))
    ButtonMessage(message)
    PopScaleformMovieFunctionVoid()
	
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, button2, true))
    ButtonMessage(message3)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function setupScaleform(scaleform, message, button)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, button, true))
    ButtonMessage(message)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end
