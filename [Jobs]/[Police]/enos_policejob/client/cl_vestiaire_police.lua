ESX = nil

local gpb =false

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

RMenu.Add('tenue', 'vpolice', RageUI.CreateMenu("Vestaire", "~b~Vestiaire"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('tenue', 'vpolice'), true, true, true, function()
            --Tenue Civil
            RageUI.ButtonWithStyle("Reprendre sa tenue civile", nil, {nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("service:true",false)
                    local plyPed = PlayerPedId()
                    local model = GetEntityModel(PlayerPedId())
                    ClearPedBloodDamage(PlayerPedId())
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                        if model == GetHashKey("mp_m_freemode_01") then
                            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water',
                                    8.0, 1.0, 22533, 0, 0, false, false, false)
                                RemoveAnimDict('mp_safehouseshower@male@')
                            end)
                            Citizen.Wait(6200)
                            clothesSkin = {
                                ['pants_1'] = clothe.pants_1,
                                ['pants_2'] = clothe.pants_2,
                                ['shoes_1'] = clothe.shoes_1,
                                ['shoes_2'] = clothe.shoes_2
                            }
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                            ClearPedTasks(plyPed)
                            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                                    8.0, 1.0, 22533, 0, 0, false, false, false)
                                RemoveAnimDict('mp_safehouseshower@male@')
                            end)
                            Citizen.Wait(6200)
                            TriggerEvent('skinchanger:loadClothes', skin, clothe)
                            TriggerEvent('skinchanger:change', 'mask_1', -1)
                            TriggerEvent('skinchanger:change', 'decals_1', 0)
                            TriggerEvent('skinchanger:change', 'helmet_1', -1)
                            TriggerEvent('skinchanger:change', 'chain_1', -1)
                            SetPedArmour(plyPed, 0)
                            TriggerEvent('armorEnable')
                            gpb = false
                            ClearPedTasks(plyPed)

                        else
                            ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                    8.0, 1.0, 22533, 0, 0, false, false, false)
                                RemoveAnimDict('mp_safehouseshower@female@')
                            end)
                            Citizen.Wait(6200)
                            clothesSkin = {
                                ['pants_1'] = clothe.pants_1,
                                ['pants_2'] = clothe.pants_2,
                                ['shoes_1'] = clothe.shoes_1,
                                ['shoes_2'] = clothe.shoes_2
                            }
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                            ClearPedTasks(plyPed)
                            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                                    8.0, 1.0, 22533, 0, 0, false, false, false)
                                RemoveAnimDict('mp_safehouseshower@male@')
                            end)
                            Citizen.Wait(6200)
                            TriggerEvent('skinchanger:loadClothes', skin, clothe)
                            TriggerEvent('skinchanger:change', 'mask_1', -1)
                            TriggerEvent('skinchanger:change', 'decals_1', 0)
                            TriggerEvent('skinchanger:change', 'helmet_1', -1)
                            TriggerEvent('skinchanger:change', 'chain_1', -1)
                            SetPedArmour(plyPed, 0)
                            TriggerEvent('armorEnable')
                            gpb = false
                            ClearPedTasks(plyPed)
                        end
                    end)
                end
            end)
            --Tenue Cadet
            if ESX.PlayerData.job.grade == 0 then
                RageUI.ButtonWithStyle("Uniforme", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 319,
                                    ['torso_2'] = 0,
                                    ['arms'] = 11,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 330,
                                    ['torso_2'] = 0,
                                    ['arms'] = 14,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
            end
            --Tenue Officer
            if ESX.PlayerData.job.grade == 1 then
                RageUI.ButtonWithStyle("Uniforme", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 55,
                                    ['torso_2'] = 0,
                                    ['arms'] = 0,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 48,
                                    ['torso_2'] = 0,
                                    ['arms'] = 14,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
            end
            --Tenue Ceremonie Cadet et Officier
            if ESX.PlayerData.job.grade == 0 or ESX.PlayerData.job.grade == 1 then
                RageUI.ButtonWithStyle("Tenue Ceremonie", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 10,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 10,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 153,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 153,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 322,
                                    ['torso_2'] = 0,
                                    ['arms'] = 77,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 10,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 10,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', 38)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 7,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 6,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 189,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 189,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 333,
                                    ['torso_2'] = 0,
                                    ['arms'] = 88,
                                    ['pants_1'] = 7,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 6,
                                    ['shoes_2'] = 0,
                                    ['helmet_1'] = 0,
                                    ['helmet_2'] = 0,
                                    ['chain_1'] = 0,
                                    ['bproof_1'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0

                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', 22)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
            end
            --Tenue Sergent
            if ESX.PlayerData.job.grade == 2 then
                RageUI.ButtonWithStyle("Uniforme", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 55,
                                    ['torso_2'] = 0,
                                    ['arms'] = 0,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 8,
                                    ['decals_2'] = 1
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 48,
                                    ['torso_2'] = 0,
                                    ['arms'] = 14,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 7,
                                    ['decals_2'] = 1
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Uniforme Hiver", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 316,
                                    ['torso_2'] = 0,
                                    ['arms'] = 6,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 8,
                                    ['decals_2'] = 1
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 48,
                                    ['torso_2'] = 0,
                                    ['arms'] = 14,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 7,
                                    ['decals_2'] = 1
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Tenue Ceremonie", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 10,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 10,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 153,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 153,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 322,
                                    ['torso_2'] = 0,
                                    ['arms'] = 77,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 10,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 10,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 8,
                                    ['decals_2'] = 1
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', 38)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 7,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 6,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 189,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 189,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 333,
                                    ['torso_2'] = 0,
                                    ['arms'] = 88,
                                    ['pants_1'] = 7,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 6,
                                    ['shoes_2'] = 0,
                                    ['helmet_1'] = 0,
                                    ['helmet_2'] = 0,
                                    ['chain_1'] = 0,
                                    ['bproof_1'] = 0,
                                    ['decals_1'] = 7,
                                    ['decals_2'] = 1

                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', 22)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
            end

            --Tenue Lieutenant
            if ESX.PlayerData.job.grade == 3 then
                RageUI.ButtonWithStyle("Uniforme", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 55,
                                    ['torso_2'] = 0,
                                    ['arms'] = 0,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 31,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 78,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 48,
                                    ['torso_2'] = 0,
                                    ['arms'] = 14,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 87,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
            end

            --Tenue Capitaine
            if ESX.PlayerData.job.grade == 4 then
                RageUI.ButtonWithStyle("Uniforme", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 35,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 10,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 58,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 55,
                                    ['torso_2'] = 0,
                                    ['arms'] = 0,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 35,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 10,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 78,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 34,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 29,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 35,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 48,
                                    ['torso_2'] = 0,
                                    ['arms'] = 14,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 34,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 29,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 87,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
            end

            --Tenue Inspecteur et Cérémonie pour Lieutenant et Capitaine
            if ESX.PlayerData.job.grade == 3 or ESX.PlayerData.job.grade == 4 then
                RageUI.ButtonWithStyle("Tenue Inspecteur", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, clothe)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = clothe.pants_1,
                                    ['pants_2'] = clothe.pants_2,
                                    ['shoes_1'] = clothe.shoes_1,
                                    ['shoes_2'] = clothe.shoes_2,
                                    ['tshirt_1'] = 122,
                                    ['tshirt_2'] = 0,
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                --Male
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 122,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = clothe.torso_1,
                                    ['torso_2'] = clothe.torso_2,
                                    ['arms'] = clothe.arms,
                                    ['mask_1'] = 121,
                                    ['mask_2'] = 0,
                                    ['bproof_1'] = clothe.bproof_1,
                                    ['helmet_1'] = clothe.helmet_1,
                                    ['helmet_2'] = clothe.helmet_2,
                                    ['chain_1'] = -1,
                                    ['pants_1'] = clothe.pants_1,
                                    ['pants_2'] = clothe.pants_2,
                                    ['shoes_1'] = clothe.shoes_1,
                                    ['shoes_2'] = clothe.shoes_2,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'chain_1', clothe.chain_1)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = clothe.pants_1,
                                    ['pants_2'] = clothe.pants_2,
                                    ['shoes_1'] = clothe.shoes_1,
                                    ['shoes_2'] = clothe.shoes_2,
                                    ['tshirt_1'] = 39,
                                    ['tshirt_2'] = 0,
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 39,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = clothe.torso_1,
                                    ['torso_2'] = clothe.torso_2,
                                    ['arms'] = clothe.arms,
                                    ['mask_1'] = 121,
                                    ['mask_2'] = 0,
                                    ['bproof_1'] = clothe.bproof_1,
                                    ['helmet_1'] = clothe.helmet_1,
                                    ['helmet_2'] = clothe.helmet_2,
                                    ['chain_1'] = clothe.chain_1,
                                    ['pants_1'] = clothe.pants_1,
                                    ['pants_2'] = clothe.pants_2,
                                    ['shoes_1'] = clothe.shoes_1,
                                    ['shoes_2'] = clothe.shoes_2,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Tenue Ceremonie", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 10,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 10,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 153,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 153,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 322,
                                    ['torso_2'] = 0,
                                    ['arms'] = 77,
                                    ['bproof_1'] = 0,
                                    ['pants_1'] = 10,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 10,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 78,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', 38)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 7,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 6,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 189,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 189,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 333,
                                    ['torso_2'] = 0,
                                    ['arms'] = 88,
                                    ['pants_1'] = 7,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 6,
                                    ['shoes_2'] = 0,
                                    ['helmet_1'] = 0,
                                    ['helmet_2'] = 0,
                                    ['chain_1'] = 0,
                                    ['bproof_1'] = 0,
                                    ['decals_1'] = 87,
                                    ['decals_2'] = 0

                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 121)
                                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                TriggerEvent('skinchanger:change', 'chain_1', 22)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
            end

            if ESX.PlayerData.job.grade == 3 or ESX.PlayerData.job.grade == 2 or ESX.PlayerData.job.grade == 4 then
                RageUI.ButtonWithStyle("Tenue SWAT", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 33,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 122,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 122,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 111,
                                    ['torso_2'] = 3,
                                    ['arms'] = 174,
                                    ['pants_1'] = 33,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 24,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                --GPB
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    if skin.sex == 0 then
                                        SetPedComponentVariation(PlayerPedId(), 9, 1, 3) -- bulletwear
                                        SetPedComponentVariation(plyPed, 7, 148, 0) -- accessoire
                                    else
                                        SetPedComponentVariation(PlayerPedId(), 9, 1, 3) -- bulletwear
                                        SetPedComponentVariation(plyPed, 7, 148, 0) -- accessoire
                                    end
                                    SetPedArmour(plyPed, 100)
                                    TriggerEvent('armorEnable')
                                    gpb = true
                                end)
                                TriggerEvent('skinchanger:change', 'mask_1', 126)
                                TriggerEvent('skinchanger:change', 'mask_2', 0)
                                TriggerEvent('skinchanger:change', 'glasses_1', 0)
                                TriggerEvent('skinchanger:change', 'helmet_1', 124)
                                ClearPedBloodDamage(plyPed)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 33,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 51,
                                    ['shoes_2'] = 0,
                                    ['tshirt_1'] = 152,
                                    ['tshirt_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['bproof_1'] = 0,
                                    ['tshirt_1'] = 152,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 331,
                                    ['torso_2'] = 0,
                                    ['arms'] = 111,
                                    ['pants_1'] = 33,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 51,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 126)
                                TriggerEvent('skinchanger:change', 'mask_2', 0)
                                TriggerEvent('skinchanger:change', 'helmet_1', 123)
                                TriggerEvent('skinchanger:change', 'chain_1', -1)
                                TriggerEvent('skinchanger:change', 'glasses_1', 5)
                                --GPB
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    if skin.sex == 0 then
                                        SetPedComponentVariation(PlayerPedId(), 9, 1, 3) -- bulletwear
                                        SetPedComponentVariation(plyPed, 7, 148, 0) -- accessoire
                                    else
                                        SetPedComponentVariation(PlayerPedId(), 9, 1, 3) -- bulletwear
                                        SetPedComponentVariation(plyPed, 7, 148, 0) -- accessoire
                                    end
                                    SetPedArmour(plyPed, 100)
                                    TriggerEvent('armorEnable')
                                    gpb = true
                                end)
                                
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
            end

            if ESX.PlayerData.job.grade ~= 0 then
                RageUI.ButtonWithStyle("Tenue Pilote", nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("service:true",true)
                        local model = GetEntityModel(PlayerPedId())
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 25,
                                    ['shoes_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = -1,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 48,
                                    ['torso_2'] = 0,
                                    ['arms'] = 96,
                                    ['mask_1'] = 0,
                                    ['mask_2'] = 0,
                                    ['bproof_1'] = 0,
                                    ['chain_1'] = 0,
                                    ['helmet_1'] = 0,
                                    ['helmet_2'] = 0,
                                    ['pants_1'] = 30,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 25,
                                    ['shoes_2'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 38)
                                TriggerEvent('skinchanger:change', 'helmet_1', 38)
                                TriggerEvent('skinchanger:change', 'chain_1', 40)
                                ClearPedTasks(plyPed)
                            else
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water',
                                        8.0, 1.0, 22533, 0, 0, false, false, false)
                                    RemoveAnimDict('mp_safehouseshower@female@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['pants_1'] = 29,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 25,
                                    ['shoes_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                ClearPedTasks(plyPed)
                                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@',
                                        'male_shower_towel_dry_to_get_dressed', 8.0, 1.0, 22533, 0, 0, false, false,
                                        false)
                                    RemoveAnimDict('mp_safehouseshower@male@')
                                end)
                                Citizen.Wait(6200)
                                clothesSkin = {
                                    ['bags_1'] = 0,
                                    ['bags_2'] = 0,
                                    ['tshirt_1'] = 111,
                                    ['tshirt_2'] = 0,
                                    ['torso_1'] = 41,
                                    ['torso_2'] = 0,
                                    ['arms'] = 5,
                                    ['pants_1'] = 29,
                                    ['pants_2'] = 0,
                                    ['shoes_1'] = 25,
                                    ['shoes_2'] = 0,
                                    ['helmet_1'] = 0,
                                    ['helmet_2'] = 0,
                                    ['chain_1'] = 0,
                                    ['bproof_1'] = 0,
                                    ['decals_1'] = 0,
                                    ['decals_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                TriggerEvent('skinchanger:change', 'mask_1', 38)
                                TriggerEvent('skinchanger:change', 'helmet_1', 37)
                                TriggerEvent('skinchanger:change', 'chain_1', 24)
                                ClearPedTasks(plyPed)
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                end)
            end

            --    RageUI.ButtonWithStyle("Tenue - Unité K-9",nil, {nil}, true, function(Hovered, Active, Selected)
            --       if Selected then      
            --           local model = GetEntityModel(PlayerPedId())
            --           local plyPed = PlayerPedId()
            --           TriggerServerEvent('service')
            ---            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)              
            --           if skine == 0 then              
            --               SetPedComponentVariation(PlayerPedId() , 11, 55, 0) --tshirt 
            -- SetPedComponentVariation(PlayerPedId() , 10, 8, 1)  --torse
            --               SetPedComponentVariation(PlayerPedId() , 3, 0, 0)  -- bras
            --               SetPedComponentVariation(PlayerPedId() , 4, 35, 0)   --pants
            --               SetPedComponentVariation(PlayerPedId() , 6, 25, 0)   --shoes
            --               SetPedComponentVariation(PlayerPedId() , 8, 58, 0)
            --               SetPedComponentVariation(PlayerPedId() , 10, 8, 0)
            --               SetPedComponentVariation(PlayerPedId() , 5, 0, 0)
            --               SetPedComponentVariation(PlayerPedId() , 7, 0, 0)
            --           else
            --               SetPedComponentVariation(PlayerPedId() , 11, 48, 0) --tshirt 
            --               SetPedComponentVariation(PlayerPedId() , 10, 7, 3)  --torse
            --              SetPedComponentVariation(PlayerPedId() , 3, 14, 0)  -- bras
            --              SetPedComponentVariation(PlayerPedId() , 4, 34, 0)   --pants
            --               SetPedComponentVariation(PlayerPedId() , 5, 0, 0)   --shoes
            --              SetPedComponentVariation(PlayerPedId() , 6, 25, 0)   --shoes
            --              SetPedComponentVariation(PlayerPedId() , 7, 0, 0)   --shoes
            --              SetPedComponentVariation(PlayerPedId() , 8, 35, 0)   --shoes
            --			end         
            --           TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)  
            --       end)             
            --        end
            --   end)

            RageUI.Separator("↓ ~o~Gestion GPB~s~ ↓")

            RageUI.ButtonWithStyle("Mettre", nil, {nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    if not gpb then
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            if skin.sex == 0 then
                                SetPedComponentVariation(PlayerPedId(), 9, 1, 3) -- bulletwear
                            else
                                SetPedComponentVariation(PlayerPedId(), 9, 1, 3) -- bulletwear
                            end
                            SetPedArmour(plyPed, 100)
                            TriggerEvent('armorEnable')
                            gpb = true
                        end)
                    else
                        ESX.ShowNotification("Vous portez déjà un GPB")
                    end
                end

            end)

            RageUI.ButtonWithStyle("Enlever", nil, {nil}, true, function(Hovered, Active, Selected)
                if Selected then
                    local plyPed = PlayerPedId()
                    ClearPedBloodDamage(PlayerPedId())
                    if gpb then
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        if skin.sex == 0 then
                            SetPedComponentVariation(PlayerPedId(), 9, 0, 0) -- bulletwear
                            SetPedComponentVariation(PlayerPedId(), 7, 0, 0) -- accessoire
                        else
                            SetPedComponentVariation(PlayerPedId(), 9, 0, 0) -- bulletwear
                            SetPedComponentVariation(PlayerPedId(), 7, 0, 0) -- accessoire
                        end
                        SetPedArmour(plyPed, 0)
                        TriggerEvent('armorEnable')
                        gpb = false
                    end)
                else
                    ESX.ShowNotification("Vous ne portez pas de GPB")
                end
                end
            end)

        end, function()
        end, 1)
        Citizen.Wait(0)
    end
end)

---------------------------------------------

local positions = {{
    x = 471.2,
    y = -987.37,
    z = 24.73
}, {
    x = -439.86,
    y = 5992.08,
    z = 30.72
}}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if ESX.PlayerData.job and ESX.PlayerData.job.name:find('police') then
            for _, pos in pairs(positions) do
                DrawMarker(1, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255,
                    false, 95, 255, 0, nil, nil, 0)

                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos.x, pos.y, pos.z)

                if dist <= 2.0 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Vestiaire")
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(RMenu:Get('tenue', 'vpolice'), not RageUI.Visible(RMenu:Get('tenue', 'vpolice')))

                    end
                end
            end

        end
    end
end)
