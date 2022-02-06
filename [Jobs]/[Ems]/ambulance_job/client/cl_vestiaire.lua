ESX = nil
local gpb =false

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

RMenu.Add('enos', 'vestiaire', RageUI.CreateMenu("Vestaire", "Vestiaire"))
Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('enos', 'vestiaire'), true, true, true, function()

            RageUI.ButtonWithStyle("Tenue ~r~Civile",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    vcivil()
                end
            end)

            if ESX.PlayerData.job.grade_name == 'infirmier' or ESX.PlayerData.job.grade_name == 'doctor' or ESX.PlayerData.job.grade_name == 'psy' or ESX.PlayerData.job.grade_name == 'boss' then
                RageUI.ButtonWithStyle("Tenue d'~b~Interne",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                       vambulance()
                    end
                end)
            end 
            if ESX.PlayerData.job.grade_name == 'infirmier' or ESX.PlayerData.job.grade_name == 'doctor' or ESX.PlayerData.job.grade_name == 'psy' or ESX.PlayerData.job.grade_name == 'chiru' or ESX.PlayerData.job.grade_name == 'boss'then
            RageUI.ButtonWithStyle("Tenue de ~b~Chirurgie",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    vambulance1()
                end
            end)
            end
            if ESX.PlayerData.job.grade_name == 'psy' or ESX.PlayerData.job.grade_name == 'chiru' or ESX.PlayerData.job.grade_name == 'doctor' or ESX.PlayerData.job.grade_name == 'boss' then 
            RageUI.ButtonWithStyle("Tenue de ~b~Médecin",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    vambulance2()
                end
            end)
        end
        if ESX.PlayerData.job.grade_name == 'infirmier' or ESX.PlayerData.job.grade_name == 'doctor' or ESX.PlayerData.job.grade_name == 'psy' or ESX.PlayerData.job.grade_name == 'chiru' or ESX.PlayerData.job.grade_name == 'boss'then
            RageUI.ButtonWithStyle("Tenue de ~b~Pompier",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    vambulance3()
                end
            end)
        end

        if ESX.PlayerData.job.grade_name == 'boss' then
            RageUI.ButtonWithStyle("Tenue de ~b~Directeur",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    vambulance4()
                end
            end)
        end

        RageUI.Separator("↓ ~o~Gestion GPB~s~ ↓")

        RageUI.ButtonWithStyle("Mettre",nil, {nil}, true, function(Hovered, Active, Selected)
            if Selected then  
                if not gpb then
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
                        if skin.sex == 0 then
                            SetPedComponentVariation(PlayerPedId(), 9, 1, 4) -- bulletwear
                            -- SetPedComponentVariation(PlayerPedId() , 7, 148, 0)   --accessoire
                        else
                            SetPedComponentVariation(PlayerPedId(), 9, 1, 4) -- bulletwear
                            -- SetPedComponentVariation(PlayerPedId() , 7, 116, 0)   --accessoire
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

        RageUI.ButtonWithStyle("Enlever",nil, {nil}, true, function(Hovered, Active, Selected)
            if Selected then    
                if gpb then
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        local plyPed = PlayerPedId()
                        ClearPedBloodDamage(PlayerPedId())
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


local position = {
    {x = 298.96, y = -598.14, z = 43.27}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(position) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then 
                DrawMarker(1, 298.96, -598.14, 42.27, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
        
            if dist <= 1.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Vestiaire")

                if IsControlJustPressed(1,51) then
                    RageUI.Visible(RMenu:Get('enos', 'vestiaire'), not RageUI.Visible(RMenu:Get('enos', 'vestiaire')))
                end
            end
        end
    end
    end
end)

function vambulance()
    local model = GetEntityModel(PlayerPedId())
    local plyPed = PlayerPedId()
    ClearPedBloodDamage(PlayerPedId())
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                 RemoveAnimDict('mp_safehouseshower@male@')
             end)
             Citizen.Wait(6200)
              clothesSkin = {
                ['pants_1'] = 96, ['pants_2'] = 0,
                ['shoes_1'] = 42, ['shoes_2'] = 2,
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
                ['torso_1'] = 250, ['torso_2'] = 0,
                ['arms'] = 85,
                ['pants_1'] = 96, ['pants_2'] = 0,
                ['shoes_1'] = 42, ['shoes_2'] = 2,
                ['decals_1'] = 58, ['decals_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            TriggerEvent('skinchanger:change', 'mask_1', -1)
            TriggerEvent('skinchanger:change', 'helmet_1', -1)
            TriggerEvent('skinchanger:change', 'chain_1', 127)
            TriggerEvent('skinchanger:change', 'glasses_1', 0)

             ClearPedTasks(plyPed)  
        else
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                 RemoveAnimDict('mp_safehouseshower@female@')
             end)
             Citizen.Wait(6200)
              clothesSkin = {
                ['pants_1'] = 99, ['pants_2'] = 0,
                ['shoes_1'] = 103, ['shoes_2'] = 0,
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
                ['tshirt_1'] = 2, ['tshirt_2'] = 0,
                ['torso_1'] = 258, ['torso_2'] = 0,
                ['arms'] = 109,
                ['pants_1'] = 99, ['pants_2'] = 0,
                ['shoes_1'] = 103, ['shoes_2'] = 0,
                ['decals_1'] = 66, ['decals_2'] = 0            
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            TriggerEvent('skinchanger:change', 'mask_1', -1)
            TriggerEvent('skinchanger:change', 'helmet_1', -1)
            TriggerEvent('skinchanger:change', 'chain_1', 97)
            TriggerEvent('skinchanger:change', 'glasses_1', 5)

             ClearPedTasks(plyPed)
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end


function vcivil()
    local plyPed = PlayerPedId()
    local model = GetEntityModel(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
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
        TriggerEvent('skinchanger:change', 'helmet_1', -1)
        TriggerEvent('skinchanger:change', 'chain_1', -1)
        TriggerEvent('skinchanger:change', 'glasses_1', 0)
        TriggerEvent('skinchanger:change', 'decals_1', 0)
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
             TriggerEvent('skinchanger:change', 'helmet_1', -1)
             TriggerEvent('skinchanger:change', 'chain_1', -1)
             TriggerEvent('skinchanger:change', 'glasses_1', 5)
             TriggerEvent('skinchanger:change', 'decals_1', 0)
             ClearPedTasks(plyPed)
        end
       end)
    end



    function vambulance1()
        local model = GetEntityModel(PlayerPedId())
        local plyPed = PlayerPedId()
        ClearPedBloodDamage(PlayerPedId())
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if model == GetHashKey("mp_m_freemode_01") then
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 104, ['pants_2'] = 0,
                    ['shoes_1'] = 42, ['shoes_2'] = 2,
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
                    ['torso_1'] = 271, ['torso_2'] = 0,
                    ['arms'] = 85,
                    ['pants_1'] = 104, ['pants_2'] = 0,
                    ['shoes_1'] = 42, ['shoes_2'] = 2,
                    ['decals_1'] = 0, ['decals_2'] = 0
                    }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'helmet_1', 14)
                TriggerEvent('skinchanger:change', 'chain_1', 127)
                TriggerEvent('skinchanger:change', 'glasses_1', 0)

                 ClearPedTasks(plyPed)  
            else
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@female@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 111, ['pants_2'] = 0,
                    ['shoes_1'] = 103, ['shoes_2'] = 0,
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
                    ['tshirt_1'] = 2, ['tshirt_2'] = 0,
                    ['torso_1'] = 141, ['torso_2'] = 0,
                    ['arms'] = 109,
                    ['pants_1'] = 111, ['pants_2'] = 0,
                    ['shoes_1'] = 103, ['shoes_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'helmet_1', 29)
                TriggerEvent('skinchanger:change', 'helmet_2', 1)
                TriggerEvent('skinchanger:change', 'chain_1', -1)
                TriggerEvent('skinchanger:change', 'glasses_1', 5)

                 ClearPedTasks(plyPed)
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
    end



    function vambulance2()
        local model = GetEntityModel(PlayerPedId())
        local plyPed = PlayerPedId()
        ClearPedBloodDamage(PlayerPedId())
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if model == GetHashKey("mp_m_freemode_01") then
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 96, ['pants_2'] = 0,
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
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 321, ['torso_2'] = 0,
                    ['arms'] = 93,
                    ['pants_1'] = 96, ['pants_2'] = 0,
                    ['shoes_1'] = 10, ['shoes_2'] = 0,
                    ['decals_1'] = 58, ['decals_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                TriggerEvent('skinchanger:change', 'chain_1', 126)
                TriggerEvent('skinchanger:change', 'glasses_1', 0)

                 ClearPedTasks(plyPed)  
            else
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@female@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 6, ['shoes_2'] = 0,
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
                    ['tshirt_1'] = 2, ['tshirt_2'] = 0,
                    ['torso_1'] = 332, ['torso_2'] = 0,
                    ['arms'] = 101,
                    ['pants_1'] = 99, ['pants_2'] = 0,
                    ['shoes_1'] = 6, ['shoes_2'] = 0,
                    ['decals_1'] = 66, ['decals_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                TriggerEvent('skinchanger:change', 'chain_1', 96)
                TriggerEvent('skinchanger:change', 'glasses_1', 5)

                 ClearPedTasks(plyPed)
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
    end



    function vambulance3()
        local model = GetEntityModel(PlayerPedId())
        local plyPed = PlayerPedId()
        ClearPedBloodDamage(PlayerPedId())
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if model == GetHashKey("mp_m_freemode_01") then
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 120, ['pants_2'] = 0,
                    ['shoes_1'] = 60, ['shoes_2'] = 0,
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
                    ['torso_1'] = 314, ['torso_2'] = 0,
                    ['arms'] = 195,
                    ['pants_1'] = 120, ['pants_2'] = 0,
                    ['shoes_1'] = 60, ['shoes_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', 185)
                TriggerEvent('skinchanger:change', 'glasses_1', 26)
                TriggerEvent('skinchanger:change', 'helmet_1', 137)
                TriggerEvent('skinchanger:change', 'chain_1', -1)
                 ClearPedTasks(plyPed)  
            else
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@female@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 126, ['pants_2'] = 0,
                    ['shoes_1'] = 73, ['shoes_2'] = 0,
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
                    ['tshirt_1'] = 2, ['tshirt_2'] = 0,
                    ['torso_1'] = 325, ['torso_2'] = 0,
                    ['arms'] = 240,
                    ['pants_1'] = 126, ['pants_2'] = 0,
                    ['shoes_1'] = 73, ['shoes_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', 185)
                TriggerEvent('skinchanger:change', 'helmet_1', 136)
                TriggerEvent('skinchanger:change', 'chain_1', -1)
                TriggerEvent('skinchanger:change', 'glasses_1', 28)

                 ClearPedTasks(plyPed)
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
    end




    function vambulance4()
        local model = GetEntityModel(PlayerPedId())
        local plyPed = PlayerPedId()
        ClearPedBloodDamage(PlayerPedId())
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if model == GetHashKey("mp_m_freemode_01") then
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@male@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 24, ['pants_2'] = 0,
                    ['shoes_1'] = 21, ['shoes_2'] = 0,
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
                    ['torso_1'] = 348, ['torso_2'] = 7,
                    ['arms'] = 88,
                    ['pants_1'] = 24, ['pants_2'] = 0,
                    ['shoes_1'] = 21, ['shoes_2'] = 0,
                    ['decals_1'] = -1, ['decals_2'] = -1
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                TriggerEvent('skinchanger:change', 'chain_1', 126)
                TriggerEvent('skinchanger:change', 'glasses_1', 0)

                 ClearPedTasks(plyPed)  
            else
                ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                    TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0, 0, false, false, false)
                     RemoveAnimDict('mp_safehouseshower@female@')
                 end)
                 Citizen.Wait(6200)
                  clothesSkin = {
                    ['pants_1'] = 7, ['pants_2'] = 0,
                    ['shoes_1'] = 0, ['shoes_2'] = 0,
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
                    ['tshirt_1'] = 39, ['tshirt_2'] = 0,
                    ['torso_1'] = 57, ['torso_2'] = 4,
                    ['arms'] = 101,
                    ['pants_1'] = 7, ['pants_2'] = 0,
                    ['shoes_1'] = 0, ['shoes_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:change', 'mask_1', -1)
                TriggerEvent('skinchanger:change', 'helmet_1', -1)
                TriggerEvent('skinchanger:change', 'chain_1', 96)
                TriggerEvent('skinchanger:change', 'glasses_1', 5)

                 ClearPedTasks(plyPed)
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
    end