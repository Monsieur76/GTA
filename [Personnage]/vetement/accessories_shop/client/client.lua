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

RegisterNetEvent('shop:SyncAccess')
AddEventHandler('shop:SyncAccess', function()
    ESX.TriggerServerCallback("shop:getMask", function(result)
        MaskTab = result
    end)
end)

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


RMenu.Add('aces', 'main', RageUI.CreateMenu("Magasin", "~b~Actions disponibles"))
RMenu.Add('aces', 'masks', RageUI.CreateSubMenu(RMenu:Get('aces', 'main'), "Masques", "~b~Actions disponibles"))


local listClotheshop = {
	{x = -1338.81,    y = -1278.25, z = 4.88, taskx = -1336.61, tasky = -1277.93, taskz= 4.87,taskh = 94.7466}
}

MaskTab = {}
local TenueTable = {}
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      for k in pairs(listClotheshop) do

        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, listClotheshop[k].x, listClotheshop[k].y, listClotheshop[k].z)
        DrawMarker(1, listClotheshop[k].x, listClotheshop[k].y, listClotheshop[k].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)

        if dist <= 1.5 then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Changer de style")

            attente = 1
            if IsControlJustPressed(1, 51) then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                    TriggerEvent('skinchanger:loadClothes', skin,clothe)
                    Citizen.Wait(3000)
                    TriggerEvent('skinchanger:change', 'glasses_1', 5)
                    TriggerEvent('skinchanger:change', 'mask_1', 5)
                    if skin['sex'] == 1 then
                        TriggerEvent('skinchanger:loadClothesAccesorie', skin,clothe, {['mask_1'] = -1, ['mask_2'] = 0})
                        TriggerEvent('skinchanger:loadClothesAccesorie', skin,clothe,{['glasses_1'] = -1, ['glasses_2'] = 0})
                        TriggerEvent('skinchanger:loadClothesAccesorie', skin,clothe, {['helmet_1'] = -1, ['helmet_2'] = 0})

                    else
                        TriggerEvent('skinchanger:loadClothesAccesorie', skin,clothe, {['mask_1'] = -1, ['mask_2'] = 0})
                        TriggerEvent('skinchanger:loadClothesAccesorie', skin,clothe,{['glasses_1'] = -1, ['glasses_2'] = 0})
                        TriggerEvent('skinchanger:loadClothesAccesorie', skin,clothe, {['helmet_1'] = -1, ['helmet_2'] = 0})

                    end
                end)
                TaskPedSlideToCoord(PlayerPedId(), listClotheshop[k].taskx, listClotheshop[k].tasky, listClotheshop[k].taskz, listClotheshop[k].taskh, 1.0)
                Citizen.Wait(5000)
                CreateMain()
                DrawAnim()
                FreezeEntityPosition(PlayerPedId(), true)
                RageUI.Visible(RMenu:Get('aces', 'main'), not RageUI.Visible(RMenu:Get('aces', 'main')))
            end
        end
    end
        RageUI.IsVisible(RMenu:Get('aces', 'main'), true, true, true, function()
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
            RageUI.Button("Masques", "", { RightLabel = "→" },true, function()
            end, RMenu:Get('aces', 'masks'))
        end, function()
        end, 1)
        RageUI.IsVisible(RMenu:Get('aces', 'masks'), true, true, true, function()
            CreateFace()
            Angle()
            if IsControlJustPressed(0, 194) then
                RenderScriptCams(0, 1, 1000, 1, 1)
                DestroyAllCams(true)
            end
            if IsControlJustPressed(0, 22) then
                Tourner()
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
            local playerPed = PlayerPedId()
            maskName = {}
            for i=0,147 do 
                RageUI.Button("Masque "..i, "Cette tenue est disponible dans notre magasin.", { RightLabel = "~g~350$" }, true, function(Hovered, Active, Selected)
                    if (Active) then
                        mask1 = i
                        mask2 = 0
                        SetPedComponentVariation(playerPed, 1, mask1,mask2, 2)
                    end
                    if (Selected) then
                        TriggerServerEvent("dqp:SetNewMasque", mask1, mask2)
                    end
                end)
            end
        end, function()
        end, 1)
        end
    end)



local blips = {
	{title="Magasin de masque", colour=8, id=362, x = -1336.73, y = -1277.44, z = 4.88}
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


