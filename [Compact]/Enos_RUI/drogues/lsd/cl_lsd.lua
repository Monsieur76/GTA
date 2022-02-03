ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(1000)
    end
end)

RMenu.Add('lsd', 'recolte', RageUI.CreateMenu("LSD", "Récolte"))
RMenu.Add('lsd', 'traitement', RageUI.CreateMenu("LSD", "Emballage"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('lsd', 'recolte'), true, true, true, function()

            RageUI.ButtonWithStyle("Récolter de la LSD", "SpoochCity", nil, {}, true,
                function(Hovered, Active, Selected)
                    if (Selected) then
                        recoltelsd()
                        RageUI.CloseAll()
                    end
                end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('lsd', 'traitement'), true, true, true, function()

            RageUI.ButtonWithStyle("Mettre de la LSD en sachet", "SpoochCity", nil, {}, true,
                function(Hovered, Active, Selected)
                    if (Selected) then
                        traitementlsd()
                        RageUI.CloseAll()
                    end
                end)

        end, function()
            ---Panels
        end, 1)

        Citizen.Wait(0)
    end
end)

---------------------------------------- Position du Menu --------------------------------------------

local recoltepossible = false
Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    while true do
        Wait(0)

        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        if IsEntityAtCoord(PlayerPedId(), 2920.88, 4305.30, 50.31, 1.5, 1.5, 1.5, 0, 1, 0) then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Récolter du LSD")
            if IsControlJustPressed(1, 51) then
                RageUI.Visible(RMenu:Get('lsd', 'recolte'), not RageUI.Visible(RMenu:Get('lsd', 'recolte')))
            end
        else
            recoltepossible = false
        end
    end
end)

local traitementpossible = false
Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    while true do
        Wait(0)

        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        if IsEntityAtCoord(PlayerPedId(), -1907.98, -570.87, 22.97, 1.5, 1.5, 1.5, 0, 1, 0) then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Mettre le LSD en sachet")
            if IsControlJustPressed(1, 51) then
                RageUI.Visible(RMenu:Get('lsd', 'traitement'), not RageUI.Visible(RMenu:Get('lsd', 'traitement')))
            end
        else
            traitementpossible = false
        end
    end
end)

function notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function recoltelsd()
    if not recoltepossible then
        recoltepossible = true
        while recoltepossible do
            Citizen.Wait(2000)
            TriggerServerEvent('rlsd')
        end
    else
        recoltepossible = false
    end
end

function traitementlsd()
    if not traitementpossible then
        traitementpossible = true
        while traitementpossible do
            Citizen.Wait(2000)
            TriggerServerEvent('tlsd')
        end
    else
        traitementpossible = false
    end
end
