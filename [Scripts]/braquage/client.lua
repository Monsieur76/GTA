ESX = nil
local ESXLoaded = false
local robbing = false
IsDead = false
local mask
local number = 0

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

    ESXLoaded = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

AddEventHandler('esx:onPlayerDeathFalse', function()
    IsDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
    IsDead = true
end)

local peds = {}
local objects = {}

RegisterNetEvent('loffe_robbery:onPedDeath')
AddEventHandler('loffe_robbery:onPedDeath', function(store)
    SetEntityHealth(peds[store], 0)
end)

RegisterNetEvent('loffe_robbery:removePickup')
AddEventHandler('loffe_robbery:removePickup', function(bank)
    for i = 1, #objects do
        if objects[i].bank == bank and DoesEntityExist(objects[i].object) then
            DeleteObject(objects[i].object)
        end
    end
end)

RegisterNetEvent('loffe_robbery:robberyOver')
AddEventHandler('loffe_robbery:robberyOver', function()
    robbing = false
end)

RegisterNetEvent('loffe_robbery:robberystoreTrue')
AddEventHandler('loffe_robbery:robberystoreTrue', function(store)
    Config.Shops[store].robbed = true
end)

RegisterNetEvent('loffe_robbery:robberyTrue')
AddEventHandler('loffe_robbery:robberyTrue', function()
    robbing = true
end)

RegisterNetEvent('loffe_robbery:talk')
AddEventHandler('loffe_robbery:talk', function(store, text, time)
    robbing = false
    local endTime = GetGameTimer() + 1000 * time
    while endTime >= GetGameTimer() do
        local x = GetEntityCoords(peds[store])
        DrawText3D(vector3(x.x, x.y, x.z + 1.0), text)
        Wait(0)
    end
end)

RegisterCommand('animation', function(source, args)
    if args[1] and args[2] then
        loadDict(args[1])
        TaskPlayAnim(PlayerPedId(), args[1], args[2], 8.0, -8.0, -1, 2, 0, false, false, false)
    end
end)

RegisterNetEvent('loffe_robbery:rob')
AddEventHandler('loffe_robbery:rob', function(i)
    local me = PlayerPedId()
    rand = math.random(60, 100)
    sacCount = 0
    pedd = peds[i]
    Citizen.CreateThread(function()
        while true do
            Wait(5)

            SetEntityCoords(pedd, Config.Shops[i].coords)
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(pedd), true) <= 7.5 then
                loadDict('mp_am_hold_up')
                TaskPlayAnim(pedd, "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)
                while not IsEntityPlayingAnim(pedd, "mp_am_hold_up", "holdup_victim_20s", 3) do
                    Wait(0)
                end
                local timer = GetGameTimer() + 10800
                -- SetEntityAnimSpeed(peds[i], "mp_am_hold_up", "holdup_victim_20s", 2.0)

                while timer >= GetGameTimer() do
                    if IsPedDeadOrDying(pedd) then
                        break
                    end
                    -- SetEntityAnimSpeed(peds[i], "mp_am_hold_up", "holdup_victim_20s", 2.0)
                    Wait(0)
                end

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(peds[i]), true) <= 7.5 and
                    not IsDead then
                    local cashRegister = GetClosestObjectOfType(GetEntityCoords(pedd), 5.0, GetHashKey('prop_till_01'))
                    if DoesEntityExist(cashRegister) then
                        CreateModelSwap(GetEntityCoords(cashRegister), 0.5, GetHashKey('prop_till_01'),
                            GetHashKey('prop_till_01_dam'), false)
                    end

                    timer = GetGameTimer() + 200
                    while timer >= GetGameTimer() do
                        if IsPedDeadOrDying(pedd) then
                            break
                        end
                        Wait(0)
                    end

                    local model = GetHashKey('prop_poly_bag_01')
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    local bag = CreateObject(model, GetEntityCoords(pedd), false, false)

                    AttachEntityToEntity(bag, pedd, GetPedBoneIndex(pedd, 60309), 0.1, -0.11, 0.08, 0.0, -75.0, -75.0,
                        1, 1, 0, 0, 2, 1)
                    timer = GetGameTimer() + 10000
                    while timer >= GetGameTimer() do
                        if IsPedDeadOrDying(pedd) then
                            break
                        end
                        Wait(0)
                    end
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(peds[i]), true) <= 7.5 and
                        not IsDead then
                        DetachEntity(bag, true, false)
                        timer = GetGameTimer() + 75
                        while timer >= GetGameTimer() do
                            if IsPedDeadOrDying(pedd) then
                                break
                            end
                            Wait(0)
                        end
                        SetEntityHeading(bag, Config.Shops[i].heading)
                        ApplyForceToEntity(bag, 3, vector3(0.0, 50.0, 0.0), 0.0, 0.0, 0.0, 0, true, true, false, false,
                            true)
                        table.insert(objects, {
                            bank = i,
                            object = bag
                        })
                        if rand > sacCount then
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(pedd), true) <=
                                7.5 and not IsDead then
                                -- PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                                sacBase = math.random(5, 10)
                                TriggerServerEvent('loffe_robbery:pickUp', sacBase)
                                sacCount = sacCount + sacBase
                                DeleteObject(bag)
                                -- break
                            else
                                ClearPedTasks(pedd)
                                TriggerServerEvent('robberyInCourtStorefalse')
                                TriggerServerEvent('robberyInCourtStoretrue1store', i)
                                ESX.ShowNotification('Tu es parti trop loin ! Braquage annulé')
                                -- break

                            end
                        else
                            number = 0
                            ESX.ShowNotification('Braquage en cours')
                            break
                        end
                    else
                        number = 0
                        ClearPedTasks(peds[i])
                        TriggerServerEvent('robberyInCourtStorefalse')
                        TriggerServerEvent('robberyInCourtStoretrue1store', i)
                        ESX.ShowNotification('Tu es parti trop loin ! Braquage annulé')
                        break
                    end
                else
                    number = 0
                    ClearPedTasks(pedd)
                    TriggerServerEvent('robberyInCourtStorefalse')
                    TriggerServerEvent('robberyInCourtStoretrue1store', i)
                    ESX.ShowNotification('Tu es parti trop loin ! Braquage annulé')
                    break
                end

            else
                number = 0
                ClearPedTasks(peds[i])
                TriggerServerEvent('robberyInCourtStorefalse')
                TriggerServerEvent('robberyInCourtStoretrue1store', i)
                ESX.ShowNotification('Tu es parti trop loin ! Braquage annulé')
                break
            end
        end
    end)
    DeleteObject(bag)
    number = 0
    -- else
    --   DeleteObject(bag)
    -- end
    -- end
    -- loadDict('mp_am_hold_up')
    -- TaskPlayAnim(peds[i], "mp_am_hold_up", "cower_intro", 8.0, -8.0, -1, 0, 0, false, false, false)
    -- timer = GetGameTimer() + 2500
    -- while timer >= GetGameTimer() do Wait(0) end
    -- TaskPlayAnim(peds[i], "mp_am_hold_up", "cower_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
    --  local stop = GetGameTimer() + 120000
    -- while stop >= GetGameTimer() do
    --     Wait(50)
    -- end
    -- if IsEntityPlayingAnim(peds[i], "mp_am_hold_up", "cower_loop", 3) then
    --     ClearPedTasks(peds[i])
    --  end
    -- end
end)

RegisterNetEvent('loffe_robbery:resetStore')
AddEventHandler('loffe_robbery:resetStore', function(i)
    Config.Shops[i].robbed = false
    while not ESXLoaded do
        Wait(0)
    end
    if DoesEntityExist(peds[i]) then
        DeletePed(peds[i])
    end
    Wait(250)
    peds[i] = _CreatePed(Config.Shopkeeper, Config.Shops[i].coords, Config.Shops[i].heading)
    local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(peds[i]), 5.0, GetHashKey('prop_till_01_dam'))
    if DoesEntityExist(brokenCashRegister) then
        CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'),
            GetHashKey('prop_till_01'), false)
    end
end)

function _CreatePed(type, hash, coords, heading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end

    local ped = CreatePed(type, hash, coords, false, false)
    SetEntityHeading(ped, heading)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    return ped
end

Citizen.CreateThread(function()
    while not ESXLoaded do
        Wait(0)
    end
    for i = 1, #Config.Shops do
        peds[i] = _CreatePed(Config.Shops[i].type, Config.Shops[i].haskKey, Config.Shops[i].coords,
            Config.Shops[i].heading)
        SetEntityInvincible(peds[i], true)
        if Config.Shops[i].blip then
            local blip = AddBlipForCoord(Config.Shops[i].coords)
            SetBlipSprite(blip, 156)
            SetBlipColour(blip, 40)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.Shops[i].name)
            EndTextCommandSetBlipName(blip)
        end

        local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(peds[i]), 5.0, GetHashKey('prop_till_01_dam'))
        if DoesEntityExist(brokenCashRegister) then
            CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'),
                GetHashKey('prop_till_01'), false)
        end
    end

    while true do
        Wait(100)
        local me = PlayerPedId()
        if IsPedArmed(me, 1) then

            if IsControlPressed(0, 25) and IsControlPressed(0, 24) and number == 0 then
print('premiere')
                
                    for i = 1, #peds do
                        if HasEntityClearLosToEntityInFront(me, peds[i], 19) and
                            GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <= 5.0 and
                            not IsDead then
                            if not Config.Shops[i].robbed then
                                if not robbing and not IsDead then
                                    number = 1
                                    print('ici')
                                    TriggerEvent('skinchanger:getSkin', function(skina)
                                        local plyPed = PlayerPedId()
                                        Citizen.Wait(850)
                                        ClearPedTasks(plyPed)
                                        if skina.mask_1 == 0 or skina.mask_1 == -1 then
                                            mask = false
                                        else
                                            mask = true
                                        end
                                    if mask then
                                    local canRob = nil
                                    ESX.TriggerServerCallback('loffe_robbery:canRob', function(cb)
                                        canRob = cb
                                    end, i)
                                    while canRob == nil do
                                        Wait(0)
                                    end
                                    if canRob == true then
                                        TriggerServerEvent('robberyInCourtStore')
                                        number = 1
                                        Config.Shops[i].robbed = true
                                        loadDict('missheist_agency2ahands_up')
                                        TaskPlayAnim(peds[i], "missheist_agency2ahands_up", "handsup_anxious", 8.0,
                                            -8.0, -1, 1, 0, false, false, false)

                                        local scared = 0
                                        while scared < 100 and not IsDead and
                                            GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <=
                                            7.5 do
                                            local sleep = 600
                                            SetEntityAnimSpeed(peds[i], "missheist_agency2ahands_up", "handsup_anxious",
                                                1.0)
                                            if IsPlayerFreeAiming(PlayerId()) then
                                                sleep = 250
                                                SetEntityAnimSpeed(peds[i], "missheist_agency2ahands_up",
                                                    "handsup_anxious", 1.3)
                                            end
                                            if IsPedArmed(me, 1) and GetAmmoInClip(me, GetSelectedPedWeapon(me)) > 0 and
                                                IsControlJustReleased(0, 24) then
                                                sleep = 50
                                                SetEntityAnimSpeed(peds[i], "missheist_agency2ahands_up",
                                                    "handsup_anxious", 1.7)
                                            end
                                            sleep = GetGameTimer() + sleep
                                            while sleep >= GetGameTimer() do
                                                Wait(0)
                                                DrawRect(0.5, 0.5, 0.2, 0.03, 75, 75, 75, 200)
                                                local draw = scared / 500
                                                DrawRect(0.5, 0.5, draw, 0.03, 0, 221, 255, 200)
                                            end
                                            scared = scared + 1
                                        end
                                        if GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <=
                                            7.5 and not IsDead then
                                                print('rob')
                                            TriggerServerEvent('loffe_robbery:rob', i)
                                        else
                                            ClearPedTasks(peds[i])
                                            local wait = GetGameTimer() + 5000
                                            while wait >= GetGameTimer() do
                                                Wait(0)
                                            end
                                            Config.Shops[i].robbed = true
                                            TriggerServerEvent('robberyInCourtStorefalse')
                                            TriggerServerEvent('robberyInCourt', i)
                                            ESX.ShowNotification('Tu es parti trop loin ! Braquage annulé')
                                            number = 0
                                        end
                                    elseif canRob == 'no_cops' then
                                        local wait = GetGameTimer() + 5000
                                        while wait >= GetGameTimer() do
                                            Wait(0)
                                            number = 0
                                            ESX.ShowNotification('Il n\'y a ~r~pas~w~ assez de flics en ligne !')
                                        end
                                    else
                                        Wait(2500)
                                    end
                                else
                                    number = 0
                                    ESX.ShowNotification('Vous devez porté un masque')
                                end
                            end)
                                else
                                    number = 0
                                    ESX.ShowNotification('La caisse est sécurisée')
                                end
                            else
                                number = 0
                                ESX.ShowNotification('~r~La caisses est vide, braquage indisponible')
                            end
                        end
                    end
                
            end
        end
    end
end)

loadDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()

    AddTextComponentString(text)
    DrawText(_x, _y)
end
