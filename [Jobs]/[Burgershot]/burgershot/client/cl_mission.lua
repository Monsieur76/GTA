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

Citizen.CreateThread(function()
    local hash = GetHashKey("mp_m_shopkeep_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVMALE", "s_m_y_cop_01", 1130.02, 2651.37, 38.0, 88.98, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
end)
