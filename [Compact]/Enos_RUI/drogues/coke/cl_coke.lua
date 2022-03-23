ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
end)

RMenu.Add('coke', 'recolte', RageUI.CreateMenu("Coke", "Récolte"))
RMenu.Add('coke', 'traitement', RageUI.CreateMenu("Coke", "Emballage"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('weed', 'recolte'), true, true, true, function()

            RageUI.ButtonWithStyle("Récolter de la Coke", "SpoochCity", {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    recoltecoke()
                    RageUI.CloseAll()
                end
            end)
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('weed', 'traitement'), true, true, true, function()

            RageUI.ButtonWithStyle("Mettre de la Coke en Sachet", "SpoochCity", {}, true,
                function(Hovered, Active, Selected)
                    if (Selected) then
                        traitementcoke()
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
        if IsEntityAtCoord(PlayerPedId(), -238.10, 3510.32, 104.48, 1.5, 1.5, 1.5, 0, 1, 0) then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Récolter de la coke")
            if IsControlJustPressed(1, 51) then
                RageUI.Visible(RMenu:Get('coke', 'recolte'), not RageUI.Visible(RMenu:Get('coke', 'recolte')))
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
        if IsEntityAtCoord(PlayerPedId(), 195.41, -3209.08, -5.79, 1.5, 1.5, 1.5, 0, 1, 0) then
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Mettre la coke en sachet")
            if IsControlJustPressed(1, 51) then
                RageUI.Visible(RMenu:Get('coke', 'traitement'), not RageUI.Visible(RMenu:Get('coke', 'traitement')))
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

function recoltecoke()
    if not recoltepossible then
        recoltepossible = true
        while recoltepossible do
            Citizen.Wait(2000)
            TriggerServerEvent('rcoke')
        end
    else
        recoltepossible = false
    end
end

function traitementcoke()
    if not traitementpossible then
        traitementpossible = true
        while traitementpossible do
            Citizen.Wait(10000)
            TriggerServerEvent('tcoke')
        end
    else
        traitementpossible = false
    end
end
