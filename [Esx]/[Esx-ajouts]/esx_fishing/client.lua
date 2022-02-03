ESX = nil
Citizen.CreateThread(function()
    while true do
        Wait(5)
        if ESX ~= nil then

        else
            ESX = nil
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
        end
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)
HaveFishingLicence = false
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
local BoatsToRent = {{
    label = 'Dinghy',
    value = 'dinghy4',
    price = 2500
}, {
    label = 'Suntrap',
    value = 'suntrap',
    price = 3500
}, {
    label = 'Jetmax',
    value = 'jetmax',
    price = 4500
}}
local x, y, z = nil
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer

    ESX.TriggerServerCallback("esx_license:checkLicenseCurrentUser", function(haveFishingLicence)
        HaveFishingLicence = haveFishingLicence
    end, "fishing")
end)
RegisterNetEvent('esx_license:licenseAdded')
AddEventHandler('esx_license:licenseAdded', function(type)
    ESX.PlayerData = ESX.GetPlayerData()
    if type == "fishing" then
        ESX.TriggerServerCallback("esx_license:checkLicenseCurrentUser", function(haveFishingLicence)
            HaveFishingLicence = haveFishingLicence
        end, "fishing")
    end
end)

RegisterNetEvent('esx_license:licenseRemoved')
AddEventHandler('esx_license:licenseRemoved', function(type)
    ESX.PlayerData = ESX.GetPlayerData()
    if type == "fishing" then
        ESX.TriggerServerCallback("esx_license:checkLicenseCurrentUser", function(haveFishingLicence)
            HaveFishingLicence = haveFishingLicence
        end, "fishing")
    end
end)
local fishing = false
local lastInput = 0
local pause = false
local pausetimer = 0
local correct = 0

local bait = "none"

for _, info in pairs(Config.MarkerZones) do
    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, 455)
    SetBlipScale(info.blip, 1.0)
    SetBlipColour(info.blip, 20)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Location de bâteaux de pêche")
    EndTextCommandSetBlipName(info.blip)
end
RMenu.Add('fishing', 'main', RageUI.CreateMenu("Pêche", "Location de bâteau"))

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if HaveFishingLicence then
            for k, info in pairs(Config.MarkerZones) do
                SetBlipDisplay(info.blip, 4)
                DrawMarker(1, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)

                local ped = PlayerPedId()
                local pedcoords = GetEntityCoords(ped, false)
                local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.MarkerZones[k].x,
                    Config.MarkerZones[k].y, Config.MarkerZones[k].z)
                if distance <= 2 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Louer un bâteau")
                    if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
                        x, y, z = Config.MarkerZones[k].xs, Config.MarkerZones[k].ys, Config.MarkerZones[k].zs

                        RageUI.Visible(RMenu:Get('fishing', 'main'), not RageUI.Visible(RMenu:Get('fishing', 'main')))

                    end
                end

            end
        else
            for _, info in pairs(Config.MarkerZones) do
                SetBlipDisplay(info.blip, 0)
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        RageUI.IsVisible(RMenu:Get('fishing', 'main'), true, true, true, function()
            local ped = PlayerPedId()
            for _, v in pairs(BoatsToRent) do
                RageUI.ButtonWithStyle(v.label, nil, {
                    RightLabel = v.price .. "$"
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        TriggerServerEvent("fishing:lowmoney", v.price)
                        ESX.ShowNotification('Vous avez loué un bâteau pour ~r~' .. v.price .. "$")
                        SetPedCoordsKeepVehicle(ped, x, y, z)
                        TriggerEvent('esx:spawnVehicle', v.value)
                    end
                end)
            end
        end, function()
        end)
    end
end)
Citizen.CreateThread(function()
    while true do
        Wait(600)
        if pause and fishing then
            pausetimer = pausetimer + 1
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Wait(5)
        if fishing then

            if IsControlJustReleased(0, Keys['N4']) then
                input = 4
            end
            if IsControlJustReleased(0, Keys['N5']) then
                input = 5
            end
            if IsControlJustReleased(0, Keys['N6']) then
                input = 6
            end
            if IsControlJustReleased(0, Keys['N7']) then
                input = 7
            end
            if IsControlJustReleased(0, Keys['N8']) then
                input = 8
            end
            if IsControlJustReleased(0, Keys['N9']) then
                input = 9
            end

            if IsControlJustReleased(0, Keys['X']) then
                fishing = false
                ClearPedTasks(PlayerPedId())
                ESX.ShowNotification("~r~Pêche arrêtée")
            end
            if fishing then

                playerPed = PlayerPedId()
                local pos = GetEntityCoords(PlayerPedId())
                if GetWaterHeight(pos.x, pos.y, pos.z) then

                else
                    fishing = false
                    ClearPedTasks(PlayerPedId())
                    ESX.ShowNotification("~r~Pêche arrêtée")
                end
                if IsEntityDead(playerPed) or IsPedSwimming(playerPed) or IsPedSwimmingUnderWater(playerPed) then
                    ESX.ShowNotification("~r~Pêche arrêtée")
                end
            end

            if pausetimer > 3 then
                input = 99
            end

            if pause and input ~= 0 then
                pause = false
                if input == correct then
                    TriggerServerEvent('fishing:catch', bait)
                else
                    ESX.ShowNotification("~r~Le poisson s'est libéré.")
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = math.random(Config.FishTime.a, Config.FishTime.b)
        Wait(wait)
        if fishing then
            pause = true
            correct = math.random(4, 9)
            ESX.ShowNotification("~g~Le poisson a pris l'appât \n ~h~Appuyez sur " .. correct ..
                                     "(NUM) pour l'attraper")
            input = 0
            pausetimer = 0
        end

    end
end)

RegisterNetEvent('fishing:break')
AddEventHandler('fishing:break', function()
    fishing = false
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('fishing:spawnPed')
AddEventHandler('fishing:spawnPed', function()

    RequestModel(GetHashKey("A_C_SharkTiger"))
    while (not HasModelLoaded(GetHashKey("A_C_SharkTiger"))) do
        Citizen.Wait(1)
    end
    local pos = GetEntityCoords(PlayerPedId())

    local ped = CreatePed(29, 0x06C3F072, pos.x, pos.y, pos.z, 90.0, true, false)
    SetEntityHealth(ped, 0)
end)

RegisterNetEvent('fishing:setbait')
AddEventHandler('fishing:setbait', function(bool)
    bait = bool
end)

RegisterNetEvent('fishing:fishstart')
AddEventHandler('fishing:fishstart', function()
    playerPed = PlayerPedId()
    local pos = GetEntityCoords(PlayerPedId())
    if IsPedInAnyVehicle(playerPed) then
        ESX.ShowNotification("Vous ne pouvez pas pêcher dans un véhicule.")
    else
        print(GetWaterHeight(pos.x, pos.y, pos.z))
        if GetWaterHeight(pos.x, pos.y, pos.z) then
            if not fishing then
                ESX.ShowNotification("~g~Pêche démarrée")
                TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_FISHING", 0, true)
                fishing = true
            else
                fishing = false
                ClearPedTasks(PlayerPedId())
                ESX.ShowNotification("~r~Pêche arrêtée")
                
            end
        else
            ESX.ShowNotification("Vous devez aller plus loin des côtes.")
        end

    end

end, false)
