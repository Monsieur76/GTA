ESX = nil

local skine

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

RMenu.Add('tenueBurger', 'burger', RageUI.CreateMenu("Vestiaire", "~b~Vestiaire"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('tenueBurger', 'burger'), true, true, true, function()

            RageUI.ButtonWithStyle("Reprendre sa tenue civile",nil, {nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    local plyPed = PlayerPedId()
                    ClearPedBloodDamage(PlayerPedId())
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
                        SetPedArmour( plyPed,0)
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
                        SetPedArmour( plyPed,0)
                        ClearPedTasks(plyPed)
                        end
                    end)
                end
            end)

            RageUI.ButtonWithStyle("Uniforme",nil, {nil}, true, function(Hovered, Active, Selected)
                if Selected then   
                    local model = GetEntityModel(PlayerPedId())
                    local plyPed = PlayerPedId()
                    ClearPedBloodDamage(PlayerPedId())
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)             
                    if skin.sex == 0 then       
                        ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                            TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                             RemoveAnimDict('mp_safehouseshower@male@')
                         end)
                         Citizen.Wait(6200)
                         clothesSkin = {
                            ['pants_1'] = 69, ['pants_2'] = 10,
                            ['shoes_1'] = 4, ['shoes_2'] = 4,
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
                             ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                             ['torso_1'] = 282, ['torso_2'] = 2,
                             ['arms'] = 11,
                             ['bproof_1'] = 0,
                             ['pants_1'] = 69, ['pants_2'] = 10,
                             ['shoes_1'] = 4, ['shoes_2'] = 4,
                             ['decals_1'] =0, ['decals_2'] = 0
                         }
                         TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                         TriggerEvent('skinchanger:change', 'mask_1', -1)
                         TriggerEvent('skinchanger:change', 'helmet_1', 132)
                         TriggerEvent('skinchanger:change', 'helmet_2', 1)
                         TriggerEvent('skinchanger:change', 'chain_1', -1)
                         ClearPedTasks(plyPed)        
                    else
                        ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                            TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                             RemoveAnimDict('mp_safehouseshower@female@')
                         end)
                         Citizen.Wait(6200)
                        clothesSkin = {
                            ['pants_1'] = 71, ['pants_2'] = 10,
                            ['shoes_1'] = 3, ['shoes_2'] = 2,
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
                            ['tshirt_1'] = 10, ['tshirt_2'] = 0,
                            ['torso_1'] = 295, ['torso_2'] = 2,
                            ['arms'] = 9,
                            ['bproof_1'] = 0,
                            ['pants_1'] = 71, ['pants_2'] = 10,
                            ['shoes_1'] = 3, ['shoes_2'] = 2,
                            ['decals_1'] =0, ['decals_2'] = 0
                        }
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        TriggerEvent('skinchanger:change', 'mask_1', -1)
                        TriggerEvent('skinchanger:change', 'helmet_1', 131)
                        TriggerEvent('skinchanger:change', 'helmet_2', 1)
                        TriggerEvent('skinchanger:change', 'chain_1', -1)
                         ClearPedTasks(plyPed)
					end 
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)  
                end)                
                end
            end)

        end, function()
        end, 1)
                        Citizen.Wait(0)
                                end
                            end)

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'burgershot' then 
                DrawMarker(1,Config.posBurger.Vestiaire.x, Config.posBurger.Vestiaire.y, Config.posBurger.Vestiaire.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.posBurger.Vestiaire.x, Config.posBurger.Vestiaire.y, Config.posBurger.Vestiaire.z)
        
            if dist <= 2.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Vestiaires")

                if IsControlJustPressed(1,51) then
                    RageUI.Visible(RMenu:Get('tenueBurger', 'burger'), not RageUI.Visible(RMenu:Get('tenueBurger', 'burger')))
                end
            end
        end
    end
end)
