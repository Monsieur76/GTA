ESX = nil
local money = {}
local employe = {}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5000)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


---------------- FONCTIONS ------------------

RMenu.Add('patronweazel', 'boss', RageUI.CreateMenu("LSPD", "Actions Patron"))
RMenu.Add('patronweazel', 'manage', RageUI.CreateSubMenu(RMenu:Get('patronweazel', 'boss'), "Management", "Accéder aux actions de Management"))
RMenu.Add('patronweazel', 'promouvoir', RageUI.CreateSubMenu(RMenu:Get('patronweazel', 'boss'), "Promotion", "Permet de promouvoir un employer"))
RMenu.Add('patronweazel', 'retrograde', RageUI.CreateSubMenu(RMenu:Get('patronweazel', 'boss'), "Rétrogradé", "Permet de rétrogradé un employer"))


Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('patronweazel', 'boss'), true, true, true, function()
            RageUI.ButtonWithStyle("Accéder aux actions de Management", nil, {RightLabel = "→"},true, function()
			end, RMenu:Get('patronweazel', 'manage'))
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('patronweazel', 'manage'), true, true, true, function()
            RageUI.ButtonWithStyle("Promouvoir", nil, {RightLabel = "→"},true, function()
			end, RMenu:Get('patronweazel', 'promouvoir'))
            RageUI.ButtonWithStyle("Rétrograder", nil, {RightLabel = "→"},true, function()
			end, RMenu:Get('patronweazel', 'retrograde'))
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('patronweazel', 'promouvoir'), true, true, true, function()
            for k,v in pairs(employe) do
                RageUI.ButtonWithStyle(v.name,nil, {RightLabel = v.grade}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Monsieur:promote',v.identifier,"weazel")
                        RageUI.CloseAll()
                    end
                end)
            end
        end, function()
        end, 1)
        RageUI.IsVisible(RMenu:Get('patronweazel', 'retrograde'), true, true, true, function()
            for k,v in pairs(employe) do
                RageUI.ButtonWithStyle(v.name,nil, {RightLabel = v.grade}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Monsieur:retrograde',v.identifier,"weazel")
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
    {x = -576.67, y = -938.45, z = 27.82}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(position) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'weazel' and ESX.PlayerData.job.grade_name == 'boss' then 

            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
            DrawMarker(1,position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

        
            if dist <= 2.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Actions patron")
                if IsControlJustPressed(1,51) then
                   employe = {}
                    ESX.TriggerServerCallback('Monsieur_employer_entreprise', function(employer)
                        employe = employer
                    end,"weazel")
                    RageUI.Visible(RMenu:Get('patronweazel', 'boss'), not RageUI.Visible(RMenu:Get('patronweazel', 'boss')))
                end
            end
        end
    end
    end
end)
