ESX = nil

local armes = {}
local arme = {}
local loadout = {}

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

-------argent sale

RMenu.Add('brinksdestruc', 'main', RageUI.CreateMenu("Destruction", "Détruire argent sale"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('brinksdestruc', 'main'), true, true, true, function()
            RageUI.ButtonWithStyle("Destruction argent sale", nil, {
                RightLabel = "→"
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    ESX.ShowNotification("Destruction en cours")
                    Citizen.Wait(5000)
                    TriggerServerEvent('destructionArgentSale')
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
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'brinks' then
            local plyCoords2 = GetEntityCoords(PlayerPedId(), false)
            local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, Config.pos.destruc.position.x,
                Config.pos.destruc.position.y, Config.pos.destruc.position.z)
            DrawMarker(1, Config.pos.destruc.position.x, Config.pos.destruc.position.y, Config.pos.destruc.position.z,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

            if dist2 <= 2.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Détruire les faux billets")

                if IsControlJustPressed(1, 51) then
                    RageUI.Visible(RMenu:Get('brinksdestruc', 'main'),
                        not RageUI.Visible(RMenu:Get('brinksdestruc', 'main')))
                end
            end
        end
    end
end)

