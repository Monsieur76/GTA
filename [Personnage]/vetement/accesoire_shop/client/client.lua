local Keys = {
	["ESC"] = 322, 		["F1"] = 288, 		["F2"] = 289, 		["F3"] = 170, 		["F5"] = 166, 
	["F6"] = 167, 		["F7"] = 168, 		["F8"] = 169, 		["F9"] = 56, 		["F10"] = 57,
	["~"] = 243, 		["1"] = 157, 		["2"] = 158, 		["3"] = 160, 		["4"] = 164, 
	["5"] = 165,		["6"] = 159, 		["7"] = 161, 		["8"] = 162, 		["9"] = 163, 
	["-"] = 84, 		["="] = 83, 		["TAB"] = 37,		["Q"] = 44, 		["W"] = 32, 
	["E"] = 38, 		["R"] = 45, 		["T"] = 245, 		["Y"] = 246, 		["U"] = 303, 
	["P"] = 199, 		["["] = 39, 		["]"] = 40, 		["ENTER"] = 18, 	["CAPS"] = 137, 
	["A"] = 34, 		["S"] = 8, 			["D"] = 9, 			["F"] = 23, 		["G"] = 47, 
	["H"] = 74, 		["K"] = 311, 		["L"] = 182, 		["LEFTSHIFT"] = 21, ["Z"] = 20, 
	["X"] = 73, 		["C"] = 26, 		["V"] = 0, 			["B"] = 29,			["N"] = 249, 
	["M"] = 244, 		[","] = 82, 		["."] = 81, 		["LEFTCTRL"] = 36, 	["LEFTALT"] = 19,
	["SPACE"] = 22,		["RIGHTCTRL"] = 70, ["HOME"] = 213, 	["PAGEUP"] = 10, 	["PAGEDOWN"] = 11,
	["DELETE"] = 178, 	["LEFT"] = 174,		["RIGHT"] = 175, 	["TOP"] = 27, 		["DOWN"] = 173, 
	["NENTER"] = 201, 	["N4"] = 108, 		["N5"] = 60, 		["N6"] = 107,		["BACKSPACE"] = 177,
	["N+"] = 96, 		["N-"] = 97, 		["N7"] = 117, 		["N8"] = 61, 		["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
end)

local skina
local chapeauHomme = {0,2,4,5,6,7,12,13,14,15,20,21,25,26,27,28,29,30,34,37,44,45,54,55,56,58,60,61,63,64,65,66,76,77,83,94,95,96,102,103,104,105,106,107,108,109,110,120,130,131,132}
local chapeauFemme = {0,4,5,6,7,9,12,13,14,15,20,21,22,26,27,28,29,36,43,44,53,54,55,56,58,60,61,63,64,65,75,76,82,93,94,95,101,102,103,104,105,106,107,108,109,129,130,131}
local glasseHomme = {0,2,3,4,5,7,8,9,10,12,13,15,16,17,18,19,20,21,22,23}  
local glasseFemme = {0,1,2,3,4,5,6,7,8,9,10,11,14,16,17,18,19,20,21,22,23,24,25}
local accesHomme = {0,10,12,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,74,75,76,77,78,79,80,81,82,83,85,86,87,88,89,90,91,92,93,94,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,129,130,131} 
local accesFemme = {0,6,7,9,11,12,13,15,16,17,18,19,20,21,22,23,24,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,81,82,83,84,85,86,87,88,89,90,91,92,93,94,99,100,101}
local watchHomme ={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29}
local watchFemme ={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}
local earsHomme ={0,1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,35,36}
local earsFemme ={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}
local braceletHomme ={0,1,2,3,4,5,6,7,8}
local braceletFemme ={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14}
local casqueHomme = {14,16,17,18,48,49,50,51,52,53,62,67,68,69,70,71,72,73,74,75,78,79,80,81,82,84,85,86,87,88,89,90,91,92,93,127,128}
local casqueFemme = {16,17,18,47,48,49,50,51,52,62,66,67,68,69,70,71,72,73,74,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,126,127,140}

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function disableControl()
    DisableControlAction(2, 1, true)
    DisableControlAction(2, 1, true) -- Disable pan
    DisableControlAction(2, 2, true) -- Disable tilt 
    DisableControlAction(0, 59, true)
    SetPedCanPlayGestureAnims(PlayerPedId(), false)
    DisableControlAction(2, 24, true) -- Attack
    DisableControlAction(2, 257, true) -- Attack 2
    DisableControlAction(2, 25, true) -- Aim
    DisableControlAction(2, 263, true) -- Melee Attack 1
    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 257, true) -- Attack 2
    DisableControlAction(0, 25, true) -- Aim
    DisableControlAction(0, 263, true) -- Melee Attack 1
    DisableControlAction(27, 23, true) -- Also 'enter'?
    DisableControlAction(0, 23, true) -- Also 'enter'?
    DisableControlAction(0, 288, true) -- Disable phone
    DisableControlAction(0,289, true) -- Inventory
    DisableControlAction(0, 289,  true) -- Inventory block
    DisableControlAction(0, 73,  true) -- Handups
    DisableControlAction(0, 105,  true) -- Handups
    DisableControlAction(0, 29,  true) -- Point
    DisableControlAction(0, Keys['Q'], true)
    DisableControlAction(0, Keys['Z'], true)
    DisableControlAction(0, Keys['S'], true)
    DisableControlAction(0, Keys['D'], true) 
    DisablePlayerFiring(PlayerPedId(), true)
    DisableControlAction(0, 82,  true) -- Animations
    DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
    DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
    DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
    DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
    DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
    DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
    DisableControlAction(0, 257, true) -- INPUT_ATTACK2
    DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
    DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
    DisableControlAction(0, 24, true) -- INPUT_ATTACK
    DisableControlAction(0, 25, true) -- INPUT_AIM
    DisableControlAction(0, 75, true)  -- Disable exit vehicle
    DisableControlAction(27, 75, true) -- Disable exit vehicle
    DisableControlAction(0, 65, true) -- Disable f9
    DisableControlAction(0, 167, true) -- Disable f6
    DisableControlAction(2, 59, true) -- Disable steering in vehicle
    DisableControlAction(0, 47, true)  -- Disable weapon
    DisableControlAction(0, 47, true)  -- Disable weapon
    DisableControlAction(0, 264, true) -- Disable melee
    DisableControlAction(0, 257, true) -- Disable melee
    DisableControlAction(0, 140, true) -- Disable melee
    DisableControlAction(0, 141, true) -- Disable melee
    DisableControlAction(0, 142, true) -- Disable melee
    DisableControlAction(0, 143, true) -- Disable melee
end

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function CreateMain()
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x-1.75, coords.y, coords.z)
    SetCamFov(cam, 50.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateShoes()
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x-1.0, coords.y, coords.z)
    SetCamFov(cam, 50.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z-1.0)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateFutal()
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x-1.75, coords.y, coords.z-0.55)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z-0.55)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateArms()
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x-1.75, coords.y, coords.z-0.15)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z-0.15)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateTop()
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x-1.75, coords.y, coords.z+0.60)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateFace()
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x-2.0, coords.y-1.0, coords.z+0.5)
    SetCamFov(cam, 30.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z+0.5)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateBack()
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x+1.75, coords.y, coords.z+0.60)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function CreateMontre()
	local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x-1.50, coords.y-1.5, coords.z+0.60)
    SetCamFov(cam, 20.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end

function Tourner()
    local back = GetEntityHeading(PlayerPedId())
    SetEntityHeading(PlayerPedId(), back+180)
end

function Left()
    local coords = GetEntityCoords(PlayerPedId())
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords.x, coords.y-1.00, coords.z)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamShakeAmplitude(cam, 13.0)
    RenderScriptCams(1, 1, 1500, 1, 1)
end



function Angle()
    DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
end

function gettxt2(txtt)
    AddTextEntry('FMMC_MPM_NA', "Texte")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", txtt, "", "", "", 100)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
		local result = GetOnscreenKeyboardResult()
		if tonumber(result) ~= nil then
			if tonumber(result) >= 1 then

				return tonumber(result)
			else
				
			end
		else
		return result
		end
    end

end


RMenu.Add('maine', 'main', RageUI.CreateMenu("Magasin", "~b~Actions disponibles"))
RMenu.Add('maine', 'glasses', RageUI.CreateSubMenu(RMenu:Get('maine', 'main'), "Lunettes", "~b~Actions disponibles"))
RMenu.Add('maine', 'hats', RageUI.CreateSubMenu(RMenu:Get('maine', 'main'), "Chapeaux", "~b~Actions disponibles"))
RMenu.Add('maine', 'clock', RageUI.CreateSubMenu(RMenu:Get('maine', 'main'), "Montre", "~b~Actions disponibles"))
RMenu.Add('maine', 'chain', RageUI.CreateSubMenu(RMenu:Get('maine', 'main'), "Chaîne", "~b~Actions disponibles"))
RMenu.Add('maine', 'bracelets', RageUI.CreateSubMenu(RMenu:Get('maine', 'main'), "Bracelets", "~b~Actions disponibles"))
RMenu.Add('maine', 'oreille', RageUI.CreateSubMenu(RMenu:Get('maine', 'main'), "Boucles d'oreilles", "~b~Actions disponibles"))
RMenu.Add('maine', 'casque', RageUI.CreateSubMenu(RMenu:Get('maine', 'main'), "Casque", "~b~Actions disponibles"))


local listClothesho = {
	{x = -624.48, y = -231.14, z = 38.06, taskx = -624.18,tasky = -235.91 , taskz= 38.06,taskh = 65.2831}
}

local TenueTable = {}
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      for k in pairs(listClothesho) do

        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, listClothesho[k].x, listClothesho[k].y, listClothesho[k].z)
        DrawMarker(1, listClothesho[k].x, listClothesho[k].y, listClothesho[k].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)
        if dist <= 1.5 then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Changer de style")

             --   DisplayHelpTextThisFrame("HELP", false)
            if IsControlJustPressed(1, 51) then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    skina = skin
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    local playerPed = PlayerPedId()
                    if skin['sex'] == 1 then
                        SetPedPropIndex(playerPed, 1, 5, 0, 2)
                    end
                end)
                TaskPedSlideToCoord(PlayerPedId(), listClothesho[k].taskx, listClothesho[k].tasky, listClothesho[k].taskz, listClothesho[k].taskh, 1.0)
                Citizen.Wait(5000)
                CreateMain()
                DrawAnim()
                FreezeEntityPosition(PlayerPedId(), true)
                RageUI.Visible(RMenu:Get('maine', 'main'), not RageUI.Visible(RMenu:Get('maine', 'main')))
            end
        end
    end

        RageUI.IsVisible(RMenu:Get('maine', 'main'), true, true, true, function()
            Angle()
            disableControl()
            if IsControlJustPressed(0, 22) then
                Tourner()       
            end
            if IsControlJustPressed(0, 191) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)     
            end
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            RageUI.Button("Lunettes", "", { RightLabel = "→" },true, function()
            end, RMenu:Get('maine', 'glasses'))
            RageUI.Button("Chaîne", "", { RightLabel = "→" },true, function()
            end, RMenu:Get('maine', 'chain'))
            RageUI.Button("Montre", "", { RightLabel = "→" },true, function()
            end, RMenu:Get('maine', 'clock'))
            RageUI.Button("Chapeaux", "", { RightLabel = "→" },true, function()
            end, RMenu:Get('maine', 'hats'))
            RageUI.Button("Boucles d'oreilles", "", { RightLabel = "→" },true, function()
            end, RMenu:Get('maine', 'oreille'))
            RageUI.Button("Bracelets", "", { RightLabel = "→" },true, function()
            end, RMenu:Get('maine', 'bracelets'))
            RageUI.Button("Casque", "", { RightLabel = "→" },true, function()
            end, RMenu:Get('maine', 'casque'))
        end, function()
        end, 1)


        RageUI.IsVisible(RMenu:Get('maine', 'glasses'), true, true, true, function()
            CreateFace()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                local playerPed = PlayerPedId()
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        SetPedPropIndex(playerPed, 1, 5, 0, 2)
                    else
                    end
                end)
            end
            if IsControlJustPressed(0, 22) then
                Tourner()       
            end

            Angle()
            if skina["sex"] == 0 then
                local playerPed = PlayerPedId()
                for k,v in ipairs (glasseHomme) do
                RageUI.Button("lunette #"..glasseHomme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        glasses1 = v
                        glasses2 = 0
                        glasses3 = 1
                        SetPedPropIndex(playerPed, glasses3, glasses1, glasses2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", glasses1, glasses2,glasses3)
                    end
                end)
            end
        else
            local playerPed = PlayerPedId()
                for k,v in ipairs (glasseFemme) do
                RageUI.Button("lunette #"..glasseFemme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        glasses1 = v
                        glasses2 = 0
                        glasses3 = 1
                        SetPedPropIndex(playerPed, glasses3, glasses1, glasses2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", glasses1, glasses2,glasses3)
                    end
                end)
            end
        end
        end, function()
        end, 1)


        RageUI.IsVisible(RMenu:Get('maine', 'chain'), true, true, true, function()
            CreateTop()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            if IsControlJustPressed(0, 22) then
                Tourner()       
            end
            Angle()
            local playerPed = PlayerPedId()

            if skina["sex"] == 0 then
                local playerPed = PlayerPedId()
                for k,v in ipairs (accesHomme) do
                RageUI.Button("Chaine #"..accesHomme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        chain1 = v
                        chain2 = 0
                        chain3 = 7
                        SetPedComponentVariation(playerPed,chain3, chain1, chain2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", chain1, chain2,chain3)
                    end
                end)
            end
        else
            local playerPed = PlayerPedId()
            for k,v in ipairs (accesFemme) do
            RageUI.Button("Chaine #"..accesFemme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                if (Active) then
                    chain1 = v
                    chain2 = 0
                    chain3 = 7
                    SetPedComponentVariation(playerPed,chain3, chain1, chain2, 2)
                end
                if (Selected) then
                    TriggerServerEvent("dqp:SetAccessorie", chain1, chain2,chain3)
                end
            end)
        end
        end
        end, function()
        end, 1)


        RageUI.IsVisible(RMenu:Get('maine', 'oreille'), true, true, true, function()
            CreateFace()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            if IsControlJustPressed(0, 22) then
                Tourner()       
            end
            Angle()
            if skina["sex"] == 0 then
                local playerPed = PlayerPedId()
                for k,v in ipairs (earsHomme) do
                RageUI.Button("boucle d'oreille"..earsHomme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        boucl1 = v
                        boucl2 = 0
                        boucl3 = 2
                        SetPedPropIndex(playerPed, boucl3, boucl1, boucl2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", boucl1, boucl2,boucl3)
                    end
                end)
            end
            else
                local playerPed = PlayerPedId()
                for k,v in ipairs (earsFemme) do
                RageUI.Button("boucle d'oreille"..earsFemme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        boucl1 = v
                        boucl2 = 0
                        boucl3 = 2
                        SetPedPropIndex(playerPed, boucl3, boucl1, boucl2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", boucl1, boucl2,boucl3)
                    end
                end)
            end
            end
        end, function()
        end, 1)
        RageUI.IsVisible(RMenu:Get('maine', 'clock'), true, true, true, function()
            CreateMontre()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            if IsControlJustPressed(0, 22) then
                Tourner()       
            end
            Angle()
            if skina["sex"] == 0 then
                local playerPed = PlayerPedId()
                for k,v in ipairs (watchHomme) do
                RageUI.Button("Montre #"..watchHomme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        clock1 = v
                        clock2 = 0
                        clock3 = 6
                        SetPedPropIndex(playerPed, clock3, clock1, clock2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", clock1, clock2,clock3)
                    end
                end)
            end 
        else
            local playerPed = PlayerPedId()
                for k,v in ipairs (watchFemme) do
                RageUI.Button("Montre #"..watchFemme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        clock1 = v
                        clock2 = 0
                        clock3 = 6
                        SetPedPropIndex(playerPed, clock3, clock1, clock2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", clock1, clock2,clock3)
                    end
                end)
            end 
        end
        end, function()
        end, 1)
        RageUI.IsVisible(RMenu:Get('maine', 'hats'), true, true, true, function()
            CreateFace()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            if IsControlJustPressed(0, 22) then
                Tourner()       
            end
            Angle()
        if skina["sex"] == 0 then
            local playerPed = PlayerPedId()
            for k,v in ipairs (chapeauHomme) do
                RageUI.Button("chapeau #"..chapeauHomme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        hats1 = v
                        hats2 = 0
                        hats3 = 0
                        SetPedPropIndex(playerPed, hats3, hats1, hats2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", hats1, hats2,hats3)
                    end
                end)
        
            end
        else
            local playerPed = PlayerPedId()
            for k,v in ipairs (chapeauFemme) do
                RageUI.Button("chapeau #"..chapeauFemme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        hats1 = v
                        hats2 = 0
                        hats3 = 0
                        SetPedPropIndex(playerPed, hats3, hats1, hats2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", hats1, hats2,hats3)
                    end
                end)
        
            end
        end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('maine', 'casque'), true, true, true, function()
            CreateFace()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            if IsControlJustPressed(0, 22) then
                Tourner()       
            end
            Angle()
        if skina["sex"] == 0 then
            local playerPed = PlayerPedId()
            for k,v in ipairs (casqueHomme) do
                RageUI.Button("chapeau #"..casqueHomme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        hats1 = v
                        hats2 = 0
                        hats3 = 0
                        SetPedPropIndex(playerPed, hats3, hats1, hats2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorieCasque", hats1, hats2)
                    end
                end)
        
            end
        else
            local playerPed = PlayerPedId()
            for k,v in ipairs (casqueFemme) do
                RageUI.Button("chapeau #"..casqueFemme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        hats1 = v
                        hats2 = 0
                        hats3 = 0
                        SetPedPropIndex(playerPed, hats3, hats1, hats2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorieCasque", hats1, hats2)
                    end
                end)
        
            end
        end
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('maine', 'bracelets'), true, true, true, function()
            CreateFace()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 177) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    end
                end)
            end
            if IsControlJustPressed(0, 22) then
                Tourner()       
            end
            Angle()
            local playerPed = PlayerPedId()
            if skina["sex"] == 0 then
                local playerPed = PlayerPedId()
                for k,v in ipairs (braceletHomme) do
                RageUI.Button("Bracelets #"..braceletHomme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        bracelets1 = v
                        bracelets2 = 0
                        bracelets3 = 7
                        SetPedPropIndex(playerPed, bracelets3, bracelets1, bracelets2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetAccessorie", bracelets1, bracelets2,4)
                    end
                end)
            end
        else
            local playerPed = PlayerPedId()
            for k,v in ipairs (braceletFemme) do
            RageUI.Button("Bracelets #"..braceletFemme[k], "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~25$" }, true, function(Hovered, Active, Selected)
                if (Active) then
                    bracelets1 = v
                    bracelets2 = 0
                    bracelets3 = 7
                    SetPedPropIndex(playerPed, bracelets3, bracelets1, bracelets2, 2)
                end
                if (Selected) then
                    TriggerServerEvent("dqp:SetAccessorie", bracelets1, bracelets2,bracelets3)
                end
            end)
        end
            end

        end, function()
        end, 1)
        end
    end)



local blips = {
	{title="Magasin d'accessoires", colour=8, id=102, x = -624.48, y = -231.14, z = 38.06}
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.75)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
	end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

--Citizen.CreateThread(function()
--	while true do
--	  Citizen.Wait(0)
--      if IsControlJustPressed(0, 47) then
--        ESX.TriggerServerCallback("shop:getMask", function(result)
--            MaskTab = result
--        end)
--        Wait(25)
--        RageUI.Visible(RMenu:Get('aces', 'access'), not RageUI.Visible(RMenu:Get('aces', 'access')))
--	  end
--	end
--  end)



function DrawAnim()
    local ped = PlayerPedId()
    local ad = "clothingshirt"
    loadAnimDict(ad)
    RequestAnimDict(dict)
    TaskPlayAnim(ped, ad, "check_out_a", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
    TaskPlayAnim(ped, ad, "check_out_b", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
    TaskPlayAnim(ped, ad, "check_out_c", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
    TaskPlayAnim(ped, ad, "intro", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
    TaskPlayAnim(ped, ad, "outro", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
    TaskPlayAnim(ped, ad, "try_shirt_base", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
    TaskPlayAnim(ped, ad, "try_shirt_positive_a", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
    TaskPlayAnim(ped, ad, "try_shirt_positive_b", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
    TaskPlayAnim(ped, ad, "try_shirt_positive_c", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
    TaskPlayAnim(ped, ad, "try_shirt_positive_d", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
end


