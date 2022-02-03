ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local money = {}
local employe = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


---------------- FONCTIONS ------------------

RMenu.Add('mairie_boss', 'boss', RageUI.CreateMenu("Mairie", "Actions Patron"))
RMenu.Add('mairie_boss', 'manage', RageUI.CreateSubMenu(RMenu:Get('mairie_boss', 'boss'), "Management", "Accéder aux actions de management"))
RMenu.Add('mairie_boss', 'promouvoir', RageUI.CreateSubMenu(RMenu:Get('mairie_boss', 'boss'), "Promotion", "Permet de promouvoir un employé"))
RMenu.Add('mairie_boss', 'retrograde', RageUI.CreateSubMenu(RMenu:Get('mairie_boss', 'boss'), "Rétrograder", "Permet de rétrograder un employé"))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('mairie_boss', 'boss'), true, true, true, function()
            RageUI.ButtonWithStyle("Accéder aux actions de management", nil, {RightLabel = "→"},true, function()
			end, RMenu:Get('mairie_boss', 'manage'))
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('mairie_boss', 'manage'), true, true, true, function()
            RageUI.ButtonWithStyle("Promouvoir", nil, {RightLabel = "→"},true, function()
			end, RMenu:Get('mairie_boss', 'promouvoir'))
            RageUI.ButtonWithStyle("Rétrograder", nil, {RightLabel = "→"},true, function()
			end, RMenu:Get('mairie_boss', 'retrograde'))
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('mairie_boss', 'promouvoir'), true, true, true, function()
            for k,v in pairs(employe) do
                RageUI.ButtonWithStyle(v.name,nil, {RightLabel = v.grade}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Monsieur:promote',v.identifier,"mairie")
                        RageUI.CloseAll()
                    end
                end)
            end
        end, function()
        end, 1)
        RageUI.IsVisible(RMenu:Get('mairie_boss', 'retrograde'), true, true, true, function()
            for k,v in pairs(employe) do
                RageUI.ButtonWithStyle(v.name,nil, {RightLabel = v.grade}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Monsieur:retrograde',v.identifier,"mairie")
                        RageUI.CloseAll()
                    end
                end)
            end
        end, function()
        end, 1)

                        Citizen.Wait(0)
                                end
                            end)

---------------------------------------------

local position = {
    {x = -545.19, y = -201.94, z = 46.41}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(position) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mairie' and ESX.PlayerData.job.grade_name == 'boss' then 
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
            DrawMarker(1, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

            if dist <= 2.0  then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Actions patron")
                if IsControlJustPressed(1,51) then
                   employe = {}
                    ESX.TriggerServerCallback('Monsieur_employer_entreprise', function(employer)
                        employe = employer
                    end,"mairie")
                    RageUI.Visible(RMenu:Get('mairie_boss', 'boss'), not RageUI.Visible(RMenu:Get('mairie_boss', 'boss')))
                end
            end
        end
    end
end
end)




