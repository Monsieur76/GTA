ESX = nil

Citizen.CreateThread(function()
    while not ESX do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    for _, v in pairs(Config.PumpsModel) do
        ESX.Game.SpawnObject(GetHashKey("prop_gas_pump_1a"), vector3(v.x, v.y, v.z), function(obj)
            SetEntityHeading(obj, v.h)
        end, true)
    end

end)


local PumpQuantities = {}
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 500
local fuelSynced = false
local inBlacklisted = false

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

function ManageFuelUsage(vehicle)
    if not DecorExistOn(vehicle, Config.FuelDecor) then
        SetFuel(vehicle, math.random(200, 800) / 10)
    elseif not fuelSynced then
        SetFuel(vehicle, GetFuel(vehicle))

        fuelSynced = true
    end

    if IsVehicleEngineOn(vehicle) then
        SetFuel(vehicle,
            GetVehicleFuelLevel(vehicle) - Config.FuelUsage[ESX.Math.Round(GetVehicleCurrentRpm(vehicle), 1)] *
                (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
    end
end

Citizen.CreateThread(function()
    DecorRegister(Config.FuelDecor, 1)
    for i = 1, #Config.Blacklist do
        if type(Config.Blacklist[i]) == 'string' then
            Config.Blacklist[GetHashKey(Config.Blacklist[i])] = false
        else
            Config.Blacklist[Config.Blacklist[i]] = false
        end
    end

    for i = #Config.Blacklist, 1, -1 do
        table.remove(Config.Blacklist, i)
    end

    while true do
        Citizen.Wait(1000)

        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)

            if Config.Blacklist[GetEntityModel(vehicle)] then
                inBlacklisted = false
            else
                inBlacklisted = false
            end

            if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
                ManageFuelUsage(vehicle)
            end
        else
            if fuelSynced then
                fuelSynced = false
            end

            if inBlacklisted then
                inBlacklisted = false
            end
        end
    end

end)

AddEventHandler('fuel:startFuelUpTick', function(ped, vehicle, name, amount, jobPump)
    currentFuel = GetVehicleFuelLevel(vehicle)
    local totalfuel = 0
    while isFueling do
        Citizen.Wait(500)

        local fuelToAdd = math.random(10, 20) / 10.0
        local extraCost = math.ceil(fuelToAdd * 3)

        currentFuel = currentFuel + fuelToAdd
        totalfuel = totalfuel + fuelToAdd
        local amountToDisplay = totalfuel
        if totalfuel >= amount or currentFuel >= 100.00 then
            isFueling = false
        end

        SetFuel(vehicle, currentFuel)

        currentCost = currentCost + extraCost

    end
    TriggerServerEvent('fuel:pls', totalfuel, name)
    if not jobPump then
        TriggerServerEvent('fuel:pay', currentCost)
        ESX.ShowNotification("Vous avez mis " .. math.ceil(totalfuel) .. "L pour ~r~" .. math.ceil(currentCost) .. "$")
    else
        ESX.ShowNotification("Vous avez mis " .. math.ceil(totalfuel) .. "L")
    end
    SetVehicleEngineOn(vehicle, true, false, true)

    Citizen.Wait(100)
    currentCost = 0.0
end)

AddEventHandler('fuel:refuelFromPump', function(ped, vehicle, markerjobx, markerjoby, markerjobz, name, amount, jobPump)

    TriggerEvent('fuel:startFuelUpTick', ped, vehicle, name, amount, jobPump)

    while isFueling do
        Citizen.Wait(1)
        ESX.ShowHelpNotification("Plein en cours...")
        local plycrdjob = GetEntityCoords(PlayerPedId(), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, markerjobx, markerjoby, markerjobz)
        local distance = jobdist > 5
        if GetVehicleClass(vehicle) == 15 then
            distance = jobdist > 15
        end
        if distance then
            isFueling = false
            ESX.ShowNotification("Le plein est annulé")
        end
        if IsControlJustReleased(0, 38) then
            isFueling = false
        end
    end

end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job ~= nil then
            local ped = PlayerPedId()
            local vehicle = GetPlayersLastVehicle()
            local plycrdjob = GetEntityCoords(PlayerPedId(), false)
            for k in pairs(Config.AllPumps) do
                local jobPump = not tonumber(Config.AllPumps[k].name)
                if IsPedInAnyVehicle(ped, false) then
                    local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Config.AllPumps[k].x,
                        Config.AllPumps[k].y, Config.AllPumps[k].z)
                    local garageJobName = Config.AllPumps[k].name
                    if string.find(garageJobName, "_heli") or string.find(garageJobName, "_Heli") then
                        garageJobName = string.gsub(garageJobName, "_heli", "")
                        garageJobName = string.gsub(garageJobName, "_Heli", "")
                    end
                    if jobdist < 70 and (not jobPump or (jobPump and ESX.PlayerData.job.name:find(garageJobName))) then
                        DrawMarker(1, Config.AllPumps[k].x, Config.AllPumps[k].y, Config.AllPumps[k].z, 0.0, 0.0, 0.0,
                            0.0, 0.0, 0.0, 3.0, 3.0, 0.50, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
                    end
                    local currentFuel = GetVehicleFuelLevel(vehicle)
                    local distance = jobdist < 5
                    if GetVehicleClass(vehicle) == 15 then
                        distance = jobdist < 15
                    end
                    if distance and currentFuel < 95 and
                        (not jobPump or (jobPump and ESX.PlayerData.job.name:find(garageJobName))) then
                        if not isFueling then
                            ESX.ShowHelpNotification("~INPUT_CONTEXT~ Faire le plein")
                            if IsControlJustReleased(0, 38) then
                                local post, amount = CheckQuantity(
                                    KeyboardInput('Combien de litres ? (' .. math.ceil(100 - currentFuel) ..
                                                      'L pour remplir le réservoir)', '', 8))
                                if post then
                                    if amount ~= nil and amount > 0 and amount <= math.ceil(100 - currentFuel) then
                                        if not jobPump then
                                            ESX.TriggerServerCallback('fuelpayement', function(money)
                                                if money then
                                                    ESX.TriggerServerCallback('fuel:storage', function(litre)
                                                        if litre >= amount then
                                                            isFueling = true
                                                            if GetIsVehicleEngineRunning(vehicle) then
                                                                SetVehicleEngineOn(vehicle, false, false, true)
                                                                TriggerEvent('fuel:refuelFromPump', ped, vehicle,
                                                                    Config.AllPumps[k].x, Config.AllPumps[k].y,
                                                                    Config.AllPumps[k].z, Config.AllPumps[k].name,
                                                                    amount, false)
                                                            end
                                                        else
                                                            ESX.ShowNotification("La station est vide")
                                                        end
                                                    end, Config.AllPumps[k].name)
                                                else
                                                    ESX.ShowNotification(
                                                        "Pas assez d'argent, le minimum est de ~y~" .. amount * 2 ..
                                                            " $")
                                                end
                                            end, amount * 2)
                                        else
                                            ESX.TriggerServerCallback('fuel:storage', function(litre)
                                                if litre >= amount then
                                                    isFueling = true
                                                    if GetIsVehicleEngineRunning(vehicle) then
                                                        SetVehicleEngineOn(vehicle, false, false, true)
                                                        TriggerEvent('fuel:refuelFromPump', ped, vehicle,
                                                            Config.AllPumps[k].x, Config.AllPumps[k].y,
                                                            Config.AllPumps[k].z, Config.AllPumps[k].name, amount, true)
                                                    end
                                                else
                                                    ESX.ShowNotification("La station est vide")
                                                end
                                            end, Config.AllPumps[k].name)
                                        end
                                    else
                                        ESX.ShowNotification("Quantité invalide")
                                    end
                                end
                            end
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
        for k in pairs(Config.AllPumpsView) do
            local ped = PlayerPedId()
            local garageJobName = Config.AllPumpsView[k].name
            local plycrdjob = GetEntityCoords(PlayerPedId(), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Config.AllPumpsView[k].x,
                        Config.AllPumpsView[k].y, Config.AllPumpsView[k].z)
            if jobdist < 40 and ESX.PlayerData.job.name:find(garageJobName)~= nil and not IsPedInAnyVehicle(ped, false) then
                DrawMarker(1, Config.AllPumpsView[k].x, Config.AllPumpsView[k].y, Config.AllPumpsView[k].z, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 1.0, 1.0, 0.50, 25, 95, 255, 255, false, 95, 255, 0, nil, nil, 0)
                if jobdist < 1.5 and (not jobPump or (jobPump and ESX.PlayerData.job.name:find(garageJobName))) then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Voir le niveau de la pompe")
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('fuel:storage', function(litre)
                            ESX.ShowNotification("La station à actuellement "..litre.."L")
                        end,garageJobName)
                    end
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
    for _, info in pairs(Config.AllPumps) do
        if tonumber(info.name) and not info.noblip then
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite(info.blip, 361)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 0.50)
            SetBlipColour(info.blip, 35)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Station Essence")
            EndTextCommandSetBlipName(info.blip)
        end
    end
end)

function GetFuel(vehicle)
    return DecorGetFloat(vehicle, Config.FuelDecor)
end

function SetFuel(vehicle, fuel)
    if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
        SetVehicleFuelLevel(vehicle, fuel + 0.0)
        DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
    end
end

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry("FUEL_TEXT", textEntry)
    DisplayOnscreenKeyboard(1, "FUEL_TEXT", '', inputText, '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function CheckQuantity(number)
    number = tonumber(number)

    if type(number) == 'number' then
        number = ESX.Math.Round(number)

        if number > 0 then
            return true, number
        end
    end

    return false, number
end

exports('SetFuel', SetFuel)
exports('GetFuel', GetFuel)
