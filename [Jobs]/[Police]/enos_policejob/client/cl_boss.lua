ESX = nil
local money = {}
local employe = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
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

RMenu.Add('patron', 'boss', RageUI.CreateMenu("LSPD", "Actions Patron"))
RMenu.Add('patron', 'manage',
    RageUI.CreateSubMenu(RMenu:Get('patron', 'boss'), "Management", "Accéder aux actions de Management"))
RMenu.Add('patron', 'promouvoir',
    RageUI.CreateSubMenu(RMenu:Get('patron', 'boss'), "Promotion", "Permet de promouvoir un employer"))
RMenu.Add('patron', 'retrograde',
    RageUI.CreateSubMenu(RMenu:Get('patron', 'boss'), "Rétrogradé", "Permet de rétrogradé un employer"))

Citizen.CreateThread(function()
    while true do
        local jobName = "police"
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "policeNorth" then
            jobName = "policeNorth"
        end
        RageUI.IsVisible(RMenu:Get('patron', 'boss'), true, true, true, function()
            RageUI.ButtonWithStyle("Accéder aux actions de Management", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('patron', 'manage'))
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('patron', 'manage'), true, true, true, function()
            RageUI.ButtonWithStyle("Promouvoir", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('patron', 'promouvoir'))
            RageUI.ButtonWithStyle("Rétrograder", nil, {
                RightLabel = "→"
            }, true, function()
            end, RMenu:Get('patron', 'retrograde'))
        end, function()
        end, 1)

        RageUI.IsVisible(RMenu:Get('patron', 'promouvoir'), true, true, true, function()
            for k, v in pairs(employe) do
                RageUI.ButtonWithStyle(v.name, nil, {
                    RightLabel = v.grade
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Monsieur:promote', v.identifier, jobName)
                        RageUI.CloseAll()
                    end
                end)
            end
        end, function()
        end, 1)
        RageUI.IsVisible(RMenu:Get('patron', 'retrograde'), true, true, true, function()
            for k, v in pairs(employe) do
                RageUI.ButtonWithStyle(v.name, nil, {
                    RightLabel = v.grade
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Monsieur:retrograde', v.identifier, jobName)
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

local positions = {
    ["police"] = {{
        x = 471.5,
        y = -1005.75,
        z = 29.69
    }},
    ["policeNorth"] = {{
        x = -439.76,
        y = 6004.85,
        z = 30.72
    }}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for job in pairs(positions) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == job and ESX.PlayerData.job.grade_name == 'boss' then
                for _, position in pairs(positions[job]) do
                    local plyCoords2 = GetEntityCoords(PlayerPedId(), false)
                    local dist = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, position.x, position.y, position.z)
                    DrawMarker(1, position.x, position.y, position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.25, 25,
                        95, 255, 255, false, 95, 255, 0, nil, nil, 0)

                    if dist <= 2.0 then
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ Actions patron")
                        if IsControlJustPressed(1, 51) then
                            employe = {}
                            ESX.TriggerServerCallback('Monsieur_employer_entreprise', function(employer)
                                employe = employer
                            end, job)
                            RageUI.Visible(RMenu:Get('patron', 'boss'), not RageUI.Visible(RMenu:Get('patron', 'boss')))
                        end
                    end
                end
            end
        end
    end
end)
