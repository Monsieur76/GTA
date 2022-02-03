-- internal variables
local hasAlreadyEnteredMarker, isInATMMarker, menuIsShowed = false, false, false
local peds = {}
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx_atm:closeATM')
AddEventHandler('esx_atm:closeATM', function()
    SendNUIMessage({
        show = false
    })
    SetNuiFocus(false, false)
    menuIsShowed = false
end)

RegisterNUICallback('escape', function(data, cb)
    TriggerEvent('esx_atm:closeATM')
end)

RegisterNUICallback('deposit', function(data, cb)
    TriggerServerEvent('esx_atm:deposit', data.amount)
    ESX.TriggerServerCallback('h-banking:getAccounts', function(wallet, bank)
        SendNUIMessage({
            show = true,
            wallet = wallet.wallet,
            bank = wallet.bank
        })
    end)
end)

RegisterNUICallback('withdraw', function(data, cb)
    TriggerServerEvent('esx_atm:withdraw', data.amount)
    ESX.TriggerServerCallback('h-banking:getAccounts', function(wallet, bank)
        SendNUIMessage({
            show = true,
            wallet = wallet.wallet,
            bank = wallet.bank
        })
    end)
end)

-- Create blips
Citizen.CreateThread(function()
    for i = 1, #Config.ped do
        peds[i] = _CreatePed(Config.ped[i].type,Config.ped[i].haskKey, Config.ped[i].coords, Config.ped[i].heading)
        SetEntityInvincible(peds[i], true)
    end
    for _, v in pairs(Config.Locations["banks"]) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, v.id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring(v.name))
        EndTextCommandSetBlipName(blip)
    end

	--for _, v in pairs(Config.Locations["atms"]) do
    --    local blip = AddBlipForCoord(v.x, v.y, v.z)
   --     SetBlipSprite(blip, v.id)
    --    SetBlipDisplay(blip, 4)
   --     SetBlipScale(blip, 0.8)
   --     SetBlipColour(blip, 2)
   --     SetBlipAsShortRange(blip, true)
   --     BeginTextCommandSetBlipName("STRING")
   --     AddTextComponentString(tostring(v.name))
   --     EndTextCommandSetBlipName(blip)
   -- end
end)

function _CreatePed(type,hash, coords, heading)
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
    while true do
        Citizen.Wait(0)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        for k, v in pairs(Config.Locations["banks"]) do
            local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z, true)
            if distance < 10.0 then
                zoneDistance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z, true)

                DrawMarker(1, v.x, v.y, v.z,  0.0, 0.0, 0.0, 0.0, 0.0, 0.0,1.0, 1.0, 1.0, 25, 95, 255, 255, false, 95, 100, 0, nil, nil, 0)
            end
        end
        if NearBank() or NearATM() then
            if IsControlPressed(0, 38) then
                ESX.TriggerServerCallback('h-banking:getAccounts', function(wallet, bank)
                    SendNUIMessage({
                        show = true,
                        wallet = wallet.wallet,
                        bank = wallet.bank
                    })
                end)
                SetNuiFocus(true, true)
                menuIsShowed = true
            end
        end

    end
end)


function NearBank()
    local _ped = PlayerPedId()
    local _pcoords = GetEntityCoords(_ped)
    local _toreturn = false
    for _, search in pairs(Config.Locations["banks"]) do
        local distance = #(vector3(search.x, search.y, search.z) - vector3(_pcoords))
        if distance <= 3 then
            atbank = true
            _toreturn = true
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Banque")
        end
    end
    return _toreturn
end
function NearATM()
    local _ped = PlayerPedId()
    local _pcoords = GetEntityCoords(_ped)
    local _toreturn = false
    for _, search in pairs(Config.Locations["atms"]) do
        local distance = #(vector3(search.x, search.y, search.z) - vector3(_pcoords))
        if distance <= 2 then
            atbank = false
            _toreturn = true
            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Distributeur")
        end
    end
    return _toreturn
end
-- close the menu when script is stopping to avoid being stuck in NUI focus
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuIsShowed then
            TriggerEvent('esx_atm:closeATM')
        end
    end
end)
