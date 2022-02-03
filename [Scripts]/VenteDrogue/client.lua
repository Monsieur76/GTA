ESX = nil
PlayerData = {}
npc = {}
cooldown = false
notifyCooldown = false
blips = {}
local vente = false
local pedaccept = false
local closestPed = false
local closestPedDst = false
local drugToSell = false
local lastVente = nil
local rand = nil
local countDrogue = nil
local price = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(5000)
    end

    PlayerData = ESX.GetPlayerData()
    ESX.Streaming.RequestStreamedTextureDict('DIA_CLIFFORD')

    ESX.PlayAnim = function(dict, anim, speed, time, flag)
        ESX.Streaming.RequestAnimDict(dict, function()
            TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, time, flag, 1, false, false, false)
        end)
    end

    ESX.PlayAnimOnPed = function(ped, dict, anim, speed, time, flag)
        ESX.Streaming.RequestAnimDict(dict, function()
            TaskPlayAnim(ped, dict, anim, speed, speed, time, flag, 1, false, false, false)
        end)
    end

    ESX.Game.MakeEntityFaceEntity = function(entity1, entity2)
        local p1 = GetEntityCoords(entity1, true)
        local p2 = GetEntityCoords(entity2, true)

        local dx = p2.x - p1.x
        local dy = p2.y - p1.y

        local heading = GetHeadingFromVector_2d(dx, dy)
        SetEntityHeading(entity1, heading)
    end
end)

next_ped = function(drugToSell)
    cops = 0
    ESX.TriggerServerCallback('stasiek_selldrugsv2:getPoliceCount', function(_cops)
        cops = _cops
    end)

    -- if cops < Config.requiredCops then
    --	ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.cops, 'DIA_CLIFFORD', 1)
    --	return
    -- end
    if cops == 0 then
        drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur0)
    elseif cops == 1 then
        drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur1)
    elseif cops == 2 then
        drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur2)
    elseif cops == 3 then
        drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur3)
    elseif cops == 4 then
        drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur4)
    elseif cops == 5 then
        drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur5)
    elseif cops == 6 then
        drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur6)
    elseif cops >= 7 then
        drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur7)
    end

    -- TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, true)
    -- ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.searching .. drugToSell.label, 'DIA_CLIFFORD', 1)
    -- Wait(math.random(5000, 10000))
    -- ESX.PlayAnim('amb@world_human_drug_dealer_hard@male@base', 'base', 8.0, -1, 1)
    ClearPedTasks(PlayerPedId())
    -- npc.hash = GetHashKey(Config.pedlist[math.random(1, #Config.pedlist)])
    -- ESX.Streaming.RequestModel(npc.hash)
    -- npc.coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 50.0, 5.0)
    -- retval, npc.z = GetGroundZFor_3dCoord(npc.coords.x, npc.coords.y, npc.coords.z, 0)

    -- if retval == false then
    -- cooldown = false
    -- ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.abort, 'DIA_CLIFFORD', 1)
    --	ClearPedTasks(PlayerPedId())
    --	return
    -- end

    -- npc.zone = GetLabelText(GetNameOfZone(npc.coords))
    -- drugToSell.zone = npc.zone
    -- npc.ped = CreatePed(5, npc.hash, npc.coords.x, npc.coords.y, npc.z, 0.0, true, true)
    -- PlaceObjectOnGroundProperly(npc.ped)
    -- SetEntityAsMissionEntity(npc.ped)

    -- if IsEntityDead(npc.ped) or GetEntityCoords(npc.ped) == vector3(0.0, 0.0, 0.0) then
    -- ESX.ShowAdvancedNotification(Config.notify.title, '', Config.notify.notfound, 'DIA_CLIFFORD', 1)
    -- return
    -- end

    -- ESX.ShowAdvancedNotification(Config.notify.title, Config.notify.approach, Config.notify.found .. npc.zone, 'DIA_CLIFFORD', 1)
    -- TaskGoToEntity(npc.ped, PlayerPedId(), 60000, 4.0, 2.0, 0, 0)
end

CreateThread(function()
    while true do
        Citizen.Wait(0)
        if pedaccept then

            if not IsPedDeadOrDying(closestPed, 0) then

                local x, y, z = table.unpack(GetEntityCoords(closestPed))
                DrawMarker(1, x, y, z - 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 25, 95, 255, 255, false, true, 2,
                    false, false, false, false)
                distance = Vdist2(GetEntityCoords(PlayerPedId()), x, y, z)
                TaskSetBlockingOfNonTemporaryEvents(closestPed, true)
                if distance < 2.0 then
                    ESX.ShowHelpNotification(Config.notify.press)
                    if IsControlJustPressed(0, 51) then
                        if rand < drugToSell.alert then
                            drugToSell.coords = {
                                x = x,
                                y = y,
                                z = z
                            }
                            drugToSell.price = drugToSell.count * price
                            if not notifyCooldown then
                                local street = GetStreetNameFromHashKey(
                                    GetStreetNameAtCoord(drugToSell.coords.x, drugToSell.coords.y, drugToSell.coords.z))
                                local msg = "vente de drogue ici ! " .. street
                                TriggerServerEvent('gcPhone:sendMessage', "police", msg, drugToSell.coords, true)
                                notifyCooldown = true
                            end

                        end

                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            ESX.ShowNotification("Vous devez descendre de votre véhicule")
                        else
                            ESX.Game.MakeEntityFaceEntity(PlayerPedId(), closestPed)
                            ESX.Game.MakeEntityFaceEntity(closestPed, PlayerPedId())
                            SetPedTalk(closestPed)
                            PlayAmbientSpeech1(closestPed, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
                            obj = CreateObject(GetHashKey('prop_weed_bottle'), 0, 0, 0, true)
                            AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.02,
                                0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                            obj2 = CreateObject(GetHashKey('hei_prop_heist_cash_pile'), 0, 0, 0, true)
                            AttachEntityToEntity(obj2, closestPed, GetPedBoneIndex(closestPed, 57005), 0.13, 0.02, 0.0,
                                -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                            ESX.PlayAnim('mp_common', 'givetake1_a', 8.0, -1, 0)
                            ESX.PlayAnimOnPed(closestPed, 'mp_common', 'givetake1_a', 8.0, -1, 0)
                            Wait(1000)
                            AttachEntityToEntity(obj2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.02,
                                0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                            AttachEntityToEntity(obj, closestPed, GetPedBoneIndex(closestPed, 57005), 0.13, 0.02, 0.0,
                                -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                            Wait(1000)
                            DeleteEntity(obj)
                            DeleteEntity(obj2)
                            PlayAmbientSpeech1(closestPed, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                            SetPedAsNoLongerNeeded(closestPed)
                            if countDrogue >= 4 then
                                drugToSell.count = math.random(1, 4)
                            elseif countDrogue > 0 then
                                drugToSell.count = math.random(1, countDrogue)
                            end
                            drugToSell.price = drugToSell.count * price
                            countDrogue = countDrogue - drugToSell.count
                            cops = 0
                            ESX.TriggerServerCallback('stasiek_selldrugsv2:getPoliceCount', function(cops)
                                if cops == 0 then
                                    drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur0)
                                elseif cops == 1 then
                                    drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur1)
                                elseif cops == 2 then
                                    drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur2)
                                elseif cops == 3 then
                                    drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur3)
                                elseif cops == 4 then
                                    drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur4)
                                elseif cops == 5 then
                                    drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur5)
                                elseif cops == 6 then
                                    drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur6)
                                elseif cops >= 7 then
                                    drugToSell.price = ESX.Math.Round(drugToSell.price * Config.multiplicateur7)
                                end
                                TriggerServerEvent('stasiek_selldrugsv2:pay', drugToSell)
                                ESX.ShowNotification("Vous avez vendu ~g~" .. drugToSell.count .. " " .. drugToSell.type)
                                ESX.ShowNotification("Vous avez gagné ~g~" .. drugToSell.price .. "$")
                            end)
                            lastVente = closestPed
                            pedaccept = false
                            vente = true
                            if countDrogue == 0 then
                                vente = false
                                pedaccept = false
                                ESX.ShowNotification("~r~Vous arrêtez de vendre")
                            end
                        end
                    end
                end
            else
                pedaccept = false
                vente = true
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if vente then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local closestPe, closestPedDs = ESX.Game.GetClosestPed(pedCoords)
            local model = GetEntityModel(closestPe)
            rand = math.random(0, 10000) / 100
            accept = math.random(0, 10000) / 100
            Citizen.Wait(10000)
            if vente then
                for k, v in pairs(Config.pedlist) do
                    if not IsPedSittingInAnyVehicle(closestPe) and closestPe ~= lastVente and model == GetHashKey(v) then
                        if accept >= 10 then
                            PlaySoundFrontend(-1, "Cancel", "GTAO_Exec_SecuroServ_Warehouse_PC_Sounds", 0)
                            ESX.ShowNotification("Vous avez un client")
                            closestPed = closestPe
                            closestPedDst = closestPedDs
                            pedaccept = true
                            vente = false
                        end
                    end
                end
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if notifyCooldown then
            Citizen.Wait(3 * 60 * 1000)
            notifyCooldown = false
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Wait(20000)
        if cooldown then
            cooldown = false
        end
    end
end)

RegisterNetEvent('stasiek_selldrugsv2:findClient')
AddEventHandler('stasiek_selldrugsv2:findClient', function(drug, ventedrogue, count)
    vente = ventedrogue
    if not ventedrogue then
        pedaccept = false
    end
    price = drug.price
    countDrogue = count
    drugToSell = drug
    next_ped(drug)
end)
