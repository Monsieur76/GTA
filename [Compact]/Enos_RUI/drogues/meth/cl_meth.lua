ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)


RMenu.Add('meth', 'recolte', RageUI.CreateMenu("meth", "Récolte"))
RMenu.Add('meth', 'traitement', RageUI.CreateMenu("meth", "Emballage"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('meth', 'recolte'), true, true, true, function()

                RageUI.ButtonWithStyle("Récolter de la pseudoéphédrine", "SpoochCity", {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        recoltemeth()
                        RageUI.CloseAll()
                    end
                end)
            end, function()
            end)

                RageUI.IsVisible(RMenu:Get('meth', 'traitement'), true, true, true, function()

                    RageUI.ButtonWithStyle("Mettre de la Meth en sachet", "SpoochCity", {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            traitementmeth()
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
                if IsEntityAtCoord(PlayerPedId(), 3648.22, 3783.92, 21.14, 1.5, 1.5, 1.5, 0, 1, 0) then 
                    
                          RageUI.Text({
                            message = "",
                            time_display = 1
                        })
                            if IsControlJustPressed(1, 51) then
                                RageUI.Visible(RMenu:Get('meth', 'recolte'), not RageUI.Visible(RMenu:Get('meth', 'recolte')))
                   				
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
                        if IsEntityAtCoord(PlayerPedId(), 23.80, -2727.34, 6.00, 1.5, 1.5, 1.5, 0, 1, 0) then 

                                   RageUI.Text({
                                    message = "",
                                    time_display = 1
                                })
                                    if IsControlJustPressed(1, 51) then
                                       RageUI.Visible(RMenu:Get('meth', 'traitement'), not RageUI.Visible(RMenu:Get('meth', 'traitement')))
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

function recoltemeth()
    if not recoltepossible then
        recoltepossible = true
    while recoltepossible do
            Citizen.Wait(2000)
            TriggerServerEvent('rmeth')
    end
    else
        recoltepossible = false
    end
end

function traitementmeth()
    if not traitementpossible then
        traitementpossible = true
    while traitementpossible do
            Citizen.Wait(2000)
            TriggerServerEvent('tmeth')
    end
    else
        traitementpossible = false
    end
end
