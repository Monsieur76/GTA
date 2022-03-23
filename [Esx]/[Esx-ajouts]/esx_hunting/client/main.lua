local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

ESX = nil
HaveHuntingLicence = false
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    ScriptLoaded()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    ESX.TriggerServerCallback("esx_license:checkLicenseCurrentUser", function(haveHuntingLicence)
        HaveHuntingLicence = haveHuntingLicence
    end, "hunting")
end)
RegisterNetEvent('esx_license:licenseAdded')
AddEventHandler('esx_license:licenseAdded', function(type)
    if type == "hunting" then
        ESX.TriggerServerCallback("esx_license:checkLicenseCurrentUser", function(haveHuntingLicence)
            HaveHuntingLicence = haveHuntingLicence
        end, "hunting")
    end
end)

RegisterNetEvent('esx_license:licenseRemoved')
AddEventHandler('esx_license:licenseRemoved', function(type)
    if type == "hunting" then
        ESX.TriggerServerCallback("esx_license:checkLicenseCurrentUser", function(haveHuntingLicence)
            HaveHuntingLicence = haveHuntingLicence
        end, "hunting")
    end
end)

function ScriptLoaded()
    Citizen.Wait(1000)
    LoadMarkers()
end

local AnimalsInSession = {}

local OnGoingHuntSession = false
local StartBlip = nil
function LoadMarkers()

    Citizen.CreateThread(function()
        StartBlip = AddBlipForCoord(Config.StartHuntPosition.x, Config.StartHuntPosition.y, Config.StartHuntPosition.z)
        SetBlipSprite(StartBlip, 442)
        SetBlipColour(StartBlip, 76)
        SetBlipScale(StartBlip, 0.7)
        SetBlipAsShortRange(StartBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Chasse')
        EndTextCommandSetBlipName(StartBlip)
    end)

    LoadModel('a_c_deer')
    LoadAnimDict('amb@medic@standing@kneel@base')
    LoadAnimDict('anim@gangops@facility@servers@bodysearch@')

    Citizen.CreateThread(function()
        while true do
            local plyCoords = GetEntityCoords(PlayerPedId())
            if HaveHuntingLicence then
                SetBlipDisplay(StartBlip, 4)

                local text = ""
                if OnGoingHuntSession then
                    text = '~INPUT_CONTEXT~ Arrêter la chasse'
                else
                    text = '~INPUT_CONTEXT~ Commencer la chasse'
                end
                local distance = GetDistanceBetweenCoords(plyCoords, Config.StartHuntPosition.x,
                    Config.StartHuntPosition.y, Config.StartHuntPosition.z, true)
                DrawMarker(1, Config.StartHuntPosition.x, Config.StartHuntPosition.y, Config.StartHuntPosition.z - 1,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

                if distance < 1.5 then
                    ESX.ShowHelpNotification(text)
                    if IsControlJustReleased(0, Keys['E']) then
                        StartHuntingSession()
                    end
                end
            else
                SetBlipDisplay(StartBlip, 0)
            end
            Citizen.Wait(5)
        end
    end)
end

function StartHuntingSession()

    if not HasPedGotWeapon(PlayerPedId(), GetHashKey("WEAPON_KNIFE")) or
        not HasPedGotWeapon(PlayerPedId(), GetHashKey("WEAPON_MUSKET")) then
        if not HasPedGotWeapon(PlayerPedId(), GetHashKey("WEAPON_KNIFE")) then
            ESX.ShowNotification("Vous ne pouvez pas chasser sans couteau")
        end
        if not HasPedGotWeapon(PlayerPedId(), GetHashKey("WEAPON_MUSKET")) then
            ESX.ShowNotification("Vous ne pouvez pas chasser sans fusil")
        end
    elseif OnGoingHuntSession then
        ESX.ShowNotification("Vous avez arrêté de chasser")
        OnGoingHuntSession = false

        for index, value in pairs(AnimalsInSession) do
            if DoesEntityExist(value.id) then
                DeleteEntity(value.id)
            end
        end

    else
        ESX.ShowNotification("La chasse commence ! Les animaux à chasser sont indiqués sur votre carte")
        OnGoingHuntSession = true

        -- Animals

        Citizen.CreateThread(function()

            for index, value in pairs(Config.AnimalPositions) do
                local Animal = CreatePed(5, GetHashKey('a_c_deer'), value.x, value.y, value.z, 0.0, true, false)
                TaskWanderStandard(Animal, true, true)
                SetEntityAsMissionEntity(Animal, true, true)
                -- Blips

                local AnimalBlip = AddBlipForEntity(Animal)
                SetBlipSprite(AnimalBlip, 153)
                SetBlipColour(AnimalBlip, 1)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Cerf/Biche - Animal')
                EndTextCommandSetBlipName(AnimalBlip)

                table.insert(AnimalsInSession, {
                    id = Animal,
                    x = value.x,
                    y = value.y,
                    z = value.z,
                    Blipid = AnimalBlip
                })
            end

            while OnGoingHuntSession do
                local sleep = 500
                for index, value in ipairs(AnimalsInSession) do
                    if DoesEntityExist(value.id) then
                        local AnimalCoords = GetEntityCoords(value.id)
                        local PlyCoords = GetEntityCoords(PlayerPedId())
                        local AnimalHealth = GetEntityHealth(value.id)

                        local PlyToAnimal = GetDistanceBetweenCoords(PlyCoords, AnimalCoords, true)

                        if AnimalHealth <= 0 then
                            SetBlipColour(value.Blipid, 3)
                            if PlyToAnimal < 2.0 then
                                sleep = 5
                                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Dépecer l'animal")
                                if IsControlJustReleased(0, Keys['E']) then
                                    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE') then
                                        if DoesEntityExist(value.id) then
                                            table.remove(AnimalsInSession, index)
                                            SlaughterAnimal(value.id)
                                        end
                                    else
                                        ESX.ShowNotification('Vous devez utiliser un couteau !')
                                    end
                                end

                            end
                        end
                    end
                end

                Citizen.Wait(sleep)

            end

        end)
    end
end

function SlaughterAnimal(AnimalId)

    TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
    TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8.0, -1, 48, 0,
        false, false, false)

    Citizen.Wait(5000)

    ClearPedTasksImmediately(PlayerPedId())
    local meatQuantity, leatherQuantity = math.random(1, 3), math.random(1, 4)
    TriggerServerEvent('esx-qalle-hunting:reward', meatQuantity, leatherQuantity)

    DeleteEntity(AnimalId)
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end
end
