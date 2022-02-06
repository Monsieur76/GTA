ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

------------------------------------------------------------Shops-----------------------------------------------------------------

RMenu.Add('example', 'main', RageUI.CreateMenu("L.S.M.S", "Pharmacie"))

------ Variable Sous Menu

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('example', 'main'), true, true, true, function()

            RageUI.ButtonWithStyle("Kit de soin", "Continue a sauvé des vies !", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent('kaiiroz:BuyKit')
                end
            end)
            RageUI.ButtonWithStyle("Bandage", "Continue a sauvé des vies !", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent('kaiiroz:BuyBandage')
                end
            end)
            RageUI.ButtonWithStyle("Medicament", "Continue a sauvé des vies !", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent('Monsieur:medicament')
                end
            end)
            RageUI.ButtonWithStyle("Pommade", "Continue a sauvé des vies !", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent('Monsieur:creme')
                end
            end)
            RageUI.ButtonWithStyle("Canne", "Continue a sauvé des vies !", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent('Monsieur:canne')
                end
            end)
            RageUI.ButtonWithStyle("Tenue plonger", "Continue a sauvé des vies !", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent('Monsieur:plonger')
                end
            end)

        end, function()
        end)

        Citizen.Wait(0)
    end
end)



--------------------------------------- Position du Menu --------------------------------------------

local position = {
    {x = 356.28, y = -602.02, z = 42.28 }
}
    
    
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    
        for k in pairs(position) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance'  then
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
            DrawMarker(1, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            if dist <= 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Pharmacie")
                if IsControlJustPressed(1,51) then

                            RageUI.Visible(RMenu:Get('example', 'main'), not RageUI.Visible(RMenu:Get('example', 'main')))

                end
            end
        end
		end
    end
end)

----------------------------------------------------------------------------------
--------------------------- Création du Tuto byKaiiroz ---------------------------
----------------------------------------------------------------------------------