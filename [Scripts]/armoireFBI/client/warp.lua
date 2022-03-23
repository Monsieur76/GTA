ESX = nil
local compteur
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

local position = {{
    name = "principal",
    x = 136.07,
    y = -761.69,
    z = 241.15
}, {
    name = "rdc",
    x = 139.08,
    y = -762.67,
    z = 44.75
}, {
    name = "garage",
    x = 92.57,
    y = -724.96,
    z = 32.13
}}

RMenu.Add('ascenseur', 'main', RageUI.CreateMenu("Ascenseur", "Ascenseur"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('ascenseur', 'main'), true, true, true, function()
            RageUI.ButtonWithStyle("Étage Principal", nil, {
                RightLabel = "→→→"
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local playerPed = PlayerPedId()
                    SetEntityCoords(playerPed, position[1].x, position[1].y, position[1].z, true, true, true, true)
                    SetEntityHeading(playerPed, 0)
                    RageUI.CloseAll()
                end
            end)
            RageUI.ButtonWithStyle("Rez-de-chaussée", nil, {
                RightLabel = "→→→"
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local playerPed = PlayerPedId()
                    SetEntityCoords(playerPed, position[2].x, position[2].y, position[2].z, true, true, true, true)
                    SetEntityHeading(playerPed, 0)
                    RageUI.CloseAll()
                end
            end)
            RageUI.ButtonWithStyle("Garage", nil, {
                RightLabel = "→→→"
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local playerPed = PlayerPedId()
                    SetEntityCoords(playerPed, position[3].x, position[3].y, position[3].z, true, true, true, true)
                    SetEntityHeading(playerPed, 113.78)
                    RageUI.CloseAll()
                end
            end)
        end, function()
        end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(position) do
            local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, position[k].x, position[k].y, position[k].z)
            DrawMarker(1, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25,
                95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            if dist3 <= 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Ascenseur")
                if IsControlJustPressed(1, 51) then
                    RageUI.Visible(RMenu:Get('ascenseur', 'main'), not RageUI.Visible(RMenu:Get('ascenseur', 'main')))
                end
            end
        end
    end
end)
