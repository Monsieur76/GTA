ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

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

RMenu.Add('vestiaire_pls', 'pls', RageUI.CreateMenu("Vestaire", "Mécano"))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('vestiaire_pls', 'pls'), true, true, true, function()

            RageUI.ButtonWithStyle("S'équiper de sa tenue | ~b~Civile",nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
                if Selected then
                    vcivil()
                end
            end)


            RageUI.ButtonWithStyle("S'équiper de la tenue | ~y~Travaille",nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
                if Selected then
                    vmechanic()
                end
            end)


        if ESX.PlayerData.job.grade_name == 'experimente' then
            RageUI.ButtonWithStyle("S'équiper de la tenue | ~y~Cadre",nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
                if Selected then
                    vmechanic1()
                end
            end)
        end


        if ESX.PlayerData.job.grade_name == 'boss' then
            RageUI.ButtonWithStyle("S'équiper de la tenue de | ~y~Patron",nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
                if Selected then
                    vmechanic2()
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
    {x = 612.56, y = 2849.5, z = 40.89}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(position) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pls' then 

            DrawMarker(1, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
        
            if dist <= 2.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Vestiaire")
                if IsControlJustPressed(1,51) then
                    RageUI.Visible(RMenu:Get('vestiaire_pls', 'pls'), not RageUI.Visible(RMenu:Get('vestiaire_pls', 'pls')))
                end
            end
        end
    end
    end
end)

function vmechanic()
                local model = GetEntityModel(PlayerPedId())
                local plyPed = PlayerPedId()
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    if model == GetHashKey("mp_m_freemode_01") then
                        ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                            TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                             RemoveAnimDict('mp_safehouseshower@male@')
                         end)
                         Citizen.Wait(6200)
                          clothesSkin = {
                            ['pants_1'] = 9, ['pants_2'] = 0,
                            ['shoes_1'] = 1, ['shoes_2'] = 0,
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                         ClearPedTasks(plyPed)
                         ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                            TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                             RemoveAnimDict('mp_safehouseshower@male@')
                         end)
                         Citizen.Wait(6200)
                         clothesSkin = {
                           ['bags_1'] = 0, ['bags_2'] = 0,
                            ['tshirt_1'] = -1, ['tshirt_2'] = 0,
                            ['torso_1'] = 56, ['torso_2'] = 0,
                            ['arms'] = 41,
                            ['mask_1'] = 0, ['mask_2'] = 0,
                            ['bproof_1'] = 0,
                            ['pants_1'] = 9, ['pants_2'] = 0,
                            ['shoes_1'] = 1, ['shoes_2'] = 0,
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        TriggerEvent('skinchanger:change', 'mask_1', -1)
                        TriggerEvent('skinchanger:change', 'decals_1', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', 136)
                        TriggerEvent('skinchanger:change', 'chain_1', -1)
                         ClearPedTasks(plyPed)

                        
                    else
                        ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                            TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                             RemoveAnimDict('mp_safehouseshower@female@')
                         end)
                         Citizen.Wait(6200)
                          clothesSkin = {
                            ['pants_1'] = 27, ['pants_2'] = 0,
                            ['shoes_1'] = 10, ['shoes_2'] = 0,
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                         ClearPedTasks(plyPed)
                         ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                            TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                             RemoveAnimDict('mp_safehouseshower@male@')
                         end)
                         Citizen.Wait(6200)
                         clothesSkin = {
                            ['bags_1'] = 0, ['bags_2'] = 0,
                            ['tshirt_1'] = -1, ['tshirt_2'] = 0,
                            ['torso_1'] = 195, ['torso_2'] = 0,
                            ['arms'] = 50,
                            ['pants_1'] = 27, ['pants_2'] = 0,
                            ['shoes_1'] = 10, ['shoes_2'] = 0,
                            ['bproof_1'] = 0,
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        TriggerEvent('skinchanger:change', 'mask_1', -1)
                        TriggerEvent('skinchanger:change', 'decals_1', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', 142)
                        TriggerEvent('skinchanger:change', 'chain_1', -1)
                        ClearPedTasks(plyPed)
                    end
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            end


function vcivil()
    local plyPed = PlayerPedId()
    local model = GetEntityModel(PlayerPedId())
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
        if model == GetHashKey("mp_m_freemode_01") then
        ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
            TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
             RemoveAnimDict('mp_safehouseshower@male@')
         end)
         Citizen.Wait(6200)
         clothesSkin = {
            ['pants_1'] = clothe.pants_1, ['pants_2'] = clothe.pants_2,
            ['shoes_1'] = clothe.shoes_1, ['shoes_2'] = clothe.shoes_2,
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
         ClearPedTasks(plyPed)
         ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
            TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
             RemoveAnimDict('mp_safehouseshower@male@')
         end)
         Citizen.Wait(6200)
         TriggerEvent('skinchanger:loadClothes', skin,clothe)
         TriggerEvent('skinchanger:change', 'mask_1', -1)
                        TriggerEvent('skinchanger:change', 'decals_1', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', -1)
                        TriggerEvent('skinchanger:change', 'chain_1', -1)
         ClearPedTasks(plyPed)

        else
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                 RemoveAnimDict('mp_safehouseshower@female@')
             end)
             Citizen.Wait(6200)
             clothesSkin = {
                ['pants_1'] = clothe.pants_1, ['pants_2'] = clothe.pants_2,
                ['shoes_1'] = clothe.shoes_1, ['shoes_2'] = clothe.shoes_2,
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            TriggerEvent('skinchanger:change', 'mask_1', -1)
                        TriggerEvent('skinchanger:change', 'decals_1', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', -1)
                        TriggerEvent('skinchanger:change', 'chain_1', -1)
             ClearPedTasks(plyPed)
             ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                 RemoveAnimDict('mp_safehouseshower@male@')
             end)
             Citizen.Wait(6200)
             TriggerEvent('skinchanger:loadClothes', skin,clothe)
             ClearPedTasks(plyPed)
        end
       end)
    end


    function vmechanic1()
        local model = GetEntityModel(PlayerPedId())
        local plyPed = PlayerPedId()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if model == GetHashKey("mp_m_freemode_01") then
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 47, ['pants_2'] = 0,
                    ['shoes_1'] = 61, ['shoes_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                 ClearPedTasks(plyPed)
                 ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                 clothesSkin = {
                   ['bags_1'] = 0, ['bags_2'] = 0,
                    ['tshirt_1'] = 47, ['tshirt_2'] = 3,
                    ['torso_1'] = 346, ['torso_2'] = 0,
                    ['arms'] = 37,
                    ['bproof_1'] = 0,
                    ['pants_1'] = 47, ['pants_2'] = 0,
                    ['shoes_1'] = 61, ['shoes_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'decals_1', 0)
                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                TriggerEvent('skinchanger:change', 'chain_1', -1)
                 ClearPedTasks(plyPed)

                
            else
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@female@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 11, ['pants_2'] = 0,
                    ['shoes_1'] = 10, ['shoes_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                 ClearPedTasks(plyPed)
                 ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                 clothesSkin = {
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['tshirt_1'] = -1, ['tshirt_2'] = 0,
                    ['torso_1'] = 262, ['torso_2'] = 1,
                    ['arms'] = 7,
                    ['pants_1'] = 11, ['pants_2'] = 0,
                    ['shoes_1'] = 10, ['shoes_2'] = 0,
                    ['bproof_1'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'decals_1', 0)
                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                TriggerEvent('skinchanger:change', 'chain_1', -1)
                 ClearPedTasks(plyPed)
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
    end

    function vmechanic2()
        local model = GetEntityModel(PlayerPedId())
        local plyPed = PlayerPedId()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if model == GetHashKey("mp_m_freemode_01") then
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 28, ['pants_2'] = 0,
                    ['shoes_1'] = 61, ['shoes_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                 ClearPedTasks(plyPed)
                 ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                 clothesSkin = {
                   ['bags_1'] = 0, ['bags_2'] = 0,
                    ['tshirt_1'] = 32, ['tshirt_2'] = 0,
                    ['torso_1'] = 381, ['torso_2'] = 9,
                    ['arms'] = 4,
                    ['bproof_1'] = 0,
                    ['pants_1'] = 28, ['pants_2'] = 0,
                    ['shoes_1'] = 61, ['shoes_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'decals_1', 0)
                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                TriggerEvent('skinchanger:change', 'chain_1', -1)
                 ClearPedTasks(plyPed)

                
            else
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@female@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 44, ['pants_2'] = 0,
                    ['shoes_1'] = 8, ['shoes_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                 ClearPedTasks(plyPed)
                 ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                 clothesSkin = {
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['tshirt_1'] = 52, ['tshirt_2'] = 0,
                    ['torso_1'] = 35, ['torso_2'] = 2,
                    ['arms'] = 1,
                    ['pants_1'] = 44, ['pants_2'] = 0,
                    ['shoes_1'] = 8, ['shoes_2'] = 0,
                    ['bproof_1'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'decals_1', 0)
                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                TriggerEvent('skinchanger:change', 'chain_1', -1)
                 ClearPedTasks(plyPed)
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
    end