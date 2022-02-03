ESX = nil
local PlayerData = {}
local prop = 0
local IsDead = false
local PlayerSpawned = false
local Loaded = false
local attached_weapons = {}
local propmalette = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        Citizen.Wait(10)
    end

    while not Loaded do
        Citizen.Wait(500)
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

RegisterNetEvent('useparachute')
AddEventHandler('useparachute', function()

    if not HasPedGotWeapon(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), false) then
        GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
    else
        TriggerEvent('esx:showNotification', "Vous avez déjà un parachute")
    end
end)


RegisterNetEvent('useplonger')
AddEventHandler('useplonger', function()
    local plyPed = PlayerPedId()
    SetPedMaxTimeUnderwater(plyPed, 1500.0)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin.sex == 0 then
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_undress_&_turn_on_water', 8.0, 1.0, 22533,
                    0, 0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@male@')
            end)
            Citizen.Wait(6200)
            clothesSkin = {
                ['pants_1'] = 94,
                ['pants_2'] = 0,
                ['shoes_1'] = 67,
                ['shoes_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            ClearPedTasks(plyPed)
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0,
                    22533, 0, 0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@male@')
            end)
            Citizen.Wait(6200)
            clothesSkin = {
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['tshirt_1'] = 151,
                ['tshirt_2'] = 0,
                ['torso_1'] = 243,
                ['torso_2'] = 0,
                ['arms'] = 4,
                ['mask_1'] = 36,
                ['mask_2'] = 0,
                ['bproof_1'] = 0,
                ['chain_1'] = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['pants_1'] = 94,
                ['pants_2'] = 0,
                ['shoes_1'] = 67,
                ['shoes_2'] = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            -- TriggerEvent('skinchanger:change', 'mask_1', 36)
            TriggerEvent('skinchanger:change', 'glasses_1', 26)
            TriggerEvent('skinchanger:change', 'helmet_1', -1)
            TriggerEvent('skinchanger:change', 'chain_1', 40)
            ClearPedTasks(plyPed)
        else
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@female@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@female@', 'shower_undress_&_turn_on_water', 8.0, 1.0, 22533, 0,
                    0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@female@')
            end)
            Citizen.Wait(6200)
            clothesSkin = {
                ['pants_1'] = 97,
                ['pants_2'] = 0,
                ['shoes_1'] = 70,
                ['shoes_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            ClearPedTasks(plyPed)
            ESX.Streaming.RequestAnimDict('mp_safehouseshower@male@', function()
                TaskPlayAnim(plyPed, 'mp_safehouseshower@male@', 'male_shower_towel_dry_to_get_dressed', 8.0, 1.0,
                    22533, 0, 0, false, false, false)
                RemoveAnimDict('mp_safehouseshower@male@')
            end)
            Citizen.Wait(6200)
            clothesSkin = {
                ['bags_1'] = 0,
                ['bags_2'] = 0,
                ['tshirt_1'] = 187,
                ['tshirt_2'] = 0,
                ['torso_1'] = 251,
                ['torso_2'] = 0,
                ['arms'] = 3,
                ['pants_1'] = 97,
                ['pants_2'] = 0,
                ['shoes_1'] = 70,
                ['shoes_2'] = 0,
                ['helmet_1'] = 0,
                ['helmet_2'] = 0,
                ['chain_1'] = 0,
                ['bproof_1'] = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            -- TriggerEvent('skinchanger:change', 'mask_1', 36)
            TriggerEvent('skinchanger:change', 'glasses_1', 28)
            TriggerEvent('skinchanger:change', 'helmet_1', -1)
            TriggerEvent('skinchanger:change', 'chain_1', 24)
            ClearPedTasks(plyPed)
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)

RegisterNetEvent('usecanne')
AddEventHandler('usecanne', function(canne)

    local Player = PlayerPedId()
    if canne then
        local props = "prop_cs_walking_stick"
        local x, y, z = table.unpack(GetEntityCoords(Player))
        anim = "move_m@injured"

        while not HasModelLoaded(GetHashKey(props)) do
            RequestModel(GetHashKey(props))
            Wait(10)
        end
        prop = CreateObject(GetHashKey(props), x, y, z + 0.2, true, true, true)
        AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, 57005), 0.15, 0.05, -0.03, 0.0, 266.0, 180.0, true,
            true, false, true, 1, true)
        SetModelAsNoLongerNeeded(props)
        ESX.Streaming.RequestAnimSet(anim, function()
            SetPedMotionBlur(Player, true)
            SetPedMovementClipset(Player, anim, false)
            RemoveAnimSet(anim)
        end)
    else
        if prop ~= 0 then
            local model = GetEntityModel(Player)
            if model == GetHashKey("mp_m_freemode_01") then
                Citizen.Wait(180)
                RemoveAnimSet(anim)
                ESX.Streaming.RequestAnimSet("move_m@confident", function()
                    SetPedMotionBlur(Player, true)
                    SetPedMovementClipset(Player, "move_m@confident", false)
                    RemoveAnimSet("move_m@confident")
                end)
            else
                Citizen.Wait(180)
                RemoveAnimSet(anim)
                ESX.Streaming.RequestAnimSet("move_f@heels@c", function()
                    SetPedMotionBlur(Player, true)
                    SetPedMovementClipset(Player, "move_f@heels@c", false)
                    RemoveAnimSet("move_f@heels@c")
                end)
            end
            ESX.Game.DeleteObject(prop)
            prop = 0
        end
    end
end)
local maletteActive = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15000)
        ESX.PlayerData = ESX.GetPlayerData()
        if Loaded then
            Malette()
        end
    end
end)
local maletteInVehicle = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if maletteActive or prop ~= 0 or IsDead then
            HudWeaponWheelIgnoreSelection()
            HideHudComponentThisFrame(19)
            HideHudComponentThisFrame(20)
        end
        if maletteInVehicle then
            HudWeaponWheelIgnoreSelection()
        end
    end
end)

function Malette()
    local money = 0
    local blackmoney = 0

    while ESX.PlayerData.accounts == nil do
        Wait(10)
    end
    for i = 1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'money' then
            money = ESX.PlayerData.accounts[i].money
        elseif ESX.PlayerData.accounts[i].name == 'black_money' then
            blackmoney = ESX.PlayerData.accounts[i].money
        end
    end
    if not maletteActive then
        if not IsPedInAnyVehicle(PlayerPedId()) then
            CheckAndSetMalette(blackmoney + money)
        end
    else
        if IsPedInAnyVehicle(PlayerPedId()) then
            maletteInVehicle = true
            RemoveMalette(blackmoney + money, true)
        else
            maletteInVehicle = false
            RemoveMalette(blackmoney + money, false)
        end
    end
end
function RemoveMalette(value, force)
    if value < 5000 or force then
        Citizen.Wait(1000)
        ESX.Game.DeleteObject(propmalette)
        propmalette = nil
        maletteActive = false
    end
end
function CheckAndSetMalette(value)
    local Player = PlayerPedId()
    if value >= 5000 then
        Citizen.Wait(1000)
        local props = "bkr_prop_biker_case_shut"
        local x, y, z = table.unpack(GetEntityCoords(Player))

        while not HasModelLoaded(GetHashKey(props)) do
            RequestModel(GetHashKey(props))
            Wait(10)
        end
        propmalette = CreateObject(GetHashKey(props), x, y, z + 0.2, true, true, true)
        AttachEntityToEntity(propmalette, Player, GetPedBoneIndex(Player, 57005), 0.15, 0, 0.02, 90.0, 90.0, 300.0,
            true, true, false, false, 1, true)
        SetModelAsNoLongerNeeded(props)
        if GetSelectedPedWeapon(Player) ~= GetHashKey("WEAPON_UNARMED") then
            SetCurrentPedWeapon(Player, GetHashKey("WEAPON_UNARMED"), true)
        end
        -- print(propmalette)
        maletteActive = true
    end
end
RegisterNetEvent('launchMaletteCheck')
AddEventHandler('launchMaletteCheck', function(spawn)
    Loaded = true
    --Citizen.SetTimeout(15000, function()
    --    Malette()
    --end)
end)
RegisterNetEvent('arme:deleteMallette')
AddEventHandler("arme:deleteMallette", function()
    RemoveMalette(0, true)
end)

Citizen.CreateThread(function()
    while true do
        local me = PlayerPedId()
        Citizen.Wait(100)
        if IsPedInAnyVehicle(me) and GetVehicleClass(GetVehiclePedIsIn(me)) ~= 8 then
            for name, attached_object in pairs(attached_weapons) do
                ESX.Game.DeleteObject(attached_object.handle)
                attached_weapons[name] = nil
            end
        else
            ---------------------------------------
            -- attach if player has large weapon --
            ---------------------------------------
            for i = 1, #Config.RealWeapons, 1 do
                local weap_hash = GetHashKey(Config.RealWeapons[i].name)
                if HasPedGotWeapon(me, weap_hash, false) then
                    if not attached_weapons[Config.RealWeapons[i].model] and GetSelectedPedWeapon(me) ~= weap_hash then
                        AttachWeapon(Config.RealWeapons[i].model, weap_hash, Config.RealWeapons[i].bone,
                            Config.RealWeapons[i].x, Config.RealWeapons[i].y, Config.RealWeapons[i].z,
                            Config.RealWeapons[i].xRot, Config.RealWeapons[i].yRot, Config.RealWeapons[i].zRot)
                    end
                end
            end
            --------------------------------------------
            -- remove from back if equipped / dropped --
            --------------------------------------------
            for name, attached_object in pairs(attached_weapons) do
                -- equipped? delete it from back:
                if GetSelectedPedWeapon(me) == attached_object.hash or
                    not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
                    ESX.Game.DeleteObject(attached_object.handle)
                    attached_weapons[name] = nil
                end
            end
        end
    end
end)

function AttachWeapon(attachModel, modelHash, boneNumber, x, y, z, xR, yR, zR)
    local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Wait(100)
    end

    attached_weapons[attachModel] = {
        hash = modelHash,
        handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
    }

    AttachEntityToEntity(attached_weapons[attachModel].handle, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2,
        1)
end

RegisterNetEvent('arme:deleteWeapons')
AddEventHandler("arme:deleteWeapons", function()
    for name, attached_object in pairs(attached_weapons) do
        ESX.Game.DeleteObject(attached_object.handle)
        attached_weapons[name] = nil
    end
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
    IsDead = true
end)
RegisterNetEvent('esx:onPlayerDeathFalse')
AddEventHandler('esx:onPlayerDeathFalse', function()
    IsDead = false
end)

AddEventHandler('onResourceStop', function(resource)
    TriggerEvent("arme:deleteWeapons")
    TriggerEvent("arme:deleteMallette")
end)

